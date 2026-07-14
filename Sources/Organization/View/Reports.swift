import Alphabet
import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// REPORTS names the company's audit, re-proved on every build.
// ═══════════════════════════════════════════════════════════════

// ── Access matrix — reuses Documents.swift's per-vault tables, the one source ──

enum AccessMatrixTab: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Symbol { FinanceVault.self }; Break.self
        Table { FinanceAccessRows.self }
        Symbol { EngineeringRepo.self }; Break.self
        Table { EngineeringAccessRows.self }
    }
}

// ── Standing invariants ──

enum StandingInvariantsTab: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        DataResidencyLine.self; Break.self
        ManagerLedLine.self; Break.self
        OwnersLine {
            Symbol { FinanceVault.Owner.self }
            Symbol { FinanceVault.Owner.Home.self }
            Symbol { EngineeringRepo.Owner.self }
            Symbol { EngineeringRepo.Owner.Home.self }
        }
        Break.self
        Tally { StandingReport.self }; Space.self; InvariantsProvedLine.self; Break.self
    }
}

// ── Scale ──

enum ScaleHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { MeasureHeader.self }
        TableCell { ThisBuildHeader.self }
    }
}
enum ScaleRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}
enum CertifiedRuleClassesRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { CertifiedRulesLabel.self }
        TableCell { Tally { CertifiedRules.self } }
    }
}
enum AccessesCertifiedRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { AccessesCertifiedLabel.self }
        TableCell { Tally { AllAccesses.self } }
    }
}
enum ProofsSavedRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { ProofsSavedLabel.self }
        TableCell { TimesValue { ProofsSavedRatio.self } }
    }
}
enum ScaleRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { ScaleHeader.self }
        TableRow { ScaleRule.self }
        TableRow { CertifiedRuleClassesRow.self }
        TableRow { AccessesCertifiedRow.self }
        TableRow { ProofsSavedRow.self }
    }
}
enum ScaleTab: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        ScaleIntro.self; Break.self
        Table { ScaleRows.self }
    }
}

enum ReportsTabs: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        At.self; TabLabel.self; ParenOpen.self; Quote.self; AccessMatrixHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        AccessMatrixTab.self
        CloseBrace.self
        At.self; TabLabel.self; ParenOpen.self; Quote.self; StandingInvariantsHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        StandingInvariantsTab.self
        CloseBrace.self
        At.self; TabLabel.self; ParenOpen.self; Quote.self; ScaleHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        ScaleTab.self
        CloseBrace.self
    }
}

public enum ReportsPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { ReportsTitle.self }
        ReportsIntro.self; Break.self
        TabGroup { ReportsTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; ReportsTitle.self
    }
}

// ── Return to office — its own page, a policy in its own right (Reports audits it; this is the
// policy the audit reads), the same standing Cycles already has. ──

enum ReturnToOfficeHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { ArrangementHeader.self }
        TableCell { MeetsMinimumHeader.self }
    }
}
enum ReturnToOfficeRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}
enum OnSiteMinimumRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { OnSite.self } }
        TableCell { OnSiteMinimum.self }
    }
}
enum HybridMinimumRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Hybrid.self } }
        TableCell { HybridMinimum.self }
    }
}
enum RemoteMinimumRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Remote.self } }
        TableCell { RemoteMinimum.self }
    }
}
enum ReturnToOfficeRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { ReturnToOfficeHeader.self }
        TableRow { ReturnToOfficeRule.self }
        TableRow { OnSiteMinimumRow.self }
        TableRow { HybridMinimumRow.self }
        TableRow { RemoteMinimumRow.self }
    }
}

// ── Who clears it — the named team, each verdict read off `Who.Site`. Alice and Dave are
// literally `OnSite` (the same type their `Site` typealias names, Team.swift), so their row
// reuses `OnSiteMinimum` — the same proxy the arrangements table above already uses, not a
// second one: the verdict does not change because a different person asks for it. ──

enum WhoClearsItHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { PersonHeader.self }
        TableCell { WorksHeader.self }
        TableCell { MeetsMinimumHeader.self }
    }
}
enum WhoClearsItRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}
enum AliceClearsItRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Alice.self } }
        TableCell { Symbol { Alice.Site.self } }
        TableCell { OnSiteMinimum.self }
    }
}
enum BobClearsItRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Bob.self } }
        TableCell { Symbol { Bob.Site.self } }
        TableCell { HybridMinimum.self }
    }
}
enum CarolClearsItRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Carol.self } }
        TableCell { Symbol { Carol.Site.self } }
        TableCell { RemoteMinimum.self }
    }
}
enum DaveClearsItRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Dave.self } }
        TableCell { Symbol { Dave.Site.self } }
        TableCell { OnSiteMinimum.self }
    }
}
enum WhoClearsItRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { WhoClearsItHeader.self }
        TableRow { WhoClearsItRule.self }
        TableRow { AliceClearsItRow.self }
        TableRow { BobClearsItRow.self }
        TableRow { CarolClearsItRow.self }
        TableRow { DaveClearsItRow.self }
    }
}

// ── Across the company — the same three verified chains Employees' workplace breakdown already
// reads (`OnSiteTeam`/`HybridTeam`/`RemoteTeam`, GeneratedTeam.swift), not a second source. ──

enum AcrossTheCompanyHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { CategoryHeader.self }
        TableCell { PeopleHeader.self }
    }
}
enum AcrossTheCompanyRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}
enum OnSiteCompanyRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { OnSite.self } }
        TableCell { Tally { OnSiteTeam.self } }
    }
}
enum HybridCompanyRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Hybrid.self } }
        TableCell { Tally { HybridTeam.self } }
    }
}
enum RemoteCompanyRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Remote.self } }
        TableCell { Tally { RemoteTeam.self } }
    }
}
enum AcrossTheCompanyRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { AcrossTheCompanyHeader.self }
        TableRow { AcrossTheCompanyRule.self }
        TableRow { OnSiteCompanyRow.self }
        TableRow { HybridCompanyRow.self }
        TableRow { RemoteCompanyRow.self }
    }
}

/// This names `OfficeArrangement`'s bare name, not `Symbol { OfficeArrangement<OnSite>.self }`:
/// that reads a real, but APPLIED, generic (`String(describing:)` prints "OfficeArrangement
/// <OnSite>", the one instance, not the type family), and there is no way to write the
/// unapplied generic's name as a value at all (checked directly, the same wall SurfaceLaw
/// §S11 already names for a combinator's hole). Literal text, the same call `ModuleTitleTarget`
/// (DocumentKit/Landing.swift) already makes for a name no single value can stand in for.
enum OfficeArrangementName: Close {}
extension OfficeArrangementName {
    public static var typeName: String { "OfficeArrangement" }
}

/// This is the paragraph below: it spells over 500 characters. ProseGen (Prose.json) spells prose
/// one GLYPH atom per character, and a `Structure` that long crashed the render with "failed to
/// demangle witness for associated type 'Body' … Mangled type is too complex" (checked
/// directly, on this exact text), a REAL limit, sharper than §S16's stack depth: not a crash
/// at render time, a metadata complexity ceiling the compiled binary hits before it ever gets
/// that far. A literal `typeName`, the same call every long caption in DocumentKit/Landing.swift
/// already makes, has no such chain to build.
enum WhyArrangementBody: Close {}
extension WhyArrangementBody {
    public static var typeName: String {
        "The policy asks two different questions, and this page proves the cheap one. Which arrangement a person holds is a marker: one conformance, checked by name. How many hours they actually logged would be an ordered quantity, a typed count compared against a threshold (Peano `>=`): a strictly heavier move (Distance Is Cost: the price of a claim is the structure it must carry). The demo proves the marker half and names the ordered half as the next, dearer step. The boundary between the two is exactly where the type gets more expensive."
    }
}

// This is a hero above the ribbon: the three arrangements, drawn with their verdict.
enum RtoHeroAsset: Close {}
extension RtoHeroAsset {
    public static var typeName: String { "rto-hero" }
}
enum RtoHeroAlt: Close {}
extension RtoHeroAlt {
    public static var typeName: String { "Return to office arrangements" }
}
enum RtoHeroBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Picture { RtoHeroAlt.self; RtoHeroAsset.self }
        Break.self
    }
}

public enum ReturnToOfficePage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { ReturnToOfficeTitle.self }
        ReturnToOfficeIntro.self; Break.self
        RtoHeroBlock.self
        OfficeMinimumRibbon.self
        Break.self
        Table { ReturnToOfficeRows.self }
        Break.self
        DoubleHash.self; WhoClearsItHeading.self; Break.self
        Table { WhoClearsItRows.self }
        Break.self
        DoubleHash.self; AcrossTheCompanyHeading.self; Break.self
        Table { AcrossTheCompanyRows.self }
        Break.self
        DoubleHash.self; WhyArrangementHeading.self; Break.self
        WhyArrangementBody.self
        Break.self
        Warned { RefusalWarningPrefix.self; Symbol { Carol.self }; RefusalWarningMiddle.self; Symbol { Remote.self }; RefusalWarningSuffix.self }
        ReadTheTypesLabel.self; Space.self
        Symbol { OfficeArrangementName.self }; Comma.self; Space.self
        ProtocolReference<any Workplace>.self; Comma.self; Space.self
        ProtocolReference<any ComesToOffice>.self; Comma.self; Space.self
        ProtocolReference<any MeetsOfficeMinimum>.self
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; ReturnToOfficeTitle.self
    }
}
