-- Generated finite observations; not a proved bridge.
import U7.Words

namespace U7.ContractCases
open U5

def PreservesEqualities : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.leaf [false]), [⟨[], [false], [true, false]⟩]⟩
def PreservesEqualitiesActions : List Action := [⟨[], (.pair (.leaf [true, false]) (.pair (.leaf [false]) (.leaf [true, true])))⟩]
def PreservesEqualitiesCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualities_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesCert = true := by decide
theorem PreservesEqualities_conclusion : PreservesEqualitiesCert.stable.isSome = true := by decide

def PreservesEqualitiesLostClosureCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesLostClosure_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesLostClosureCert = false := by decide

def PreservesEqualitiesNoStableCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], none⟩
theorem PreservesEqualitiesNoStable_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesNoStableCert = false := by decide

def PreservesEqualitiesMissingEvidenceCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesMissingEvidence_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesMissingEvidenceCert = false := by decide

def PreservesEqualitiesExtraEvidenceCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩, ⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesExtraEvidence_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesExtraEvidenceCert = false := by decide

def PreservesEqualitiesWrongMemberCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[false], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongMember_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongMemberCert = false := by decide

def PreservesEqualitiesMissingEdgeGroundCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesMissingEdgeGround_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesMissingEdgeGroundCert = false := by decide

def PreservesEqualitiesObservedValuesGroundCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [.observedValues])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesObservedValuesGround_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesObservedValuesGroundCert = false := by decide

def PreservesEqualitiesWrongEdgeGroundCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [.address])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongEdgeGround_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongEdgeGroundCert = false := by decide

def PreservesEqualitiesFalseRefusalCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.notPreserved [])⟩], none⟩
theorem PreservesEqualitiesFalseRefusal_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesFalseRefusalCert = false := by decide

def PreservesEqualitiesMissingForestsCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesMissingForests_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesMissingForestsCert = false := by decide

def PreservesEqualitiesMissingForestEdgeCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesMissingForestEdge_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesMissingForestEdgeCert = false := by decide

def PreservesEqualitiesReversedForestEdgeCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], true⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesReversedForestEdge_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesReversedForestEdgeCert = false := by decide

def PreservesEqualitiesWrongSortCert : U7.Certificate := ⟨[⟨1, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongSort_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongSortCert = false := by decide

def PreservesEqualitiesMissingWitnessCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesMissingWitness_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesMissingWitnessCert = false := by decide

def PreservesEqualitiesWrongQuestionCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [false], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongQuestion_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongQuestionCert = false := by decide

def PreservesEqualitiesUnknownWordMemberCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [[false]], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesUnknownWordMember_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesUnknownWordMemberCert = false := by decide

def PreservesEqualitiesUnknownBlockCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨999, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesUnknownBlock_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesUnknownBlockCert = false := by decide

def PreservesEqualitiesBadWitnessGroundCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .observedValues⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesBadWitnessGround_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesBadWitnessGroundCert = false := by decide

def PreservesEqualitiesWrongRepresentativeCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[true, true]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongRepresentative_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongRepresentativeCert = false := by decide

def PreservesEqualitiesWrongViewCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [true, true]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongView_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongViewCert = false := by decide

def PreservesEqualitiesWrongImageMemberCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[false], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongImageMember_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongImageMemberCert = false := by decide

def PreservesEqualitiesMissingTargetsCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesMissingTargets_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesMissingTargetsCert = false := by decide

def PreservesEqualitiesInvalidTargetCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [999], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesInvalidTarget_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesInvalidTargetCert = false := by decide

def PreservesEqualitiesMissingImageSelectionsCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesMissingImageSelections_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesMissingImageSelectionsCert = false := by decide

def PreservesEqualitiesWrongImageProgramCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [false])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongImageProgram_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongImageProgramCert = false := by decide

def PreservesEqualitiesWrongImageGroundCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongImageGround_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongImageGroundCert = false := by decide

def PreservesEqualitiesMissingDecoderCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesMissingDecoder_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesMissingDecoderCert = false := by decide

def PreservesEqualitiesWrongDecoderProgramCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .address⟩], (.leaf [false])⟩⟩)⟩
theorem PreservesEqualitiesWrongDecoderProgram_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongDecoderProgramCert = false := by decide

def PreservesEqualitiesWrongDecoderGroundCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], .address⟩], [[false]], (.leaf [false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], false⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], .observedValues⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesWrongDecoderGround_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesWrongDecoderGroundCert = false := by decide

def PreservesEqualitiesOtherRepresentativeCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some ⟨[⟨0, [], [], (.sourceRelation [⟨[], false⟩])⟩], [[true, false]], (.leaf [true, false]), [⟨[], [0], ⟨[⟨[], [], (.sourceRelation [⟨[], true⟩])⟩], (.leaf [])⟩⟩], ⟨[⟨[], [], (.sourceRelation [⟨[], true⟩])⟩], (.leaf [])⟩⟩)⟩
theorem PreservesEqualitiesOtherRepresentative_observed : U7.check PreservesEqualities PreservesEqualitiesActions PreservesEqualitiesOtherRepresentativeCert = true := by decide
theorem PreservesEqualitiesOtherRepresentative_conclusion : PreservesEqualitiesOtherRepresentativeCert.stable.isSome = true := by decide

def BreaksEqualities : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.leaf [false]), [⟨[], [false], [true, false]⟩]⟩
def BreaksEqualitiesActions : List Action := [⟨[], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩]
def BreaksEqualitiesCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.notPreserved [])⟩], none⟩
theorem BreaksEqualities_observed : U7.check BreaksEqualities BreaksEqualitiesActions BreaksEqualitiesCert = true := by decide
theorem BreaksEqualities_conclusion : BreaksEqualitiesCert.stable.isSome = false := by decide

def BreaksEqualitiesUnknownRefusalEdgeCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.notPreserved [true])⟩], none⟩
theorem BreaksEqualitiesUnknownRefusalEdge_observed : U7.check BreaksEqualities BreaksEqualitiesActions BreaksEqualitiesUnknownRefusalEdgeCert = false := by decide

def BreaksEqualitiesFalsePreservationCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], (.preserved [.address])⟩], none⟩
theorem BreaksEqualitiesFalsePreservation_observed : U7.check BreaksEqualities BreaksEqualitiesActions BreaksEqualitiesFalsePreservationCert = false := by decide

def BreaksEqualitiesMissingEvidenceCert : U7.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [], none⟩
theorem BreaksEqualitiesMissingEvidence_observed : U7.check BreaksEqualities BreaksEqualitiesActions BreaksEqualitiesMissingEvidenceCert = false := by decide

def CyclicQuestion : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.leaf [false]), []⟩
def CyclicQuestionActions : List Action := [⟨[], (.pair (.leaf [true, true]) (.pair (.leaf [false]) (.leaf [true, false])))⟩]
def CyclicQuestionCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨2, [], [[]], .address⟩, ⟨1, [], [[], []], .address⟩], [[false], [true, true], [true, false]], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [1, 2, 0], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [false], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem CyclicQuestion_observed : U7.check CyclicQuestion CyclicQuestionActions CyclicQuestionCert = true := by decide
theorem CyclicQuestion_conclusion : CyclicQuestionCert.stable.isSome = true := by decide

def CyclicQuestionLostClosureCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨2, [], [[]], .address⟩, ⟨1, [], [[], []], .address⟩], [[false], [true, true], [true, false]], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem CyclicQuestionLostClosure_observed : U7.check CyclicQuestion CyclicQuestionActions CyclicQuestionLostClosureCert = false := by decide

def CyclicQuestionLostEmptyWordCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], (.preserved [])⟩], (some ⟨[⟨0, [], [[], [], []], .address⟩, ⟨2, [], [[]], .address⟩, ⟨1, [], [[], []], .address⟩], [[false], [true, true], [true, false]], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [1, 2, 0], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [false], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem CyclicQuestionLostEmptyWord_observed : U7.check CyclicQuestion CyclicQuestionActions CyclicQuestionLostEmptyWordCert = false := by decide

def CyclicQuestionWrongWordCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨2, [], [], .address⟩, ⟨1, [], [[], []], .address⟩], [[false], [true, true], [true, false]], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [1, 2, 0], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [false], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem CyclicQuestionWrongWord_observed : U7.check CyclicQuestion CyclicQuestionActions CyclicQuestionWrongWordCert = false := by decide

def CyclicQuestionDuplicateClassCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨0, [], [], .address⟩, ⟨1, [], [[], []], .address⟩], [[false], [true, true], [true, false]], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [1, 2, 0], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [false], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem CyclicQuestionDuplicateClass_observed : U7.check CyclicQuestion CyclicQuestionActions CyclicQuestionDuplicateClassCert = false := by decide

def CyclicQuestionLostRepresentativeCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨2, [], [[]], .address⟩, ⟨1, [], [[], []], .address⟩], [[false], [true, true]], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [1, 2, 0], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [false], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem CyclicQuestionLostRepresentative_observed : U7.check CyclicQuestion CyclicQuestionActions CyclicQuestionLostRepresentativeCert = false := by decide

def CyclicQuestionWrongClosureTargetCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨2, [], [[]], .address⟩, ⟨1, [], [[], []], .address⟩], [[false], [true, true], [true, false]], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [0, 2, 0], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [false], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem CyclicQuestionWrongClosureTarget_observed : U7.check CyclicQuestion CyclicQuestionActions CyclicQuestionWrongClosureTargetCert = false := by decide

def CyclicQuestionUnbalancedViewCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨2, [], [[]], .address⟩, ⟨1, [], [[], []], .address⟩], [[false], [true, true], [true, false]], (.pair (.pair (.leaf [false]) (.leaf [true, true])) (.leaf [true, false])), [⟨[], [1, 2, 0], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [false], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem CyclicQuestionUnbalancedView_observed : U7.check CyclicQuestion CyclicQuestionActions CyclicQuestionUnbalancedViewCert = false := by decide

def EmptyActions : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.leaf [true, true]), []⟩
def EmptyActionsActions : List Action := []
def EmptyActionsCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [], (some ⟨[⟨2, [], [], .address⟩], [[true, true]], (.leaf [true, true]), [], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem EmptyActions_observed : U7.check EmptyActions EmptyActionsActions EmptyActionsCert = true := by decide
theorem EmptyActions_conclusion : EmptyActionsCert.stable.isSome = true := by decide

def EmptyActionsLostEmptyWordCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [], (some ⟨[⟨2, [], [[]], .address⟩], [[true, true]], (.leaf [true, true]), [], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem EmptyActionsLostEmptyWord_observed : U7.check EmptyActions EmptyActionsActions EmptyActionsLostEmptyWordCert = false := by decide

def EmptyActionsWrongDecoderCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [], (some ⟨[⟨2, [], [], .address⟩], [[true, true]], (.leaf [true, true]), [], ⟨[⟨[], [], .address⟩], (.leaf [false])⟩⟩)⟩
theorem EmptyActionsWrongDecoder_observed : U7.check EmptyActions EmptyActionsActions EmptyActionsWrongDecoderCert = false := by decide

def EmptyActionsUnknownViewCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [], (some ⟨[⟨2, [], [], .address⟩], [[true, true]], (.leaf [false]), [], ⟨[⟨[], [], .address⟩], (.leaf [])⟩⟩)⟩
theorem EmptyActionsUnknownView_observed : U7.check EmptyActions EmptyActionsActions EmptyActionsUnknownViewCert = false := by decide

def NoncommutingWords : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.leaf [false]), []⟩
def NoncommutingWordsActions : List Action := [⟨[false], (.pair (.leaf [true, false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩, ⟨[true], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, true])))⟩]
def NoncommutingWordsCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨1, [], [[false]], .address⟩, ⟨2, [], [[false], [true]], .address⟩], [[false], [true, false], [true, true]], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true]))), [⟨[false], [1, 1, 2], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, false], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩⟩, ⟨[true], [0, 2, 2], ⟨[⟨[false], [false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, true])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem NoncommutingWords_observed : U7.check NoncommutingWords NoncommutingWordsActions NoncommutingWordsCert = true := by decide
theorem NoncommutingWords_conclusion : NoncommutingWordsCert.stable.isSome = true := by decide

def NoncommutingWordsLostClosureCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨1, [], [[false]], .address⟩, ⟨2, [], [[false], [true]], .address⟩], [[false], [true, false], [true, true]], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true]))), [], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem NoncommutingWordsLostClosure_observed : U7.check NoncommutingWords NoncommutingWordsActions NoncommutingWordsLostClosureCert = false := by decide

def NoncommutingWordsReversedWordCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨1, [], [[false]], .address⟩, ⟨2, [], [[true], [false]], .address⟩], [[false], [true, false], [true, true]], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true]))), [⟨[false], [1, 1, 2], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, false], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩⟩, ⟨[true], [0, 2, 2], ⟨[⟨[false], [false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, true])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem NoncommutingWordsReversedWord_observed : U7.check NoncommutingWords NoncommutingWordsActions NoncommutingWordsReversedWordCert = false := by decide

def NoncommutingWordsPermutedImageActionsCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨1, [], [[false]], .address⟩, ⟨2, [], [[false], [true]], .address⟩], [[false], [true, false], [true, true]], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true]))), [⟨[true], [0, 2, 2], ⟨[⟨[false], [false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, true])))⟩⟩, ⟨[false], [1, 1, 2], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, false], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem NoncommutingWordsPermutedImageActions_observed : U7.check NoncommutingWords NoncommutingWordsActions NoncommutingWordsPermutedImageActionsCert = false := by decide

def NoncommutingWordsPermutedEvidenceCert : U7.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[true], (.preserved [])⟩, ⟨[false], (.preserved [])⟩], (some ⟨[⟨0, [], [], .address⟩, ⟨1, [], [[false]], .address⟩, ⟨2, [], [[false], [true]], .address⟩], [[false], [true, false], [true, true]], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true]))), [⟨[false], [1, 1, 2], ⟨[⟨[false], [true, false], .address⟩, ⟨[true, false], [true, false], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [true, false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩⟩, ⟨[true], [0, 2, 2], ⟨[⟨[false], [false], .address⟩, ⟨[true, false], [true, true], .address⟩, ⟨[true, true], [true, true], .address⟩], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, true])))⟩⟩], ⟨[⟨[], [false], .address⟩], (.leaf [false])⟩⟩)⟩
theorem NoncommutingWordsPermutedEvidence_observed : U7.check NoncommutingWords NoncommutingWordsActions NoncommutingWordsPermutedEvidenceCert = false := by decide

end U7.ContractCases
