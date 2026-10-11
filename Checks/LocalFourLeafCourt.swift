import VerificationIsIdentification
import Examples

// Use with LocalPolicyCourt.swift. All obligations name fields of the current
// word constructors. The court reads these finite source/endpoint seams directly.
public enum FourCourtO: Close {}
public enum FourCourtA: Close {}
public enum FourCourtB: Close {}
public enum FourCourtC: Close {}
public enum FourCourtD: Close {}
public typealias FourCourtStageInput = FourLeafStageLabels<FourCourtO, FourCourtA, FourCourtB, FourCourtC, FourCourtD>
public typealias FourCourtPhaseInput = BoundaryWorking<FourCourtA, FourCourtB, FourCourtC, FourCourtD>

public typealias FourCourtWStage = FourLeafStageWord<FourCourtO, FourCourtA, FourCourtB, FourCourtC, FourCourtD>

public typealias FourCourtWPhase = FourLeafPhaseWord<FourCourtA, FourCourtB, FourCourtC, FourCourtD>

public typealias FourCourtZStage = FourLeafShortStageWord<FourCourtO, FourCourtA, FourCourtB, FourCourtC, FourCourtD>

public typealias FourCourtZPhase = FourLeafShortPhaseWord<FourCourtA, FourCourtB, FourCourtC, FourCourtD>

public typealias FourCourtWStageStart = LocalCourtSame<FourCourtWStage.S0.Left, FourCourtStageInput>
public typealias FourCourtWStageSeam0 = LocalCourtSame<FourCourtWStage.S0.Right, FourCourtWStage.S1.Left>
public typealias FourCourtWStageSeam1 = LocalCourtSame<FourCourtWStage.S1.Right, FourCourtWStage.S2.Left>
public typealias FourCourtWStageSeam2 = LocalCourtSame<FourCourtWStage.S2.Right, FourCourtWStage.S3.Left>
public typealias FourCourtWStageSeam3 = LocalCourtSame<FourCourtWStage.S3.Right, FourCourtWStage.S4.Left>
public typealias FourCourtWStageSeam4 = LocalCourtSame<FourCourtWStage.S4.Right, FourCourtWStage.S5.Left>
public typealias FourCourtWStageSeam5 = LocalCourtSame<FourCourtWStage.S5.Right, FourCourtWStage.S6.Left>
public typealias FourCourtWStageSeam6 = LocalCourtSame<FourCourtWStage.S6.Right, FourCourtWStage.S7.Left>
public typealias FourCourtWStageSeam7 = LocalCourtSame<FourCourtWStage.S7.Right, FourCourtWStage.S8.Left>
public typealias FourCourtWStageSeam8 = LocalCourtSame<FourCourtWStage.S8.Right, FourCourtWStage.S9.Left>
public typealias FourCourtWStageSeam9 = LocalCourtSame<FourCourtWStage.S9.Right, FourCourtWStage.S10.Left>
public typealias FourCourtWStageSeam10 = LocalCourtSame<FourCourtWStage.S10.Right, FourCourtWStage.S11.Left>
public typealias FourCourtWStageEnd = LocalCourtSame<FourCourtWStage.S11.Right, FourCourtStageInput>
public typealias FourCourtWPhaseStart = LocalCourtSame<FourCourtWPhase.S0.Left, FourCourtPhaseInput>
public typealias FourCourtWPhaseSeam0 = LocalCourtSame<FourCourtWPhase.S0.Right, FourCourtWPhase.S1.Left>
public typealias FourCourtWPhaseSeam1 = LocalCourtSame<FourCourtWPhase.S1.Right, FourCourtWPhase.S2.Left>
public typealias FourCourtWPhaseSeam2 = LocalCourtSame<FourCourtWPhase.S2.Right, FourCourtWPhase.S3.Left>
public typealias FourCourtWPhaseSeam3 = LocalCourtSame<FourCourtWPhase.S3.Right, FourCourtWPhase.S4.Left>
public typealias FourCourtWPhaseSeam4 = LocalCourtSame<FourCourtWPhase.S4.Right, FourCourtWPhase.S5.Left>
public typealias FourCourtWPhaseSeam5 = LocalCourtSame<FourCourtWPhase.S5.Right, FourCourtWPhase.S6.Left>
public typealias FourCourtWPhaseSeam6 = LocalCourtSame<FourCourtWPhase.S6.Right, FourCourtWPhase.S7.Left>
public typealias FourCourtWPhaseSeam7 = LocalCourtSame<FourCourtWPhase.S7.Right, FourCourtWPhase.S8.Left>
public typealias FourCourtWPhaseSeam8 = LocalCourtSame<FourCourtWPhase.S8.Right, FourCourtWPhase.S9.Left>
public typealias FourCourtWPhaseSeam9 = LocalCourtSame<FourCourtWPhase.S9.Right, FourCourtWPhase.S10.Left>
public typealias FourCourtWPhaseSeam10 = LocalCourtSame<FourCourtWPhase.S10.Right, FourCourtWPhase.S11.Left>
public typealias FourCourtWPhaseEnd = LocalCourtSame<FourCourtWPhase.S11.Right, BoundaryWorking<FourCourtD, FourCourtB, FourCourtA, FourCourtC>>
public typealias FourCourtZStageStart = LocalCourtSame<FourCourtZStage.S0.Left, FourCourtStageInput>
public typealias FourCourtZStageSeam0 = LocalCourtSame<FourCourtZStage.S0.Right, FourCourtZStage.S1.Left>
public typealias FourCourtZStageSeam1 = LocalCourtSame<FourCourtZStage.S1.Right, FourCourtZStage.S2.Left>
public typealias FourCourtZStageSeam2 = LocalCourtSame<FourCourtZStage.S2.Right, FourCourtZStage.S3.Left>
public typealias FourCourtZStageSeam3 = LocalCourtSame<FourCourtZStage.S3.Right, FourCourtZStage.S4.Left>
public typealias FourCourtZStageSeam4 = LocalCourtSame<FourCourtZStage.S4.Right, FourCourtZStage.S5.Left>
public typealias FourCourtZStageEnd = LocalCourtSame<FourCourtZStage.S5.Right, FourCourtStageInput>
public typealias FourCourtZPhaseStart = LocalCourtSame<FourCourtZPhase.S0.Left, FourCourtPhaseInput>
public typealias FourCourtZPhaseSeam0 = LocalCourtSame<FourCourtZPhase.S0.Right, FourCourtZPhase.S1.Left>
public typealias FourCourtZPhaseSeam1 = LocalCourtSame<FourCourtZPhase.S1.Right, FourCourtZPhase.S2.Left>
public typealias FourCourtZPhaseSeam2 = LocalCourtSame<FourCourtZPhase.S2.Right, FourCourtZPhase.S3.Left>
public typealias FourCourtZPhaseSeam3 = LocalCourtSame<FourCourtZPhase.S3.Right, FourCourtZPhase.S4.Left>
public typealias FourCourtZPhaseSeam4 = LocalCourtSame<FourCourtZPhase.S4.Right, FourCourtZPhase.S5.Left>
public typealias FourCourtZPhaseEnd = LocalCourtSame<FourCourtZPhase.S5.Right, BoundaryWorking<FourCourtB, FourCourtA, FourCourtD, FourCourtC>>
public typealias FourCourtTokenZeroDestination = LocalCourtSame<FourCourtWPhase.S11.Right.Right.Left, FourCourtA>
public typealias FourCourtTokenAtFinalZero = LocalCourtSame<FourCourtWPhase.S11.Right.Left.Left, FourCourtD>

// Force those same conditional equalities when Swift is the independent court.
public typealias FourCourtUseWStageStart = LocalCourtUse<FourCourtWStageStart>
public typealias FourCourtUseWStageSeam0 = LocalCourtUse<FourCourtWStageSeam0>
public typealias FourCourtUseWStageSeam1 = LocalCourtUse<FourCourtWStageSeam1>
public typealias FourCourtUseWStageSeam2 = LocalCourtUse<FourCourtWStageSeam2>
public typealias FourCourtUseWStageSeam3 = LocalCourtUse<FourCourtWStageSeam3>
public typealias FourCourtUseWStageSeam4 = LocalCourtUse<FourCourtWStageSeam4>
public typealias FourCourtUseWStageSeam5 = LocalCourtUse<FourCourtWStageSeam5>
public typealias FourCourtUseWStageSeam6 = LocalCourtUse<FourCourtWStageSeam6>
public typealias FourCourtUseWStageSeam7 = LocalCourtUse<FourCourtWStageSeam7>
public typealias FourCourtUseWStageSeam8 = LocalCourtUse<FourCourtWStageSeam8>
public typealias FourCourtUseWStageSeam9 = LocalCourtUse<FourCourtWStageSeam9>
public typealias FourCourtUseWStageSeam10 = LocalCourtUse<FourCourtWStageSeam10>
public typealias FourCourtUseWStageEnd = LocalCourtUse<FourCourtWStageEnd>
public typealias FourCourtUseWPhaseStart = LocalCourtUse<FourCourtWPhaseStart>
public typealias FourCourtUseWPhaseSeam0 = LocalCourtUse<FourCourtWPhaseSeam0>
public typealias FourCourtUseWPhaseSeam1 = LocalCourtUse<FourCourtWPhaseSeam1>
public typealias FourCourtUseWPhaseSeam2 = LocalCourtUse<FourCourtWPhaseSeam2>
public typealias FourCourtUseWPhaseSeam3 = LocalCourtUse<FourCourtWPhaseSeam3>
public typealias FourCourtUseWPhaseSeam4 = LocalCourtUse<FourCourtWPhaseSeam4>
public typealias FourCourtUseWPhaseSeam5 = LocalCourtUse<FourCourtWPhaseSeam5>
public typealias FourCourtUseWPhaseSeam6 = LocalCourtUse<FourCourtWPhaseSeam6>
public typealias FourCourtUseWPhaseSeam7 = LocalCourtUse<FourCourtWPhaseSeam7>
public typealias FourCourtUseWPhaseSeam8 = LocalCourtUse<FourCourtWPhaseSeam8>
public typealias FourCourtUseWPhaseSeam9 = LocalCourtUse<FourCourtWPhaseSeam9>
public typealias FourCourtUseWPhaseSeam10 = LocalCourtUse<FourCourtWPhaseSeam10>
public typealias FourCourtUseWPhaseEnd = LocalCourtUse<FourCourtWPhaseEnd>
public typealias FourCourtUseZStageStart = LocalCourtUse<FourCourtZStageStart>
public typealias FourCourtUseZStageSeam0 = LocalCourtUse<FourCourtZStageSeam0>
public typealias FourCourtUseZStageSeam1 = LocalCourtUse<FourCourtZStageSeam1>
public typealias FourCourtUseZStageSeam2 = LocalCourtUse<FourCourtZStageSeam2>
public typealias FourCourtUseZStageSeam3 = LocalCourtUse<FourCourtZStageSeam3>
public typealias FourCourtUseZStageSeam4 = LocalCourtUse<FourCourtZStageSeam4>
public typealias FourCourtUseZStageEnd = LocalCourtUse<FourCourtZStageEnd>
public typealias FourCourtUseZPhaseStart = LocalCourtUse<FourCourtZPhaseStart>
public typealias FourCourtUseZPhaseSeam0 = LocalCourtUse<FourCourtZPhaseSeam0>
public typealias FourCourtUseZPhaseSeam1 = LocalCourtUse<FourCourtZPhaseSeam1>
public typealias FourCourtUseZPhaseSeam2 = LocalCourtUse<FourCourtZPhaseSeam2>
public typealias FourCourtUseZPhaseSeam3 = LocalCourtUse<FourCourtZPhaseSeam3>
public typealias FourCourtUseZPhaseSeam4 = LocalCourtUse<FourCourtZPhaseSeam4>
public typealias FourCourtUseZPhaseEnd = LocalCourtUse<FourCourtZPhaseEnd>
public typealias FourCourtUseTokenZeroDestination = LocalCourtUse<FourCourtTokenZeroDestination>
public typealias FourCourtUseTokenAtFinalZero = LocalCourtUse<FourCourtTokenAtFinalZero>

// Independently specified word: equal endpoints do not choose an operation.
public typealias FourCourtWStageOperation0 = LocalCourtSame<FourCourtWStage.S0, FourLeafStage0<FourCourtWStage.S0.Left.Left, FourCourtWStage.S0.Left.Right.Left.Left, FourCourtWStage.S0.Left.Right.Left.Right, FourCourtWStage.S0.Left.Right.Right.Left, FourCourtWStage.S0.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation1 = LocalCourtSame<FourCourtWStage.S1, FourLeafStage2<FourCourtWStage.S1.Left.Left, FourCourtWStage.S1.Left.Right.Left.Left, FourCourtWStage.S1.Left.Right.Left.Right, FourCourtWStage.S1.Left.Right.Right.Left, FourCourtWStage.S1.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation2 = LocalCourtSame<FourCourtWStage.S2, FourLeafStage0<FourCourtWStage.S2.Left.Left, FourCourtWStage.S2.Left.Right.Left.Left, FourCourtWStage.S2.Left.Right.Left.Right, FourCourtWStage.S2.Left.Right.Right.Left, FourCourtWStage.S2.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation3 = LocalCourtSame<FourCourtWStage.S3, FourLeafStage1<FourCourtWStage.S3.Left.Left, FourCourtWStage.S3.Left.Right.Left.Left, FourCourtWStage.S3.Left.Right.Left.Right, FourCourtWStage.S3.Left.Right.Right.Left, FourCourtWStage.S3.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation4 = LocalCourtSame<FourCourtWStage.S4, FourLeafStage3<FourCourtWStage.S4.Left.Left, FourCourtWStage.S4.Left.Right.Left.Left, FourCourtWStage.S4.Left.Right.Left.Right, FourCourtWStage.S4.Left.Right.Right.Left, FourCourtWStage.S4.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation5 = LocalCourtSame<FourCourtWStage.S5, FourLeafStage1<FourCourtWStage.S5.Left.Left, FourCourtWStage.S5.Left.Right.Left.Left, FourCourtWStage.S5.Left.Right.Left.Right, FourCourtWStage.S5.Left.Right.Right.Left, FourCourtWStage.S5.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation6 = LocalCourtSame<FourCourtWStage.S6, FourLeafStage0<FourCourtWStage.S6.Left.Left, FourCourtWStage.S6.Left.Right.Left.Left, FourCourtWStage.S6.Left.Right.Left.Right, FourCourtWStage.S6.Left.Right.Right.Left, FourCourtWStage.S6.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation7 = LocalCourtSame<FourCourtWStage.S7, FourLeafStage2<FourCourtWStage.S7.Left.Left, FourCourtWStage.S7.Left.Right.Left.Left, FourCourtWStage.S7.Left.Right.Left.Right, FourCourtWStage.S7.Left.Right.Right.Left, FourCourtWStage.S7.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation8 = LocalCourtSame<FourCourtWStage.S8, FourLeafStage0<FourCourtWStage.S8.Left.Left, FourCourtWStage.S8.Left.Right.Left.Left, FourCourtWStage.S8.Left.Right.Left.Right, FourCourtWStage.S8.Left.Right.Right.Left, FourCourtWStage.S8.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation9 = LocalCourtSame<FourCourtWStage.S9, FourLeafStage1<FourCourtWStage.S9.Left.Left, FourCourtWStage.S9.Left.Right.Left.Left, FourCourtWStage.S9.Left.Right.Left.Right, FourCourtWStage.S9.Left.Right.Right.Left, FourCourtWStage.S9.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation10 = LocalCourtSame<FourCourtWStage.S10, FourLeafStage3<FourCourtWStage.S10.Left.Left, FourCourtWStage.S10.Left.Right.Left.Left, FourCourtWStage.S10.Left.Right.Left.Right, FourCourtWStage.S10.Left.Right.Right.Left, FourCourtWStage.S10.Left.Right.Right.Right>>
public typealias FourCourtWStageOperation11 = LocalCourtSame<FourCourtWStage.S11, FourLeafStage1<FourCourtWStage.S11.Left.Left, FourCourtWStage.S11.Left.Right.Left.Left, FourCourtWStage.S11.Left.Right.Left.Right, FourCourtWStage.S11.Left.Right.Right.Left, FourCourtWStage.S11.Left.Right.Right.Right>>
public typealias FourCourtWPhaseOperation0 = LocalCourtSame<FourCourtWPhase.S0, FourLeafPhase0<FourCourtWPhase.S0.Left.Left.Left, FourCourtWPhase.S0.Left.Left.Right, FourCourtWPhase.S0.Left.Right.Left, FourCourtWPhase.S0.Left.Right.Right>>
public typealias FourCourtWPhaseOperation1 = LocalCourtSame<FourCourtWPhase.S1, FourLeafPhase2<FourCourtWPhase.S1.Left.Left.Left, FourCourtWPhase.S1.Left.Left.Right, FourCourtWPhase.S1.Left.Right.Left, FourCourtWPhase.S1.Left.Right.Right>>
public typealias FourCourtWPhaseOperation2 = LocalCourtSame<FourCourtWPhase.S2, FourLeafPhase0<FourCourtWPhase.S2.Left.Left.Left, FourCourtWPhase.S2.Left.Left.Right, FourCourtWPhase.S2.Left.Right.Left, FourCourtWPhase.S2.Left.Right.Right>>
public typealias FourCourtWPhaseOperation3 = LocalCourtSame<FourCourtWPhase.S3, FourLeafPhase1<FourCourtWPhase.S3.Left.Left.Left, FourCourtWPhase.S3.Left.Left.Right, FourCourtWPhase.S3.Left.Right.Left, FourCourtWPhase.S3.Left.Right.Right>>
public typealias FourCourtWPhaseOperation4 = LocalCourtSame<FourCourtWPhase.S4, FourLeafPhase3<FourCourtWPhase.S4.Left.Left.Left, FourCourtWPhase.S4.Left.Left.Right, FourCourtWPhase.S4.Left.Right.Left, FourCourtWPhase.S4.Left.Right.Right>>
public typealias FourCourtWPhaseOperation5 = LocalCourtSame<FourCourtWPhase.S5, FourLeafPhase1<FourCourtWPhase.S5.Left.Left.Left, FourCourtWPhase.S5.Left.Left.Right, FourCourtWPhase.S5.Left.Right.Left, FourCourtWPhase.S5.Left.Right.Right>>
public typealias FourCourtWPhaseOperation6 = LocalCourtSame<FourCourtWPhase.S6, FourLeafPhase0<FourCourtWPhase.S6.Left.Left.Left, FourCourtWPhase.S6.Left.Left.Right, FourCourtWPhase.S6.Left.Right.Left, FourCourtWPhase.S6.Left.Right.Right>>
public typealias FourCourtWPhaseOperation7 = LocalCourtSame<FourCourtWPhase.S7, FourLeafPhase2<FourCourtWPhase.S7.Left.Left.Left, FourCourtWPhase.S7.Left.Left.Right, FourCourtWPhase.S7.Left.Right.Left, FourCourtWPhase.S7.Left.Right.Right>>
public typealias FourCourtWPhaseOperation8 = LocalCourtSame<FourCourtWPhase.S8, FourLeafPhase0<FourCourtWPhase.S8.Left.Left.Left, FourCourtWPhase.S8.Left.Left.Right, FourCourtWPhase.S8.Left.Right.Left, FourCourtWPhase.S8.Left.Right.Right>>
public typealias FourCourtWPhaseOperation9 = LocalCourtSame<FourCourtWPhase.S9, FourLeafPhase1<FourCourtWPhase.S9.Left.Left.Left, FourCourtWPhase.S9.Left.Left.Right, FourCourtWPhase.S9.Left.Right.Left, FourCourtWPhase.S9.Left.Right.Right>>
public typealias FourCourtWPhaseOperation10 = LocalCourtSame<FourCourtWPhase.S10, FourLeafPhase3<FourCourtWPhase.S10.Left.Left.Left, FourCourtWPhase.S10.Left.Left.Right, FourCourtWPhase.S10.Left.Right.Left, FourCourtWPhase.S10.Left.Right.Right>>
public typealias FourCourtWPhaseOperation11 = LocalCourtSame<FourCourtWPhase.S11, FourLeafPhase1<FourCourtWPhase.S11.Left.Left.Left, FourCourtWPhase.S11.Left.Left.Right, FourCourtWPhase.S11.Left.Right.Left, FourCourtWPhase.S11.Left.Right.Right>>
public typealias FourCourtZStageOperation0 = LocalCourtSame<FourCourtZStage.S0, FourLeafStage0<FourCourtZStage.S0.Left.Left, FourCourtZStage.S0.Left.Right.Left.Left, FourCourtZStage.S0.Left.Right.Left.Right, FourCourtZStage.S0.Left.Right.Right.Left, FourCourtZStage.S0.Left.Right.Right.Right>>
public typealias FourCourtZStageOperation1 = LocalCourtSame<FourCourtZStage.S1, FourLeafStage2<FourCourtZStage.S1.Left.Left, FourCourtZStage.S1.Left.Right.Left.Left, FourCourtZStage.S1.Left.Right.Left.Right, FourCourtZStage.S1.Left.Right.Right.Left, FourCourtZStage.S1.Left.Right.Right.Right>>
public typealias FourCourtZStageOperation2 = LocalCourtSame<FourCourtZStage.S2, FourLeafStage0<FourCourtZStage.S2.Left.Left, FourCourtZStage.S2.Left.Right.Left.Left, FourCourtZStage.S2.Left.Right.Left.Right, FourCourtZStage.S2.Left.Right.Right.Left, FourCourtZStage.S2.Left.Right.Right.Right>>
public typealias FourCourtZStageOperation3 = LocalCourtSame<FourCourtZStage.S3, FourLeafStage2<FourCourtZStage.S3.Left.Left, FourCourtZStage.S3.Left.Right.Left.Left, FourCourtZStage.S3.Left.Right.Left.Right, FourCourtZStage.S3.Left.Right.Right.Left, FourCourtZStage.S3.Left.Right.Right.Right>>
public typealias FourCourtZStageOperation4 = LocalCourtSame<FourCourtZStage.S4, FourLeafStage0<FourCourtZStage.S4.Left.Left, FourCourtZStage.S4.Left.Right.Left.Left, FourCourtZStage.S4.Left.Right.Left.Right, FourCourtZStage.S4.Left.Right.Right.Left, FourCourtZStage.S4.Left.Right.Right.Right>>
public typealias FourCourtZStageOperation5 = LocalCourtSame<FourCourtZStage.S5, FourLeafStage2<FourCourtZStage.S5.Left.Left, FourCourtZStage.S5.Left.Right.Left.Left, FourCourtZStage.S5.Left.Right.Left.Right, FourCourtZStage.S5.Left.Right.Right.Left, FourCourtZStage.S5.Left.Right.Right.Right>>
public typealias FourCourtZPhaseOperation0 = LocalCourtSame<FourCourtZPhase.S0, FourLeafPhase0<FourCourtZPhase.S0.Left.Left.Left, FourCourtZPhase.S0.Left.Left.Right, FourCourtZPhase.S0.Left.Right.Left, FourCourtZPhase.S0.Left.Right.Right>>
public typealias FourCourtZPhaseOperation1 = LocalCourtSame<FourCourtZPhase.S1, FourLeafPhase2<FourCourtZPhase.S1.Left.Left.Left, FourCourtZPhase.S1.Left.Left.Right, FourCourtZPhase.S1.Left.Right.Left, FourCourtZPhase.S1.Left.Right.Right>>
public typealias FourCourtZPhaseOperation2 = LocalCourtSame<FourCourtZPhase.S2, FourLeafPhase0<FourCourtZPhase.S2.Left.Left.Left, FourCourtZPhase.S2.Left.Left.Right, FourCourtZPhase.S2.Left.Right.Left, FourCourtZPhase.S2.Left.Right.Right>>
public typealias FourCourtZPhaseOperation3 = LocalCourtSame<FourCourtZPhase.S3, FourLeafPhase2<FourCourtZPhase.S3.Left.Left.Left, FourCourtZPhase.S3.Left.Left.Right, FourCourtZPhase.S3.Left.Right.Left, FourCourtZPhase.S3.Left.Right.Right>>
public typealias FourCourtZPhaseOperation4 = LocalCourtSame<FourCourtZPhase.S4, FourLeafPhase0<FourCourtZPhase.S4.Left.Left.Left, FourCourtZPhase.S4.Left.Left.Right, FourCourtZPhase.S4.Left.Right.Left, FourCourtZPhase.S4.Left.Right.Right>>
public typealias FourCourtZPhaseOperation5 = LocalCourtSame<FourCourtZPhase.S5, FourLeafPhase2<FourCourtZPhase.S5.Left.Left.Left, FourCourtZPhase.S5.Left.Left.Right, FourCourtZPhase.S5.Left.Right.Left, FourCourtZPhase.S5.Left.Right.Right>>
public typealias FourCourtPhaseContact0 = LocalCourtSame<FourLeafPhase0<FourCourtA, FourCourtB, FourCourtC, FourCourtD>.Right, BoundaryWorking<FourCourtB, FourCourtA, FourCourtC, FourCourtD>>
public typealias FourCourtStageContact0 = LocalCourtSame<FourLeafStage0<FourCourtO, FourCourtA, FourCourtB, FourCourtC, FourCourtD>.Right, FourLeafStageLabels<FourCourtA, FourCourtO, FourCourtB, FourCourtC, FourCourtD>>
public typealias FourCourtPhaseContact1 = LocalCourtSame<FourLeafPhase1<FourCourtA, FourCourtB, FourCourtC, FourCourtD>.Right, BoundaryWorking<FourCourtA, FourCourtC, FourCourtB, FourCourtD>>
public typealias FourCourtStageContact1 = LocalCourtSame<FourLeafStage1<FourCourtO, FourCourtA, FourCourtB, FourCourtC, FourCourtD>.Right, FourLeafStageLabels<FourCourtB, FourCourtA, FourCourtO, FourCourtC, FourCourtD>>
public typealias FourCourtPhaseContact2 = LocalCourtSame<FourLeafPhase2<FourCourtA, FourCourtB, FourCourtC, FourCourtD>.Right, BoundaryWorking<FourCourtA, FourCourtB, FourCourtD, FourCourtC>>
public typealias FourCourtStageContact2 = LocalCourtSame<FourLeafStage2<FourCourtO, FourCourtA, FourCourtB, FourCourtC, FourCourtD>.Right, FourLeafStageLabels<FourCourtC, FourCourtA, FourCourtB, FourCourtO, FourCourtD>>
public typealias FourCourtPhaseContact3 = LocalCourtSame<FourLeafPhase3<FourCourtA, FourCourtB, FourCourtC, FourCourtD>.Right, BoundaryWorking<FourCourtD, FourCourtB, FourCourtC, FourCourtA>>
public typealias FourCourtStageContact3 = LocalCourtSame<FourLeafStage3<FourCourtO, FourCourtA, FourCourtB, FourCourtC, FourCourtD>.Right, FourLeafStageLabels<FourCourtD, FourCourtA, FourCourtB, FourCourtC, FourCourtO>>
public typealias FourCourtUseWStageOperation0 = LocalCourtUse<FourCourtWStageOperation0>
public typealias FourCourtUseWStageOperation1 = LocalCourtUse<FourCourtWStageOperation1>
public typealias FourCourtUseWStageOperation2 = LocalCourtUse<FourCourtWStageOperation2>
public typealias FourCourtUseWStageOperation3 = LocalCourtUse<FourCourtWStageOperation3>
public typealias FourCourtUseWStageOperation4 = LocalCourtUse<FourCourtWStageOperation4>
public typealias FourCourtUseWStageOperation5 = LocalCourtUse<FourCourtWStageOperation5>
public typealias FourCourtUseWStageOperation6 = LocalCourtUse<FourCourtWStageOperation6>
public typealias FourCourtUseWStageOperation7 = LocalCourtUse<FourCourtWStageOperation7>
public typealias FourCourtUseWStageOperation8 = LocalCourtUse<FourCourtWStageOperation8>
public typealias FourCourtUseWStageOperation9 = LocalCourtUse<FourCourtWStageOperation9>
public typealias FourCourtUseWStageOperation10 = LocalCourtUse<FourCourtWStageOperation10>
public typealias FourCourtUseWStageOperation11 = LocalCourtUse<FourCourtWStageOperation11>
public typealias FourCourtUseWPhaseOperation0 = LocalCourtUse<FourCourtWPhaseOperation0>
public typealias FourCourtUseWPhaseOperation1 = LocalCourtUse<FourCourtWPhaseOperation1>
public typealias FourCourtUseWPhaseOperation2 = LocalCourtUse<FourCourtWPhaseOperation2>
public typealias FourCourtUseWPhaseOperation3 = LocalCourtUse<FourCourtWPhaseOperation3>
public typealias FourCourtUseWPhaseOperation4 = LocalCourtUse<FourCourtWPhaseOperation4>
public typealias FourCourtUseWPhaseOperation5 = LocalCourtUse<FourCourtWPhaseOperation5>
public typealias FourCourtUseWPhaseOperation6 = LocalCourtUse<FourCourtWPhaseOperation6>
public typealias FourCourtUseWPhaseOperation7 = LocalCourtUse<FourCourtWPhaseOperation7>
public typealias FourCourtUseWPhaseOperation8 = LocalCourtUse<FourCourtWPhaseOperation8>
public typealias FourCourtUseWPhaseOperation9 = LocalCourtUse<FourCourtWPhaseOperation9>
public typealias FourCourtUseWPhaseOperation10 = LocalCourtUse<FourCourtWPhaseOperation10>
public typealias FourCourtUseWPhaseOperation11 = LocalCourtUse<FourCourtWPhaseOperation11>
public typealias FourCourtUseZStageOperation0 = LocalCourtUse<FourCourtZStageOperation0>
public typealias FourCourtUseZStageOperation1 = LocalCourtUse<FourCourtZStageOperation1>
public typealias FourCourtUseZStageOperation2 = LocalCourtUse<FourCourtZStageOperation2>
public typealias FourCourtUseZStageOperation3 = LocalCourtUse<FourCourtZStageOperation3>
public typealias FourCourtUseZStageOperation4 = LocalCourtUse<FourCourtZStageOperation4>
public typealias FourCourtUseZStageOperation5 = LocalCourtUse<FourCourtZStageOperation5>
public typealias FourCourtUseZPhaseOperation0 = LocalCourtUse<FourCourtZPhaseOperation0>
public typealias FourCourtUseZPhaseOperation1 = LocalCourtUse<FourCourtZPhaseOperation1>
public typealias FourCourtUseZPhaseOperation2 = LocalCourtUse<FourCourtZPhaseOperation2>
public typealias FourCourtUseZPhaseOperation3 = LocalCourtUse<FourCourtZPhaseOperation3>
public typealias FourCourtUseZPhaseOperation4 = LocalCourtUse<FourCourtZPhaseOperation4>
public typealias FourCourtUseZPhaseOperation5 = LocalCourtUse<FourCourtZPhaseOperation5>
public typealias FourCourtUsePhaseContact0 = LocalCourtUse<FourCourtPhaseContact0>
public typealias FourCourtUseStageContact0 = LocalCourtUse<FourCourtStageContact0>
public typealias FourCourtUsePhaseContact1 = LocalCourtUse<FourCourtPhaseContact1>
public typealias FourCourtUseStageContact1 = LocalCourtUse<FourCourtStageContact1>
public typealias FourCourtUsePhaseContact2 = LocalCourtUse<FourCourtPhaseContact2>
public typealias FourCourtUseStageContact2 = LocalCourtUse<FourCourtStageContact2>
public typealias FourCourtUsePhaseContact3 = LocalCourtUse<FourCourtPhaseContact3>
public typealias FourCourtUseStageContact3 = LocalCourtUse<FourCourtStageContact3>

// Bind the actual declared Path to the independently specified ordered tree.
public typealias FourCourtWStagePathStructure = LocalCourtSame<FourCourtWStage.Path, FollowedPair<FollowedPair<FollowedPair<FollowedPair<FourCourtWStage.S0, FourCourtWStage.S1>, FourCourtWStage.S2>, FollowedPair<FollowedPair<FourCourtWStage.S3, FourCourtWStage.S4>, FourCourtWStage.S5>>, FollowedPair<FollowedPair<FollowedPair<FourCourtWStage.S6, FourCourtWStage.S7>, FourCourtWStage.S8>, FollowedPair<FollowedPair<FourCourtWStage.S9, FourCourtWStage.S10>, FourCourtWStage.S11>>>>
public typealias FourCourtWStageUsePathStructure = LocalCourtUse<FourCourtWStagePathStructure>
public typealias FourCourtWPhasePathStructure = LocalCourtSame<FourCourtWPhase.Path, FollowedPair<FollowedPair<FollowedPair<FollowedPair<FourCourtWPhase.S0, FourCourtWPhase.S1>, FourCourtWPhase.S2>, FollowedPair<FollowedPair<FourCourtWPhase.S3, FourCourtWPhase.S4>, FourCourtWPhase.S5>>, FollowedPair<FollowedPair<FollowedPair<FourCourtWPhase.S6, FourCourtWPhase.S7>, FourCourtWPhase.S8>, FollowedPair<FollowedPair<FourCourtWPhase.S9, FourCourtWPhase.S10>, FourCourtWPhase.S11>>>>
public typealias FourCourtWPhaseUsePathStructure = LocalCourtUse<FourCourtWPhasePathStructure>
public typealias FourCourtZStagePathStructure = LocalCourtSame<FourCourtZStage.Path, FollowedPair<FollowedPair<FollowedPair<FourCourtZStage.S0, FourCourtZStage.S1>, FollowedPair<FourCourtZStage.S2, FourCourtZStage.S3>>, FollowedPair<FourCourtZStage.S4, FourCourtZStage.S5>>>
public typealias FourCourtZStageUsePathStructure = LocalCourtUse<FourCourtZStagePathStructure>
public typealias FourCourtZPhasePathStructure = LocalCourtSame<FourCourtZPhase.Path, FollowedPair<FollowedPair<FollowedPair<FourCourtZPhase.S0, FourCourtZPhase.S1>, FollowedPair<FourCourtZPhase.S2, FourCourtZPhase.S3>>, FollowedPair<FourCourtZPhase.S4, FourCourtZPhase.S5>>>
public typealias FourCourtZPhaseUsePathStructure = LocalCourtUse<FourCourtZPhasePathStructure>
