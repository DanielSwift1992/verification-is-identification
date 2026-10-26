-- Generated finite observations; not a proved Swift/Lean bridge.
import U11.Soundness

namespace U11.ContractCases
open U5 U7

def ReturnFirst : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.leaf [false]), []⟩
def ReturnFirstHidden : List Action := [⟨[false], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩, ⟨[true], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩]
def ReturnFirstCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirst_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstCert = true := by decide
theorem ReturnFirst_claim : U11.Claim ReturnFirst ReturnFirstHidden ReturnFirstCert := U11.check_sound ReturnFirst_observed

def ReturnFirstMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstMissingRequired_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstMissingRequiredCert = false := by decide

def ReturnFirstExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 999], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstExtraRequired_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstExtraRequiredCert = false := by decide

def ReturnFirstDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstDuplicateRequired_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstDuplicateRequiredCert = false := by decide

def ReturnFirstMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstMissingEvidence_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstMissingEvidenceCert = false := by decide

def ReturnFirstExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩, ⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstExtraEvidence_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstExtraEvidenceCert = false := by decide

def ReturnFirstWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false, true, true, true, true, true, true, true, true], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstWrongMemberEvidence_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongMemberEvidenceCert = false := by decide

def ReturnFirstMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstMissingForests_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstMissingForestsCert = false := by decide

def ReturnFirstMissingClassesCert : U11.Certificate := ⟨[], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstMissingClasses_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstMissingClassesCert = false := by decide

def ReturnFirstNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], none⟩
theorem ReturnFirstNoConclusion_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstNoConclusionCert = false := by decide

def ReturnFirstMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstMissingCycles_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstMissingCyclesCert = false := by decide

def ReturnFirstExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[false], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstExtraCycle_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstExtraCycleCert = false := by decide

def ReturnFirstWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false, true, true, true, true, true, true, true, true], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstWrongMember_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongMemberCert = false := by decide

def ReturnFirstWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 999, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstWrongBlock_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongBlockCert = false := by decide

def ReturnFirstWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 999], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstWrongVertex_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongVertexCert = false := by decide

def ReturnFirstWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstWrongLength_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongLengthCert = false := by decide

def ReturnFirstRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0, 0], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstRepeatedPrefix_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstRepeatedPrefixCert = false := by decide

def ReturnFirstEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstEmptyWalk_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstEmptyWalkCert = false := by decide

def ReturnFirstZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0], 0⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstZeroWalk_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstZeroWalkCert = false := by decide

def ReturnFirstMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [], 3, 2⟩))⟩
theorem ReturnFirstMissingArithmetic_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstMissingArithmeticCert = false := by decide

def ReturnFirstExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩, ⟨1, 1, 1⟩], 3, 2⟩))⟩
theorem ReturnFirstExtraArithmetic_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstExtraArithmeticCert = false := by decide

def ReturnFirstWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨2, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstWrongGCD_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongGCDCert = false := by decide

def ReturnFirstWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 2, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstWrongMultiplier_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongMultiplierCert = false := by decide

def ReturnFirstWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 2⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem ReturnFirstWrongStepValue_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongStepValueCert = false := by decide

def ReturnFirstWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 4, 2⟩))⟩
theorem ReturnFirstWrongCalls_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongCallsCert = false := by decide

def ReturnFirstWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 3⟩))⟩
theorem ReturnFirstWrongAdditionalCalls_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstWrongAdditionalCallsCert = false := by decide

def ReturnFirstZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 0, 2⟩))⟩
theorem ReturnFirstZeroCalls_observed : U11.check ReturnFirst ReturnFirstHidden ReturnFirstZeroCallsCert = false := by decide

def ReturnWhole : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true]))), []⟩
def ReturnWholeHidden : List Action := [⟨[false], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩, ⟨[true], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩]
def ReturnWholeCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWhole_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeCert = true := by decide
theorem ReturnWhole_claim : U11.Claim ReturnWhole ReturnWholeHidden ReturnWholeCert := U11.check_sound ReturnWhole_observed

def ReturnWholeMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeMissingRequired_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeMissingRequiredCert = false := by decide

def ReturnWholeExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2, 999], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeExtraRequired_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeExtraRequiredCert = false := by decide

def ReturnWholeDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2, 0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeDuplicateRequired_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeDuplicateRequiredCert = false := by decide

def ReturnWholeMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeMissingEvidence_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeMissingEvidenceCert = false := by decide

def ReturnWholeExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩, ⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeExtraEvidence_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeExtraEvidenceCert = false := by decide

def ReturnWholeWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false, true, true, true, true, true, true, true, true], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeWrongMemberEvidence_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongMemberEvidenceCert = false := by decide

def ReturnWholeMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeMissingForests_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeMissingForestsCert = false := by decide

def ReturnWholeMissingClassesCert : U11.Certificate := ⟨[], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeMissingClasses_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeMissingClassesCert = false := by decide

def ReturnWholeRequiredOrderCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [2, 1, 0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeRequiredOrder_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeRequiredOrderCert = false := by decide

def ReturnWholeNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], none⟩
theorem ReturnWholeNoConclusion_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeNoConclusionCert = false := by decide

def ReturnWholeMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeMissingCycles_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeMissingCyclesCert = false := by decide

def ReturnWholeExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩, ⟨[false], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeExtraCycle_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeExtraCycleCert = false := by decide

def ReturnWholeWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false, true, true, true, true, true, true, true, true], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeWrongMember_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongMemberCert = false := by decide

def ReturnWholeWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 999, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeWrongBlock_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongBlockCert = false := by decide

def ReturnWholeWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 999], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeWrongVertex_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongVertexCert = false := by decide

def ReturnWholeWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 2⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeWrongLength_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongLengthCert = false := by decide

def ReturnWholeRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0, 0], 2⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeRepeatedPrefix_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeRepeatedPrefixCert = false := by decide

def ReturnWholeEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeEmptyWalk_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeEmptyWalkCert = false := by decide

def ReturnWholeZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0], 0⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeZeroWalk_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeZeroWalkCert = false := by decide

def ReturnWholeMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [], 6, 5⟩))⟩
theorem ReturnWholeMissingArithmetic_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeMissingArithmeticCert = false := by decide

def ReturnWholeExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩, ⟨1, 1, 1⟩], 6, 5⟩))⟩
theorem ReturnWholeExtraArithmetic_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeExtraArithmeticCert = false := by decide

def ReturnWholeWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨2, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeWrongGCD_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongGCDCert = false := by decide

def ReturnWholeWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 2, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeWrongMultiplier_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongMultiplierCert = false := by decide

def ReturnWholeWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 2⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeWrongStepValue_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongStepValueCert = false := by decide

def ReturnWholeWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 7, 5⟩))⟩
theorem ReturnWholeWrongCalls_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongCallsCert = false := by decide

def ReturnWholeWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 6⟩))⟩
theorem ReturnWholeWrongAdditionalCalls_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeWrongAdditionalCallsCert = false := by decide

def ReturnWholeZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 2, [2, 0, 1, 2], 3⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 0, 5⟩))⟩
theorem ReturnWholeZeroCalls_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeZeroCallsCert = false := by decide

def ReturnWholeCycleOrderCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 1, 2], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[true], 2, [2, 0, 1, 2], 3⟩, ⟨[true], 1, [1, 2, 0, 1], 3⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[false], 2, [2, 1, 2], 2⟩, ⟨[false], 1, [1, 2, 1], 2⟩, ⟨[false], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 3, 6⟩, ⟨3, 1, 6⟩, ⟨3, 1, 6⟩], 6, 5⟩))⟩
theorem ReturnWholeCycleOrder_observed : U11.check ReturnWhole ReturnWholeHidden ReturnWholeCycleOrderCert = false := by decide

def FixedQuestion : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [false]), []⟩
def FixedQuestionHidden : List Action := [⟨[], (.pair (.leaf [false]) (.leaf [false]))⟩]
def FixedQuestionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestion_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionCert = true := by decide
theorem FixedQuestion_claim : U11.Claim FixedQuestion FixedQuestionHidden FixedQuestionCert := U11.check_sound FixedQuestion_observed

def FixedQuestionMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionMissingRequired_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionMissingRequiredCert = false := by decide

def FixedQuestionExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 999], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionExtraRequired_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionExtraRequiredCert = false := by decide

def FixedQuestionDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionDuplicateRequired_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionDuplicateRequiredCert = false := by decide

def FixedQuestionMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionMissingEvidence_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionMissingEvidenceCert = false := by decide

def FixedQuestionExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩, ⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionExtraEvidence_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionExtraEvidenceCert = false := by decide

def FixedQuestionWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[true, true, true, true, true, true, true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionWrongMemberEvidence_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongMemberEvidenceCert = false := by decide

def FixedQuestionMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionMissingForests_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionMissingForestsCert = false := by decide

def FixedQuestionMissingClassesCert : U11.Certificate := ⟨[], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionMissingClasses_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionMissingClassesCert = false := by decide

def FixedQuestionNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], none⟩
theorem FixedQuestionNoConclusion_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionNoConclusionCert = false := by decide

def FixedQuestionMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionMissingCycles_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionMissingCyclesCert = false := by decide

def FixedQuestionExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionExtraCycle_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionExtraCycleCert = false := by decide

def FixedQuestionWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[true, true, true, true, true, true, true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionWrongMember_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongMemberCert = false := by decide

def FixedQuestionWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 999, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionWrongBlock_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongBlockCert = false := by decide

def FixedQuestionWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 999], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionWrongVertex_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongVertexCert = false := by decide

def FixedQuestionWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 2⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionWrongLength_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongLengthCert = false := by decide

def FixedQuestionRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0, 0], 2⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionRepeatedPrefix_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionRepeatedPrefixCert = false := by decide

def FixedQuestionEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionEmptyWalk_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionEmptyWalkCert = false := by decide

def FixedQuestionZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0], 0⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionZeroWalk_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionZeroWalkCert = false := by decide

def FixedQuestionMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [], 1, 0⟩))⟩
theorem FixedQuestionMissingArithmetic_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionMissingArithmeticCert = false := by decide

def FixedQuestionExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionExtraArithmetic_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionExtraArithmeticCert = false := by decide

def FixedQuestionWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨2, 1, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionWrongGCD_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongGCDCert = false := by decide

def FixedQuestionWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 2, 1⟩], 1, 0⟩))⟩
theorem FixedQuestionWrongMultiplier_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongMultiplierCert = false := by decide

def FixedQuestionWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 2⟩], 1, 0⟩))⟩
theorem FixedQuestionWrongStepValue_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongStepValueCert = false := by decide

def FixedQuestionWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 2, 0⟩))⟩
theorem FixedQuestionWrongCalls_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongCallsCert = false := by decide

def FixedQuestionWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 1⟩))⟩
theorem FixedQuestionWrongAdditionalCalls_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionWrongAdditionalCallsCert = false := by decide

def FixedQuestionZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 0, 0⟩))⟩
theorem FixedQuestionZeroCalls_observed : U11.check FixedQuestion FixedQuestionHidden FixedQuestionZeroCallsCert = false := by decide

def FourCycle : Model := ⟨(.pair (.pair (.leaf 0) (.leaf 0)) (.pair (.leaf 0) (.leaf 0))), (.leaf [false, false]), (.leaf [false, false]), []⟩
def FourCycleHidden : List Action := [⟨[], (.pair (.pair (.leaf [false, true]) (.leaf [true, false])) (.pair (.leaf [true, true]) (.leaf [false, false])))⟩]
def FourCycleCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycle_observed : U11.check FourCycle FourCycleHidden FourCycleCert = true := by decide
theorem FourCycle_claim : U11.Claim FourCycle FourCycleHidden FourCycleCert := U11.check_sound FourCycle_observed

def FourCycleMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleMissingRequired_observed : U11.check FourCycle FourCycleHidden FourCycleMissingRequiredCert = false := by decide

def FourCycleExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0, 999], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleExtraRequired_observed : U11.check FourCycle FourCycleHidden FourCycleExtraRequiredCert = false := by decide

def FourCycleDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0, 0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleDuplicateRequired_observed : U11.check FourCycle FourCycleHidden FourCycleDuplicateRequiredCert = false := by decide

def FourCycleMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleMissingEvidence_observed : U11.check FourCycle FourCycleHidden FourCycleMissingEvidenceCert = false := by decide

def FourCycleExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩, ⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleExtraEvidence_observed : U11.check FourCycle FourCycleHidden FourCycleExtraEvidenceCert = false := by decide

def FourCycleWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[true, true, true, true, true, true, true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleWrongMemberEvidence_observed : U11.check FourCycle FourCycleHidden FourCycleWrongMemberEvidenceCert = false := by decide

def FourCycleMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleMissingForests_observed : U11.check FourCycle FourCycleHidden FourCycleMissingForestsCert = false := by decide

def FourCycleMissingClassesCert : U11.Certificate := ⟨[], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleMissingClasses_observed : U11.check FourCycle FourCycleHidden FourCycleMissingClassesCert = false := by decide

def FourCycleNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], none⟩
theorem FourCycleNoConclusion_observed : U11.check FourCycle FourCycleHidden FourCycleNoConclusionCert = false := by decide

def FourCycleMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleMissingCycles_observed : U11.check FourCycle FourCycleHidden FourCycleMissingCyclesCert = false := by decide

def FourCycleExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩, ⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleExtraCycle_observed : U11.check FourCycle FourCycleHidden FourCycleExtraCycleCert = false := by decide

def FourCycleWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[true, true, true, true, true, true, true, true], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleWrongMember_observed : U11.check FourCycle FourCycleHidden FourCycleWrongMemberCert = false := by decide

def FourCycleWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 999, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleWrongBlock_observed : U11.check FourCycle FourCycleHidden FourCycleWrongBlockCert = false := by decide

def FourCycleWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 999, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleWrongVertex_observed : U11.check FourCycle FourCycleHidden FourCycleWrongVertexCert = false := by decide

def FourCycleWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 5⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleWrongLength_observed : U11.check FourCycle FourCycleHidden FourCycleWrongLengthCert = false := by decide

def FourCycleRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0, 1, 2, 3, 0], 5⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleRepeatedPrefix_observed : U11.check FourCycle FourCycleHidden FourCycleRepeatedPrefixCert = false := by decide

def FourCycleEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [], 4⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleEmptyWalk_observed : U11.check FourCycle FourCycleHidden FourCycleEmptyWalkCert = false := by decide

def FourCycleZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0], 0⟩], [⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleZeroWalk_observed : U11.check FourCycle FourCycleHidden FourCycleZeroWalkCert = false := by decide

def FourCycleMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [], 4, 3⟩))⟩
theorem FourCycleMissingArithmetic_observed : U11.check FourCycle FourCycleHidden FourCycleMissingArithmeticCert = false := by decide

def FourCycleExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩, ⟨1, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleExtraArithmetic_observed : U11.check FourCycle FourCycleHidden FourCycleExtraArithmeticCert = false := by decide

def FourCycleWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨2, 4, 4⟩], 4, 3⟩))⟩
theorem FourCycleWrongGCD_observed : U11.check FourCycle FourCycleHidden FourCycleWrongGCDCert = false := by decide

def FourCycleWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 5, 4⟩], 4, 3⟩))⟩
theorem FourCycleWrongMultiplier_observed : U11.check FourCycle FourCycleHidden FourCycleWrongMultiplierCert = false := by decide

def FourCycleWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 5⟩], 4, 3⟩))⟩
theorem FourCycleWrongStepValue_observed : U11.check FourCycle FourCycleHidden FourCycleWrongStepValueCert = false := by decide

def FourCycleWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 5, 3⟩))⟩
theorem FourCycleWrongCalls_observed : U11.check FourCycle FourCycleHidden FourCycleWrongCallsCert = false := by decide

def FourCycleWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 4, 4⟩))⟩
theorem FourCycleWrongAdditionalCalls_observed : U11.check FourCycle FourCycleHidden FourCycleWrongAdditionalCallsCert = false := by decide

def FourCycleZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 1, 2, 3, 0], 4⟩], [⟨1, 4, 4⟩], 0, 3⟩))⟩
theorem FourCycleZeroCalls_observed : U11.check FourCycle FourCycleHidden FourCycleZeroCallsCert = false := by decide

def IdentityReturn : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.pair (.leaf [false]) (.leaf [true])), []⟩
def IdentityReturnHidden : List Action := [⟨[], (.pair (.leaf [false]) (.leaf [true]))⟩]
def IdentityReturnCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturn_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnCert = true := by decide
theorem IdentityReturn_claim : U11.Claim IdentityReturn IdentityReturnHidden IdentityReturnCert := U11.check_sound IdentityReturn_observed

def IdentityReturnMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnMissingRequired_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnMissingRequiredCert = false := by decide

def IdentityReturnExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1, 999], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnExtraRequired_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnExtraRequiredCert = false := by decide

def IdentityReturnDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1, 0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnDuplicateRequired_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnDuplicateRequiredCert = false := by decide

def IdentityReturnMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnMissingEvidence_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnMissingEvidenceCert = false := by decide

def IdentityReturnExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩, ⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnExtraEvidence_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnExtraEvidenceCert = false := by decide

def IdentityReturnWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[true, true, true, true, true, true, true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnWrongMemberEvidence_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongMemberEvidenceCert = false := by decide

def IdentityReturnMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnMissingForests_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnMissingForestsCert = false := by decide

def IdentityReturnMissingClassesCert : U11.Certificate := ⟨[], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnMissingClasses_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnMissingClassesCert = false := by decide

def IdentityReturnRequiredOrderCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1, 0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnRequiredOrder_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnRequiredOrderCert = false := by decide

def IdentityReturnNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], none⟩
theorem IdentityReturnNoConclusion_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnNoConclusionCert = false := by decide

def IdentityReturnMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnMissingCycles_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnMissingCyclesCert = false := by decide

def IdentityReturnExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩, ⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnExtraCycle_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnExtraCycleCert = false := by decide

def IdentityReturnWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[true, true, true, true, true, true, true, true], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnWrongMember_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongMemberCert = false := by decide

def IdentityReturnWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 999, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnWrongBlock_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongBlockCert = false := by decide

def IdentityReturnWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 999], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnWrongVertex_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongVertexCert = false := by decide

def IdentityReturnWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 2⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnWrongLength_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongLengthCert = false := by decide

def IdentityReturnRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0, 0], 2⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnRepeatedPrefix_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnRepeatedPrefixCert = false := by decide

def IdentityReturnEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnEmptyWalk_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnEmptyWalkCert = false := by decide

def IdentityReturnZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0], 0⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnZeroWalk_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnZeroWalkCert = false := by decide

def IdentityReturnMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [], 1, 0⟩))⟩
theorem IdentityReturnMissingArithmetic_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnMissingArithmeticCert = false := by decide

def IdentityReturnExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnExtraArithmetic_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnExtraArithmeticCert = false := by decide

def IdentityReturnWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨2, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnWrongGCD_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongGCDCert = false := by decide

def IdentityReturnWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 2, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnWrongMultiplier_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongMultiplierCert = false := by decide

def IdentityReturnWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 2⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnWrongStepValue_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongStepValueCert = false := by decide

def IdentityReturnWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 2, 0⟩))⟩
theorem IdentityReturnWrongCalls_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongCallsCert = false := by decide

def IdentityReturnWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 1⟩))⟩
theorem IdentityReturnWrongAdditionalCalls_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnWrongAdditionalCallsCert = false := by decide

def IdentityReturnZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 1, [1, 1], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 0, 0⟩))⟩
theorem IdentityReturnZeroCalls_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnZeroCallsCert = false := by decide

def IdentityReturnCycleOrderCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 1], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 1, [1, 1], 1⟩, ⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem IdentityReturnCycleOrder_observed : U11.check IdentityReturn IdentityReturnHidden IdentityReturnCycleOrderCert = false := by decide

def EqualClassReturn : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.pair (.leaf [false]) (.leaf [true])), [⟨[], [false], [true]⟩]⟩
def EqualClassReturnHidden : List Action := [⟨[], (.pair (.leaf [true]) (.leaf [false]))⟩]
def EqualClassReturnCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturn_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnCert = true := by decide
theorem EqualClassReturn_claim : U11.Claim EqualClassReturn EqualClassReturnHidden EqualClassReturnCert := U11.check_sound EqualClassReturn_observed

def EqualClassReturnMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnMissingRequired_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnMissingRequiredCert = false := by decide

def EqualClassReturnExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0, 999], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnExtraRequired_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnExtraRequiredCert = false := by decide

def EqualClassReturnDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0, 0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnDuplicateRequired_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnDuplicateRequiredCert = false := by decide

def EqualClassReturnMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnMissingEvidence_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnMissingEvidenceCert = false := by decide

def EqualClassReturnExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩, ⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnExtraEvidence_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnExtraEvidenceCert = false := by decide

def EqualClassReturnWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[true, true, true, true, true, true, true, true], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnWrongMemberEvidence_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongMemberEvidenceCert = false := by decide

def EqualClassReturnMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnMissingForests_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnMissingForestsCert = false := by decide

def EqualClassReturnMissingClassesCert : U11.Certificate := ⟨[], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnMissingClasses_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnMissingClassesCert = false := by decide

def EqualClassReturnNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], none⟩
theorem EqualClassReturnNoConclusion_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnNoConclusionCert = false := by decide

def EqualClassReturnMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnMissingCycles_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnMissingCyclesCert = false := by decide

def EqualClassReturnExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnExtraCycle_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnExtraCycleCert = false := by decide

def EqualClassReturnWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[true, true, true, true, true, true, true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnWrongMember_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongMemberCert = false := by decide

def EqualClassReturnWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 999, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnWrongBlock_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongBlockCert = false := by decide

def EqualClassReturnWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 999], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnWrongVertex_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongVertexCert = false := by decide

def EqualClassReturnWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 2⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnWrongLength_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongLengthCert = false := by decide

def EqualClassReturnRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0, 0], 2⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnRepeatedPrefix_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnRepeatedPrefixCert = false := by decide

def EqualClassReturnEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnEmptyWalk_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnEmptyWalkCert = false := by decide

def EqualClassReturnZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0], 0⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnZeroWalk_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnZeroWalkCert = false := by decide

def EqualClassReturnMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [], 1, 0⟩))⟩
theorem EqualClassReturnMissingArithmetic_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnMissingArithmeticCert = false := by decide

def EqualClassReturnExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnExtraArithmetic_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnExtraArithmeticCert = false := by decide

def EqualClassReturnWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨2, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnWrongGCD_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongGCDCert = false := by decide

def EqualClassReturnWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 2, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnWrongMultiplier_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongMultiplierCert = false := by decide

def EqualClassReturnWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 2⟩], 1, 0⟩))⟩
theorem EqualClassReturnWrongStepValue_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongStepValueCert = false := by decide

def EqualClassReturnWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 2, 0⟩))⟩
theorem EqualClassReturnWrongCalls_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongCallsCert = false := by decide

def EqualClassReturnWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 1⟩))⟩
theorem EqualClassReturnWrongAdditionalCalls_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnWrongAdditionalCallsCert = false := by decide

def EqualClassReturnZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 0, 0⟩))⟩
theorem EqualClassReturnZeroCalls_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnZeroCallsCert = false := by decide

def EqualClassReturnLostEqualityGroundCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[]], [0], [⟨[], (.preserved [(.sourceRelation [⟨[], true⟩])])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnLostEqualityGround_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnLostEqualityGroundCert = false := by decide

def EqualClassReturnLostPreservationGroundCert : U11.Certificate := ⟨[⟨0, [[false], [true]]⟩], [[⟨[], false⟩]], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem EqualClassReturnLostPreservationGround_observed : U11.check EqualClassReturn EqualClassReturnHidden EqualClassReturnLostPreservationGroundCert = false := by decide

def DuplicateReturnQuestion : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.pair (.leaf [false]) (.leaf [false])), []⟩
def DuplicateReturnQuestionHidden : List Action := [⟨[false], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩, ⟨[true], (.pair (.leaf [true, false]) (.pair (.leaf [true, true]) (.leaf [false])))⟩]
def DuplicateReturnQuestionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestion_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionCert = true := by decide
theorem DuplicateReturnQuestion_claim : U11.Claim DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionCert := U11.check_sound DuplicateReturnQuestion_observed

def DuplicateReturnQuestionMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionMissingRequired_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionMissingRequiredCert = false := by decide

def DuplicateReturnQuestionExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 999], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionExtraRequired_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionExtraRequiredCert = false := by decide

def DuplicateReturnQuestionDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0, 0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionDuplicateRequired_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionDuplicateRequiredCert = false := by decide

def DuplicateReturnQuestionMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionMissingEvidence_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionMissingEvidenceCert = false := by decide

def DuplicateReturnQuestionExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩, ⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionExtraEvidence_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionExtraEvidenceCert = false := by decide

def DuplicateReturnQuestionWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false, true, true, true, true, true, true, true, true], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionWrongMemberEvidence_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongMemberEvidenceCert = false := by decide

def DuplicateReturnQuestionMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionMissingForests_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionMissingForestsCert = false := by decide

def DuplicateReturnQuestionMissingClassesCert : U11.Certificate := ⟨[], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionMissingClasses_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionMissingClassesCert = false := by decide

def DuplicateReturnQuestionNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], none⟩
theorem DuplicateReturnQuestionNoConclusion_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionNoConclusionCert = false := by decide

def DuplicateReturnQuestionMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionMissingCycles_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionMissingCyclesCert = false := by decide

def DuplicateReturnQuestionExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩, ⟨[false], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionExtraCycle_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionExtraCycleCert = false := by decide

def DuplicateReturnQuestionWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false, true, true, true, true, true, true, true, true], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionWrongMember_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongMemberCert = false := by decide

def DuplicateReturnQuestionWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 999, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionWrongBlock_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongBlockCert = false := by decide

def DuplicateReturnQuestionWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 999], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionWrongVertex_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongVertexCert = false := by decide

def DuplicateReturnQuestionWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionWrongLength_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongLengthCert = false := by decide

def DuplicateReturnQuestionRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0, 0], 2⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionRepeatedPrefix_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionRepeatedPrefixCert = false := by decide

def DuplicateReturnQuestionEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionEmptyWalk_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionEmptyWalkCert = false := by decide

def DuplicateReturnQuestionZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0], 0⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionZeroWalk_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionZeroWalkCert = false := by decide

def DuplicateReturnQuestionMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [], 3, 2⟩))⟩
theorem DuplicateReturnQuestionMissingArithmetic_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionMissingArithmeticCert = false := by decide

def DuplicateReturnQuestionExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩, ⟨1, 1, 1⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionExtraArithmetic_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionExtraArithmeticCert = false := by decide

def DuplicateReturnQuestionWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨2, 1, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionWrongGCD_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongGCDCert = false := by decide

def DuplicateReturnQuestionWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 2, 1⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionWrongMultiplier_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongMultiplierCert = false := by decide

def DuplicateReturnQuestionWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 2⟩, ⟨1, 3, 3⟩], 3, 2⟩))⟩
theorem DuplicateReturnQuestionWrongStepValue_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongStepValueCert = false := by decide

def DuplicateReturnQuestionWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 4, 2⟩))⟩
theorem DuplicateReturnQuestionWrongCalls_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongCallsCert = false := by decide

def DuplicateReturnQuestionWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 3, 3⟩))⟩
theorem DuplicateReturnQuestionWrongAdditionalCalls_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionWrongAdditionalCallsCert = false := by decide

def DuplicateReturnQuestionZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 2, 0], 3⟩], [⟨1, 1, 1⟩, ⟨1, 3, 3⟩], 0, 2⟩))⟩
theorem DuplicateReturnQuestionZeroCalls_observed : U11.check DuplicateReturnQuestion DuplicateReturnQuestionHidden DuplicateReturnQuestionZeroCallsCert = false := by decide

def AliasedRepeats : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.leaf [false]) (.leaf [true])), (.leaf [false]), []⟩
def AliasedRepeatsHidden : List Action := [⟨[false], (.pair (.leaf [false]) (.leaf [true]))⟩, ⟨[true], (.pair (.leaf [true]) (.leaf [false]))⟩]
def AliasedRepeatsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeats_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsCert = true := by decide
theorem AliasedRepeats_claim : U11.Claim AliasedRepeats AliasedRepeatsHidden AliasedRepeatsCert := U11.check_sound AliasedRepeats_observed

def AliasedRepeatsMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsMissingRequired_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsMissingRequiredCert = false := by decide

def AliasedRepeatsExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 999], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsExtraRequired_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsExtraRequiredCert = false := by decide

def AliasedRepeatsDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsDuplicateRequired_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsDuplicateRequiredCert = false := by decide

def AliasedRepeatsMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsMissingEvidence_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsMissingEvidenceCert = false := by decide

def AliasedRepeatsExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩, ⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsExtraEvidence_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsExtraEvidenceCert = false := by decide

def AliasedRepeatsWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false, true, true, true, true, true, true, true, true], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsWrongMemberEvidence_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongMemberEvidenceCert = false := by decide

def AliasedRepeatsMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsMissingForests_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsMissingForestsCert = false := by decide

def AliasedRepeatsMissingClassesCert : U11.Certificate := ⟨[], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsMissingClasses_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsMissingClassesCert = false := by decide

def AliasedRepeatsNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], none⟩
theorem AliasedRepeatsNoConclusion_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsNoConclusionCert = false := by decide

def AliasedRepeatsMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsMissingCycles_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsMissingCyclesCert = false := by decide

def AliasedRepeatsExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩, ⟨[false], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsExtraCycle_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsExtraCycleCert = false := by decide

def AliasedRepeatsWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false, true, true, true, true, true, true, true, true], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsWrongMember_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongMemberCert = false := by decide

def AliasedRepeatsWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 999, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsWrongBlock_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongBlockCert = false := by decide

def AliasedRepeatsWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 999], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsWrongVertex_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongVertexCert = false := by decide

def AliasedRepeatsWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsWrongLength_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongLengthCert = false := by decide

def AliasedRepeatsRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsRepeatedPrefix_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsRepeatedPrefixCert = false := by decide

def AliasedRepeatsEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsEmptyWalk_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsEmptyWalkCert = false := by decide

def AliasedRepeatsZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0], 0⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsZeroWalk_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsZeroWalkCert = false := by decide

def AliasedRepeatsMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [], 2, 1⟩))⟩
theorem AliasedRepeatsMissingArithmetic_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsMissingArithmeticCert = false := by decide

def AliasedRepeatsExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩, ⟨1, 1, 1⟩], 2, 1⟩))⟩
theorem AliasedRepeatsExtraArithmetic_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsExtraArithmeticCert = false := by decide

def AliasedRepeatsWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨2, 1, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsWrongGCD_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongGCDCert = false := by decide

def AliasedRepeatsWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 1⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsWrongMultiplier_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongMultiplierCert = false := by decide

def AliasedRepeatsWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 2⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem AliasedRepeatsWrongStepValue_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongStepValueCert = false := by decide

def AliasedRepeatsWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 3, 1⟩))⟩
theorem AliasedRepeatsWrongCalls_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongCallsCert = false := by decide

def AliasedRepeatsWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 2, 2⟩))⟩
theorem AliasedRepeatsWrongAdditionalCalls_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsWrongAdditionalCallsCert = false := by decide

def AliasedRepeatsZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 1, 1⟩, ⟨1, 2, 2⟩], 0, 1⟩))⟩
theorem AliasedRepeatsZeroCalls_observed : U11.check AliasedRepeats AliasedRepeatsHidden AliasedRepeatsZeroCallsCert = false := by decide

def OtherClassesMayHaveTails : Model := ⟨(.pair (.pair (.leaf 0) (.leaf 0)) (.pair (.leaf 0) (.leaf 0))), (.leaf [false, false]), (.leaf [false, false]), []⟩
def OtherClassesMayHaveTailsHidden : List Action := [⟨[], (.pair (.pair (.leaf [false, false]) (.leaf [false, false])) (.pair (.leaf [false, true]) (.leaf [true, false])))⟩]
def OtherClassesMayHaveTailsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTails_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsCert = true := by decide
theorem OtherClassesMayHaveTails_claim : U11.Claim OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsCert := U11.check_sound OtherClassesMayHaveTails_observed

def OtherClassesMayHaveTailsMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsMissingRequired_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsMissingRequiredCert = false := by decide

def OtherClassesMayHaveTailsExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0, 999], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsExtraRequired_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsExtraRequiredCert = false := by decide

def OtherClassesMayHaveTailsDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0, 0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsDuplicateRequired_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsDuplicateRequiredCert = false := by decide

def OtherClassesMayHaveTailsMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsMissingEvidence_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsMissingEvidenceCert = false := by decide

def OtherClassesMayHaveTailsExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩, ⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsExtraEvidence_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsExtraEvidenceCert = false := by decide

def OtherClassesMayHaveTailsWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[true, true, true, true, true, true, true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsWrongMemberEvidence_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongMemberEvidenceCert = false := by decide

def OtherClassesMayHaveTailsMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsMissingForests_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsMissingForestsCert = false := by decide

def OtherClassesMayHaveTailsMissingClassesCert : U11.Certificate := ⟨[], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsMissingClasses_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsMissingClassesCert = false := by decide

def OtherClassesMayHaveTailsNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], none⟩
theorem OtherClassesMayHaveTailsNoConclusion_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsNoConclusionCert = false := by decide

def OtherClassesMayHaveTailsMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsMissingCycles_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsMissingCyclesCert = false := by decide

def OtherClassesMayHaveTailsExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩, ⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsExtraCycle_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsExtraCycleCert = false := by decide

def OtherClassesMayHaveTailsWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[true, true, true, true, true, true, true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsWrongMember_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongMemberCert = false := by decide

def OtherClassesMayHaveTailsWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 999, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsWrongBlock_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongBlockCert = false := by decide

def OtherClassesMayHaveTailsWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 999], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsWrongVertex_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongVertexCert = false := by decide

def OtherClassesMayHaveTailsWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 2⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsWrongLength_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongLengthCert = false := by decide

def OtherClassesMayHaveTailsRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0, 0], 2⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsRepeatedPrefix_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsRepeatedPrefixCert = false := by decide

def OtherClassesMayHaveTailsEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [], 1⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsEmptyWalk_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsEmptyWalkCert = false := by decide

def OtherClassesMayHaveTailsZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0], 0⟩], [⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsZeroWalk_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsZeroWalkCert = false := by decide

def OtherClassesMayHaveTailsMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsMissingArithmetic_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsMissingArithmeticCert = false := by decide

def OtherClassesMayHaveTailsExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsExtraArithmetic_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsExtraArithmeticCert = false := by decide

def OtherClassesMayHaveTailsWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨2, 1, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsWrongGCD_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongGCDCert = false := by decide

def OtherClassesMayHaveTailsWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 2, 1⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsWrongMultiplier_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongMultiplierCert = false := by decide

def OtherClassesMayHaveTailsWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 2⟩], 1, 0⟩))⟩
theorem OtherClassesMayHaveTailsWrongStepValue_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongStepValueCert = false := by decide

def OtherClassesMayHaveTailsWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 2, 0⟩))⟩
theorem OtherClassesMayHaveTailsWrongCalls_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongCallsCert = false := by decide

def OtherClassesMayHaveTailsWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 1, 1⟩))⟩
theorem OtherClassesMayHaveTailsWrongAdditionalCalls_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsWrongAdditionalCallsCert = false := by decide

def OtherClassesMayHaveTailsZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [0], [⟨[], (.preserved [])⟩], (some (.returned ⟨[⟨[], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩], 0, 0⟩))⟩
theorem OtherClassesMayHaveTailsZeroCalls_observed : U11.check OtherClassesMayHaveTails OtherClassesMayHaveTailsHidden OtherClassesMayHaveTailsZeroCallsCert = false := by decide

def RepeatedHiddenCopies : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [false]), []⟩
def RepeatedHiddenCopiesHidden : List Action := [⟨[false], (.pair (.leaf [true]) (.leaf [false]))⟩, ⟨[true], (.pair (.leaf [true]) (.leaf [false]))⟩]
def RepeatedHiddenCopiesCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopies_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesCert = true := by decide
theorem RepeatedHiddenCopies_claim : U11.Claim RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesCert := U11.check_sound RepeatedHiddenCopies_observed

def RepeatedHiddenCopiesMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesMissingRequired_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesMissingRequiredCert = false := by decide

def RepeatedHiddenCopiesExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 999], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesExtraRequired_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesExtraRequiredCert = false := by decide

def RepeatedHiddenCopiesDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0, 0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesDuplicateRequired_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesDuplicateRequiredCert = false := by decide

def RepeatedHiddenCopiesMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesMissingEvidence_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesMissingEvidenceCert = false := by decide

def RepeatedHiddenCopiesExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩, ⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesExtraEvidence_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesExtraEvidenceCert = false := by decide

def RepeatedHiddenCopiesWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false, true, true, true, true, true, true, true, true], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesWrongMemberEvidence_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongMemberEvidenceCert = false := by decide

def RepeatedHiddenCopiesMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesMissingForests_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesMissingForestsCert = false := by decide

def RepeatedHiddenCopiesMissingClassesCert : U11.Certificate := ⟨[], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesMissingClasses_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesMissingClassesCert = false := by decide

def RepeatedHiddenCopiesNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], none⟩
theorem RepeatedHiddenCopiesNoConclusion_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesNoConclusionCert = false := by decide

def RepeatedHiddenCopiesMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesMissingCycles_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesMissingCyclesCert = false := by decide

def RepeatedHiddenCopiesExtraCycleCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩, ⟨[false], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesExtraCycle_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesExtraCycleCert = false := by decide

def RepeatedHiddenCopiesWrongMemberCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false, true, true, true, true, true, true, true, true], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesWrongMember_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongMemberCert = false := by decide

def RepeatedHiddenCopiesWrongBlockCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 999, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesWrongBlock_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongBlockCert = false := by decide

def RepeatedHiddenCopiesWrongVertexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 999, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesWrongVertex_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongVertexCert = false := by decide

def RepeatedHiddenCopiesWrongLengthCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 3⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesWrongLength_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongLengthCert = false := by decide

def RepeatedHiddenCopiesRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0, 1, 0], 3⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesRepeatedPrefix_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesRepeatedPrefixCert = false := by decide

def RepeatedHiddenCopiesEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesEmptyWalk_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesEmptyWalkCert = false := by decide

def RepeatedHiddenCopiesZeroWalkCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0], 0⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesZeroWalk_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesZeroWalkCert = false := by decide

def RepeatedHiddenCopiesMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesMissingArithmetic_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesMissingArithmeticCert = false := by decide

def RepeatedHiddenCopiesExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩, ⟨1, 2, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesExtraArithmetic_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesExtraArithmeticCert = false := by decide

def RepeatedHiddenCopiesWrongGCDCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨2, 2, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesWrongGCD_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongGCDCert = false := by decide

def RepeatedHiddenCopiesWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 3, 2⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesWrongMultiplier_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongMultiplierCert = false := by decide

def RepeatedHiddenCopiesWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 3⟩, ⟨2, 1, 2⟩], 2, 1⟩))⟩
theorem RepeatedHiddenCopiesWrongStepValue_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongStepValueCert = false := by decide

def RepeatedHiddenCopiesWrongCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 3, 1⟩))⟩
theorem RepeatedHiddenCopiesWrongCalls_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongCallsCert = false := by decide

def RepeatedHiddenCopiesWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 2, 2⟩))⟩
theorem RepeatedHiddenCopiesWrongAdditionalCalls_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesWrongAdditionalCallsCert = false := by decide

def RepeatedHiddenCopiesZeroCallsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0], [⟨[false], (.preserved [])⟩, ⟨[true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 1, 0], 2⟩, ⟨[true], 0, [0, 1, 0], 2⟩], [⟨1, 2, 2⟩, ⟨2, 1, 2⟩], 0, 1⟩))⟩
theorem RepeatedHiddenCopiesZeroCalls_observed : U11.check RepeatedHiddenCopies RepeatedHiddenCopiesHidden RepeatedHiddenCopiesZeroCallsCert = false := by decide

def ScalarRepeats : Model := ⟨(.leaf 0), (.leaf []), (.leaf []), []⟩
def ScalarRepeatsHidden : List Action := [⟨[false], (.leaf [])⟩, ⟨[true, false], (.leaf [])⟩, ⟨[true, true], (.leaf [])⟩]
def ScalarRepeatsCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeats_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsCert = true := by decide
theorem ScalarRepeats_claim : U11.Claim ScalarRepeats ScalarRepeatsHidden ScalarRepeatsCert := U11.check_sound ScalarRepeats_observed

def ScalarRepeatsMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsMissingRequired_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsMissingRequiredCert = false := by decide

def ScalarRepeatsExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0, 999], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsExtraRequired_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsExtraRequiredCert = false := by decide

def ScalarRepeatsDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0, 0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsDuplicateRequired_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsDuplicateRequiredCert = false := by decide

def ScalarRepeatsMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsMissingEvidence_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsMissingEvidenceCert = false := by decide

def ScalarRepeatsExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩, ⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsExtraEvidence_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsExtraEvidenceCert = false := by decide

def ScalarRepeatsWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false, true, true, true, true, true, true, true, true], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsWrongMemberEvidence_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongMemberEvidenceCert = false := by decide

def ScalarRepeatsMissingForestsCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsMissingForests_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsMissingForestsCert = false := by decide

def ScalarRepeatsMissingClassesCert : U11.Certificate := ⟨[], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsMissingClasses_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsMissingClassesCert = false := by decide

def ScalarRepeatsNoConclusionCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], none⟩
theorem ScalarRepeatsNoConclusion_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsNoConclusionCert = false := by decide

def ScalarRepeatsMissingCyclesCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsMissingCycles_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsMissingCyclesCert = false := by decide

def ScalarRepeatsExtraCycleCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩, ⟨[false], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsExtraCycle_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsExtraCycleCert = false := by decide

def ScalarRepeatsWrongMemberCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false, true, true, true, true, true, true, true, true], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsWrongMember_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongMemberCert = false := by decide

def ScalarRepeatsWrongBlockCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 999, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsWrongBlock_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongBlockCert = false := by decide

def ScalarRepeatsWrongVertexCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 999], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsWrongVertex_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongVertexCert = false := by decide

def ScalarRepeatsWrongLengthCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 2⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsWrongLength_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongLengthCert = false := by decide

def ScalarRepeatsRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0, 0], 2⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsRepeatedPrefix_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsRepeatedPrefixCert = false := by decide

def ScalarRepeatsEmptyWalkCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsEmptyWalk_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsEmptyWalkCert = false := by decide

def ScalarRepeatsZeroWalkCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0], 0⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsZeroWalk_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsZeroWalkCert = false := by decide

def ScalarRepeatsMissingArithmeticCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [], 1, 0⟩))⟩
theorem ScalarRepeatsMissingArithmetic_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsMissingArithmeticCert = false := by decide

def ScalarRepeatsExtraArithmeticCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsExtraArithmetic_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsExtraArithmeticCert = false := by decide

def ScalarRepeatsWrongGCDCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨2, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsWrongGCD_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongGCDCert = false := by decide

def ScalarRepeatsWrongMultiplierCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 2, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsWrongMultiplier_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongMultiplierCert = false := by decide

def ScalarRepeatsWrongStepValueCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 2⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 0⟩))⟩
theorem ScalarRepeatsWrongStepValue_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongStepValueCert = false := by decide

def ScalarRepeatsWrongCallsCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 2, 0⟩))⟩
theorem ScalarRepeatsWrongCalls_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongCallsCert = false := by decide

def ScalarRepeatsWrongAdditionalCallsCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 1, 1⟩))⟩
theorem ScalarRepeatsWrongAdditionalCalls_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsWrongAdditionalCallsCert = false := by decide

def ScalarRepeatsZeroCallsCert : U11.Certificate := ⟨[⟨0, [[]]⟩], [[]], [0], [⟨[false], (.preserved [])⟩, ⟨[true, false], (.preserved [])⟩, ⟨[true, true], (.preserved [])⟩], (some (.returned ⟨[⟨[false], 0, [0, 0], 1⟩, ⟨[true, false], 0, [0, 0], 1⟩, ⟨[true, true], 0, [0, 0], 1⟩], [⟨1, 1, 1⟩, ⟨1, 1, 1⟩, ⟨1, 1, 1⟩], 0, 0⟩))⟩
theorem ScalarRepeatsZeroCalls_observed : U11.check ScalarRepeats ScalarRepeatsHidden ScalarRepeatsZeroCallsCert = false := by decide

def TailQuestion : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [true]), []⟩
def TailQuestionHidden : List Action := [⟨[], (.pair (.leaf [false]) (.leaf [false]))⟩]
def TailQuestionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestion_observed : U11.check TailQuestion TailQuestionHidden TailQuestionCert = true := by decide
theorem TailQuestion_claim : U11.Claim TailQuestion TailQuestionHidden TailQuestionCert := U11.check_sound TailQuestion_observed

def TailQuestionMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestionMissingRequired_observed : U11.check TailQuestion TailQuestionHidden TailQuestionMissingRequiredCert = false := by decide

def TailQuestionExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1, 999], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestionExtraRequired_observed : U11.check TailQuestion TailQuestionHidden TailQuestionExtraRequiredCert = false := by decide

def TailQuestionDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1, 1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestionDuplicateRequired_observed : U11.check TailQuestion TailQuestionHidden TailQuestionDuplicateRequiredCert = false := by decide

def TailQuestionMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [], (some (.obstructed ⟨[], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestionMissingEvidence_observed : U11.check TailQuestion TailQuestionHidden TailQuestionMissingEvidenceCert = false := by decide

def TailQuestionExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩, ⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestionExtraEvidence_observed : U11.check TailQuestion TailQuestionHidden TailQuestionExtraEvidenceCert = false := by decide

def TailQuestionWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[true, true, true, true, true, true, true, true], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestionWrongMemberEvidence_observed : U11.check TailQuestion TailQuestionHidden TailQuestionWrongMemberEvidenceCert = false := by decide

def TailQuestionMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestionMissingForests_observed : U11.check TailQuestion TailQuestionHidden TailQuestionMissingForestsCert = false := by decide

def TailQuestionMissingClassesCert : U11.Certificate := ⟨[], [[], []], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestionMissingClasses_observed : U11.check TailQuestion TailQuestionHidden TailQuestionMissingClassesCert = false := by decide

def TailQuestionNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩], none⟩
theorem TailQuestionNoConclusion_observed : U11.check TailQuestion TailQuestionHidden TailQuestionNoConclusionCert = false := by decide

def TailQuestionUnknownTailMemberCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[true, true, true, true, true, true, true, true], 1, [1, 0, 0], 1⟩))⟩
theorem TailQuestionUnknownTailMember_observed : U11.check TailQuestion TailQuestionHidden TailQuestionUnknownTailMemberCert = false := by decide

def TailQuestionWrongTailBlockCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 999, [1, 0, 0], 1⟩))⟩
theorem TailQuestionWrongTailBlock_observed : U11.check TailQuestion TailQuestionHidden TailQuestionWrongTailBlockCert = false := by decide

def TailQuestionWrongTailVertexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 999, 0], 1⟩))⟩
theorem TailQuestionWrongTailVertex_observed : U11.check TailQuestion TailQuestionHidden TailQuestionWrongTailVertexCert = false := by decide

def TailQuestionTailZeroIndexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 0⟩))⟩
theorem TailQuestionTailZeroIndex_observed : U11.check TailQuestion TailQuestionHidden TailQuestionTailZeroIndexCert = false := by decide

def TailQuestionTailUnknownIndexCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 0], 999⟩))⟩
theorem TailQuestionTailUnknownIndex_observed : U11.check TailQuestion TailQuestionHidden TailQuestionTailUnknownIndexCert = false := by decide

def TailQuestionTailRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 1, 0, 0], 1⟩))⟩
theorem TailQuestionTailRepeatedPrefix_observed : U11.check TailQuestion TailQuestionHidden TailQuestionTailRepeatedPrefixCert = false := by decide

def TailQuestionTailReturnsStartCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [1], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 1, [1, 0, 1], 1⟩))⟩
theorem TailQuestionTailReturnsStart_observed : U11.check TailQuestion TailQuestionHidden TailQuestionTailReturnsStartCert = false := by decide

def LongReturnTail : Model := ⟨(.pair (.pair (.leaf 0) (.leaf 0)) (.pair (.leaf 0) (.leaf 0))), (.leaf [false, false]), (.leaf [true, true]), []⟩
def LongReturnTailHidden : List Action := [⟨[], (.pair (.pair (.leaf [false, false]) (.leaf [false, false])) (.pair (.leaf [false, true]) (.leaf [true, false])))⟩]
def LongReturnTailCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTail_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailCert = true := by decide
theorem LongReturnTail_claim : U11.Claim LongReturnTail LongReturnTailHidden LongReturnTailCert := U11.check_sound LongReturnTail_observed

def LongReturnTailMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailMissingRequired_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailMissingRequiredCert = false := by decide

def LongReturnTailExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3, 999], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailExtraRequired_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailExtraRequiredCert = false := by decide

def LongReturnTailDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3, 3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailDuplicateRequired_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailDuplicateRequiredCert = false := by decide

def LongReturnTailMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailMissingEvidence_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailMissingEvidenceCert = false := by decide

def LongReturnTailExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩, ⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailExtraEvidence_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailExtraEvidenceCert = false := by decide

def LongReturnTailWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[true, true, true, true, true, true, true, true], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailWrongMemberEvidence_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailWrongMemberEvidenceCert = false := by decide

def LongReturnTailMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailMissingForests_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailMissingForestsCert = false := by decide

def LongReturnTailMissingClassesCert : U11.Certificate := ⟨[], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailMissingClasses_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailMissingClassesCert = false := by decide

def LongReturnTailNoConclusionCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], none⟩
theorem LongReturnTailNoConclusion_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailNoConclusionCert = false := by decide

def LongReturnTailUnknownTailMemberCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[true, true, true, true, true, true, true, true], 3, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailUnknownTailMember_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailUnknownTailMemberCert = false := by decide

def LongReturnTailWrongTailBlockCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 999, [3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailWrongTailBlock_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailWrongTailBlockCert = false := by decide

def LongReturnTailWrongTailVertexCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 999, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailWrongTailVertex_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailWrongTailVertexCert = false := by decide

def LongReturnTailTailZeroIndexCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 0⟩))⟩
theorem LongReturnTailTailZeroIndex_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailTailZeroIndexCert = false := by decide

def LongReturnTailTailUnknownIndexCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 0], 999⟩))⟩
theorem LongReturnTailTailUnknownIndex_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailTailUnknownIndexCert = false := by decide

def LongReturnTailTailRepeatedPrefixCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 3, 2, 1, 0, 0], 3⟩))⟩
theorem LongReturnTailTailRepeatedPrefix_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailTailRepeatedPrefixCert = false := by decide

def LongReturnTailTailReturnsStartCert : U11.Certificate := ⟨[⟨0, [[false, false]]⟩, ⟨0, [[false, true]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], [], []], [3], [⟨[], (.preserved [])⟩], (some (.obstructed ⟨[], 3, [3, 2, 1, 0, 3], 3⟩))⟩
theorem LongReturnTailTailReturnsStart_observed : U11.check LongReturnTail LongReturnTailHidden LongReturnTailTailReturnsStartCert = false := by decide

def ReturnBadPreservation : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.leaf [false]), [⟨[], [false], [true, false]⟩]⟩
def ReturnBadPreservationHidden : List Action := [⟨[], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, true])))⟩]
def ReturnBadPreservationCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [0], [⟨[], (.notPreserved [])⟩], none⟩
theorem ReturnBadPreservation_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationCert = true := by decide
theorem ReturnBadPreservation_claim : U11.Claim ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationCert := U11.check_sound ReturnBadPreservation_observed

def ReturnBadPreservationMissingRequiredCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [], [⟨[], (.notPreserved [])⟩], none⟩
theorem ReturnBadPreservationMissingRequired_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationMissingRequiredCert = false := by decide

def ReturnBadPreservationExtraRequiredCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [0, 999], [⟨[], (.notPreserved [])⟩], none⟩
theorem ReturnBadPreservationExtraRequired_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationExtraRequiredCert = false := by decide

def ReturnBadPreservationDuplicateRequiredCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [0, 0], [⟨[], (.notPreserved [])⟩], none⟩
theorem ReturnBadPreservationDuplicateRequired_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationDuplicateRequiredCert = false := by decide

def ReturnBadPreservationMissingEvidenceCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [0], [], none⟩
theorem ReturnBadPreservationMissingEvidence_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationMissingEvidenceCert = false := by decide

def ReturnBadPreservationExtraEvidenceCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [0], [⟨[], (.notPreserved [])⟩, ⟨[], (.notPreserved [])⟩], none⟩
theorem ReturnBadPreservationExtraEvidence_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationExtraEvidenceCert = false := by decide

def ReturnBadPreservationWrongMemberEvidenceCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [0], [⟨[true, true, true, true, true, true, true, true], (.notPreserved [])⟩], none⟩
theorem ReturnBadPreservationWrongMemberEvidence_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationWrongMemberEvidenceCert = false := by decide

def ReturnBadPreservationMissingForestsCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [], [0], [⟨[], (.notPreserved [])⟩], none⟩
theorem ReturnBadPreservationMissingForests_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationMissingForestsCert = false := by decide

def ReturnBadPreservationMissingClassesCert : U11.Certificate := ⟨[], [[⟨[], false⟩], []], [0], [⟨[], (.notPreserved [])⟩], none⟩
theorem ReturnBadPreservationMissingClasses_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationMissingClassesCert = false := by decide

def ReturnBadPreservationFalsePreservationCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [0], [⟨[], (.preserved [])⟩], none⟩
theorem ReturnBadPreservationFalsePreservation_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationFalsePreservationCert = false := by decide

def ReturnBadPreservationUnknownPreservationEdgeCert : U11.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [0], [⟨[], (.notPreserved [true, true, true, true, true, true, true, true])⟩], none⟩
theorem ReturnBadPreservationUnknownPreservationEdge_observed : U11.check ReturnBadPreservation ReturnBadPreservationHidden ReturnBadPreservationUnknownPreservationEdgeCert = false := by decide

end U11.ContractCases
