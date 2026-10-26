import U8.Separation

namespace U9
open U5

/-- A structural cut, with output occurrences distinct from source occurrences. -/
def origin (p : Term Path) (u : Path) : Path := (p.lookup u).getD []
def output (m : Model) (p : Term Path) : Term SortId :=
  p.map (fun q => (m.source.lookup q).getD 0)
def Admitted (m : Model) (p : Term Path) : Prop :=
  ∀ q ∈ p.values, ∃ s, m.source.lookup q = some s

def OutputTyped (m : Model) (p : Term Path) (i : Interpretation α) (y : Path → α) : Prop :=
  ∀ u q, p.lookup u = some q → i.carrier ((m.source.lookup q).getD 0) (y u)

/-- E_P is induced on output addresses, not on source addresses. -/
def Induced (m : Model) (p : Term Path) (u v : Path) : Prop :=
  Closure m.edges (origin p u) (origin p v)
def ImageCompatible (m : Model) (p : Term Path) (y : Path → α) : Prop :=
  ∀ u q v r, p.lookup u = some q → p.lookup v = some r →
    Closure m.edges q r → y u = y v

def IsImage (m : Model) (p : Term Path) (i : Interpretation α) (y : Path → α) : Prop :=
  ∃ x, Gamma m i x ∧ ∀ u q, p.lookup u = some q → x q = y u

theorem closure_sort {m : Model} (hm : m.valid = true) {p q : Path}
    (h : Closure m.edges p q) : m.source.lookup p = m.source.lookup q := by
  apply closure_minimal (fun p q => m.source.lookup p = m.source.lookup q)
    (fun _ => rfl) Eq.symm Eq.trans ?_ h
  intro e he
  simp only [Model.valid, Bool.and_eq_true_iff, List.all_eq_true, beq_iff_eq,
    decide_eq_true_eq] at hm
  exact (hm.1.2 e he).2

theorem image_forward {m : Model} {p : Term Path} {i : Interpretation α} {y : Path → α}
    (ha : Admitted m p) (h : IsImage m p i y) :
    OutputTyped m p i y ∧ ImageCompatible m p y := by
  obtain ⟨x, hx, hy⟩ := h
  constructor
  · intro u q hq
    obtain ⟨s, hs⟩ := ha q (Term.mem_values_of_lookup hq)
    simpa [hs, hy u q hq] using hx.1 q s hs
  · intro u q v r hq hr he
    rw [← hy u q hq, ← hy v r hr]
    exact closure_sound hx.2 he

/-- Existential completion uses nonempty sorts. It is not a U3 inverse program
and does not acquire an omitted unknown source occurrence. -/
theorem image_reverse {m : Model} {p : Term Path} (hm : m.valid = true)
    {i : Interpretation α} {y : Path → α}
    (ht : OutputTyped m p i y) (hc : ImageCompatible m p y) : IsImage m p i y := by
  classical
  let represented := fun q => ∃ u r, p.lookup u = some r ∧ Closure m.edges q r
  let choose := fun q (h : represented q) => Classical.choose h
  let fill := fun s => Classical.choose (i.inhabited s)
  let x := fun q => if h : represented q then y (choose q h)
    else fill ((m.source.lookup q).getD 0)
  have chosen : ∀ q (h : represented q), ∃ r,
      p.lookup (choose q h) = some r ∧ Closure m.edges q r := by
    intro q h; exact Classical.choose_spec h
  have respects : ∀ q r, Closure m.edges q r → x q = x r := by
    intro q r he
    have hi : represented q ↔ represented r := by
      constructor
      · rintro ⟨u, a, hu, hr⟩; exact ⟨u, a, hu, .trans (.symm he) hr⟩
      · rintro ⟨u, a, hu, hr⟩; exact ⟨u, a, hu, .trans he hr⟩
    by_cases hq : represented q
    · have hr := hi.mp hq
      obtain ⟨a, ha, hqa⟩ := chosen q hq
      obtain ⟨b, hb, hrb⟩ := chosen r hr
      simp only [x, dite_eq_left hq, dite_eq_left hr]
      exact hc _ a _ b ha hb (.trans (.symm hqa) (.trans he hrb))
    · have hr : ¬ represented r := fun h => hq (hi.mpr h)
      simp only [x, dite_eq_right hq, dite_eq_right hr, closure_sort hm he]
  refine ⟨x, ⟨?_, fun e he => respects _ _ (.edge he)⟩, ?_⟩
  · intro q s hs
    by_cases hq : represented q
    · obtain ⟨r, hr, hqr⟩ := chosen q hq
      have hsort := closure_sort hm hqr
      have hy := ht _ r hr
      simpa [x, hq, ← hsort, hs] using hy
    · simpa [x, hq, hs, fill] using Classical.choose_spec (i.inhabited s)
  · intro u q hu
    have hq : represented q := ⟨u, q, hu, .refl _⟩
    obtain ⟨r, hr, hqr⟩ := chosen q hq
    simp only [x, dite_eq_left hq]
    exact hc _ r u q hr hu (.symm hqr)

/-- P(X_E) = X_(E_P), for every interpretation by nonempty sorts. -/
theorem exact_image {m : Model} {p : Term Path} (hm : m.valid = true)
    (ha : Admitted m p) (i : Interpretation α) (y : Path → α) :
    IsImage m p i y ↔ OutputTyped m p i y ∧ ImageCompatible m p y :=
  ⟨image_forward ha, fun h => image_reverse hm h.1 h.2⟩

def PromiseHolds (m : Model) (p : Term Path) (cs : List Edge) : Prop :=
  ∀ (α : Type) (i : Interpretation α) x, Gamma m i x →
    ∀ e ∈ cs, x (origin p e.left) = x (origin p e.right)

/-- Necessity uses a two-element interpretation of each sort, not sampled values. -/
theorem promise_iff (m : Model) (p : Term Path) (cs : List Edge) :
    PromiseHolds m p cs ↔ ∀ e ∈ cs, Induced m p e.left e.right := by
  constructor
  · intro h e he
    apply Classical.byContradiction
    intro hn
    exact U8.classBit_distinguishes hn
      (h Bool bits (U8.classBit m (origin p e.left))
        (U8.classBit_gamma m _) e he)
  · intro h α i x hx e he
    exact closure_sound hx.2 (h e he)

theorem promise_counterexample {m : Model} {p : Term Path} {cs : List Edge}
    {e : Edge} (_he : e ∈ cs) (hn : ¬ Induced m p e.left e.right) :
    ∃ x : Path → Bool, Gamma m bits x ∧
      x (origin p e.left) ≠ x (origin p e.right) :=
  ⟨U8.classBit m (origin p e.left), U8.classBit_gamma m _, U8.classBit_distinguishes hn⟩

/-- The hidden choice has the full product domain H × X_E. -/
theorem hidden_promise_iff (m : Model) (hs : List (Term Path)) (cs : List Edge) :
    (∀ p ∈ hs, PromiseHolds m p cs) ↔
      ∀ p ∈ hs, ∀ e ∈ cs, Induced m p e.left e.right := by
  constructor
  · intro h p hp; exact (promise_iff m p cs).mp (h p hp)
  · intro h p hp; exact (promise_iff m p cs).mpr (h p hp)
end U9
