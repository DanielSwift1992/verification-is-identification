import Alphabet
import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// CARD names one profile per person, named or generated (Architecture.swift §5). Every card is a
// DOCUMENTATION EXTENSION merged onto that person's symbol page (`PageTitle { Symbol {
// Who.self } }`, the backtick title is what tells DocC to merge, not create a second address).
// This is deliberate, not incidental: it means EVERY existing `Symbol { Alice.self }` reference
// anywhere in the whole app, the roster, Documents.swift's access rows, TasksBoard.swift's
// assignees, wherever, starts showing the merged card for free. We do not chase down and
// rewrite every call site by hand; we control the ONE page each of those references already
// resolves to. The only case that needs a genuinely SEPARATE address is `AliceUnlocked`
// (below): a person can be in two states, locked and unlocked, and one symbol page cannot
// hold two, so the resolved state gets its address, reached only from that person's
// keypad walk, linked from nowhere public.
//
// `CardShell<Who, AccessBlock, PictureAsset>` is the one shell every state of a person's page
// composes: title, the drawn canvas (identity, role, and access-dots, never a second markdown
// table restating what the canvas already shows), and the access section, differing only in
// `AccessBlock` (the guest prompt, or the granted table) and `PictureAsset` (which picture). A
// generated employee has one state, so both name the same choice every time; a named person's
// guest page plugs in the live vault (`PersonHeroAsset`) and its signed-in page plugs in the
// header alone (`UnlockedHeroAsset`) — the walk that reaches that page already is the proof, so
// nothing there asks for the password again. The `Identity`/`Tasks` tabs are a SEPARATE,
// also-shared type (`AliceCardTabs`, …), composed after the shell, so a guest's page and that
// same person's signed-in page are built from the identical pieces everywhere except the two
// blocks that actually differ, not two hand-kept-in-sync bodies.
//
// The picture is embedded IN the body (`Picture`, DocumentKit). `@PageImage` (Metadata,
// written in OrgDemo) only shows a page's picture when it is a TILE in a link grid (the
// Dashboard's Cards list); it shows nothing on the page itself. Both are used: `@PageImage` for
// the grid tile, `Picture` for the page you actually land on.
//
// Tabs (`TabGroup`, `SideBySide`, `PanelOf`) are the same combinators ``ReportsPage``/
// ``BoardPage`` already use: a hand-written `@TabNavigator { @Tab(...) { @Row { @Column {...}
// } } }` is markup no one hand-writes twice; composed through `body` it is ordinary `{ }`.
//
// Identity Selects Body: `SecretPage<Page, Secret>` conforms to `Screen` only `where
// Page.Secret == Secret`, the same conditional-conformance shape `View`/`Administer`/`Delete`
// (System/Policy.swift) already use for access, applied here to which BODY a page shows. A
// caller cannot write `SecretPage<AliceCard, BobPass>` and have it compile.
//
// Every generated employee gets the SAME shell (`CardShell`, below): avatar, an access section,
// an identity table, not a plainer cousin. The one honest difference: their access section
// carries no lock, because there is nothing PERSONAL to unlock; access is entirely role-derived
// (Roles Make It Scale), a public fact true of anyone at that department and rank. The four named
// people additionally OWN a vault each, an individual, provable fact, which is the one thing
// worth a real password walk. Alice and Emp0000 are the same KIND of type (`Employee & Person`,
// checked by `IdentityRows` below accepting either); only `Credentialed` (a password) and
// ownership set the named four apart, and both are real facts, not arbitrary design choices.
// ═══════════════════════════════════════════════════════════════

/// This names the one asset every card embeds (Resources/avatar.svg): its `typeName` IS the bare
/// asset name a `Picture` reads, not a Swift identifier reflected through `String(describing:)`.
enum AvatarAsset: Close {}
extension AvatarAsset {
    public static var typeName: String { "avatar" }
}

/// This names the drawn `PersonHero`'s asset name for a given person: `person-` + that person's
/// site slug (`PageSlug`, DocumentKit/Vector.swift), the same fix `KeypadAsset` already stands
/// on (Keypad.swift), so the picture reference cannot drift from the SVG the emitter actually
/// writes (`swift package generate org`, VectorDemo/PersonHero.swift). The keypad-carrying
/// picture is shown by the person's LOGIN page (`PasscodePage`), where it stands alone.
enum PersonHeroAsset<X>: Close {}
extension PersonHeroAsset {
    public static var typeName: String { "person-" + PageSlug<X>.typeName }
}

/// This names the still header picture: no keypad, the shape a generated employee's picture
/// already is. Both the guest card and the signed-in card wear it now — what differs between
/// those two states is the access section, and the live keypad lives on the login page alone.
enum UnlockedHeroAsset<X>: Close {}
extension UnlockedHeroAsset {
    public static var typeName: String { "person-" + PageSlug<X>.typeName + "-unlocked" }
}

/// A page with a secret to unlock: `Secret` is what a `SecretPage` must be given, literally, to
/// show `Unlocked` instead of the page's (guest) body.
public protocol HasSecret {
    associatedtype Secret
    associatedtype Unlocked: Structure
}

/// This is the gate itself: conforms to `Screen` only when `Secret` really is `Page`'s. Identity
/// Selects Body: the door is which type you name, not a value it computes.
public enum SecretPage<
    Page: HasSecret,
    Secret
>: Screen
where Page.Secret == Secret {
    @StructureBuilder
    public static var body: some Structure {
        Page.Unlocked.self
    }
}

/// The keypad's own pages. A digit press is a fragment jump inside the picture, and a jump
/// scrolls the page that carries it: embedded mid-card, every press scrolled the whole card.
/// On its own page the picture fills the viewport, so a press changes the frame and nothing
/// moves. The card keeps the still header and links here instead.
public enum AliceLogin: Close {}
public enum BobLogin: Close {}
public enum CarolLogin: Close {}
public enum DaveLogin: Close {}
enum EnterPasscodeTitle: Close {}
extension EnterPasscodeTitle {
    static var typeName: String { "Enter the passcode" }
}
enum PasscodeHint: Close {}
extension PasscodeHint {
    static var typeName: String {
        "The person's card prints the passcode. Walk it on the keypad below, digit by digit: the last correct press is a real link to the unlocked card."
    }
}
enum EnterPasscodeText: Close {}
extension EnterPasscodeText {
    static var typeName: String { "Sign in at the keypad" }
}
public enum PasscodePage<
    Who: Employee & Person & Structure,
    Door: Structure
>: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { RawName<Door>.self } }
        EnterPasscodeTitle.self
        Break.self
        Picture { Symbol { Who.self }; PersonHeroAsset<Who>.self }
        Break.self
        PasscodeHint.self
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; Link { RawName<Who>.self; Who.self }
    }
}

/// This is the guest page's one link to `GateMechanism` (Gate.swift): the state graph and the
/// gate's proof, off the main path, for whoever wants the mechanism rather than the walk
/// (DESIGN19 §3).
enum GateExplainerLink: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Link { GateExplainerText.self; GateMechanism.self }
    }
}

/// This gives a person's identity fields, one row each: the card's table, distinct from the
/// roster's (one row per PERSON there, one row per FIELD here). `Who: Employee & Person` reads
/// either a named person or a generated one identically, there is no third shape.
enum IdentityRows<
    Who: Employee & Person
>: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { TableCell { FieldHeader.self }; TableCell { ValueHeader.self } }
        TableRow { TableCell { RuleMark.self }; TableCell { RuleMark.self } }
        TableRow { TableCell { GivenNameLabel.self }; TableCell { Symbol { Who.Given.self } } }
        TableRow { TableCell { FamilyNameLabel.self }; TableCell { Symbol { Who.Family.self } } }
        TableRow { TableCell { GenderHeader.self }; TableCell { Symbol { Who.Sex.self } } }
        TableRow { TableCell { BornHeader.self }; TableCell { Symbol { Who.Born.self } } }
        TableRow { TableCell { RankHeader.self }; TableCell { Symbol { Who.Rank.self } } }
        TableRow { TableCell { DepartmentHeader.self }; TableCell { Symbol { Who.Home.self } } }
        TableRow { TableCell { WorksHeader.self }; TableCell { Symbol { Who.Site.self } } }
    }
}

/// This reads whether `Who` left the company at a year-close, read off the same batches
/// `CyclesPage` names: `labels` (VerificationIsIdentification), the bare handle each `Batch` leaf
/// already carries, no new witness. Empty for anyone not let go (every named person, most
/// generated ones): the leaf then contributes nothing, not even a stray blank line, since its
/// `\n\n` is folded into the non-empty case, not composed separately.
enum TenureNote<
    Who: Employee & Person
>: Close {}
extension TenureNote {
    public static var typeName: String {
        let batches = [(year: "2026", labels: Batch2026.labels), (year: "2027", labels: Batch2027.labels),
                       (year: "2028", labels: Batch2028.labels), (year: "2029", labels: Batch2029.labels)]
        let handle = String(describing: Who.self)
        guard let hit = batches.first(
        where: { $0.labels.contains(handle) }) else { return "" }
        return "Left the company in the \(hit.year) year-close batch.\n\n"
    }
}

/// This is the shell every card composes: title read by the caller, then the drawn canvas, then
/// an "Access" section. Two things can differ between a named person's guest and signed-in page,
/// and only these: which picture (`PictureAsset`, the live vault or the header alone) and which
/// access text (`AccessBlock`, the guest prompt or the granted table). A generated employee has
/// only the one state, so both parameters name the same choice every time.
enum CardShell<
    Who: Employee & Person,
    AccessBlock: Structure,
    PictureAsset: Structure
>: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PersonHeroIntro.self; Break.self
        Picture { Symbol { Who.self }; PictureAsset.self }
        Break.self
        TenureNote<Who>.self
        DoubleHash.self; CardAccessHeading.self; Break.self
        AccessBlock.self
        Break.self
    }
}

enum RoleAccessPrefix: Close {}
extension RoleAccessPrefix {
    public static var typeName: String { "Access follows the role: the audit totals what " }
}
enum RoleAccessMiddle: Close {}
extension RoleAccessMiddle {
    public static var typeName: String { " in " }
}
enum RoleAccessSuffix: Close {}
extension RoleAccessSuffix {
    public static var typeName: String { " reaches." }
}

/// This gives the access section for a generated employee: no personal secret, nothing to
/// unlock, access is entirely role-derived, read off `Who`'s `Rank`/`Home` (`Symbol`, the same
/// reading Identity's table uses), NOT the guest sign-in prompt: there is no keypad walk for a
/// generated employee to sign in with. The named four keep `GuestAccessLine`: their
/// `XGuestAccessBlock`, which this type does not touch.
enum RoleBasedAccessBlock<
    Who: Employee & Person
>: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        RoleAccessPrefix.self; Symbol { Who.Rank.self }; RoleAccessMiddle.self; Symbol { Who.Home.self }; RoleAccessSuffix.self
        Break.self
        ListItem { Page { Nav.Reports.self } }
    }
}

/// This is the generated roster's profile, merged onto each `Emp####` symbol's page (see the
/// header: a deliberate doc-extension, not a second address, since there is only ever one state
/// to show). `RawName<Who>` in the breadcrumb reads the same bare handle the page's title
/// does (`Symbol`), not a human name: the same identifier every other reference to this
/// person already uses.
public enum EmployeeCard<
    Who: Employee & Person
>: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { Who.self } }
        CardShell<
            Who,
            RoleBasedAccessBlock<Who>,
            PersonHeroAsset<Who>
        >.self
        DoubleHash.self; IdentityHeading.self; Break.self
        Table { IdentityRows<Who>.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; RawName<Who>.self
    }
}

// ── Alice ──

enum AliceCardTabs: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        At.self; TabLabel.self; ParenOpen.self; Quote.self; IdentityHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        Table { IdentityRows<Alice>.self }
        CloseBrace.self

        At.self; TabLabel.self; ParenOpen.self; Quote.self; CardTasksHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        ListItem { Symbol { Q3AccessAudit.self } }
        ListItem { Symbol { FinanceReconciliation.self } }
        CloseBrace.self
    }
}
enum AliceGuestAccessBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        GuestAccessLine.self
        Break.self
        Link { EnterPasscodeText.self; AliceLogin.self }
        Break.self
        GateExplainerLink.self
    }
}
enum AliceSignedInAccessBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PathHeldPrefix.self; Alice.self; PathHeldSuffix.self
        Break.self
        SideBySide {
            PanelOf {
                Symbol { FinanceVault.self }
                ViewColonLabel.self; AliceFinanceView.self
                AdministerColonLabel.self; AliceFinanceAdmin.self
                DeleteColonLabel.self; AliceFinanceDelete.self
            }
            PanelOf {
                Symbol { EngineeringRepo.self }
                ViewColonLabel.self; AliceEngineeringView.self
                AdministerColonLabel.self; AliceEngineeringAdmin.self
                DeleteColonLabel.self; AliceEngineeringDelete.self
            }
        }
    }
}
public enum AliceCard: Screen, HasSecret {
    public typealias Secret = AlicePass
    public typealias Unlocked = AliceUnlockedContent
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { Alice.self } }
        CardShell<
            Alice,
            AliceGuestAccessBlock,
            UnlockedHeroAsset<Alice>
        >.self
        TabGroup { AliceCardTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; RawName<Alice>.self
    }
}
public enum AliceUnlockedContent: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { RawName<AliceUnlocked>.self } }
        CardShell<
            Alice,
            AliceSignedInAccessBlock,
            UnlockedHeroAsset<Alice>
        >.self
        TabGroup { AliceCardTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; RawName<Alice>.self
    }
}
public enum AliceUnlocked: Screen {
    @StructureBuilder
    public static var body: some Structure {
        SecretPage<
            AliceCard,
            AlicePass
        >.self
    }
}

// ── Bob ──

enum BobCardTabs: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        At.self; TabLabel.self; ParenOpen.self; Quote.self; IdentityHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        Table { IdentityRows<Bob>.self }
        CloseBrace.self

        At.self; TabLabel.self; ParenOpen.self; Quote.self; CardTasksHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        ListItem { Symbol { ReviewImprovementPlanPolicy.self } }
        CloseBrace.self
    }
}
enum BobGuestAccessBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        GuestAccessLine.self
        Break.self
        Link { EnterPasscodeText.self; BobLogin.self }
        Break.self
        GateExplainerLink.self
    }
}
enum BobSignedInAccessBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PathHeldPrefix.self; Bob.self; PathHeldSuffix.self
        Break.self
        SideBySide {
            PanelOf {
                Symbol { FinanceVault.self }
                ViewColonLabel.self; BobFinanceView.self
                AdministerColonLabel.self; BobFinanceAdmin.self
                DeleteColonLabel.self; BobFinanceDelete.self
            }
            PanelOf {
                Symbol { EngineeringRepo.self }
                ViewColonLabel.self; BobEngineeringView.self
                AdministerColonLabel.self; BobEngineeringAdmin.self
                DeleteColonLabel.self; BobEngineeringDelete.self
            }
        }
    }
}
public enum BobCard: Screen, HasSecret {
    public typealias Secret = BobPass
    public typealias Unlocked = BobUnlockedContent
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { Bob.self } }
        CardShell<
            Bob,
            BobGuestAccessBlock,
            UnlockedHeroAsset<Bob>
        >.self
        TabGroup { BobCardTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; RawName<Bob>.self
    }
}
public enum BobUnlockedContent: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { RawName<BobUnlocked>.self } }
        CardShell<
            Bob,
            BobSignedInAccessBlock,
            UnlockedHeroAsset<Bob>
        >.self
        TabGroup { BobCardTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; RawName<Bob>.self
    }
}
public enum BobUnlocked: Screen {
    @StructureBuilder
    public static var body: some Structure {
        SecretPage<
            BobCard,
            BobPass
        >.self
    }
}

// ── Carol ──

enum CarolCardTabs: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        At.self; TabLabel.self; ParenOpen.self; Quote.self; IdentityHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        Table { IdentityRows<Carol>.self }
        CloseBrace.self

        At.self; TabLabel.self; ParenOpen.self; Quote.self; CardTasksHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        ListItem { Symbol { UpdateOrganizationChart.self } }
        ListItem { Symbol { OnboardNewHire.self } }
        CloseBrace.self
    }
}
enum CarolGuestAccessBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        GuestAccessLine.self
        Break.self
        Link { EnterPasscodeText.self; CarolLogin.self }
        Break.self
        GateExplainerLink.self
    }
}
enum CarolSignedInAccessBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PathHeldPrefix.self; Carol.self; PathHeldSuffix.self
        Break.self
        SideBySide {
            PanelOf {
                Symbol { FinanceVault.self }
                ViewColonLabel.self; CarolFinanceView.self
                AdministerColonLabel.self; CarolFinanceAdmin.self
                DeleteColonLabel.self; CarolFinanceDelete.self
            }
            PanelOf {
                Symbol { EngineeringRepo.self }
                ViewColonLabel.self; CarolEngineeringView.self
                AdministerColonLabel.self; CarolEngineeringAdmin.self
                DeleteColonLabel.self; CarolEngineeringDelete.self
            }
        }
    }
}
public enum CarolCard: Screen, HasSecret {
    public typealias Secret = CarolPass
    public typealias Unlocked = CarolUnlockedContent
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { Carol.self } }
        CardShell<
            Carol,
            CarolGuestAccessBlock,
            UnlockedHeroAsset<Carol>
        >.self
        TabGroup { CarolCardTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; RawName<Carol>.self
    }
}
public enum CarolUnlockedContent: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { RawName<CarolUnlocked>.self } }
        CardShell<
            Carol,
            CarolSignedInAccessBlock,
            UnlockedHeroAsset<Carol>
        >.self
        TabGroup { CarolCardTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; RawName<Carol>.self
    }
}
public enum CarolUnlocked: Screen {
    @StructureBuilder
    public static var body: some Structure {
        SecretPage<
            CarolCard,
            CarolPass
        >.self
    }
}

// ── Dave ──

enum DaveCardTabs: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        At.self; TabLabel.self; ParenOpen.self; Quote.self; IdentityHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        Table { IdentityRows<Dave>.self }
        CloseBrace.self

        At.self; TabLabel.self; ParenOpen.self; Quote.self; CardTasksHeading.self; Quote.self; ParenClose.self; OpenBrace.self
        ListItem { Symbol { RotateVaultKeys.self } }
        ListItem { Symbol { ArchiveOldRepositories.self } }
        CloseBrace.self
    }
}
enum DaveGuestAccessBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        GuestAccessLine.self
        Break.self
        Link { EnterPasscodeText.self; DaveLogin.self }
        Break.self
        GateExplainerLink.self
    }
}
enum DaveSignedInAccessBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PathHeldPrefix.self; Dave.self; PathHeldSuffix.self
        Break.self
        SideBySide {
            PanelOf {
                Symbol { FinanceVault.self }
                ViewColonLabel.self; DaveFinanceView.self
                AdministerColonLabel.self; DaveFinanceAdmin.self
                DeleteColonLabel.self; DaveFinanceDelete.self
            }
            PanelOf {
                Symbol { EngineeringRepo.self }
                ViewColonLabel.self; DaveEngineeringView.self
                AdministerColonLabel.self; DaveEngineeringAdmin.self
                DeleteColonLabel.self; DaveEngineeringDelete.self
            }
        }
    }
}
public enum DaveCard: Screen, HasSecret {
    public typealias Secret = DavePass
    public typealias Unlocked = DaveUnlockedContent
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { Dave.self } }
        CardShell<
            Dave,
            DaveGuestAccessBlock,
            UnlockedHeroAsset<Dave>
        >.self
        TabGroup { DaveCardTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; RawName<Dave>.self
    }
}
public enum DaveUnlockedContent: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { RawName<DaveUnlocked>.self } }
        CardShell<
            Dave,
            DaveSignedInAccessBlock,
            UnlockedHeroAsset<Dave>
        >.self
        TabGroup { DaveCardTabs.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; RawName<Dave>.self
    }
}
public enum DaveUnlocked: Screen {
    @StructureBuilder
    public static var body: some Structure {
        SecretPage<
            DaveCard,
            DavePass
        >.self
    }
}
