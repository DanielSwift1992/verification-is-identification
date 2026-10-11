import VerificationIsIdentification

// The shared CoherentBlock constructors retain the exact scalar. A measured
// classical branch may later read only Word for a density-operator question.
public enum ResidentWireReply0<F: CoherentBlock>: Close {
    public typealias Before = F
    public typealias NegateMeasurementAngle = F.Word.Left
    public typealias After = F.ConjugatedH
}

public enum ResidentWireReply1<F: CoherentBlock>: Close {
    public typealias Before = F
    public typealias NegateMeasurementAngle = F.Word.Left
    public typealias After = F.ConjugatedH.LeftX
}

public enum ResidentWireCarrier0: Close {
    public typealias Index = QBit0
    public typealias After = ResidentWireCarrier1
}

public enum ResidentWireCarrier1: Close {
    public typealias Index = QBit1
    public typealias After = ResidentWireCarrier0
}

public enum ResidentMeasurementWireRoot: Close {
    public typealias Input = ResidentWireCarrier0
    public typealias InitialFrame = CoherentI<CoherentPhase0>
    public typealias Reply = Paired<QBit0, QBit1>
    public typealias CorrectionsInTimeOrder = Paired<QX, QZ>
}
