import VerificationIsIdentification

// This is the acquired comparison, not a claim that the goal will eventually
// be reached. The executor must connect this reading to the actual contact.
public typealias ResidentCompletionFlag<S: ResidentHistoryShape> = S.Different

public enum ResidentCompletionAfter0<R: QuantumBit, F: QuantumBit>: Close {
    public typealias Contact = ResidentFirstAfter0<R, F>
    public typealias Flag = ResidentCompletionFlag<Contact.After>
}

public enum ResidentCompletionAfter1<R: QuantumBit, F: QuantumBit>: Close {
    public typealias Contact = ResidentFirstAfter1<R, F>
    public typealias Flag = ResidentCompletionFlag<Contact.After>
}

public enum ResidentCompletionRoot: Close {
    public typealias Source = ResidentGoalAcquisitionRoot
    public typealias Target = QBit1
    public typealias Contact = Source.Contact
    public typealias RetainedMemory = Source.RetainedMemory
    public typealias Acquired0 = Source.Source.Acquired0
    public typealias Acquired1 = Source.Source.Acquired1
}
