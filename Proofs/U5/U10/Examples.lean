import U10.Soundness
import U10.ContractCases

namespace U10.Examples
open U5

def sourcePlaces : Term Path := .pair (.leaf [false]) (.pair (.leaf [true,false]) (.leaf [true,true]))
def outputPlaces : Term Path := .pair (.leaf [false]) (.leaf [true])
def three : Request :=
  ⟨⟨.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0)), sourcePlaces, sourcePlaces, []⟩,
   ⟨.pair (.leaf 0) (.leaf 0), outputPlaces, outputPlaces, [⟨[],[false],[true]⟩]⟩, []⟩
def threePlan : Plan :=
  ⟨[[false]], .pair (.leaf [false]) (.leaf [false]), [],
    [⟨1,[[true,false]]⟩,⟨2,[[true,true]]⟩], [[true,false],[true,true]],
    some (.pair (.leaf [true,false]) (.leaf [true,true])),
    ⟨[⟨[false],[false,false],.address⟩,⟨[true,false],[true,false],.address⟩,
       ⟨[true,true],[true,true],.address⟩],
      .pair (.leaf [false,false]) (.pair (.leaf [true,false]) (.leaf [true,true]))⟩,
    [⟨0,3,1,0,1,2⟩]⟩
def threeCert : Certificate :=
  ⟨[⟨0,[[false]]⟩,⟨0,[[true,false]]⟩,⟨0,[[true,true]]⟩], [[],[],[]],
    [⟨0,[[false],[true]]⟩], [[⟨[],false⟩]], .constructed threePlan⟩

theorem three_is_contract : three = ContractCases.AgreeThree := rfl

theorem three_checked : check three threeCert = true := by decide

/-- Actual ((a,a),(b,c)), not just arithmetic on the number three. The first
half supplies the decoder for every filling, the second excludes every smaller
adequate U3 residual even with a different legal P and arbitrary decoder. -/
theorem two_necessary_sufficient :
    Legal three threePlan.step ∧ residualCount threePlan.residual = 2 ∧
    (∀ (α : Type) (i : Interpretation α) x, Gamma three.source i x →
      run threePlan.decoder.program ((jointView threePlan.step threePlan.residual).map x) =
        some (three.source.question.map x)) ∧
    (∀ alternative d, Legal three alternative →
      (∃ f : Term Bool → Term Bool, ∀ x, Gamma three.source bits x →
        f ((jointView alternative d).map x) = three.source.question.map x) →
      2 ≤ residualCount d) := by
  have h := constructed_sound three_checked (show threeCert.conclusion = .constructed threePlan from rfl)
  exact ⟨h.1,by decide,h.2.2.1,h.2.2.2⟩
end U10.Examples
