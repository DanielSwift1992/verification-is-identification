public protocol Setting { associatedtype Home }
public enum Red {}
public enum Blue {}
public enum Good: Setting { public typealias Home = Red }
public protocol Plain {}
public protocol Fenced: Setting where Home == Red {}
