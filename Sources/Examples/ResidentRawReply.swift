import VerificationIsIdentification

public enum ResidentHiddenMemoryPort: Close {}

// Only the response alphabet and addressed service carrier are fixed here.
// There is no Pauli question, projector, truthful-eigenvalue claim or fresh
// memory claim. Locality is realized by the separately checked SDK embedding.
public enum ResidentRawReplyRoot: Close {
    public typealias Control = ResidentAcquisitionRoot
    public typealias Interpreter = ResidentClassicalRoot
    public typealias Reply = Paired<QBit0, QBit1>
    public typealias Carrier = Paired<ResidentDataPort,
        Paired<ResidentServicePort, ResidentHiddenMemoryPort>>
    public typealias WorkingData = Carrier.Left
    public typealias Contact = Carrier.Right
    public typealias ContinuedMemory = Contact.Right
    public typealias NextContact = Paired<Contact.Left, ContinuedMemory>
    public typealias Acquired0 = Control.Row00.Install0.Left
    public typealias Acquired1 = Control.Row00.Install1.Left
}
