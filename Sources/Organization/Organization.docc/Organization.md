# ``Organization``

A company modeled in Swift's type system. Its people, its access rules, and its audit are one program, and compiling that program checks every access. This documentation is generated from the same types, so it cannot drift from what the code enforces.

## Start here

Three things to do, in order:

- term **Take the walk:** <doc:SiteWalk> reaches any page in four choices, and any of the 204 people in eight. Every door names what it holds, read off the same types this site is rendered from. Try it: the task board is three choices in.
- term **Unlock a card:** every person's card is public, including the password printed on it, and the keypad beside it is the login. Walk the code digit by digit — the last correct press lands on the card's unlocked half. <doc:CompanyDashboard> lists the four named cards to try.
- term **Change a rule:** edit `System/Policy.swift` and rebuild. Every page re-reads itself, and a rule that contradicts the policy refuses the build with the failed premise named.

The pages are the same for everyone — dashboard, roster, access matrix. The one page that differs is a card's unlocked half, and it is reached by the walk above, never by a session.

## The idea

Most companies describe who can do what in three places, and the three disagree. The policy is a wiki page. The code that enforces it sits somewhere else. The audit that certifies it was correct is a spreadsheet from last quarter. Keeping them in step is manual work, so they drift, and the wiki page is usually the part that is quietly wrong.

Here the three are one. The policy is written as types, so compiling the company is what enforces it: an allowed access compiles, and a forbidden one fails to compile and names the rule it broke. The audit, the access matrix, and this documentation are not copies kept in sync — each is read straight from those types. Change a rule, rebuild, and every page re-reads itself.

## Architecture

At runtime there is nothing to architect, because nothing runs. The whole shape is
one direction: the types are proved by the build, the verdicts are read off the
types, and the pages you are reading are that reading, rendered. Where MVVM or
VIPER would slice a runtime, this slices a proof.

![The package, top down: the V=I lattice, the DocumentKit engine that renders and walks it, the Organization written in both, and the two outputs of every build.](architecture)

![The build, left to right: sources of truth feed the generators, generated Swift meets the gates inside swift build, and the outputs are the site, the drawings, and the audit.](build-flow)

The second picture is the tooling: everything that executes, executes here, once, at
build time. The sources of truth are files in the repository. `swift package generate`
turns them into checked-in Swift, and `swift build` holds the gates — a law violation, a
style violation, or an overdrawn doc-comment budget refuses the build by name — and what
falls out is the site you are reading.

One flow, top down: the core library everything imports, the render engine that reads
it (markdown, SVG, and the guided walks), the demo application written in both, and the
two outputs every build produces. Each box names its role, its parts, and its census, counted
by the build that rendered this page. Click a box to open it.

- term `System/`, the company itself, written in the types of the V=I framework (`VerificationIsIdentification`): the people, the roles, the departments, the documents, the access gates, and the year-close interlock. Nothing here runs and nothing is stored. Compiling this layer is what enforces the policy and proves every access.
- term `Query/`, the questions the compiler answers about that company: is this access granted, who owns this document, do the standing invariants still hold. Each answer is a conformance that either holds or fails to, decided when the code type-checks, not stored anywhere.
- term `View/`, the surface: every page here is itself a type, composed from the same people and verdicts the system proved. It is the one place a type meets its printed form — a name through `Symbol`, a count through `Tally` — and nothing below it depends on it.
- term `DocumentKit`, the render engine, itself pure types: a page's `body` is a composition, and reading its `typeName` walks that composition once into the markdown you are reading. Its grammar is `SurfaceLaw`, one level above the lattice's `Law`.

**The stack.** Three packages' targets, one direction of dependency: `VerificationIsIdentification` holds the law and the lattice — what proves. `DocumentKit` holds the surface — what shows, written in the notation it renders. `Organization` holds the domain — what is proved and shown. `Examples` sits beside it, the same lattice applied to physics. Each floor writes its own grammar in the floor below (`Law`, then `SurfaceLaw`), and nothing points back up.

The library depends on one framework, V=I, and on nothing else — in particular not Foundation. `System/` and `Query/` are made only of its types: protocols, conformances, and `where` clauses, with no stored state and no strings. A type turns into a string or a number only at the View boundary. Two things then read that boundary: this documentation, which `DocumentKit` renders to markdown, and the console audit (`swift run OrgDemo audit`), which prints the same reads without it. A policy that contradicts itself never compiles, so neither output can describe a company that does not exist.

## How it works

The showcase rests on a few small mechanisms. Each one is checked by the compiler, so a green build is the proof that all of them hold.

| Mechanism | What the compiler guarantees |
| --- | --- |
| **Access is a gate** | ``View``, ``Administer``, ``Delete`` earn ``Authorized`` only when their rule holds. A forbidden access does not compile. |
| **Roles make it scale** | Access depends on the role, not the person, so the whole roster resolves from a few certified rules (``RoleLibrary``) — 200 people, four proofs. |
| **The audit re-proves itself** | The standing report (``OwnedFromWithin``, ``LedByManager``) is re-checked on every build, so a fact that stops being true becomes a build error. |
| **An access can name a person** | Only the owner can delete a vault, so "who may delete it?" has one answer. Checking the access names that person (``OwnerGate``). |
| **Policy holds by construction** | The next year (``Closed``, ``CommittedCut``) cannot be formed until the cut is recorded at the size the policy requires. |
| **The numbers are not typed in** | Headcount, proof count, cut size: each is `count` on a type composed through `body`, folded by the compiler as it builds (``Roster``). |
| **A condition costs what it is** | Return-to-office proves the arrangement cheaply — ``OfficeArrangement`` over ``Remote`` will not compile as compliant. The hours logged would be a typed count too. Comparing them against a threshold is the heavier ordered move (Peano `>=`), so the demo shows the cheap half. |

## Where to start

To read the source, take the files in this order — each builds on the last.

| File | What it shows |
| --- | --- |
| `System/Policy.swift` | the gates ``View``, ``Administer``, ``Delete`` and what each requires |
| `System/Team.swift`, `System/GeneratedTeam.swift` | a few named people, then the same scaled to 200 |
| `System/Identification.swift` | access is identification: ``OwnerGate`` has one survivor, ``DepartmentGate`` has many |
| `System/Saturation.swift` | it scales: ``RoleLibrary``, the roster resolves from a few certified rules |
| `Query/Report.swift` | it reports itself: ``OwnedFromWithin``, ``LedByManager``, re-proved every build |
| `Query/Access.swift` | the matrix, read: `granted` asks the compiler one access at a time |
| `View/Card.swift` | each person's card, guest and signed in — one shared shell, two states of one identity |
| `System/ReviewCycle.swift` | the harder policy: ``Closed``, a year cannot close without its cut |
| `System/ReturnToOffice.swift` | the cost gradient: ``OfficeArrangement`` proves the arrangement cheaply, the hour threshold is the heavier ordered move |

Supporting: `System/Witnesses.swift` and the two generated files.

**The company, rendered.** `swift run OrgDemo render-doc` builds the <doc:CompanyDashboard> and the catalogs from the compiled types: the access matrix, the standing report, the figures. These pages are objective — the same company for everyone — read from the types, never written into the page. A personal view is not built in: it is reached by walking a card's own password, and it unlocks that same card. So nothing multiplies per viewer.

## Topics

### The named team's cards

The person's symbol page carries the card. The signed-in page is the same card, one proved walk later.

- ``Alice``
- ``Bob``
- ``Carol``
- ``Dave``
- <doc:AliceUnlocked>
- <doc:BobUnlocked>
- <doc:CarolUnlocked>
- <doc:DaveUnlocked>
- ``Credentialed``
- ``Secret``
- ``HasSecret``
- ``SecretPage``

### The desk

- <doc:CompanyDashboard>

### The catalogs

- <doc:Employees>
- <doc:Departments>
- <doc:Documents>
- <doc:Tasks>
- <doc:Directories>
- <doc:Board>

### The board's what-if walk

One step from each task's own real status, closed after that (DESIGN11 b3).

- <doc:WhatIfOnboardNewHireInProgress>
- <doc:WhatIfArchiveOldRepositoriesInProgress>
- <doc:WhatIfRotateVaultKeysToDo>
- <doc:WhatIfRotateVaultKeysDone>
- <doc:WhatIfReviewImprovementPlanPolicyToDo>
- <doc:WhatIfReviewImprovementPlanPolicyDone>
- <doc:WhatIfFinanceReconciliationToDo>
- <doc:WhatIfFinanceReconciliationDone>
- <doc:WhatIfQ3AccessAuditInProgress>
- <doc:WhatIfUpdateOrganizationChartInProgress>

### The reports

- <doc:Reports>
- <doc:ReturnToOffice>
- <doc:Cycles>

### How it is built

- ``Architecture``
- ``GateMechanism``

### How it is written

Three canvases show their own composition — read back from the compiled type, never a second
copy of it (DESIGN12 §2).

- <doc:PulseSource>
- <doc:BoardSource>
- <doc:CyclesHeroSource>

### The walk pages' own tails

The atoms a walk step spells its Topics section with, so the navigator nests each step under the one before it.

- ``TopicsHeadingBlock``
- ``WalkTopicsHeading``
- ``WalkDoorsGroupHeading``
- ``TopicDoor``
- ``TopicSymbol``

### The policy, enforced

- ``Authorized``
- ``View``
- ``Administer``
- ``Delete``
- ``Granted``
- ``CertifiedAccesses``
- ``CanView``
- ``CanEdit``
- ``CanAdmin``
- ``Department``

### The people, the documents, and the work

- ``Employee``
- ``Doc``
- ``Owned``
- ``Task``
- ``TaskState``

### The standing report, re-proved every build

- ``OwnedFromWithin``
- ``LedByManager``
- ``DepartmentOf``

### When verification is identification

- ``OwnerGate``
- ``DepartmentGate``
- ``RoleLibrary``

### The harder policies

- ``ImprovementPlan``
- ``Closed``
- ``CommittedCut``
- ``OfficeArrangement``
- ``MeetsOfficeMinimum``
- ``ComesToOffice``
- ``Workplace``

### Counted by the compiler

The roster and the proofs are each one type, composed through `body`. Their size is not a
number anyone wrote, but `count` (VerificationIsIdentification), folded as the compiler
type-checks the body. When each leaf must itself be a proof, compiling the body certifies every
element and counts them at once.

- ``Roster``
- ``Team``
- ``AccessLedger``
- ``AllAccesses``
- ``RuleSet``
- ``CertifiedRules``
- ``Report``
- ``StandingReport``

### Counted by this build

The census, spelled into atoms by the CensusGen plugin on every build: the numbers the architecture diagram wears.

- ``CensusLatticeTypes``
- ``CensusLatticeRuntimeFunctions``
- ``CensusLatticeStructs``
- ``CensusLatticeClasses``
- ``CensusEngineTypes``
- ``CensusEngineRuntimeFunctions``
- ``CensusEngineStructs``
- ``CensusEngineClasses``
- ``CensusCompanyTypes``
- ``CensusCompanyRuntimeFunctions``
- ``CensusCompanyStructs``
- ``CensusCompanyClasses``
- ``CensusToolingTypes``
- ``CensusToolingRuntimeFunctions``
- ``CensusToolingStructs``
- ``CensusToolingClasses``

### The walk, step by step

The walk: binary questions over the site's composition, every door a witness of the half it opens. <doc:SiteWalk> is the entry, and the pages below are the steps, as types.

- <doc:SiteWalk>
- <doc:RoleWalk>
- <doc:RosterSpan0000To0203>
- ``SiteWalkPage``
- ``PeopleOrWorkPage``
- ``PolicyOrNumbersPage``
- ``PeopleHalfPage``
- ``WorkHalfPage``
- ``PolicyHalfPage``
- ``NumbersHalfPage``
- ``DepartmentsOrDirectoriesPage``
- ``BoardOrTasksPage``
- ``Halves``
- ``PeopleOrWork``
- ``PeopleHalf``
- ``WorkHalf``
- ``PolicyOrNumbers``
- ``PolicyHalf``
- ``NumbersHalf``
- ``DepartmentsOrDirectories``
- ``BoardOrTasks``
- ``RoleWalk``
- ``MoneyOrBuildSide``
- ``SalesOrPeopleSide``
- ``LeadOrManagerPair``
- ``FinanceRanks``
- ``FinanceLeadOrManager``
- ``EngineeringRanks``
- ``EngineeringLeadOrManager``
- ``SalesRanks``
- ``SalesLeadOrManager``
- ``PeopleRanks``
- ``PeopleLeadOrManager``
- ``NameOf``
- ``NameSpan``
- ``WalkHint``
- ``UpWord``
- ``RoleCellIntro``
- ``StandingHereWord``
- ``ViewColonWord``

### The site order

Every place knows the place above it: the whole order is one type. ``SiteWalk`` is that order made walkable, and its `count` is the coverage read against ``AllPlaces``. The walk itself starts at <doc:SiteWalk>.

- ``Nav``
- ``Place``
- ``SiteOrder``
- ``AllPlaces``
- ``SiteWalk``

### The pages, as types

A page is a type and its markdown is the type's name. The demo writes these into this catalog on every build.

- ``DashboardPage``
- ``EmployeesPage``
- ``DepartmentsPage``
- ``DocumentsPage``
- ``TasksPage``
- ``BoardPage``
- ``DirectoriesPage``
- ``ReportsPage``
- ``CyclesPage``
- ``ReturnToOfficePage``
- ``CutPage``
- ``EmployeeCard``
- ``ViewCapability``
- ``ViewDotColor``
- ``MeetsMinimum``
- ``FullRosterRows``
- ``Screen``
- ``Fragment``
- ``Prose``

### Behind the named cards

Each named person's password walk, unlocked half, and access dots.

- ``AliceCard``
- ``AlicePass``
- ``AliceUnlockedContent``
- ``AliceFinanceDot``
- ``AliceEngineeringDot``
- ``BobCard``
- ``BobPass``
- ``BobUnlockedContent``
- ``BobFinanceDot``
- ``BobEngineeringDot``
- ``CarolCard``
- ``CarolPass``
- ``CarolUnlockedContent``
- ``CarolFinanceDot``
- ``CarolEngineeringDot``
- ``DaveCard``
- ``DavePass``
- ``DaveUnlockedContent``
- ``DaveFinanceDot``
- ``DaveEngineeringDot``
- ``PasscodePage``
- ``AliceLogin``
- ``BobLogin``
- ``CarolLogin``
- ``DaveLogin``
- ``Spelled``
- ``SpelledSecret``
- ``HandleName``

### The company, composed

The roster as one type, the departments, the teams, and the verified memberships the pages read.

- ``Company``
- ``AllDepartments``
- ``Finance``
- ``Engineering``
- ``Sales``
- ``People``
- ``FinanceShare``
- ``EngineeringShare``
- ``SalesShare``
- ``PeopleShare``
- ``FinanceTeam``
- ``EngineeringTeam``
- ``SalesTeam``
- ``PeopleTeam``
- ``FinanceVault``
- ``EngineeringRepo``
- ``AnyoneIn``
- ``SomeoneAs``
- ``FinanceIndividualContributors``
- ``FinanceLeads``
- ``FinanceManagers``
- ``EngineeringIndividualContributors``
- ``EngineeringLeads``
- ``EngineeringManagers``
- ``SalesIndividualContributors``
- ``SalesLeads``
- ``SalesManagers``
- ``PeopleIndividualContributors``
- ``PeopleLeads``
- ``PeopleManagers``
- ``ManagersHere``
- ``Managers2``
- ``Managers3``
- ``NoAdmins``
- ``VerifiedInDepartment``
- ``VerifiedAtRank``
- ``VerifiedAtWorkplace``
- ``VerifiedView``
- ``AccessGate``
- ``Administrators``
- ``ReachesAdmin``

### The ranks and the workplaces

- ``IndividualContributor``
- ``Lead``
- ``Manager``
- ``Role``
- ``RankCycle``
- ``OnSite``
- ``Hybrid``
- ``Remote``
- ``OnSiteTeam``
- ``HybridTeam``
- ``RemoteTeam``
- ``IndividualContributorTeam``
- ``LeadTeam``
- ``ManagerTeam``

### Who people are

The directory vocabulary: the name pools, the years, the genders.

- ``Person``
- ``DepartmentDirectory``
- ``GivenName``
- ``GivenNameCycle``
- ``FamilyName``
- ``FamilyNameCycle``
- ``BirthYear``
- ``BirthYearCycle``
- ``Gender``
- ``Female``
- ``Male``
- ``Nonbinary``
- ``Barbara``
- ``Dennis``
- ``Donald``
- ``Edsger``
- ``Frances``
- ``John``
- ``Karen``
- ``Katherine``
- ``Ken``
- ``Margaret``
- ``Niklaus``
- ``Radia``
- ``Allen``
- ``Dijkstra``
- ``Goldwasser``
- ``Hamilton``
- ``Knuth``
- ``Lamport``
- ``Liskov``
- ``McCarthy``
- ``Perlman``
- ``Ritchie``
- ``Thompson``
- ``Wirth``
- ``Hopper``
- ``Lovelace``
- ``Torvalds``
- ``Turing``
- ``Y1815``
- ``Y1906``
- ``Y1912``
- ``Y1925``
- ``Y1928``
- ``Y1931``
- ``Y1934``
- ``Y1937``
- ``Y1940``
- ``Y1943``
- ``Y1946``
- ``Y1949``
- ``Y1952``
- ``Y1955``
- ``Y1958``
- ``Y1969``

### The cycles, the cuts, and the bar

- ``Chain``
- ``Cycle``
- ``FirstCycle``
- ``Y2027``
- ``Y2028``
- ``Y2029``
- ``Y2030``
- ``Batch``
- ``Batch2026``
- ``Batch2027``
- ``Batch2028``
- ``Batch2029``
- ``Cut2026``
- ``Cut2027``
- ``Cut2028``
- ``Cut2029``
- ``Rated``
- ``MeetsTheBar``
- ``Exceeds``
- ``Meets``
- ``BelowBar``
- ``OnImprovementPlan``
- ``Reviewed``
- ``MeetsBarReview``
- ``BelowBarReview``
- ``Outcome``
- ``Audited``
- ``Cell``
- ``EmptyAudit``
- ``Invariant``

### The tasks on the board

- ``ToDo``
- ``InProgress``
- ``Done``
- ``ToDoDisplayName``
- ``InProgressDisplayName``
- ``DoneDisplayName``
- ``OnboardNewHire``
- ``OnboardNewHireDisplayName``
- ``ArchiveOldRepositories``
- ``ArchiveOldRepositoriesDisplayName``
- ``FinanceReconciliation``
- ``FinanceReconciliationDisplayName``
- ``Q3AccessAudit``
- ``Q3AccessAuditDisplayName``
- ``RotateVaultKeys``
- ``RotateVaultKeysDisplayName``
- ``ReviewImprovementPlanPolicy``
- ``ReviewImprovementPlanPolicyDisplayName``
- ``UpdateOrganizationChart``
- ``UpdateOrganizationChartDisplayName``

### The numbers, spelled as types

- ``One``
- ``Two``
- ``Three``
- ``Four``
- ``Five``
- ``Six``
- ``Seven``
- ``Eight``
- ``Nine``
- ``Ten``
