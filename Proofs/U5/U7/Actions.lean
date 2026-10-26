import U6.Factor
import U6.Partition

namespace U7
open U5

structure Action where
  member : Path
  image : Term Path
  deriving Repr

/-- Outside source leaves this is an arbitrary total extension. The admitted
source-shaped action never uses that extension at a source leaf. -/
def pull (a : Action) (p : Path) : Path := (a.image.lookup p).getD p
def act (a : Action) (x : Path → α) : Path → α := fun p => x (pull a p)

def checkAction (m : Model) (a : Action) : Bool :=
  a.image.map (fun _ => 0) == m.source.map (fun _ => 0) &&
  m.source.entries.all (fun (p, s) =>
    match a.image.lookup p with
    | some origin => m.source.lookup origin == some s
    | none => false)

theorem action_sort {m : Model} {a : Action} (h : checkAction m a = true)
    {p : Path} {s : SortId} (hs : m.source.lookup p = some s) :
    m.source.lookup (pull a p) = some s := by
  simp only [checkAction, Bool.and_eq_true_iff, List.all_eq_true] at h
  have hi := h.2 (p,s) (Term.mem_entries.mpr hs)
  cases hl : a.image.lookup p with
  | none => simp [hl] at hi
  | some q => simpa [pull, hl] using hi

def Preserves (m : Model) (a : Action) : Prop :=
  ∀ e ∈ m.edges, Closure m.edges (pull a e.left) (pull a e.right)

theorem preserves_closure {m : Model} {a : Action} (h : Preserves m a)
    {p q : Path} (hc : Closure m.edges p q) :
    Closure m.edges (pull a p) (pull a q) := by
  induction hc with
  | refl p => exact .refl _
  | edge he => exact h _ he
  | symm _ ih => exact .symm ih
  | trans _ _ ih₁ ih₂ => exact .trans ih₁ ih₂

/-- Checking the declared generators is equivalent to preserving the entire
generated equivalence; no enumeration of payload interpretations is involved. -/
theorem generators_iff (m : Model) (a : Action) :
    Preserves m a ↔ ∀ p q, Closure m.edges p q →
      Closure m.edges (pull a p) (pull a q) := by
  exact ⟨fun h _ _ hc => preserves_closure h hc, fun h _ he => h _ _ (.edge he)⟩

theorem action_gamma {m : Model} {a : Action} (ha : checkAction m a = true)
    (he : Preserves m a) {i : Interpretation α} {x : Path → α}
    (hx : Gamma m i x) : Gamma m i (act a x) := by
  constructor
  · intro p s hs; exact hx.1 _ _ (action_sort ha hs)
  · intro e hm; exact closure_sound hx.2 (he e hm)

def checkEdges (m : Model) (a : Action) : List Edge → List Basis → Bool
  | [], [] => true
  | e :: es, b :: bs => checkBasis m.edges (pull a e.left) (pull a e.right) b &&
      checkEdges m a es bs
  | _, _ => false

theorem edges_sound {m : Model} {a : Action} {es : List Edge} {bs : List Basis}
    (h : checkEdges m a es bs = true) :
    ∀ e ∈ es, Closure m.edges (pull a e.left) (pull a e.right) := by
  induction es generalizing bs with
  | nil => simp
  | cons e es ih =>
    cases bs with
    | nil => simp [checkEdges] at h
    | cons b bs =>
      have hh := Bool.and_eq_true_iff.mp h
      intro f hf
      rcases List.mem_cons.mp hf with rfl | hf
      · exact basis_sound hh.1
      · exact ih hh.2 f hf

/-- A word is outermost to innermost. Its pullback is left to right. -/
def pullWord (gs : List Action) : List Path → Path → Option Path
  | [], p => some p
  | name :: names, p => do
    let a ← gs.find? (fun a => a.member == name)
    pullWord gs names (pull a p)

theorem word_preserves {m : Model} {gs : List Action}
    (h : ∀ a ∈ gs, Preserves m a) {w : List Path} {p q u v : Path}
    (hp : pullWord gs w p = some u) (hq : pullWord gs w q = some v)
    (hc : Closure m.edges p q) : Closure m.edges u v := by
  induction w generalizing p q with
  | nil => simp [pullWord] at hp hq; subst u; subst v; exact hc
  | cons n ns ih =>
    cases ha : gs.find? (fun a => a.member == n) with
    | none => simp [pullWord, ha] at hp
    | some a =>
      simp [pullWord, ha] at hp hq
      exact ih hp hq (preserves_closure (h a (List.mem_of_find?_eq_some ha)) hc)

end U7
