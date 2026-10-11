import VerificationIsIdentification

// Branch actions use the same acquired bit as the instrument record.
// These are control relations; projector probabilities and disturbance are
// supplied by the separately checked finite Pauli-instrument interpretation.
public enum ResidentAcquisitionRow<P: QuantumBit, C: QuantumBit>: Close {
    public typealias Input = Paired<P, C>
    public typealias Toggle0 = Paired<P, C>
    public typealias Toggle1 = Paired<P.Flipped, C>
    public typealias Write0 = Paired<QBit0, C>
    public typealias Write1 = Paired<QBit1, C>
    public typealias Install0 = Paired<QBit0, QBit0>
    public typealias Install1 = Paired<QBit1, QBit0>
    public typealias Restart = Paired<P, QBit0>
}

public enum ResidentAcquisitionRoot: Close {
    public typealias Interpreter = ResidentInterpreterRoot
    // QX/QZ here identify the measured Pauli observable, not a gate call.
    // The two record labels denote eigenvalues +1 and -1 respectively.
    public typealias ProbeX = Paired<QX, Paired<QBit0, QBit1>>
    public typealias ProbeZ = Paired<QZ, Paired<QBit0, QBit1>>
    public typealias Row00 = ResidentAcquisitionRow<QBit0, QBit0>
    public typealias Row01 = ResidentAcquisitionRow<QBit0, QBit1>
    public typealias Row10 = ResidentAcquisitionRow<QBit1, QBit0>
    public typealias Row11 = ResidentAcquisitionRow<QBit1, QBit1>
}
