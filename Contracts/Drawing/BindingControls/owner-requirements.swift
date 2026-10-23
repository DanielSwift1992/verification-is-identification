import Notation
import DocumentKit

public protocol FirstRequirements: DrawingStyle {
    associatedtype ReservedExtent: Structure
}

public protocol RenamedRequirements: DrawingStyle {
    associatedtype RenamedExtent: Structure
}
