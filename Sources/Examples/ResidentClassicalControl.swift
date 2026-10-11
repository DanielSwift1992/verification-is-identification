import VerificationIsIdentification

// Concrete port names. The SDK interpretation maps this ordered pair to D,E;
// the names alone do not prove non-disturbance or a physical measurement law.
public enum ResidentDataPort: Close {}
public enum ResidentServicePort: Close {}

public enum ResidentClassicalRoot: Close {
    public typealias QuantumPorts = Paired<ResidentDataPort, ResidentServicePort>
    public typealias Payload = QuantumPorts.Left
    public typealias AcquiredAt = QuantumPorts.Right
    public typealias ProbeX = Paired<AcquiredAt, ResidentAcquisitionRoot.ProbeX>
    public typealias ProbeZ = Paired<AcquiredAt, ResidentAcquisitionRoot.ProbeZ>
    public typealias Control = ResidentAcquisitionRoot
    public typealias Known0 = Control.Row00.Install0.Left
    public typealias Known1 = Control.Row00.Install1.Left
    // The p=0 representatives read the already established relative action.
    // Agreement with p=1 representatives is checked by applications below.
    public typealias At0 = ResidentInterpreterRoot.Row00
    public typealias At1 = ResidentInterpreterRoot.Row01
    public typealias MemoryAction = ResidentInterpreterRoot.ServiceAction
    public typealias Reopen = ResidentInterpreterRoot.ReopenService
}
