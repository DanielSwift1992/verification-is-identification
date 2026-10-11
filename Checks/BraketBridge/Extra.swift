import VerificationIsIdentification

// Added after the 15-case base builder was implemented and exported.
// Execution order: Z0 H S Z1 H S Z2. No planner/adapter scenario branch.
typealias NewWord = QuantumZ2<QuantumS<QuantumH<QuantumZ1<QuantumS<QuantumH<QuantumZ0<QuantumStart<Source3>>>>>>>>
typealias NewYMemory = One<RecordToggle2<R0<Source3>>>
typealias NewStateMemory = Two<RecordToggle2<R0<Source3>>,RecordToggle2<R1<Source3>>>
typealias NewWordY = QuantumContinuation<NewWord,NewYMemory,ReadY<NewWord.Frame>>
typealias NewWordX = QuantumContinuation<NewWord,NewYMemory,ReadX<NewWord.Frame>>
typealias NewWordState = QuantumContinuation<NewWord,NewStateMemory,ReadState<NewWord.Frame>>
// Second holdout keeps both recorded contacts inside a nontrivial ideal X
// computation. A common bit cancels projectively; a fresh second bit does not.
typealias ThroughX = QuantumH<QuantumS<QuantumS<QuantumH<QuantumZ0<QuantumStart<Source2>>>>>>
typealias SecondShared = QuantumContinuation<QuantumZ0<ThroughX>,Empty<Source2>,ReadState<QuantumZ0<ThroughX>.Frame>>
typealias SecondFresh = QuantumContinuation<QuantumZ1<ThroughX>,Empty<Source2>,ReadState<QuantumZ1<ThroughX>.Frame>>
func extraModels() throws -> [Model] {
    try [model(NewWordY.self,name:"NewWordY"),model(NewWordX.self,name:"NewWordX"),model(NewWordState.self,name:"NewWordState"),model(SecondShared.self,name:"SecondShared"),model(SecondFresh.self,name:"SecondFresh")]
}
