import U10.Allocation
import U9.Certificate

namespace U10
open U5

structure Binding where
  address : Path
  output : Path
  source : Path
  deriving Repr

structure Request where
  source : Model
  target : Model
  bindings : List Binding
  deriving Repr

/-- A U3 program in normal form is a tree of source selectors. -/
def HasShape (r : Request) (p : Term Path) : Prop :=
  U9.Admitted r.source p ∧ U9.output r.source p = r.target.source

def Obligations (r : Request) (p : Term Path) : Prop :=
  (∀ e ∈ r.target.edges, Closure r.source.edges (U9.origin p e.left) (U9.origin p e.right)) ∧
  (∀ b ∈ r.bindings, Closure r.source.edges (U9.origin p b.output) b.source)

def Legal (r : Request) (p : Term Path) : Prop := HasShape r p ∧ Obligations r p

/-- Semantic form of the obligations, quantified over every interpretation.
The converse is justified by the same two-element separation as U9. -/
def UniversalObligations (r : Request) (p : Term Path) : Prop :=
  ∀ (α : Type) (i : Interpretation α) x, Gamma r.source i x →
    (∀ e ∈ r.target.edges, x (U9.origin p e.left) = x (U9.origin p e.right)) ∧
    (∀ b ∈ r.bindings, x (U9.origin p b.output) = x b.source)

theorem obligations_iff (r : Request) (p : Term Path) :
    Obligations r p ↔ UniversalObligations r p := by
  constructor
  · intro h α i x hx
    exact ⟨fun e he => closure_sound hx.2 (h.1 e he),
      fun b hb => closure_sound hx.2 (h.2 b hb)⟩
  · intro h
    constructor
    · intro e he
      apply Classical.byContradiction
      intro hn
      exact U8.classBit_distinguishes hn
        ((h Bool bits (U8.classBit r.source (U9.origin p e.left))
          (U8.classBit_gamma r.source _) ).1 e he)
    · intro b hb
      apply Classical.byContradiction
      intro hn
      exact U8.classBit_distinguishes hn
        ((h Bool bits (U8.classBit r.source (U9.origin p b.output))
          (U8.classBit_gamma r.source _) ).2 b hb)

/-- Any admissible structural program collapses each C-class to one E-class;
this is necessary, not an assumption about the preferred constructor. -/
theorem normalize_legal {r : Request} {p : Term Path} (h : Legal r p)
    {u v : Path} (hc : Closure r.target.edges u v) :
    Closure r.source.edges (U9.origin p u) (U9.origin p v) := by
  exact closure_minimal (fun u v => Closure r.source.edges (U9.origin p u) (U9.origin p v))
    (fun _ => .refl _) Closure.symm Closure.trans h.2.1 hc

theorem shape_origin {r : Request} {p : Term Path} (h : HasShape r p)
    {u : Path} {s : SortId} (hu : r.target.source.lookup u = some s) :
    r.source.source.lookup (U9.origin p u) = some s := by
  have hs := congrArg (fun t => t.lookup u) h.2
  simp only [U9.output, Term.lookup_map, hu] at hs
  cases hp : p.lookup u with
  | none => simp [hp] at hs
  | some q =>
    obtain ⟨t, ht⟩ := h.1 q (Term.mem_values_of_lookup hp)
    have he : t = s := by simpa [hp, ht] using hs
    simpa [U9.origin, hp, he] using ht

/-- Availability follows from U3's selector/pair grammar, without search. -/
theorem unavailable_impossible {r : Request} {u : Path} {s : SortId}
    (hu : r.target.source.lookup u = some s)
    (ha : ∀ q, r.source.source.lookup q ≠ some s) : ¬ ∃ p, Legal r p := by
  rintro ⟨p,hp⟩
  exact ha _ (shape_origin hp.1 hu)

theorem wrong_sort_impossible {r : Request} (hm : r.source.valid = true)
    {b : Binding} (hb : b ∈ r.bindings) {s t : SortId}
    (hu : r.target.source.lookup b.output = some s)
    (hv : r.source.source.lookup b.source = some t) (hne : s ≠ t) :
    ¬ ∃ p, Legal r p := by
  rintro ⟨p,hp⟩
  have he := U9.closure_sort hm (hp.2.2 b hb)
  rw [shape_origin hp.1 hu, hv] at he
  exact hne (Option.some.inj he)

/-- Incompatible bindings are separated in a two-element interpretation.
Normalizing a C-class cannot make two independent E-classes equal. -/
theorem incompatible_impossible {r : Request} {a b : Binding}
    (ha : a ∈ r.bindings) (hb : b ∈ r.bindings)
    (hc : Closure r.target.edges a.output b.output)
    (hn : ¬ Closure r.source.edges a.source b.source) : ¬ ∃ p, Legal r p := by
  rintro ⟨p,hp⟩
  exact hn (.trans (.symm (hp.2.2 a ha)) (.trans (normalize_legal hp hc) (hp.2.2 b hb)))

/-- Joint reconstruction uses the actual P(x) and M(x) of the SAME source. -/
def jointView (p : Term Path) : Option (Term Path) → Term Path
  | none => p
  | some d => .pair p d

theorem decoder_sound {r : Request} {p : Term Path} {d : Option (Term Path)} {c : Construction}
    (h : checkConstruction {r.source with observation := jointView p d} c = true)
    (i : Interpretation α) (x : Path → α) (hx : Gamma r.source i x) :
    run c.program ((jointView p d).map x) = some (r.source.question.map x) :=
  construction_interpretation_sound h i x hx

/-- Every adequate residual must contain a required class not held by P. This
uses semantic U5 necessity, so an arbitrary decoder cannot escape the bound. -/
theorem adequate_class_coverage {m : Model} {classes : List PartitionClass}
    {p : Term Path} {d : Option (Term Path)}
    (hp : checkPartition m classes = true)
    (ha : ∃ f : Term Bool → Term Bool, ∀ x, Gamma m bits x →
      f ((jointView p d).map x) = m.question.map x)
    {q : Path} (hq : q ∈ m.question.values) {b : Nat} (hb : blockOf classes q = some b) :
    ∃ a ∈ (jointView p d).values, blockOf classes a = some b := by
  classical
  apply Classical.byContradiction
  intro hn
  obtain ⟨address, haddr⟩ := U6.lookup_of_mem_values hq
  have hnone : ∀ a ∈ (jointView p d).values, blockOf classes a ≠ some b := by
    intro a ham he; exact hn ⟨a,ham,he⟩
  have ho : checkObstruction {m with observation := jointView p d} ⟨address,classes⟩ = true := by
    change checkPartition m classes &&
      (match m.question.lookup address with
      | none => false
      | some q => match blockOf classes q with
        | none => false
        | some k => (jointView p d).values.all (fun a => blockOf classes a != some k)) = true
    simpa [hp, haddr, hb, List.all_eq_true] using hnone
  exact obstruction_no_decoder ho ha
end U10
