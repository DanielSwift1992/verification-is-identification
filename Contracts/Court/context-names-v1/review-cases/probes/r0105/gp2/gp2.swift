public protocol Line {}
public protocol Pen { associatedtype AtY }
public enum UntilY<Prev, Line> {}
extension UntilY: Pen {
    public typealias AtY = Self.Line
}
