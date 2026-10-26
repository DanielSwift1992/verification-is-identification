import U10.Completeness
import U10.Examples

namespace U10.Examples
open U5

/-- Admission is checked from the request alone, without threePlan/three_checked. -/
theorem three_admissible : Admissible three := by
  refine ⟨by decide, by decide, by decide, ?_, ?_, ?_⟩
  · intro u s hu
    have hs := Term.mem_values_of_lookup hu
    have he : s = 0 := by simpa [three,Term.values] using hs
    subst s
    exact ⟨[false],rfl⟩
  · simp [three]
  · simp [three]

/-- AgreeThree is now an instance of general existence/minimality, rather
than an independently supplied successful Plan. Class forests only present E/C. -/
theorem agree_three_general :
    ∃ p d decoder,
      Legal ContractCases.AgreeThree p ∧
      (∀ t, d = some t → U9.Admitted ContractCases.AgreeThree.source t) ∧
      (∀ (α : Type) (i : Interpretation α) x, Gamma ContractCases.AgreeThree.source i x →
        run decoder ((jointView p d).map x) = some (ContractCases.AgreeThree.source.question.map x)) ∧
      residualCount d = 2 ∧
      ∀ alternative other, Legal ContractCases.AgreeThree alternative →
        (∃ f : Term Bool → Term Bool, ∀ x, Gamma ContractCases.AgreeThree.source bits x →
          f ((jointView alternative other).map x) = ContractCases.AgreeThree.source.question.map x) →
        residualCount d ≤ residualCount other := by
  have h := optimal_plan_minimal three_admissible
    (sc := threeCert.classes) (oc := threeCert.outputClasses)
    (sf := threeCert.connections) (of := threeCert.outputConnections)
    (by decide) (by decide) (by decide) (by decide)
  have hn : lower three threeCert.classes threeCert.outputClasses = 2 := by decide
  rw [hn,three_is_contract] at h
  exact h

end U10.Examples
