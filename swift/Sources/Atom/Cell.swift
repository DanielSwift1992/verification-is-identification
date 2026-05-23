// §4.1 Atom — PAIR(PAIR(row, col), value)

import Engine

public struct Pixel: Equatable, Sendable, CustomStringConvertible {
    public let row, col, val: Int
    public init(_ row: Int, _ col: Int, _ val: Int) {
        self.row = row; self.col = col; self.val = val
    }
    public var description: String { "(\(row), \(col), \(val))" }
}

public protocol CellType: State {
    associatedtype Row: Nat
    associatedtype Col: Nat
    associatedtype Val: Nat
    static var materialized: Pixel { get }
}

public extension CellType {
    static var materialized: Pixel {
        Pixel(Row.value, Col.value, Val.value)
    }
}

public enum Cell<R: Nat, C: Nat, V: Nat>: CellType {
    public typealias Row = R
    public typealias Col = C
    public typealias Val = V
}
