import VerificationIsIdentification
import Examples

// One steady reading admits the first setting and refuses the second.
typealias FirstSettingIsAdmittedByOneReading = HeldSettingAdmitted<
    ProjectionDefectOutputDelays.FirstSetting, ProjectionDefectOutputDelays.Tolerance, ProjectionDefectOutputDelays.FirstPasses>
typealias SecondSettingIsRefusedByOneReading = ProjectionDefectOutputDelays.SecondExceeds
// The refusal reads one exact frequency, so it needs no device class.
typealias RefusalNeedsNoDeviceClass = ProjectionDefectOutputDelays.SecondExceedsBetweenMixers

#if PROJECTION_DEFECT_PASS_ABOVE_TOLERANCE
// Every order from 36 ends at 36 or above, never at 25.
typealias RejectedSecondSettingPassesTheTolerance = ProjectionDefectPasses<ProjectionDefectOutputDelays.Tolerance, ProjectionDefectOutputDelays.SecondReading, SuccessorAtMost<ProjectionDefectOutputDelays.FiveAtMost<ProjectionDefectOutputDelays.FiveAtMost<ProjectionDefectOutputDelays.TwentyFiveAtMost<ZeroAtMost<Never>>>>>>
#endif

#if PROJECTION_DEFECT_REFUSE_BELOW_TOLERANCE
// Every order from 26 ends at 26 or above, never at the power 16.
typealias RejectedFirstSettingExceedsTheTolerance = ProjectionDefectExceeds<ProjectionDefectOutputDelays.Tolerance, ProjectionDefectOutputDelays.FirstReading, SuccessorAtMost<ProjectionDefectOutputDelays.TwentyFiveAtMost<ZeroAtMost<Never>>>>
#endif

#if PROJECTION_DEFECT_OTHER_UNIT
// The same count 25 in quarters of the power is another requirement.
enum QuarterOfInputPower: Close {}
typealias RejectedToleranceInAnotherUnit = ProjectionDefectPasses<ProjectionTolerance<QuarterOfInputPower, ProjectionDefectOutputDelays.TwentyFive>, ProjectionDefectOutputDelays.FirstReading, ProjectionDefectOutputDelays.SixteenAtMostTwentyFive>
#endif

#if PROJECTION_DEFECT_DELAY_BETWEEN_MIXERS
typealias RejectedOneReadingPassesWithADelayBetweenMixers = ProjectionDefectPasses<ProjectionDefectOutputDelays.Tolerance, ProjectionDefectReading<ProjectionDefectOutputDelays.FirstSetting, DelayBetweenMixers, ExactReading, SummedPowerContinuation, ProjectionDefectOutputDelays.Hundredths, ProjectionDefectOutputDelays.Sixteen>, ProjectionDefectOutputDelays.SixteenAtMostTwentyFive>
#endif

#if PROJECTION_DEFECT_READING_ERROR_PASS
typealias RejectedReadingWithErrorPassesAsExact = ProjectionDefectPasses<ProjectionDefectOutputDelays.Tolerance, ProjectionDefectReading<ProjectionDefectOutputDelays.FirstSetting, OneMixerAndDelayBank, ReadingWithinError, SummedPowerContinuation, ProjectionDefectOutputDelays.Hundredths, ProjectionDefectOutputDelays.Sixteen>, ProjectionDefectOutputDelays.SixteenAtMostTwentyFive>
#endif

#if PROJECTION_DEFECT_READING_ERROR_REFUSAL
// With the pass refused as well, a reading with error stays unresolved.
typealias RejectedReadingWithErrorRefusesAsExact = ProjectionDefectExceeds<ProjectionDefectOutputDelays.Tolerance, ProjectionDefectReading<ProjectionDefectOutputDelays.SecondSetting, OneMixerAndDelayBank, ReadingWithinError, SummedPowerContinuation, ProjectionDefectOutputDelays.Hundredths, ProjectionDefectOutputDelays.ThirtySix>, ProjectionDefectOutputDelays.TwentySixAtMostThirtySix>
#endif

#if PROJECTION_DEFECT_NEW_MIXER_CONTINUATION
typealias RejectedPassForAContinuationWithANewMixer = ProjectionDefectPasses<ProjectionDefectOutputDelays.Tolerance, ProjectionDefectReading<ProjectionDefectOutputDelays.FirstSetting, OneMixerAndDelayBank, ExactReading, MixerAfterPortsContinuation, ProjectionDefectOutputDelays.Hundredths, ProjectionDefectOutputDelays.Sixteen>, ProjectionDefectOutputDelays.SixteenAtMostTwentyFive>
#endif

#if PROJECTION_DEFECT_OTHER_SETTING
// A certificate of the first setting admits nothing for the second.
typealias RejectedCertificateAdmitsAnotherSetting = HeldSettingAdmitted<ProjectionDefectOutputDelays.SecondSetting, ProjectionDefectOutputDelays.Tolerance, ProjectionDefectOutputDelays.FirstPasses>
#endif

#if PROJECTION_DEFECT_ADMIT_REFUSAL
typealias RejectedRefusalAdmitsItsSetting = HeldSettingAdmitted<ProjectionDefectOutputDelays.SecondSetting, ProjectionDefectOutputDelays.Tolerance, ProjectionDefectOutputDelays.SecondExceeds>
#endif

// The same power 36 passes a requirement of 36, but that is not the original 25.
typealias RelaxedProjectionRequirement = ProjectionTolerance<
    ProjectionDefectOutputDelays.Hundredths, ProjectionDefectOutputDelays.ThirtySix>
typealias ThirtySixAtMostThirtySix = SuccessorAtMost<
    ProjectionDefectOutputDelays.FiveAtMost<ProjectionDefectOutputDelays.FiveAtMost<
    ProjectionDefectOutputDelays.TwentyFiveAtMost<ZeroAtMost<Never>>>>>
typealias RelaxedProjectionPass = ProjectionDefectPasses<RelaxedProjectionRequirement,
    ProjectionDefectOutputDelays.SecondReading, ThirtySixAtMostThirtySix>
typealias RelaxedProjectionAdmitted = HeldSettingAdmitted<
    ProjectionDefectOutputDelays.SecondSetting, RelaxedProjectionRequirement, RelaxedProjectionPass>

#if PROJECTION_DEFECT_OTHER_REQUIREMENT
typealias RejectedRelaxedCertificateAdmitsOriginalRequirement = HeldSettingAdmitted<
    ProjectionDefectOutputDelays.SecondSetting, ProjectionDefectOutputDelays.Tolerance,
    RelaxedProjectionPass>
#endif
