import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// CAPABILITY CELLS names a gate's verdict, rendered by conditional dispatch, not `decide()`.
//
// A cell is `Close`: nothing to compose, only a derived verdict string. Three `typeName`
// overrides sit at three `where`-specificities on the SAME cell type, and Swift picks the most
// specific one that holds, the same cascade `count`'s `Open where Body == Never` exception
// uses, applied to a verdict instead of a size. This works for `typeName` (an ordinary
// `static var String` witness) but NOT for `Open`'s `Body` (an associated type Swift resolves
// once, not per conditional extension), verified directly, so verdict cells stay `Close`.
//
// A SECOND limit, also checked directly: `Capability<Administer<Alice,FinanceVault>,…>.typeName`
// resolves correctly at a literal call site, but the SAME reference embedded as `TableCell`'s
// generic argument (`TableCell<Capability<…>>`) resolves to the BASE case, wrong, because
// `Field`'s shared `body` extension reads `Content.typeName` generically (`Content: Structure`),
// and Swift picks a conditional-extension witness once for that generic context, not per the
// concrete type it is later instantiated with. Any generic indirection between the literal
// instantiation and the `.typeName` read reproduces this: a plain generic function does too, no
// `Field`/`Paired` involved. The fix: resolve the conditional read at a literal site into a
// NON-GENERIC proxy type first (below), and pass the always-already-resolved proxy into
// `TableCell`. A proxy's `typeName` is a single, unconditional witness, nothing left for
// the generic layer to get wrong.
// ═══════════════════════════════════════════════════════════════

/// This gives a view/administer/delete verdict for one (principal, document) pair: granted, or
/// the reason it is not. `Reason` names what a manager-reachable principal is missing (a
/// department, an ownership) when the gate itself does not hold.
enum Capability<
    Gate,
    Who: Employee,
    Reason: Structure
>: Close {}

extension Capability {
    public static var typeName: String { "manager only" }
}
extension Capability
where ReachesAdmin<Who>: Decidable {
    static var typeName: String { Reason.typeName }
}
// `Gate: Decidable` alone is not, to Swift, a refinement of `ReachesAdmin<Who>: Decidable`:
// they constrain different types, so without the redundant clause the two `where`s are
// unordered and a site where BOTH hold (a real grant) is an ambiguity error, not a resolved
// "most specific wins" (checked directly). Naming both gives Swift the subset it needs; every
// real gate's `Decidable` already implies the rank premise, so nothing new is required.
extension Capability
where ReachesAdmin<Who>: Decidable, Gate: Decidable {
    static var typeName: String { "granted" }
}

/// The reason an administer denial names, for a manager-reachable principal in the wrong
/// department: `Administer` needs `Who.Home == Of.Home`, not just the rank.
enum WrongDepartment: Close {}
extension WrongDepartment {
    public static var typeName: String { "different department" }
}

/// The reason a delete denial names, for a manager-reachable principal who is not the owner:
/// `Delete` needs `Of.Owner == Who`, not just the rank.
enum NotOwner: Close {}
extension NotOwner {
    public static var typeName: String { "owner only" }
}

/// This is a view verdict: `View` has no manager premise, so its only two states are granted or
/// wrong department. `Reason` is always `WrongDepartment`, so the middle `where` in
/// `Capability` does not fire for it (`View` does not gate on `ReachesAdmin`), and the base
/// case already reads correctly for it.
public enum ViewCapability<
    Who: Employee,
    Of: Doc
>: Close {}
extension ViewCapability {
    public static var typeName: String { WrongDepartment.typeName }
}
extension ViewCapability
where View<
    Who,
    Of
>: Decidable {
    public static var typeName: String { "granted" }
}

/// This is the SAME `View<Who, Of>: Decidable` dispatch as ``ViewCapability``, read as a colour
/// instead of a word: `PersonHero`'s access dot (VectorDemo). Zero new logic, one more `typeName`
/// pair on the identical two `where`-specificities, the reading `ViewCapability` already proved
/// correct, not a second gate re-derived to answer the same question.
public enum ViewDotColor<
    Who: Employee,
    Of: Doc
>: Close {}
extension ViewDotColor {
    public static var typeName: String { LineRole.typeName }
}
extension ViewDotColor
where View<
    Who,
    Of
>: Decidable {
    public static var typeName: String { ActionRole.typeName }
}

/// This reads whether an arrangement meets the office minimum: granted/denied dispatch, the same
/// shape as ``ViewCapability``, on ``OfficeArrangement``'s conditional `Decidable` conformance.
public enum MeetsMinimum<
    Site: Workplace
>: Close {}
extension MeetsMinimum {
    public static var typeName: String { "no" }
}
extension MeetsMinimum
where OfficeArrangement<Site>: Decidable {
    public static var typeName: String { "yes" }
}

/// This gives the compression ratio a saturated library gives: accesses certified ÷ certified
/// rules, rendered as digits the way `Tally` renders a single count. Used once (Reports' scale
/// tab), so it is a plain named `Close`, not a generic, no reuse to buy back with one.
enum ProofsSavedRatio: Close {}
extension ProofsSavedRatio {
    public static var typeName: String { String(AllAccesses.count / CertifiedRules.count) }
}

// ── Named-team access proxies — one non-generic type per (principal, vault, gate), the fix for
//    the generic-indirection limit above. Each just resolves the real check at a literal site. ──

enum AliceFinanceView: Close {}
extension AliceFinanceView {
    public static var typeName: String {
        ViewCapability<
            Alice,
            FinanceVault
        >.typeName
    }
}
enum AliceFinanceAdmin: Close {}
extension AliceFinanceAdmin {
    public static var typeName: String {
        Capability<
            Administer<
                Alice,
                FinanceVault
            >,
            Alice,
            WrongDepartment
        >.typeName
    }
}
enum AliceFinanceDelete: Close {}
extension AliceFinanceDelete {
    public static var typeName: String {
        Capability<
            Delete<
                Alice,
                FinanceVault
            >,
            Alice,
            NotOwner
        >.typeName
    }
}

enum AliceEngineeringView: Close {}
extension AliceEngineeringView {
    public static var typeName: String {
        ViewCapability<
            Alice,
            EngineeringRepo
        >.typeName
    }
}
enum AliceEngineeringAdmin: Close {}
extension AliceEngineeringAdmin {
    public static var typeName: String {
        Capability<
            Administer<
                Alice,
                EngineeringRepo
            >,
            Alice,
            WrongDepartment
        >.typeName
    }
}
enum AliceEngineeringDelete: Close {}
extension AliceEngineeringDelete {
    public static var typeName: String {
        Capability<
            Delete<
                Alice,
                EngineeringRepo
            >,
            Alice,
            NotOwner
        >.typeName
    }
}

enum BobFinanceView: Close {}
extension BobFinanceView {
    public static var typeName: String {
        ViewCapability<
            Bob,
            FinanceVault
        >.typeName
    }
}
enum BobFinanceAdmin: Close {}
extension BobFinanceAdmin {
    public static var typeName: String {
        Capability<
            Administer<
                Bob,
                FinanceVault
            >,
            Bob,
            WrongDepartment
        >.typeName
    }
}
enum BobFinanceDelete: Close {}
extension BobFinanceDelete {
    public static var typeName: String {
        Capability<
            Delete<
                Bob,
                FinanceVault
            >,
            Bob,
            NotOwner
        >.typeName
    }
}

enum BobEngineeringView: Close {}
extension BobEngineeringView {
    public static var typeName: String {
        ViewCapability<
            Bob,
            EngineeringRepo
        >.typeName
    }
}
enum BobEngineeringAdmin: Close {}
extension BobEngineeringAdmin {
    public static var typeName: String {
        Capability<
            Administer<
                Bob,
                EngineeringRepo
            >,
            Bob,
            WrongDepartment
        >.typeName
    }
}
enum BobEngineeringDelete: Close {}
extension BobEngineeringDelete {
    public static var typeName: String {
        Capability<
            Delete<
                Bob,
                EngineeringRepo
            >,
            Bob,
            NotOwner
        >.typeName
    }
}

enum CarolFinanceView: Close {}
extension CarolFinanceView {
    public static var typeName: String {
        ViewCapability<
            Carol,
            FinanceVault
        >.typeName
    }
}
enum CarolFinanceAdmin: Close {}
extension CarolFinanceAdmin {
    public static var typeName: String {
        Capability<
            Administer<
                Carol,
                FinanceVault
            >,
            Carol,
            WrongDepartment
        >.typeName
    }
}
enum CarolFinanceDelete: Close {}
extension CarolFinanceDelete {
    public static var typeName: String {
        Capability<
            Delete<
                Carol,
                FinanceVault
            >,
            Carol,
            NotOwner
        >.typeName
    }
}

enum CarolEngineeringView: Close {}
extension CarolEngineeringView {
    public static var typeName: String {
        ViewCapability<
            Carol,
            EngineeringRepo
        >.typeName
    }
}
enum CarolEngineeringAdmin: Close {}
extension CarolEngineeringAdmin {
    public static var typeName: String {
        Capability<
            Administer<
                Carol,
                EngineeringRepo
            >,
            Carol,
            WrongDepartment
        >.typeName
    }
}
enum CarolEngineeringDelete: Close {}
extension CarolEngineeringDelete {
    public static var typeName: String {
        Capability<
            Delete<
                Carol,
                EngineeringRepo
            >,
            Carol,
            NotOwner
        >.typeName
    }
}

enum DaveFinanceView: Close {}
extension DaveFinanceView {
    public static var typeName: String {
        ViewCapability<
            Dave,
            FinanceVault
        >.typeName
    }
}
enum DaveFinanceAdmin: Close {}
extension DaveFinanceAdmin {
    public static var typeName: String {
        Capability<
            Administer<
                Dave,
                FinanceVault
            >,
            Dave,
            WrongDepartment
        >.typeName
    }
}
enum DaveFinanceDelete: Close {}
extension DaveFinanceDelete {
    public static var typeName: String {
        Capability<
            Delete<
                Dave,
                FinanceVault
            >,
            Dave,
            NotOwner
        >.typeName
    }
}

enum DaveEngineeringView: Close {}
extension DaveEngineeringView {
    public static var typeName: String {
        ViewCapability<
            Dave,
            EngineeringRepo
        >.typeName
    }
}
enum DaveEngineeringAdmin: Close {}
extension DaveEngineeringAdmin {
    public static var typeName: String {
        Capability<
            Administer<
                Dave,
                EngineeringRepo
            >,
            Dave,
            WrongDepartment
        >.typeName
    }
}
enum DaveEngineeringDelete: Close {}
extension DaveEngineeringDelete {
    public static var typeName: String {
        Capability<
            Delete<
                Dave,
                EngineeringRepo
            >,
            Dave,
            NotOwner
        >.typeName
    }
}

// ── Named-team access DOT colours — `PersonHero`'s own two dots per card, same fix, same
// four people, `ViewDotColor` instead of `ViewCapability`. ──

public enum AliceFinanceDot: Close {}
extension AliceFinanceDot {
    public static var typeName: String {
        ViewDotColor<
            Alice,
            FinanceVault
        >.typeName
    }
}
public enum AliceEngineeringDot: Close {}
extension AliceEngineeringDot {
    public static var typeName: String {
        ViewDotColor<
            Alice,
            EngineeringRepo
        >.typeName
    }
}
public enum BobFinanceDot: Close {}
extension BobFinanceDot {
    public static var typeName: String {
        ViewDotColor<
            Bob,
            FinanceVault
        >.typeName
    }
}
public enum BobEngineeringDot: Close {}
extension BobEngineeringDot {
    public static var typeName: String {
        ViewDotColor<
            Bob,
            EngineeringRepo
        >.typeName
    }
}
public enum CarolFinanceDot: Close {}
extension CarolFinanceDot {
    public static var typeName: String {
        ViewDotColor<
            Carol,
            FinanceVault
        >.typeName
    }
}
public enum CarolEngineeringDot: Close {}
extension CarolEngineeringDot {
    public static var typeName: String {
        ViewDotColor<
            Carol,
            EngineeringRepo
        >.typeName
    }
}
public enum DaveFinanceDot: Close {}
extension DaveFinanceDot {
    public static var typeName: String {
        ViewDotColor<
            Dave,
            FinanceVault
        >.typeName
    }
}
public enum DaveEngineeringDot: Close {}
extension DaveEngineeringDot {
    public static var typeName: String {
        ViewDotColor<
            Dave,
            EngineeringRepo
        >.typeName
    }
}

// ── Return-to-office proxies — the same fix, for the three arrangements. ──

enum OnSiteMinimum: Close {}
extension OnSiteMinimum {
    public static var typeName: String { MeetsMinimum<OnSite>.typeName }
}
enum HybridMinimum: Close {}
extension HybridMinimum {
    public static var typeName: String { MeetsMinimum<Hybrid>.typeName }
}
enum RemoteMinimum: Close {}
extension RemoteMinimum {
    public static var typeName: String { MeetsMinimum<Remote>.typeName }
}

// ── The office-minimum order, as one ribbon — the threshold is not a property either
// arrangement carries, it is the SPACE between `Remote` and `Hybrid` (`Gap`/`SpaceBetween`,
// DocumentKit — the same mechanism Gallery.swift's `GapExample` demonstrates). Declared here,
// not on the page that first needs it, so any other page reading the same order reads the same
// proxy (§S12/§S17: a non-generic proxy per pairing, resolved once at a literal site).

extension SpaceBetween
where Left == Remote, Right == Hybrid {
    public static var typeName: String { "  ‖ *office minimum* ‖  " }
}
extension SpaceBetween
where Left == Hybrid, Right == OnSite {
    public static var typeName: String { " -> " }
}

enum RemoteToHybridGap: Close {}
extension RemoteToHybridGap {
    public static var typeName: String {
        SpaceBetween<
            Remote,
            Hybrid
        >.typeName
    }
}
enum HybridToOnSiteGap: Close {}
extension HybridToOnSiteGap {
    public static var typeName: String {
        SpaceBetween<
            Hybrid,
            OnSite
        >.typeName
    }
}

/// `Remote ‖ office minimum ‖ Hybrid -> OnSite` names the office-minimum order as one line: the
/// gap name carries the verdict (Remote does not clear it), not a property on either arrangement.
enum OfficeMinimumRibbon: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Symbol { Remote.self }; RemoteToHybridGap.self; Symbol { Hybrid.self }; HybridToOnSiteGap.self; Symbol { OnSite.self }
    }
}

// ── This gives the capability order, as one ribbon: `CanView -> CanEdit -> CanAdmin`, unblocked
// now that `ProtocolReference` (DocumentKit) exists: a bare protocol
// still cannot fill `Gap`'s `Left`/`Right` through `Symbol` (that needs `Structure`), but `Gap`'s
// associated types carry no constraint at all, so `SpaceBetween<CanView, CanEdit>`, the
// pairing itself, compiles the same way `ProtocolReference<any CanView>` does (checked directly).
// Every step here is an expected widening, so every gap is a plain arrow, no threshold to flag.

extension SpaceBetween
where Left == any CanView, Right == any CanEdit {
    public static var typeName: String { " -> " }
}
extension SpaceBetween
where Left == any CanEdit, Right == any CanAdmin {
    public static var typeName: String { " -> " }
}

enum CanViewToCanEditGap: Close {}
extension CanViewToCanEditGap {
    public static var typeName: String {
        SpaceBetween<
            any CanView,
            any CanEdit
        >.typeName
    }
}
enum CanEditToCanAdminGap: Close {}
extension CanEditToCanAdminGap {
    public static var typeName: String {
        SpaceBetween<
            any CanEdit,
            any CanAdmin
        >.typeName
    }
}

/// `CanView -> CanEdit -> CanAdmin` names the capability refinement as one line.
enum CapabilityRefinementRibbon: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        ProtocolReference<any CanView>.self; CanViewToCanEditGap.self; ProtocolReference<any CanEdit>.self; CanEditToCanAdminGap.self; ProtocolReference<any CanAdmin>.self
    }
}


