public enum Leaf {}
public struct Box<T> { public typealias Inner = Leaf }
extension Box where T == Inner { public typealias Z = T }
let x: Box<Leaf>.Z.Type = Leaf.self
