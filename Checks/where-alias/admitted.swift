// The control for refused.swift. The claims go through the same
// intermediate alias and member alias, and the setting carries every premise
// the gate asks for. Each claim and the application are judged at the gate
// and admitted.

public protocol Reading {}
public enum SummaryProjection: Reading {}

public protocol Setting {}
public protocol StationaryUnitary: Setting {}
public protocol AnswerFactorBound: Setting {}
public protocol FullMatrixBound: Setting {}

public protocol Task {
    associatedtype In: Setting
    associatedtype Asks: Reading
}

public protocol GroundedByRL {}
public enum UseRL<T: Task> {}
extension UseRL: GroundedByRL
where T.In: StationaryUnitary, T.In: FullMatrixBound, T.Asks == SummaryProjection {}

public enum FullClass: StationaryUnitary, FullMatrixBound {}
public enum TaskFull: Task {
    public typealias In = FullClass
    public typealias Asks = SummaryProjection
}

public typealias UseRLVia<T: Task> = UseRL<T>

public protocol Holder {}
public enum Claims: Holder {
    public typealias OnFull = UseRL<TaskFull>
}

public typealias Use_8_RL_via_alias_on_full = UseRLVia<TaskFull>
public typealias Use_10_RL_via_member_on_full = Claims.OnFull

func need<T: GroundedByRL>(_: T.Type) {}
func demandThroughAlias() { need(Use_8_RL_via_alias_on_full.self) }
func demandThroughMember() { need(Use_10_RL_via_member_on_full.self) }
func applyThroughAlias() { need(UseRLVia<TaskFull>.self) }
