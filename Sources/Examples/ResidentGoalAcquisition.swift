import VerificationIsIdentification

// The input is only the old First reading (relative, first). Neither
// constructor receives the old Last field or asks for its reconstruction.
// Reply0/1 name the two branches of the actual next contact, not a supplied
// answer about the past. The source step has already advanced its occurrence.
public enum ResidentFirstAfter0<R: QuantumBit, F: QuantumBit>: Close {
    public typealias Before = Paired<R, F>
    public typealias Reply = QBit0
    public typealias After = ResidentHistoryLast0<R.Flipped, F>
}

public enum ResidentFirstAfter1<R: QuantumBit, F: QuantumBit>: Close {
    public typealias Before = Paired<R, F>
    public typealias Reply = QBit1
    public typealias After = ResidentHistoryLast1<R, F>
}

public enum ResidentGoalAcquisitionRoot: Close {
    public typealias Source = ResidentGoalMemoryRoot
    public typealias Contact = Source.Source.Contact
    public typealias RetainedMemory = Contact.Right
    public typealias NextContact = Paired<Contact.Left, RetainedMemory>
}
