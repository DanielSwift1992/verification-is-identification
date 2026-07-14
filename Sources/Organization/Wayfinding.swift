import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// WAYFINDING halves the site until one page survives.
//
// Site.swift states the order bottom-up: every place knows the place above it. This file
// states the walkable reading, top-down: the ten places regrouped into halves, each half a
// plain composed body, so the fork at every step is `Pair` itself and the doors' faces are
// witnesses (`RollCall`, `Tally`) of the very halves they open. Nothing here is a second
// list of pages: a place stands in a half by being composed into it, and the walk pages
// (View/WalkPages.swift) read these types, so a door cannot say what its half does not
// hold. The walker brings the one thing the system cannot know, which half the wanted
// page is in, and four choices at most land anywhere.
// ═══════════════════════════════════════════════════════════════

/// This marks a halving: a regrouping of the site whose body lists the two halves a walker
/// chooses between. A category under `Open`, the same sanctioned move `SiteOrder` makes.
public protocol Halves: Open {}

/// This reads one person out the way a phone book does, family name first, the handle in
/// brackets since many people share a name (the name is an atom, the handle the identity).
/// The face of a door that lands on one person.
public enum NameOf<Someone: Person & Structure>: Close {}
extension NameOf {
    public static var typeName: String {
        "\(Someone.Family.typeName), \(Someone.Given.typeName) (\(Someone.typeName))"
    }
}

/// This reads a shelf of people out by its edges, phone-book order: the face of a door to
/// a half too wide to name person by person. Both edges are projections of real employees,
/// so the face cannot drift from the shelf.
public enum NameSpan<First: Person, Last: Person>: Close {}
extension NameSpan {
    public static var typeName: String {
        "\(First.Family.typeName), \(First.Given.typeName) … \(Last.Family.typeName), \(Last.Given.typeName)"
    }
}

public enum DepartmentsOrDirectories: Halves {
    @StructureBuilder
    public static var body: some Structure {
        Nav.Departments.self
        Nav.Directories.self
    }
}
public enum PeopleHalf: Halves {
    @StructureBuilder
    public static var body: some Structure {
        Nav.Employees.self
        DepartmentsOrDirectories.self
    }
}
public enum BoardOrTasks: Halves {
    @StructureBuilder
    public static var body: some Structure {
        Nav.Board.self
        Nav.Tasks.self
    }
}
public enum WorkHalf: Halves {
    @StructureBuilder
    public static var body: some Structure {
        BoardOrTasks.self
        Nav.Documents.self
    }
}
public enum PolicyHalf: Halves {
    @StructureBuilder
    public static var body: some Structure {
        Nav.Cycles.self
        Nav.ReturnToOffice.self
    }
}
public enum NumbersHalf: Halves {
    @StructureBuilder
    public static var body: some Structure {
        Nav.Reports.self
        Nav.CompanyDashboard.self
    }
}
public enum PeopleOrWork: Halves {
    @StructureBuilder
    public static var body: some Structure {
        PeopleHalf.self
        WorkHalf.self
    }
}
public enum PolicyOrNumbers: Halves {
    @StructureBuilder
    public static var body: some Structure {
        PolicyHalf.self
        NumbersHalf.self
    }
}

/// The whole site as one walkable type: the root every walk starts from. Its `count` is
/// the coverage, read against ``AllPlaces``: the demo audit prints both counts.
public enum SiteWalk: Halves {
    @StructureBuilder
    public static var body: some Structure {
        PeopleOrWork.self
        PolicyOrNumbers.self
    }
}
