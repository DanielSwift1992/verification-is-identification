import Notation
import DocumentKit
public enum FixtureText: Close {}
extension FixtureText {
    public static var typeName: String { "plain text" }
}
public enum FixtureLabel: SpanLabelWrapped {
    public typealias Y = Tally<U16>
    public typealias LinePitch = Tally<U16>
    public typealias FillColor = FixtureBindingTextPrimary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = FixtureText
}
public enum FixtureRow: HFlow {
    public typealias Given = U512
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<FixtureLabel>.self
    }
}
public enum FixtureArt: GrownDiagram {
    public typealias Binding = FixtureBinding
    public typealias Across = U512
    public typealias AriaLabel = FixtureText
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<U32, SpanHosted<FixtureRow>>.self
    }
}
