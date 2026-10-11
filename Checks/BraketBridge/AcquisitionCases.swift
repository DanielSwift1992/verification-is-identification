import VerificationIsIdentification

typealias Live = RetainedQuantumZ1<QuantumH<QuantumZ0<QuantumStart<Source2>>>>
typealias LiveMemory = One<Parity<Source2>>
typealias LiveYAcquisition = ContactAugmented<Live,LiveMemory,ReadY<Live.Frame>>
typealias LiveXAcquisition = ContactAugmented<Live,LiveMemory,ReadX<Live.Frame>>
typealias LiveZAcquisition = ContactAugmented<Live,LiveMemory,ReadZ<Live.Frame>>
typealias LiveStateAcquisition = ContactAugmented<Live,LiveMemory,ReadState<Live.Frame>>
typealias LiveYBefore = LiveYAcquisition.Base
typealias LiveXBefore = LiveXAcquisition.Base
typealias LiveZBefore = LiveZAcquisition.Base
typealias LiveStateBefore = LiveStateAcquisition.Base
typealias LiveYAfter = LiveYAcquisition.Continuation
typealias LiveXAfter = LiveXAcquisition.Continuation
typealias LiveZAfter = LiveZAcquisition.Continuation
typealias LiveStateAfter = LiveStateAcquisition.Continuation

typealias NoPortX = QuantumContinuation<ParityBase,ParityMemory,ReadX<ParityBase.Frame>>
typealias Withdrawn = DestroyResidents<Live>
typealias WithdrawnX = QuantumContinuation<Withdrawn,LiveMemory,ReadX<Withdrawn.Frame>>

// Holdout added after the baseline acquisition builder was frozen. The S
// suffix changes the output question while preserving the actual resident.
typealias Rotated = QuantumS<Live>
typealias RotatedXAcquisition = ContactAugmented<Rotated,LiveMemory,ReadX<Rotated.Frame>>
typealias RotatedYAcquisition = ContactAugmented<Rotated,LiveMemory,ReadY<Rotated.Frame>>
typealias RotatedZAcquisition = ContactAugmented<Rotated,LiveMemory,ReadZ<Rotated.Frame>>
typealias RotatedXBefore = RotatedXAcquisition.Base
typealias RotatedYBefore = RotatedYAcquisition.Base
typealias RotatedZBefore = RotatedZAcquisition.Base
typealias RotatedXAfter = RotatedXAcquisition.Continuation
typealias RotatedYAfter = RotatedYAcquisition.Continuation
typealias RotatedZAfter = RotatedZAcquisition.Continuation

func acquisitionModels() throws -> [Model] {
    try [model(LiveYBefore.self,name:"LiveYBefore"),model(LiveXBefore.self,name:"LiveXBefore"),
    model(LiveZBefore.self,name:"LiveZBefore"),model(LiveStateBefore.self,name:"LiveStateBefore"),
    model(LiveYAfter.self,name:"LiveYAfter"),model(LiveXAfter.self,name:"LiveXAfter"),
    model(LiveZAfter.self,name:"LiveZAfter"),model(LiveStateAfter.self,name:"LiveStateAfter"),
    model(NoPortX.self,name:"NoPortX"),model(WithdrawnX.self,name:"WithdrawnX"),
    model(RotatedXBefore.self,name:"RotatedXBefore"),model(RotatedYBefore.self,name:"RotatedYBefore"),
    model(RotatedZBefore.self,name:"RotatedZBefore"),model(RotatedXAfter.self,name:"RotatedXAfter"),
    model(RotatedYAfter.self,name:"RotatedYAfter"),model(RotatedZAfter.self,name:"RotatedZAfter")]
}
func acquisitionRequests() throws -> [AcquisitionRequest] {
    try [contactRequest(LiveYAcquisition.self,name:"AcquireY",beforeName:"LiveYBefore",afterName:"LiveYAfter"),
    contactRequest(LiveXAcquisition.self,name:"AcquireX",beforeName:"LiveXBefore",afterName:"LiveXAfter"),
    contactRequest(LiveZAcquisition.self,name:"AcquireZ",beforeName:"LiveZBefore",afterName:"LiveZAfter"),
    contactRequest(LiveStateAcquisition.self,name:"AcquireState",beforeName:"LiveStateBefore",afterName:"LiveStateAfter"),
    AcquisitionRequest(name:"NoPortX",before:model(NoPortX.self,name:"NoPortX"),contacts:[]),
    AcquisitionRequest(name:"WithdrawnX",before:model(WithdrawnX.self,name:"WithdrawnX"),contacts:[]),
    contactRequest(RotatedXAcquisition.self,name:"RotatedX",beforeName:"RotatedXBefore",afterName:"RotatedXAfter"),
    contactRequest(RotatedYAcquisition.self,name:"RotatedY",beforeName:"RotatedYBefore",afterName:"RotatedYAfter"),
    contactRequest(RotatedZAcquisition.self,name:"RotatedZ",beforeName:"RotatedZBefore",afterName:"RotatedZAfter")]
}
