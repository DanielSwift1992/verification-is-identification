import VerificationIsIdentification

/// All four phase preparations at one declared stage, with the same carried
/// program and laboratory context. This is the independent product support.
public typealias FourLeafStagePreparations<S: Structure, K: Structure> = BoundaryWorking<
    LocalPhaseWorld<S, FourLeafPhaseMark0, Paired<FourLeafAddressProgram, K>>,
    LocalPhaseWorld<S, FourLeafPhaseMark1, Paired<FourLeafAddressProgram, K>>,
    LocalPhaseWorld<S, FourLeafPhaseMark2, Paired<FourLeafAddressProgram, K>>,
    LocalPhaseWorld<S, FourLeafPhaseMark3, Paired<FourLeafAddressProgram, K>>>

/// The twenty actual U rows from one marked preparation. The complete path
/// was derived by five generic rounds; its sources cover precisely 5×4.
public enum FourLeafControlOrbit<K: Structure>: Close {
    public typealias Cycle = FourLeafControlCycle<Lit1, Never, Never, Never, Never, K>
    public typealias S0 = Cycle.R0.S0
    public typealias S1 = Cycle.R0.S1
    public typealias S2 = Cycle.R0.S2
    public typealias S3 = Cycle.R0.S3
    public typealias S4 = Cycle.R1.S0
    public typealias S5 = Cycle.R1.S1
    public typealias S6 = Cycle.R1.S2
    public typealias S7 = Cycle.R1.S3
    public typealias S8 = Cycle.R2.S0
    public typealias S9 = Cycle.R2.S1
    public typealias S10 = Cycle.R2.S2
    public typealias S11 = Cycle.R2.S3
    public typealias S12 = Cycle.R3.S0
    public typealias S13 = Cycle.R3.S1
    public typealias S14 = Cycle.R3.S2
    public typealias S15 = Cycle.R3.S3
    public typealias S16 = Cycle.R4.S0
    public typealias S17 = Cycle.R4.S1
    public typealias S18 = Cycle.R4.S2
    public typealias S19 = Cycle.R4.S3
    public enum SourceCoverage: Null {
        public typealias Left = FourLeafStageLabels<
            BoundaryWorking<S0.Left, S5.Left, S10.Left, S15.Left>,
            BoundaryWorking<S4.Left, S1.Left, S2.Left, S3.Left>,
            BoundaryWorking<S8.Left, S9.Left, S6.Left, S7.Left>,
            BoundaryWorking<S12.Left, S13.Left, S14.Left, S11.Left>,
            BoundaryWorking<S16.Left, S17.Left, S18.Left, S19.Left>>
        public typealias Right = FourLeafStageLabels<
            FourLeafStagePreparations<FourLeafCenter, K>,
            FourLeafStagePreparations<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, K>,
            FourLeafStagePreparations<FourLeafStageLabels<Never, Never, Lit1, Never, Never>, K>,
            FourLeafStagePreparations<FourLeafStageLabels<Never, Never, Never, Lit1, Never>, K>,
            FourLeafStagePreparations<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, K>>
    }
    public enum OnePolicy: Null {
        public typealias Left = FourLeafStageLabels<
            BoundaryWorking<S0.Predicate, S1.Predicate, S2.Predicate, S3.Predicate>,
            BoundaryWorking<S4.Predicate, S5.Predicate, S6.Predicate, S7.Predicate>,
            BoundaryWorking<S8.Predicate, S9.Predicate, S10.Predicate, S11.Predicate>,
            BoundaryWorking<S12.Predicate, S13.Predicate, S14.Predicate, S15.Predicate>,
            BoundaryWorking<S16.Predicate, S17.Predicate, S18.Predicate, S19.Predicate>>
        public typealias Row = BoundaryWorking<S0.Predicate, S0.Predicate, S0.Predicate, S0.Predicate>
        public typealias Right = FourLeafStageLabels<Row, Row, Row, Row, Row>
    }
}

/// The extension uses the same four actual primitive applications at center
/// as the already acquired-law experiment. Only their root wrapper differs.
public enum FourLeafControlAgreesAtCenter<K: Structure>: Null {
    public typealias U = FourLeafControl<Lit1, Never, Never, Never, Never, K>
    public typealias Left = BoundaryWorking<U.At0.Primitive, U.At1.Primitive,
        U.At2.Primitive, U.At3.Primitive>
    public typealias Right = BoundaryWorking<FourLeafSelected0<K>.Primitive,
        FourLeafSelected1<K>.Primitive, FourLeafSelected2<K>.Primitive, FourLeafSelected3<K>.Primitive>
}
