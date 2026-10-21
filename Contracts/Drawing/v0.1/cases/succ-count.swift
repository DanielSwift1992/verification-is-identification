import Notation
import DocumentKit
public enum FixtureTitle: Close {}
extension FixtureTitle {
    public static var typeName: String { "Count" }
}
public enum FixtureArt: GrownDiagram {
    public typealias Across = U64
    public typealias AriaLabel = FixtureTitle
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<Succ<Succ<Never>>>.self
    }
}
