import Base
public enum Use<T: Base.Setting>: Base.Setting { public typealias Home = T.Home }
extension Use: Base.Plain,
 Base.Fenced where T.Home == Base.Red {}
public typealias Probe = Use<Base.Good>
