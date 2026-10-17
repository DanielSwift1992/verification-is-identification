// A result is a gated form, and a claim names it through an intermediate
// generic alias or a member alias. The setting carries the answer-factor
// bound and lacks the full matrix bound the gate asks for. The direct claim,
// both intermediate claims and an application through the alias are refused
// for one reason.

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

public enum AnswerOnlyClass: StationaryUnitary, AnswerFactorBound {}
public enum TaskAnswerOnly: Task {
    public typealias In = AnswerOnlyClass
    public typealias Asks = SummaryProjection
}

public typealias UseRLVia<T: Task> = UseRL<T>

public protocol Holder {}
public enum Claims: Holder {
    public typealias OnAnswerOnly = UseRL<TaskAnswerOnly>
}

public typealias Use_1_RL_on_answer_only = UseRL<TaskAnswerOnly>
public typealias Use_7_RL_via_alias = UseRLVia<TaskAnswerOnly>
public typealias Use_9_RL_via_member = Claims.OnAnswerOnly

func need<T: GroundedByRL>(_: T.Type) {}
func demandDirect() { need(Use_1_RL_on_answer_only.self) }
func demandThroughAlias() { need(Use_7_RL_via_alias.self) }
func demandThroughMember() { need(Use_9_RL_via_member.self) }
func applyThroughAlias() { need(UseRLVia<TaskAnswerOnly>.self) }
