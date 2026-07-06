import VerificationIsIdentification
import DocumentKit
import Oracle

// The walk pages: one page per halving (Wayfinding.swift), each two doors and a step back
// up. A door's face is `RollCall` of the very half it opens and its address is the half
// type itself, so a door cannot mislabel its half and cannot point at a page that does not
// exist. The titles and the one hint line are the authored voice; everything else is read.

public enum WalkHint: Close {}
extension WalkHint {
    public static var typeName: String {
        "Two doors, and each door names every page behind it. Choose the half that holds yours, or step back up."
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

enum SiteWalkTitle: Close {}
extension SiteWalkTitle {
    public static var typeName: String { "Find your page" }
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

public enum SiteWalkPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { SiteWalkTitle.self }
        WalkHint.self; Break.self
        ListItem { Link { RollCall<PeopleOrWork>.self; PeopleOrWork.self } }
        ListItem { Link { RollCall<PolicyOrNumbers>.self; PolicyOrNumbers.self } }
        Break.self
    }
}
public enum PeopleOrWorkPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { PeopleOrWorkTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self
        Break.self
        ListItem { Link { RollCall<PeopleHalf>.self; PeopleHalf.self } }
        ListItem { Link { RollCall<WorkHalf>.self; WorkHalf.self } }
        ListItem { Link { UpWord.self; SiteWalk.self } }
        Break.self
    }
}
public enum PolicyOrNumbersPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { PolicyOrNumbersTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentRight.self
        Break.self
        ListItem { Link { RollCall<PolicyHalf>.self; PolicyHalf.self } }
        ListItem { Link { RollCall<NumbersHalf>.self; NumbersHalf.self } }
        ListItem { Link { UpWord.self; SiteWalk.self } }
        Break.self
    }
}
enum FindPersonLabel: Close {}
extension FindPersonLabel {
    public static var typeName: String { "Find one person, eight choices at most" }
}
public enum PeopleHalfPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { PeopleHalfTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self; StepDot.self; WentLeft.self
        Break.self
        ListItem { Link { RollCall<Nav.Employees>.self; Nav.Employees.self } }
        ListItem { Link { RollCall<DepartmentsOrDirectories>.self; DepartmentsOrDirectories.self } }
        ListItem { Link { FindPersonLabel.self; RosterSpan0000To0203.self } }
        ListItem { Link { UpWord.self; PeopleOrWork.self } }
        Break.self
    }
}
public enum WorkHalfPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { WorkHalfTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self; StepDot.self; WentRight.self
        Break.self
        ListItem { Link { RollCall<BoardOrTasks>.self; BoardOrTasks.self } }
        ListItem { Link { RollCall<Nav.Documents>.self; Nav.Documents.self } }
        ListItem { Link { UpWord.self; PeopleOrWork.self } }
        Break.self
    }
}
public enum PolicyHalfPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { PolicyHalfTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentRight.self; StepDot.self; WentLeft.self
        Break.self
        ListItem { Link { RollCall<Nav.Cycles>.self; Nav.Cycles.self } }
        ListItem { Link { RollCall<Nav.ReturnToOffice>.self; Nav.ReturnToOffice.self } }
        ListItem { Link { UpWord.self; PolicyOrNumbers.self } }
        Break.self
    }
}
public enum NumbersHalfPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { NumbersHalfTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentRight.self; StepDot.self; WentRight.self
        Break.self
        ListItem { Link { RollCall<Nav.Reports>.self; Nav.Reports.self } }
        ListItem { Link { RollCall<Nav.CompanyDashboard>.self; Nav.CompanyDashboard.self } }
        ListItem { Link { UpWord.self; PolicyOrNumbers.self } }
        Break.self
    }
}
public enum DepartmentsOrDirectoriesPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { DepartmentsOrDirectoriesTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self; StepDot.self; WentLeft.self; StepDot.self; WentRight.self
        Break.self
        ListItem { Link { RollCall<Nav.Departments>.self; Nav.Departments.self } }
        ListItem { Link { RollCall<Nav.Directories>.self; Nav.Directories.self } }
        ListItem { Link { UpWord.self; PeopleHalf.self } }
        Break.self
    }
}
public enum BoardOrTasksPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { BoardOrTasksTitle.self }
        WalkHint.self; Break.self
        WordSoFar.self; WentLeft.self; StepDot.self; WentRight.self; StepDot.self; WentLeft.self
        Break.self
        ListItem { Link { RollCall<Nav.Board>.self; Nav.Board.self } }
        ListItem { Link { RollCall<Nav.Tasks>.self; Nav.Tasks.self } }
        ListItem { Link { UpWord.self; WorkHalf.self } }
        Break.self
    }
}
