import Notation
import DocumentKit
public enum FixtureTitle: Close {}
extension FixtureTitle {
    public static var typeName: String { "Remainder" }
}
public enum FixtureRow: HFlow {
    public typealias Given = U1
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<U2>.self
        Flexible<FixtureFill>.self
    }
}
public enum FixtureFill: SpanTrack {
    public typealias H = Tally<U1>
    public typealias Radius = Tally<Never>
    public typealias Fill = FixtureBindingTextPrimary
}
public enum FixtureArt: GrownDiagram {
    public typealias Binding = FixtureBinding
    public typealias Across = U2
    public typealias AriaLabel = FixtureTitle
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<U1, SpanHosted<FixtureRow>>.self
    }
}
