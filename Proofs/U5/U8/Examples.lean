import U8.Inheritance

namespace U8.Examples
open U5 U7

def whole : Term Path := .pair (.leaf [false]) (.leaf [true])
def model : Model := ⟨.pair (.leaf 0) (.leaf 0), whole, whole, []⟩
def identityAction : Action := ⟨[false], whole⟩
def swap : Action := ⟨[true], .pair (.leaf [true]) (.leaf [false])⟩
def singleton : Interpretation Unit := ⟨fun _ _ => True, fun _ => ⟨(), trivial⟩⟩

/-- Necessity cannot be claimed for a SINGLE special interpretation. -/
theorem singleton_common : CommonAt model [identityAction, swap] whole singleton := by
  refine ⟨id, ?_⟩
  intro x _ a _
  apply Term.map_eq_of_values
  intro p _
  exact Subsingleton.elim _ _

theorem restrictions_disagree : ¬ Agrees model [identityAction, swap] whole := by
  intro h
  have bad := h identityAction (by simp) swap (by simp) [false] (by simp [whole, Term.values])
  change Closure [] [false] [true] at bad
  have heq : [false] = [true] := closure_minimal (fun p q => p = q)
    (fun _ => rfl) Eq.symm Eq.trans (fun _ he => by simp at he) bad
  simp at heq

theorem singleton_does_not_establish_universal : ¬ UniversalCommon model [identityAction, swap] whole := by
  intro h
  exact restrictions_disagree (common_necessary (h Bool bits)).2

theorem empty_family_refused (m : Model) (gs : List Action) (c : U8.Certificate) :
    U8.check m gs [] c = false := by simp [U8.check]

end U8.Examples
