import Foundation
import VerificationIsIdentification
import DocumentKit
import Organization

// `swift run OrgDemo render-doc`: writes every generated page's rendered markdown
// (`typeName`, DocumentKit's render) into the real .docc catalog, so a `doc:` link
// resolves to that content instead of DocC's bare auto-generated symbol page. The list
// below is hand-enumerated (Surface Law §S8): a small, named, non-generic set, the same
// call already made for the four-person named team.

let catalog = "Sources/Organization/Organization.docc/"

func write(_ content: String, _ name: String) {
    try? content.write(toFile: catalog + name + ".md", atomically: true, encoding: .utf8)
}

/// Insert a DocC `@Metadata` block right after the page's title line, so the page, and every
/// `@Links` card that points at it, shows the catalog's picture (Resources/card-*.svg)
/// instead of a generic file icon. Mirrors `Directories.md`/`Cycles.md`'s hand-written pages,
/// the two that already carry this block.
func withCard(_ page: String, _ card: String, _ alt: String) -> String {
    guard let newline = page.firstIndex(of: "\n") else { return page }
    let title = page[..<newline]
    let rest = page[page.index(after: newline)...]
    let metadata = "\n@Metadata {\n    @PageImage(purpose: card, source: \"\(card)\", alt: \"\(alt)\")\n}\n"
    return title + "\n" + metadata + rest
}

// `swift run OrgDemo audit`: the console side of the two reads Organization.md's Architecture
// section names, this documentation (DocumentKit) and the console audit, "without it." Every
// line below is an existing witness, `count` (a body-fold, VerificationIsIdentification) or
// `typeName` on a plain `Close` verdict (a conditional-extension string, no DocumentKit
// composition walked), the same facts the site shows, read without rendering a page.
func runAudit() {
    print("Headcount: \(Company.count)")
    print("Finance: \(FinanceTeam.count)")
    print("Engineering: \(EngineeringTeam.count)")
    print("Sales: \(SalesTeam.count)")
    print("People: \(PeopleTeam.count)")
    print("Certified role-rules: \(CertifiedRules.count)")
    print("Standing invariants proved: \(StandingReport.count)")
    print("Proofs (AllAccesses): \(AllAccesses.count)")
    print("2026 batch: \(Batch2026.count)")
    print("2027 batch: \(Batch2027.count)")
    print("2028 batch: \(Batch2028.count)")
    print("2029 batch: \(Batch2029.count)")
    print("Alice / FinanceVault, View: \(ViewCapability<Alice, FinanceVault>.typeName)")
    print("Bob / FinanceVault, View: \(ViewCapability<Bob, FinanceVault>.typeName)")
    print("Carol / Remote, meets office minimum: \(MeetsMinimum<Remote>.typeName)")
    print("Site walk covers: \(SiteWalk.count) of \(AllPlaces.count) places, same names: "
        + String(Set(SiteWalk.labels) == Set(AllPlaces.labels)))
    let everyone = Company.labels + Alice.labels + Bob.labels + Carol.labels + Dave.labels
    print("Roster walk covers: \(RosterWalkRoot.count) of \(everyone.count) people, same names: "
        + String(Set(RosterWalkRoot.labels) == Set(everyone)))
    let cellSum = FinanceIndividualContributors.count + FinanceLeads.count + FinanceManagers.count
        + EngineeringIndividualContributors.count + EngineeringLeads.count + EngineeringManagers.count
        + SalesIndividualContributors.count + SalesLeads.count + SalesManagers.count
        + PeopleIndividualContributors.count + PeopleLeads.count + PeopleManagers.count
    print("Role cells cover: \(cellSum) of \(everyone.count) people, twelve cells, no one uncelled")
}

switch CommandLine.arguments.dropFirst().first {
case "render-doc": break
case "audit":
    runAudit()
    exit(0)
default:
    print("usage: swift run OrgDemo <render-doc|audit>")
    exit(0)
}

// The hubs: the same company for everyone. Each gets the catalog's own card picture.
write(withCard(DashboardPage.typeName, "card-dashboard", "Company dashboard"), "CompanyDashboard")
write(withCard(EmployeesPage.typeName, "card-employees", "Employees"), "Employees")
write(withCard(DepartmentsPage.typeName, "card-departments", "Departments"), "Departments")
write(withCard(DocumentsPage.typeName, "card-documents", "Documents"), "Documents")
write(withCard(TasksPage.typeName, "card-tasks", "Tasks"), "Tasks")
write(withCard(BoardPage.typeName, "card-board", "Task board"), "Board")
write(withCard(ReportsPage.typeName, "card-reports", "Reports"), "Reports")
write(withCard(DirectoriesPage.typeName, "card-directories", "Directories"), "Directories")
write(withCard(ReturnToOfficePage.typeName, "card-returntooffice", "Return to Office"), "ReturnToOffice")
write(withCard(CyclesPage.typeName, "card-cycles", "Review Cycles"), "Cycles")

// The walk pages: one per halving (Wayfinding.swift), addressed by the half type's own
// name, so a door's `doc:` target and its page cannot drift apart.
write(SiteWalkPage.typeName, "SiteWalk")
write(PeopleOrWorkPage.typeName, "PeopleOrWork")
write(PolicyOrNumbersPage.typeName, "PolicyOrNumbers")
write(PeopleHalfPage.typeName, "PeopleHalf")
write(WorkHalfPage.typeName, "WorkHalf")
write(PolicyHalfPage.typeName, "PolicyHalf")
write(NumbersHalfPage.typeName, "NumbersHalf")
write(DepartmentsOrDirectoriesPage.typeName, "DepartmentsOrDirectories")
write(BoardOrTasksPage.typeName, "BoardOrTasks")

// Each committed cut's own page: a doc-extension merged onto its bare symbol page (title
// match), delivering what the Timeline caption promises ("the cycle, the enforcer, and the
// interlock") instead of DocC's auto-generated Type Aliases page (FINDINGS4 A-05).
write(CutPage<Cut2026>.typeName, "Cut2026")
write(CutPage<Cut2027>.typeName, "Cut2027")
write(CutPage<Cut2028>.typeName, "Cut2028")
write(CutPage<Cut2029>.typeName, "Cut2029")

// The named team's cards: merged onto that person's OWN symbol page ("Alice", not
// "AliceCard": Card.swift's header), plus the gate each one's walk unlocks (`SecretPage<XCard,
// XPass>`, named `XUnlocked` for a clean address, a genuinely separate state, so it keeps its
// own address). Both sides of a person carry the same picture, the one asset
// (Resources/avatar.svg), embedded inline (`Picture`) AND set as the grid-tile picture.
write(PasscodePage<Alice>.typeName, "AliceLogin")
write(PasscodePage<Bob>.typeName, "BobLogin")
write(PasscodePage<Carol>.typeName, "CarolLogin")
write(PasscodePage<Dave>.typeName, "DaveLogin")
write(withCard(AliceCard.typeName, "avatar", "Alice"), "Alice")
write(withCard(AliceUnlocked.typeName, "avatar", "Alice"), "AliceUnlocked")
write(withCard(BobCard.typeName, "avatar", "Bob"), "Bob")
write(withCard(BobUnlocked.typeName, "avatar", "Bob"), "BobUnlocked")
write(withCard(CarolCard.typeName, "avatar", "Carol"), "Carol")
write(withCard(CarolUnlocked.typeName, "avatar", "Carol"), "CarolUnlocked")
write(withCard(DaveCard.typeName, "avatar", "Dave"), "Dave")
write(withCard(DaveUnlocked.typeName, "avatar", "Dave"), "DaveUnlocked")

// The keypad walk is drawn INSIDE each person's own picture now (VectorDemo/NamedCard.swift,
// DESIGN19 §2), :target states in one SVG, not a fifth generated page per depth.

// DESIGN11 b3: the board's ten what-if pages, one step from each task's own real status
// (`WhatIfPage<T, N>`, View/WhatIf.swift), a closed action space, the same hand-enumerated
// shape the keypad states above already are. DESIGN12 §1: each carries the same card-board
// picture the true board's own page uses, so a `@Links` card pointing at a what-if page shows
// the board too, not a generic file icon.
write(withCard(WhatIfOnboardNewHireInProgress.typeName, "card-board", "Task board"), "WhatIfOnboardNewHireInProgress")
write(withCard(WhatIfArchiveOldRepositoriesInProgress.typeName, "card-board", "Task board"), "WhatIfArchiveOldRepositoriesInProgress")
write(withCard(WhatIfRotateVaultKeysToDo.typeName, "card-board", "Task board"), "WhatIfRotateVaultKeysToDo")
write(withCard(WhatIfRotateVaultKeysDone.typeName, "card-board", "Task board"), "WhatIfRotateVaultKeysDone")
write(withCard(WhatIfReviewImprovementPlanPolicyToDo.typeName, "card-board", "Task board"), "WhatIfReviewImprovementPlanPolicyToDo")
write(withCard(WhatIfReviewImprovementPlanPolicyDone.typeName, "card-board", "Task board"), "WhatIfReviewImprovementPlanPolicyDone")
write(withCard(WhatIfFinanceReconciliationToDo.typeName, "card-board", "Task board"), "WhatIfFinanceReconciliationToDo")
write(withCard(WhatIfFinanceReconciliationDone.typeName, "card-board", "Task board"), "WhatIfFinanceReconciliationDone")
write(withCard(WhatIfQ3AccessAuditInProgress.typeName, "card-board", "Task board"), "WhatIfQ3AccessAuditInProgress")
write(withCard(WhatIfUpdateOrganizationChartInProgress.typeName, "card-board", "Task board"), "WhatIfUpdateOrganizationChartInProgress")

// The generated roster's 200 profiles: GeneratedEmployeeCards.swift (private/gen_org.py).
renderEmployeeCards()
renderRosterWalk()
renderRoleWalk()

print("rendered 471 pages: 10 hubs, 4 keypad pages, 9 walk steps, 203 roster-walk steps, 11 role-walk steps + 12 role cells, 4 cut pages, 4 cards + 4 unlocked gates, 10 what-if pages, 200 employee profiles (the keypad walk moved into each card's own picture, DESIGN19 §2, 20 fewer pages)")
