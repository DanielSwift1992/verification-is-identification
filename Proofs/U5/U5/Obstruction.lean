import U5.Construction

namespace U5

structure PartitionClass where
  sort : SortId
  leaves : List Path
  deriving DecidableEq, Repr

structure Obstruction where
  question : Path
  classes : List PartitionClass
  deriving DecidableEq, Repr

/-- The index of a supplied block, not an E-component computed by the checker. -/
def blockOf (classes : List PartitionClass) (p : Path) : Option Nat :=
  classes.findIdx? (fun c => c.leaves.contains p)

def checkPartition (m : Model) (classes : List PartitionClass) : Bool :=
  let paths := classes.flatMap PartitionClass.leaves
  decide paths.Nodup &&
  decide (paths.Perm (m.source.entries.map Prod.fst)) &&
  classes.all (fun c => !c.leaves.isEmpty &&
    c.leaves.all (fun p => m.source.lookup p == some c.sort)) &&
  m.edges.all (fun e => blockOf classes e.left == blockOf classes e.right)

def checkObstruction (m : Model) (o : Obstruction) : Bool :=
  checkPartition m o.classes &&
  match m.question.lookup o.question with
  | none => false
  | some target =>
    match blockOf o.classes target with
    | none => false
    | some block => m.observation.values.all
        (fun p => blockOf o.classes p != some block)

/-- A permitted interpretation, used to refute a UNIVERSAL continuation.
It does not assert failure for every interpretation (singletons are different). -/
def bits : Interpretation Bool := ⟨fun _ _ => True, fun _ => ⟨false, trivial⟩⟩

theorem obstruction_witnesses {m : Model} {o : Obstruction}
    (h : checkObstruction m o = true) :
    ∃ x y : Path → Bool, Gamma m bits x ∧ Gamma m bits y ∧
      m.observation.map x = m.observation.map y ∧
      m.question.map x ≠ m.question.map y := by
  simp only [checkObstruction, Bool.and_eq_true_iff] at h
  obtain ⟨hp, hs⟩ := h
  cases hq : m.question.lookup o.question with
  | none => simp [hq] at hs
  | some target =>
    cases ht : blockOf o.classes target with
    | none => simp [hq, ht] at hs
    | some block =>
      have separated : ∀ p ∈ m.observation.values, blockOf o.classes p ≠ some block := by
        simpa [hq, ht, List.all_eq_true] using hs
      have closed : ∀ e ∈ m.edges, blockOf o.classes e.left = blockOf o.classes e.right := by
        simp only [checkPartition, Bool.and_eq_true_iff, List.all_eq_true, beq_iff_eq] at hp
        exact hp.2
      let x : Path → Bool := fun _ => false
      let y : Path → Bool := fun p => decide (blockOf o.classes p = some block)
      refine ⟨x, y, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_, ?_⟩
      · intro p s _; trivial
      · intro e _; rfl
      · intro p s _; trivial
      · intro e he; simp only [y, closed e he]
      · apply Term.map_eq_of_values
        intro p hmem
        simp [x, y, separated p hmem]
      · intro heq
        have bad := congrArg (fun t => t.lookup o.question) heq
        simp [hq, x, y, ht] at bad

/-- Even an arbitrary decoder on the Boolean interpretation is impossible. -/
theorem obstruction_no_decoder {m : Model} {o : Obstruction}
    (h : checkObstruction m o = true) :
    ¬ ∃ f : Term Bool → Term Bool, ∀ x, Gamma m bits x →
      f (m.observation.map x) = m.question.map x := by
  obtain ⟨x, y, hx, hy, hp, hq⟩ := obstruction_witnesses h
  rintro ⟨f, hf⟩
  exact hq ((hf x hx).symm.trans ((congrArg f hp).trans (hf y hy)))

/-- The same finite U3 program must work for every interpretation/filling. -/
def UniversalContinuation (m : Model) : Prop :=
  ∃ program : Term Path, ∀ (α : Type) (i : Interpretation α) (x : Path → α),
    Gamma m i x → run program (m.observation.map x) = some (m.question.map x)

theorem obstruction_not_universal {m : Model} {o : Obstruction}
    (h : checkObstruction m o = true) : ¬ UniversalContinuation m := by
  obtain ⟨x, y, hx, hy, hp, hq⟩ := obstruction_witnesses h
  rintro ⟨p, hpall⟩
  have hx' := hpall Bool bits x hx
  have hy' := hpall Bool bits y hy
  rw [hp, hy'] at hx'
  exact hq (Option.some.inj hx').symm

inductive Certificate where
  | constructed : Construction → Certificate
  | obstructed : Obstruction → Certificate
  deriving DecidableEq, Repr

/-- Only U5's core conclusion. Extensions are not silently accepted here. -/
def check (m : Model) (c : Certificate) : Bool :=
  m.valid && match c with
  | .constructed p => checkConstruction m p
  | .obstructed o => checkObstruction m o

/-- The negative claim is the negation of UNIVERSAL solvability, not a
pointwise negation of solvability in the particular interpretation i. -/
def Claim (m : Model) (c : Certificate) (_i : Interpretation α) (x : Path → α) : Prop :=
  match c with
  | .constructed p => run p.program (m.observation.map x) = some (m.question.map x)
  | .obstructed _ => ¬ UniversalContinuation m

/-- Soundness of the executable finite checker, across opaque interpretations. -/
theorem check_sound {m : Model} {c : Certificate} (h : check m c = true) :
    ∀ (α : Type) (i : Interpretation α) (x : Path → α),
      Gamma m i x → Claim m c i x := by
  intro α i x hx
  cases c with
  | constructed p =>
    have hp : checkConstruction m p = true := (Bool.and_eq_true_iff.mp h).2
    exact construction_interpretation_sound hp i x hx
  | obstructed o =>
    have ho : checkObstruction m o = true := (Bool.and_eq_true_iff.mp h).2
    exact obstruction_not_universal ho

/-- Acceptance cannot hide an empty compatible class. -/
theorem accepted_nonempty {m : Model} {c : Certificate} (h : check m c = true)
    (i : Interpretation α) : ∃ x, Gamma m i x :=
  compatible_nonempty m (Bool.and_eq_true_iff.mp h).1 i

/-- The two accepted conclusions cannot coexist for the same fixed model. -/
theorem conclusions_disjoint {m : Model} {c : Construction} {o : Obstruction}
    (hc : checkConstruction m c = true) (ho : checkObstruction m o = true) : False := by
  apply obstruction_not_universal ho
  refine ⟨c.program, ?_⟩
  intro α i x hx
  exact construction_interpretation_sound hc i x hx

end U5
