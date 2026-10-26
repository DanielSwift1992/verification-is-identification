-- Finite observations, not a proved Swift bridge.
import U9.Certificate
import U10.Negative
set_option maxRecDepth 10000
set_option maxHeartbeats 8000000
namespace U9.ContractCases
open U5
def PermutedPromise : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [false], [true, false]⟩]⟩
def PermutedPromiseMembers : List U9.Member := [⟨[], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩]
def PermutedPromisePromise : List Edge := [⟨[], [false], [true, true]⟩]
def PermutedPromiseCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem PermutedPromise_observed : U9.check PermutedPromise PermutedPromiseMembers PermutedPromisePromise PermutedPromiseCert = true := by decide
theorem PermutedPromise_verdict : (PermutedPromiseCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def PermutedPromiseMissingSourceClassesCert : U9.Certificate := ⟨[], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem PermutedPromiseMissingSourceClasses_observed : U9.check PermutedPromise PermutedPromiseMembers PermutedPromisePromise PermutedPromiseMissingSourceClassesCert = false := by decide
def PermutedPromiseMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem PermutedPromiseMissingSourceForests_observed : U9.check PermutedPromise PermutedPromiseMembers PermutedPromisePromise PermutedPromiseMissingSourceForestsCert = false := by decide
def PermutedPromiseMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], []⟩
theorem PermutedPromiseMissingMembers_observed : U9.check PermutedPromise PermutedPromiseMembers PermutedPromisePromise PermutedPromiseMissingMembersCert = false := by decide
def PermutedPromiseWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[false], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem PermutedPromiseWrongMember_observed : U9.check PermutedPromise PermutedPromiseMembers PermutedPromisePromise PermutedPromiseWrongMemberCert = false := by decide
def PermutedPromiseWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [999, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem PermutedPromiseWrongSourceClassIndex_observed : U9.check PermutedPromise PermutedPromiseMembers PermutedPromisePromise PermutedPromiseWrongSourceClassIndexCert = false := by decide
def PermutedPromiseMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem PermutedPromiseMissingOutputClasses_observed : U9.check PermutedPromise PermutedPromiseMembers PermutedPromisePromise PermutedPromiseMissingOutputClassesCert = false := by decide
def PermutedPromiseMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [], (.holds [(.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem PermutedPromiseMissingOutputConnections_observed : U9.check PermutedPromise PermutedPromiseMembers PermutedPromisePromise PermutedPromiseMissingOutputConnectionsCert = false := by decide
def PermutedPromiseWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [])⟩]⟩
theorem PermutedPromiseWrongPromise_observed : U9.check PermutedPromise PermutedPromiseMembers PermutedPromisePromise PermutedPromiseWrongPromiseCert = false := by decide
def PermutedOldRelation : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [false], [true, false]⟩]⟩
def PermutedOldRelationMembers : List U9.Member := [⟨[], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩]
def PermutedOldRelationPromise : List Edge := [⟨[], [false], [true, false]⟩]
def PermutedOldRelationCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [])⟩]⟩
theorem PermutedOldRelation_observed : U9.check PermutedOldRelation PermutedOldRelationMembers PermutedOldRelationPromise PermutedOldRelationCert = true := by decide
theorem PermutedOldRelation_verdict : (PermutedOldRelationCert.images.all (fun p => U9.verdict p.promise)) = false := by decide
def PermutedOldRelationMissingSourceClassesCert : U9.Certificate := ⟨[], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [])⟩]⟩
theorem PermutedOldRelationMissingSourceClasses_observed : U9.check PermutedOldRelation PermutedOldRelationMembers PermutedOldRelationPromise PermutedOldRelationMissingSourceClassesCert = false := by decide
def PermutedOldRelationMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [])⟩]⟩
theorem PermutedOldRelationMissingSourceForests_observed : U9.check PermutedOldRelation PermutedOldRelationMembers PermutedOldRelationPromise PermutedOldRelationMissingSourceForestsCert = false := by decide
def PermutedOldRelationMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], []⟩
theorem PermutedOldRelationMissingMembers_observed : U9.check PermutedOldRelation PermutedOldRelationMembers PermutedOldRelationPromise PermutedOldRelationMissingMembersCert = false := by decide
def PermutedOldRelationWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[false], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [])⟩]⟩
theorem PermutedOldRelationWrongMember_observed : U9.check PermutedOldRelation PermutedOldRelationMembers PermutedOldRelationPromise PermutedOldRelationWrongMemberCert = false := by decide
def PermutedOldRelationWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [999, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [])⟩]⟩
theorem PermutedOldRelationWrongSourceClassIndex_observed : U9.check PermutedOldRelation PermutedOldRelationMembers PermutedOldRelationPromise PermutedOldRelationWrongSourceClassIndexCert = false := by decide
def PermutedOldRelationMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [])⟩]⟩
theorem PermutedOldRelationMissingOutputClasses_observed : U9.check PermutedOldRelation PermutedOldRelationMembers PermutedOldRelationPromise PermutedOldRelationMissingOutputClassesCert = false := by decide
def PermutedOldRelationMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [], (.violated [])⟩]⟩
theorem PermutedOldRelationMissingOutputConnections_observed : U9.check PermutedOldRelation PermutedOldRelationMembers PermutedOldRelationPromise PermutedOldRelationMissingOutputConnectionsCert = false := by decide
def PermutedOldRelationWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [])⟩]⟩
theorem PermutedOldRelationWrongPromise_observed : U9.check PermutedOldRelation PermutedOldRelationMembers PermutedOldRelationPromise PermutedOldRelationWrongPromiseCert = false := by decide
def IndependentPromise : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.leaf [false]) (.leaf [true])), (.pair (.leaf [false]) (.leaf [true])), []⟩
def IndependentPromiseMembers : List U9.Member := [⟨[], (.pair (.leaf [false]) (.leaf [true]))⟩]
def IndependentPromisePromise : List Edge := [⟨[], [false], [true]⟩]
def IndependentPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.violated [])⟩]⟩
theorem IndependentPromise_observed : U9.check IndependentPromise IndependentPromiseMembers IndependentPromisePromise IndependentPromiseCert = true := by decide
theorem IndependentPromise_verdict : (IndependentPromiseCert.images.all (fun p => U9.verdict p.promise)) = false := by decide
def IndependentPromiseMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.violated [])⟩]⟩
theorem IndependentPromiseMissingSourceClasses_observed : U9.check IndependentPromise IndependentPromiseMembers IndependentPromisePromise IndependentPromiseMissingSourceClassesCert = false := by decide
def IndependentPromiseMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.violated [])⟩]⟩
theorem IndependentPromiseMissingSourceForests_observed : U9.check IndependentPromise IndependentPromiseMembers IndependentPromisePromise IndependentPromiseMissingSourceForestsCert = false := by decide
def IndependentPromiseMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem IndependentPromiseMissingMembers_observed : U9.check IndependentPromise IndependentPromiseMembers IndependentPromisePromise IndependentPromiseMissingMembersCert = false := by decide
def IndependentPromiseWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.violated [])⟩]⟩
theorem IndependentPromiseWrongMember_observed : U9.check IndependentPromise IndependentPromiseMembers IndependentPromisePromise IndependentPromiseWrongMemberCert = false := by decide
def IndependentPromiseWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [999, 1], [[], []], (.violated [])⟩]⟩
theorem IndependentPromiseWrongSourceClassIndex_observed : U9.check IndependentPromise IndependentPromiseMembers IndependentPromisePromise IndependentPromiseWrongSourceClassIndexCert = false := by decide
def IndependentPromiseMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [], [0, 1], [[], []], (.violated [])⟩]⟩
theorem IndependentPromiseMissingOutputClasses_observed : U9.check IndependentPromise IndependentPromiseMembers IndependentPromisePromise IndependentPromiseMissingOutputClassesCert = false := by decide
def IndependentPromiseMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [], (.violated [])⟩]⟩
theorem IndependentPromiseMissingOutputConnections_observed : U9.check IndependentPromise IndependentPromiseMembers IndependentPromisePromise IndependentPromiseMissingOutputConnectionsCert = false := by decide
def IndependentPromiseWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.holds [])⟩]⟩
theorem IndependentPromiseWrongPromise_observed : U9.check IndependentPromise IndependentPromiseMembers IndependentPromisePromise IndependentPromiseWrongPromiseCert = false := by decide
def UnrestrictedImage : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.leaf [false]) (.leaf [true])), (.pair (.leaf [false]) (.leaf [true])), []⟩
def UnrestrictedImageMembers : List U9.Member := [⟨[], (.pair (.leaf [false]) (.leaf [true]))⟩]
def UnrestrictedImagePromise : List Edge := []
def UnrestrictedImageCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.holds [])⟩]⟩
theorem UnrestrictedImage_observed : U9.check UnrestrictedImage UnrestrictedImageMembers UnrestrictedImagePromise UnrestrictedImageCert = true := by decide
theorem UnrestrictedImage_verdict : (UnrestrictedImageCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def UnrestrictedImageMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.holds [])⟩]⟩
theorem UnrestrictedImageMissingSourceClasses_observed : U9.check UnrestrictedImage UnrestrictedImageMembers UnrestrictedImagePromise UnrestrictedImageMissingSourceClassesCert = false := by decide
def UnrestrictedImageMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.holds [])⟩]⟩
theorem UnrestrictedImageMissingSourceForests_observed : U9.check UnrestrictedImage UnrestrictedImageMembers UnrestrictedImagePromise UnrestrictedImageMissingSourceForestsCert = false := by decide
def UnrestrictedImageMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem UnrestrictedImageMissingMembers_observed : U9.check UnrestrictedImage UnrestrictedImageMembers UnrestrictedImagePromise UnrestrictedImageMissingMembersCert = false := by decide
def UnrestrictedImageWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.holds [])⟩]⟩
theorem UnrestrictedImageWrongMember_observed : U9.check UnrestrictedImage UnrestrictedImageMembers UnrestrictedImagePromise UnrestrictedImageWrongMemberCert = false := by decide
def UnrestrictedImageWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [999, 1], [[], []], (.holds [])⟩]⟩
theorem UnrestrictedImageWrongSourceClassIndex_observed : U9.check UnrestrictedImage UnrestrictedImageMembers UnrestrictedImagePromise UnrestrictedImageWrongSourceClassIndexCert = false := by decide
def UnrestrictedImageMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [], [0, 1], [[], []], (.holds [])⟩]⟩
theorem UnrestrictedImageMissingOutputClasses_observed : U9.check UnrestrictedImage UnrestrictedImageMembers UnrestrictedImagePromise UnrestrictedImageMissingOutputClassesCert = false := by decide
def UnrestrictedImageMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [], (.holds [])⟩]⟩
theorem UnrestrictedImageMissingOutputConnections_observed : U9.check UnrestrictedImage UnrestrictedImageMembers UnrestrictedImagePromise UnrestrictedImageMissingOutputConnectionsCert = false := by decide
def DuplicateImage : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.leaf [false]) (.leaf [false])), (.pair (.leaf [false]) (.leaf [false])), []⟩
def DuplicateImageMembers : List U9.Member := [⟨[], (.pair (.leaf [false]) (.leaf [false]))⟩]
def DuplicateImagePromise : List Edge := [⟨[], [false], [true]⟩]
def DuplicateImageCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem DuplicateImage_observed : U9.check DuplicateImage DuplicateImageMembers DuplicateImagePromise DuplicateImageCert = true := by decide
theorem DuplicateImage_verdict : (DuplicateImageCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def DuplicateImageMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem DuplicateImageMissingSourceClasses_observed : U9.check DuplicateImage DuplicateImageMembers DuplicateImagePromise DuplicateImageMissingSourceClassesCert = false := by decide
def DuplicateImageMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem DuplicateImageMissingSourceForests_observed : U9.check DuplicateImage DuplicateImageMembers DuplicateImagePromise DuplicateImageMissingSourceForestsCert = false := by decide
def DuplicateImageMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem DuplicateImageMissingMembers_observed : U9.check DuplicateImage DuplicateImageMembers DuplicateImagePromise DuplicateImageMissingMembersCert = false := by decide
def DuplicateImageWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem DuplicateImageWrongMember_observed : U9.check DuplicateImage DuplicateImageMembers DuplicateImagePromise DuplicateImageWrongMemberCert = false := by decide
def DuplicateImageWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false], [true]]⟩], [999], [[.address]], (.holds [.address])⟩]⟩
theorem DuplicateImageWrongSourceClassIndex_observed : U9.check DuplicateImage DuplicateImageMembers DuplicateImagePromise DuplicateImageWrongSourceClassIndexCert = false := by decide
def DuplicateImageMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [], [0], [[.address]], (.holds [.address])⟩]⟩
theorem DuplicateImageMissingOutputClasses_observed : U9.check DuplicateImage DuplicateImageMembers DuplicateImagePromise DuplicateImageMissingOutputClassesCert = false := by decide
def DuplicateImageMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false], [true]]⟩], [0], [], (.holds [.address])⟩]⟩
theorem DuplicateImageMissingOutputConnections_observed : U9.check DuplicateImage DuplicateImageMembers DuplicateImagePromise DuplicateImageMissingOutputConnectionsCert = false := by decide
def DuplicateImageWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.violated [])⟩]⟩
theorem DuplicateImageWrongPromise_observed : U9.check DuplicateImage DuplicateImageMembers DuplicateImagePromise DuplicateImageWrongPromiseCert = false := by decide
def DuplicateOutputPlaces : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.leaf [false]) (.pair (.leaf [false]) (.leaf [true]))), (.pair (.leaf [false]) (.pair (.leaf [false]) (.leaf [true]))), []⟩
def DuplicateOutputPlacesMembers : List U9.Member := [⟨[], (.pair (.leaf [false]) (.pair (.leaf [false]) (.leaf [true])))⟩]
def DuplicateOutputPlacesPromise : List Edge := [⟨[], [false], [true, false]⟩]
def DuplicateOutputPlacesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem DuplicateOutputPlaces_observed : U9.check DuplicateOutputPlaces DuplicateOutputPlacesMembers DuplicateOutputPlacesPromise DuplicateOutputPlacesCert = true := by decide
theorem DuplicateOutputPlaces_verdict : (DuplicateOutputPlacesCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def DuplicateOutputPlacesMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem DuplicateOutputPlacesMissingSourceClasses_observed : U9.check DuplicateOutputPlaces DuplicateOutputPlacesMembers DuplicateOutputPlacesPromise DuplicateOutputPlacesMissingSourceClassesCert = false := by decide
def DuplicateOutputPlacesMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem DuplicateOutputPlacesMissingSourceForests_observed : U9.check DuplicateOutputPlaces DuplicateOutputPlacesMembers DuplicateOutputPlacesPromise DuplicateOutputPlacesMissingSourceForestsCert = false := by decide
def DuplicateOutputPlacesMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem DuplicateOutputPlacesMissingMembers_observed : U9.check DuplicateOutputPlaces DuplicateOutputPlacesMembers DuplicateOutputPlacesPromise DuplicateOutputPlacesMissingMembersCert = false := by decide
def DuplicateOutputPlacesWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem DuplicateOutputPlacesWrongMember_observed : U9.check DuplicateOutputPlaces DuplicateOutputPlacesMembers DuplicateOutputPlacesPromise DuplicateOutputPlacesWrongMemberCert = false := by decide
def DuplicateOutputPlacesWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [999, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem DuplicateOutputPlacesWrongSourceClassIndex_observed : U9.check DuplicateOutputPlaces DuplicateOutputPlacesMembers DuplicateOutputPlacesPromise DuplicateOutputPlacesWrongSourceClassIndexCert = false := by decide
def DuplicateOutputPlacesMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem DuplicateOutputPlacesMissingOutputClasses_observed : U9.check DuplicateOutputPlaces DuplicateOutputPlacesMembers DuplicateOutputPlacesPromise DuplicateOutputPlacesMissingOutputClassesCert = false := by decide
def DuplicateOutputPlacesMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [0, 1], [], (.holds [.address])⟩]⟩
theorem DuplicateOutputPlacesMissingOutputConnections_observed : U9.check DuplicateOutputPlaces DuplicateOutputPlacesMembers DuplicateOutputPlacesPromise DuplicateOutputPlacesMissingOutputConnectionsCert = false := by decide
def DuplicateOutputPlacesWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [0, 1], [[.address], []], (.violated [])⟩]⟩
theorem DuplicateOutputPlacesWrongPromise_observed : U9.check DuplicateOutputPlaces DuplicateOutputPlacesMembers DuplicateOutputPlacesPromise DuplicateOutputPlacesWrongPromiseCert = false := by decide
def LeftMarginal : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [false]), (.leaf [false]), []⟩
def LeftMarginalMembers : List U9.Member := [⟨[], (.leaf [false])⟩]
def LeftMarginalPromise : List Edge := []
def LeftMarginalCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem LeftMarginal_observed : U9.check LeftMarginal LeftMarginalMembers LeftMarginalPromise LeftMarginalCert = true := by decide
theorem LeftMarginal_verdict : (LeftMarginalCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def LeftMarginalMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem LeftMarginalMissingSourceClasses_observed : U9.check LeftMarginal LeftMarginalMembers LeftMarginalPromise LeftMarginalMissingSourceClassesCert = false := by decide
def LeftMarginalMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem LeftMarginalMissingSourceForests_observed : U9.check LeftMarginal LeftMarginalMembers LeftMarginalPromise LeftMarginalMissingSourceForestsCert = false := by decide
def LeftMarginalMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem LeftMarginalMissingMembers_observed : U9.check LeftMarginal LeftMarginalMembers LeftMarginalPromise LeftMarginalMissingMembersCert = false := by decide
def LeftMarginalWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem LeftMarginalWrongMember_observed : U9.check LeftMarginal LeftMarginalMembers LeftMarginalPromise LeftMarginalWrongMemberCert = false := by decide
def LeftMarginalWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[]]⟩], [999], [[]], (.holds [])⟩]⟩
theorem LeftMarginalWrongSourceClassIndex_observed : U9.check LeftMarginal LeftMarginalMembers LeftMarginalPromise LeftMarginalWrongSourceClassIndexCert = false := by decide
def LeftMarginalMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [], [0], [[]], (.holds [])⟩]⟩
theorem LeftMarginalMissingOutputClasses_observed : U9.check LeftMarginal LeftMarginalMembers LeftMarginalPromise LeftMarginalMissingOutputClassesCert = false := by decide
def LeftMarginalMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[]]⟩], [0], [], (.holds [])⟩]⟩
theorem LeftMarginalMissingOutputConnections_observed : U9.check LeftMarginal LeftMarginalMembers LeftMarginalPromise LeftMarginalMissingOutputConnectionsCert = false := by decide
def RightMarginal : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.leaf [true]), (.leaf [true]), []⟩
def RightMarginalMembers : List U9.Member := [⟨[], (.leaf [true])⟩]
def RightMarginalPromise : List Edge := []
def RightMarginalCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[]]⟩], [1], [[]], (.holds [])⟩]⟩
theorem RightMarginal_observed : U9.check RightMarginal RightMarginalMembers RightMarginalPromise RightMarginalCert = true := by decide
theorem RightMarginal_verdict : (RightMarginalCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def RightMarginalMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[]]⟩], [1], [[]], (.holds [])⟩]⟩
theorem RightMarginalMissingSourceClasses_observed : U9.check RightMarginal RightMarginalMembers RightMarginalPromise RightMarginalMissingSourceClassesCert = false := by decide
def RightMarginalMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[], [⟨0, [[]]⟩], [1], [[]], (.holds [])⟩]⟩
theorem RightMarginalMissingSourceForests_observed : U9.check RightMarginal RightMarginalMembers RightMarginalPromise RightMarginalMissingSourceForestsCert = false := by decide
def RightMarginalMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem RightMarginalMissingMembers_observed : U9.check RightMarginal RightMarginalMembers RightMarginalPromise RightMarginalMissingMembersCert = false := by decide
def RightMarginalWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[]]⟩], [1], [[]], (.holds [])⟩]⟩
theorem RightMarginalWrongMember_observed : U9.check RightMarginal RightMarginalMembers RightMarginalPromise RightMarginalWrongMemberCert = false := by decide
def RightMarginalWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[]]⟩], [999], [[]], (.holds [])⟩]⟩
theorem RightMarginalWrongSourceClassIndex_observed : U9.check RightMarginal RightMarginalMembers RightMarginalPromise RightMarginalWrongSourceClassIndexCert = false := by decide
def RightMarginalMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [], [1], [[]], (.holds [])⟩]⟩
theorem RightMarginalMissingOutputClasses_observed : U9.check RightMarginal RightMarginalMembers RightMarginalPromise RightMarginalMissingOutputClassesCert = false := by decide
def RightMarginalMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[]]⟩], [1], [], (.holds [])⟩]⟩
theorem RightMarginalMissingOutputConnections_observed : U9.check RightMarginal RightMarginalMembers RightMarginalPromise RightMarginalMissingOutputConnectionsCert = false := by decide
def AliasedImage : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.leaf [true]) (.leaf [false])), (.pair (.leaf [true]) (.leaf [false])), []⟩
def AliasedImageMembers : List U9.Member := [⟨[], (.pair (.leaf [true]) (.leaf [false]))⟩]
def AliasedImagePromise : List Edge := [⟨[], [false], [false]⟩]
def AliasedImageCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [[], []], (.holds [.address])⟩]⟩
theorem AliasedImage_observed : U9.check AliasedImage AliasedImageMembers AliasedImagePromise AliasedImageCert = true := by decide
theorem AliasedImage_verdict : (AliasedImageCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def AliasedImageMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [[], []], (.holds [.address])⟩]⟩
theorem AliasedImageMissingSourceClasses_observed : U9.check AliasedImage AliasedImageMembers AliasedImagePromise AliasedImageMissingSourceClassesCert = false := by decide
def AliasedImageMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [[], []], (.holds [.address])⟩]⟩
theorem AliasedImageMissingSourceForests_observed : U9.check AliasedImage AliasedImageMembers AliasedImagePromise AliasedImageMissingSourceForestsCert = false := by decide
def AliasedImageMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem AliasedImageMissingMembers_observed : U9.check AliasedImage AliasedImageMembers AliasedImagePromise AliasedImageMissingMembersCert = false := by decide
def AliasedImageWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [[], []], (.holds [.address])⟩]⟩
theorem AliasedImageWrongMember_observed : U9.check AliasedImage AliasedImageMembers AliasedImagePromise AliasedImageWrongMemberCert = false := by decide
def AliasedImageWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [999, 0], [[], []], (.holds [.address])⟩]⟩
theorem AliasedImageWrongSourceClassIndex_observed : U9.check AliasedImage AliasedImageMembers AliasedImagePromise AliasedImageWrongSourceClassIndexCert = false := by decide
def AliasedImageMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [], [1, 0], [[], []], (.holds [.address])⟩]⟩
theorem AliasedImageMissingOutputClasses_observed : U9.check AliasedImage AliasedImageMembers AliasedImagePromise AliasedImageMissingOutputClassesCert = false := by decide
def AliasedImageMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [], (.holds [.address])⟩]⟩
theorem AliasedImageMissingOutputConnections_observed : U9.check AliasedImage AliasedImageMembers AliasedImagePromise AliasedImageMissingOutputConnectionsCert = false := by decide
def AliasedImageWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [[], []], (.violated [])⟩]⟩
theorem AliasedImageWrongPromise_observed : U9.check AliasedImage AliasedImageMembers AliasedImagePromise AliasedImageWrongPromiseCert = false := by decide
def TwoSortImage : Model := ⟨(.pair (.leaf 0) (.leaf 1)), (.pair (.leaf [true]) (.leaf [false])), (.pair (.leaf [true]) (.leaf [false])), []⟩
def TwoSortImageMembers : List U9.Member := [⟨[], (.pair (.leaf [true]) (.leaf [false]))⟩]
def TwoSortImagePromise : List Edge := []
def TwoSortImageCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[], [⟨1, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [[], []], (.holds [])⟩]⟩
theorem TwoSortImage_observed : U9.check TwoSortImage TwoSortImageMembers TwoSortImagePromise TwoSortImageCert = true := by decide
theorem TwoSortImage_verdict : (TwoSortImageCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def TwoSortImageMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨1, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [[], []], (.holds [])⟩]⟩
theorem TwoSortImageMissingSourceClasses_observed : U9.check TwoSortImage TwoSortImageMembers TwoSortImagePromise TwoSortImageMissingSourceClassesCert = false := by decide
def TwoSortImageMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [], [⟨[], [⟨1, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [[], []], (.holds [])⟩]⟩
theorem TwoSortImageMissingSourceForests_observed : U9.check TwoSortImage TwoSortImageMembers TwoSortImagePromise TwoSortImageMissingSourceForestsCert = false := by decide
def TwoSortImageMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], []⟩
theorem TwoSortImageMissingMembers_observed : U9.check TwoSortImage TwoSortImageMembers TwoSortImagePromise TwoSortImageMissingMembersCert = false := by decide
def TwoSortImageWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[false], [⟨1, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [[], []], (.holds [])⟩]⟩
theorem TwoSortImageWrongMember_observed : U9.check TwoSortImage TwoSortImageMembers TwoSortImagePromise TwoSortImageWrongMemberCert = false := by decide
def TwoSortImageWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[], [⟨1, [[false]]⟩, ⟨0, [[true]]⟩], [999, 0], [[], []], (.holds [])⟩]⟩
theorem TwoSortImageWrongSourceClassIndex_observed : U9.check TwoSortImage TwoSortImageMembers TwoSortImagePromise TwoSortImageWrongSourceClassIndexCert = false := by decide
def TwoSortImageMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[], [], [1, 0], [[], []], (.holds [])⟩]⟩
theorem TwoSortImageMissingOutputClasses_observed : U9.check TwoSortImage TwoSortImageMembers TwoSortImagePromise TwoSortImageMissingOutputClassesCert = false := by decide
def TwoSortImageMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[], [⟨1, [[false]]⟩, ⟨0, [[true]]⟩], [1, 0], [], (.holds [])⟩]⟩
theorem TwoSortImageMissingOutputConnections_observed : U9.check TwoSortImage TwoSortImageMembers TwoSortImagePromise TwoSortImageMissingOutputConnectionsCert = false := by decide
def ScalarImage : Model := ⟨(.leaf 0), (.leaf []), (.leaf []), []⟩
def ScalarImageMembers : List U9.Member := [⟨[], (.leaf [])⟩]
def ScalarImagePromise : List Edge := [⟨[], [], []⟩]
def ScalarImageCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [.address])⟩]⟩
theorem ScalarImage_observed : U9.check ScalarImage ScalarImageMembers ScalarImagePromise ScalarImageCert = true := by decide
theorem ScalarImage_verdict : (ScalarImageCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def ScalarImageMissingSourceClassesCert : U9.Certificate := ⟨[], [[]], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [.address])⟩]⟩
theorem ScalarImageMissingSourceClasses_observed : U9.check ScalarImage ScalarImageMembers ScalarImagePromise ScalarImageMissingSourceClassesCert = false := by decide
def ScalarImageMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [.address])⟩]⟩
theorem ScalarImageMissingSourceForests_observed : U9.check ScalarImage ScalarImageMembers ScalarImagePromise ScalarImageMissingSourceForestsCert = false := by decide
def ScalarImageMissingMembersCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], []⟩
theorem ScalarImageMissingMembers_observed : U9.check ScalarImage ScalarImageMembers ScalarImagePromise ScalarImageMissingMembersCert = false := by decide
def ScalarImageWrongMemberCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[false], [⟨0, [[]]⟩], [0], [[]], (.holds [.address])⟩]⟩
theorem ScalarImageWrongMember_observed : U9.check ScalarImage ScalarImageMembers ScalarImagePromise ScalarImageWrongMemberCert = false := by decide
def ScalarImageWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[], [⟨0, [[]]⟩], [999], [[]], (.holds [.address])⟩]⟩
theorem ScalarImageWrongSourceClassIndex_observed : U9.check ScalarImage ScalarImageMembers ScalarImagePromise ScalarImageWrongSourceClassIndexCert = false := by decide
def ScalarImageMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[], [], [0], [[]], (.holds [.address])⟩]⟩
theorem ScalarImageMissingOutputClasses_observed : U9.check ScalarImage ScalarImageMembers ScalarImagePromise ScalarImageMissingOutputClassesCert = false := by decide
def ScalarImageMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[], [⟨0, [[]]⟩], [0], [], (.holds [.address])⟩]⟩
theorem ScalarImageMissingOutputConnections_observed : U9.check ScalarImage ScalarImageMembers ScalarImagePromise ScalarImageMissingOutputConnectionsCert = false := by decide
def ScalarImageWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.violated [])⟩]⟩
theorem ScalarImageWrongPromise_observed : U9.check ScalarImage ScalarImageMembers ScalarImagePromise ScalarImageWrongPromiseCert = false := by decide
def ChainedImage : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true]))), (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true]))), [⟨[false], [false], [true, false]⟩, ⟨[true], [true, false], [true, true]⟩]⟩
def ChainedImageMembers : List U9.Member := [⟨[], (.pair (.leaf [false]) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩]
def ChainedImagePromise : List Edge := [⟨[], [false], [true, true]⟩]
def ChainedImageCert : U9.Certificate := ⟨[⟨0, [[false], [true, false], [true, true]]⟩], [[⟨[false], false⟩, ⟨[true], false⟩]], [⟨[], [⟨0, [[false], [true, false], [true, true]]⟩], [0], [[(.sourceRelation [⟨[false], false⟩]), (.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])])⟩]⟩
theorem ChainedImage_observed : U9.check ChainedImage ChainedImageMembers ChainedImagePromise ChainedImageCert = true := by decide
theorem ChainedImage_verdict : (ChainedImageCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def ChainedImageMissingSourceClassesCert : U9.Certificate := ⟨[], [[⟨[false], false⟩, ⟨[true], false⟩]], [⟨[], [⟨0, [[false], [true, false], [true, true]]⟩], [0], [[(.sourceRelation [⟨[false], false⟩]), (.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])])⟩]⟩
theorem ChainedImageMissingSourceClasses_observed : U9.check ChainedImage ChainedImageMembers ChainedImagePromise ChainedImageMissingSourceClassesCert = false := by decide
def ChainedImageMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false], [true, true]]⟩], [], [⟨[], [⟨0, [[false], [true, false], [true, true]]⟩], [0], [[(.sourceRelation [⟨[false], false⟩]), (.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])])⟩]⟩
theorem ChainedImageMissingSourceForests_observed : U9.check ChainedImage ChainedImageMembers ChainedImagePromise ChainedImageMissingSourceForestsCert = false := by decide
def ChainedImageMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false], [true, false], [true, true]]⟩], [[⟨[false], false⟩, ⟨[true], false⟩]], []⟩
theorem ChainedImageMissingMembers_observed : U9.check ChainedImage ChainedImageMembers ChainedImagePromise ChainedImageMissingMembersCert = false := by decide
def ChainedImageWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false], [true, false], [true, true]]⟩], [[⟨[false], false⟩, ⟨[true], false⟩]], [⟨[false], [⟨0, [[false], [true, false], [true, true]]⟩], [0], [[(.sourceRelation [⟨[false], false⟩]), (.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])])⟩]⟩
theorem ChainedImageWrongMember_observed : U9.check ChainedImage ChainedImageMembers ChainedImagePromise ChainedImageWrongMemberCert = false := by decide
def ChainedImageWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false], [true, false], [true, true]]⟩], [[⟨[false], false⟩, ⟨[true], false⟩]], [⟨[], [⟨0, [[false], [true, false], [true, true]]⟩], [999], [[(.sourceRelation [⟨[false], false⟩]), (.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])])⟩]⟩
theorem ChainedImageWrongSourceClassIndex_observed : U9.check ChainedImage ChainedImageMembers ChainedImagePromise ChainedImageWrongSourceClassIndexCert = false := by decide
def ChainedImageMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false], [true, false], [true, true]]⟩], [[⟨[false], false⟩, ⟨[true], false⟩]], [⟨[], [], [0], [[(.sourceRelation [⟨[false], false⟩]), (.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])])⟩]⟩
theorem ChainedImageMissingOutputClasses_observed : U9.check ChainedImage ChainedImageMembers ChainedImagePromise ChainedImageMissingOutputClassesCert = false := by decide
def ChainedImageMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false], [true, true]]⟩], [[⟨[false], false⟩, ⟨[true], false⟩]], [⟨[], [⟨0, [[false], [true, false], [true, true]]⟩], [0], [], (.holds [(.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])])⟩]⟩
theorem ChainedImageMissingOutputConnections_observed : U9.check ChainedImage ChainedImageMembers ChainedImagePromise ChainedImageMissingOutputConnectionsCert = false := by decide
def ChainedImageWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false], [true, false], [true, true]]⟩], [[⟨[false], false⟩, ⟨[true], false⟩]], [⟨[], [⟨0, [[false], [true, false], [true, true]]⟩], [0], [[(.sourceRelation [⟨[false], false⟩]), (.sourceRelation [⟨[false], false⟩, ⟨[true], false⟩])]], (.violated [])⟩]⟩
theorem ChainedImageWrongPromise_observed : U9.check ChainedImage ChainedImageMembers ChainedImagePromise ChainedImageWrongPromiseCert = false := by decide
def OmittedIndependentPlaces : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.leaf [false]), (.leaf [false]), []⟩
def OmittedIndependentPlacesMembers : List U9.Member := [⟨[], (.leaf [false])⟩]
def OmittedIndependentPlacesPromise : List Edge := []
def OmittedIndependentPlacesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem OmittedIndependentPlaces_observed : U9.check OmittedIndependentPlaces OmittedIndependentPlacesMembers OmittedIndependentPlacesPromise OmittedIndependentPlacesCert = true := by decide
theorem OmittedIndependentPlaces_verdict : (OmittedIndependentPlacesCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def OmittedIndependentPlacesMissingSourceClassesCert : U9.Certificate := ⟨[], [[], [], []], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem OmittedIndependentPlacesMissingSourceClasses_observed : U9.check OmittedIndependentPlaces OmittedIndependentPlacesMembers OmittedIndependentPlacesPromise OmittedIndependentPlacesMissingSourceClassesCert = false := by decide
def OmittedIndependentPlacesMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem OmittedIndependentPlacesMissingSourceForests_observed : U9.check OmittedIndependentPlaces OmittedIndependentPlacesMembers OmittedIndependentPlacesPromise OmittedIndependentPlacesMissingSourceForestsCert = false := by decide
def OmittedIndependentPlacesMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], []⟩
theorem OmittedIndependentPlacesMissingMembers_observed : U9.check OmittedIndependentPlaces OmittedIndependentPlacesMembers OmittedIndependentPlacesPromise OmittedIndependentPlacesMissingMembersCert = false := by decide
def OmittedIndependentPlacesWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem OmittedIndependentPlacesWrongMember_observed : U9.check OmittedIndependentPlaces OmittedIndependentPlacesMembers OmittedIndependentPlacesPromise OmittedIndependentPlacesWrongMemberCert = false := by decide
def OmittedIndependentPlacesWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], [⟨0, [[]]⟩], [999], [[]], (.holds [])⟩]⟩
theorem OmittedIndependentPlacesWrongSourceClassIndex_observed : U9.check OmittedIndependentPlaces OmittedIndependentPlacesMembers OmittedIndependentPlacesPromise OmittedIndependentPlacesWrongSourceClassIndexCert = false := by decide
def OmittedIndependentPlacesMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], [], [0], [[]], (.holds [])⟩]⟩
theorem OmittedIndependentPlacesMissingOutputClasses_observed : U9.check OmittedIndependentPlaces OmittedIndependentPlacesMembers OmittedIndependentPlacesPromise OmittedIndependentPlacesMissingOutputClassesCert = false := by decide
def OmittedIndependentPlacesMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[], [⟨0, [[]]⟩], [0], [], (.holds [])⟩]⟩
theorem OmittedIndependentPlacesMissingOutputConnections_observed : U9.check OmittedIndependentPlaces OmittedIndependentPlacesMembers OmittedIndependentPlacesPromise OmittedIndependentPlacesMissingOutputConnectionsCert = false := by decide
def HiddenPairPromise : Model := ⟨(.pair (.pair (.leaf 0) (.leaf 0)) (.pair (.leaf 0) (.leaf 0))), (.pair (.pair (.leaf [false, false]) (.leaf [false, true])) (.pair (.leaf [true, false]) (.leaf [true, true]))), (.pair (.pair (.leaf [false, false]) (.leaf [false, true])) (.pair (.leaf [true, false]) (.leaf [true, true]))), [⟨[false], [false, false], [false, true]⟩, ⟨[true], [true, false], [true, true]⟩]⟩
def HiddenPairPromiseMembers : List U9.Member := [⟨[false], (.pair (.pair (.leaf [false, false]) (.leaf [false, true])) (.pair (.leaf [true, false]) (.leaf [true, true])))⟩, ⟨[true], (.pair (.pair (.leaf [true, false]) (.leaf [true, true])) (.pair (.leaf [false, false]) (.leaf [false, true])))⟩]
def HiddenPairPromisePromise : List Edge := [⟨[], [false, false], [false, true]⟩]
def HiddenPairPromiseCert : U9.Certificate := ⟨[⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [[⟨[false], false⟩], [⟨[true], false⟩]], [⟨[false], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [0, 1], [[(.sourceRelation [⟨[false], false⟩])], [(.sourceRelation [⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩])])⟩, ⟨[true], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [1, 0], [[(.sourceRelation [⟨[true], false⟩])], [(.sourceRelation [⟨[false], false⟩])]], (.holds [(.sourceRelation [⟨[true], false⟩])])⟩]⟩
theorem HiddenPairPromise_observed : U9.check HiddenPairPromise HiddenPairPromiseMembers HiddenPairPromisePromise HiddenPairPromiseCert = true := by decide
theorem HiddenPairPromise_verdict : (HiddenPairPromiseCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def HiddenPairPromiseMissingSourceClassesCert : U9.Certificate := ⟨[], [[⟨[false], false⟩], [⟨[true], false⟩]], [⟨[false], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [0, 1], [[(.sourceRelation [⟨[false], false⟩])], [(.sourceRelation [⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩])])⟩, ⟨[true], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [1, 0], [[(.sourceRelation [⟨[true], false⟩])], [(.sourceRelation [⟨[false], false⟩])]], (.holds [(.sourceRelation [⟨[true], false⟩])])⟩]⟩
theorem HiddenPairPromiseMissingSourceClasses_observed : U9.check HiddenPairPromise HiddenPairPromiseMembers HiddenPairPromisePromise HiddenPairPromiseMissingSourceClassesCert = false := by decide
def HiddenPairPromiseMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [], [⟨[false], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [0, 1], [[(.sourceRelation [⟨[false], false⟩])], [(.sourceRelation [⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩])])⟩, ⟨[true], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [1, 0], [[(.sourceRelation [⟨[true], false⟩])], [(.sourceRelation [⟨[false], false⟩])]], (.holds [(.sourceRelation [⟨[true], false⟩])])⟩]⟩
theorem HiddenPairPromiseMissingSourceForests_observed : U9.check HiddenPairPromise HiddenPairPromiseMembers HiddenPairPromisePromise HiddenPairPromiseMissingSourceForestsCert = false := by decide
def HiddenPairPromiseMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [[⟨[false], false⟩], [⟨[true], false⟩]], []⟩
theorem HiddenPairPromiseMissingMembers_observed : U9.check HiddenPairPromise HiddenPairPromiseMembers HiddenPairPromisePromise HiddenPairPromiseMissingMembersCert = false := by decide
def HiddenPairPromiseWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [[⟨[false], false⟩], [⟨[true], false⟩]], [⟨[false, false], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [0, 1], [[(.sourceRelation [⟨[false], false⟩])], [(.sourceRelation [⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩])])⟩, ⟨[true], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [1, 0], [[(.sourceRelation [⟨[true], false⟩])], [(.sourceRelation [⟨[false], false⟩])]], (.holds [(.sourceRelation [⟨[true], false⟩])])⟩]⟩
theorem HiddenPairPromiseWrongMember_observed : U9.check HiddenPairPromise HiddenPairPromiseMembers HiddenPairPromisePromise HiddenPairPromiseWrongMemberCert = false := by decide
def HiddenPairPromiseWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [[⟨[false], false⟩], [⟨[true], false⟩]], [⟨[false], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [999, 1], [[(.sourceRelation [⟨[false], false⟩])], [(.sourceRelation [⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩])])⟩, ⟨[true], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [1, 0], [[(.sourceRelation [⟨[true], false⟩])], [(.sourceRelation [⟨[false], false⟩])]], (.holds [(.sourceRelation [⟨[true], false⟩])])⟩]⟩
theorem HiddenPairPromiseWrongSourceClassIndex_observed : U9.check HiddenPairPromise HiddenPairPromiseMembers HiddenPairPromisePromise HiddenPairPromiseWrongSourceClassIndexCert = false := by decide
def HiddenPairPromiseMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [[⟨[false], false⟩], [⟨[true], false⟩]], [⟨[false], [], [0, 1], [[(.sourceRelation [⟨[false], false⟩])], [(.sourceRelation [⟨[true], false⟩])]], (.holds [(.sourceRelation [⟨[false], false⟩])])⟩, ⟨[true], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [1, 0], [[(.sourceRelation [⟨[true], false⟩])], [(.sourceRelation [⟨[false], false⟩])]], (.holds [(.sourceRelation [⟨[true], false⟩])])⟩]⟩
theorem HiddenPairPromiseMissingOutputClasses_observed : U9.check HiddenPairPromise HiddenPairPromiseMembers HiddenPairPromisePromise HiddenPairPromiseMissingOutputClassesCert = false := by decide
def HiddenPairPromiseMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [[⟨[false], false⟩], [⟨[true], false⟩]], [⟨[false], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [0, 1], [], (.holds [(.sourceRelation [⟨[false], false⟩])])⟩, ⟨[true], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [1, 0], [[(.sourceRelation [⟨[true], false⟩])], [(.sourceRelation [⟨[false], false⟩])]], (.holds [(.sourceRelation [⟨[true], false⟩])])⟩]⟩
theorem HiddenPairPromiseMissingOutputConnections_observed : U9.check HiddenPairPromise HiddenPairPromiseMembers HiddenPairPromisePromise HiddenPairPromiseMissingOutputConnectionsCert = false := by decide
def HiddenPairPromiseWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [[⟨[false], false⟩], [⟨[true], false⟩]], [⟨[false], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [0, 1], [[(.sourceRelation [⟨[false], false⟩])], [(.sourceRelation [⟨[true], false⟩])]], (.violated [])⟩, ⟨[true], [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩], [1, 0], [[(.sourceRelation [⟨[true], false⟩])], [(.sourceRelation [⟨[false], false⟩])]], (.holds [(.sourceRelation [⟨[true], false⟩])])⟩]⟩
theorem HiddenPairPromiseWrongPromise_observed : U9.check HiddenPairPromise HiddenPairPromiseMembers HiddenPairPromisePromise HiddenPairPromiseWrongPromiseCert = false := by decide
def HiddenMixedPromise : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.leaf [false]) (.leaf [true])), (.pair (.leaf [false]) (.leaf [true])), []⟩
def HiddenMixedPromiseMembers : List U9.Member := [⟨[false], (.pair (.leaf [false]) (.leaf [true]))⟩, ⟨[true], (.pair (.leaf [false]) (.leaf [false]))⟩]
def HiddenMixedPromisePromise : List Edge := [⟨[], [false], [true]⟩]
def HiddenMixedPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.violated [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenMixedPromise_observed : U9.check HiddenMixedPromise HiddenMixedPromiseMembers HiddenMixedPromisePromise HiddenMixedPromiseCert = true := by decide
theorem HiddenMixedPromise_verdict : (HiddenMixedPromiseCert.images.all (fun p => U9.verdict p.promise)) = false := by decide
def HiddenMixedPromiseMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.violated [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenMixedPromiseMissingSourceClasses_observed : U9.check HiddenMixedPromise HiddenMixedPromiseMembers HiddenMixedPromisePromise HiddenMixedPromiseMissingSourceClassesCert = false := by decide
def HiddenMixedPromiseMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.violated [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenMixedPromiseMissingSourceForests_observed : U9.check HiddenMixedPromise HiddenMixedPromiseMembers HiddenMixedPromisePromise HiddenMixedPromiseMissingSourceForestsCert = false := by decide
def HiddenMixedPromiseMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem HiddenMixedPromiseMissingMembers_observed : U9.check HiddenMixedPromise HiddenMixedPromiseMembers HiddenMixedPromisePromise HiddenMixedPromiseMissingMembersCert = false := by decide
def HiddenMixedPromiseWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false, false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.violated [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenMixedPromiseWrongMember_observed : U9.check HiddenMixedPromise HiddenMixedPromiseMembers HiddenMixedPromisePromise HiddenMixedPromiseWrongMemberCert = false := by decide
def HiddenMixedPromiseWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [999, 1], [[], []], (.violated [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenMixedPromiseWrongSourceClassIndex_observed : U9.check HiddenMixedPromise HiddenMixedPromiseMembers HiddenMixedPromisePromise HiddenMixedPromiseWrongSourceClassIndexCert = false := by decide
def HiddenMixedPromiseMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [], [0, 1], [[], []], (.violated [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenMixedPromiseMissingOutputClasses_observed : U9.check HiddenMixedPromise HiddenMixedPromiseMembers HiddenMixedPromisePromise HiddenMixedPromiseMissingOutputClassesCert = false := by decide
def HiddenMixedPromiseMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [], (.violated [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenMixedPromiseMissingOutputConnections_observed : U9.check HiddenMixedPromise HiddenMixedPromiseMembers HiddenMixedPromisePromise HiddenMixedPromiseMissingOutputConnectionsCert = false := by decide
def HiddenMixedPromiseWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [0, 1], [[], []], (.holds [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenMixedPromiseWrongPromise_observed : U9.check HiddenMixedPromise HiddenMixedPromiseMembers HiddenMixedPromisePromise HiddenMixedPromiseWrongPromiseCert = false := by decide
def HiddenDifferentOutputShape : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.pair (.leaf [false]) (.leaf [false])), (.pair (.leaf [false]) (.leaf [false])), []⟩
def HiddenDifferentOutputShapeMembers : List U9.Member := [⟨[false], (.pair (.leaf [false]) (.leaf [false]))⟩, ⟨[true], (.pair (.leaf [true, false]) (.leaf [true, false]))⟩]
def HiddenDifferentOutputShapePromise : List Edge := [⟨[], [false], [true]⟩]
def HiddenDifferentOutputShapeCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [1], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenDifferentOutputShape_observed : U9.check HiddenDifferentOutputShape HiddenDifferentOutputShapeMembers HiddenDifferentOutputShapePromise HiddenDifferentOutputShapeCert = true := by decide
theorem HiddenDifferentOutputShape_verdict : (HiddenDifferentOutputShapeCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def HiddenDifferentOutputShapeMissingSourceClassesCert : U9.Certificate := ⟨[], [[], [], []], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [1], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenDifferentOutputShapeMissingSourceClasses_observed : U9.check HiddenDifferentOutputShape HiddenDifferentOutputShapeMembers HiddenDifferentOutputShapePromise HiddenDifferentOutputShapeMissingSourceClassesCert = false := by decide
def HiddenDifferentOutputShapeMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [1], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenDifferentOutputShapeMissingSourceForests_observed : U9.check HiddenDifferentOutputShape HiddenDifferentOutputShapeMembers HiddenDifferentOutputShapePromise HiddenDifferentOutputShapeMissingSourceForestsCert = false := by decide
def HiddenDifferentOutputShapeMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], []⟩
theorem HiddenDifferentOutputShapeMissingMembers_observed : U9.check HiddenDifferentOutputShape HiddenDifferentOutputShapeMembers HiddenDifferentOutputShapePromise HiddenDifferentOutputShapeMissingMembersCert = false := by decide
def HiddenDifferentOutputShapeWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false, false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [1], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenDifferentOutputShapeWrongMember_observed : U9.check HiddenDifferentOutputShape HiddenDifferentOutputShapeMembers HiddenDifferentOutputShapePromise HiddenDifferentOutputShapeWrongMemberCert = false := by decide
def HiddenDifferentOutputShapeWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], [⟨0, [[false], [true]]⟩], [999], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [1], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenDifferentOutputShapeWrongSourceClassIndex_observed : U9.check HiddenDifferentOutputShape HiddenDifferentOutputShapeMembers HiddenDifferentOutputShapePromise HiddenDifferentOutputShapeWrongSourceClassIndexCert = false := by decide
def HiddenDifferentOutputShapeMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], [], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [1], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenDifferentOutputShapeMissingOutputClasses_observed : U9.check HiddenDifferentOutputShape HiddenDifferentOutputShapeMembers HiddenDifferentOutputShapePromise HiddenDifferentOutputShapeMissingOutputClassesCert = false := by decide
def HiddenDifferentOutputShapeMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [1], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenDifferentOutputShapeMissingOutputConnections_observed : U9.check HiddenDifferentOutputShape HiddenDifferentOutputShapeMembers HiddenDifferentOutputShapePromise HiddenDifferentOutputShapeMissingOutputConnectionsCert = false := by decide
def HiddenDifferentOutputShapeWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true, false]]⟩, ⟨0, [[true, true]]⟩], [[], [], []], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.violated [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [1], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenDifferentOutputShapeWrongPromise_observed : U9.check HiddenDifferentOutputShape HiddenDifferentOutputShapeMembers HiddenDifferentOutputShapePromise HiddenDifferentOutputShapeWrongPromiseCert = false := by decide
def HiddenScalarOutput : Model := ⟨(.leaf 0), (.pair (.leaf []) (.leaf [])), (.pair (.leaf []) (.leaf [])), []⟩
def HiddenScalarOutputMembers : List U9.Member := [⟨[false], (.pair (.leaf []) (.leaf []))⟩, ⟨[true], (.pair (.leaf []) (.leaf []))⟩]
def HiddenScalarOutputPromise : List Edge := [⟨[], [false], [true]⟩]
def HiddenScalarOutputCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenScalarOutput_observed : U9.check HiddenScalarOutput HiddenScalarOutputMembers HiddenScalarOutputPromise HiddenScalarOutputCert = true := by decide
theorem HiddenScalarOutput_verdict : (HiddenScalarOutputCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def HiddenScalarOutputMissingSourceClassesCert : U9.Certificate := ⟨[], [[]], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenScalarOutputMissingSourceClasses_observed : U9.check HiddenScalarOutput HiddenScalarOutputMembers HiddenScalarOutputPromise HiddenScalarOutputMissingSourceClassesCert = false := by decide
def HiddenScalarOutputMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenScalarOutputMissingSourceForests_observed : U9.check HiddenScalarOutput HiddenScalarOutputMembers HiddenScalarOutputPromise HiddenScalarOutputMissingSourceForestsCert = false := by decide
def HiddenScalarOutputMissingMembersCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], []⟩
theorem HiddenScalarOutputMissingMembers_observed : U9.check HiddenScalarOutput HiddenScalarOutputMembers HiddenScalarOutputPromise HiddenScalarOutputMissingMembersCert = false := by decide
def HiddenScalarOutputWrongMemberCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[false, false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenScalarOutputWrongMember_observed : U9.check HiddenScalarOutput HiddenScalarOutputMembers HiddenScalarOutputPromise HiddenScalarOutputWrongMemberCert = false := by decide
def HiddenScalarOutputWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[false], [⟨0, [[false], [true]]⟩], [999], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenScalarOutputWrongSourceClassIndex_observed : U9.check HiddenScalarOutput HiddenScalarOutputMembers HiddenScalarOutputPromise HiddenScalarOutputWrongSourceClassIndexCert = false := by decide
def HiddenScalarOutputMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[false], [], [0], [[.address]], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenScalarOutputMissingOutputClasses_observed : U9.check HiddenScalarOutput HiddenScalarOutputMembers HiddenScalarOutputPromise HiddenScalarOutputMissingOutputClassesCert = false := by decide
def HiddenScalarOutputMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [], (.holds [.address])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenScalarOutputMissingOutputConnections_observed : U9.check HiddenScalarOutput HiddenScalarOutputMembers HiddenScalarOutputPromise HiddenScalarOutputMissingOutputConnectionsCert = false := by decide
def HiddenScalarOutputWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[]]⟩], [[]], [⟨[false], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.violated [])⟩, ⟨[true], [⟨0, [[false], [true]]⟩], [0], [[.address]], (.holds [.address])⟩]⟩
theorem HiddenScalarOutputWrongPromise_observed : U9.check HiddenScalarOutput HiddenScalarOutputMembers HiddenScalarOutputPromise HiddenScalarOutputWrongPromiseCert = false := by decide
def MultiImagePromise : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [false], [true, false]⟩]⟩
def MultiImagePromiseMembers : List U9.Member := [⟨[], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩]
def MultiImagePromisePromise : List Edge := [⟨[false], [false], [true, true]⟩, ⟨[true], [false], [true, true]⟩]
def MultiImagePromiseCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩]), (.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem MultiImagePromise_observed : U9.check MultiImagePromise MultiImagePromiseMembers MultiImagePromisePromise MultiImagePromiseCert = true := by decide
theorem MultiImagePromise_verdict : (MultiImagePromiseCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def MultiImagePromiseMissingSourceClassesCert : U9.Certificate := ⟨[], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩]), (.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem MultiImagePromiseMissingSourceClasses_observed : U9.check MultiImagePromise MultiImagePromiseMembers MultiImagePromisePromise MultiImagePromiseMissingSourceClassesCert = false := by decide
def MultiImagePromiseMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩]), (.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem MultiImagePromiseMissingSourceForests_observed : U9.check MultiImagePromise MultiImagePromiseMembers MultiImagePromisePromise MultiImagePromiseMissingSourceForestsCert = false := by decide
def MultiImagePromiseMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], []⟩
theorem MultiImagePromiseMissingMembers_observed : U9.check MultiImagePromise MultiImagePromiseMembers MultiImagePromisePromise MultiImagePromiseMissingMembersCert = false := by decide
def MultiImagePromiseWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[false], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩]), (.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem MultiImagePromiseWrongMember_observed : U9.check MultiImagePromise MultiImagePromiseMembers MultiImagePromisePromise MultiImagePromiseWrongMemberCert = false := by decide
def MultiImagePromiseWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [999, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩]), (.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem MultiImagePromiseWrongSourceClassIndex_observed : U9.check MultiImagePromise MultiImagePromiseMembers MultiImagePromisePromise MultiImagePromiseWrongSourceClassIndexCert = false := by decide
def MultiImagePromiseMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [(.sourceRelation [⟨[], false⟩]), (.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem MultiImagePromiseMissingOutputClasses_observed : U9.check MultiImagePromise MultiImagePromiseMembers MultiImagePromisePromise MultiImagePromiseMissingOutputClassesCert = false := by decide
def MultiImagePromiseMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [], (.holds [(.sourceRelation [⟨[], false⟩]), (.sourceRelation [⟨[], false⟩])])⟩]⟩
theorem MultiImagePromiseMissingOutputConnections_observed : U9.check MultiImagePromise MultiImagePromiseMembers MultiImagePromisePromise MultiImagePromiseMissingOutputConnectionsCert = false := by decide
def MultiImagePromiseWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [false])⟩]⟩
theorem MultiImagePromiseWrongPromise_observed : U9.check MultiImagePromise MultiImagePromiseMembers MultiImagePromisePromise MultiImagePromiseWrongPromiseCert = false := by decide
def MixedImagePromises : Model := ⟨(.pair (.leaf 0) (.pair (.leaf 0) (.leaf 0))), (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false]))), [⟨[], [false], [true, false]⟩]⟩
def MixedImagePromisesMembers : List U9.Member := [⟨[], (.pair (.leaf [false]) (.pair (.leaf [true, true]) (.leaf [true, false])))⟩]
def MixedImagePromisesPromise : List Edge := [⟨[false], [false], [true, true]⟩, ⟨[true], [false], [true, false]⟩]
def MixedImagePromisesCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [true])⟩]⟩
theorem MixedImagePromises_observed : U9.check MixedImagePromises MixedImagePromisesMembers MixedImagePromisesPromise MixedImagePromisesCert = true := by decide
theorem MixedImagePromises_verdict : (MixedImagePromisesCert.images.all (fun p => U9.verdict p.promise)) = false := by decide
def MixedImagePromisesMissingSourceClassesCert : U9.Certificate := ⟨[], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [true])⟩]⟩
theorem MixedImagePromisesMissingSourceClasses_observed : U9.check MixedImagePromises MixedImagePromisesMembers MixedImagePromisesPromise MixedImagePromisesMissingSourceClassesCert = false := by decide
def MixedImagePromisesMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [true])⟩]⟩
theorem MixedImagePromisesMissingSourceForests_observed : U9.check MixedImagePromises MixedImagePromisesMembers MixedImagePromisesPromise MixedImagePromisesMissingSourceForestsCert = false := by decide
def MixedImagePromisesMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], []⟩
theorem MixedImagePromisesMissingMembers_observed : U9.check MixedImagePromises MixedImagePromisesMembers MixedImagePromisesPromise MixedImagePromisesMissingMembersCert = false := by decide
def MixedImagePromisesWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[false], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [true])⟩]⟩
theorem MixedImagePromisesWrongMember_observed : U9.check MixedImagePromises MixedImagePromisesMembers MixedImagePromisesPromise MixedImagePromisesWrongMemberCert = false := by decide
def MixedImagePromisesWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [999, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [true])⟩]⟩
theorem MixedImagePromisesWrongSourceClassIndex_observed : U9.check MixedImagePromises MixedImagePromisesMembers MixedImagePromisesPromise MixedImagePromisesWrongSourceClassIndexCert = false := by decide
def MixedImagePromisesMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.violated [true])⟩]⟩
theorem MixedImagePromisesMissingOutputClasses_observed : U9.check MixedImagePromises MixedImagePromisesMembers MixedImagePromisesPromise MixedImagePromisesMissingOutputClassesCert = false := by decide
def MixedImagePromisesMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [], (.violated [true])⟩]⟩
theorem MixedImagePromisesMissingOutputConnections_observed : U9.check MixedImagePromises MixedImagePromisesMembers MixedImagePromisesPromise MixedImagePromisesMissingOutputConnectionsCert = false := by decide
def MixedImagePromisesWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false], [true, false]]⟩, ⟨0, [[true, true]]⟩], [[⟨[], false⟩], []], [⟨[], [⟨0, [[false], [true, true]]⟩, ⟨0, [[true, false]]⟩], [0, 1], [[(.sourceRelation [⟨[], false⟩])], []], (.holds [])⟩]⟩
theorem MixedImagePromisesWrongPromise_observed : U9.check MixedImagePromises MixedImagePromisesMembers MixedImagePromisesPromise MixedImagePromisesWrongPromiseCert = false := by decide
def OmittedSortImage : Model := ⟨(.pair (.leaf 0) (.leaf 1)), (.leaf [false]), (.leaf [false]), []⟩
def OmittedSortImageMembers : List U9.Member := [⟨[], (.leaf [false])⟩]
def OmittedSortImagePromise : List Edge := []
def OmittedSortImageCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem OmittedSortImage_observed : U9.check OmittedSortImage OmittedSortImageMembers OmittedSortImagePromise OmittedSortImageCert = true := by decide
theorem OmittedSortImage_verdict : (OmittedSortImageCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def OmittedSortImageMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem OmittedSortImageMissingSourceClasses_observed : U9.check OmittedSortImage OmittedSortImageMembers OmittedSortImagePromise OmittedSortImageMissingSourceClassesCert = false := by decide
def OmittedSortImageMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [], [⟨[], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem OmittedSortImageMissingSourceForests_observed : U9.check OmittedSortImage OmittedSortImageMembers OmittedSortImagePromise OmittedSortImageMissingSourceForestsCert = false := by decide
def OmittedSortImageMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], []⟩
theorem OmittedSortImageMissingMembers_observed : U9.check OmittedSortImage OmittedSortImageMembers OmittedSortImagePromise OmittedSortImageMissingMembersCert = false := by decide
def OmittedSortImageWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[]]⟩], [0], [[]], (.holds [])⟩]⟩
theorem OmittedSortImageWrongMember_observed : U9.check OmittedSortImage OmittedSortImageMembers OmittedSortImagePromise OmittedSortImageWrongMemberCert = false := by decide
def OmittedSortImageWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[], [⟨0, [[]]⟩], [999], [[]], (.holds [])⟩]⟩
theorem OmittedSortImageWrongSourceClassIndex_observed : U9.check OmittedSortImage OmittedSortImageMembers OmittedSortImagePromise OmittedSortImageWrongSourceClassIndexCert = false := by decide
def OmittedSortImageMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[], [], [0], [[]], (.holds [])⟩]⟩
theorem OmittedSortImageMissingOutputClasses_observed : U9.check OmittedSortImage OmittedSortImageMembers OmittedSortImagePromise OmittedSortImageMissingOutputClassesCert = false := by decide
def OmittedSortImageMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[], [⟨0, [[]]⟩], [0], [], (.holds [])⟩]⟩
theorem OmittedSortImageMissingOutputConnections_observed : U9.check OmittedSortImage OmittedSortImageMembers OmittedSortImagePromise OmittedSortImageMissingOutputConnectionsCert = false := by decide
def JointLeft : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.pair (.leaf [false]) (.leaf [true])) (.leaf [false])), (.pair (.pair (.leaf [false]) (.leaf [true])) (.leaf [false])), []⟩
def JointLeftMembers : List U9.Member := [⟨[], (.pair (.pair (.leaf [false]) (.leaf [true])) (.leaf [false]))⟩]
def JointLeftPromise : List Edge := [⟨[], [false, false], [true]⟩]
def JointLeftCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false, false], [true]]⟩, ⟨0, [[false, true]]⟩], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem JointLeft_observed : U9.check JointLeft JointLeftMembers JointLeftPromise JointLeftCert = true := by decide
theorem JointLeft_verdict : (JointLeftCert.images.all (fun p => U9.verdict p.promise)) = true := by decide
def JointLeftMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[false, false], [true]]⟩, ⟨0, [[false, true]]⟩], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem JointLeftMissingSourceClasses_observed : U9.check JointLeft JointLeftMembers JointLeftPromise JointLeftMissingSourceClassesCert = false := by decide
def JointLeftMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[], [⟨0, [[false, false], [true]]⟩, ⟨0, [[false, true]]⟩], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem JointLeftMissingSourceForests_observed : U9.check JointLeft JointLeftMembers JointLeftPromise JointLeftMissingSourceForestsCert = false := by decide
def JointLeftMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem JointLeftMissingMembers_observed : U9.check JointLeft JointLeftMembers JointLeftPromise JointLeftMissingMembersCert = false := by decide
def JointLeftWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false, false], [true]]⟩, ⟨0, [[false, true]]⟩], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem JointLeftWrongMember_observed : U9.check JointLeft JointLeftMembers JointLeftPromise JointLeftWrongMemberCert = false := by decide
def JointLeftWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false, false], [true]]⟩, ⟨0, [[false, true]]⟩], [999, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem JointLeftWrongSourceClassIndex_observed : U9.check JointLeft JointLeftMembers JointLeftPromise JointLeftWrongSourceClassIndexCert = false := by decide
def JointLeftMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [], [0, 1], [[.address], []], (.holds [.address])⟩]⟩
theorem JointLeftMissingOutputClasses_observed : U9.check JointLeft JointLeftMembers JointLeftPromise JointLeftMissingOutputClassesCert = false := by decide
def JointLeftMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false, false], [true]]⟩, ⟨0, [[false, true]]⟩], [0, 1], [], (.holds [.address])⟩]⟩
theorem JointLeftMissingOutputConnections_observed : U9.check JointLeft JointLeftMembers JointLeftPromise JointLeftMissingOutputConnectionsCert = false := by decide
def JointLeftWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false, false], [true]]⟩, ⟨0, [[false, true]]⟩], [0, 1], [[.address], []], (.violated [])⟩]⟩
theorem JointLeftWrongPromise_observed : U9.check JointLeft JointLeftMembers JointLeftPromise JointLeftWrongPromiseCert = false := by decide
def JointRight : Model := ⟨(.pair (.leaf 0) (.leaf 0)), (.pair (.pair (.leaf [false]) (.leaf [true])) (.leaf [true])), (.pair (.pair (.leaf [false]) (.leaf [true])) (.leaf [true])), []⟩
def JointRightMembers : List U9.Member := [⟨[], (.pair (.pair (.leaf [false]) (.leaf [true])) (.leaf [true]))⟩]
def JointRightPromise : List Edge := [⟨[], [false, false], [true]⟩]
def JointRightCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false, false]]⟩, ⟨0, [[false, true], [true]]⟩], [0, 1], [[], [.address]], (.violated [])⟩]⟩
theorem JointRight_observed : U9.check JointRight JointRightMembers JointRightPromise JointRightCert = true := by decide
theorem JointRight_verdict : (JointRightCert.images.all (fun p => U9.verdict p.promise)) = false := by decide
def JointRightMissingSourceClassesCert : U9.Certificate := ⟨[], [[], []], [⟨[], [⟨0, [[false, false]]⟩, ⟨0, [[false, true], [true]]⟩], [0, 1], [[], [.address]], (.violated [])⟩]⟩
theorem JointRightMissingSourceClasses_observed : U9.check JointRight JointRightMembers JointRightPromise JointRightMissingSourceClassesCert = false := by decide
def JointRightMissingSourceForestsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [], [⟨[], [⟨0, [[false, false]]⟩, ⟨0, [[false, true], [true]]⟩], [0, 1], [[], [.address]], (.violated [])⟩]⟩
theorem JointRightMissingSourceForests_observed : U9.check JointRight JointRightMembers JointRightPromise JointRightMissingSourceForestsCert = false := by decide
def JointRightMissingMembersCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], []⟩
theorem JointRightMissingMembers_observed : U9.check JointRight JointRightMembers JointRightPromise JointRightMissingMembersCert = false := by decide
def JointRightWrongMemberCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[false], [⟨0, [[false, false]]⟩, ⟨0, [[false, true], [true]]⟩], [0, 1], [[], [.address]], (.violated [])⟩]⟩
theorem JointRightWrongMember_observed : U9.check JointRight JointRightMembers JointRightPromise JointRightWrongMemberCert = false := by decide
def JointRightWrongSourceClassIndexCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false, false]]⟩, ⟨0, [[false, true], [true]]⟩], [999, 1], [[], [.address]], (.violated [])⟩]⟩
theorem JointRightWrongSourceClassIndex_observed : U9.check JointRight JointRightMembers JointRightPromise JointRightWrongSourceClassIndexCert = false := by decide
def JointRightMissingOutputClassesCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [], [0, 1], [[], [.address]], (.violated [])⟩]⟩
theorem JointRightMissingOutputClasses_observed : U9.check JointRight JointRightMembers JointRightPromise JointRightMissingOutputClassesCert = false := by decide
def JointRightMissingOutputConnectionsCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false, false]]⟩, ⟨0, [[false, true], [true]]⟩], [0, 1], [], (.violated [])⟩]⟩
theorem JointRightMissingOutputConnections_observed : U9.check JointRight JointRightMembers JointRightPromise JointRightMissingOutputConnectionsCert = false := by decide
def JointRightWrongPromiseCert : U9.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [⟨[], [⟨0, [[false, false]]⟩, ⟨0, [[false, true], [true]]⟩], [0, 1], [[], [.address]], (.holds [])⟩]⟩
theorem JointRightWrongPromise_observed : U9.check JointRight JointRightMembers JointRightPromise JointRightWrongPromiseCert = false := by decide
end U9.ContractCases
