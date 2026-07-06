import Alphabet
import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// EMPLOYEES names the directory, read off the roster.
//
// Every row is real: `Symbol { Emp0042.self }` links the type's DocC page, and
// `Tally { FinanceTeam.self }` reads a VERIFIED chain's count (every member proved in that
// department by the compiler), no runtime filter, no array scanned. The full roster's 200 rows
// are generated (private/gen_org.py, GeneratedRoster.swift), one `TableRow { RosterRow { … } }`
// per person.
// ═══════════════════════════════════════════════════════════════

/// This gives a person's given and family name, each linked separately: the reusable cell
/// content for any table column showing a full name.
enum FullNameOf<
    Who: Employee & Person
>: Fragment {
    init(@StructureBuilder _ who: () -> Who) { fatalError() }
    @StructureBuilder
    public static var body: some Structure {
        Symbol { Who.Given.self }
        Space.self
        Symbol { Who.Family.self }
    }
}

/// One roster row's cells: handle, full name, rank, department, work arrangement. Generic over
/// the person, so the same declaration draws the named team and the generated 200.
enum RosterRow<
    Who: Employee & Person
>: Fragment {
    init(@StructureBuilder _ who: () -> Who) { fatalError() }
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Who.self } }
        TableCell { FullNameOf { Who.self } }
        TableCell { Symbol { Who.Rank.self } }
        TableCell { Symbol { Who.Home.self } }
        TableCell { Symbol { Who.Site.self } }
    }
}

/// This wraps a roster row in its table row, in one call: the leaf the full roster's 200
/// generated entries actually use (GeneratedRoster.swift), so each generated line names one person once,
/// instead of repeating the `TableRow { RosterRow { … } }` wrapper 200 times.
enum RosterTableRow<
    Who: Employee & Person
>: Fragment {
    init(@StructureBuilder _ who: () -> Who) { fatalError() }
    @StructureBuilder
    public static var body: some Structure {
        TableRow { RosterRow { Who.self } }
    }
}

enum RosterHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { HandleHeader.self }
        TableCell { NameHeader.self }
        TableCell { RankHeader.self }
        TableCell { DepartmentHeader.self }
        TableCell { WorksHeader.self }
    }
}
/// This names the full roster's header delimiter, read by the generated table
/// (GeneratedRoster.swift, private/gen_org.py), which writes `TableRow { RosterRule.self }`
/// right after the header row.
enum RosterRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}

/// This is one named-team row's cells: handle, gender, birth year, department, work arrangement,
/// the identity fields the full roster's row does not show. The handle is a bare `Symbol`,
/// same as every other reference to a named person anywhere in the app, because each one's
/// symbol page IS their card now (Card.swift's header): one merge, not a link to chase.
enum NamedTeamRow<
    Who: Employee & Person
>: Fragment {
    init(@StructureBuilder _ who: () -> Who) { fatalError() }
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Who.self } }
        TableCell { FullNameOf { Who.self } }
        TableCell { Symbol { Who.Sex.self } }
        TableCell { Symbol { Who.Born.self } }
        TableCell { Symbol { Who.Home.self } }
        TableCell { Symbol { Who.Site.self } }
    }
}

enum NamedTeamHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { HandleHeader.self }
        TableCell { NameHeader.self }
        TableCell { GenderHeader.self }
        TableCell { BornHeader.self }
        TableCell { DepartmentHeader.self }
        TableCell { WorksHeader.self }
    }
}
enum NamedTeamRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}
enum NamedTeamRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { NamedTeamHeader.self }
        TableRow { NamedTeamRule.self }
        TableRow { NamedTeamRow { Alice.self } }
        TableRow { NamedTeamRow { Bob.self } }
        TableRow { NamedTeamRow { Carol.self } }
        TableRow { NamedTeamRow { Dave.self } }
    }
}

enum CountHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { CategoryHeader.self }   // shared across department/rank/workplace tables —
        TableCell { PeopleHeader.self }     // the section heading above names which facet it is.
    }
}
enum CountRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}

// One (label, verified-chain) headcount row per facet: plain named types, no generic, the
// department/rank/workplace facets are a fixed, closed set (never scaling with N, the same way
// the named team is fixed), so there is no reuse to buy back with a generic `CountRow`.
// `Team.count` is read off a chain every one of whose members the compiler proved shares the
// property, never a runtime filter.
enum FinanceCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Finance.self } }
        TableCell { Tally { FinanceTeam.self } }
    }
}
enum EngineeringCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Engineering.self } }
        TableCell { Tally { EngineeringTeam.self } }
    }
}
enum SalesCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Sales.self } }
        TableCell { Tally { SalesTeam.self } }
    }
}
enum PeopleCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { People.self } }
        TableCell { Tally { PeopleTeam.self } }
    }
}
enum IndividualContributorCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { IndividualContributor.self } }
        TableCell { Tally { IndividualContributorTeam.self } }
    }
}
enum LeadCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Lead.self } }
        TableCell { Tally { LeadTeam.self } }
    }
}
enum ManagerCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Manager.self } }
        TableCell { Tally { ManagerTeam.self } }
    }
}
enum OnSiteCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { OnSite.self } }
        TableCell { Tally { OnSiteTeam.self } }
    }
}
enum HybridCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Hybrid.self } }
        TableCell { Tally { HybridTeam.self } }
    }
}
enum RemoteCountRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Remote.self } }
        TableCell { Tally { RemoteTeam.self } }
    }
}

enum ByDepartmentRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { CountHeader.self }
        TableRow { CountRule.self }
        TableRow { FinanceCountRow.self }
        TableRow { EngineeringCountRow.self }
        TableRow { SalesCountRow.self }
        TableRow { PeopleCountRow.self }
    }
}
enum ByRankRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { CountHeader.self }
        TableRow { CountRule.self }
        TableRow { IndividualContributorCountRow.self }
        TableRow { LeadCountRow.self }
        TableRow { ManagerCountRow.self }
    }
}
enum ByWorkplaceRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { CountHeader.self }
        TableRow { CountRule.self }
        TableRow { OnSiteCountRow.self }
        TableRow { HybridCountRow.self }
        TableRow { RemoteCountRow.self }
    }
}

// The three aggregates, side by side: each column its own heading and table, unchanged, the
// same `SideBySide { PanelOf { … } }` shape ``BoardColumns`` (TasksBoard.swift) already uses.
enum ByDepartmentSection: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        DoubleHash.self; ByDepartmentHeading.self; Break.self
        Table { ByDepartmentRows.self }
    }
}
enum ByRankSection: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        DoubleHash.self; ByRankHeading.self; Break.self
        Table { ByRankRows.self }
    }
}
enum ByWorkplaceSection: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        DoubleHash.self; ByWorkplaceHeading.self; Break.self
        Table { ByWorkplaceRows.self }
    }
}
enum AggregatesColumns: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PanelOf { ByDepartmentSection.self }
        PanelOf { ByRankSection.self }
        PanelOf { ByWorkplaceSection.self }
    }
}

// This is a summary strip above the tables: the same three facets, as chips.
enum EmpHeroAsset: Close {}
extension EmpHeroAsset {
    public static var typeName: String { "employees-hero" }
}
enum EmpHeroAlt: Close {}
extension EmpHeroAlt {
    public static var typeName: String { "Headcount by department, rank, and workplace" }
}
enum EmpHeroBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Picture { EmpHeroAlt.self; EmpHeroAsset.self }
        Break.self
    }
}

public enum EmployeesPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { EmployeesTitle.self }
        EmployeesIntro.self; Break.self
        EmpHeroBlock.self
        DoubleHash.self; NamedTeamHeading.self; Break.self
        Table { NamedTeamRows.self }
        Break.self
        SideBySide { AggregatesColumns.self }
        Break.self
        DoubleHash.self; FullRosterHeading.self; Break.self
        Table { FullRosterRows.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; EmployeesTitle.self
        Break.self
        DoubleHash.self; TopicsHeading.self; Break.self
        TripleHash.self; TheTwoHundredHeading.self; Break.self
        GeneratedRosterTopics.self
    }
}

// The Topics section curates the two hundred under this hub: DocC nests every generated
// employee's page here instead of pouring them into the landing's automatic symbol flood.
enum TopicsHeading: Close {}
extension TopicsHeading {
    static var typeName: String { "Topics" }
}
enum TheTwoHundredHeading: Close {}
extension TheTwoHundredHeading {
    static var typeName: String { "The two hundred" }
}
