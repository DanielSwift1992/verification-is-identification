import Foundation

// One registry owns the logical papers and their physical pages. The source revision
// records the split origin; it is not a claim that later prose still has those bytes.
enum PaperFamilies {
    struct Family {
        let id: String
        let parts: [String]
        let sourceRevision: String?
        var entry: String { id + ".md" }
        var members: [String] { [entry] + parts.map { id + "__" + $0 + ".md" } }
    }

    static let registry: [Family] = [
        Family(id: "permanence_is_resistance", parts: [
            "forced_answers",
            "cost",
            "records_entropy",
            "retention",
            "frame_acquisition",
            "contact_rigidity",
            "support_renewal",
            "reusable_requests",
            "joint_laws",
            "reacquisition_residue",
            "balance_clock",
            "uniform_routing",
            "recovery_remainder",
            "physical_models",
        ], sourceRevision: "fc431eb5c95c3ea689e2e60b3ce00b6e587aa790"),
        Family(id: "verdict_is_invariant", parts: [
            "finite_records",
            "recovery_memory",
            "discovery_acquisition",
            "reusable_images",
            "routing_laws",
            "relative_questions",
            "finite_policies",
            "local_lifts",
            "four_phase_catalogue",
            "action_interfaces",
            "return_costs",
            "calibration_residence",
            "bounded_calibration",
        ], sourceRevision: "fc431eb5c95c3ea689e2e60b3ce00b6e587aa790"),
        Family(id: "interference_is_substitution", parts: [
            "models_calibration",
            "positive_channels",
            "global_obstructions",
            "program_mediator",
            "comparison_fluctuations",
            "support_calibration",
            "acquired_programs",
            "support_memory",
            "repair_continuation",
        ], sourceRevision: "fc431eb5c95c3ea689e2e60b3ce00b6e587aa790"),
        Family(id: "learning_is_liquid", parts: [
            "medium_contacts",
            "coordination_blocks",
            "reconstructed_sides",
            "atoms_continuations",
        ], sourceRevision: "fc431eb5c95c3ea689e2e60b3ce00b6e587aa790"),
    ]

    struct Address: Codable {
        let family: String
        let label: String
        let page: String
        let line: Int
        let anchor: String
        var link: String { "<doc:\(page.dropLast(3))#\(anchor)>" }
    }

    struct Setting {
        let page: String
        let family: String
        let labels: [String]
        let section: String?
        let heading: String?
        let reason: String
    }

    // These are reviewed premises, including the unnumbered optical counterexample.
    // Textual mentions below make no assertion of a proof dependency.
    static let settings: [Setting] = [
        Setting(page: "permanence_is_resistance__support_renewal.md",
                family: "permanence_is_resistance", labels: ["M64n"], section: nil, heading: nil,
                reason: "M64o uses M64n’s four source positions and W,Z."),
        Setting(page: "interference_is_substitution__models_calibration.md",
                family: "interference_is_substitution", labels: [],
                section: "4-Polarization-is-a-pair-of-slots", heading: "## §4. Polarization is a pair of slots",
                reason: "IiS7 uses the preceding optical counterexample in §4."),
        Setting(page: "verdict_is_invariant__action_interfaces.md",
                family: "verdict_is_invariant", labels: ["VC100a", "VC100b", "VC100c", "VC100d", "VC100e"],
                section: "6zzj-Twelve-actual-words-supply-the-complete-four-phase-ambiguity",
                heading: "### §6zzj. Twelve actual words supply the complete four-phase ambiguity",
                reason: "VC100f uses the four-phase catalogue and its full setting."),
        Setting(page: "verdict_is_invariant__return_costs.md",
                family: "verdict_is_invariant", labels: ["VC100m"],
                section: "6zzj-Twelve-actual-words-supply-the-complete-four-phase-ambiguity",
                heading: "### §6zzj. Twelve actual words supply the complete four-phase ambiguity",
                reason: "VC100n uses VC100m’s complete carrier and program setting."),
    ]

    struct Failure: Error, CustomStringConvertible {
        let description: String
    }

    struct Corpus {
        let families: [Family]
        let texts: [String: String]
        let owners: [String: String]
        let addresses: [String: Address]

        func family(of page: String) -> String { owners[page] ?? page }

        func setting(_ item: Setting) throws -> String {
            var links: [String] = []
            for label in item.labels {
                guard let address = addresses[item.family + "/" + label] else {
                    throw Failure(description: "\(item.page): missing required setting \(item.family)/\(label)")
                }
                links.append(address.link)
            }
            if let section = item.section, let heading = item.heading {
                let entry = item.family + ".md"
                guard (texts[entry] ?? "").components(separatedBy: "\n").contains(heading) else {
                    throw Failure(description: "\(entry): missing required section \(heading)")
                }
                links.append("<doc:\(item.family)#\(section)>")
            }
            return "Required setting: " + item.reason + " " + links.joined(separator: ", ") + "."
        }

        // A quote must stand inside an actual block. Joining pages, or even adjacent
        // blocks, could manufacture a quote that no source occurrence contains.
        func blocks(in family: String) -> [String] {
            families.filter { $0.id == family }.flatMap { $0.members }
                .flatMap { markdownBlocks(texts[$0] ?? "") }
        }

        func mentions() -> [String: Set<String>] {
            var out: [String: Set<String>] = [:]
            let pattern = #"(?<![\w])(?:IiS|VC|VI|LQ|M)\d+[a-z]*(?:\.[a-z0-9]+)?(?![\w])"#
            let regex = try! NSRegularExpression(pattern: pattern)
            let byLabel = Dictionary(grouping: addresses.values, by: { $0.label })
            for family in families
            where family.sourceRevision != nil {
                for page in family.members {
                    let text = sourceText(texts[page] ?? "")
                    for match in regex.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
                        let label = (text as NSString).substring(with: match.range)
                        for address in byLabel[label] ?? []
                        where address.page != page {
                            out[page, default: []].insert(address.family + "/" + label)
                        }
                    }
                }
            }
            return out
        }

        func mentionsBlock(page: String, mentions: [String: Set<String>]) -> String {
            let forward = (mentions[page] ?? []).sorted().compactMap { addresses[$0]?.link }
            var reverse: [String] = []
            for source in mentions.keys.sorted() {
                for key in (mentions[source] ?? []).sorted()
                where addresses[key]?.page == page {
                    reverse.append("<doc:\(source.dropLast(3))> (\(addresses[key]!.label))")
                }
            }
            guard !forward.isEmpty || !reverse.isEmpty else { return "" }
            var blocks = ["## Cross-page mentions"]
            if !forward.isEmpty { blocks.append("Labels mentioned here: " + forward.joined(separator: ", ") + ".") }
            if !reverse.isEmpty { blocks.append("Mentions of this page’s labels: " + reverse.joined(separator: ", ") + ".") }
            return blocks.joined(separator: "\n\n") + "\n"
        }
    }

    struct Fence {
        let mark: Character
        let width: Int

        func closes(_ line: String) -> Bool {
            guard let run = fenceRun(line) else { return false }
            return run.mark == mark && run.width >= width
                && run.rest.allSatisfy { $0 == " " || $0 == "\t" }
        }
    }

    static func fenceRun(_ line: String) -> (mark: Character, width: Int, rest: String)? {
        let indent = line.prefix { $0 == " " }.count
        guard indent <= 3 else { return nil }
        let body = line.dropFirst(indent)
        guard let mark = body.first, mark == "`" || mark == "~" else { return nil }
        let width = body.prefix { $0 == mark }.count
        guard width >= 3 else { return nil }
        return (mark, width, String(body.dropFirst(width)))
    }

    static func openingFence(_ line: String) -> Fence? {
        guard let run = fenceRun(line), run.mark != "`" || !run.rest.contains("`") else { return nil }
        return Fence(mark: run.mark, width: run.width)
    }

    static func unfencedLines(_ text: String) -> [(number: Int, text: String)] {
        var out: [(Int, String)] = []
        var fence: Fence?
        for (i, line) in text.components(separatedBy: "\n").enumerated() {
            if let active = fence {
                if active.closes(line) { fence = nil }
            } else if let opening = openingFence(line) {
                fence = opening
            } else { out.append((i + 1, line)) }
        }
        return out
    }

    static func markdownBlocks(_ text: String) -> [String] {
        var blocks: [String] = []
        var current: [String] = []
        var fence: Fence?
        for line in text.components(separatedBy: "\n") {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if let active = fence {
                current.append(line)
                if active.closes(line) {
                    blocks.append(current.joined(separator: "\n"))
                    current = []
                    fence = nil
                }
            } else if let opening = openingFence(line) {
                if !current.isEmpty { blocks.append(current.joined(separator: "\n")) }
                current = [line]
                fence = opening
            } else if trimmed.isEmpty {
                if !current.isEmpty { blocks.append(current.joined(separator: "\n")) }
                current = []
            } else { current.append(line) }
        }
        if !current.isEmpty { blocks.append(current.joined(separator: "\n")) }
        return blocks
    }

    // Remove only the added navigation for the mention scan. Original headings,
    // code and declarations remain source text, just as in the reviewed block ledger.
    static func sourceText(_ text: String) -> String {
        let prefixes = ["This part contains the original derivations for ", "Family and original section headings: ",
                        "Section setting: ", "Required setting: ", "Derivations: ", "Labels mentioned here: ",
                        "Mentions of this page’s labels: ", "## Cross-page mentions", "## Detail: "]
        return text.components(separatedBy: "\n").filter { line in
            prefixes.filter { line.hasPrefix($0) }.isEmpty
        }.joined(separator: "\n")
    }

    static func load(_ directory: String) throws -> Corpus {
        let fm = FileManager.default
        let paths = (fm.enumerator(atPath: directory)?.allObjects as? [String]) ?? []
        let pages = paths.filter { $0.hasSuffix(".md") }.sorted()
        guard !pages.isEmpty else { throw Failure(description: "no paper pages under \(directory)") }
        guard pages.filter({ $0.contains("/") }).isEmpty else {
            throw Failure(description: "paper pages must be flat under \(directory)")
        }
        var owners: [String: String] = [:]
        var ids: Set<String> = []
        for family in registry {
            guard ids.insert(family.id).inserted else {
                throw Failure(description: "duplicate family \(family.id)")
            }
            for page in family.members {
                guard owners[page] == nil else { throw Failure(description: "duplicate member \(page)") }
                guard pages.contains(page) else { throw Failure(description: "missing member \(page)") }
                owners[page] = family.id
            }
        }
        var families = registry
        var texts: [String: String] = [:]
        for page in pages {
            guard let text = try? String(contentsOfFile: directory + "/" + page, encoding: .utf8),
                  !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw Failure(description: "unreadable or empty member \(page)")
            }
            texts[page] = text
            if owners[page] == nil {
                guard !page.contains("__") else { throw Failure(description: "unregistered part \(page)") }
                let id = String(page.dropLast(3))
                families.append(Family(id: id, parts: [], sourceRevision: nil))
                owners[page] = id
            }
        }
        var addresses: [String: Address] = [:]
        let declaration = try! NSRegularExpression(
            pattern: #"^\*\*(?:(?:Claim|Theorem|Lemma|Proposition|Corollary|Law)\s+)?((?:IiS|VC|VI|LQ|M)\d+[a-z]*(?:\.[a-z0-9]+)?)\s*\("#
        )
        for family in registry {
            for page in family.members {
                let lines = texts[page]!.components(separatedBy: "\n")
                if page != family.entry,
                   !lines.contains("Family and original section headings: <doc:\(family.id)>.") {
                    throw Failure(description: "\(page): wrong or missing family address \(family.id)")
                }
                var labelHeadings: [String] = []
                for (number, line) in unfencedLines(texts[page]!) {
                    if line.hasPrefix("### ") { labelHeadings.append(String(line.dropFirst(4))) }
                    guard let match = declaration.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)) else { continue }
                    let label = (line as NSString).substring(with: match.range(at: 1))
                    let key = family.id + "/" + label
                    guard addresses[key] == nil else { throw Failure(description: "\(page):\(number): duplicate label \(key)") }
                    addresses[key] = Address(family: family.id, label: label, page: page, line: number, anchor: label)
                }
                for address in addresses.values
                where address.page == page {
                    guard labelHeadings.filter({ $0 == address.label }).count == 1 else {
                        throw Failure(description: "\(page):\(address.line): label \(family.id)/\(address.label) needs one address heading")
                    }
                }
                for anchor in labelHeadings {
                    if anchor.range(of: #"^(?:IiS|VC|VI|LQ|M)\d+[a-z]*(?:\.[a-z0-9]+)?$"#, options: .regularExpression) != nil,
                       addresses[family.id + "/" + anchor]?.page != page {
                        throw Failure(description: "\(page): orphan label heading \(anchor)")
                    }
                }
            }
        }
        let corpus = Corpus(families: families.sorted { $0.id < $1.id }, texts: texts,
                            owners: owners, addresses: addresses)
        for item in settings {
            let required = try corpus.setting(item)
            guard (texts[item.page] ?? "").components(separatedBy: "\n").contains(required) else {
                throw Failure(description: "\(item.page): missing reviewed \(required)")
            }
        }
        let links = try! NSRegularExpression(pattern: #"<doc:([^>#]+)(?:#([^>]+))?>"#)
        let label = try! NSRegularExpression(pattern: #"^(?:IiS|VC|VI|LQ|M)\d+[a-z]*(?:\.[a-z0-9]+)?$"#)
        for page in pages {
            for (number, line) in unfencedLines(texts[page]!) {
                for match in links.matches(in: line, range: NSRange(line.startIndex..., in: line)) {
                    let target = (line as NSString).substring(with: match.range(at: 1)) + ".md"
                    if target.contains("__"), owners[target] == nil {
                        throw Failure(description: "\(page):\(number): unregistered link \(target)")
                    }
                    guard match.range(at: 2).location != NSNotFound else { continue }
                    let anchor = (line as NSString).substring(with: match.range(at: 2))
                    guard let family = owners[target], ids.contains(family),
                          label.firstMatch(in: anchor, range: NSRange(anchor.startIndex..., in: anchor)) != nil else { continue }
                    guard addresses[family + "/" + anchor]?.page == target else {
                        throw Failure(description: "\(page):\(number): wrong owner for \(family)/\(anchor): \(target)")
                    }
                }
            }
        }
        return corpus
    }

    static func require(_ directory: String) -> Corpus {
        do { return try load(directory) }
        catch {
            print("✗ PAPER FAMILIES: \(error)")
            exit(1)
        }
    }

    static func run(_ args: [String]) {
        let directory = args.first ?? "Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers"
        let corpus = require(directory)
        if args.dropFirst().first == "--addresses" {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let addresses = corpus.addresses.values.sorted { ($0.family, $0.label) < ($1.family, $1.label) }
            print(String(data: try! encoder.encode(addresses), encoding: .utf8)!)
        } else {
            print("✓ PAPER FAMILIES: \(corpus.families.count) papers, \(corpus.texts.count) pages, \(corpus.addresses.count) labelled addresses.")
        }
    }
}
