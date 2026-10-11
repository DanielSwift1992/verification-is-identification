import VerificationIsIdentification

enum QuantumUnitWeight: Close {}
typealias W1 = QuantumUnitWeight
typealias W2 = Paired<W1,W1>
typealias W3 = Paired<W2,W1>
typealias W9 = Paired<Paired<W3,W3>,W3>
enum MainOccurrence: Close {}
enum OtherOccurrence: Close {}
typealias Uniform2 = QuantumWeights16<W1,Never,Never,Never,W1,Never,Never,Never,W1,Never,Never,Never,W1,Never,Never,Never>
typealias Uniform3 = QuantumWeights16<W1,Never,W1,Never,W1,Never,W1,Never,W1,Never,W1,Never,W1,Never,W1,Never>
typealias Uniform4 = QuantumWeights16<W1,W1,W1,W1,W1,W1,W1,W1,W1,W1,W1,W1,W1,W1,W1,W1>
typealias NoiseShared = QuantumWeights16<W3,Never,Never,W1,W3,Never,Never,W1,W3,Never,Never,W1,W3,Never,Never,W1>
typealias NoiseIndependent = QuantumWeights16<W9,W3,W3,W1,W9,W3,W3,W1,W9,W3,W3,W1,W9,W3,W3,W1>
typealias NoiseExclusive = QuantumWeights16<W2,W1,W1,Never,W2,W1,W1,Never,W2,W1,W1,Never,W2,W1,W1,Never>
typealias Source2 = QuantumSource<MainOccurrence,Uniform2>
typealias Source3 = QuantumSource<MainOccurrence,Uniform3>
typealias Source4 = QuantumSource<MainOccurrence,Uniform4>
typealias Empty<S: QuantumSourceModel> = QuantumNoRecords<S>
typealias R0<S: QuantumSourceModel> = RecordToggle0<RecordZero<S>>
typealias R1<S: QuantumSourceModel> = RecordToggle1<RecordZero<S>>
typealias R2<S: QuantumSourceModel> = RecordToggle2<RecordZero<S>>
typealias R3<S: QuantumSourceModel> = RecordToggle3<RecordZero<S>>
typealias Parity<S: QuantumSourceModel> = RecordToggle1<R0<S>>
typealias One<R: QuantumRecord> = QuantumRecordsCons<R,Empty<R.Source>>
typealias Two<R: QuantumRecord,T: QuantumRecord> = QuantumRecordsCons<R,One<T>> where R.Source == T.Source
typealias Three<R: QuantumRecord,T: QuantumRecord,U: QuantumRecord> = QuantumRecordsCons<R,Two<T,U>> where R.Source == T.Source,R.Source == U.Source
typealias ZHZ<S: QuantumSourceModel> = QuantumZ1<QuantumH<QuantumZ0<QuantumStart<S>>>>
typealias ZZ<S: QuantumSourceModel> = QuantumZ1<QuantumZ0<QuantumStart<S>>>
typealias Echo<S: QuantumSourceModel> = QuantumZ0<QuantumZ0<QuantumStart<S>>>
typealias Single<S: QuantumSourceModel> = QuantumZ0<QuantumStart<S>>
typealias ParityBase = ZHZ<Source2>
typealias ParityMemory = One<Parity<Source2>>
typealias FullMemory = Two<R0<Source2>,R1<Source2>>
typealias ParityX = QuantumContinuation<ParityBase,ParityMemory,ReadX<ParityBase.Frame>>
typealias ParityY = QuantumContinuation<ParityBase,ParityMemory,ReadY<ParityBase.Frame>>
typealias ParityZ = QuantumContinuation<ParityBase,ParityMemory,ReadZ<ParityBase.Frame>>
typealias ParityState = QuantumContinuation<ParityBase,ParityMemory,ReadState<ParityBase.Frame>>
typealias FullState = QuantumContinuation<ParityBase,FullMemory,ReadState<ParityBase.Frame>>
typealias SharedEcho = QuantumContinuation<Echo<Source2>,Empty<Source2>,ReadState<Echo<Source2>.Frame>>
typealias FreshEcho = QuantumContinuation<ZZ<Source2>,Empty<Source2>,ReadState<ZZ<Source2>.Frame>>
typealias GenuineMemory = QuantumContinuation<Single<Source2>,One<R0<Source2>>,ReadState<Single<Source2>.Frame>>
typealias UnboundMemory = QuantumContinuation<Single<Source2>,One<R1<Source2>>,ReadState<Single<Source2>.Frame>>
typealias AfterH = QuantumContinuation<QuantumH<Single<Source2>>,One<R0<Source2>>,ReadState<QuantumH<Single<Source2>>.Frame>>
typealias Masked = RecordToggle2<R1<Source3>>
typealias JointKey = QuantumContinuation<ZZ<Source3>,Three<R0<Source3>,R2<Source3>,Masked>,ReadState<ZZ<Source3>.Frame>>
typealias DroppedKey = QuantumContinuation<ZZ<Source3>,Two<R0<Source3>,Masked>,ReadState<ZZ<Source3>.Frame>>
typealias SourceNoiseShared = QuantumSource<MainOccurrence,NoiseShared>
typealias BSCShared = QuantumContinuation<ZZ<SourceNoiseShared>,Two<RecordToggle2<R0<SourceNoiseShared>>,RecordToggle3<R1<SourceNoiseShared>>>,ReadState<ZZ<SourceNoiseShared>.Frame>>
typealias SourceNoiseIndependent = QuantumSource<MainOccurrence,NoiseIndependent>
typealias BSCIndependent = QuantumContinuation<ZZ<SourceNoiseIndependent>,Two<RecordToggle2<R0<SourceNoiseIndependent>>,RecordToggle3<R1<SourceNoiseIndependent>>>,ReadState<ZZ<SourceNoiseIndependent>.Frame>>
typealias SourceNoiseExclusive = QuantumSource<MainOccurrence,NoiseExclusive>
typealias BSCExclusive = QuantumContinuation<ZZ<SourceNoiseExclusive>,Two<RecordToggle2<R0<SourceNoiseExclusive>>,RecordToggle3<R1<SourceNoiseExclusive>>>,ReadState<ZZ<SourceNoiseExclusive>.Frame>>

func baseModels() throws -> [Model] { try [
model(ParityX.self,name:"ParityX"),
model(ParityY.self,name:"ParityY"),
model(ParityZ.self,name:"ParityZ"),
model(ParityState.self,name:"ParityState"),
model(FullState.self,name:"FullState"),
model(SharedEcho.self,name:"SharedEcho"),
model(FreshEcho.self,name:"FreshEcho"),
model(GenuineMemory.self,name:"GenuineMemory"),
model(UnboundMemory.self,name:"UnboundMemory"),
model(AfterH.self,name:"AfterH"),
model(JointKey.self,name:"JointKey"),
model(DroppedKey.self,name:"DroppedKey"),
model(BSCShared.self,name:"BSCShared"),
model(BSCIndependent.self,name:"BSCIndependent"),
model(BSCExclusive.self,name:"BSCExclusive")
] }
