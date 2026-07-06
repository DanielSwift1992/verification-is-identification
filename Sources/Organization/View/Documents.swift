import Alphabet
import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// DOCUMENTS names every document, and who may reach it, read from the compiler's verdict.
//
// Each `Capability` cell renders "granted" or the reason it is not, by conditional dispatch on
// whether the gate itself conforms `Decidable`, not a `decide()` call, not a stored Bool.
// ═══════════════════════════════════════════════════════════════

enum AllDocumentsHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { DocumentHeader.self }
        TableCell { KindHeader.self }
        TableCell { DepartmentHeader.self }
        TableCell { OwnerHeader.self }
    }
}
enum AllDocumentsRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}
enum FinanceVaultRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { FinanceVault.self } }
        TableCell { OwnedMark.self }
        TableCell { Symbol { Finance.self } }
        TableCell { Symbol { FinanceVault.Owner.self } }
    }
}
enum EngineeringRepoRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { EngineeringRepo.self } }
        TableCell { OwnedMark.self }
        TableCell { Symbol { Engineering.self } }
        TableCell { Symbol { EngineeringRepo.Owner.self } }
    }
}
enum FinanceShareRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { FinanceShare.self } }
        TableCell { SharedMark.self }
        TableCell { Symbol { Finance.self } }
        TableCell { NoneMark.self }
    }
}
enum EngineeringShareRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { EngineeringShare.self } }
        TableCell { SharedMark.self }
        TableCell { Symbol { Engineering.self } }
        TableCell { NoneMark.self }
    }
}
enum SalesShareRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { SalesShare.self } }
        TableCell { SharedMark.self }
        TableCell { Symbol { Sales.self } }
        TableCell { NoneMark.self }
    }
}
enum PeopleShareRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { PeopleShare.self } }
        TableCell { SharedMark.self }
        TableCell { Symbol { People.self } }
        TableCell { NoneMark.self }
    }
}
enum AllDocumentsRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { AllDocumentsHeader.self }
        TableRow { AllDocumentsRule.self }
        TableRow { FinanceVaultRow.self }
        TableRow { EngineeringRepoRow.self }
        TableRow { FinanceShareRow.self }
        TableRow { EngineeringShareRow.self }
        TableRow { SalesShareRow.self }
        TableRow { PeopleShareRow.self }
    }
}

// One named principal's reach into one vault: view, administer, delete. Each cell is a
// non-generic proxy (View/Cells.swift) resolving the real `Capability`/`ViewCapability` check at
// a literal site: `TableCell { Capability { … } }` directly reads the base case, wrong, a Swift
// generic-indirection limit checked directly (Cells.swift's header comment).
enum AliceFinanceAccessRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Alice.self } }
        TableCell { AliceFinanceView.self }
        TableCell { AliceFinanceAdmin.self }
        TableCell { AliceFinanceDelete.self }
    }
}
enum BobFinanceAccessRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Bob.self } }
        TableCell { BobFinanceView.self }
        TableCell { BobFinanceAdmin.self }
        TableCell { BobFinanceDelete.self }
    }
}
enum CarolFinanceAccessRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Carol.self } }
        TableCell { CarolFinanceView.self }
        TableCell { CarolFinanceAdmin.self }
        TableCell { CarolFinanceDelete.self }
    }
}
enum DaveFinanceAccessRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Dave.self } }
        TableCell { DaveFinanceView.self }
        TableCell { DaveFinanceAdmin.self }
        TableCell { DaveFinanceDelete.self }
    }
}
enum AliceEngineeringAccessRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Alice.self } }
        TableCell { AliceEngineeringView.self }
        TableCell { AliceEngineeringAdmin.self }
        TableCell { AliceEngineeringDelete.self }
    }
}
enum BobEngineeringAccessRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Bob.self } }
        TableCell { BobEngineeringView.self }
        TableCell { BobEngineeringAdmin.self }
        TableCell { BobEngineeringDelete.self }
    }
}
enum CarolEngineeringAccessRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Carol.self } }
        TableCell { CarolEngineeringView.self }
        TableCell { CarolEngineeringAdmin.self }
        TableCell { CarolEngineeringDelete.self }
    }
}
enum DaveEngineeringAccessRow: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { Dave.self } }
        TableCell { DaveEngineeringView.self }
        TableCell { DaveEngineeringAdmin.self }
        TableCell { DaveEngineeringDelete.self }
    }
}
enum AccessHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { PersonHeader.self }
        TableCell { ViewHeader.self }
        TableCell { AdministerHeader.self }
        TableCell { DeleteHeader.self }
    }
}
enum AccessRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}
enum FinanceAccessRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { AccessHeader.self }
        TableRow { AccessRule.self }
        TableRow { AliceFinanceAccessRow.self }
        TableRow { BobFinanceAccessRow.self }
        TableRow { CarolFinanceAccessRow.self }
        TableRow { DaveFinanceAccessRow.self }
    }
}
enum EngineeringAccessRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { AccessHeader.self }
        TableRow { AccessRule.self }
        TableRow { AliceEngineeringAccessRow.self }
        TableRow { BobEngineeringAccessRow.self }
        TableRow { CarolEngineeringAccessRow.self }
        TableRow { DaveEngineeringAccessRow.self }
    }
}

// The two access blocks, in tabs: the tab label already reads "Finance vault"/"Engineering
// repository", so the content starts straight into its table (the same shape Reports.swift's
// tabs already use, no redundant inner heading). `Table`'s own body ends in `Newline.self`
// (Grid, Markup.swift), so `CloseBrace.self` right after it already satisfies §S14.
enum DocumentsAccessTabs: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        At.self; TabLabel.self; ParenOpen.self; Quote.self; FinanceVaultTabLabel.self; Quote.self; ParenClose.self; OpenBrace.self
        Table { FinanceAccessRows.self }
        CloseBrace.self
        At.self; TabLabel.self; ParenOpen.self; Quote.self; EngineeringRepositoryTabLabel.self; Quote.self; ParenClose.self; OpenBrace.self
        Table { EngineeringAccessRows.self }
        CloseBrace.self
    }
}

// A hero above the table: the same six documents, as chips (an owned one carries
// an `AccentRole` dot).
enum DocHeroAsset: Close {}
extension DocHeroAsset {
    public static var typeName: String { "documents-hero" }
}
enum DocHeroAlt: Close {}
extension DocHeroAlt {
    public static var typeName: String { "The six documents" }
}
enum DocHeroBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Picture { DocHeroAlt.self; DocHeroAsset.self }
        Break.self
    }
}

public enum DocumentsPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { DocumentsTitle.self }
        DocumentsIntro.self; Break.self
        DocHeroBlock.self
        DoubleHash.self; AllDocumentsHeading.self; Break.self
        Table { AllDocumentsRows.self }
        Break.self
        TabGroup { DocumentsAccessTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; DocumentsTitle.self
    }
}
