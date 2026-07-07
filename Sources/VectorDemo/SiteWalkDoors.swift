import VerificationIsIdentification
import DocumentKit
import Organization

// The site walk's drawn doors: the same two-card strip the role walk wears, with wrapped
// faces — a roll call of six pages measures wider than a card, and the wrap earns it the
// lines it needs, by the font's own metrics. Hand-enumerated like the pages themselves
// (§S8): nine strips, one per halving.

enum WalkDoorWrapBase: Close {}
extension WalkDoorWrapBase {
    public static var typeName: String { "28" }
}
enum WalkDoorWrapPitch: Close {}
extension WalkDoorWrapPitch {
    public static var typeName: String { "18" }
}
enum WalkDoorWrappedLabel<Face: Structure>: SpanLabelMidWrapped {
    public typealias Y = WalkDoorWrapBase
    public typealias LinePitch = WalkDoorWrapPitch
    public typealias FillColor = TextPrimary
    public typealias Size = TextS
    public typealias Weight = WeightBold
    public typealias Content = Face
}
typealias WrappedDoorArt<
    Face: Structure,
    To: Structure
> = SpanLink<SitePath<To>, Layered<WalkDoorFace, SpanHosted<WrappedDoorInterior<Face>>>>
enum WrappedDoorInterior<Face: Structure>: HFlow {
    public typealias Given = CardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<HairBreath>.self
        Flexible<WalkDoorWrappedLabel<Face>>.self
        Air<HairBreath>.self
    }
}
enum SiteDoorsRow<
    FaceA: Structure,
    ToA: Structure,
    FaceB: Structure,
    ToB: Structure
>: HFlow {
    public typealias Given = RtoSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<CardWide, WrappedDoorArt<FaceA, ToA>>.self
        Air<Breath>.self
        Fixed<CardWide, WrappedDoorArt<FaceB, ToB>>.self
        RestAir.self
    }
}
enum SiteDoorsAlt<A: Structure, B: Structure>: Close {}
extension SiteDoorsAlt {
    public static var typeName: String {
        "Two doors: \(RollCall<A>.typeName); or \(RollCall<B>.typeName)."
    }
}
enum SiteDoorsStrip<
    FaceA: Structure,
    ToA: Structure,
    FaceB: Structure,
    ToB: Structure
>: GrownDiagram {
    public typealias Across = RtoSurface
    public typealias AriaLabel = SiteDoorsAlt<FaceA, FaceB>
    public typealias Defs = WalkDoorsDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<VerdictCardTall, SpanHosted<SiteDoorsRow<RollCall<FaceA>, ToA, RollCall<FaceB>, ToB>>>.self
        Air<EdgeMargin>.self
    }
}

func runSiteDoors() {
    write(SiteDoorsStrip<PeopleOrWork, PeopleOrWork, PolicyOrNumbers, PolicyOrNumbers>.typeName, "site-doors-sitewalk")
    write(SiteDoorsStrip<PeopleHalf, PeopleHalf, WorkHalf, WorkHalf>.typeName, "site-doors-peopleorwork")
    write(SiteDoorsStrip<PolicyHalf, PolicyHalf, NumbersHalf, NumbersHalf>.typeName, "site-doors-policyornumbers")
    write(SiteDoorsStrip<Nav.Employees, Nav.Employees, DepartmentsOrDirectories, DepartmentsOrDirectories>.typeName, "site-doors-peoplehalf")
    write(SiteDoorsStrip<BoardOrTasks, BoardOrTasks, Nav.Documents, Nav.Documents>.typeName, "site-doors-workhalf")
    write(SiteDoorsStrip<Nav.Cycles, Nav.Cycles, Nav.ReturnToOffice, Nav.ReturnToOffice>.typeName, "site-doors-policyhalf")
    write(SiteDoorsStrip<Nav.Reports, Nav.Reports, Nav.CompanyDashboard, Nav.CompanyDashboard>.typeName, "site-doors-numbershalf")
    write(SiteDoorsStrip<Nav.Departments, Nav.Departments, Nav.Directories, Nav.Directories>.typeName, "site-doors-departmentsordirectories")
    write(SiteDoorsStrip<Nav.Board, Nav.Board, Nav.Tasks, Nav.Tasks>.typeName, "site-doors-boardortasks")
    print("generated 9 site-walk door strips (Vector composition, wrapped by the font's own measure)")
}
