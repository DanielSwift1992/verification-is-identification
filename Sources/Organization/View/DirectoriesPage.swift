import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// DIRECTORIES names every attribute in the company, read as the protocol that names it.
// Generated, like every other hub, part of the render pipeline, not a second hand-authored
// artifact this whole showcase otherwise refuses to keep, the same discipline Return to
// Office's page holds too.
//
// A protocol (`Gender`, `CanView`, …) is not `Structure`-conforming, so `Symbol` (built for a
// concrete type) cannot read one (checked directly). `ProtocolReference` (DocumentKit,
// Markup.swift, next to `RawName`) is the door built for exactly this: the same double-backtick
// shape, for the one case `Symbol` cannot take.
// ═══════════════════════════════════════════════════════════════

enum DirectoryRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        ListItem { ProtocolReference<any Gender>.self }
        ListItem { ProtocolReference<any Department>.self }
        ListItem { ProtocolReference<any BirthYear>.self }
        ListItem { ProtocolReference<any GivenName>.self }
        ListItem { ProtocolReference<any FamilyName>.self }
        ListItem { ProtocolReference<any TaskState>.self }
        ListItem { ProtocolReference<any Workplace>.self }
    }
}

enum CapabilityRefinementRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        ListItem { ProtocolReference<any CanView>.self }
        ListItem { ProtocolReference<any CanEdit>.self }
        ListItem { ProtocolReference<any CanAdmin>.self }
    }
}

enum OfficeRefinementRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        ListItem { ProtocolReference<any Workplace>.self }
        ListItem { ProtocolReference<any ComesToOffice>.self }
    }
}

public enum DirectoriesPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { DirectoriesTitle.self }
        DirectoriesIntro.self; Break.self
        DoubleHash.self; TheDirectoriesHeading.self; Break.self
        DirectoryRows.self
        Break.self
        DoubleHash.self; RankRefinementHeading.self; Break.self
        CapabilityRefinementRows.self
        Break.self
        CapabilityRefinementRibbon.self
        Break.self
        DoubleHash.self; OfficeRefinementHeading.self; Break.self
        OfficeRefinementRows.self
        Break.self
        OfficeMinimumRibbon.self
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; DirectoriesTitle.self
    }
}
