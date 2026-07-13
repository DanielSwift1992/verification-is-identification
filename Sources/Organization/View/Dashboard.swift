import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// THE DASHBOARD names the company's key figures, read straight off the enforced types.
//
// Every number here is a `Tally` of a real System type (`Company`, `AllDepartments`,
// `CertifiedRules`, `StandingReport`). Nothing is authored, nothing can drift from what
// compiles. The page itself is a type: reading `DashboardPage.typeName` renders the markdown.
// ═══════════════════════════════════════════════════════════════

/// This names the bare asset name a `Picture` reads (Resources/pulse.svg): Pulse's
/// tokens (Design.swift) drawing the key figures, the department bars, and the workplace split
/// as one clickable dashboard. Replaces the markdown `@Row` tiles and `chart-headcount.svg`
/// both, one source for these numbers, not two or three.
enum PulseAsset: Close {}
extension PulseAsset {
    public static var typeName: String { "pulse" }
}
enum PulseAlt: Close {}
extension PulseAlt {
    public static var typeName: String { "Company Pulse" }
}

enum PulseBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Picture { PulseAlt.self; PulseAsset.self }
        Break.self
        PulseCaption.self
    }
}

/// The walk door: one line under the catalog grid offering the halving walk
/// (Wayfinding.swift) — at most four choices from here to any page, every door a witness.
enum WalkDoorLabel: Close {}
extension WalkDoorLabel {
    public static var typeName: String { "New here? Any page is four choices away" }
}
enum FormQueryLabel: Close {}
extension FormQueryLabel {
    static var typeName: String { "Or form a query with your feet: a department and a rank, four doors" }
}
enum WalkDoor: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Link { WalkDoorLabel.self; SiteWalk.self }
        Break.self
        Link { FormQueryLabel.self; RoleWalk.self }
    }
}

enum CatalogLinks: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        ListItem { Page { Nav.Employees.self } }
        ListItem { Page { Nav.Departments.self } }
        ListItem { Page { Nav.Documents.self } }
        ListItem { Page { Nav.Tasks.self } }
        ListItem { Page { Nav.Directories.self } }
        ListItem { Page { Nav.Reports.self } }
        ListItem { Page { Nav.Cycles.self } }
        ListItem { Page { Nav.ReturnToOffice.self } }
    }
}

// The named team's cards, one column each: the avatar picture, then a link to that
// person's page (Card.swift's header, a doc-extension merged onto their symbol, so the
// link target is the person, not a second address). A table, not `@Row`/`@Column`: checked
// directly, the DocC theme centers an embedded image inside a `.column` (a fixed left/right
// margin, regardless of content), but not inside a table cell, flush against its edge instead.
// Four named people, hand-enumerated (Surface Law §S8): a small, closed set, no generic to
// buy back.
enum CardPictureRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Picture { Symbol { Alice.self }; AvatarAsset.self } }
        TableCell { Picture { Symbol { Bob.self }; AvatarAsset.self } }
        TableCell { Picture { Symbol { Carol.self }; AvatarAsset.self } }
        TableCell { Picture { Symbol { Dave.self }; AvatarAsset.self } }
    }
}
enum CardRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}
enum CardNameRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Link { FullNameOf { Alice.self }; Alice.self } }
        TableCell { Link { FullNameOf { Bob.self }; Bob.self } }
        TableCell { Link { FullNameOf { Carol.self }; Carol.self } }
        TableCell { Link { FullNameOf { Dave.self }; Dave.self } }
    }
}
enum CardRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { CardPictureRow.self }
        TableRow { CardRule.self }
        TableRow { CardNameRow.self }
    }
}

public enum DashboardPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { DashboardTitle.self }
        DashboardIntro.self; Break.self
        DoubleHash.self; KeyFiguresHeading.self; Break.self
        PulseBlock.self
        Break.self
        DoubleHash.self; CatalogsHeading.self; Break.self
        LinkGrid { CatalogLinks.self }
        Break.self
        WalkDoor.self
        Break.self
        DoubleHash.self; CardsHeading.self; Break.self
        CardsIntro.self; Break.self
        Table { CardRows.self }
        Break.self
    }
}
