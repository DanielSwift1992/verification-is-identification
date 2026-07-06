import Alphabet
import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// DEPARTMENTS names the four organizational units, read off the types.
// ═══════════════════════════════════════════════════════════════

// Four department cards, side by side. Header is the department's symbol-link, then its
// facts as a short list: People (a `Tally`), shared space, owned vault, owner. Sales and People
// carry no vault, so those two rows read `NoneMark` ("—"), the same mark the table used.
enum FinanceDeptCard: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Symbol { Finance.self }
        Break.self
        ListItem { PeopleHeader.self; Colon.self; Space.self; Tally { FinanceTeam.self } }
        ListItem { SharedSpaceHeader.self; Colon.self; Space.self; Symbol { FinanceShare.self } }
        ListItem { OwnedVaultHeader.self; Colon.self; Space.self; Symbol { FinanceVault.self } }
        ListItem { OwnerHeader.self; Colon.self; Space.self; Symbol { FinanceVault.Owner.self } }
    }
}
enum EngineeringDeptCard: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Symbol { Engineering.self }
        Break.self
        ListItem { PeopleHeader.self; Colon.self; Space.self; Tally { EngineeringTeam.self } }
        ListItem { SharedSpaceHeader.self; Colon.self; Space.self; Symbol { EngineeringShare.self } }
        ListItem { OwnedVaultHeader.self; Colon.self; Space.self; Symbol { EngineeringRepo.self } }
        ListItem { OwnerHeader.self; Colon.self; Space.self; Symbol { EngineeringRepo.Owner.self } }
    }
}
enum SalesDeptCard: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Symbol { Sales.self }
        Break.self
        ListItem { PeopleHeader.self; Colon.self; Space.self; Tally { SalesTeam.self } }
        ListItem { SharedSpaceHeader.self; Colon.self; Space.self; Symbol { SalesShare.self } }
        ListItem { OwnedVaultHeader.self; Colon.self; Space.self; NoneMark.self }
        ListItem { OwnerHeader.self; Colon.self; Space.self; NoneMark.self }
    }
}
enum PeopleDeptCard: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Symbol { People.self }
        Break.self
        ListItem { PeopleHeader.self; Colon.self; Space.self; Tally { PeopleTeam.self } }
        ListItem { SharedSpaceHeader.self; Colon.self; Space.self; Symbol { PeopleShare.self } }
        ListItem { OwnedVaultHeader.self; Colon.self; Space.self; NoneMark.self }
        ListItem { OwnerHeader.self; Colon.self; Space.self; NoneMark.self }
    }
}
enum DepartmentsColumns: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PanelOf { FinanceDeptCard.self }
        PanelOf { EngineeringDeptCard.self }
        PanelOf { SalesDeptCard.self }
        PanelOf { PeopleDeptCard.self }
    }
}

// A hero above the cards: the same four facts, drawn.
enum DepartmentsHeroAsset: Close {}
extension DepartmentsHeroAsset {
    public static var typeName: String { "departments-hero" }
}
enum DepartmentsHeroAlt: Close {}
extension DepartmentsHeroAlt {
    public static var typeName: String { "Departments" }
}
enum DepartmentsHeroBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Picture { DepartmentsHeroAlt.self; DepartmentsHeroAsset.self }
        Break.self
    }
}

public enum DepartmentsPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { DepartmentsTitle.self }
        DepartmentsIntro.self; Break.self
        DepartmentsHeroBlock.self
        DoubleHash.self; AllDepartmentsHeading.self; Break.self
        SideBySide { DepartmentsColumns.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; DepartmentsTitle.self
    }
}
