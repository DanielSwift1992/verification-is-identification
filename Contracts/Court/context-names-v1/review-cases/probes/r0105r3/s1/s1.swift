public enum Leaf {}
public enum Other {}
public struct Box<T> where T == Inner { public typealias Inner = Leaf }
