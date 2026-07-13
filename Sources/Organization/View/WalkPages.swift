import VerificationIsIdentification
import DocumentKit

// The walk pages: one page per halving (Wayfinding.swift), each two doors and a step back
// up. A door's face is `RollCall` of the very half it opens and its address is the half
// type itself, so a door cannot mislabel its half and cannot point at a page that does not
// exist. The titles and the one hint line are the authored voice; everything else is read.

public enum WalkHint: Close {}
extension WalkHint {
    public static var typeName: String {
        "Two doors, and each door names every page behind it. Pick a half and keep choosing: any page stands at most four choices away, and a wrong turn steps back up."
    }
}
/// The role-walk cell's shared voice: what the walker just formed, said once.
public enum RoleCellIntro: Close {}
extension RoleCellIntro {
    public static var typeName: String {
        "Four doors formed this pair: a department and a rank, shaped as a person (SomeoneAs). The count and the verdicts below are read through it, and cover everyone standing here."
    }
}
public enum StandingHereWord: Close {}
extension StandingHereWord {
    public static var typeName: String { "Standing here: " }
}
public enum ViewColonWord: Close {}
extension ViewColonWord {
    public static var typeName: String { ", view: " }
}
public enum UpWord: Close {}
extension UpWord {
    public static var typeName: String { "Back up a step" }
}

/// The drawn doors above the text ones: inert as a bare image, live once the host inlines
/// the canvas, the same door the tour stations opened first.
enum WalkDoorsPictureAlt: Close {}
extension WalkDoorsPictureAlt {
    static var typeName: String { "The two doors, drawn: each card is the half it opens." }
}
/// The Topics tail every walk step carries: DocC nests each step's two doors under it, so
/// the navigator shows the walk as the tree it is instead of pouring every step into the
/// root. The visible doors above stay the page's own; this tail is the curation.
public enum WalkTopicsHeading: Close {}
extension WalkTopicsHeading {
    public static var typeName: String { "Topics" }
}
public enum WalkDoorsGroupHeading: Close {}
extension WalkDoorsGroupHeading {
    public static var typeName: String { "The doors" }
}
public enum TopicsHeadingBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        DoubleHash.self; WalkTopicsHeading.self; Break.self
        TripleHash.self; WalkDoorsGroupHeading.self; Break.self
    }
}
public typealias TopicDoor<X> = ListItem<TopicReference<X>>
public typealias TopicSymbol<X> = ListItem<Symbol<RawName<X>>>

enum SiteWalkTitle: Close {}
extension SiteWalkTitle {
    public static var typeName: String { "Any page in four choices" }
}
enum PeopleOrWorkTitle: Close {}
extension PeopleOrWorkTitle {
    public static var typeName: String { "The people, or the work?" }
}
enum PolicyOrNumbersTitle: Close {}
extension PolicyOrNumbersTitle {
    public static var typeName: String { "A policy, or the numbers?" }
}
enum PeopleHalfTitle: Close {}
extension PeopleHalfTitle {
    public static var typeName: String { "The people themselves?" }
}
enum WorkHalfTitle: Close {}
extension WorkHalfTitle {
    public static var typeName: String { "The work in motion?" }
}
enum PolicyHalfTitle: Close {}
extension PolicyHalfTitle {
    public static var typeName: String { "Which policy?" }
}
enum NumbersHalfTitle: Close {}
extension NumbersHalfTitle {
    public static var typeName: String { "Which numbers?" }
}
enum DepartmentsOrDirectoriesTitle: Close {}
extension DepartmentsOrDirectoriesTitle {
    public static var typeName: String { "Departments, or directories?" }
}
enum BoardOrTasksTitle: Close {}
extension BoardOrTasksTitle {
    public static var typeName: String { "The board, or the tasks hub?" }
}

enum SiteWalkDoorsAsset: Close {}
extension SiteWalkDoorsAsset {
    static var typeName: String { "site-doors-sitewalk" }
}
public enum SiteWalkPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { SiteWalkTitle.self }
        WalkHint.self; Break.self
        Picture { WalkDoorsPictureAlt.self; SiteWalkDoorsAsset.self }
        Break.self
        ListItem { Link { RollCall<PeopleOrWork>.self; PeopleOrWork.self } }
        ListItem { Link { RollCall<PolicyOrNumbers>.self; PolicyOrNumbers.self } }
        Break.self
        TopicsHeadingBlock.self
        TopicDoor<PeopleOrWork>.self
        TopicDoor<PolicyOrNumbers>.self

    }
}
enum PeopleOrWorkDoorsAsset: Close {}
extension PeopleOrWorkDoorsAsset {
    static var typeName: String { "site-doors-peopleorwork" }
}
public enum PeopleOrWorkPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { PeopleOrWorkTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self
        Break.self
        Picture { WalkDoorsPictureAlt.self; PeopleOrWorkDoorsAsset.self }
        Break.self
        ListItem { Link { RollCall<PeopleHalf>.self; PeopleHalf.self } }
        ListItem { Link { RollCall<WorkHalf>.self; WorkHalf.self } }
        ListItem { Link { UpWord.self; SiteWalk.self } }
        Break.self
        TopicsHeadingBlock.self
        TopicDoor<PeopleHalf>.self
        TopicDoor<WorkHalf>.self

    }
}
enum PolicyOrNumbersDoorsAsset: Close {}
extension PolicyOrNumbersDoorsAsset {
    static var typeName: String { "site-doors-policyornumbers" }
}
public enum PolicyOrNumbersPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { PolicyOrNumbersTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentRight.self
        Break.self
        Picture { WalkDoorsPictureAlt.self; PolicyOrNumbersDoorsAsset.self }
        Break.self
        ListItem { Link { RollCall<PolicyHalf>.self; PolicyHalf.self } }
        ListItem { Link { RollCall<NumbersHalf>.self; NumbersHalf.self } }
        ListItem { Link { UpWord.self; SiteWalk.self } }
        Break.self
        TopicsHeadingBlock.self
        TopicDoor<PolicyHalf>.self
        TopicDoor<NumbersHalf>.self

    }
}
enum FindPersonLabel: Close {}
extension FindPersonLabel {
    public static var typeName: String { "Find one person, eight choices at most" }
}
enum PeopleHalfDoorsAsset: Close {}
extension PeopleHalfDoorsAsset {
    static var typeName: String { "site-doors-peoplehalf" }
}
public enum PeopleHalfPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { PeopleHalfTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self; StepDot.self; WentLeft.self
        Break.self
        Picture { WalkDoorsPictureAlt.self; PeopleHalfDoorsAsset.self }
        Break.self
        ListItem { Link { RollCall<Nav.Employees>.self; Nav.Employees.self } }
        ListItem { Link { RollCall<DepartmentsOrDirectories>.self; DepartmentsOrDirectories.self } }
        ListItem { Link { FindPersonLabel.self; RosterWalkRoot.self } }
        ListItem { Link { UpWord.self; PeopleOrWork.self } }
        Break.self
        TopicsHeadingBlock.self
        TopicDoor<Nav.Employees>.self
        TopicDoor<DepartmentsOrDirectories>.self
        TopicDoor<RosterWalkRoot>.self

    }
}
enum WorkHalfDoorsAsset: Close {}
extension WorkHalfDoorsAsset {
    static var typeName: String { "site-doors-workhalf" }
}
public enum WorkHalfPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { WorkHalfTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self; StepDot.self; WentRight.self
        Break.self
        Picture { WalkDoorsPictureAlt.self; WorkHalfDoorsAsset.self }
        Break.self
        ListItem { Link { RollCall<BoardOrTasks>.self; BoardOrTasks.self } }
        ListItem { Link { RollCall<Nav.Documents>.self; Nav.Documents.self } }
        ListItem { Link { UpWord.self; PeopleOrWork.self } }
        Break.self
        TopicsHeadingBlock.self
        TopicDoor<BoardOrTasks>.self
        TopicDoor<Nav.Documents>.self

    }
}
enum PolicyHalfDoorsAsset: Close {}
extension PolicyHalfDoorsAsset {
    static var typeName: String { "site-doors-policyhalf" }
}
public enum PolicyHalfPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { PolicyHalfTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentRight.self; StepDot.self; WentLeft.self
        Break.self
        Picture { WalkDoorsPictureAlt.self; PolicyHalfDoorsAsset.self }
        Break.self
        ListItem { Link { RollCall<Nav.Cycles>.self; Nav.Cycles.self } }
        ListItem { Link { RollCall<Nav.ReturnToOffice>.self; Nav.ReturnToOffice.self } }
        ListItem { Link { UpWord.self; PolicyOrNumbers.self } }
        Break.self
        TopicsHeadingBlock.self
        TopicDoor<Nav.Cycles>.self
        TopicDoor<Nav.ReturnToOffice>.self

    }
}
enum NumbersHalfDoorsAsset: Close {}
extension NumbersHalfDoorsAsset {
    static var typeName: String { "site-doors-numbershalf" }
}
public enum NumbersHalfPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { NumbersHalfTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentRight.self; StepDot.self; WentRight.self
        Break.self
        Picture { WalkDoorsPictureAlt.self; NumbersHalfDoorsAsset.self }
        Break.self
        ListItem { Link { RollCall<Nav.Reports>.self; Nav.Reports.self } }
        ListItem { Link { RollCall<Nav.CompanyDashboard>.self; Nav.CompanyDashboard.self } }
        ListItem { Link { UpWord.self; PolicyOrNumbers.self } }
        Break.self
        TopicsHeadingBlock.self
        TopicDoor<Nav.Reports>.self
        TopicDoor<Nav.CompanyDashboard>.self

    }
}
enum DepartmentsOrDirectoriesDoorsAsset: Close {}
extension DepartmentsOrDirectoriesDoorsAsset {
    static var typeName: String { "site-doors-departmentsordirectories" }
}
public enum DepartmentsOrDirectoriesPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { DepartmentsOrDirectoriesTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self; StepDot.self; WentLeft.self; StepDot.self; WentRight.self
        Break.self
        Picture { WalkDoorsPictureAlt.self; DepartmentsOrDirectoriesDoorsAsset.self }
        Break.self
        ListItem { Link { RollCall<Nav.Departments>.self; Nav.Departments.self } }
        ListItem { Link { RollCall<Nav.Directories>.self; Nav.Directories.self } }
        ListItem { Link { UpWord.self; PeopleHalf.self } }
        Break.self
        TopicsHeadingBlock.self
        TopicDoor<Nav.Departments>.self
        TopicDoor<Nav.Directories>.self

    }
}
enum BoardOrTasksDoorsAsset: Close {}
extension BoardOrTasksDoorsAsset {
    static var typeName: String { "site-doors-boardortasks" }
}
public enum BoardOrTasksPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { BoardOrTasksTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self; StepDot.self; WentRight.self; StepDot.self; WentLeft.self
        Break.self
        Picture { WalkDoorsPictureAlt.self; BoardOrTasksDoorsAsset.self }
        Break.self
        ListItem { Link { RollCall<Nav.Board>.self; Nav.Board.self } }
        ListItem { Link { RollCall<Nav.Tasks>.self; Nav.Tasks.self } }
        ListItem { Link { UpWord.self; WorkHalf.self } }
        Break.self
        TopicsHeadingBlock.self
        TopicDoor<Nav.Board>.self
        TopicDoor<Nav.Tasks>.self

    }
}
