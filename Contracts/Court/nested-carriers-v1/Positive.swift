public enum Red {}
public protocol Carrier { associatedtype Axis }
public enum Company: Carrier {
    public enum Slice: Carrier { public typealias Axis = Red }
    public typealias Axis = Red
}
public enum Ledger: Carrier {
    public enum Slice: Carrier { public typealias Axis = Company.Slice.Axis }
    public typealias Axis = Company.Axis
}
public protocol Demand { associatedtype Axis }
public protocol Allowed: Demand where Axis == Red {}
public enum Witness: Allowed { public typealias Axis = Ledger.Slice.Axis }
public typealias Probe = Witness
