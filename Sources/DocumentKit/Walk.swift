import Notation

/// Reads the supplied structure leaf labels in body order.
public enum RollCall<Of: Structure>: Close {}
extension RollCall {
    public static var typeName: String { Of.labels.joined(separator: ", ") }
}

/// Names the left direction of a composed path.
public enum WentLeft: Close {}
extension WentLeft {
    public static var typeName: String { "left" }
}
public enum WentRight: Close {}
extension WentRight {
    public static var typeName: String { "right" }
}

/// Writes the caption for a consumer-supplied path reading.
public enum WordSoFar: Close {}
extension WordSoFar {
    public static var typeName: String { "The word so far: " }
}
public enum StepDot: Close {}
extension StepDot {
    public static var typeName: String { " · " }
}

