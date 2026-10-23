import Notation
import DocumentKit

/// Declares the owner requirements independently of their supplied readings.
public protocol DocumentationStyle: DrawingStyle {
    associatedtype HairBreath: Structure
    associatedtype S24Breath: Structure
    associatedtype R4: Structure
    associatedtype R6: Structure
    associatedtype R10: Structure
    associatedtype R16: Structure
    associatedtype R20: Structure
    associatedtype TextXXS: Structure
    associatedtype TextS: Structure
    associatedtype TextL: Structure
    associatedtype TitleT: Structure
    associatedtype WeightRegular: Structure
    associatedtype TextXS: Structure
    associatedtype TextM: Structure
    associatedtype DisplayS: Structure
    associatedtype Display: Structure
    associatedtype WeightBold: Structure
    associatedtype SourceLinkWidth: Structure
}
