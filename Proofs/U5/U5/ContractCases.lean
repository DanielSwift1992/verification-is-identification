-- Generated observations by Tools/FixtureProbe.swift; bridge is not a proved reader.
import U5.Obstruction

namespace U5.ContractCases

def AddressIdentity : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [false]), []⟩
def AddressIdentityCert : Certificate := (.constructed ⟨[⟨[], [], .address⟩], (.leaf [])⟩)
theorem AddressIdentity_observed : check AddressIdentity AddressIdentityCert = true := by decide

def OneEquality : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [true]), [⟨[], [false], [true]⟩]⟩
def OneEqualityCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩)
theorem OneEquality_observed : check OneEquality OneEqualityCert = true := by decide

def OneEqualityBadOutputCert : Certificate := (.constructed ⟨[⟨[false], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩)
theorem OneEqualityBadOutput_observed : check OneEquality OneEqualityBadOutputCert = false := by decide

def OneEqualityBadInputCert : Certificate := (.constructed ⟨[⟨[], [true], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩)
theorem OneEqualityBadInput_observed : check OneEquality OneEqualityBadInputCert = false := by decide

def OneEqualityValuesGroundCert : Certificate := (.constructed ⟨[⟨[], [], .observedValues⟩], (.leaf [])⟩)
theorem OneEqualityValuesGround_observed : check OneEquality OneEqualityValuesGroundCert = false := by decide

def OneEqualityFalseAddressCert : Certificate := (.constructed ⟨[⟨[], [], .address⟩], (.leaf [])⟩)
theorem OneEqualityFalseAddress_observed : check OneEquality OneEqualityFalseAddressCert = false := by decide

def OneEqualityEmptyPathCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [])⟩], (.leaf [])⟩)
theorem OneEqualityEmptyPath_observed : check OneEquality OneEqualityEmptyPathCert = false := by decide

def OneEqualityAbsentEdgeCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [⟨[true], false⟩])⟩], (.leaf [])⟩)
theorem OneEqualityAbsentEdge_observed : check OneEquality OneEqualityAbsentEdgeCert = false := by decide

def OneEqualityWrongDirectionCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [⟨[], true⟩])⟩], (.leaf [])⟩)
theorem OneEqualityWrongDirection_observed : check OneEquality OneEqualityWrongDirectionCert = false := by decide

def OneEqualityMissingSelectionCert : Certificate := (.constructed ⟨[], (.leaf [])⟩)
theorem OneEqualityMissingSelection_observed : check OneEquality OneEqualityMissingSelectionCert = false := by decide

def OneEqualityExtraSelectionCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩, ⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩)
theorem OneEqualityExtraSelection_observed : check OneEquality OneEqualityExtraSelectionCert = false := by decide

def OneEqualityBadProgramCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.pair (.leaf []) (.leaf []))⟩)
theorem OneEqualityBadProgram_observed : check OneEquality OneEqualityBadProgramCert = false := by decide

def EqualityChain : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.leaf [true, true]), [⟨[false], [false], [true, false]⟩, ⟨[true], [true, false], [true, true]⟩]⟩
def EqualityChainCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])⟩], (.leaf [])⟩)
theorem EqualityChain_observed : check EqualityChain EqualityChainCert = true := by decide

def EqualityChainBrokenChainCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [⟨[true], false⟩, ⟨[false], false⟩])⟩], (.leaf [])⟩)
theorem EqualityChainBrokenChain_observed : check EqualityChain EqualityChainBrokenChainCert = false := by decide

def EqualityChainWrongEndpointCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [⟨[false], false⟩])⟩], (.leaf [])⟩)
theorem EqualityChainWrongEndpoint_observed : check EqualityChain EqualityChainWrongEndpointCert = false := by decide

def ReversedChain : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [true, true]), (.leaf [false]), [⟨[false], [false], [true, false]⟩, ⟨[true], [true, false], [true, true]⟩]⟩
def ReversedChainCert : Certificate := (.constructed ⟨[⟨[], [], (.sourceRelation [⟨[true], true⟩, ⟨[false], true⟩])⟩], (.leaf [])⟩)
theorem ReversedChain_observed : check ReversedChain ReversedChainCert = true := by decide

def JointQuestion : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.pair (.leaf [false]) (.leaf [true, false])), (.pair (.leaf [true, true]) (.pair (.leaf [false]) (.leaf [true, false]))), [⟨[], [true, false], [true, true]⟩]⟩
def JointQuestionCert : Certificate := (.constructed ⟨[⟨[false], [true], (.sourceRelation [⟨[], false⟩])⟩, ⟨[true, false], [false], .address⟩, ⟨[true, true], [true], .address⟩], (.pair (.leaf [true]) (.pair (.leaf [false]) (.leaf [true])))⟩)
theorem JointQuestion_observed : check JointQuestion JointQuestionCert = true := by decide

def AliasedView : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.pair (.leaf [true, false]) (.leaf [true, true])), (.pair (.leaf [false]) (.leaf [true, true])), [⟨[], [false], [true, false]⟩]⟩
def AliasedViewCert : Certificate := (.constructed ⟨[⟨[false], [false], (.sourceRelation [⟨[], true⟩])⟩, ⟨[true], [true], .address⟩], (.pair (.leaf [false]) (.leaf [true]))⟩)
theorem AliasedView_observed : check AliasedView AliasedViewCert = true := by decide

def DisconnectedClass : Model := ⟨(.pair (.pair (.leaf 0) (.leaf 0)) (.pair (.leaf 0) (.leaf 0))), (.leaf [false, false]), (.leaf [true, true]), [⟨[], [false, false], [false, true]⟩]⟩
def DisconnectedClassCert : Certificate := (.obstructed ⟨[], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩]⟩)
theorem DisconnectedClass_observed : check DisconnectedClass DisconnectedClassCert = true := by decide

def DisconnectedClassBrokenEdgeCert : Certificate := (.obstructed ⟨[], [⟨0, [[false, false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩, ⟨0, [[false, true]]⟩]⟩)
theorem DisconnectedClassBrokenEdge_observed : check DisconnectedClass DisconnectedClassBrokenEdgeCert = false := by decide

def SameSortDifferentPlaces : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [true]), []⟩
def SameSortDifferentPlacesCert : Certificate := (.obstructed ⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩)
theorem SameSortDifferentPlaces_observed : check SameSortDifferentPlaces SameSortDifferentPlacesCert = true := by decide

def SameSortDifferentPlacesBadQuestionCert : Certificate := (.obstructed ⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩)
theorem SameSortDifferentPlacesBadQuestion_observed : check SameSortDifferentPlaces SameSortDifferentPlacesBadQuestionCert = false := by decide

def SameSortDifferentPlacesLostLeafCert : Certificate := (.obstructed ⟨[], [⟨0, [[false]]⟩]⟩)
theorem SameSortDifferentPlacesLostLeaf_observed : check SameSortDifferentPlaces SameSortDifferentPlacesLostLeafCert = false := by decide

def SameSortDifferentPlacesDuplicateLeafCert : Certificate := (.obstructed ⟨[], [⟨0, [[false], [false]]⟩, ⟨0, [[true]]⟩]⟩)
theorem SameSortDifferentPlacesDuplicateLeaf_observed : check SameSortDifferentPlaces SameSortDifferentPlacesDuplicateLeafCert = false := by decide

def SameSortDifferentPlacesEmptyClassCert : Certificate := (.obstructed ⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩, ⟨0, []⟩]⟩)
theorem SameSortDifferentPlacesEmptyClass_observed : check SameSortDifferentPlaces SameSortDifferentPlacesEmptyClassCert = false := by decide

def SameSortDifferentPlacesObservedBlockCert : Certificate := (.obstructed ⟨[], [⟨0, [[false], [true]]⟩]⟩)
theorem SameSortDifferentPlacesObservedBlock_observed : check SameSortDifferentPlaces SameSortDifferentPlacesObservedBlockCert = false := by decide

def DisplayCoincidence : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [true]), []⟩
def DisplayCoincidenceCert : Certificate := (.obstructed ⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩)
theorem DisplayCoincidence_observed : check DisplayCoincidence DisplayCoincidenceCert = true := by decide

def TwoSorts : Model := ⟨(.pair (.leaf 0) (.leaf 1)), (.leaf [false]), (.leaf [true]), []⟩
def TwoSortsCert : Certificate := (.obstructed ⟨[], [⟨0, [[false]]⟩, ⟨1, [[true]]⟩]⟩)
theorem TwoSorts_observed : check TwoSorts TwoSortsCert = true := by decide

def TwoSortsWrongSortCert : Certificate := (.obstructed ⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩]⟩)
theorem TwoSortsWrongSort_observed : check TwoSorts TwoSortsWrongSortCert = false := by decide

def DuplicatedOrigin : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.leaf [false]) (.leaf [false])), (.leaf [false]), []⟩
def DuplicatedOriginCert : Certificate := (.constructed ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩)
theorem DuplicatedOrigin_observed : check DuplicatedOrigin DuplicatedOriginCert = true := by decide

def WholeAsObservation : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.leaf [false]) (.leaf [true])), (.pair (.leaf [true]) (.leaf [false])), []⟩
def WholeAsObservationCert : Certificate := (.constructed ⟨[⟨[false], [true], .address⟩, ⟨[true], [false], .address⟩], (.pair (.leaf [true]) (.leaf [false]))⟩)
theorem WholeAsObservation_observed : check WholeAsObservation WholeAsObservationCert = true := by decide

end U5.ContractCases
