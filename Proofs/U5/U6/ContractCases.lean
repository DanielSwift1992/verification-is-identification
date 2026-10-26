-- Generated finite observations; not a proved bridge.
import U6.Minimality

namespace U6.ContractCases
open U5

def RetainOneClass : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [true]), []⟩
def RetainOneClassCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClass_observed : U6.check RetainOneClass RetainOneClassCert = true := by decide
theorem RetainOneClass_leaves : leafCount RetainOneClassCert = 1 := by decide

def RetainOneClassMissingLeafCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[], (.leaf [true]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassMissingLeaf_observed : U6.check RetainOneClass RetainOneClassMissingLeafCert = false := by decide

def RetainOneClassExtraLeafCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[[true], [true]], (.leaf [true]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassExtraLeaf_observed : U6.check RetainOneClass RetainOneClassExtraLeafCert = false := by decide

def RetainOneClassObservedLeafCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[[false]], (.leaf [false]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassObservedLeaf_observed : U6.check RetainOneClass RetainOneClassObservedLeafCert = false := by decide

def RetainOneClassWrongViewCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[[true]], (.leaf [false]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassWrongView_observed : U6.check RetainOneClass RetainOneClassWrongViewCert = false := by decide

def RetainOneClassWrongProgramCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[], [true], .address⟩], (.leaf [false])⟩⟩⟩)
theorem RetainOneClassWrongProgram_observed : U6.check RetainOneClass RetainOneClassWrongProgramCert = false := by decide

def RetainOneClassBadInputCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[], [false, false], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassBadInput_observed : U6.check RetainOneClass RetainOneClassBadInputCert = false := by decide

def RetainOneClassBadOutputCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[false], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassBadOutput_observed : U6.check RetainOneClass RetainOneClassBadOutputCert = false := by decide

def RetainOneClassObservedValuesCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[], [true], .observedValues⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassObservedValues_observed : U6.check RetainOneClass RetainOneClassObservedValuesCert = false := by decide

def RetainOneClassMissingSelectionCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassMissingSelection_observed : U6.check RetainOneClass RetainOneClassMissingSelectionCert = false := by decide

def RetainOneClassNoForestRowsCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[], [⟨1, [[]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassNoForestRows_observed : U6.check RetainOneClass RetainOneClassNoForestRowsCert = false := by decide

def RetainOneClassMissingNeededCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], []⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassMissingNeeded_observed : U6.check RetainOneClass RetainOneClassMissingNeededCert = false := by decide

def RetainOneClassDuplicateNeededCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[]]⟩, ⟨1, [[]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassDuplicateNeeded_observed : U6.check RetainOneClass RetainOneClassDuplicateNeededCert = false := by decide

def RetainOneClassObservedNeededCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨0, [[]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassObservedNeeded_observed : U6.check RetainOneClass RetainOneClassObservedNeededCert = false := by decide

def RetainOneClassWrongQuestionPathCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[true]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainOneClassWrongQuestionPath_observed : U6.check RetainOneClass RetainOneClassWrongQuestionPathCert = false := by decide

def RetainTwoSorts : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 1) (.leaf 2))), (.leaf [false]), (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true]))), []⟩
def RetainTwoSortsCert : U6.Certificate := (.retained ⟨⟨[true, false], [⟨0, [[false]]⟩, ⟨1, [[true, false]]⟩, ⟨2, [[true, true]]⟩]⟩, ⟨[[], [], []], [⟨1, [[true, false]]⟩, ⟨2, [[true, true]]⟩]⟩, ⟨[[true, false], [true, true]], (.pair (.leaf [true, false]) (.leaf [true, true])), ⟨[⟨[false], [false], .address⟩, ⟨[true, false], [true, false], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩⟩⟩)
theorem RetainTwoSorts_observed : U6.check RetainTwoSorts RetainTwoSortsCert = true := by decide
theorem RetainTwoSorts_leaves : leafCount RetainTwoSortsCert = 2 := by decide

def RetainTwoSortsPermutedNeededCert : U6.Certificate := (.retained ⟨⟨[true, false], [⟨0, [[false]]⟩, ⟨1, [[true, false]]⟩, ⟨2, [[true, true]]⟩]⟩, ⟨[[], [], []], [⟨2, [[true, true]]⟩, ⟨1, [[true, false]]⟩]⟩, ⟨[[true, false], [true, true]], (.pair (.leaf [true, false]) (.leaf [true, true])), ⟨[⟨[false], [false], .address⟩, ⟨[true, false], [true, false], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩⟩⟩)
theorem RetainTwoSortsPermutedNeeded_observed : U6.check RetainTwoSorts RetainTwoSortsPermutedNeededCert = false := by decide

def RetainTwoSortsDuplicateClassCert : U6.Certificate := (.retained ⟨⟨[true, false], [⟨0, [[false]]⟩, ⟨1, [[true, false]]⟩, ⟨2, [[true, true]]⟩]⟩, ⟨[[], [], []], [⟨1, [[true, false]]⟩, ⟨2, [[true, true]]⟩]⟩, ⟨[[true, false], [true, false]], (.pair (.leaf [true, false]) (.leaf [true, true])), ⟨[⟨[false], [false], .address⟩, ⟨[true, false], [true, false], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩⟩⟩)
theorem RetainTwoSortsDuplicateClass_observed : U6.check RetainTwoSorts RetainTwoSortsDuplicateClassCert = false := by decide

def RetainTwoSortsPermutedRetentionCert : U6.Certificate := (.retained ⟨⟨[true, false], [⟨0, [[false]]⟩, ⟨1, [[true, false]]⟩, ⟨2, [[true, true]]⟩]⟩, ⟨[[], [], []], [⟨1, [[true, false]]⟩, ⟨2, [[true, true]]⟩]⟩, ⟨[[true, true], [true, false]], (.pair (.leaf [true, true]) (.leaf [true, false])), ⟨[⟨[false], [false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [true, false], .address⟩], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩⟩⟩)
theorem RetainTwoSortsPermutedRetention_observed : U6.check RetainTwoSorts RetainTwoSortsPermutedRetentionCert = true := by decide
theorem RetainTwoSortsPermutedRetention_leaves : leafCount RetainTwoSortsPermutedRetentionCert = 2 := by decide

def RetainTwoSortsPermutationWithoutDecoderCert : U6.Certificate := (.retained ⟨⟨[true, false], [⟨0, [[false]]⟩, ⟨1, [[true, false]]⟩, ⟨2, [[true, true]]⟩]⟩, ⟨[[], [], []], [⟨1, [[true, false]]⟩, ⟨2, [[true, true]]⟩]⟩, ⟨[[true, true], [true, false]], (.pair (.leaf [true, true]) (.leaf [true, false])), ⟨[⟨[false], [false], .address⟩, ⟨[true, false], [true, false], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩⟩⟩)
theorem RetainTwoSortsPermutationWithoutDecoder_observed : U6.check RetainTwoSorts RetainTwoSortsPermutationWithoutDecoderCert = false := by decide

def RetainRepeatedClass : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.pair (.leaf [true]) (.leaf [true])), []⟩
def RetainRepeatedClassCert : U6.Certificate := (.retained ⟨⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[false], [true]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[false], [true], .address⟩, ⟨[true], [true], .address⟩], (.pair (.leaf [true]) (.leaf [true]))⟩⟩⟩)
theorem RetainRepeatedClass_observed : U6.check RetainRepeatedClass RetainRepeatedClassCert = true := by decide
theorem RetainRepeatedClass_leaves : leafCount RetainRepeatedClassCert = 1 := by decide

def RetainRepeatedClassLostRepeatedQuestionCert : U6.Certificate := (.retained ⟨⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[false]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[false], [true], .address⟩, ⟨[true], [true], .address⟩], (.pair (.leaf [true]) (.leaf [true]))⟩⟩⟩)
theorem RetainRepeatedClassLostRepeatedQuestion_observed : U6.check RetainRepeatedClass RetainRepeatedClassLostRepeatedQuestionCert = false := by decide

def RetainRepeatedClassPermutedQuestionPathsCert : U6.Certificate := (.retained ⟨⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩, ⟨[[], []], [⟨1, [[true], [false]]⟩]⟩, ⟨[[true]], (.leaf [true]), ⟨[⟨[false], [true], .address⟩, ⟨[true], [true], .address⟩], (.pair (.leaf [true]) (.leaf [true]))⟩⟩⟩)
theorem RetainRepeatedClassPermutedQuestionPaths_observed : U6.check RetainRepeatedClass RetainRepeatedClassPermutedQuestionPathsCert = false := by decide

def RetainFromClassOutsideViews : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [true, true]), (.leaf [true, false]), [⟨[], [false], [true, false]⟩]⟩
def RetainFromClassOutsideViewsCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩]⟩, ⟨[[⟨[], false⟩], []], [⟨0, [[]]⟩]⟩, ⟨[[false]], (.leaf [false]), ⟨[⟨[], [true], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [true])⟩⟩⟩)
theorem RetainFromClassOutsideViews_observed : U6.check RetainFromClassOutsideViews RetainFromClassOutsideViewsCert = true := by decide
theorem RetainFromClassOutsideViews_leaves : leafCount RetainFromClassOutsideViewsCert = 1 := by decide

def RetainFromClassOutsideViewsMissingForestEdgeCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩]⟩, ⟨[[], []], [⟨0, [[]]⟩]⟩, ⟨[[false]], (.leaf [false]), ⟨[⟨[], [true], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [true])⟩⟩⟩)
theorem RetainFromClassOutsideViewsMissingForestEdge_observed : U6.check RetainFromClassOutsideViews RetainFromClassOutsideViewsMissingForestEdgeCert = false := by decide

def RetainFromClassOutsideViewsReversedForestEdgeCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩]⟩, ⟨[[⟨[], true⟩], []], [⟨0, [[]]⟩]⟩, ⟨[[false]], (.leaf [false]), ⟨[⟨[], [true], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [true])⟩⟩⟩)
theorem RetainFromClassOutsideViewsReversedForestEdge_observed : U6.check RetainFromClassOutsideViews RetainFromClassOutsideViewsReversedForestEdgeCert = false := by decide

def RetainFromClassOutsideViewsUnknownForestEdgeCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩]⟩, ⟨[[⟨[true], false⟩], []], [⟨0, [[]]⟩]⟩, ⟨[[false]], (.leaf [false]), ⟨[⟨[], [true], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [true])⟩⟩⟩)
theorem RetainFromClassOutsideViewsUnknownForestEdge_observed : U6.check RetainFromClassOutsideViews RetainFromClassOutsideViewsUnknownForestEdgeCert = false := by decide

def RetainFromClassOutsideViewsNoEqualityGroundCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩]⟩, ⟨[[⟨[], false⟩], []], [⟨0, [[]]⟩]⟩, ⟨[[false]], (.leaf [false]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainFromClassOutsideViewsNoEqualityGround_observed : U6.check RetainFromClassOutsideViews RetainFromClassOutsideViewsNoEqualityGroundCert = false := by decide

def RetainFromClassOutsideViewsOtherRepresentativeCert : U6.Certificate := (.retained ⟨⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩]⟩, ⟨[[⟨[], false⟩], []], [⟨0, [[]]⟩]⟩, ⟨[[true, false]], (.leaf [true, false]), ⟨[⟨[], [true], .address⟩], (.leaf [true])⟩⟩⟩)
theorem RetainFromClassOutsideViewsOtherRepresentative_observed : U6.check RetainFromClassOutsideViews RetainFromClassOutsideViewsOtherRepresentativeCert = true := by decide
theorem RetainFromClassOutsideViewsOtherRepresentative_leaves : leafCount RetainFromClassOutsideViewsOtherRepresentativeCert = 1 := by decide

def RetainNothing : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [true]), [⟨[], [false], [true]⟩]⟩
def RetainNothingCert : U6.Certificate := (.zero ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩)
theorem RetainNothing_observed : U6.check RetainNothing RetainNothingCert = true := by decide
theorem RetainNothing_leaves : leafCount RetainNothingCert = 0 := by decide

def RetainNothingBadBasisCert : U6.Certificate := (.zero ⟨[⟨[], [], .observedValues⟩], (.leaf [])⟩)
theorem RetainNothingBadBasis_observed : U6.check RetainNothing RetainNothingBadBasisCert = false := by decide

def MultiClassResidue : Model := ⟨(.pair (.pair (.leaf 0) (.leaf 0)) (.pair (.leaf 0) (.leaf 0))), (.leaf [false, false]), (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [false, false], [false, true]⟩]⟩
def MultiClassResidueCert : U6.Certificate := (.retained ⟨⟨[false], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩]⟩, ⟨[[⟨[], false⟩], [], []], [⟨1, [[false], [true, true]]⟩, ⟨2, [[true, false]]⟩]⟩, ⟨[[true, false], [true, true]], (.pair (.leaf [true, false]) (.leaf [true, true])), ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [true, false], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩⟩⟩)
theorem MultiClassResidue_observed : U6.check MultiClassResidue MultiClassResidueCert = true := by decide
theorem MultiClassResidue_leaves : leafCount MultiClassResidueCert = 2 := by decide

def MultiClassResidueCoarseWithoutForestCert : U6.Certificate := (.retained ⟨⟨[false], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩]⟩, ⟨[[⟨[], false⟩], []], [⟨1, [[false], [true, true], [true, false]]⟩]⟩, ⟨[[true, false], [true, true]], (.pair (.leaf [true, false]) (.leaf [true, true])), ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [true, false], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩⟩⟩)
theorem MultiClassResidueCoarseWithoutForest_observed : U6.check MultiClassResidue MultiClassResidueCoarseWithoutForestCert = false := by decide

end U6.ContractCases
