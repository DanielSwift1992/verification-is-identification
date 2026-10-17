// A conformance written in an unconditional extension is the type's
// conformance. Two refinements are stated in extensions for a setting whose
// bound is loose, once with the bound in the declaration and once in the
// extension's own body. A setting gains a second premise from an extension
// and still lacks the one the gate asks for. The compiler refuses all three,
// and the court refuses them for the same reasons.

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

public enum AnswerOnlyClass: StationaryUnitary {}
extension AnswerOnlyClass: AnswerFactorBound {}
public enum TaskAnswerOnly: Task {
    public typealias In = AnswerOnlyClass
    public typealias Asks = SummaryProjection
}

public typealias Use_12_RL_on_answer_only = UseRL<TaskAnswerOnly>

func need<T: GroundedByRL>(_: T.Type) {}
func demand() { need(Use_12_RL_on_answer_only.self) }

public protocol Bound {}
public enum Tight: Bound {}
public enum Loose: Bound {}

public protocol Banded {
    associatedtype Band: Bound
}
public protocol StrictlyBanded: Banded
where Band == Tight {}

public protocol Holder {}
public enum Later: Banded {
    public typealias Band = Loose
}
extension Later: StrictlyBanded {}

public enum Drifted: Holder {}
extension Drifted: StrictlyBanded {
    public typealias Band = Loose
}
