import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// REVIEW CYCLES names the year-close interlock, read from the types.
//
// The last hand-authored page brought into the pipeline: every figure below is a reading of
// System/ReviewCycle.swift, the cuts carry their year, cohort, and enforcer as associated
// types, so one authored anchor (the cut) derives its whole timeline row. The batch lines are
// `labels` reads of the same Batch types the count test pins, the cohort is listed once, in
// the system, and this page cannot disagree with it.
// ═══════════════════════════════════════════════════════════════

// ── Readers — a cut derives its row, a cohort derives its line ──

/// This names the year a cut closed, read off the cut's name: `Cut2026` carries "2026" the way a
/// handle carries its label. The prefix is the one authored convention, dropped at render.
enum CutYear<
    Cut: CommittedCut
>: Close {}
extension CutYear {
    public static var typeName: String { String(String(describing: Cut.self).dropFirst(3)) }
}

/// This gives one year's cohort as a run of symbol links: `labels` of the batch the cut names,
/// the same reading `testBatchListsItsEmployeesInOrder` pins, not a second list kept beside it.
enum BatchLine<
    Cut: CommittedCut
>: Close {}
extension BatchLine {
    public static var typeName: String {
        CutYear<Cut>.typeName + ": "
            + Cut.Cohort.labels.map { "``" + $0 + "``" }.joined(separator: ", ")
    }
}

/// One timeline row, derived entirely from the cut: the year from its name, the band from the
/// cohort's fold (`Tally`), the enforcer and the cut itself as symbols.
enum TimelineRow<
    Cut: CommittedCut
>: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow {
            TableCell { CutYear<Cut>.self }
            TableCell { Tally { Cut.Cohort.self } }
            TableCell { Symbol { Cut.EnforcedBy.self } }
            TableCell { Symbol { Cut.self } }
        }
    }
}

// ── Long prose — literal atoms, §S22's door for paragraphs ──

enum CyclesIntroBody: Close {}
extension CyclesIntroBody {
    public static var typeName: String {
        "Some companies run forced distribution: rank everyone each year and let the bottom share go, here enforced by the People manager who owns the policy. Microsoft did it until 2013, and Amazon ran a version of it. This demo does not rank or score anyone. A real system would, from its performance data. It takes the decision as given and shows the part that holds by construction: the year cannot close until the cut is recorded."
    }
}

enum TimelineCaptionBody: Close {}
extension TimelineCaptionBody {
    public static var typeName: String {
        "The last column is the confirming fact, not a tick: each links to the ``CommittedCut`` type that closed the year. Open it for the cycle, the enforcer, and the interlock."
    }
}

enum BatchClosingBody: Close {}
extension BatchClosingBody {
    public static var typeName: String {
        "A batch each year, not one name: the 5% band, 10 of the founding 200. The committed cut names its whole cohort in the types, and the policy pins that cohort to exactly the band (`Cohort.Length == Ten`), so a cut of a different size will not compile and the 5% is enforced, not just claimed. A departed person's type stays in the roster, since the system is static, and their card marks the year-close that ended their tenure."
    }
}

enum HeadcountExplainerBody: Close {}
extension HeadcountExplainerBody {
    public static var typeName: String {
        "Headcount is the first ORDERED quantity here: a cap asks how many are ≤ X, a comparison, where the atoms (names, ranks) compare only by identity. The framework's marker for such a value is `IntegerValued`. The cap is a policy, and its satisfaction is read off the roster at the close. Every department is within cap, so the requirements hold."
    }
}

enum InterlockBody: Close {}
extension InterlockBody {
    public static var typeName: String {
        "The next year is `Closed<Prev, Cut>`: a type you cannot write without a cut committed for that year. The cut must name the whole band the policy lets go, 10 people, 5% of the founding 200, and its enforcer must be a manager. A cut that names a different number will not compile, so the size is proved, not just stated. The chain compiles through 2030, so every year closed with its cut."
    }
}

enum LeavesOutBody: Close {}
extension LeavesOutBody {
    public static var typeName: String {
        "No ranking runs here, and no score is stored. A real system would hold performance data and compute the cut from it. The demo keeps the decision as data and enforces the one thing that holds by construction: the year does not close until the cut is recorded. This is the move for a policy like this one: rather than trust a process to run, make the next state unreachable until the decision is on record."
    }
}

// ── The tables ──

enum TimelineHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { YearHeader.self }
        TableCell { BatchBandHeader.self }
        TableCell { EnforcedByHeader.self }
        TableCell { CommittedCutHeader.self }
    }
}

enum TimelineRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}

enum TimelineRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { TimelineHeader.self }
        TableRow { TimelineRule.self }
        TimelineRow<Cut2026>.self
        TimelineRow<Cut2027>.self
        TimelineRow<Cut2028>.self
        TimelineRow<Cut2029>.self
    }
}

/// This names the cap's verdict: `Crew.count <= 60` reads the same policy number the row's cap
/// column states as a type (`TextDigit`, the §S15 discipline: stated, not computed, 60 is 30% of
/// the roster of 200, hardcoded here to match), so this IS the "ordered comparison, read at the
/// close" the explainer promises, not an echo of a department name.
enum WithinVerdict<
    Crew: Structure
>: Close {}
extension WithinVerdict {
    public static var typeName: String { Crew.count <= 60 ? "within" : "over cap" }
}

/// This is one department's requirement row. The cap is a policy number, STATED as a type
/// (`TextDigit`, the §S15 discipline: stated, not computed), 30% of the roster of 200.
/// Its satisfaction is an ordered comparison, read at the close, as the explainer says.
enum HeadcountRow<
    Home: Department,
    Crew: Structure
>: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow {
            TableCell { Symbol { Home.self } }
            TableCell { Tally { Crew.self } }
            TableCell { TextDigit._6.self; TextDigit._0.self }
            TableCell { WithinVerdict<Crew>.self }
        }
    }
}

enum HeadcountHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { DepartmentHeader.self }
        TableCell { PeopleHeader.self }
        TableCell { CapHeader.self }
        TableCell { WithinHeader.self }
    }
}

enum HeadcountRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { HeadcountHeader.self }
        TableRow { TimelineRule.self }
        HeadcountRow<
            Finance,
            FinanceTeam
        >.self
        HeadcountRow<
            Engineering,
            EngineeringTeam
        >.self
        HeadcountRow<
            Sales,
            SalesTeam
        >.self
        HeadcountRow<
            People,
            PeopleTeam
        >.self
    }
}

// ── The cut's own page — a doc-extension merged onto ``Cut2026``'s own DocC symbol page (title
//    match, the same merge `EmployeeCard`/Card.swift's header explains), so a reader who follows
//    "Open it for the cycle, the enforcer, and the interlock" (the Timeline caption, above)
//    lands somewhere richer than the bare auto-generated Type Aliases page — and has a way back
//    (FINDINGS4 A-05). ──

enum CutIntroPrefix: Close {}
extension CutIntroPrefix {
    public static var typeName: String { "The " }
}
enum CutIntroMiddle: Close {}
extension CutIntroMiddle {
    public static var typeName: String { " year-close, enforced by " }
}
enum CutIntroSuffix: Close {}
extension CutIntroSuffix {
    public static var typeName: String { "." }
}

/// This gives one cut's page: the year and enforcer (both reads off the type, `CutYear` +
/// `Symbol`), the cohort it let go (`BatchLine`, reused from the timeline above), and a way back.
public enum CutPage<
    Cut: CommittedCut
>: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { Cut.self } }
        CutIntroPrefix.self; CutYear<Cut>.self; CutIntroMiddle.self; Symbol { Cut.EnforcedBy.self }; CutIntroSuffix.self
        Break.self
        ListItem { BatchLine<Cut>.self }
        Break.self
        Link { CyclesTitle.self; Nav.Cycles.self }
    }
}

// ── The page ──

// This is a hero above the table: the same four cuts, drawn as a hover timeline.
enum CyclesHeroAsset: Close {}
extension CyclesHeroAsset {
    public static var typeName: String { "cycles-hero" }
}
enum CyclesHeroAlt: Close {}
extension CyclesHeroAlt {
    public static var typeName: String { "Review cycles" }
}
enum CyclesHeroBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Picture { CyclesHeroAlt.self; CyclesHeroAsset.self }
        Break.self
    }
}

public enum CyclesPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { CyclesTitle.self }
        CyclesIntroBody.self; Break.self
        CyclesHeroBlock.self
        DoubleHash.self; TimelineHeading.self; Break.self
        Table { TimelineRows.self }
        Break.self
        TimelineCaptionBody.self; Break.self
        DoubleHash.self; BatchByYearHeading.self; Break.self
        ListItem { BatchLine<Cut2026>.self }
        ListItem { BatchLine<Cut2027>.self }
        ListItem { BatchLine<Cut2028>.self }
        ListItem { BatchLine<Cut2029>.self }
        Break.self
        BatchClosingBody.self; Break.self
        DoubleHash.self; HeadcountRequirementsHeading.self; Break.self
        Table { HeadcountRows.self }
        Break.self
        HeadcountExplainerBody.self; Break.self
        DoubleHash.self; InterlockHeading.self; Break.self
        Flagged { InterlockBody.self }
        DoubleHash.self; LeavesOutHeading.self; Break.self
        Noted { LeavesOutBody.self }
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; Link { ReportsTitle.self; Nav.Reports.self }; Chevron.self; CyclesTitle.self
    }
}
