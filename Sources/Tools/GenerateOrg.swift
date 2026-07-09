import Foundation

// GenerateOrg is a 1:1 Swift port of private/gen_org.py (Law §0″ generation-in-SPM directive,
// DESIGN5 §1). Emits three files for a company of N:
//   Sources/Organization/System/GeneratedTeam.swift:   the types + proofs (pure system)
//   Sources/Organization/View/GeneratedRoster.swift:   the display roster (render)
//   Sources/OrgDemo/GeneratedEmployeeCards.swift:      one render call per generated employee
// The generated roster are FULL people: `Employee, Person`, the same shape as the named
// four. They are simulated (composed from a pool of name atoms by this generator), but the
// system is static: once generated they are real types, no different in kind from Alice or Bob.
enum GenerateOrg {
    static let depts: [(name: String, share: String)] = [
        ("Finance", "FinanceShare"), ("Engineering", "EngineeringShare"),
        ("Sales", "SalesShare"), ("People", "PeopleShare"),
    ]
    // Department steps every hire, unconditionally, before this fix, so a period-4 field on
    // 200 hires gives every department the SAME size, 50/50/50/50, a split no real company has.
    // The `.Next` chain still only ever advances Finance → Engineering → Sales → People → Finance
    // (fixed order, `System/Policy.swift`, this generator decides only WHEN to step, not
    // WHICH department comes next, same discipline as the other fields below); what changes is
    // DWELL TIME per visit: Finance 3 hires, Engineering 5, Sales 4, People 2 (14 per lap,
    // 200 = 14×14 + 4), giving Engineering 71, Sales 56, Finance 45, People 28: an
    // engineering-heavy company with a lean People team, not an arbitrary shape, and still fully
    // deterministic: no randomness, only a variable period instead of a fixed one.
    static let deptLapLength = 14
    static let deptStepOffsets: Set<Int> = [0, 3, 8, 12]   // where, within one lap, dwell ends
    static func deptSteps(_ i: Int) -> Bool { deptStepOffsets.contains(i % deptLapLength) }
    static let ranks = ["IndividualContributor", "Lead", "Manager"]
    // Work arrangements (return-to-office). Cycled on (i // 3) % 3 so the site is decorrelated
    // from rank (i % 3) and department (a period-14 dwell pattern, coprime with 3, so no fixed
    // relationship forms between any two axes): all nine rank/site pairs appear. On-site and
    // hybrid meet the office minimum, remote does not, so ~2/3 of the roster comes in.
    static let sites = ["OnSite", "Hybrid", "Remote"]

    // The pool the roster is composed from, more computing pioneers, distinct from the named
    // four (Lovelace/Turing/Hopper/Torvalds). A given name carries its gender; the person is
    // the handle, so many employees share a name (the name is an atom, the handle is the identity).
    // Each name is its own `SourceFile` atom (DESIGN6 §2.1's typed pool): the roster's pool lives
    // in the notation, read back through `typeName`, the same way `labels` reads a real
    // `Structure`'s leaves, not a bare string array. The choice of WHICH pool member steps to
    // which employee is still the driver's, below: the wall this file's header names.
    enum GivenEdsger: SourceFile {
        static var typeName: String { "Edsger" }
    }
    enum GivenBarbara: SourceFile {
        static var typeName: String { "Barbara" }
    }
    enum GivenJohn: SourceFile {
        static var typeName: String { "John" }
    }
    enum GivenMargaret: SourceFile {
        static var typeName: String { "Margaret" }
    }
    enum GivenDonald: SourceFile {
        static var typeName: String { "Donald" }
    }
    enum GivenFrances: SourceFile {
        static var typeName: String { "Frances" }
    }
    enum GivenKen: SourceFile {
        static var typeName: String { "Ken" }
    }
    enum GivenKatherine: SourceFile {
        static var typeName: String { "Katherine" }
    }
    enum GivenDennis: SourceFile {
        static var typeName: String { "Dennis" }
    }
    enum GivenRadia: SourceFile {
        static var typeName: String { "Radia" }
    }
    enum GivenNiklaus: SourceFile {
        static var typeName: String { "Niklaus" }
    }
    enum GivenKaren: SourceFile {
        static var typeName: String { "Karen" }
    }
    static let given: [(name: SourceFile.Type, sex: String)] = [
        (GivenEdsger.self, "Male"), (GivenBarbara.self, "Female"), (GivenJohn.self, "Male"), (GivenMargaret.self, "Female"),
        (GivenDonald.self, "Male"), (GivenFrances.self, "Female"), (GivenKen.self, "Male"), (GivenKatherine.self, "Female"),
        (GivenDennis.self, "Male"), (GivenRadia.self, "Female"), (GivenNiklaus.self, "Male"), (GivenKaren.self, "Female"),
    ]
    enum FamilyDijkstra: SourceFile {
        static var typeName: String { "Dijkstra" }
    }
    enum FamilyLiskov: SourceFile {
        static var typeName: String { "Liskov" }
    }
    enum FamilyMcCarthy: SourceFile {
        static var typeName: String { "McCarthy" }
    }
    enum FamilyHamilton: SourceFile {
        static var typeName: String { "Hamilton" }
    }
    enum FamilyKnuth: SourceFile {
        static var typeName: String { "Knuth" }
    }
    enum FamilyAllen: SourceFile {
        static var typeName: String { "Allen" }
    }
    enum FamilyThompson: SourceFile {
        static var typeName: String { "Thompson" }
    }
    enum FamilyGoldwasser: SourceFile {
        static var typeName: String { "Goldwasser" }
    }
    enum FamilyRitchie: SourceFile {
        static var typeName: String { "Ritchie" }
    }
    enum FamilyWirth: SourceFile {
        static var typeName: String { "Wirth" }
    }
    enum FamilyPerlman: SourceFile {
        static var typeName: String { "Perlman" }
    }
    enum FamilyLamport: SourceFile {
        static var typeName: String { "Lamport" }
    }
    static let family: [SourceFile.Type] = [
        FamilyDijkstra.self, FamilyLiskov.self, FamilyMcCarthy.self, FamilyHamilton.self, FamilyKnuth.self, FamilyAllen.self,
        FamilyThompson.self, FamilyGoldwasser.self, FamilyRitchie.self, FamilyWirth.self, FamilyPerlman.self, FamilyLamport.self,
    ]
    enum BornY1925: SourceFile {
        static var typeName: String { "1925" }
    }
    enum BornY1928: SourceFile {
        static var typeName: String { "1928" }
    }
    enum BornY1931: SourceFile {
        static var typeName: String { "1931" }
    }
    enum BornY1934: SourceFile {
        static var typeName: String { "1934" }
    }
    enum BornY1937: SourceFile {
        static var typeName: String { "1937" }
    }
    enum BornY1940: SourceFile {
        static var typeName: String { "1940" }
    }
    enum BornY1943: SourceFile {
        static var typeName: String { "1943" }
    }
    enum BornY1946: SourceFile {
        static var typeName: String { "1946" }
    }
    enum BornY1949: SourceFile {
        static var typeName: String { "1949" }
    }
    enum BornY1952: SourceFile {
        static var typeName: String { "1952" }
    }
    enum BornY1955: SourceFile {
        static var typeName: String { "1955" }
    }
    enum BornY1958: SourceFile {
        static var typeName: String { "1958" }
    }
    static let born: [SourceFile.Type] = [
        BornY1925.self, BornY1928.self, BornY1931.self, BornY1934.self, BornY1937.self, BornY1940.self,
        BornY1943.self, BornY1946.self, BornY1949.self, BornY1952.self, BornY1955.self, BornY1958.self,
    ]

    // Law §0″ "Angles open like a tree": a leaf's OWN `<A, B>` (two or more bare arguments) has
    // to open onto its own lines, same as hand-written code (Generated* is code, not exempt).
    // Leaves are always `Name<arg, arg>.tail` here (no nested generics), so a flat two-group
    // match is enough; a single-argument leaf (`Emp0000.self`, no comma) never matches and stays
    // on the packed line untouched.
    private static let leafGeneric = try! NSRegularExpression(pattern: #"^(\w+)<([^<>]+)>(.*)$"#)

    private static func expandLeaf(_ leaf: String, _ indent: String) -> [String]? {
        let ns = leaf as NSString
        guard let m = leafGeneric.firstMatch(in: leaf, range: NSRange(location: 0, length: ns.length)) else { return nil }
        let name = ns.substring(with: m.range(at: 1))
        let argsStr = ns.substring(with: m.range(at: 2))
        let tail = ns.substring(with: m.range(at: 3))
        let args = argsStr.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        if args.count < 2 { return nil }
        var lines = ["\(indent)\(name)<"]
        for a in args.dropLast() { lines.append("\(indent)    \(a),") }
        lines.append("\(indent)    \(args.last!)")
        lines.append("\(indent)>\(tail);")
        return lines
    }

    private static func quoted(_ text: String) -> String { "\"\(text)\"" }

    // A flat body of N statements folds into a Pair chain N deep, and every reader of the
    // type then re-walks that depth: the measured quadratic of the curve (DESIGN21 v28).
    // Past the threshold the leaves nest into slices, so the chain becomes a tree and
    // depth falls to the logarithm. Counts, labels, and rendered text are fold sums over
    // Pair, so the regrouping changes no reading. The numbers live in CodeForm, the form
    // dictionary, and `fanout=F` on the command line overrides them for a sweep.


    // Render calls shard into functions of two hundred behind one hub: a body of N
    // statements is one SIL emission, and the frontend's stack is finite (DESIGN21 v30).
    private static func shardedRenderer(_ name: String, _ calls: [String], footer: String? = nil) -> [String] {
        var out: [String] = []
        var hub = ["func \(name)() {"]
        let perShard = CodeForm.renderCalls
        var index = 0
        var cursor = 0
        while cursor < calls.count {
            let shardName = String(format: "%@Shard%02d", name, index)
            hub.append("    \(shardName)()")
            out += ["func \(shardName)() {"] + calls[cursor..<min(cursor + perShard, calls.count)] + ["}"]
            index += 1
            cursor += perShard
        }
        if let footer { hub.append(footer) }
        hub.append("}")
        return hub + out
    }

    private static func bodyStatements(_ leaves: [String], _ indent: String, _ perLine: Int) -> [String] {
        var out: [String] = []
        var pending: [String] = []
        func flush() {
            if !pending.isEmpty {
                out.append(indent + pending.map { "\($0);" }.joined(separator: " "))
                pending.removeAll()
            }
        }
        for leaf in leaves {
            if let expanded = expandLeaf(leaf, indent) {
                flush()
                out.append(contentsOf: expanded)
            } else {
                pending.append(leaf)
                if pending.count == perLine { flush() }
            }
        }
        flush()
        return out
    }

    private static func enumBlock(_ name: String, _ category: String, _ leaves: [String],
                                  _ perLine: Int, keyword: String, pad: String) -> [String] {
        var out = ["\(pad)\(keyword) enum \(name): \(category) {"]
        var level = leaves
        var tier = 0
        while level.count > CodeForm.sliceThreshold {
            let groups = stride(from: 0, to: level.count, by: CodeForm.sliceFanout).map {
                Array(level[$0..<min($0 + CodeForm.sliceFanout, level.count)])
            }
            var groupNames: [String] = []
            for (index, group) in groups.enumerated() {
                let sliceName = String(format: "Slice%d_%02d", tier, index)
                groupNames.append(sliceName + ".self")
                out += enumBlock(sliceName, category, group, perLine, keyword: "public", pad: pad + "    ")
            }
            level = groupNames
            tier += 1
        }
        out += ["\(pad)    @StructureBuilder", "\(pad)    public static var body: some Structure {"]
        out += bodyStatements(level, pad + "        ", perLine)
        out += ["\(pad)    }", "\(pad)}"]
        return out
    }

    private static func bodyBlock(_ name: String, _ category: String, _ doc: [String], _ leaves: [String], perLine: Int = 6) -> [String] {
        doc.map { "// \($0)" } + enumBlock(name, category, leaves, perLine, keyword: "public", pad: "")
    }

    private static func emp(_ i: Int) -> String { String(format: "Emp%04d", i) }

    // The header's static portion, everything but the one line naming `n`, as ONE `SourceFile`
    // atom, the §S22 discipline (a long fixed skeleton is a literal, never rebuilt from smaller
    // pieces that would only re-fragment something that never varies).
    enum GeneratedTeamHeaderBody: SourceFile {
        static var typeName: String {
            """
            // Pure types and proofs: every access is proved at build, the green build IS the audit.
            // No strings here, the display roster is read off these types in GeneratedRoster.swift.
            // Every field but the first hire's is read off the PREVIOUS hire's field (unchanged or
            // `.Next`), the compiler derives the value, this generator only decides when to step.

            // The pool of name atoms the roster is composed from, directory values like any other,
            // cyclic (`Next`) so the generator reads the next one off the previous hire's, not by index.
            """
        }
    }

    enum GeneratedRosterDocBody: SourceFile {
        static var typeName: String {
            """
            `RosterTableRow(_:)` (View/Employees.swift) is generic: one declaration, reused per
            person, the same relationship `Emp####` has to `Employee, Person`.
            """
        }
    }

    enum GeneratedEmployeeCardsHeader: SourceFile {
        static var typeName: String {
            """
            // GENERATED by `swift package generate org` — one render call per generated employee, merged
            // onto that person's own symbol page (see Card.swift's EmployeeCard, and its header
            // comment on doc-extension vs a second address).
            """
        }
    }

    static func run(_ args: [String]) {
        CodeForm.applyOverrides(args)
        let n = args.first.flatMap { Int($0) } ?? 200

        // ── System: the types and the proofs. No label, no string, pure. ──
        //
        // Each hire's Rank/Home/Given/Family/Born/Site is not looked up by index: it is read off
        // the PREVIOUS hire's field, either unchanged or `.Next` (RankCycle/Department/
        // GivenNameCycle/FamilyNameCycle/BirthYearCycle/Workplace, System/Policy.swift+
        // ReturnToOffice.swift+Directories.swift): the compiler derives the value the way
        // `Coloring.swift`'s `Conflicts<Prev>` derives one task's machine from another's. This
        // generator decides only WHEN a field steps (a period, the same boundary `i % k == 0`
        // always meant), not WHICH name it steps to; that is `.Next`, resolved by the type
        // checker chasing the chain back to Emp0000.
        var o = [
            "import VerificationIsIdentification", "",
            "// GENERATED by `swift package generate org`: a company of \(n), every one a full person.",
        ]
        o += GeneratedTeamHeaderBody.typeName.components(separatedBy: "\n")
        for (j, pair) in given.enumerated() {
            let g = pair.name.typeName
            let nxt = given[(j + 1) % given.count].name.typeName
            o += ["/// This is \(g).", "public enum \(g): GivenNameCycle {",
                  "    public typealias Next = \(nxt)", "    public typealias Sex = \(pair.sex)", "}"]
        }
        for (j, f) in family.enumerated() {
            let name = f.typeName
            let nxt = family[(j + 1) % family.count].typeName
            o += ["/// This is \(name).", "public enum \(name): FamilyNameCycle {", "    public typealias Next = \(nxt)", "}"]
        }
        for (j, y) in born.enumerated() {
            let year = y.typeName
            let nxt = born[(j + 1) % born.count].typeName
            o += ["/// This is \(year).", "public enum Y\(year): BirthYearCycle {", "    public typealias Next = Y\(nxt)", "}"]
        }
        o += [""]
        // Department index per hire: index 0 (Finance) at i=0, advancing by one position (mod
        // `depts.count`) exactly where `deptSteps` says a dwell block ends. Computed once; both
        // the `.Next`-chain decision below and the AccessLedger/Team generation further down
        // read this SAME array, never two formulas left to drift apart.
        var deptIndexOf: [Int] = n > 0 ? [0] : []
        if n > 1 {
            for i in 1..<n {
                deptIndexOf.append(deptSteps(i) ? (deptIndexOf[i - 1] + 1) % depts.count : deptIndexOf[i - 1])
            }
        }
        for i in 0..<n {
            // Every coordinate is emitted DIRECTLY, by the same index formulas the walk's
            // faces already read (one formula per axis, never two to drift apart). The old
            // form derived each hire from the previous one (`Emp5391.Rank.Next`): the same
            // content, but serialized as a dependent-member chain N deep, and past a few
            // thousand people the frontend's deserializer overflowed its stack resolving
            // one person (signal 4, DESIGN21 v40). Direct coordinates are depth one; the
            // rotation the chain performed is the same rotation these indices state.
            let rankExpr = ranks[i % ranks.count]
            let homeExpr = depts[deptIndexOf[i]].name
            let givenExpr = given[i % given.count].name.typeName
            let familyExpr = family[(i / family.count) % family.count].typeName
            let bornExpr = "Y\(born[(i / born.count) % born.count].typeName)"
            let siteExpr = sites[(i / sites.count) % sites.count]
            o += ["public enum \(emp(i)): Employee, Person {",
                  "    public typealias Rank = \(rankExpr)",
                  "    public typealias Home = \(homeExpr)",
                  "    public typealias Given = \(givenExpr)",
                  "    public typealias Family = \(familyExpr)",
                  "    public typealias Born = \(bornExpr)",
                  "    public typealias Site = \(siteExpr)",
                  "    public typealias Sex = Given.Sex",   // the name carries its gender, read off its own Given, not a separate chain
                  "}", ""]
        }

        o += bodyBlock(
            "Company", "Roster",
            ["The whole roster as ONE type: every employee composed through the body.",
             "`Company.count` is the headcount, COUNTED by the type checker as this compiles",
             "(no authored number, read at the boundary)."],
            (0..<n).map { "\(emp($0)).self" })
        o += [""]
        o += bodyBlock(
            "AllAccesses", "AccessLedger",
            ["Every access in the company as ONE type: each member is `VerifiedView`, which forms",
             "only when the principal's department matches the document's (everyone may view their",
             "own department's shared space). It type-checks only when all are proved, and",
             "`AllAccesses.count` is the count, folded out as it compiles. The green build IS the",
             "audit, and its size is read off the type."],
            (0..<n).map { "VerifiedView<\(emp($0)), \(depts[deptIndexOf[$0]].share)>.self" },
            perLine: 3)
        // Verified department rosters: every leaf is `VerifiedInDepartment`, which forms only
        // when `Head.Home == D`. The compiler checks each member is in the department, so the
        // count is read off `count`, never filtered at runtime. The generator writes the
        // members (Law §3), the compiler verifies, the View reads.
        for (dept, _) in depts {
            let members = (0..<n).filter { depts[deptIndexOf[$0]].name == dept }.map { emp($0) }
            o += [""]
            o += bodyBlock(
                "\(dept)Team", "Team",
                ["\(dept)Team: every member verified in \(dept) by the compiler, `count` is the headcount."],
                members.map { "VerifiedInDepartment<\($0), \(dept)>.self" })
        }
        // Verified rank rosters: every leaf is `VerifiedAtRank`, `Head.Rank == R`. Same
        // mechanism, the rank axis.
        for rank in ranks {
            let members = (0..<n).filter { ranks[$0 % 3] == rank }.map { emp($0) }
            o += [""]
            o += bodyBlock(
                "\(rank)Team", "Team",
                ["\(rank)Team: every member verified at rank \(rank) by the compiler, `count` is the count."],
                members.map { "VerifiedAtRank<\($0), \(rank)>.self" })
        }
        // Verified work-arrangement rosters: every leaf is `VerifiedAtWorkplace`, `Head.Site == S`.
        for site in sites {
            let members = (0..<n).filter { sites[($0 / 3) % 3] == site }.map { emp($0) }
            o += [""]
            o += bodyBlock(
                "\(site)Team", "Team",
                ["\(site)Team: every member verified at arrangement \(site) by the compiler, `count` is the count."],
                members.map { "VerifiedAtWorkplace<\($0), \(site)>.self" })
        }
        try? (o.joined(separator: "\n") + "\n").write(toFile: "Sources/Organization/System/GeneratedTeam.swift", atomically: true, encoding: .utf8)

        // ── Render: the full roster's table rows, pure types: one `RosterTableRow { Emp#### }`
        //    per person (View/Employees.swift declares it once, generic, folding `TableRow {
        //    RosterRow { … } }` into a single call). The role table (12 roles) and the named
        //    team (4 people) are fixed-size and live hand-written; only the per-person rows
        //    scale with N, so only those are generated. `perLine=3` keeps each generated line
        //    under ~110 columns, the same density `bodyBlock` already uses for a
        //    similarly-sized leaf (`VerifiedView<…>`, above). ──
        let rows = ["TableRow { RosterHeader.self }", "TableRow { RosterRule.self }"]
            + (0..<n).map { "RosterTableRow { \(emp($0)).self }" }
        var r = ["import VerificationIsIdentification", "import DocumentKit", ""]
        r += bodyBlock(
            "FullRosterRows", "Fragment",
            ["GENERATED by `swift package generate org` — the render side of the company of \(n)."]
                + GeneratedRosterDocBody.typeName.components(separatedBy: "\n"),
            rows, perLine: 3)
        // The curation shelf: every generated employee's symbol, listed once, so the
        try? (r.joined(separator: "\n") + "\n").write(toFile: "Sources/Organization/View/GeneratedRoster.swift", atomically: true, encoding: .utf8)

        // ── The two hundred, curated under the Roster SYMBOL. Only a symbol extension
        //    removes them from the module page's automatic Enumerations flood: curation
        //    in an article (the Employees hub) re-parents the navigator but leaves the
        //    landing's automatic group standing (probed directly, 2026-07-07). ──
        var curation = ["# ``Roster``", "",
                        "The full generated roster and its walk shelves, curated here as a symbol",
                        "extension: the one curation every DocC honors, so the module landing lists",
                        "people and shelves once, under the type that composes them.", "",
                        "## Topics", "", "### The two hundred", ""]
        for i in 0..<n {
            curation.append("- ``\(emp(i))``")
        }
        // The shelves join below, once the walk has named them; one file, one writer.

        // ── OrgDemo: one EmployeeCard<Emp####> render call per generated employee, a
        //    doc-extension merged onto that person's OWN symbol page (Card.swift's header
        //    explains why this is the right call for the 200: one state, ever, so no second
        //    address is worth the cost). Every existing `Symbol { Emp0042.self }` roster link
        //    starts showing this profile for free. ──
        var c = ["import VerificationIsIdentification", "import Organization", ""]
        c += GeneratedEmployeeCardsHeader.typeName.components(separatedBy: "\n")
        // One render call per person makes one function N statements long, and past a few
        // thousand the frontend dies emitting it (signal 4, DESIGN21 v30): the calls shard
        // into functions of two hundred behind one hub, the composition instrument again.
        var cardCalls: [String] = []
        for i in 0..<n {
            cardCalls.append("    write(withCard(EmployeeCard<\(emp(i))>.typeName, \"avatar\", \"\(emp(i))\"), \"\(emp(i))\")")
        }
        c += shardedRenderer("renderEmployeeCards", cardCalls)
        try? (c.joined(separator: "\n") + "\n").write(toFile: "Sources/OrgDemo/GeneratedEmployeeCards.swift", atomically: true, encoding: .utf8)

        // ── The role cells: one cohort per (department, rank) pair, the twelve destinations
        //    a role-walk lands on. Membership is read off the same index math the .Next
        //    chains walk (rank = i % 3, department = the dwell array above); the named four
        //    stand in their own cells, and the audit holds the sum equal to the roster. ──
        var cells = [
            "import VerificationIsIdentification", "",
            "// GENERATED by `swift package generate org`: the twelve (department, rank)",
            "// cohorts a role-walk lands on. Each is a plain composed body; `count` is the",
            "// cohort's size, counted by the type checker as this compiles.", "",
        ]
        let rankPlural = ["IndividualContributor": "IndividualContributors",
                          "Lead": "Leads", "Manager": "Managers"]
        let namedFourCells: [(department: String, rank: String, reference: String)] = [
            ("Finance", "Manager", "Alice"), ("Engineering", "Lead", "Bob"),
            ("Finance", "IndividualContributor", "Carol"), ("Engineering", "Manager", "Dave"),
        ]
        for (departmentIndex, department) in depts.enumerated() {
            for rank in ranks {
                let members = (0..<n).filter {
                    deptIndexOf[$0] == departmentIndex && ranks[$0 % ranks.count] == rank
                }.map { emp($0) } + namedFourCells.filter {
                    $0.department == department.name && $0.rank == rank
                }.map { $0.reference }
                cells += bodyBlock(
                    "\(department.name)\(rankPlural[rank] ?? rank)", "Team",
                    ["Everyone standing in the (\(department.name), \(rank)) pair."],
                    members.map { "\($0).self" })
                cells += [""]
            }
        }
        try? (cells.joined(separator: "\n") + "\n").write(toFile: "Sources/Organization/System/GeneratedRoleCells.swift", atomically: true, encoding: .utf8)

        // ── The role walk: four doors form the (department, rank) pair. Fork faces are
        //    RollCall over tiny Halves compositions of the REAL department and rank types,
        //    so a door cannot misname its half; the last door lands on the cohort's own
        //    symbol page, where the verdicts are read through SomeoneAs — the pair the
        //    walker just formed with their feet. ──
        cells += [
            "// ── The role walk's fork faces: compositions of the real department and rank",
            "//    types, read by RollCall on the walk pages. ──",
            "public enum MoneyOrBuildSide: Halves {",
            "    @StructureBuilder",
            "    public static var body: some Structure {",
            "        Finance.self; Engineering.self",
            "    }",
            "}",
            "public enum SalesOrPeopleSide: Halves {",
            "    @StructureBuilder",
            "    public static var body: some Structure {",
            "        Sales.self; People.self",
            "    }",
            "}",
            "public enum LeadOrManagerPair: Halves {",
            "    @StructureBuilder",
            "    public static var body: some Structure {",
            "        Lead.self; Manager.self",
            "    }",
            "}",
            "/// The role space's root: the walk that forms a (department, rank) pair starts here.",
            "public enum RoleWalk: Halves {",
            "    @StructureBuilder",
            "    public static var body: some Structure {",
            "        MoneyOrBuildSide.self; SalesOrPeopleSide.self",
            "    }",
            "}",
        ]
        for department in depts {
            cells += [
                "public enum \(department.name)Ranks: Halves {",
                "    @StructureBuilder",
                "    public static var body: some Structure {",
                "        IndividualContributor.self; \(department.name)LeadOrManager.self",
                "    }",
                "}",
                "public enum \(department.name)LeadOrManager: Halves {",
                "    @StructureBuilder",
                "    public static var body: some Structure {",
                "        Lead.self; Manager.self",
                "    }",
                "}",
            ]
        }
        try? (cells.joined(separator: "\n") + "\n").write(toFile: "Sources/Organization/System/GeneratedRoleCells.swift", atomically: true, encoding: .utf8)

        var rolePages = [
            "import Foundation", "import VerificationIsIdentification", "import DocumentKit",
            "import Organization", "",
            "// GENERATED by `swift package generate org`: the role walk. Four doors form the",
            "// (department, rank) pair; every step spells its word; the cell pages merge onto",
            "// the cohorts' own symbol pages and read the verdicts through SomeoneAs.", "",
        ]
        var roleWrites = ["func renderRoleWalk() {"]
        func rolePage(_ name: String, _ titleAtom: String, _ title: String, _ word: [String],
                      _ doorLines: [String], _ upTarget: String?, docId: String? = nil) {
            rolePages += [
                "enum \(name)DoorsPictureAlt: Close {}",
                "extension \(name)DoorsPictureAlt {",
                "    static var typeName: String { \(quoted(title)) }",
                "}",
                "enum \(name)DoorsPictureAsset: Close {}",
                "extension \(name)DoorsPictureAsset {",
                "    static var typeName: String { \(quoted("role-doors-" + name.lowercased())) }",
                "}",
                "enum \(name)Title: Close {}",
                "extension \(name)Title {",
                "    static var typeName: String { \(quoted(title)) }",
                "}",
                "enum \(name)Page: Screen {",
                "    @StructureBuilder",
                "    static var body: some Structure {",
                "        PageTitle { \(name)Title.self }",
                "        WalkHint.self; Break.self",
            ]
            if !word.isEmpty {
                rolePages += ["        WordSoFar.self; " + word.joined(separator: ".self; StepDot.self; ") + ".self",
                              "        Break.self"]
            }
            rolePages += [
                "        Picture { \(name)DoorsPictureAlt.self; \(name)DoorsPictureAsset.self }",
                "        Break.self",
            ]
            rolePages += doorLines
            if let upTarget {
                rolePages += ["        ListItem { Link { UpWord.self; \(upTarget).self } }"]
            }
            rolePages += ["        Break.self", "        TopicsHeadingBlock.self"]
            for doorLine in doorLines {
                if let target = doorLine.split(separator: ";").last?
                    .trimmingCharacters(in: .whitespaces)
                    .replacingOccurrences(of: ".self } }", with: "") {
                    rolePages.append("        TopicDoor<\(target)>.self")
                }
            }
            rolePages += ["    }", "}", ""]
            roleWrites.append("    write(\(name)Page.typeName, \(quoted(docId ?? name)))")
        }
        rolePage("RoleWalk", "RoleWalk", "Form a query: which department?", [],
                 ["        ListItem { Link { RollCall<MoneyOrBuildSide>.self; MoneyOrBuildSide.self } }",
                  "        ListItem { Link { RollCall<SalesOrPeopleSide>.self; SalesOrPeopleSide.self } }"],
                 nil, docId: "RoleWalk")
        for (sideName, sideDepartments, letter) in [
            ("MoneyOrBuildSide", ["Finance", "Engineering"], "WentLeft"),
            ("SalesOrPeopleSide", ["Sales", "People"], "WentRight"),
        ] {
            rolePage(sideName, sideName, "\(sideDepartments[0]), or \(sideDepartments[1])?", [letter],
                     sideDepartments.enumerated().map { index, department in
                         "        ListItem { Link { RollCall<\(department)>.self; \(department)Ranks.self } }"
                     },
                     "RoleWalk")
            for (index, department) in sideDepartments.enumerated() {
                let word = [letter, index == 0 ? "WentLeft" : "WentRight"]
                rolePage("\(department)Ranks", "\(department)Ranks",
                         "A rank in \(department): the individual contributors, or the leads and managers?",
                         word,
                         ["        ListItem { Link { RollCall<IndividualContributor>.self; \(department)IndividualContributors.self } }",
                          "        ListItem { Link { RollCall<LeadOrManagerPair>.self; \(department)LeadOrManager.self } }"],
                         sideName)
                rolePage("\(department)LeadOrManager", "\(department)LeadOrManager",
                         "In \(department): a lead, or a manager?",
                         word + ["WentRight"],
                         ["        ListItem { Link { RollCall<Lead>.self; \(department)Leads.self } }",
                          "        ListItem { Link { RollCall<Manager>.self; \(department)Managers.self } }"],
                         "\(department)Ranks")
            }
        }
        // The twelve cell pages: merged onto the cohorts' own symbol pages (title = symbol).
        for (departmentIndex, department) in depts.enumerated() {
            _ = departmentIndex
            for rank in ranks {
                let cohort = "\(department.name)\(rankPlural[rank] ?? rank)"
                rolePages += [
                    "// The verdicts, read at a literal static site: a constrained extension does",
                    "// not enter the witness table, so the fold would read the base case (the",
                    "// same wall the person heroes' dot proxies stand behind).",
                    "enum \(cohort)VaultVerdict: Close {}",
                    "extension \(cohort)VaultVerdict {",
                    "    static var typeName: String { ViewCapability<SomeoneAs<\(department.name), \(rank)>, FinanceVault>.typeName }",
                    "}",
                    "enum \(cohort)RepoVerdict: Close {}",
                    "extension \(cohort)RepoVerdict {",
                    "    static var typeName: String { ViewCapability<SomeoneAs<\(department.name), \(rank)>, EngineeringRepo>.typeName }",
                    "}",
                    "enum \(cohort)CellPage: Screen {",
                    "    @StructureBuilder",
                    "    static var body: some Structure {",
                    "        PageTitle { Symbol { RawName<\(cohort)>.self } }",
                    "        RoleCellIntro.self; Break.self",
                    "        ListItem { StandingHereWord.self; Tally<\(cohort)>.self }",
                    "        ListItem { Symbol { RawName<FinanceVault>.self }; ViewColonWord.self; \(cohort)VaultVerdict.self }",
                    "        ListItem { Symbol { RawName<EngineeringRepo>.self }; ViewColonWord.self; \(cohort)RepoVerdict.self }",
                    "        ListItem { Link { UpWord.self; \(department.name)Ranks.self } }",
                    "        Break.self",
                    "    }",
                    "}", "",
                ]
                roleWrites.append("    write(\(cohort)CellPage.typeName, \(quoted(cohort)))")
            }
        }
        roleWrites.append("}")

        // ── The door strips: one drawn canvas per fork, two cards wearing the RollCall of
        //    the halves they open, targets the same twins the markdown doors use. ──
        var doors = [
            "import VerificationIsIdentification", "import DocumentKit",
            "import Organization", "",
            "// GENERATED by `swift package generate org`: the role walk's drawn doors, one",
            "// strip per fork, faces read off the same types the markdown doors name.", "",
        ]
        var doorWrites = ["func runRoleDoors() {"]
        var doorCount = 0
        func doorStrip(_ name: String, _ alt: String,
                       _ faceA: String, _ toA: String, _ faceB: String, _ toB: String) {
            doors += [
                "enum \(name)DoorsAlt: Close {}",
                "extension \(name)DoorsAlt {",
                "    public static var typeName: String { \(quoted(alt)) }",
                "}",
                "typealias \(name)Doors = WalkDoorsStrip<",
                "    \(name)DoorsAlt,",
                "    RollCall<\(faceA)>, SitePath<\(toA)>,",
                "    RollCall<\(faceB)>, SitePath<\(toB)>",
                ">",
            ]
            doorWrites.append("    write(\(name)Doors.typeName, \(quoted("role-doors-" + name.lowercased())))")
            doorCount += 1
        }
        doorStrip("RoleWalk", "Two doors: Finance and Engineering, or Sales and People.",
                  "MoneyOrBuildSide", "MoneyOrBuildSide", "SalesOrPeopleSide", "SalesOrPeopleSide")
        doorStrip("MoneyOrBuildSide", "Two doors: Finance, or Engineering.",
                  "Finance", "FinanceRanks", "Engineering", "EngineeringRanks")
        doorStrip("SalesOrPeopleSide", "Two doors: Sales, or People.",
                  "Sales", "SalesRanks", "People", "PeopleRanks")
        for department in depts {
            doorStrip("\(department.name)Ranks",
                      "Two doors: the individual contributors, or the leads and managers.",
                      "IndividualContributor", "\(department.name)\(rankPlural["IndividualContributor"] ?? "")",
                      "LeadOrManagerPair", "\(department.name)LeadOrManager")
            doorStrip("\(department.name)LeadOrManager",
                      "Two doors: the leads, or the managers.",
                      "Lead", "\(department.name)Leads",
                      "Manager", "\(department.name)Managers")
        }
        doorWrites.append("    print(\"generated \\(\(doorCount)) role-walk door strips (Vector composition)\")")
        doorWrites.append("}")
        try? ((doors + doorWrites).joined(separator: "\n") + "\n").write(toFile: "Sources/VectorDemo/GeneratedRoleDoors.swift", atomically: true, encoding: .utf8)
        try? ((rolePages + roleWrites).joined(separator: "\n") + "\n").write(toFile: "Sources/OrgDemo/GeneratedRoleWalkPages.swift", atomically: true, encoding: .utf8)


        // ── Wayfinding: the roster as a walkable halving (DocumentKit Walk). Two files: the tree
        //    (System — nodes are plain composed bodies, the fork is Pair itself) and the walk
        //    pages (OrgDemo — one page per halving, doors read by witnesses of the very half
        //    they open). The split is the midpoint, so a walk is at most ⌈log₂ n⌉ choices. ──
        func spanName(_ lo: Int, _ hi: Int) -> String {
            "RosterSpan" + String(format: "%04d", lo) + "To" + String(format: "%04d", hi)
        }
        // The shelf order: phone-book, family then given then handle. Given steps every hire,
        // family every `family.count` hires (the same periods the `.Next` chains above walk),
        // so both names fall out of the index the way the types themselves derive them.
        func givenName(_ i: Int) -> String { given[i % given.count].name.typeName }
        func familyName(_ i: Int) -> String { family[(i / family.count) % family.count].typeName }
        // The named four stand on the same shelf as everyone else: a phone book that cannot
        // find Alice is not a phone book. Their names are restated here (this generator
        // cannot import the hand types it stands beside); the coverage audit holds the two
        // spellings together — a drifted name reads as a missing person, in both directions.
        let namedFour: [(family: String, given: String, reference: String)] = [
            ("Lovelace", "Alice", "Alice"), ("Turing", "Bob", "Bob"),
            ("Hopper", "Carol", "Carol"), ("Torvalds", "Dave", "Dave"),
        ]
        let shelf = ((0..<n).map { (family: familyName($0), given: givenName($0), reference: emp($0)) } + namedFour)
            .sorted { ($0.family, $0.given, $0.reference) < ($1.family, $1.given, $1.reference) }
        var tree = [
            "import VerificationIsIdentification", "import DocumentKit", "",
            "// GENERATED by `swift package generate org`: the roster as a walkable halving, in",
            "// phone-book order (family, given, handle). Each node is a plain composed body —",
            "// the fork is `Pair` itself (DocumentKit Walk) — and the walk pages read these types, so a",
            "// door cannot say what its half does not hold. Span indices are positions on the",
            "// alphabetical shelf; the midpoint split keeps every walk within ⌈log₂ \(n)⌉ choices.",
            "",
        ]
        var walkPages = [
            "import Foundation", "import VerificationIsIdentification", "import DocumentKit",
            "import Organization", "",
            "// GENERATED by `swift package generate org`: one page per roster halving. A door",
            "// to a shelf wears `NameSpan` (its first and last person, phone-book order); a",
            "// door to a person wears `NameOf`; every step page spells the word walked so far.",
            "// All faces are witnesses, read off the types, never authored.", "",
        ]
        var walkWriteLines: [String] = []
        var shelfNames: [String] = []
        func descend(_ lo: Int, _ hi: Int, _ parent: String, _ word: [String]) -> String {
            if lo == hi { return shelf[lo].reference }
            let name = spanName(lo, hi)
            shelfNames.append(name)
            let half = (hi - lo + 1) / 2
            let leftReference = descend(lo, lo + half - 1, name, word + ["WentLeft"])
            let rightReference = descend(lo + half, hi, name, word + ["WentRight"])
            tree += [
                "public enum \(name): Halves {",
                "    @StructureBuilder",
                "    public static var body: some Structure {",
                "        \(leftReference).self",
                "        \(rightReference).self",
                "    }",
                "}",
            ]
            func face(_ reference: String, _ fromPosition: Int, _ toPosition: Int) -> String {
                reference.hasPrefix("RosterSpan")
                    ? "NameSpan<\(shelf[fromPosition].reference), \(shelf[toPosition].reference)>.self"
                    : "NameOf<\(reference)>.self"
            }
            let wordLine = word.isEmpty
                ? []
                : ["        WordSoFar.self; " + word.joined(separator: ".self; StepDot.self; ") + ".self", "        Break.self"]
            // Only shelf children enter the Topics tail: a person is curated once, by the
            // Employees hub, and a second curation here returns the whole roster to DocC's
            // automatic Enumerations wall (found by the persona pass, 2026-07-07).
            let shelfDoors = [leftReference, rightReference]
                .filter { $0.hasPrefix("RosterSpan") }
                .map { "        TopicDoor<\($0)>.self" }
            let topicsTail = shelfDoors.isEmpty ? [] : ["        TopicsHeadingBlock.self"] + shelfDoors
            var pageLines: [String] = [
                "public enum \(name)Page: Screen {",
                "    @StructureBuilder",
                "    public static var body: some Structure {",
                "        PageTitle { NameSpan<\(shelf[lo].reference), \(shelf[hi].reference)>.self }",
                "        WalkHint.self; Break.self",
            ]
            pageLines += wordLine
            pageLines += [
                "        ListItem { Link { \(face(leftReference, lo, lo + half - 1)); \(leftReference).self } }",
                "        ListItem { Link { \(face(rightReference, lo + half, hi)); \(rightReference).self } }",
                "        ListItem { Link { UpWord.self; \(parent).self } }",
                "        Break.self",
            ]
            pageLines += topicsTail
            walkPages += pageLines
            walkPages += [
                "    }",
                "}",
            ]
            walkWriteLines.append("    write(\(name)Page.typeName, \"\(name)\")")
            return name
        }
        let walkRootName = descend(0, shelf.count - 1, "PeopleHalf", [])
        tree += ["",
                 "/// The phone book's root shelf under one stable name: the hand-written pages, the",
                 "/// diagram, and the audit reach the walk through this alias, so the universe can",
                 "/// change size without touching them.",
                 "public typealias RosterWalkRoot = \(walkRootName)"]
        curation += ["", "### The walk root", "", "- ``RosterWalkRoot``"]
        curation += ["", "### The shelves of the phone book", ""]
        for shelfName in shelfNames.sorted() {
            curation.append("- ``\(shelfName)``")
        }
        try? (curation.joined(separator: "\n") + "\n").write(toFile: "Sources/Organization/Organization.docc/Roster.md", atomically: true, encoding: .utf8)
        // One giant generated file is one frontend job: it cannot spread across cores, and
        // every declaration pays name lookup against the whole module. Sharding by ~120
        // top-level declarations lets the type checker work the shards in parallel — the
        // composition instrument of the curve (DESIGN21 v29), byte-identical in every reading.
        func writeShards(_ lines: [String], header: [String], directory: String, base: String) {
            for stale in (try? FileManager.default.contentsOfDirectory(atPath: directory)) ?? []
            where stale.hasPrefix(base) && stale.hasSuffix(".swift") {
                try? FileManager.default.removeItem(atPath: directory + "/" + stale)
            }
            var blocks: [[String]] = []
            var current: [String] = []
            var docBuffer: [String] = []
            for line in lines {
                if line.hasPrefix("/// ") || line == "///" {
                    docBuffer.append(line)
                } else if opensDeclaration(line) {
                    if !current.isEmpty { blocks.append(current) }
                    current = docBuffer + [line]
                    docBuffer = []
                } else {
                    current += docBuffer + [line]
                    docBuffer = []
                }
            }
            current += docBuffer
            if !current.isEmpty { blocks.append(current) }
            let perShard = CodeForm.fileDeclarations
            precondition(perShard <= CodeForm.fileDeclarationLimit,
                         "form gate: \(perShard) declarations per file exceeds the stated limit \(CodeForm.fileDeclarationLimit)")
            var shardIndex = 0
            var cursor = 0
            while cursor < blocks.count {
                let slice = blocks[cursor..<min(cursor + perShard, blocks.count)]
                let name = String(format: "%@_%02d.swift", base, shardIndex)
                let text = (header + slice.flatMap { [""] + $0 }).joined(separator: "\n") + "\n"
                try? text.write(toFile: directory + "/" + name, atomically: true, encoding: .utf8)
                shardIndex += 1
                cursor += perShard
            }
        }
        func opensDeclaration(_ line: String) -> Bool {
            line.hasPrefix("public enum ") || line.hasPrefix("enum ")
                || line.hasPrefix("public typealias ") || line.hasPrefix("typealias ")
        }
        let treePrefixCount = tree.prefix(while: { !opensDeclaration($0) }).count
        let treeHeader = Array(tree.prefix(treePrefixCount)).filter { !$0.hasPrefix("///") }
        let treeBody = Array(tree.dropFirst(treePrefixCount))
        writeShards(treeBody, header: treeHeader, directory: "Sources/Organization/System", base: "GeneratedRosterWalk")
        let pagesHeader = Array(walkPages.prefix(while: { !opensDeclaration($0) }))
            .filter { $0 != "import Foundation" }
        let pagesBody = Array(walkPages.dropFirst(walkPages.prefix(while: { !opensDeclaration($0) }).count))
        writeShards(pagesBody, header: pagesHeader, directory: "Sources/OrgWalkPages", base: "GeneratedWalkPages")
        var renderHub = ["import Foundation", "import VerificationIsIdentification",
                         "import OrgWalkPages", "",
                         "// GENERATED by `swift package generate org`: the render hands for the walk",
                         "// pages — the page types live in OrgWalkPages, their own module, and only",
                         "// the write calls stay beside the catalog they fill.", ""] + [
            "func renderRosterWalk() {",
            "    // Sweep first: shelf positions shift when the roster changes, and filenames",
            "    // follow, so a stale span page would keep a door into yesterday's split.",
            "    for stale in (try? FileManager.default.contentsOfDirectory(atPath: catalog)) ?? []",
            "    where stale.hasPrefix(\"RosterSpan\") {",
            "        try? FileManager.default.removeItem(atPath: catalog + stale)",
            "    }",
        ]
        let writesPerShard = CodeForm.renderCalls
        var shardCalls: [String] = []
        var writeCursor = 0
        var writeShard = 0
        var shardFuncs: [String] = []
        while writeCursor < walkWriteLines.count {
            let slice = walkWriteLines[writeCursor..<min(writeCursor + writesPerShard, walkWriteLines.count)]
            let funcName = String(format: "renderRosterWalkShard%02d", writeShard)
            shardCalls.append("    \(funcName)()")
            shardFuncs += ["func \(funcName)() {"] + slice + ["}"]
            writeShard += 1
            writeCursor += writesPerShard
        }
        renderHub += shardCalls + ["}"] + shardFuncs
        try? (renderHub.joined(separator: "\n") + "\n").write(toFile: "Sources/OrgDemo/GeneratedWalkPagesRender.swift", atomically: true, encoding: .utf8)

        // ── VectorDemo: one `PersonHero` render call per generated employee (DESIGN14 §3).
        //    `ViewDotColor<Who, Of>`'s conditional dispatch, read through PersonHero's own
        //    generic body, hits the SAME generic-indirection limit Cells.swift's header names
        //    for `ViewCapability`, so each employee needs its own literal-site-resolved dot
        //    proxy, generated here exactly the way `VerifiedInDepartment<...>` above is: the
        //    generator writes the members, the compiler proves each one.
        //
        //    The accent slot's other branch, a departed employee's "Left in YYYY" chip,
        //    reads `System/ReviewCycle.swift`'s four batches (Organization), which Tools cannot
        //    import; the 40 handles are restated here, literally, matching those batches exactly
        //    (SurfaceLaw §S23's edge: two lists kept in step by hand, not by a mechanism,
        //    the same trade this file's header already accepts for the shared design tokens).
        let departureYear: [String: String] = {
            var d: [String: String] = [:]
            for h in ["Emp0002"] + (100...108).map({ String(format: "Emp%04d", $0) }) { d[h] = "2026" }
            for h in ["Emp0004"] + (110...118).map({ String(format: "Emp%04d", $0) }) { d[h] = "2027" }
            for h in ["Emp0006"] + (120...128).map({ String(format: "Emp%04d", $0) }) { d[h] = "2028" }
            for h in ["Emp0008"] + (130...138).map({ String(format: "Emp%04d", $0) }) { d[h] = "2029" }
            return d
        }()
        var p = ["import VerificationIsIdentification", "import DocumentKit", "import Organization", ""]
        p += [
            "// GENERATED by `swift package generate org` — one `PersonHero` render call per generated",
            "// employee (DESIGN14 §3): the two access-dot proxies (the fix for the generic-indirection",
            "// limit Cells.swift's own header names) plus the write call itself, choosing the accent",
            "// block a departed employee's own batch names, or `NoAccentBlock` for anyone still here.",
            "// Proxies are declared at file scope: `extension` is not legal inside a function body.",
            "",
        ]
        for i in 0..<n {
            let name = emp(i)
            p.append("enum \(name)FinanceDot: Close {}")
            p.append("extension \(name)FinanceDot {")
            p.append("    static var typeName: String {")
            p.append("        ViewDotColor<")
            p.append("            \(name),")
            p.append("            FinanceVault")
            p.append("        >.typeName")
            p.append("    }")
            p.append("}")
            p.append("enum \(name)EngineeringDot: Close {}")
            p.append("extension \(name)EngineeringDot {")
            p.append("    static var typeName: String {")
            p.append("        ViewDotColor<")
            p.append("            \(name),")
            p.append("            EngineeringRepo")
            p.append("        >.typeName")
            p.append("    }")
            p.append("}")
        }
        p.append("")
        var heroCalls: [String] = []
        for i in 0..<n {
            let name = emp(i)
            let accent = departureYear[name].map { "LeftIn\($0)Chip" } ?? "NoAccentBlock"
            heroCalls.append("""
    write(PersonHero<
        \(name),
        \(name)FinanceDot,
        \(name)EngineeringDot,
        \(accent)
    >.typeName, "person-\(name.lowercased())")
""")
        }
        p += shardedRenderer("renderPersonHeroes", heroCalls,
                             footer: "    print(\"generated \(n) person heroes (Vector composition, \(departureYear.count) departed)\")")
        try? (p.joined(separator: "\n") + "\n").write(toFile: "Sources/VectorDemo/GeneratedPersonHeroes.swift", atomically: true, encoding: .utf8)

        print("generated \(n) full people + \(n) proofs (system) + \(n) roster rows (render) + "
            + "\(given.count)+\(family.count)+\(born.count) name atoms + \(n) person heroes")
    }
}
