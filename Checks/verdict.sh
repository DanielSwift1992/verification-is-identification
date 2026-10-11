#!/usr/bin/env bash
# Check the generic implications, then reject one independent broken premise
# per compiler run. No diagnostic from a different fixture counts as a refusal.
set -euo pipefail
cd "$(dirname "$0")/.."
verdict_scope="${1:-all}"
case "$verdict_scope" in
    all|localphase|localpolicy|contact|publication|whole|ice|seeing|markers|uniqueness|distance|return|scopedlaw|knowledgeclosure|acquisition|interactions|knowledge|observer|resident|construction|boundary|common|evidence|evolution|closure|probe|routing|reuse|probepair|lawtransport|demand|frame|discovery) ;;
    *) echo "usage: bash Checks/verdict.sh [all|localphase|localpolicy|contact|publication|whole|ice|seeing|markers|uniqueness|distance|return|scopedlaw|knowledgeclosure|acquisition|interactions|knowledge|observer|resident|construction|boundary|common|evidence|evolution|closure|probe|routing|reuse|probepair|lawtransport|demand|frame|discovery]" >&2; exit 2 ;;
esac
verdict_tmp="$(mktemp -d "${TMPDIR:-/tmp}/vi-verdict.XXXXXX")"
trap 'rm -rf "$verdict_tmp"' EXIT

if [ "$verdict_scope" = localphase ]; then
    # This scope needs declarations only. Check both current source layers
    # together, without borrowing an older module from the package cache or
    # generating object code for the modeled constructions.
    verdict_bin="$verdict_tmp"
    mkdir -p "$verdict_bin/Modules"
    swiftc -emit-module -parse-as-library -module-name VerificationIsIdentification \
        Sources/VerificationIsIdentification/*.swift \
        -emit-module-path "$verdict_bin/Modules/VerificationIsIdentification.swiftmodule"
    swiftc -emit-module -parse-as-library -module-name Examples \
        -I "$verdict_bin/Modules" Sources/Examples/*.swift \
        -emit-module-path "$verdict_bin/Modules/Examples.swiftmodule"
else
    if [ "$verdict_scope" = publication ] || [ "$verdict_scope" = all ]; then
        swift build --product DocumentKitDemo
    else
        swift build --target Examples
    fi
    verdict_bin="$(swift build --show-bin-path)"
fi

typecheck() {
    if [ "$verdict_scope" = localphase ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/LocalPhase.swift Checks/LocalStar.swift Checks/LocalStarObservation.swift Checks/LocalContactLift.swift Checks/LocalFourLeaf.swift Checks/PhaseLawInquiry.swift Checks/PhaseWordCatalogue.swift Checks/FourLeafResident.swift Checks/FourLeafPointProbe.swift Checks/FourLeafAcquiredLaw.swift Checks/FourLeafRecoveredUse.swift Checks/FaithfulContactLift.swift Checks/FourLeafControl.swift Checks/FourReadingAcquisition.swift Checks/FourLeafEcho.swift Checks/AlternatingLine.swift Checks/QuarterClockCalibration.swift Checks/FourLeafRecordedReturn.swift Checks/StarRecoveryFibers.swift Checks/FourLeafProfileScope.swift Checks/FourLeafValueQuestion.swift Checks/FourLeafQuestionRefinement.swift Checks/SevenQuestionPrefix.swift Checks/PhaseLawKnownTransport.swift Checks/JointPhaseQuestions.swift Checks/PhaseAlignmentObstruction.swift Checks/UnobservedPhaseBridge.swift Checks/PhaseCyclingBridge.swift Checks/PhaseClockPolicy.swift Checks/PhaseProbeClockPolicy.swift Checks/ReusablePhaseInterface.swift Checks/PhaseInterfaceResidue.swift Checks/PrimitivePhaseReturn.swift Checks/PhaseBasisProfile.swift Checks/PhaseBasisReduction.swift Checks/PhaseFrameDrift.swift Checks/JointReplyAcquisition.swift Checks/JointReplyExecution.swift Checks/OneReplyApplicability.swift Checks/PartnerProbeApplicability.swift Checks/PhaseProbeExcursion.swift Checks/PairedProbeApplicability.swift Checks/LocalProbeEcho.swift Checks/EchoOrbit.swift Checks/ReturnCoverage.swift Checks/SeparationGraph.swift Checks/AcquiredFrameAction.swift Checks/ContactCycle.swift Checks/JointContactRigidity.swift Checks/ContactContrastSupport.swift Checks/ContactProfile.swift Checks/ProfileSupportHandover.swift Checks/ProfileRelease.swift Checks/BorrowedPhase.swift Checks/ProfileRenewal.swift Checks/SharedProfileRenewal.swift Checks/CyclicProfileRenewal.swift Checks/SharedFrameCoupling.swift Checks/FrameInterference.swift Checks/MarkedFrameRequest.swift Checks/SharedChannelLaw.swift Checks/RecombinationAutonomy.swift Checks/JoinedContinuation.swift Checks/RelativeAnswerCorrection.swift Checks/OccurrenceChange.swift Checks/OverlappingReadings.swift Checks/CycleAdmission.swift Checks/JointReactionBalance.swift Checks/DirectedRepair.swift Checks/RepairWithoutAnchor.swift Checks/ClockClassMass.swift Checks/BalancedContactRows.swift Checks/SelfRecordUse.swift Checks/TargetFrameTransport.swift Checks/RelativeChannelAcquisition.swift Checks/CoarseContactComparison.swift Checks/UncalibratedComparison.swift Checks/JointReadoutSymmetry.swift Checks/TripleOrientationContact.swift Checks/PhaseSelectiveContrast.swift Checks/DetectorContrast.swift Checks/FreshPartner.swift Checks/ContactDiagram.swift Checks/ContactBoundary.swift "$@"
        return
    fi
    if [ "$verdict_scope" = localpolicy ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/LocalContactPolicy.swift "$@"
        return
    fi
    if [ "$verdict_scope" = contact ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/ContactCalibration.swift Checks/ContactInquiry.swift "$@"
        return
    fi
    if [ "$verdict_scope" = publication ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Sources/DocumentKitDemo/Claim.swift Checks/Publication.swift "$@"
        return
    fi
    if [ "$verdict_scope" = discovery ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/Discovery.swift Checks/SelfInspection.swift "$@"
        return
    fi
    if [ "$verdict_scope" = seeing ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/Seeing.swift "$@"
        return
    fi
    if [ "$verdict_scope" = ice ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/IceIncidence.swift Checks/IceCoverage.swift "$@"
        return
    fi
    if [ "$verdict_scope" = whole ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/ClosedInformation.swift Checks/Context.swift "$@"
        return
    fi
    if [ "$verdict_scope" = markers ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/ClosedInformation.swift Checks/FiniteBoundary.swift "$@"
        return
    fi
    if [ "$verdict_scope" = uniqueness ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/Coverage.swift Checks/ClosedInformation.swift "$@"
        return
    fi
    if [ "$verdict_scope" = distance ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/Distance.swift "$@"
        return
    fi
    if [ "$verdict_scope" = return ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/RelationalReturn.swift "$@"
        return
    fi
    if [ "$verdict_scope" = scopedlaw ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/QuestionScopedLaw.swift "$@"
        return
    fi
    if [ "$verdict_scope" = knowledgeclosure ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/KnowledgeClosure.swift "$@"
        return
    fi
    if [ "$verdict_scope" = frame ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/RoutingFrame.swift "$@"
        return
    fi
    if [ "$verdict_scope" = demand ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/RoutingDemand.swift "$@"
        return
    fi
    if [ "$verdict_scope" = lawtransport ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/RoutingTransport.swift "$@"
        return
    fi
    if [ "$verdict_scope" = probepair ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/ResidentProbePair.swift "$@"
        return
    fi
    if [ "$verdict_scope" = reuse ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/RoutingReuse.swift "$@"
        return
    fi
    if [ "$verdict_scope" = routing ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/RoutingProbe.swift "$@"
        return
    fi
    if [ "$verdict_scope" = probe ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/MechanismProbe.swift "$@"
        return
    fi
    if [ "$verdict_scope" = closure ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/BoundaryClosure.swift "$@"
        return
    fi
    if [ "$verdict_scope" = evolution ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/BoundaryEvolution.swift "$@"
        return
    fi
    if [ "$verdict_scope" = evidence ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/AcquiredBoundary.swift "$@"
        return
    fi
    if [ "$verdict_scope" = common ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/CommonAcquisition.swift "$@"
        return
    fi
    if [ "$verdict_scope" = boundary ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/CommonBoundary.swift "$@"
        return
    fi
    if [ "$verdict_scope" = construction ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/Construction.swift "$@"
        return
    fi
    if [ "$verdict_scope" = resident ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/ResidentExperiment.swift "$@"
        return
    fi
    if [ "$verdict_scope" = observer ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/InternalObserver.swift "$@"
        return
    fi
    if [ "$verdict_scope" = knowledge ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/InteractionKnowledge.swift "$@"
        return
    fi
    if [ "$verdict_scope" = acquisition ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/Acquisition.swift "$@"
        return
    fi
    if [ "$verdict_scope" = interactions ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" Checks/Interactions.swift "$@"
        return
    fi
    swiftc -typecheck -I "$verdict_bin/Modules" \
        -module-cache-path "$verdict_tmp/cache" Checks/Verdict.swift Checks/FiniteBoundary.swift Checks/Coverage.swift Checks/Transition.swift Checks/ClosedInformation.swift Checks/Discovery.swift Checks/Cache.swift Checks/Entropy.swift Checks/Transcript.swift Checks/Learning.swift Checks/SelfPlay.swift Checks/SelfInspection.swift Checks/Sampling.swift Checks/Stationarity.swift Checks/Basis.swift Checks/Context.swift Sources/DocumentKitDemo/Claim.swift Checks/Publication.swift Checks/Transport.swift Checks/Saturation.swift Checks/Acquisition.swift Checks/Continuation.swift Checks/Interactions.swift Checks/InteractionKnowledge.swift Checks/InternalObserver.swift Checks/ResidentExperiment.swift Checks/Construction.swift Checks/CommonBoundary.swift Checks/CommonAcquisition.swift Checks/AcquiredBoundary.swift Checks/BoundaryEvolution.swift Checks/BoundaryClosure.swift Checks/MechanismProbe.swift Checks/RoutingProbe.swift Checks/RoutingReuse.swift Checks/ResidentProbePair.swift Checks/RoutingTransport.swift Checks/RoutingDemand.swift Checks/RoutingFrame.swift Checks/KnowledgeClosure.swift Checks/QuestionScopedLaw.swift Checks/ContactCalibration.swift Checks/ContactInquiry.swift Checks/LocalContactPolicy.swift Checks/LocalPhase.swift Checks/LocalStar.swift Checks/LocalStarObservation.swift Checks/LocalContactLift.swift Checks/LocalFourLeaf.swift Checks/PhaseLawInquiry.swift Checks/PhaseWordCatalogue.swift Checks/FourLeafResident.swift Checks/FourLeafPointProbe.swift Checks/FourLeafAcquiredLaw.swift Checks/FourLeafRecoveredUse.swift Checks/FaithfulContactLift.swift Checks/FourLeafControl.swift Checks/FourReadingAcquisition.swift Checks/FourLeafEcho.swift Checks/AlternatingLine.swift Checks/QuarterClockCalibration.swift Checks/FourLeafRecordedReturn.swift Checks/StarRecoveryFibers.swift Checks/FourLeafProfileScope.swift Checks/FourLeafValueQuestion.swift Checks/FourLeafQuestionRefinement.swift Checks/SevenQuestionPrefix.swift Checks/PhaseLawKnownTransport.swift Checks/JointPhaseQuestions.swift Checks/PhaseAlignmentObstruction.swift Checks/UnobservedPhaseBridge.swift Checks/PhaseCyclingBridge.swift Checks/PhaseClockPolicy.swift Checks/PhaseProbeClockPolicy.swift Checks/ReusablePhaseInterface.swift Checks/PhaseInterfaceResidue.swift Checks/PrimitivePhaseReturn.swift Checks/PhaseBasisProfile.swift Checks/PhaseBasisReduction.swift Checks/PhaseFrameDrift.swift Checks/JointReplyAcquisition.swift Checks/JointReplyExecution.swift Checks/OneReplyApplicability.swift Checks/PartnerProbeApplicability.swift Checks/PhaseProbeExcursion.swift Checks/PairedProbeApplicability.swift Checks/LocalProbeEcho.swift Checks/EchoOrbit.swift Checks/ReturnCoverage.swift Checks/SeparationGraph.swift Checks/AcquiredFrameAction.swift Checks/ContactCycle.swift Checks/JointContactRigidity.swift Checks/ContactContrastSupport.swift Checks/ContactProfile.swift Checks/ProfileSupportHandover.swift Checks/ProfileRelease.swift Checks/BorrowedPhase.swift Checks/ProfileRenewal.swift Checks/SharedProfileRenewal.swift Checks/CyclicProfileRenewal.swift Checks/SharedFrameCoupling.swift Checks/FrameInterference.swift Checks/MarkedFrameRequest.swift Checks/SharedChannelLaw.swift Checks/RecombinationAutonomy.swift Checks/JoinedContinuation.swift Checks/RelativeAnswerCorrection.swift Checks/OccurrenceChange.swift Checks/OverlappingReadings.swift Checks/CycleAdmission.swift Checks/JointReactionBalance.swift Checks/DirectedRepair.swift Checks/RepairWithoutAnchor.swift Checks/ClockClassMass.swift Checks/BalancedContactRows.swift Checks/SelfRecordUse.swift Checks/TargetFrameTransport.swift Checks/RelativeChannelAcquisition.swift Checks/CoarseContactComparison.swift Checks/UncalibratedComparison.swift Checks/JointReadoutSymmetry.swift Checks/TripleOrientationContact.swift Checks/PhaseSelectiveContrast.swift Checks/DetectorContrast.swift Checks/FreshPartner.swift Checks/ContactDiagram.swift Checks/ContactBoundary.swift Checks/RelationalReturn.swift Checks/Distance.swift Checks/IceIncidence.swift Checks/IceCoverage.swift Checks/Seeing.swift "$@"
}

typecheck_refusal() {
    if [ "$verdict_scope" = localphase ]; then
        swiftc -typecheck -I "$verdict_bin/Modules" \
            -module-cache-path "$verdict_tmp/cache" "$verdict_case_file" "$@"
    else
        typecheck "$@"
    fi
}

verdict_checked_files=" "
typecheck >"$verdict_tmp/positive.log" 2>&1 || {
    cat "$verdict_tmp/positive.log"
    exit 1
}
if [ "$verdict_scope" = publication ]; then
    echo "publication: active support, channel binding and coverage-preserving reordering compile"
elif [ "$verdict_scope" = discovery ]; then
    echo "discovery: transition traces, successor coverage, source-bound readings and diagonal fixed points compile"
elif [ "$verdict_scope" = seeing ]; then
    echo "seeing: sensor fibers, source-bound amplitude cancellation and signed-mode algebra compile"
elif [ "$verdict_scope" = ice ]; then
    echo "ice: source binding, incidence coverage, residual forest and catalogue-bound balances compile"
elif [ "$verdict_scope" = markers ]; then
    echo "markers: recursive counts, predecessor steps and output-shape boundaries compile"
elif [ "$verdict_scope" = uniqueness ]; then
    echo "uniqueness: declared support, membership paths and forced schedule assignments compile"
elif [ "$verdict_scope" = distance ]; then
    echo "distance: source partitions, reversible regrouping and zero-distance identification compile"
elif [ "$verdict_scope" = return ]; then
    echo "return: crossing derives side agreement; resident contacts share one assignment; relabelled operations and readers retain their answer"
elif [ "$verdict_scope" = localphase ]; then
    echo "localphase: complete reversible cycle, blind-action traps and original readout hold"
elif [ "$verdict_scope" = localpolicy ]; then
    echo "localpolicy: shared local rows, actual request delivery and source-bound probe replies compile"
elif [ "$verdict_scope" = contact ]; then
    echo "contact: calibration and requested probes recover source-bound answers; joint-record and intervention boundaries compile"
elif [ "$verdict_scope" = scopedlaw ]; then
    echo "scopedlaw: data coarsens required law evidence; an actual within-row law change preserves the answer"
elif [ "$verdict_scope" = knowledgeclosure ]; then
    echo "knowledgeclosure: current reuse, memory refinement, resident acquisition and all-word closure hold"
elif [ "$verdict_scope" = frame ]; then
    echo "frame: composite routing, calibrated recovery and relative agreement under a shared unknown frame hold"
elif [ "$verdict_scope" = demand ]; then
    echo "demand: the acquired repeated-first route needs one data coordinate and omits every unused value"
elif [ "$verdict_scope" = lawtransport ]; then
    echo "transport: old law evidence survives a certified module change; replacing the routing reopens the boundary"
elif [ "$verdict_scope" = probepair ]; then
    echo "probepair: two prepared resident instruments retain one source and supply both law records"
elif [ "$verdict_scope" = reuse ]; then
    echo "reuse: acquired routing and explicitly read new data derive outputs and their common-answer tables"
elif [ "$verdict_scope" = routing ]; then
    echo "routing: two common probe images reconstruct routing; one image, changed laws and source identity remain distinct"
elif [ "$verdict_scope" = probe ]; then
    echo "probe: a common output channel acquires the prepared E/K law; scope and actual application remain required"
elif [ "$verdict_scope" = closure ]; then
    echo "closure: mixed internal words, minimal binary tables, resident commands and acquired future decoders compile"
elif [ "$verdict_scope" = evolution ]; then
    echo "evolution: swaps preserve common classes, resident exchange refines them, and old evidence answers the scoped future"
elif [ "$verdict_scope" = evidence ]; then
    echo "evidence: acquired memory derives source agreement or obstruction and the three common-answer classes"
elif [ "$verdict_scope" = common ]; then
    echo "common: one acquired trace answers both resident sides, with preparation and archive access checked"
elif [ "$verdict_scope" = boundary ]; then
    echo "boundary: common-fact necessity and sufficiency, retained sources, scoped obstructions and three interface classes compile"
elif [ "$verdict_scope" = construction ]; then
    echo "construction: retained operand recovery, invariant answers, local mergers and partial constructor witnesses compile"
elif [ "$verdict_scope" = resident ]; then
    echo "resident: memory-selected acquisition, finite preparation and archived answers after instrument reset compile"
elif [ "$verdict_scope" = observer ]; then
    echo "observer: source-bound acquisition, prepared recovery, minimal refinement and internal-memory futures compile"
elif [ "$verdict_scope" = knowledge ]; then
    echo "knowledge: acquired classes, path closure, representation interchange and vocabulary refinement compile"
elif [ "$verdict_scope" = acquisition ]; then
    echo "acquisition: generic recording, refinement and trace reuse proofs compile"
elif [ "$verdict_scope" = interactions ]; then
    echo "interactions: generic availability, image and acquired-future proofs compile"
else
    echo "verdict: generic preservation proofs and finite certificates hold"
    echo "finite boundary: StructuresFinite accepts a cycle; explicit bounded floors compile"
fi

for verdict_case in \
    BAD_SENSOR_DIAGONAL_WRONG_FIELD:RejectedDiagonalObservationField \
    BAD_SENSOR_DIAGONAL_WRONG_MEMORY:RejectedDiagonalMemory \
    BAD_SENSOR_CHOI_TRACE_IDENTIFIES:RejectedChoiIdentificationFromTrace \
    BAD_SENSOR_CHOI_OMITS_BLOCK_ACTION:RejectedChoiOffDiagonalReplacement \
    BAD_SENSOR_CHOI_TRACE_SOURCE:RejectedChoiTraceSource \
    BAD_SENSOR_KRAUS_WRONG_PREPARATION:RejectedKrausRecordPreparation \
    BAD_SENSOR_KRAUS_DUPLICATE_NORMALIZES:RejectedDuplicateKrausNormalization \
    BAD_SENSOR_KRAUS_WRONG_OPERATORS:RejectedKrausOperatorSource \
    BAD_SENSOR_KRAUS_ERASES_JOINT_COHERENCE:RejectedJointCoherenceErasure \
    BAD_SENSOR_KRAUS_LOCAL_RECOVERS:RejectedLocalMatrixRecovery \
    BAD_SENSOR_BOTH_MARGINALS_RECOVER_JOINT:RejectedBothMarginalsRecoverJoint \
    BAD_SENSOR_LOCAL_TRANSPORT_IS_JOINT_TRANSPORT:RejectedLocalTransportIsJointTransport \
    BAD_SENSOR_GRAM_SUM_SOURCE:RejectedGramSumSource \
    BAD_SENSOR_GRAM_SUM_ERASES_FACTOR:RejectedGramSumErasesFactor \
    BAD_SENSOR_PRODUCT_RESTART:RejectedProductRestart \
    BAD_SENSOR_PRODUCT_OPERAND:RejectedProductOperand \
    BAD_SENSOR_GRAM_FIRST_FACTOR:RejectedGramFirstFactor \
    BAD_SENSOR_GRAM_SECOND_FACTOR:RejectedGramSecondFactor \
    BAD_SENSOR_GRAM_COMPUTED_ENTRY:RejectedGramComputedEntry \
    BAD_SENSOR_TRANSPOSE_IS_IDENTITY:RejectedPartialTransposeIdentity \
    BAD_SENSOR_TRANSPOSE_WEIGHT_ZERO:RejectedTransposeWeightZero \
    BAD_SENSOR_TRANSPOSE_WRONG_SOURCE:RejectedTransposeWeightSource \
    BAD_SENSOR_CONTROL_ERASES_PHASE:RejectedControlPhaseErasure \
    BAD_SENSOR_CONTROL_ERASES_REFERENCE:RejectedControlReferenceErasure \
    BAD_SENSOR_EQUAL_BRANCHES_CANCEL:RejectedEqualBranchCancellation \
    BAD_SENSOR_ORDER_UNBALANCED_CANCELS:RejectedUnbalancedOrderCancellation \
    BAD_SENSOR_ORDER_COMMON_CHANGE_IS_ONE_ROUTE:RejectedCommonOrderChangeIsOneRoute \
    BAD_SENSOR_PHASE_QUARTER_OVERLAP_ZERO:RejectedQuarterPhaseOverlapZero \
    BAD_SENSOR_PHASE_SIGN_CONTROLS_QUARTER_CORNERS:RejectedSignOnlyQuarterCorners \
    BAD_SENSOR_PHASE_SELECTION_IS_WHOLE:RejectedPhaseSelectionAsWhole \
    BAD_SENSOR_PHASE_ENCODING_IDENTIFIES_LABELS:RejectedPhaseEncodedLabels \
    BAD_SENSOR_PHASE_CANDIDATE_COMPLEMENT_IS_ZERO:RejectedComparisonComplementZero \
    BAD_SENSOR_PHASE_CYCLE_ERASES_FOURTH_HARMONIC:RejectedFourthHarmonicErasure \
    BAD_SENSOR_RESONANT_REMOVES_REFLECTION:RejectedResonantMissingReflection \
    BAD_SENSOR_RESONANT_REVERSES_SIDE:RejectedResonantSideSign \
    BAD_SENSOR_RESONANT_TRANSMITS:RejectedResonantTransmission \
    BAD_SENSOR_SIDE_PAIR_STAYS_OPAQUE:RejectedSidePairStillOpaque \
    BAD_SENSOR_SIDE_PAIR_RESTARTS_WINDOW:RejectedSidePairRestart \
    BAD_SENSOR_TRIANGLE_MODE_IS_ZERO:RejectedTriangleModeIsZero \
    BAD_SENSOR_OPEN_PATH_KEEPS_TRIANGLE_MODE:RejectedPathKeepsTriangleMode \
    BAD_SENSOR_SEWN_LOOP_IGNORES_COUPLING:RejectedSewnLoopIgnoresCoupling \
    BAD_SENSOR_MODES_COMMUTE:RejectedModesCommute \
    BAD_SENSOR_SCALE_FIXED_EXCHANGE:RejectedScaleFixedExchange \
    BAD_SENSOR_SCALE_FOUR_STEPS_RETURN:RejectedScaleFourStepReturn \
    BAD_SENSOR_SCALE_OMITS_OTHER_BLOCK:RejectedScaleOtherBlock \
    BAD_SENSOR_SCALE_RESTARTS_ROOT:RejectedScaleRootSource \
    BAD_SENSOR_MODE_SOURCE:RejectedModeSource \
    BAD_SENSOR_COMMON_IS_LOCAL_PHASE:RejectedCommonAsLocalPhase \
    BAD_SENSOR_AMPLITUDE_RESTART:RejectedAmplitudeRestart \
    BAD_SENSOR_AMPLITUDE_SIGN:RejectedAmplitudeSign \
    BAD_SENSOR_AMPLITUDE_RESIDUE:RejectedAmplitudeResidue \
    BAD_SENSOR_AMPLITUDE_MAGNITUDE:RejectedAmplitudeMagnitude \
    BAD_SENSOR_OPPOSITE_MAGNITUDE:RejectedOppositeMagnitude \
    BAD_SENSOR_OPPOSITE_PHASE:RejectedOppositePhase \
    BAD_SENSOR_A:RejectedSensorA \
    BAD_SENSOR_B:RejectedSensorB \
    BAD_SENSOR_C:RejectedSensorC \
    BAD_SENSOR_D:RejectedSensorD \
    BAD_SENSOR_SEPARATOR:RejectedSensorSeparator \
    BAD_SENSOR_MIX:RejectedSensorMix \
    BAD_SENSOR_QUESTION:RejectedSensorQuestion \
    COMMON_INTERSECTS_ALTERNATIVE_SUPPORTS:RejectedCommonEmptySupport \
    DISTANCE_MERGE_SUCCESS_FORCES_BRANCH_SUCCESS:RejectedMergeImpliesBranchSuccess \
    WHOLE_LAW_LOCAL_IMAGE_IDENTIFIES_SOURCE:RejectedLawLocalRecovery \
    WHOLE_LAW_EXCHANGE_IS_REPEATED_LOCAL_RESET:RejectedLawResetReuse \
    WHOLE_LAW_READY_IS_RECORDED:RejectedLawReadyRecordCollapse \
    WHOLE_LAW_RECORD_ACCEPTS_OTHER_RESULT:RejectedLawOtherLocalResult \
    WHOLE_LAW_REPEATED_ZERO_ERASES_OCCURRENCE:RejectedLawOccurrenceErasure \
    WHOLE_SWAP_RETURN_ERASES_HISTORY:RejectedSwapReturnHistory \
    WHOLE_RETAINED_SOURCE_FIXES_NEW_ANSWER:RejectedNewAnswerFromRetainedSource \
    WHOLE_TAIL_CLAIM_IS_INPUT_WITNESS:RejectedTailClaimAsInputWitness \
    WHOLE_RETENTION_ENDPOINT_SHAPE_IS_IDENTITY:RejectedRetentionIdentity \
    WHOLE_RETENTION_MERGES_OCCURRENCES:RejectedRetentionOccurrenceMerger \
    WHOLE_RETENTION_ACCEPTS_RESET:RejectedRetentionReset \
    WHOLE_RECOVERY_NAIVE_MIDDLE_READING:RejectedNaiveMiddleReading \
    WHOLE_RECOVERY_COARSE_CUT:RejectedRecoveryCoarseCut \
    WHOLE_RECOVERY_OTHER_SUFFIX:RejectedRecoveryOtherSuffix \
    WHOLE_PREDECESSOR_OTHER_START:RejectedPredecessorOtherStart \
    WHOLE_PREDECESSOR_OTHER_END:RejectedPredecessorOtherEnd \
    WHOLE_POINTWISE_RECOVERY_IS_UNIFORM:RejectedPointwiseRecoveryAsUniform \
    WHOLE_RECOVERY_CYCLE_FALSE_RETURN:RejectedRecoveryCycleFalseReturn \
    WHOLE_ANSWER_EVIDENCE_ANSWERS_NEW_QUESTION:RejectedEvidenceAnswersNewQuestion \
    WHOLE_COMPLETE_RECOVERY_FORCES_TRACKING:RejectedCompleteRecoveryTracking \
    WHOLE_OCCURRENCE_WITHOUT_FIRST_WITNESS:RejectedAbsentFirstWitness \
    WHOLE_OCCURRENCE_WITHOUT_SECOND_WITNESS:RejectedAbsentSecondWitness \
    WHOLE_OCCURRENCE_IMAGE_ERASES_WITNESS:RejectedOccurrenceWitnessErasure \
    WHOLE_OCCURRENCE_USES_OTHER_SOURCE:RejectedOccurrenceOtherSource \
    DISTANCE_ROUND_CREATES_PARENT_AND_CHILD:RejectedAbsentRoundParent \
    DISTANCE_ROUND_SHRINKS_NONLEAF:RejectedShrinkNonleaf \
    DISTANCE_ROUND_CHANGES_CONTEXT:RejectedRoundContext \
    DISTANCE_INDEPENDENCE_ERASES_HISTORY:RejectedIndependentHistoryCollapse \
    DISTANCE_SAME_LOCAL_RULE_ERASES_ORDER:RejectedSameLocalRuleOrder \
    DISTANCE_TWO_ROUNDS_ARE_ONE_ROUND:RejectedRoundCountCollapse \
    DISTANCE_PROGRESS_IGNORES_APPLICATION:RejectedProgressForOtherApplication \
    DISTANCE_PROGRESS_CHANGES_INPUT:RejectedProgressAcrossInputs \
    DISTANCE_PROGRESS_CHANGES_CONTEXT:RejectedProgressAcrossContexts \
    DISTANCE_PROGRESS_WITHOUT_REMOVAL:RejectedStationaryProgress \
    DISTANCE_PROGRESS_FROM_REMAINING_MASK:RejectedRemainingAsRemoved \
    DISTANCE_PROGRESS_WITH_DETOUR:RejectedDetourProgress \
    DISTANCE_PROGRESS_HIDES_SECOND_OUTPUT:RejectedBatchDetour \
    DISTANCE_SCALAR_DESCENT_IS_GEODESIC:RejectedScalarAsGeodesic \
    ICE_REPEATS_A_PORT:RejectedIceRepeatedPort \
    ICE_USES_OTHER_SOURCE:RejectedIceOtherSource \
    ICE_USES_OTHER_VERTEX:RejectedIceOtherVertex \
    ICE_USES_OTHER_CONTEXT:RejectedIceOtherContext \
    ICE_REVERSES_FORCED_DIRECTION:RejectedIceWrongCompletion \
    ICE_INFERS_WITH_TWO_PORTS:RejectedIceMissingPort \
    ICE_USES_OTHER_REFERENCE_EDGE:RejectedIceOtherReference \
    ICE_PROPAGATES_SAME_LOCAL_DIRECTION:RejectedIceSameLocalDirection \
    ICE_SHARED_EDGE_POINTS_OUT_AT_BOTH_ENDS:RejectedIceDoubleOut \
    ICE_ROOT_OMITS_A_LEAF:RejectedIceUncoveredRootPort \
    ICE_COVERAGE_MERGES_EQUAL_PAYLOADS:RejectedIceMergedVertexAddresses \
    ICE_COVERAGE_OMITS_VERTEX:RejectedIceUnallocatedVertex \
    ICE_EMPTY_PAYLOAD_LEAF_IS_EMPTY:CandidateLeaf \
    ICE_EMPTY_LEAF_ALIAS_OVERRIDE:CandidateLeaf \
    ICE_EMPTY_LEAF_WITNESS_OVERRIDE:CandidateLeaf \
    ICE_CYCLIC_EMPTY_ERASES_LEAF:RejectedCyclicEmptyWithLeaf \
    ICE_COVERAGE_STARTS_WITH_EXTRA_PORT:RejectedIceUnallocatedExtraPort \
    ICE_COVERAGE_REUSES_VERTEX:RejectedIceVertexReuse \
    ICE_COVERAGE_TAKES_OTHER_EDGE:RejectedIceOtherEdgeOccurrence \
    ICE_COVERAGE_REUSES_TAIL_AS_HEAD:RejectedIceTailReusedAsHead \
    ICE_COVERAGE_OMITS_EDGES:RejectedIceUnconsumedEdges \
    ICE_COVERAGE_SUBSTITUTES_PORTS:RejectedIceOtherPortAllocation \
    ICE_COVERAGE_CHANGES_CONTEXT:RejectedIceCoverageContext \
    ICE_COVERAGE_IMPLIES_ORIGINAL_GRAPH:RejectedIceCoverageAsSourceGraph \
    ICE_BINDING_REWIRES_FORWARD:RejectedIceRewiredForward \
    ICE_BINDING_REWIRES_REVERSE:RejectedIceRewiredReverse \
    ICE_BINDING_CHANGES_MEASURED_PIN:RejectedIceChangedPin \
    ICE_BINDING_OMITS_REFERENCE:RejectedIceMissingReference \
    ICE_BINDING_REORDERS_REFERENCE:RejectedIceReorderedReference \
    ICE_BINDING_USES_OTHER_CONTEXT:RejectedIceReferenceContext \
    ICE_BINDING_SPENDS_ANOTHER_CATALOGUE:RejectedIceOtherApplications \
    ICE_FOREST_OMITS_EDGE:RejectedIceUnfinishedForest \
    ICE_FOREST_REMOVES_BOTH_ENDPOINTS:RejectedIceAbsentSurvivingEndpoint \
    ICE_FOREST_ACCEPTS_LOOP:RejectedIceForestLoop \
    ICE_FOREST_REUSES_REMOVED_VERTEX:RejectedIceStrandedEdge \
    ICE_FOREST_CHANGES_CONTEXT:RejectedIceForestContext \
    ICE_FOREST_SUBSTITUTES_TOPOLOGY:RejectedIceOtherForestTopology \
    ICE_BALANCE_USES_OTHER_ORIENTATIONS:RejectedIceOtherLocalDirections \
    ICE_BALANCE_OMITS_VERTEX:RejectedIceUncoveredBalance \
    ICE_BALANCE_USES_OTHER_VERTEX:RejectedIceOtherBalanceVertex \
    MARKER_ICE_ACCEPTS_TWO_BONDS:RejectedShortIceVertex \
    MARKER_ICE_ACCEPTS_FIVE_BONDS:RejectedLongIceVertex \
    MARKER_ICE_ACCEPTS_THREE_IN:RejectedUnbalancedIceVertex \
    ACQUISITION_PREFIX_USES_LATEST_SLOT:RejectedLatestAsPrefix \
    DISTANCE_APPEND_PRESERVES_OLD_ADDRESS:RejectedAppendAddressPreservation \
    UNIQUE_SCHEDULE_WITHOUT_PIN:RejectedUnpinnedUniqueness \
    UNIQUE_SCHEDULE_WITHOUT_EDGE:RejectedMissingScheduleEdge \
    UNIQUE_SCHEDULE_IGNORES_CLOSING_EDGE:RejectedOddCycleClosure \
    UNIQUE_DEFAULT_PRESERVES_LATER_CONTACT:RejectedEarlyDefaultContact \
    UNIQUE_MEMBERSHIP_FORCES_SINGLETON:RejectedMembershipAsSingleton \
    UNIQUE_SELECTION_CHANGES_CANDIDATE:RejectedSelectionCandidate \
    UNIQUE_SELECTION_IGNORES_DECLARATION:RejectedSelectionDeclaration \
    UNIQUE_SELECTION_IGNORES_TARGET_SUPPORT:RejectedTargetSupport \
    UNIQUE_SUPPORT_HAS_DIFFERENT_MEMBERS:RejectedDifferentSupportMembers \
    UNIQUE_VISIBLE_COVERAGE_IDENTIFIES_MEMBER:RejectedVisibleSupportSingleton \
    DISTANCE_NONZERO_AT_EMPTY_ADDRESS:RejectedEmptyAddressDifference \
    DISTANCE_NONZERO_WRONG_CHILD_SEAM:RejectedNonzeroChildSeam \
    DISTANCE_NONZERO_WRONG_SOURCE_TRIPLE:RejectedNonzeroSourceTriple \
    DISTANCE_DETOUR_IS_DIRECT_NONZERO:RejectedDetourAsDirectDifference \
    MARKER_MEASURABLE_FORCES_FUNCTIONALITY:RejectedMeasurementFunctionality \
    MARKER_DECIDABLE_FORCES_BINARY_VALUE:RejectedDecisionBit \
    UNIQUE_ERASES_RESIDUAL:RejectedUniqueResidualErasure \
    UNIQUE_COARSE_ANSWER_IDENTIFIES_SOURCE:RejectedCoarseIdentification \
    UNIQUE_DIFFERENT_IDENTITY_CANDIDATES_AGREE:RejectedDifferentIdentityCandidates \
    UNIQUE_REPEATED_SUPPORT_IS_ONE_OCCURRENCE:RejectedSupportOccurrenceCollapse \
    UNIQUE_COVERAGE_OMITS_IDENTITY_CANDIDATE:RejectedIdentityCoverage \
    DISTANCE_EMPTY_ROOT_HIDES_OCCUPIED_MASK_CHILD:RejectedOccupiedMaskChild \
    DISTANCE_OCCUPIED_MASK_IS_EMPTY:RejectedOccupiedMask \
    DISTANCE_EMPTY_MASK_IS_NEVER:RejectedPaddedMaskCollapse \
    DISTANCE_EQUAL_ROOTS_HIDE_DIFFERENT_CHILDREN:RejectedZeroFromEqualRoots \
    DISTANCE_ZERO_ENDPOINTS_ERASE_DETOUR:RejectedZeroDetour \
    DISTANCE_FORGED_ZERO_MASK:RejectedZeroWithOccupiedMask \
    DISTANCE_FORGED_ZERO_SOURCES:RejectedZeroWithUnequalSources \
    DISTANCE_HIDDEN_FIRST_CHILD:RejectedHiddenFirstChild \
    DISTANCE_HIDDEN_MIDDLE_CHILD:RejectedHiddenMiddleChild \
    DISTANCE_HIDDEN_LAST_CHILD:RejectedHiddenLastChild \
    DISTANCE_SWAPS_TREE_ADDRESSES:RejectedTreeAddressSwap \
    DISTANCE_MOVES_DETOUR:RejectedDetourAddressMove \
    DISTANCE_ERASES_DETOUR:RejectedDistanceErasure \
    DISTANCE_CHANGES_DIRECT_PART:RejectedDistanceRetargeting \
    DISTANCE_UNSHARED_PART:RejectedDistanceSeam \
    RETURN_UNEQUAL_ZERO_ONE:RejectedReturnZeroOne \
    RETURN_UNEQUAL_ONE_ZERO:RejectedReturnOneZero \
    RETURN_FORCES_VALUE:RejectedReturnValue \
    RETURN_IDENTITY_FORCES_AGREEMENT:RejectedIdentityCrossing \
    RETURN_DOUBLE_FORCES_AGREEMENT:RejectedDoubleAgreement \
    RETURN_INTERMEDIATE_IS_ENDPOINT:RejectedIntermediateReturn \
    RETURN_PHASE_CYCLE_CLOSING_EDGE:RejectedPhaseClosingEdge \
    RETURN_PHASE_CYCLE_SEPARATE_SOURCES:RejectedPhaseSeparateSources \
    RETURN_PHASE_CONTACT_FOREIGN_START:RejectedPhaseForeignStart \
    RETURN_RELABEL_WITH_UNCHANGED_QUESTION:RejectedUnchangedFrameQuestion \
    FRAME_PATTERN_EQUAL_VALUES_WRONG_PATH:RejectedPatternEqualValuesWrongPath \
    FRAME_PATTERN_WRONG_SIGNATURE:RejectedPatternWrongSignature \
    FRAME_PATTERN_FALSE_RECOVERY:RejectedPatternFalseRecovery \
    FRAME_TWO_CONTENT_AGREEMENT_IDENTIFIES_LAW:RejectedTwoContentLawIdentification \
    FRAME_RESERVE_NOT_READ:RejectedUnreadReserve \
    FRAME_CALIBRATION_OTHER_RESERVE:RejectedCalibrationOtherReserve \
    FRAME_SELECTED_OLD_PREPARATION:RejectedSelectedOldPreparation \
    FRAME_SELECTED_FOREIGN_CATALOGUE:RejectedSelectedForeignCatalogue \
    FRAME_CHOICE_REPEATED_RESERVE:RejectedChoiceFromRepeatedReserve \
    FRAME_PATTERN_EQUALITY_DEPENDENCE:RejectedPatternEqualityDependence \
    FRAME_PATTERN_WRONG_LAW:RejectedPatternWrongLaw \
    FRAME_PATTERN_FOREIGN_SELECTION:RejectedPatternForeignSelection \
    FRAME_EQUALITY_FROZEN_ROUTING:RejectedEqualityFrozenRouting \
    FRAME_EQUALITY_WRONG_RETURN:RejectedEqualityWrongReturn \
    FRAME_UNCALIBRATED_MODULE_RECOVERY:RejectedFrameModule \
    FRAME_FACT_IDENTIFIES_WHOLE:RejectedFrameWhole \
    FRAME_ORDER_CHANGE_IS_INVISIBLE:RejectedFrameOrder \
    FRAME_WRONG_CALIBRATION:RejectedFrameCalibration \
    FRAME_MIXED_IMAGES_FORCE_SOURCE_AGREEMENT:RejectedMixedFrameAgreement \
    FRAME_SHARED_ORIENTATION_IS_KNOWN:RejectedSharedOrientation \
    FRAME_SHARED_CROSSING_ERASES_CONTRAST:RejectedSharedContrast \
    FRAME_PROBE_IDENTIFIES_ABSOLUTE_SOURCE:RejectedAbsoluteProbeSource \
    FRAME_CONTRAST_PROBE_RELATIONS_AGREE:RejectedRelativeProbeMerger \
    FRAME_DIAGONAL_CALIBRATION_COVERS_CONTRAST:RejectedDiagonalProbeReuse \
    FRAME_RELATIVE_BIT_RECOVERS_PROBE_IMAGE:RejectedRelativeBitImageRecovery \
    FRAME_RELATIVE_BIT_ERASES_CLASS:RejectedRelativeBitClassMerger \
    FRAME_OLD_CALIBRATION_COVERS_ARBITRARY_REPLACEMENT:RejectedUntrackedFrameReplay \
    FRAME_REPLAY_RECOVERS_ABSOLUTE_DATA:RejectedAbsoluteDataFromReplay \
    DEMAND_FIRST_SUFFICES_FOR_IDENTITY:RejectedDemandIdentity \
    DEMAND_NO_DATA_NEEDED:RejectedDemandNoData \
    DEMAND_DIFFERENT_LAW_FACT:RejectedDemandLaw \
    DEMAND_LAW_FACT_IS_DATA:RejectedDemandMissing \
    DEMAND_SWAPPED_ARGUMENTS:RejectedDemandLayout \
    DEMAND_RECOVERS_UNREAD_COORDINATE:RejectedDemandUnread \
    DEMAND_INVENTS_UNUSED_BRANCH_READ:RejectedDemandShape \
    LAWTRANSPORT_ROUTING_FREEZES_MODULE:RejectedTransportModule \
    LAWTRANSPORT_SKIPS_ACTUAL_TRANSITION:RejectedTransportSkip \
    LAWTRANSPORT_WRONG_ENDPOINT:RejectedTransportEndpoint \
    LAWTRANSPORT_WRONG_INITIAL_EVIDENCE:RejectedTransportEvidence \
    LAWTRANSPORT_WRONG_PATH_SEAM:RejectedTransportSeam \
    LAWTRANSPORT_ERASES_OPERATION_WORD:RejectedTransportWord \
    LAWTRANSPORT_REPLACEMENT_PRESERVES_LAW:RejectedTransportReplacement \
    LAWTRANSPORT_NEW_INPUT_MISSING:RejectedTransportInput \
    PROBEPAIR_SKIPS_FOCUS:RejectedProbePairFocus \
    PROBEPAIR_REUSES_FIRST_SLOT:RejectedProbePairSlot \
    PROBEPAIR_UNREAD_SECOND:RejectedProbePairUnread \
    PROBEPAIR_MISSING_SECOND_INSTRUMENT:RejectedProbePairMissing \
    PROBEPAIR_OTHER_SOURCE:RejectedProbePairSource \
    PROBEPAIR_SWAPPED_RECORDS:RejectedProbePairOrder \
    PROBEPAIR_SAME_CHANNEL_FOR_BOTH:RejectedProbePairChannel \
    REUSE_NO_NEW_INPUT:RejectedReuseNoInput \
    REUSE_OTHER_NEW_INPUT:RejectedReuseOtherInput \
    REUSE_OTHER_ACTUAL_ROUTING:RejectedReuseRouting \
    REUSE_EQUAL_FACT_OTHER_SOURCE:RejectedReuseSource \
    REUSE_WRONG_ADDRESS_CLAUSE:RejectedReuseClause \
    REUSE_HIDDEN_INPUT_EQUALITY:RejectedReuseInputEquality \
    REUSE_SWAPPED_MEMORY_LAYOUT:RejectedReuseLayout \
    REUSE_OUTPUT_IDENTIFIES_LAW:RejectedReuseOutputLaw \
    REUSE_OLD_OUTPUT_TABLE:RejectedReuseOldTable \
    REUSE_CALIBRATION_WRONG_READING:RejectedReuseCalibrationReading \
    REUSE_CALIBRATION_PROVES_ALL_INPUTS:RejectedReuseCalibrationAllInputs \
    REUSE_SAME_INPUT_IS_SAME_DECODER:RejectedReuseDifferentDecoders \
    ROUTING_ONE_PROBE_RECOVERS_ALL:RejectedRoutingSingle \
    ROUTING_MIXED_ACTUAL_MECHANISMS:RejectedRoutingMixed \
    ROUTING_WRONG_ACQUIRED_SOURCE:RejectedRoutingSource \
    ROUTING_SWAPPED_PROBE_ORDER:RejectedRoutingOrder \
    ROUTING_COORDINATES_ARE_MECHANISM:RejectedRoutingIdentity \
    ROUTING_BEHAVIOR_RECOVERS_WORD:RejectedRoutingWord \
    ROUTING_ONE_IMAGE_IS_TWO:RejectedRoutingMissing \
    ROUTING_ONE_WHOLE_PROVES_STATIONARITY:RejectedRoutingStationarity \
    PROBE_BAD_PREPARATION:RejectedProbePreparation \
    PROBE_OTHER_APPLICATION:RejectedProbeApplication \
    PROBE_OTHER_PREPARED_SOURCE:RejectedProbeSource \
    PROBE_CONSTANT_LAW_FROM_BAD_RECORD:RejectedProbeBadRecord \
    PROBE_RESPONSE_IDENTIFIES_EXTENDED_FAMILY:RejectedProbeFamily \
    PROBE_RESPONSE_IS_LAW_TAG:RejectedProbeLawTag \
    PROBE_EQUAL_FACT_IDENTIFIES_APPLICATION:RejectedProbeIdentity \
    CLOSURE_WRONG_MIDDLE:RejectedClosureMiddle \
    CLOSURE_REAPPLIES_ZERO:RejectedClosureZero \
    CLOSURE_WRONG_COMPARISON_ADDRESS:RejectedClosureAddress \
    CLOSURE_WRONG_MEMORY_SOURCE:RejectedClosureSource \
    CLOSURE_ALPHA_ONLY_SUFFICES:RejectedClosureAlpha \
    CLOSURE_OTHER_ENDPOINT:RejectedClosureEndpoint \
    CLOSURE_ERASES_PATH:RejectedClosurePath \
    CLOSURE_RECOVERS_ORIENTATION:RejectedClosureOrientation \
    CLOSURE_FAILURE_IS_ANSWER:RejectedClosureFailure \
    CLOSURE_HISTORY_IS_CURRENT:RejectedClosureHistory \
    CLOSURE_WRONG_RESIDENT_COMMAND:RejectedClosureCommand \
    CLOSURE_PREPARATION_AFTER_EXCHANGE:RejectedClosurePreparation \
    CLOSURE_OLD_CLASS_SURVIVES_CROSS:RejectedClosureCrossClass \
    CLOSURE_CROSS_IS_OLD_OPERATION:RejectedClosureCrossCommand \
    SLAWS_ROW_PROBE_IDENTIFIES_LAW:RejectedScopedIdentity \
    SLAWS_NO_LAW_READING_ON_DISTINCT_ROWS:RejectedScopedNoReading \
    SLAWS_OLD_PROBE_COVERS_NEW_DATA:RejectedScopedNewData \
    SLAWS_WRONG_ROW_DECODER:RejectedScopedWrongRow \
    SLAWS_ANY_REPLACEMENT_PRESERVES_ANSWER:RejectedScopedReplacement \
    SLAWS_ANSWER_PRESERVES_LAW:RejectedScopedLawUnchanged \
    SLAWS_CHANGE_ERASES_QUESTION:RejectedScopedChangeQuestion \
    KCLOSURE_CURRENT_IS_SWAP:RejectedKnowledgeCurrent \
    KCLOSURE_OLD_MEMORY_IS_COMPLETE:RejectedKnowledgeOldComplete \
    KCLOSURE_ONE_OLD_ANSWER_FOR_HIDDEN:RejectedKnowledgeHidden \
    KCLOSURE_FOREIGN_ACQUISITION:RejectedKnowledgeForeign \
    KCLOSURE_QUESTION_OMITS_OPERATION:RejectedKnowledgeQuestion \
    KCLOSURE_REVERSED_WORD:RejectedKnowledgeOrder \
    KCLOSURE_WRONG_TAPE_HEAD:RejectedKnowledgeTape \
    KCLOSURE_SKIPS_RESIDENT_FOCUS:RejectedKnowledgeFocus \
    KCLOSURE_FORGED_THIRD_FACT:RejectedKnowledgeForged \
    EVOLUTION_FALSE_COARSE_RESET:RejectedEvolutionCoarseReset \
    EVOLUTION_UNPREPARED_ZERO_IMAGE:RejectedEvolutionUnprepared \
    EVOLUTION_REUSES_ZERO_AFTER_CONSUMPTION:RejectedEvolutionConsumed \
    EVOLUTION_OLD_FACT_IS_FRESH_TRACE:RejectedEvolutionFreshTrace \
    EVOLUTION_OLD_READING_IS_CURRENT:RejectedEvolutionOldReading \
    EVOLUTION_WRONG_ACTUAL_ENDPOINT:RejectedEvolutionEndpoint \
    EVOLUTION_EQUAL_VALUE_FOREIGN_EVIDENCE:RejectedEvolutionForeign \
    EVOLUTION_FUTURE_OMITS_OPERATION:RejectedEvolutionQuestion \
    EVOLUTION_LOCAL_RESET_ERASES_OLD_VALUE:RejectedEvolutionErasure \
    EVOLUTION_SWAPS_WITH_OLD_ENDPOINT:RejectedEvolutionSwapSeam \
    EVOLUTION_HISTORY_IS_RETURNED_SOURCE:RejectedEvolutionHistory \
    EVIDENCE_ADVANCE_UNREAD:RejectedEvidenceUnread \
    EVIDENCE_ADVANCE_NO_SLOT:RejectedEvidenceNoSlot \
    EVIDENCE_ADVANCE_OCCUPIED_SLOT:RejectedEvidenceOccupied \
    EVIDENCE_ADVANCE_OTHER_SOURCE:RejectedEvidenceAdvanceSource \
    EVIDENCE_UNRELATED_OBSERVATIONS:RejectedEvidenceForeign \
    EVIDENCE_WRONG_MEMORY_DECODER:RejectedEvidenceDecoder \
    EVIDENCE_PREMATURE_CLASSIFICATION:RejectedEvidencePremature \
    EVIDENCE_UNEQUAL_AS_AGREEMENT:RejectedEvidenceUnequal \
    EVIDENCE_FALSE_OBSTRUCTION:RejectedEvidenceObstruction \
    EVIDENCE_FAILURE_IS_ANSWER:RejectedEvidenceFailureFact \
    EVIDENCE_CLASS_ERASES_ORIENTATION:RejectedEvidenceOrientation \
    EVIDENCE_OLD_PERMISSION_NEW_SOURCE:RejectedEvidenceOldPermission \
    COMMON_UNEQUAL_WITH_PREPARATION:RejectedCommonUnequal \
    COMMON_OTHER_ACTUAL_SOURCE:RejectedCommonForeign \
    COMMON_OTHER_ACTUAL_READING:RejectedCommonReading \
    COMMON_OCCUPIED_WORKSPACE:RejectedCommonOccupied \
    COMMON_OTHER_CHANNEL:RejectedCommonChannel \
    COMMON_NO_PREPARATION_RESERVE:RejectedCommonReserve \
    COMMON_NO_PARKING_RESERVE:RejectedCommonParkingReserve \
    COMMON_ARCHIVE_INACCESSIBLE:RejectedCommonAccess \
    COMMON_REPLACEMENT_ARCHIVE:RejectedCommonArchive \
    COMMON_FIRST_FACT_CERTIFIES_SECOND:RejectedCommonUnmeasured \
    BOUNDARY_UNEQUAL_ANSWERS_SHARE_DECODER:RejectedBoundarySharedDecoder \
    BOUNDARY_UNEQUAL_ANSWERS_FORM_VERDICT:RejectedBoundaryVerdict \
    BOUNDARY_OTHER_QUESTION:RejectedBoundaryQuestion \
    BOUNDARY_OTHER_ENCODING:RejectedBoundaryEncoding \
    BOUNDARY_SUBSTITUTES_EQUAL_VALUED_SOURCE:RejectedBoundaryActualSource \
    BOUNDARY_OBSTRUCTION_WITH_EQUAL_ANSWERS:RejectedBoundaryFalseObstruction \
    BOUNDARY_OBSTRUCTION_OTHER_SUCCESSOR:RejectedBoundaryUnboundObstruction \
    BOUNDARY_REVERSES_OBSTRUCTION:RejectedBoundaryObstructionOrder \
    BOUNDARY_REFUSAL_IS_COMMON_FACT:RejectedBoundaryRefusalFact \
    BOUNDARY_FIRST_ANSWER_DETERMINES_DOMAIN:RejectedBoundaryFirstDomain \
    BOUNDARY_SAME_REFUSAL_IDENTIFIES_ORIENTATION:RejectedBoundaryOrientation \
    BOUNDARY_SAME_ANSWER_IDENTIFIES_SOURCES:RejectedBoundarySourceIdentity \
    BOUNDARY_CANONICAL_FACT_IS_ORIGINAL_IMAGE:RejectedBoundaryOriginalImage \
    BOUNDARY_COARSE_AGREEMENT_FORCES_FINE:RejectedBoundaryRefinement \
    BOUNDARY_SUBSTITUTES_EQUAL_VALUED_ANCHOR:RejectedBoundaryAnchor \
    CONSTRUCTION_LOCAL_RESULT_IS_COMPLETE:RejectedConstructionLocalAsWhole \
    CONSTRUCTION_LOCAL_RESULT_RECOVERS_BOTH:RejectedConstructionLocalRecovery \
    CONSTRUCTION_OTHER_OPERAND_BOUNDARY:RejectedConstructionBoundary \
    CONSTRUCTION_REVERSES_OPERANDS:RejectedConstructionOrder \
    CONSTRUCTION_DROPS_ACTUAL_CONTEXT:RejectedConstructionContext \
    CONSTRUCTION_EQUAL_ANSWER_IDENTIFIES_OUTPUT:RejectedConstructionOutputIdentity \
    CONSTRUCTION_EQUAL_ANSWER_IDENTIFIES_SOURCE:RejectedConstructionSourceIdentity \
    CONSTRUCTION_FRESH_RECORD_IS_FLOOR:RejectedConstructionFreshFloor \
    CONSTRUCTION_EQUAL_CHILDREN_ARE_FLOOR:RejectedConstructionDiagonalFloor \
    CONSTRUCTION_PARTIAL_BECOMES_TOTAL:RejectedConstructionTotalPairing \
    CONSTRUCTION_LATER_RECORD_IS_EARLIER:RejectedConstructionOccurrenceCollapse \
    CONSTRUCTION_LAYOUT_USES_OLD_ADDRESS:RejectedConstructionLayoutAddress \
    RESIDENT_SELECTS_OTHER_CHANNEL:RejectedResidentChannel \
    RESIDENT_SELECTS_FROM_SOURCE:RejectedResidentSourceChoice \
    RESIDENT_READY_FORCES_ACQUISITION:RejectedResidentReadyChoice \
    RESIDENT_OTHER_ACTUAL_SOURCE:RejectedResidentActualSource \
    RESIDENT_EMPTY_RESERVE_PREPARES:RejectedResidentEmptyReserve \
    RESIDENT_OCCUPIED_RESERVE_IS_BLANK:RejectedResidentOccupiedReserve \
    RESIDENT_ONE_SLOT_PAYS_TWICE:RejectedResidentSecondSlot \
    RESIDENT_PARKS_BEFORE_READING:RejectedResidentUnreadParking \
    RESIDENT_PARKS_OTHER_FACT:RejectedResidentOtherFact \
    RESIDENT_LOSES_OLD_CONTENT:RejectedResidentOldContent \
    RESIDENT_FULL_PARTICIPANT_RETURNS:RejectedResidentFullReturn \
    RESIDENT_ARCHIVE_IS_OTHER_SOURCE:RejectedResidentArchiveSource \
    RESIDENT_ARCHIVE_HAS_OTHER_ANSWER:RejectedResidentArchiveAnswer \
    RESIDENT_ARCHIVE_HAS_OTHER_CONTEXT:RejectedResidentArchiveContext \
    RESIDENT_OLD_POLICY_READS_NEW_TRACE:RejectedResidentOldPolicy \
    RESIDENT_RESET_WORK_ALONE_KNOWS_BETA:RejectedResidentResetKnowledge \
    OBSERVER_OTHER_SOURCE_SAME_VALUE:RejectedObserverOtherSource \
    OBSERVER_BEFORE_IS_READY:RejectedObserverPrematureRead \
    OBSERVER_OTHER_WHOLE_SOURCE:RejectedObserverWholeSource \
    OBSERVER_OTHER_MEMORY:RejectedObserverOtherMemory \
    OBSERVER_OTHER_CHANNEL:RejectedObserverChannel \
    OBSERVER_REUSES_CONSUMED_SLOT:RejectedObserverConsumedSlot \
    OBSERVER_UNPREPARED_OCCUPIED_SLOT:RejectedObserverOccupiedSlot \
    OBSERVER_BLANK_IS_RECORDED_ZERO:RejectedObserverBlankAsZero \
    OBSERVER_SWAPPED_RECORD_ORDER:RejectedObserverRecordOrder \
    OBSERVER_WRONG_RECORDED_QUESTION:RejectedObserverQuestion \
    OBSERVER_NEW_ANSWER_FROM_OLD_CLASS:RejectedObserverOldClass \
    OBSERVER_WIDENS_BINARY_HIDDEN_SCOPE:RejectedObserverHiddenScope \
    OBSERVER_READY_CLASS_IS_BLOCKED:RejectedObserverReadyAsBlocked \
    OBSERVER_OBSERVATION_EXECUTES_SWAP:RejectedObserverSceneSwap \
    OBSERVER_FUTURE_AVAILABLE_AT_OTHER_SOURCE:RejectedObserverUnavailableFuture \
    OBSERVER_REWIND_PRESERVES_READY_ANSWER:RejectedObserverReadyAfterRewind \
    OBSERVER_LATER_RECORD_IS_EARLIER_WHOLE:RejectedObserverClockIdentity \
    OBSERVER_CLOSURE_PROVES_RECOVERY:RejectedClosedResetRecovery \
    OBSERVER_RECURRENCE_IDENTIFIES_HISTORY:RejectedObserverHistoryCollapse \
    KNOWLEDGE_CLASS_FROM_ALPHA_FACT:RejectedClassFromAlpha \
    KNOWLEDGE_CLASS_FROM_OTHER_SOURCE:RejectedOtherSourceFact \
    KNOWLEDGE_DECODER_FROM_SOURCE:RejectedSourceAsFact \
    KNOWLEDGE_OTHER_FACT_QUESTION:RejectedFactQuestion \
    KNOWLEDGE_BLOCKED_FACT_INVENTS_ACTION:RejectedBlockedFactAction \
    KNOWLEDGE_REPEATS_EXIT:RejectedExitContinuation \
    KNOWLEDGE_FUTURE_OTHER_ENDPOINT:RejectedKnowledgeEndpoint \
    KNOWLEDGE_FUTURE_OTHER_INITIAL_EVIDENCE:RejectedKnowledgeInitialEvidence \
    KNOWLEDGE_FUTURE_ERASES_PATH:RejectedKnowledgePathErasure \
    KNOWLEDGE_REOBSERVES_OTHER_IMAGE:RejectedReobservationImage \
    KNOWLEDGE_REOBSERVES_TOTAL_AS_PARTIAL:RejectedReobservationOperation \
    KNOWLEDGE_APPENDS_OTHER_SOURCE:RejectedRepeatSource \
    KNOWLEDGE_NEW_ACTION_FROM_OLD_CLASS:RejectedNewActionFromClass \
    KNOWLEDGE_NEW_ANSWERS_AGREE:RejectedNewVocabularyAgreement \
    KNOWLEDGE_CLASS_IS_FULL_IMAGE:RejectedClassAsFullImage \
    KNOWLEDGE_ANSWER_IS_SOURCE_IDENTITY:RejectedKnowledgeSourceIdentity \
    KNOWLEDGE_EQUAL_BOUNDARIES_IDENTIFY_PROOFS:RejectedInterchangeProofIdentity \
    BAD_INFRARED:RejectedInfrared \
    BAD_QUESTION:RejectedQuestion \
    BAD_ENCODING:RejectedEncoding \
    BAD_SPACE:RejectedSpace \
    BAD_ANSWER:RejectedAnswer \
    BAD_RIGHT_ANSWER:RejectedRightAnswer \
    BAD_MEMBER:RejectedMember \
    BAD_REORDER:RejectedReorder \
    EMPTY_READINGS:RejectedEmpty \
    BAD_THIRD_BRANCH:RejectedThird \
    BAD_LEFT_FLOOR:RejectedLeftCycle \
    BAD_RIGHT_FLOOR:RejectedRightCycle \
    MISSING_CANDIDATE:RejectedMissing \
    REPEATED_CANDIDATE:RejectedRepeated \
    FALSE_LEAF:RejectedLeaf \
    FALSE_GROUP:RejectedGroup \
    FALSE_UNION:RejectedUnion \
    FALSE_OBSERVATION_SOURCE:RejectedObservationSource \
    FALSE_OBSERVATION_IMAGE:RejectedObservationImage \
    HIDDEN_DECODER:RejectedHiddenDecoder \
    FALSE_SHARED_DECODER:RejectedSharedDecoder \
    FUTURE_OBSERVATION:RejectedFuture \
    STEP_SOURCE_INPUT:RejectedSquare \
    STEP_SOURCE_OUTPUT:RejectedSquare \
    STEP_IMAGE_INPUT:RejectedSquare \
    STEP_IMAGE_OUTPUT:RejectedSquare \
    STEP_OPERATION:RejectedSquare \
    STEP_CONTEXT:RejectedSquare \
    STEP_QUESTION:RejectedStepQuestion \
    STEP_MIDDLE:RejectedMiddle \
    STEP_EXPOSURE:RejectedExposure \
    STEP_INVERSE:RejectedErasureInverse \
    STEP_RICHER_IMAGE:RejectedRicherImage \
    WHOLE_RECORD_LOSS:RejectedRecordLoss \
    WHOLE_MUTUAL_RECORDS_FORCE_PRESERVATION:RejectedMutualRecordsPreservation \
    WHOLE_RECIPROCAL_INFLUENCE_PRESERVES:RejectedReciprocalInfluencePreservation \
    WHOLE_WITNESS_WRONG_NEXT_ADDRESS:RejectedWitnessWrongNextAddress \
    WHOLE_OUTPUT_MERGER:RejectedWholeMerger \
    WHOLE_PAIR_MARGINALS_IDENTIFY_JOINT:RejectedPairMarginalCompleteness \
    WHOLE_PAIR_MARGINALS_PREDICT_CONTINUATION:RejectedPairMarginalContinuation \
    WHOLE_BINARY_CONSTRAINTS_EXPRESS_PARITY:RejectedMajorityClosedParity \
    WHOLE_CLAUSE_SUPPORT_INVENTS_TRUE_INPUT:RejectedClauseInventsTrueInput \
    WHOLE_CLAUSE_EMPTY_SUPPORT_IS_ODD:RejectedClauseEmptySupport \
    WHOLE_CLAUSE_EVEN_SUPPORT_IS_ODD:RejectedClauseEvenSupport \
    WHOLE_CLAUSE_RESTARTS_PARITY:RejectedClauseRestartsParity \
    WHOLE_CLAUSE_CONTACT_OMITS_MIDDLE_ADMISSION:RejectedClauseMissingContact \
    WHOLE_CLAUSE_CONTACT_ALLOWS_EMPTY_SUPPORT:RejectedClauseAllowsEmptyContact \
    WHOLE_CURRENT_AGREEMENT_IDENTIFIES_ORIGIN:RejectedAgreementAsAcquisition \
    WHOLE_ACQUISITION_IGNORES_COPY_BINDING:RejectedUnboundAcquisitionCopy \
    WHOLE_CONTACT_OUTPUT_ERASES_MODE:RejectedContactModeErasure \
    WHOLE_FAITHFUL_COMPOSITE_CERTIFIES_EACH_LINK:RejectedCompositeCertifiesLocalReader \
    WHOLE_LOCAL_REPAIR_PRESERVES_COMPENSATED_RESULT:RejectedLocalRepairKeepsComposite \
    WHOLE_CORRECTION_OLD_SCOPE_COVERS_EXPANSION:RejectedCorrectionOldScope \
    WHOLE_CORRECTION_EXPANDED_SECOND_AGREES:RejectedCorrectionSecondAgreement \
    WHOLE_CORRECTION_SECOND_RESTATEMENT_SURVIVES:RejectedCorrectionSecondRestatement \
    COMPRESSED_RESIDUAL_LOSS:RejectedResidualLoss \
    EQUALITY_IS_NOT_FLOOR:RejectedEqualityAsFloor \
    ONE_FRAME_PREDICTION:RejectedOneFramePrediction \
    GLUING_WITHOUT_SHARED_MIDDLE:RejectedUnmatchedSeam \
    FALSE_PAIR_SEPARATOR:RejectedPairSeparator \
    FALSE_REPAIRED_BRANCH:RejectedRepairedBranch \
    FALSE_WHOLE_HISTORY_MERGER:RejectedWholeHistoryMerger \
    RETARGETED_ORIGINAL_QUESTION:RejectedRetargetedQuestion \
    DISCOVERY_TARGET_TAG_AS_MEMORY:RejectedTargetTagAsMemory \
    DISCOVERY_PLAIN_SHIFT_ADMITS_001:RejectedPlainShift001 \
    DISCOVERY_TWISTED_SHIFT_ADMITS_000:RejectedTwistedShift000 \
    DISCOVERY_UNCOVERED_PARENT:RejectedUncoveredDiscoveryParent \
    DISCOVERY_CHANGED_ORIGINAL_TARGET:RejectedChangedDiscoveryTarget \
    DISCOVERY_WRONG_OBSERVATION_BRANCH:RejectedWrongDiscoveryBranch \
    DISCOVERY_WRONG_SUCCESSOR:RejectedWrongDiscoverySuccessor \
    DISCOVERY_ACTION_DEPENDS_ON_ORIGIN:RejectedOriginDependentDiscoveryAction \
    DISCOVERY_UNLINKED_TERMINALS:RejectedUnlinkedDiscoveryTerminals \
    DISCOVERY_MIXED_TERMINAL_ANSWERS:RejectedMixedDiscoveryTerminal \
    DISCOVERY_DECODER_WRONG_OBSERVATION:RejectedDiscoveryObservationDecoder \
    DISCOVERY_EXECUTES_OTHER_ACTION:RejectedDiscoveryExecutedAction \
    DISCOVERY_FORGED_COMPLETION:RejectedForgedDiscoveryCompletion \
    DISCOVERY_FORGED_ACTION_SELECTION:RejectedForgedDiscoveryAction \
    DISCOVERY_DIRECT_CONFLICTING_QUESTION:RejectedDirectDiscoveryConflict \
    DISCOVERY_DIRECT_WRONG_SOURCE:RejectedDirectDiscoverySource \
    CONTROLLER_WRONG_SCENE_INPUT:RejectedControllerScene \
    CONTROLLER_WRONG_MEMORY_INPUT:RejectedControllerMemory \
    BUDGET_DID_NOT_DECREASE:RejectedUnchangedBudget \
    BUDGET_SPENDS_ZERO:RejectedZeroBudgetStep \
    PURE_TRUTH_IMPLIES_RETENTION:PureFrameWithRetractingCache \
    RAW_APPEND_IMPLIES_DECODED_RETENTION:RejectedLatestOnlyRetention \
    OBSERVATION_WITHOUT_PREPARATION:RejectedUnpreparedObservation \
    EQUAL_READING_ERASES_RESIDUAL:RejectedObservationResidualMerger \
    TRANSCRIPT_OVERREADS_HIDDEN_FIELD:RejectedOverreadingTrace \
    EQUAL_TRACE_MERGES_WHOLE_RECORD:RejectedTraceWholeMerger \
    TRAINING_AGREEMENT_IMPLIES_TEST_AGREEMENT:RejectedUnseenPrediction \
    OBSERVATION_PROVES_CONSTANT_FAMILY:RejectedConstantFamily \
    SELF_LABEL_CERTIFIES_ACTUAL_SECOND_ANSWER:RejectedSelfLabelAsMeasurement \
    DIAGONAL_COMPLEMENT_HAS_CODE_ZERO:RejectedDiagonalCodeZero \
    DIAGONAL_COMPLEMENT_HAS_CODE_ONE:RejectedDiagonalCodeOne \
    DIAGONAL_NONFIXED_FIRST_ROW:RejectedUnfixedFirstRow \
    DIAGONAL_NONFIXED_SECOND_ROW:RejectedUnfixedSecondRow \
    CYCLIC_FOURTH_READING_CAN_DIFFER:RejectedFreshFourthReading \
    CYCLIC_TAPE_ERASES_SECOND_FIELD:RejectedTapeErasure \
    INTERACTION_AVERAGE_IDENTIFIES_ENTRIES:RejectedAverageIdentifiesEntries \
    INTERACTION_AVERAGE_CERTIFIES_AGREEMENT:RejectedAverageCertifiesAgreement \
    INTERACTION_TWO_MOMENTS_IDENTIFY_SOURCE:RejectedTwoMomentsIdentifySource \
    INTERACTION_COINCIDENCE_ERASES_GUESS_ADMISSION:RejectedCoincidenceErasesGuessAdmission \
    INTERACTION_LANDMARK_RECORD_COMMUTES_WITH_REVERSAL:RejectedLandmarkRecordReversal \
    INTERACTION_DELAY_PAIR_REVERSES_WITHOUT_FIELD_EXCHANGE:RejectedDelayPairOrdinaryReversal \
    INTERACTION_OPEN_BLOCK_REVERSAL_PRESERVES_SEAM:RejectedOpenBlockReversalPreservesSeam \
    INTERACTION_SAME_RECORD_LAW_IDENTIFIES_PREPARATION:RejectedSameRecordLawIdentifiesPreparation \
    INTERACTION_DYNAMICS_IDENTIFIES_REVERSAL:RejectedDynamicsIdentifiesReversal \
    INTERACTION_QUARTER_REPHASING_PRESERVES_SQUARE:RejectedQuarterRephasingPreservesSquare \
    INTERACTION_CROSSED_REGIONS_COARSEN_ROWS:RejectedCrossedRegionsCoarsenRows \
    INTERACTION_CROSSED_REGIONS_COARSEN_COLUMNS:RejectedCrossedRegionsCoarsenColumns \
    INTERACTION_JOINT_SYMMETRY_IDENTIFIES_CONTACT:RejectedJointSymmetryIdentifiesContact \
    INTERACTION_JOINT_SYMMETRY_TRANSFERS_BOUNDARY:RejectedJointSymmetryTransfersBoundary \
    EXPOSURE_ERASES_OLD_CACHE:RejectedExposureCacheLoss \
    EXPOSURE_INVENTS_NEW_READING:RejectedInventedExposure \
    MACRO_EXPANSION_ENDS_AFTER_TWO:RejectedUnchangedPrimitiveBudget \
    MACRO_EXPANSION_REORDERS_OPERATIONS:RejectedReorderedExpansion \
    FIRST_INPUT_CERTIFICATE_COVERS_NEW_INPUT:RejectedExpandedCertificateScope \
    FIRST_INPUT_CERTIFICATE_IDENTIFIES_WHOLE_FUNCTION:RejectedWholeFunctionFromSample \
    TRANSPORT_MIDDLE_SOURCE:RejectedTransportMiddle \
    TRANSPORT_MIDDLE_CODE:RejectedTransportCode \
    TRANSPORT_INPUT_CODE:RejectedTransportEndpoint \
    TRANSPORT_OUTPUT_CODE:RejectedTransportEndpoint \
    TRANSPORT_OUTPUT_VALUE:RejectedTransportEndpoint \
    TRANSPORT_QUESTION:RejectedTransportReading \
    TRANSPORT_CONTEXT:RejectedTransportReading \
    TRANSPORT_WRONG_DECODER:RejectedTransportDecoder \
    TRANSPORT_IDENTIFIES_SOURCE:RejectedTransportIdentity \
    TRANSPORT_RECOVERS_HIDDEN:RejectedTransportRecovery \
    UNPREPARED_MEMORY_COUNTS_AS_READING:RejectedUnpreparedReading \
    ACQUIRED_FIRST_ANSWER_IS_SECOND:RejectedAcquiredSecond \
    SAME_MEMORY_VALUE_CHANGES_QUESTION:RejectedMemoryQuestion \
    SATURATION_SEPARATE_JOIN:RejectedSeparateSaturation \
    SATURATION_REVERSE_WORD:RejectedSaturationWordOrder \
    SATURATION_MISSING_FIELD:RejectedSaturationWithoutHidden \
    SATURATION_WRONG_UPDATE:RejectedSaturationImageUpdate \
    SATURATION_EQUAL_IMAGE_IS_SOURCE:RejectedImageAsSourceIdentity \
    SATURATION_EQUAL_IMAGE_IS_PATH_ENDPOINT:RejectedImageAsPathEndpoint \
    SATURATION_AGREEMENT_WITHOUT_COMPLETE_IMAGE:RejectedIncompleteImageAgreement \
    CONTINUATION_RETARGETS_PRESENT_QUESTION:RejectedFutureAsPresentQuestion \
    CONTINUATION_OTHER_FINAL_SOURCE:RejectedFutureEndpoint \
    CONTINUATION_WITHOUT_ACQUIRED_IMAGE:RejectedInsufficientFutureFact \
    INTERACTION_COMMON_RESPONSE_INVENTS_MENU_MEMBER:RejectedInventedMenuMember \
    INTERACTION_COMMON_RESPONSE_USES_FIRST_MENU_ENTRY:RejectedCommonAtFirstMenuEntry \
    INTERACTION_COMMON_RESPONSE_USES_SECOND_MENU_ENTRY:RejectedCommonAtSecondMenuEntry \
    INTERACTION_INDIVIDUAL_RESPONSES_ARE_COMMON:RejectedIndividualResponsesAsCommon \
    INTERACTION_CUT_PRIMARY_IDENTIFIES_SOURCE:RejectedCutPrimaryRecovery \
    INTERACTION_CUT_UNORDERED_RESULT:RejectedCutUnorderedResult \
    INTERACTION_CUT_COMPLEMENT_FIRST_VACANCY:RejectedCutComplementFirst \
    INTERACTION_CUT_COMPLEMENT_SECOND_VACANCY:RejectedCutComplementSecond \
    INTERACTION_CUT_ERASES_COMPLEMENT:RejectedCutComplementErasure \
    INTERACTION_CUT_RECOVERS_NOMINAL_SHELL:RejectedCutNominalRecovery \
    INTERACTION_CUT_INDEPENDENT_SOURCE_CONTACTS_SUFFICE:RejectedCutWithoutCrossContact \
    INTERACTION_CONTACT_FOURTH_CORNER_DIFFERS:RejectedFourthCornerSeparation \
    INTERACTION_CROSSED_SEAM_FROM_TWO_CUTS:RejectedCrossedSeamFromTwoCuts \
    INTERACTION_PAIRING_DETERMINES_SQUARE:RejectedPairingDeterminesSquare \
    INTERACTION_LOCAL_SQUARES_ERASE_CROSSING:RejectedLocalSquaresEraseCrossing \
    INTERACTION_CONTEXT_SQUARE_ERASES_RETURN:RejectedContextSquareReturn \
    INTERACTION_CONTEXT_SQUARE_RESTARTS_SOURCE:RejectedContextSquareSource \
    INTERACTION_LOCAL_LISTS_IDENTIFY_JOINING:RejectedLocalListsIdentifyJoining \
    INTERACTION_LOCAL_LISTS_RETAIN_ALTERNATIVE_ADDRESS:RejectedLocalListsRetainAlternativeAddress \
    INTERACTION_LOCAL_MIDPOINTS_GLUE:RejectedLocalMidpointsGlue \
    INTERACTION_LOCAL_LOOP_WITNESSES_GLUE:RejectedLocalLoopWitnessesGlue \
    INTERACTION_LOOP_RETURN_IS_IDENTITY:RejectedLoopReturnAsIdentity \
    INTERACTION_SHAPE_RETURN_IS_CONTACT_RETURN:RejectedShapeReturnAsContactReturn \
    INTERACTION_BOTH_SUPPORTS_ALLOW_EXTENSION:RejectedBothSupportsExtension \
    INTERACTION_RETRACE_RESTARTS_INTERIOR:RejectedRetraceRestartsInterior \
    INTERACTION_SEPARATE_RETURNS_ERASE_ORDER:RejectedSeparateReturnsEraseOrder \
    INTERACTION_CENTRE_ONLY_REGROUPING:RejectedCentreOnlyRegrouping \
    INTERACTION_REVERSIBLE_CENTRES_FORCE_MEDIAL:RejectedReversibleCentresMedial \
    INTERACTION_CONTACT_WRONG_RESERVE:RejectedContactReserve \
    INTERACTION_CONTACT_BROKEN_SOURCE:RejectedBrokenContact \
    INTERACTION_CONTACT_ERASES_RESERVE:RejectedContactReserveErasure \
    INTERACTION_CONTACT_RETAINS_CHANGED_PARTNER:RejectedChangedPartner \
    INTERACTION_FULL_FIRST_VACANCY:RejectedFullFirstVacancy \
    INTERACTION_FULL_SECOND_VACANCY:RejectedFullSecondVacancy \
    INTERACTION_FULL_THIRD_VACANCY:RejectedFullThirdVacancy \
    INTERACTION_VALID_CHOICE_IS_EQUIVARIANT:RejectedVacancyChoiceEquivariance \
    INTERACTION_CYCLIC_WITNESS_REFLECTION:RejectedCyclicVacancyReflection \
    INTERACTION_DISABLED_SOURCE:RejectedDisabledSource \
    INTERACTION_DISABLED_IMAGE:RejectedDisabledImage \
    INTERACTION_REPEAT_AFTER_GUARD_CHANGES:RejectedRepeatedMatch \
    INTERACTION_REUSES_OLD_SOURCE_STEP:RejectedOldStep \
    INTERACTION_VISIBLE_IMAGE_INVENTS_AVAILABILITY:RejectedVisiblePermission \
    INTERACTION_ERASES_ACTION_CONDITION:RejectedGuardedAsUnguardedQuestion \
    INTERACTION_SHARED_FUTURES_ARE_TRANSITIVE:RejectedCommonFutureTransitivity \
    INTERACTION_IDENTIFIES_ZERO_SUCCESSOR:RejectedZeroSuccessorEquality \
    INTERACTION_BLOCKS_EQUAL_FIELDS:RejectedEqualFieldsBlocked \
    INTERACTION_MERGES_READY_FUTURES:RejectedReadyFutureMerger \
    INTERACTION_MERGES_AVAILABILITY:RejectedAvailabilityMerger \
    INTERACTION_WRONG_CLASS_SUCCESSOR:RejectedClassSuccessor \
    INTERACTION_READY_STEP_FROM_BLOCKED:RejectedReadyFromBlocked \
    ACQUISITION_WRONG_FACT_ANSWER:RejectedFactAnswer \
    ACQUISITION_MIXED_CONTEXT_IS_COMPARABLE:RejectedMixedComparison \
    ACQUISITION_RETENTION_OTHER_SOURCE:RejectedRetentionSource \
    ACQUISITION_RETENTION_OTHER_MEMORY:RejectedRetentionMemory \
    ACQUISITION_FACT_IS_SOURCE_READING:RejectedFactAsSourceReading \
    ACQUISITION_COEXISTENCE_IS_AGREEMENT:RejectedStoredAgreement \
    ACQUISITION_WRONG_FACT_QUESTION:RejectedFactQuestion \
    ACQUISITION_WRONG_FACT_SOURCE:RejectedFactSource \
    ACQUISITION_UNKNOWN_SECOND_FROM_FIRST:RejectedUnmeasuredSecond \
    ACQUISITION_WIDENS_CONSTANT_SCOPE:RejectedConstantScope \
    ACQUISITION_REFINES_OTHER_QUESTION:RejectedRefinementQuestion \
    ACQUISITION_REFINES_OTHER_SOURCE:RejectedRefinementSource \
    ACQUISITION_TRACE_CHANGES_SOURCE:RejectedTraceSource \
    ACQUISITION_TRACE_FORGETS_PREFIX:RejectedTracePrefix \
    ACQUISITION_TRACE_ADDS_NO_FACT:RejectedMissingFact \
    ACQUISITION_REUSE_ADDS_OBSERVATION:RejectedReuseGrowth \
    ACQUISITION_REUSE_OTHER_MEMORY:RejectedOtherMemory \
    ACQUISITION_REUSE_OTHER_SOURCE:RejectedOtherSource \
    ACQUISITION_PUBLICATION_USES_ARCHIVE:RejectedArchiveAsCurrent \
    ACQUISITION_REUSE_CHANGES_QUESTION:RejectedRepeatedQuestion \
    LOCAL_PHASE_READS_TOO_EARLY:RejectedPhaseEarlyWindow \
    LOCAL_PHASE_REUSES_FORWARD_AS_INVERSE:RejectedPhaseForwardInverse \
    LOCAL_PHASE_SELECTS_WITHOUT_PHASE:RejectedPhaseIdenticalControlInput \
    LOCAL_PHASE_RENAMES_ONLY_COORDINATES:RejectedPhaseUnchangedTable \
    LOCAL_PHASE_CLAIMS_UNPAIRED_DEADLINE:RejectedPhaseUnpairedDeadline \
    LOCAL_PHASE_ALTERS_PRIMITIVE:RejectedPhasePrimitiveChange \
    LOCAL_PHASE_FORGETS_WORD_POSITION:RejectedPaddedOneTable \
    LOCAL_PHASE_IGNORES_CONTROL_CHANGE:RejectedPaddedUntouchedControl \
    LOCAL_PHASE_MERGES_MIDDLE_POSITIONS:RejectedFourStageMergedPositions \
    LOCAL_PHASE_REPEATS_STAGE_AS_STATE:RejectedFourStageAutonomousImage \
    LOCAL_PHASE_STAR_USES_FORWARD_INVERSE:RejectedStarForwardInverse \
    LOCAL_PHASE_STAR_HAS_FREE_CLOCK:RejectedStarIndependentClock \
    LOCAL_PHASE_STAR_FORGETS_RETURN_PATH:RejectedStarUnknownPathDecoder \
    LOCAL_PHASE_STAR_READS_CURRENT_AS_ORIGINAL:RejectedStarCurrentPhase \
    LOCAL_PHASE_STAR_SHORT_TRACE_SUFFICES:RejectedStarShortTrace \
    LOCAL_PHASE_STAR_USES_UNSELECTED_PRIMITIVE:RejectedStarUnselectedPrimitive \
    LOCAL_PHASE_STAR_REORDERS_ACQUIRED_FACTS:RejectedStarReorderedFacts \
    LOCAL_PHASE_STAR_ALIASES_FIRST_TWO_OPERATIONS:RejectedStarFirstSecondAlias \
    LOCAL_PHASE_STAR_CONFUSES_STAGE_PHASE_QUESTION:RejectedStarDifferentQuestion \
    LOCAL_PHASE_STAR_RECORDS_ANOTHER_QUESTION:RejectedStarWrongRecording \
    LOCAL_PHASE_STAR_FORGES_SELECTED_OCCURRENCE:RejectedStarForgedOccurrence \
    LOCAL_PHASE_CLOSING_SUBSTITUTES_COMPLETE_CONTACT:RejectedClosingFullReplacement \
    LOCAL_PHASE_CLOSING_SUBSTITUTES_UNDER_FEEDBACK:RejectedClosingFeedbackReplacement \
    LOCAL_PHASE_FOUR_STAGE_IDENTITY_IS_COMPLETE:RejectedFourLeafCompleteIdentity \
    LOCAL_PHASE_FOUR_OMITS_INTERMEDIATE_CHANGE:RejectedFourLeafWrongSeam \
    LOCAL_PHASE_INQUIRY_MIXES_CURRENT_LAW:RejectedPhaseInquiryCurrentLaw \
    LOCAL_PHASE_INQUIRY_MIXES_SOURCES:RejectedPhaseInquiryOneSource \
    LOCAL_PHASE_WORD_DIRECTION_REVERSED:RejectedPhaseWordWrongDirection \
    LOCAL_PHASE_WORD_CENTER_IS_COMPLETE:RejectedPhaseWordStageReturnIsWholeReturn \
    LOCAL_PHASE_RESIDENT_WRONG_TABLE_ROW:RejectedFourLeafResidentRow \
    LOCAL_PHASE_RESIDENT_READS_PHASE_AS_STAGE:RejectedFourLeafPhaseForStage \
    LOCAL_PHASE_WORD_IGNORES_RESIDENT_ADDRESS:RejectedFourLeafWrongResidentWord \
    LOCAL_PHASE_REPLACES_SECOND_LAW:RejectedFourLeafChangedSecondLaw \
    LOCAL_PHASE_DECODER_WRONG_ROW:RejectedFourLeafDecoderRow \
    LOCAL_PHASE_DIAGONAL_IS_LAW:RejectedFourLeafDiagonalLaw \
    LOCAL_PHASE_REUSE_IGNORES_LEARNED_LAW:RejectedFourLeafReuseOtherLaw \
    LOCAL_PHASE_FAITHFUL_UNUSED_IS_EQUIVALENT:RejectedFaithfulSameContinuation \
    LOCAL_PHASE_FAITHFUL_OMITS_REMAINDER:RejectedFaithfulUnusedCenter \
    LOCAL_PHASE_CONTROL_FOUR_STEPS_ARE_RETURN:RejectedFourLeafShortControlReturn \
    LOCAL_PHASE_CONTROL_REUSES_WRONG_STAGE_ROOT:RejectedFourLeafSamePolicyWrongRoot \
    LOCAL_PHASE_THREE_RECORDS_COMPLETE_WINDOW:RejectedFourReadingThreeFactsAreComplete \
    LOCAL_PHASE_FOUR_READING_USES_OLD_SOURCE:RejectedFourReadingOldThirdSource \
    LOCAL_PHASE_ECHO_REUSES_OLD_SOURCE:RejectedFourLeafEchoWrongObservationSource \
    LOCAL_PHASE_ECHO_RETURN_ERASES_RECORDS:RejectedFourLeafEchoWholeReturn \
    LOCAL_PHASE_ECHO_SECOND_FACT_PREDICTS_NOW:RejectedFourLeafEchoSecondFactReuse \
    LOCAL_PHASE_LINE_STAGE_RETURN_IS_FULL_RETURN:RejectedAlternatingLineFullReturn \
    LOCAL_PHASE_LINE_PROJECTED_CONTACT_IS_ACTUAL:RejectedAlternatingLineProjectedContact \
    LOCAL_PHASE_LINE_MATCHING_CONTINUES_PAST_TOP:RejectedAlternatingLinePastTop \
    LOCAL_PHASE_SIX_RETURNS_FORCE_INVOLUTION:RejectedQuarterClockInvolution \
    LOCAL_PHASE_RECORDED_CHOICE_ALLOWS_OTHER_ADDRESS:RejectedRecordedChoiceOtherAddress \
    LOCAL_PHASE_RECORDED_CHOICE_NEXT_U_IS_INVERSE:RejectedRecordedChoiceNextU \
    LOCAL_PHASE_RECORDED_CHOICE_SURVIVES_LAW_CHANGE:RejectedRecordedChoiceChangedLaw \
    LOCAL_PHASE_MERGED_STAR_ADDRESS_RECOVERS_BOTH:RejectedMergedStarInverse \
    LOCAL_PHASE_PROFILE_SURVIVES_NEW_CONTACT:RejectedProfileScopeExtension \
    LOCAL_PHASE_VALUE_WRONG_ROW:RejectedOneFactValueRow \
    LOCAL_PHASE_VALUE_IS_WHOLE_LAW:RejectedOneFactWholeLaw \
    LOCAL_PHASE_WEAK_USE_IGNORES_CHOICE:RejectedWeakUseUnselectedWord \
    LOCAL_PHASE_WEAK_REPRESENTATIVE_IS_ORIGINAL:RejectedWeakRepresentativeAsOriginal \
    LOCAL_PHASE_WEAK_REPLACES_PARKED_LAW:RejectedWeakReplacementAtResume \
    LOCAL_PHASE_CURRENT_VALUE_IS_FUTURE_MEMORY:RejectedCurrentValueAsFutureMemory \
    LOCAL_PHASE_PREFIX_FOURTH_POINT0:RejectedSevenPrefixPoint0 \
    LOCAL_PHASE_PREFIX_FOURTH_POINT1:RejectedSevenPrefixPoint1 \
    LOCAL_PHASE_PREFIX_FOURTH_POINT2:RejectedSevenPrefixPoint2 \
    LOCAL_PHASE_PREFIX_FOURTH_POINT3:RejectedSevenPrefixPoint3 \
    LOCAL_PHASE_TRANSPORT_USES_IDENTITY_FRAME:RejectedPhaseIdentityFrame \
    LOCAL_PHASE_TRANSPORT_KEEPS_OLD_ADDRESS:RejectedPhaseUnchangedAddress \
    LOCAL_PHASE_TRANSPORT_COUNTS_RAW_ADDRESSES:RejectedPhaseRepeatedReferenceAsComplete \
    LOCAL_PHASE_JOINT_QUESTIONS_MIX_ACTIONS:RejectedJointQuestionMixedActions \
    LOCAL_PHASE_INDIVIDUAL_PERIODS_ALIGN_GAMES:RejectedPhaseAlignmentFromIndividualPeriods \
    LOCAL_PHASE_UNOBSERVED_BRIDGE_ALLOWS_SWITCH:RejectedUnobservedBridgeAfterSwitch \
    LOCAL_PHASE_UNOBSERVED_BRIDGE_IDENTIFIES_LAW:RejectedUnobservedBridgeAsIdentification \
    LOCAL_PHASE_CYCLING_CLOCK_RETURN_IS_BRIDGE:RejectedCyclingClockReturnAsBridge \
    LOCAL_PHASE_CYCLING_REUSES_OLD_CLAUSE:RejectedCyclingPreviousClockClause \
    LOCAL_PHASE_CLOCK_POLICY_IGNORES_ACQUIRED_BIT:RejectedClockPolicyWrongSelection \
    LOCAL_PHASE_CLOCK_POLICY_REUSES_OLD_RECORD:RejectedClockPolicyStaleRecord \
    LOCAL_PHASE_PROBE_USES_FACT_BEFORE_CLOCK_RETURN:RejectedPhaseProbeBeforeClockReturn \
    LOCAL_PHASE_PROBE_CLOCK_RETURN_IS_WHOLE_RETURN:RejectedPhaseProbeWholeReturn \
    LOCAL_PHASE_INTERFACE_REUSES_INITIAL_CLOCK:RejectedInterfaceInitialClock \
    LOCAL_PHASE_INTERFACE_DROPS_AUXILIARY_CHANGE:RejectedInterfaceMissingAuxiliaryChange \
    LOCAL_PHASE_INTERFACE_CUBE_IS_WHOLE_RETURN:RejectedInterfaceCubeWholeReturn \
    LOCAL_PHASE_INTERFACE_SWAPS_LOGICAL_ACTION:RejectedInterfaceWrongImage \
    LOCAL_PHASE_RESIDUE_IS_WHOLE_IDENTITY:RejectedPhaseResidueWholeIdentity \
    LOCAL_PHASE_SHORT_RESET_PRESERVES_AUX:RejectedPhaseShortResetAuxiliary \
    LOCAL_PHASE_EQUAL_COUNT_IS_EQUAL_ACTION:RejectedPhaseEqualCountEqualAction \
    LOCAL_PHASE_PRIMITIVE_CORE_IS_TARGET:RejectedPrimitiveCoreAsTarget \
    LOCAL_PHASE_PRIMITIVE_RETURN_IS_IDENTITY:RejectedPrimitiveReturnAsIdentity \
    LOCAL_PHASE_Q_COMMUTES_WITH_W_SQUARED:RejectedPhaseQCommutesWithWSquared \
    LOCAL_PHASE_BASIS_MERGES_EQUAL_COST:RejectedPhaseBasisEqualCostAsEqualAction \
    LOCAL_PHASE_BASIS_REUSES_UNTRANSFORMED_SOURCE:RejectedPhaseBasisOldPrefixSource \
    LOCAL_PHASE_REDUCTION_ERASES_WW:RejectedPhaseReductionErasesWW \
    LOCAL_PHASE_REDUCTION_PRESERVES_INTERMEDIATE:RejectedPhaseReductionSameIntermediate \
    LOCAL_PHASE_FRAME_COMMON_CHANGE_IS_HARMLESS:RejectedSharedFrameChangePreservesLaw \
    LOCAL_PHASE_JOINT_REPLY_WRONG_LOOKUP:RejectedJointReplyWrongRow \
    LOCAL_PHASE_JOINT_REPLY_SAME_PRESENTATION:RejectedJointReplySamePresentation \
    LOCAL_PHASE_REPLY_EXECUTION_INVERSE_SELECTION:RejectedReplyInverseSelection \
    LOCAL_PHASE_REPLY_EXECUTION_OLD_WORKING:RejectedReplyOldWorking \
    LOCAL_PHASE_REPLY_EXECUTION_FORWARD_AS_INVERSE:RejectedReplyForwardAsInverse \
    LOCAL_PHASE_REPLY_FRAME_UNCHANGED_ACTION:RejectedReplyUnchangedActuator \
    LOCAL_PHASE_REPLY_FRAME_SAME_TRANSPORT:RejectedReplySameActuatorFrame \
    LOCAL_PHASE_ONE_REPLY_IDENTIFIES_FRAME:RejectedOneReplyIdentifiesFrame \
    LOCAL_PHASE_ONE_REPLY_WITHOUT_EVEN_SCOPE:RejectedOneReplyWithoutEvenScope \
    LOCAL_PHASE_PARTNER_IDENTIFIES_FRAME:RejectedPartnerIdentifiesFrame \
    LOCAL_PHASE_PARTNER_ARBITRARY_INPUTS:RejectedPartnerArbitraryInputs \
    LOCAL_PHASE_PARTNER_FREEZES_SOURCE:RejectedPartnerFreezesSource \
    LOCAL_PHASE_EXCURSION_INTERMEDIATE_APPLICABLE:RejectedExcursionIntermediateApplicability \
    LOCAL_PHASE_EXCURSION_TWO_READS_SUFFICE:RejectedExcursionTwoReadings \
    LOCAL_PHASE_EXCURSION_RETURN_ERASES_RECORDS:RejectedExcursionErasesRecords \
    LOCAL_PHASE_EXCURSION_MERGES_POSITIVE_MEMORY:RejectedExcursionMergesPositiveMemory \
    LOCAL_PHASE_PAIRED_UNSHARED_FRAME:RejectedPairedUnsharedFrame \
    LOCAL_PHASE_PAIRED_COLLAPSED_FRAME:RejectedPairedCollapsedFrame \
    LOCAL_PHASE_PAIRED_NO_EVEN_SCOPE:RejectedPairedNoEvenScope \
    LOCAL_PHASE_PAIRED_IDENTIFIES_CHANNELS:RejectedPairedIdentifiesChannels \
    LOCAL_PHASE_ECHO_UNKNOWN_IS_FALSE:RejectedEchoUnknownIsFalse \
    LOCAL_PHASE_ECHO_UNKNOWN_IS_TRUE:RejectedEchoUnknownIsTrue \
    LOCAL_PHASE_ECHO_SPLIT_RETURN:RejectedEchoSplitReturn \
    LOCAL_PHASE_ECHO_GLOBAL_RECOVERY:RejectedEchoGlobalRecovery \
    LOCAL_PHASE_ECHO_ORBIT_TWO_ROUNDS:RejectedEchoOrbitTwoRounds \
    LOCAL_PHASE_ECHO_ORBIT_MISSING_COVERAGE:RejectedEchoOrbitMissingCoverage \
    LOCAL_PHASE_ECHO_ORBIT_IDENTIFIES_SEED:RejectedEchoOrbitIdentifiesSeed \
    LOCAL_PHASE_ECHO_ORBIT_REINDEX_IS_RANGE:RejectedEchoOrbitReindexIsRange \
    LOCAL_PHASE_RETURN_COVERAGE_IGNORES_REPEAT:RejectedReturnCoverageIgnoresRepeat \
    LOCAL_PHASE_RETURN_COVERAGE_MERGES_SOURCES:RejectedReturnCoverageMergesSources \
    LOCAL_PHASE_RETURN_COVERAGE_IDENTIFIES_GENERATOR:RejectedReturnCoverageIdentifiesGenerator \
    LOCAL_PHASE_RETURN_COVERAGE_USES_CURRENT_TARGET:RejectedReturnCoverageUsesCurrentTarget \
LOCAL_PHASE_SEPARATION_MISSING_TRIANGLE:RejectedSeparationMissingTriangle \
LOCAL_PHASE_SEPARATION_MISSING_SPOKE:RejectedSeparationMissingSpoke \
LOCAL_PHASE_SEPARATION_SPLIT_MAP:RejectedSeparationSplitMap \
    LOCAL_PHASE_ACQUIRED_ACTION_CHANGES_QUESTION:RejectedAcquiredActionChangesQuestion \
    LOCAL_PHASE_ACQUIRED_ACTION_IDENTIFIES_FRAMES:RejectedAcquiredActionIdentifiesFrames \
    LOCAL_PHASE_ACQUIRED_ACTION_WRONG_INVERSE:RejectedAcquiredActionWrongInverse \
    LOCAL_PHASE_CONTACT_CYCLE_ONE_SQUARE:RejectedContactCycleOneSquare \
    LOCAL_PHASE_CONTACT_CYCLE_IDENTIFIES_FRAME:RejectedContactCycleIdentifiesFrame \
    LOCAL_PHASE_CONTACT_CYCLE_ADJACENT_GAPS:RejectedContactCycleAdjacentGaps \
    LOCAL_PHASE_CONTACT_CYCLE_OMITS_BIJECTION:RejectedContactCycleOmitsBijection \
    LOCAL_PHASE_CONTACT_RIGIDITY_PARTIAL:RejectedContactRigidityPartial \
    LOCAL_PHASE_CONTACT_RIGIDITY_ONE_CONTACT:RejectedContactRigidityOneContact \
    LOCAL_PHASE_CONTACT_RIGIDITY_NO_CONTRAST:RejectedContactRigidityNoContrast \
    LOCAL_PHASE_CONTACT_SUPPORT_THREE:RejectedContactSupportThree \
    LOCAL_PHASE_CONTACT_SUPPORT_PLACEMENT:RejectedContactSupportPlacement \
    LOCAL_PHASE_CONTACT_SUPPORT_FULL_Z:RejectedContactSupportFullZ \
    LOCAL_PHASE_PROFILE_THIRD:RejectedProfileThird \
    LOCAL_PHASE_PROFILE_PATTERN:RejectedProfilePattern \
    LOCAL_PHASE_PROFILE_SOURCE:RejectedProfileSource \
    LOCAL_PHASE_PROFILE_RETURN:RejectedProfileReturn \
    LOCAL_PHASE_PROFILE_IMAGE_IDENTITY:RejectedProfileImageIdentity \
    LOCAL_PHASE_PROFILE_ROTATION:RejectedProfileRotation \
    LOCAL_PHASE_PROFILE_SPARSE_PATTERN:RejectedSparseProfilePattern \
    LOCAL_PHASE_HANDOVER_RETIRED:RejectedRetiredProfileFact \
    LOCAL_PHASE_HANDOVER_UNACQUIRED:RejectedUnacquiredProfileReplacement \
    LOCAL_PHASE_HANDOVER_SOURCE:RejectedOtherProfileSource \
    LOCAL_PHASE_RELEASE_SAME:RejectedDistinctRectangleRows \
    LOCAL_PHASE_RELEASE_MISSING:RejectedRectangleWithoutLastCell \
    LOCAL_PHASE_BORROWED_EMPTY:RejectedBorrowedWordIsEmpty \
    LOCAL_PHASE_BORROWED_MIDPOINT:RejectedUnmodifiedBorrowedInterleaving \
    LOCAL_PHASE_RENEWAL_EARLY:RejectedOneCellDeterminesReplacement \
    LOCAL_PHASE_RENEWAL_NEXT:RejectedPresentSupportDeterminesNextAccess \
    LOCAL_PHASE_RENEWAL_LOCAL:RejectedLocalContrastsEstablishJointOrientation \
    LOCAL_PHASE_RENEWAL_IDLE:RejectedRenewalIsIdle \
    LOCAL_PHASE_RENEWAL_SOURCE:RejectedSecondAcquisitionUsesOldSource \
    LOCAL_PHASE_RENEWAL_ERASED:RejectedNormalizationErasesOrientation \
    LOCAL_PHASE_SHARED_STALE:RejectedSharedChartRemainsLiterallyCurrent \
    LOCAL_PHASE_SHARED_RELEASE:RejectedCurrentChartsLicenseCommonRelease \
    LOCAL_PHASE_SHARED_PARITY:RejectedReleaseParityRestoresWholePartnerChart \
    LOCAL_PHASE_SHARED_FOURTH:RejectedFourthBinaryCoordinateIsAnotherGrid \
    LOCAL_PHASE_SHARED_SOURCE:RejectedSecondSharedWriteUsesTheOldSource \
    LOCAL_PHASE_SHARED_PAYLOAD:RejectedUnchangedPayloadTableWorksAfterSharedChange \
    LOCAL_PHASE_CYCLIC_REPEAT:RejectedOnceSafeMeansRepeatSafe \
    LOCAL_PHASE_CYCLIC_ENDPOINT:RejectedSecondCyclicContactAtOldSource \
    LOCAL_PHASE_CYCLIC_RETURN:RejectedTwoCyclicContactsReturnSource \
    LOCAL_PHASE_CYCLIC_PARTNER:RejectedIsolatedRenewalMakesSharedPhasesCurrent \
    LOCAL_PHASE_FRAME_PAIR:RejectedFixedPortSelectsAnotherPair \
    LOCAL_PHASE_FRAME_WHOLE:RejectedOneFixedPortIdentifiesTheWholeFrame \
    LOCAL_PHASE_FRAME_NO_PROBE:RejectedOneUncalibratedSwapWorksInEveryFrame \
    LOCAL_PHASE_INTERFERENCE_STALE:RejectedOldFrameFactStillAnswersAfterCrossing \
    LOCAL_PHASE_INTERFERENCE_SAME:RejectedSameOldFactAndWordDetermineCurrentAnswer \
    LOCAL_PHASE_INTERFERENCE_ACTION:RejectedTheOldSelectedSwapStillCouples \
    LOCAL_PHASE_INTERFERENCE_SOURCE:RejectedReprobeCanUseThePrechangeSource \
    LOCAL_PHASE_MARKED_SEPARATE:RejectedMovingOnlyValuesPreservesTheMarkedAnswer \
    LOCAL_PHASE_MARKED_FORGOTTEN:RejectedTheUnmarkedFrameDeterminesTheMarkedQuestion \
    LOCAL_PHASE_INTERFERENCE_OPPOSITE:RejectedOppositeSwapSurvivesUnreportedTurn \
    LOCAL_PHASE_INTERFERENCE_ADJACENT:RejectedTurnParityDeterminesAdjacentSwap \
    LOCAL_PHASE_MARKED_GATED:RejectedGatedMovementIsOneFixedWholeRowExchange \
    LOCAL_PHASE_TERNARY_ZERO:RejectedJointProfileIsTheNeutralTernaryValue \
    LOCAL_PHASE_TERNARY_LEFT:RejectedJointProfileIsTheLeftTernaryValue \
    LOCAL_PHASE_TERNARY_RIGHT:RejectedJointProfileIsTheRightTernaryValue \
    LOCAL_PHASE_CHANNEL_OTHER_STEP:RejectedTwoDifferentSourceStepsFormOneOccurrence \
    LOCAL_PHASE_CHANNEL_MIXED:RejectedOldAndNewChannelFactsAreOneCurrentProfile \
    LOCAL_PHASE_CHANNEL_AUTONOMY:RejectedTheSameChannelInputHasOneSuccessor \
    LOCAL_PHASE_CHANNEL_IDENTITY:RejectedTheAvailableIdentityExtendsToTheNewPreparation \
    LOCAL_PHASE_CHANNEL_FOURTH:RejectedTheReadFourthProfileIsTheOldTernaryRow \
    LOCAL_PHASE_CHANNEL_LOSSY:RejectedEqualCurrentProfilesRecoverBothOldSources \
    LOCAL_PHASE_CHANNEL_RECORDED_SOURCE:RejectedTheJointDecoderTakesAnUnacquiredCurrentSource \
    LOCAL_PHASE_CHANNEL_PREPARATION:RejectedReturnUsesThePrecontactApplication \
    LOCAL_PHASE_CHANNEL_RESTORED:RejectedTheAcquiredReplyDescribesTheRestoredTuple \
    LOCAL_PHASE_CHANNEL_RESIDUE:RejectedTheTwoMergedInputsShareOneResidual \
    LOCAL_PHASE_CHANNEL_PROFILE_FUTURE:RejectedTheCurrentProfileDeterminesItsNextAnswer \
    LOCAL_PHASE_CHANNEL_REPEAT:RejectedARepeatedCallRepeatsThePreparedProfileLaw \
    OVERLAPPING_READING_SPLIT:RejectedTheSharedContactChangesInOnlyOneReading \
    CYCLE_ADMISSION_FALSE_ZERO:RejectedTheHiddenTrianglePassesBothCycles \
    CYCLE_ADMISSION_MIXED_SOURCE:RejectedTheSecondCycleMayComeFromAnotherRawRecord \
    REACTION_BALANCE_EMPTY:RejectedZeroDifferenceDoesNotSupplyBothReactants \
    REACTION_BALANCE_SINGLE_LOSS:RejectedIndependentLossIsTheSameJointReaction \
    DIRECTED_REPAIR_SEALED:RejectedEarlierOpeningDoesNotEnableTheSealedSource \
    DIRECTED_REPAIR_WRONG_SIDE:RejectedOppositeOpeningIsNotTheSamePreparedContact \
    DIRECTED_REPAIR_AGREEMENT:RejectedAgreementAloneDoesNotIdentifyTheRestoredContents \
    REPLICA_TWO_EXCHANGES:RejectedOneExchangeGuaranteeAfterTwoActualExchanges \
    REPLICA_NO_EQUAL_PAIR:RejectedUnequalPairCannotBeAnEqualPairReading \
    CLOCK_MASS_GROUPING:RejectedClassGroupingIsNotAutomaticallyOutcomeBalance \
    CLOCK_MASS_SOURCE:RejectedClockGroupingFromADifferentCurrentSource \
    CONTACT_MOMENT_UNCOUPLED:RejectedChangedRelativeRateKeepsTheSameBalance \
    CONTACT_MOMENT_SOURCE:RejectedMomentProofForAnotherContactRow \
    SELF_RECORD_NORMAL_AFTER_PROBE:RejectedNormalTrackingAgreementAfterTheInternalProbe \
    SELF_RECORD_STALE_SOURCE:RejectedUnperturbedAdvanceFromThePerturbedRecord \
    FRAME_SINGLE_TARGET:RejectedCurrentTargetDeterminesTheTargetAfterFrameChange \
    FRAME_STALE_PAIR:RejectedRetainedPairFromAnotherFrame \
    CHANNEL_UNREAD_MATCH:RejectedTwoRepliesEstablishTheUnmeasuredMatch \
    CHANNEL_MISSING_REPLY:RejectedOldRecordSuppliesTheFreshChannelReply \
    COARSE_FOUR_AGREEMENTS:RejectedFourAgreementsForTheUnresolvedDistinctPair \
    COARSE_CHANGING_SENSOR:RejectedDifferentSensorsAreTheSameFourReadingProfile \
    UNCALIBRATED_ODD_CLOSURE:RejectedDistinctMarkersCloseThreeReversals \
    UNCALIBRATED_FIFTH_READING:RejectedFifthReadingRemainsTheOldOpposition \
    JOINT_READOUT_INDEPENDENT:RejectedIndependentMovementPreservesDistinctReadoutCodes \
    JOINT_READOUT_PROJECTION:RejectedCoordinateCovarianceIsFixedReadoutInvariance \
    TRIPLE_ORIENTATION_MERGER:RejectedOppositeTripleContactsHaveTheSameAnswer \
    TRIPLE_ORIENTATION_STALE_CONTACT:RejectedReflectedInputUsesTheUntransportedContact \
    PHASE_CONTRAST_ERASES_TARGET:RejectedSelectedNonzeroTargetIsCancelled \
    PHASE_CONTRAST_MISSING_CORNER:RejectedSingleControlSuppliesTheDoubleControlCorner \
    DETECTOR_SQUARE_PRESERVES_NULL:RejectedInjectiveSquaringPreservesTheOldContrast \
    DETECTOR_SHARED_CONTRAST_MEANS_SAME_OFFSET:RejectedContrastPreservationRequiresIdenticalOffsets \
    FRESH_PARTNER_OLD_AGREEMENT_IS_GLOBAL:RejectedOldPartnersCertifyEveryPartner \
    FRESH_PARTNER_VISIBLE_MEANS_WHOLE:RejectedVisibleExchangeIdentifiesTheWhole \
    FRESH_PARTNER_PRIVATE_SOURCE_SUBSTITUTION:RejectedPrivateUpdateFromADifferentSource \
    OCCURRENCE_CHANGE_WRONG_SOURCE:RejectedCurrentAcquisitionUsesTheEarlierSource \
    OCCURRENCE_CHANGE_OLD:RejectedTheOldFactIsTheCurrentAnswerAfterChange \
    OCCURRENCE_CHANGE_UNLINKED:RejectedOneChangedReplyLeavesTheAcquiredChangeUnchanged \
    RELATIVE_CORRECTION_MORE_ERRORS:RejectedOneErrorConclusionCoversTwoErrors \
    RELATIVE_CORRECTION_SOURCE:RejectedCorrectedAnswerIdentifiesTheAvailableTriple \
    JOINED_CONTINUATION_HISTORY:RejectedJoinedAnswersIdentifyTheRetainedHistory \
    JOINED_CONTINUATION_CURRENT:RejectedCurrentAgreementDeterminesTheFuture \
    LOCAL_PHASE_CUT_FIRST:RejectedTheFirstBitHasItsOwnNextBit \
    LOCAL_PHASE_CUT_SECOND:RejectedTheSecondBitHasItsOwnNextBit \
    LOCAL_PHASE_CUT_RETURN:RejectedAnUnreturnedQuestionHasTheCyclicFrame \
    LOCAL_PHASE_CUT_STATIONARY:RejectedTransportPreservesTheStationaryReading \
    LOCAL_PHASE_CUT_RECORD:RejectedTheNextFactIsTheRestoredCurrentAnswer \
    LOCAL_PHASE_CONTACT_DIAGRAM_OPEN_MERGE:RejectedContactDiagramOpenMerge \
    LOCAL_PHASE_CONTACT_DIAGRAM_EXTRA_RETURN:RejectedContactDiagramExtraReturn \
    LOCAL_PHASE_CONTACT_DIAGRAM_EXTENT:RejectedContactDiagramExtent \
    LOCAL_PHASE_CONTACT_BOUNDARY_FLAT:RejectedContactBoundaryFlat \
    LOCAL_PHASE_CONTACT_BOUNDARY_HIDDEN:RejectedContactBoundaryHidden \
    LOCAL_PHASE_CONTACT_BOUNDARY_INTERIOR:RejectedContactBoundaryInterior \
    LOCAL_PHASE_CONTACT_BOUNDARY_ALTERNATION:RejectedContactBoundaryAlternation \
    LOCAL_PHASE_CONTACT_BOUNDARY_PRODUCT_AB:RejectedContactBoundaryProductAB \
    LOCAL_PHASE_CONTACT_BOUNDARY_PRODUCT_AC:RejectedContactBoundaryProductAC \
    LOCAL_PHASE_CONTACT_BOUNDARY_ONLY_FIRST:RejectedContactBoundaryOnlyFirst \
    LOCAL_PHASE_CONTACT_BOUNDARY_ONLY_SECOND:RejectedContactBoundaryOnlySecond \
    LOCAL_POLICY_HIDDEN_BRANCH:RejectedLocalHiddenBranch \
    LOCAL_POLICY_UNSENT_REQUEST:RejectedLocalUnsentRequest \
    LOCAL_POLICY_CHANGES_TABLE:RejectedLocalChangedTable \
    LOCAL_POLICY_READY_IS_REPLY:RejectedLocalReadyReply \
    LOCAL_POLICY_CONSTANT_FIRST_ANSWER:RejectedLocalFirstCollisionAnswer \
    LOCAL_POLICY_CONSTANT_SECOND_ANSWER:RejectedLocalSecondCollisionAnswer \
    LOCAL_POLICY_RENAMES_MESSAGE_ONLY:RejectedLocalMessageOnlyRename \
    LOCAL_POLICY_UNSELECTED_PRIMITIVE:RejectedLocalUnselectedPrimitive \
    LOCAL_POLICY_CURRENT_IS_ORIGINAL:RejectedLocalCurrentForOriginal \
    LOCAL_POLICY_USES_DISPLACED_PORT:RejectedLocalDisplacedProbe \
    LOCAL_POLICY_GUESSES_REPLY_QUESTION:RejectedLocalGuessedReplyQuestion \
    CONTACT_INQUIRY_WRONG_COMMAND:RejectedInquiryCommand \
    CONTACT_INQUIRY_BLIND_QUERY:RejectedInquiryBlindQuery \
    CONTACT_INQUIRY_AS_CALIBRATION:RejectedInquiryAsCalibration \
    CONTACT_INQUIRY_IGNORES_INTERVENTION:RejectedInquiryCurrentAsOriginal \
    CONTACT_INQUIRY_STAR_COLLAPSES_ANSWER:RejectedInquiryStarAnswer \
    CONTACT_STALE_CALIBRATION:RejectedStaleContactCalibration \
    CONTACT_TWO_SYMBOLS_CLOSE:RejectedTwoContactSymbols \
    CONTACT_COLLISION_REUSES_ANSWER:RejectedContactCollision \
    CONTACT_FALSE_ADMISSION:RejectedContactAdmission \
    CONTACT_CHANGES_SEAM:RejectedContactSeam \
    PUBLICATION_ARCHIVE_IS_ACTIVE:RejectedPublicationArchive \
    PUBLICATION_OTHER_QUESTION:RejectedPublicationQuestion \
    PUBLICATION_OTHER_ENCODING:RejectedPublicationEncoding \
    PUBLICATION_OTHER_SPACE:RejectedPublicationSpace \
    PUBLICATION_SAME_LABEL_DIFFERENT_READING:RejectedPublicationReadingBridge \
    PUBLICATION_COHERENT_FALSE_READINGS:RejectedCoherentPublication \
    PUBLICATION_VISIBLE_IDENTIFIES_SOURCE:RejectedPublishedIdentification
do
    verdict_flag="${verdict_case%%:*}"
    verdict_name="${verdict_case#*:}"
    if [ "$verdict_scope" = localphase ] && [[ "$verdict_flag" != LOCAL_PHASE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = localpolicy ] && [[ "$verdict_flag" != LOCAL_POLICY_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = contact ] && [[ "$verdict_flag" != CONTACT_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = publication ] && [[ "$verdict_flag" != PUBLICATION_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = discovery ]; then
        case "$verdict_flag" in
            FALSE_PAIR_SEPARATOR|FALSE_REPAIRED_BRANCH|FALSE_WHOLE_HISTORY_MERGER|RETARGETED_ORIGINAL_QUESTION|CONTROLLER_WRONG_*|DISCOVERY_*|DIAGONAL_*) ;;
            *) continue ;;
        esac
    fi
    if [ "$verdict_scope" = whole ] && [[ "$verdict_flag" != WHOLE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = ice ] && [[ "$verdict_flag" != ICE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = markers ] && [[ "$verdict_flag" != MARKER_* ]] && [[ "$verdict_flag" != BUDGET_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = uniqueness ] && [[ "$verdict_flag" != UNIQUE_* ]] && [ "$verdict_flag" != EQUALITY_IS_NOT_FLOOR ]; then
        continue
    fi
    if [ "$verdict_scope" = distance ] && [[ "$verdict_flag" != DISTANCE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = return ] && [[ "$verdict_flag" != RETURN_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = scopedlaw ] && [[ "$verdict_flag" != SLAWS_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = knowledgeclosure ] && [[ "$verdict_flag" != KCLOSURE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = frame ] && [[ "$verdict_flag" != FRAME_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = demand ] && [[ "$verdict_flag" != DEMAND_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = lawtransport ] && [[ "$verdict_flag" != LAWTRANSPORT_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = probepair ] && [[ "$verdict_flag" != PROBEPAIR_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = reuse ] && [[ "$verdict_flag" != REUSE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = routing ] && [[ "$verdict_flag" != ROUTING_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = probe ] && [[ "$verdict_flag" != PROBE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = closure ] && [[ "$verdict_flag" != CLOSURE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = evolution ] && [[ "$verdict_flag" != EVOLUTION_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = evidence ] && [[ "$verdict_flag" != EVIDENCE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = common ] && [[ "$verdict_flag" != COMMON_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = boundary ] && [[ "$verdict_flag" != BOUNDARY_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = construction ] && [[ "$verdict_flag" != CONSTRUCTION_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = resident ] && [[ "$verdict_flag" != RESIDENT_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = observer ] && [[ "$verdict_flag" != OBSERVER_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = knowledge ] && [[ "$verdict_flag" != KNOWLEDGE_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = acquisition ] && [[ "$verdict_flag" != ACQUISITION_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = interactions ] && [[ "$verdict_flag" != INTERACTION_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = seeing ] && [[ "$verdict_flag" != BAD_SENSOR_* ]]; then
        continue
    fi
    if [ "$verdict_scope" = localphase ]; then
        # The combined positive scope has already passed. Also establish
        # that this fixture stands alone before testing its one changed
        # premise. Unrelated large history proofs need not be checked again
        # for every refusal. Missing dependencies cannot count as a refusal.
        verdict_case_files=()
        while IFS= read -r verdict_case_file; do
            verdict_case_files+=("$verdict_case_file")
        done < <(rg -l --glob '*.swift' "^#if ${verdict_flag}$" Checks)
        if [ "${#verdict_case_files[@]}" -ne 1 ]; then
            echo "verdict: ERROR — expected one fixture for $verdict_flag"
            exit 1
        fi
        verdict_case_file="${verdict_case_files[0]}"
        case "$verdict_checked_files" in
            *" $verdict_case_file "*) ;;
            *)
                if ! typecheck_refusal >"$verdict_tmp/fixture-positive.log" 2>&1; then
                    cat "$verdict_tmp/fixture-positive.log"
                    echo "verdict: ERROR — standalone positive failed for $verdict_case_file"
                    exit 1
                fi
                verdict_checked_files="$verdict_checked_files$verdict_case_file "
                ;;
        esac
    fi
    verdict_log="$verdict_tmp/$verdict_flag.log"
    if typecheck_refusal "-D$verdict_flag" >"$verdict_log" 2>&1; then
        echo "verdict: ERROR — $verdict_flag was accepted"
        exit 1
    else
        verdict_status=$?
    fi
    # A compiler crash or exhausted solver is not a proof of incompatibility.
    # Swift's ordinary type-checking refusals exit 1 and name the broken seam.
    if [ "$verdict_status" -ne 1 ] || grep -Eq \
        'Stack dump:|[Pp][Ll][Ee][Aa][Ss][Ee] submit a bug report|Assertion failed|cannot build rewrite system|rule (length|count) limit exceeded|reasonable time' \
        "$verdict_log"; then
        cat "$verdict_log"
        echo "verdict: ERROR — compiler could not check $verdict_flag (exit $verdict_status)"
        exit 1
    fi
    if ! grep -q 'error:' "$verdict_log" || ! grep -q "$verdict_name" "$verdict_log"; then
        cat "$verdict_log"
        echo "verdict: ERROR — failure did not name $verdict_name"
        exit 1
    fi
    echo "verdict: refused $verdict_flag"
done
