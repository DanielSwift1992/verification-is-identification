import Base
public enum Use<T: Base.Setting>: Base.Setting { public typealias Home = Base.Blue }
extension Use: Base.Plain,
 Base.Fenced where T.Home == Base.Red {}
public typealias Probe = Use<Base.Good>
