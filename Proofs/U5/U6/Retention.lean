import U6.Residue

namespace U6
open U5

structure Retention where
  leaves : List Path
  view : Term Path
  decoder : Construction
  deriving DecidableEq, Repr

structure Plan where
  obstruction : Obstruction
  residue : Residue
  retention : Retention
  deriving DecidableEq, Repr

/-- The contract's unique balanced, ordered nonempty product shape. -/
def balanced : Term α → Bool
  | .leaf _ => true
  | .pair l r =>
    l.values.length == (l.values.length + r.values.length) / 2 && balanced l && balanced r

def checkRetention (m : Model) (classes : List PartitionClass) (r : Retention) : Bool :=
  decide ((r.leaves.map (blockOf classes)).Perm ((neededBlocks m classes).map some)) &&
  r.view.values == r.leaves && balanced r.view

def joint (m : Model) (view : Term Path) : Model :=
  { m with observation := .pair m.observation view }

def checkPlan (m : Model) (p : Plan) : Bool :=
  U5.check m (.obstructed p.obstruction) &&
  checkResidue m p.obstruction.classes p.residue &&
  checkRetention m p.obstruction.classes p.retention &&
  U5.check (joint m p.retention.view) (.constructed p.retention.decoder)

/-- The zero case carries no invented Unit/Null/opaque leaf. -/
inductive Certificate where
  | zero : Construction → Certificate
  | retained : Plan → Certificate
  deriving DecidableEq, Repr

def check (m : Model) : Certificate → Bool
  | .zero c => U5.check m (.constructed c)
  | .retained p => checkPlan m p

def observation (m : Model) : Certificate → Term Path
  | .zero _ => m.observation
  | .retained p => .pair m.observation p.retention.view

def program : Certificate → Term Path
  | .zero c => c.program
  | .retained p => p.retention.decoder.program

def leafCount : Certificate → Nat
  | .zero _ => 0
  | .retained p => p.retention.view.values.length

/-- Soundness of the retained view and decoder on the SAME source filling. -/
theorem check_sound {m : Model} {c : Certificate} (h : check m c = true) :
    ∀ (α : Type) (i : Interpretation α) (x : Path → α), Gamma m i x →
      run (program c) ((observation m c).map x) = some (m.question.map x) := by
  intro α i x hx
  cases c with
  | zero construction => exact U5.check_sound (m := m) (c := .constructed construction) h α i x hx
  | retained p =>
    simp only [check, checkPlan, Bool.and_eq_true_iff] at h
    exact U5.check_sound h.2 α i x hx

theorem accepted_nonempty {m : Model} {c : Certificate} (h : check m c = true)
    (i : Interpretation α) : ∃ x, Gamma m i x := by
  cases c with
  | zero construction => exact U5.accepted_nonempty (m := m) (c := .constructed construction) h i
  | retained p =>
    simp only [check, checkPlan, Bool.and_eq_true_iff] at h
    exact U5.accepted_nonempty h.1.1.1 i

/-- One retained leaf per enumerated missing E-class, permutations allowed. -/
theorem leaf_count_exact {m : Model} {p : Plan} (h : checkPlan m p = true) :
    p.retention.view.values.length = (neededBlocks m p.obstruction.classes).length := by
  simp only [checkPlan, Bool.and_eq_true_iff] at h
  have hr := h.1.2
  simp only [checkRetention, Bool.and_eq_true_iff, decide_eq_true_eq, beq_iff_eq] at hr
  have he := hr.1.1.length_eq
  simpa [hr.1.2] using he

/-- Every retained place belongs to a Question class, even if its particular
source occurrence is outside both original views. -/
theorem retained_covered_by_question {m : Model} {p : Plan} (h : checkPlan m p = true) :
    Covers m m.question p.retention.view := by
  simp only [checkPlan, Bool.and_eq_true_iff] at h
  have hr := h.1.2
  simp only [checkRetention, Bool.and_eq_true_iff, decide_eq_true_eq, beq_iff_eq] at hr
  have hs := h.1.1.2
  simp only [checkResidue, Bool.and_eq_true_iff] at hs
  intro a ha
  have ha' : a ∈ p.retention.leaves := hr.1.2 ▸ ha
  have hm := hr.1.1.mem_iff.mp (List.mem_map.mpr ⟨a, ha', rfl⟩)
  obtain ⟨b, hb, hba⟩ := List.mem_map.mp hm
  obtain ⟨⟨q, hq, hqb⟩, _⟩ := needed_spec.mp hb
  obtain ⟨addr, had⟩ := lookup_of_mem_values hq
  exact ⟨addr, q, had, same_block_closure hs.1.1.2 hqb hba.symm⟩

/-- The relative information order fixes P and the interpretation. D may be
arbitrary and deterministic; only the reached joint image matters. -/
def RelativeLE (m : Model) (i : Interpretation α) (retained : Term Path)
    (d : (Path → α) → β) : Prop :=
  ∃ f : Term α → β → Term α, ∀ x, Gamma m i x →
    retained.map x = f (m.observation.map x) (d x)

/-- U6's leastness in ≼_P, including nonstructural D on a fixed interpretation.
No absolute least standalone residual (e.g. against XOR) is asserted. -/
theorem relative_least {m : Model} {p : Plan} (h : checkPlan m p = true)
    (i : Interpretation α) (d : (Path → α) → β)
    (decoder : Term α → β → Term α)
    (adequate : ∀ x, Gamma m i x → decoder (m.observation.map x) (d x) = m.question.map x) :
    RelativeLE m i p.retention.view d := by
  obtain ⟨f, hf⟩ := covers_factor (retained_covered_by_question h)
  classical
  let fallback : Term α := .leaf (Classical.choose (i.inhabited 0))
  refine ⟨fun obs value => (run f (decoder obs value)).getD fallback, ?_⟩
  intro x hx
  simp [adequate x hx, hf α i x hx]

def retainedValue (c : Certificate) (x : Path → α) : Option (Term α) :=
  match c with
  | .zero _ => none
  | .retained p => some (p.retention.view.map x)

/-- The same relative-order statement including absence of a residual carrier. -/
theorem relative_least_all {m : Model} {c : Certificate} (h : check m c = true)
    (i : Interpretation α) (d : (Path → α) → β)
    (decoder : Term α → β → Term α)
    (adequate : ∀ x, Gamma m i x → decoder (m.observation.map x) (d x) = m.question.map x) :
    ∃ f : Term α → β → Option (Term α), ∀ x, Gamma m i x →
      retainedValue c x = f (m.observation.map x) (d x) := by
  cases c with
  | zero construction => exact ⟨fun _ _ => none, fun _ _ => rfl⟩
  | retained p =>
    obtain ⟨f, hf⟩ := relative_least h i d decoder adequate
    exact ⟨fun obs value => some (f obs value), fun x hx => congrArg some (hf x hx)⟩

end U6
