// The control for refused.swift. A setting declares one premise of the gate
// and an unconditional extension adds the other, and a refinement holds
// through an extension whose own body states the bound. The compiler accepts
// all of it, and the court admits the claim, the application and the
// refinement.

public protocol Reading {}
public enum SummaryProjection: Reading {}

public protocol Setting {}
public protocol StationaryUnitary: Setting {}
public protocol FullMatrixBound: Setting {}

public protocol Task {
    associatedtype In: Setting
    associatedtype Asks: Reading
}

public protocol GroundedByRL {}
public enum UseRL<T: Task> {}
extension UseRL: GroundedByRL
where T.In: StationaryUnitary, T.In: FullMatrixBound, T.Asks == SummaryProjection {}

public enum FullClass: StationaryUnitary {}
extension FullClass: FullMatrixBound {}
public enum TaskFull: Task {
    public typealias In = FullClass
    public typealias Asks = SummaryProjection
}

public typealias Use_11_RL_on_full = UseRL<TaskFull>

func need<T: GroundedByRL>(_: T.Type) {}
func demand() { need(Use_11_RL_on_full.self) }
func apply() { need(UseRL<TaskFull>.self) }

public protocol Bound {}
public enum Tight: Bound {}

public protocol Banded {
    associatedtype Band: Bound
}
public protocol StrictlyBanded: Banded
where Band == Tight {}

public protocol Holder {}
public enum Settled: Holder {}
extension Settled: StrictlyBanded {
    public typealias Band = Tight
}
