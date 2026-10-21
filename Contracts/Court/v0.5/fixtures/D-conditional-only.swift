public protocol Root {}
public enum Unit: Root {}
public enum Other: Root {}
public protocol Pair: Root { associatedtype Left; associatedtype Right }
public protocol Same: Pair where Left == Right {}
public enum Page: Root {
 public static var body: Root { Unit.self }
}
#if FLAG
public enum Hidden: Same { public typealias Left = Unit; public typealias Right = Other }
#endif
