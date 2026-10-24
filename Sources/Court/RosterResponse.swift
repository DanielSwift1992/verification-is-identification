import Foundation

/// A finite relation: the complete presented nominal roster, its protocol
/// admission graphs, and the source-replayed normal form of every protocol axis.
/// Literal contents are an explicitly unjudged byte transport, not Swift evaluation.
public enum RosterResponse {
    public static let schema = "vi.court.roster/1"
    struct Reduction: Codable {
        let rule: String
        let term: String
        let children: [Reduction]
        init(_ proof: DefinitionReduction.Derivation) {
            switch proof {
            case let .name(n):
                rule = "name"
                term = n
                children = []
            case let .arguments(n, ps):
                rule = "arguments"
                term = n
                children = ps.map(Reduction.init)
            case let .field(p, a):
                rule = "field"
                term = a
                children = [Reduction(p)]
            case let .unfold(e, p):
                rule = "unfold"
                term = e.text
                children = [Reduction(p)]
            case let .join(a, b):
                rule = "join"
                term = ""
                children = [Reduction(a), Reduction(b)]
            }
        }
        func proof() throws -> DefinitionReduction.Derivation {
            typealias R = DefinitionReduction
            switch (rule, children.count) {
            case ("name", 0): return .name(term)
            case ("arguments", _): return .arguments(term, try children.map { try $0.proof() })
            case ("field", 1): return .field(try children[0].proof(), term)
            case ("unfold", 1): return .unfold(try R.parse(term), try children[0].proof())
            case ("join", 2)
            where term.isEmpty: return .join(try children[0].proof(), try children[1].proof())
            default: throw R.Failure("invalid reduction rule/arity")
            }
        }
    }
    struct Goal: Codable, Hashable {
        let relation: String
        let subject: String
        let predicate: String
        static func == (lhs: Self, rhs: Self) -> Bool {
            WhereJudge.sameName(lhs.relation, rhs.relation) && WhereJudge.sameName(lhs.subject, rhs.subject)
                && WhereJudge.sameName(lhs.predicate, rhs.predicate)
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(ScalarName(relation)); hasher.combine(ScalarName(subject)); hasher.combine(ScalarName(predicate))
        }
        init(_ g: ApplicationCourt.Goal) {
            switch g {
            case let .root(e):
                relation = "root"
                subject = e.text
                predicate = ""
            case let .form(e):
                relation = "form"
                subject = e.text
                predicate = ""
            case let .member(e, p):
                relation = "member"
                subject = e.text
                predicate = p
            case let .equal(a, b):
                relation = "equal"
                subject = a.text
                predicate = b.text
            case let .contract(e, p):
                relation = "contract"
                subject = e.text
                predicate = p
            }
        }
        func goal() throws -> ApplicationCourt.Goal {
            let e = try DefinitionReduction.parse(subject)
            switch relation {
            case "root"
            where predicate.isEmpty: return .root(e)
            case "form"
            where predicate.isEmpty: return .form(e)
            case "member": return .member(e, predicate)
            case "contract": return .contract(e, predicate)
            case "equal": return .equal(e, try DefinitionReduction.parse(predicate))
            default: throw DefinitionReduction.Failure("invalid application relation")
            }
        }
    }
    struct Node: Codable {
        let goal: Goal
        let reductions: [Reduction]
        let dependencies: [Goal]
        let prerequisites: [Goal]
    }
    struct Admission: Codable {
        let nodes: [Node]
        init(_ proof: ApplicationCourt.Derivation) {
            nodes = proof.nodes.keys.sorted { $0.text < $1.text }.map { g in
                let n = proof.nodes[g]!
                return Node(goal: Goal(g), reductions: n.reductions.map(Reduction.init),
                    dependencies: n.dependencies.sorted { $0.text < $1.text }.map(Goal.init),
                    prerequisites: n.prerequisites.sorted { $0.text < $1.text }.map(Goal.init))
            }
        }
        func replay(_ root: DefinitionReduction.Expression, source: StructuralSource, predicate: String) throws {
            guard nodes.count <= 20_000 else { throw DefinitionReduction.Failure("application graph limit reached") }
            var graph: [ApplicationCourt.Goal: ApplicationCourt.Node] = [:]
            for n in nodes {
                let g = try n.goal.goal()
                guard graph[g] == nil, Set(n.dependencies).count == n.dependencies.count,
                      Set(n.prerequisites).count == n.prerequisites.count else {
                    throw DefinitionReduction.Failure("duplicate application proof entry")
                }
                graph[g] = ApplicationCourt.Node(reductions: try n.reductions.map { try $0.proof() },
                    dependencies: Set(try n.dependencies.map { try $0.goal() }),
                    prerequisites: Set(try n.prerequisites.map { try $0.goal() }))
            }
            let roots: Set<ApplicationCourt.Goal> = [.member(root, predicate)]
            try ApplicationCourt.verify(roots, derivation: .init(roots: roots, nodes: graph), source: source)
        }
    }
    struct Axis: Codable {
        let normal: String
        let derivation: Reduction
        let literal: StructuralSource.Literal?
    }
    struct Row: Codable {
        let name: String
        let at: StructuralSource.Address
        let admission: Admission
        let axes: NameMap<Axis>
        let literal: StructuralSource.Literal?
    }
    struct Input: Codable, Equatable {
        let path: String
        let sha256: String
        func matches(_ other: Input) -> Bool {
            WhereJudge.sameName(path, other.path) && sha256 == other.sha256
        }
        static func == (lhs: Self, rhs: Self) -> Bool { lhs.matches(rhs) }
    }
    struct Report: Codable {
        let schema: String
        let question: String
        let reader: String
        let inputs: [Input]
        let outcome: String
        let records: [Row]
        let diagnostics: [String]
    }
    struct World {
        let files: [(String, String)]
        let source: StructuralSource
        let predicate: String
        let candidates: [String]
        let axes: [String]
        var inputs: [Input] { files.map { Input(path: $0.0, sha256: courtSHA256(Data($0.1.utf8))) }.sorted { $0.path < $1.path } }
        init(_ files: [(String, String)], predicate: String) throws {
            guard !files.isEmpty, NameSet(files.map { $0.0 }).count == files.count,
                  files.allSatisfy({ !$0.0.isEmpty }) else {
                throw StructuralSource.AddressedFailure("roster:1: source paths must be nonempty and distinct")
            }
            self.files = files
            self.predicate = predicate
            let source = try StructuralSource(files: files, roster: true, arguments: [("--protocol", predicate)])
            self.source = source
            guard let p = source.declarations[predicate], p.kind == "protocol" else {
                throw StructuralSource.AddressedFailure("\(files[0].0):1: no declared protocol '\(predicate)'")
            }
            let closure = source.protocolClosure([predicate])
            for name in closure {
                guard let d = source.declarations[name], d.kind == "protocol" else {
                    throw StructuralSource.AddressedFailure("\(p.origin):1: unavailable protocol '\(name)'")
                }
            }
            for d in source.declarations.values {
                for parent in source.conformanceChoices(d.name).map({ $0.0 }) {
                    guard source.declarations[parent]?.kind == "protocol" else {
                        let at = source.addresses[d.name]
                        throw StructuralSource.AddressedFailure("\(at?.path ?? d.origin):\(at?.line ?? 1): unavailable or aliased protocol '\(parent)' on '\(d.name)'")
                    }
                }
                if d.kind == "typealias", source.extensions[d.name] != nil {
                    let at = source.addresses[d.name]!
                    throw StructuralSource.AddressedFailure("\(at.path):\(at.line): extension through alias '\(d.name)' is outside roster scope")
                }
            }
            var names = NameSet()
            for proto in closure {
                for axis in source.declarations[proto]!.axes {
                    guard names.insert(axis.name).inserted else {
                        throw StructuralSource.AddressedFailure("\(p.origin):1: repeated inherited axis '\(axis.name)' is outside roster scope")
                    }
                }
            }
            axes = names.sorted()
            candidates = source.declarations.values.filter { d in
                d.kind != "protocol" && d.kind != "typealias" && source.protocolClosure(source.conformanceChoices(d.name).map { $0.0 }).contains(predicate)
            }.map(\.name).sorted {
                let a = source.addresses[$0], b = source.addresses[$1]
                return (a?.path ?? "", a?.start ?? 0, $0) < (b?.path ?? "", b?.start ?? 0, $1)
            }
            for name in candidates {
                let d = source.declarations[name]!
                guard d.parameters.isEmpty, d.kind != "external" else {
                    let at = source.addresses[name]
                    throw StructuralSource.AddressedFailure("\(at?.path ?? d.origin):\(at?.line ?? 1): open/external conformer '\(name)' is outside finite roster scope")
                }
            }
        }
        func address(_ name: String) -> StructuralSource.Address {
            source.addresses[name] ?? StructuralSource.Address(path: source.declarations[name]?.origin ?? files[0].0, line: 1, start: 0, end: 0)
        }
        func literal(_ e: DefinitionReduction.Expression) -> StructuralSource.Literal? {
            if case let .application(name, args) = e, args.isEmpty { return source.literals[name] }
            return nil
        }
        func normal(_ e: DefinitionReduction.Expression) throws {
            let raw = DefinitionReduction.Source(world: source.syntax, rigid: [])
            guard try raw.expansion(e) == nil else { throw DefinitionReduction.Failure("claimed normal form still reduces") }
            switch e {
            case let .application(name, args):
                guard let d = source.declarations[name], d.kind != "protocol", d.parameters.count == args.count else {
                    throw DefinitionReduction.Failure("normal form has unavailable nominal '\(name)'")
                }
                for a in args { try normal(a) }
            case .field: throw DefinitionReduction.Failure("unresolved axis '\(e.text)'")
            }
        }
        func row(_ name: String) throws -> Row {
            let d = source.declarations[name]!, root = DefinitionReduction.Expression.application(name, [])
            guard d.parameters.isEmpty, d.kind != "external" else {
                throw DefinitionReduction.Failure("open/external conformer '\(name)' is outside finite roster scope")
            }
            // This graph includes required associated types and declared bounds;
            // an absent field is never a successful empty projection.
            let admission = Admission(try ApplicationCourt.derive([.member(root, predicate)], source: source))
            var fields: NameMap<Axis> = [:]
            let raw = DefinitionReduction.Source(world: source.syntax, rigid: [])
            for a in axes {
                let expression = DefinitionReduction.Expression.field(root, a)
                let proof = try DefinitionReduction.derive(expression, source: raw)
                let end = try DefinitionReduction.replay(proof, source: raw)
                guard end.input == expression else { throw DefinitionReduction.Failure("projection changed its input") }
                try normal(end.output)
                fields[a] = Axis(normal: end.output.text, derivation: Reduction(proof), literal: literal(end.output))
            }
            return Row(name: name, at: address(name), admission: admission, axes: fields, literal: source.literals[name])
        }
        func sameLiteral(_ a: StructuralSource.Literal?, _ b: StructuralSource.Literal?) -> Bool {
            guard let a else { return b == nil }
            guard let b else { return false }
            return a.at.matches(b.at) && WhereJudge.sameName(a.bytes, b.bytes) && a.judged == b.judged
        }
        /// No search for a replacement proof: replay the supplied finite graph
        /// and reductions, and compare coverage with the original read domain.
        func replay(_ report: Report) throws {
            guard report.schema == RosterResponse.schema, WhereJudge.sameName(report.question, predicate),
                report.reader == "vi.roster.flat-declarations/1", report.inputs.count == inputs.count,
                zip(report.inputs, inputs).allSatisfy({ $0.0.matches($0.1) }),
                report.records.count == candidates.count,
                zip(report.records, candidates).allSatisfy({ WhereJudge.sameName($0.0.name, $0.1) }),
                report.outcome == (candidates.isEmpty ? "empty" : "holds"), report.diagnostics.isEmpty else {
                throw DefinitionReduction.Failure("roster certificate changes input, outcome or complete coverage")
            }
            let raw = DefinitionReduction.Source(world: source.syntax, rigid: [])
            for row in report.records {
                let root = DefinitionReduction.Expression.application(row.name, [])
                guard row.at.matches(address(row.name)), NameSet(row.axes.keys) == NameSet(axes), sameLiteral(row.literal, source.literals[row.name]) else {
                    throw DefinitionReduction.Failure("changed address, axis roster or carried bytes at '\(row.name)'")
                }
                try row.admission.replay(root, source: source, predicate: predicate)
                for a in axes {
                    let field = row.axes[a]!
                    let end = try DefinitionReduction.replay(field.derivation.proof(), source: raw)
                    guard end.input == .field(root, a), WhereJudge.sameName(end.output.text, field.normal),
                        sameLiteral(field.literal, literal(end.output)) else { throw DefinitionReduction.Failure("changed axis projection '\(row.name).\(a)'") }
                    try normal(end.output)
                }
            }
        }
    }
    static func diagnostic(_ error: Error, fallback: String) -> String {
        if let addressed = error as? StructuralSource.AddressedFailure { return addressed.description }
        return "\(fallback):1: \(error)"
    }
    static func answer(_ files: [(String, String)], predicate: String) -> Report {
        var inputs = files.map { Input(path: $0.0, sha256: courtSHA256(Data($0.1.utf8))) }.sorted { $0.path < $1.path }
        do {
            let world = try World(files, predicate: predicate)
            inputs = world.inputs
            var rows: [Row] = [], diagnostics: [String] = []
            for name in world.candidates {
                do { rows.append(try world.row(name)) }
                catch {
                    let at = world.address(name)
                    diagnostics.append("\(at.path):\(at.line): \(name): \(error)")
                }
            }
            let outcome = diagnostics.isEmpty ? (rows.isEmpty ? "empty" : "holds") : "not-established"
            let report = Report(schema: schema, question: predicate, reader: "vi.roster.flat-declarations/1", inputs: inputs,
                outcome: outcome, records: rows, diagnostics: diagnostics)
            if diagnostics.isEmpty { try world.replay(report) }
            return report
        } catch {
            return Report(schema: schema, question: predicate, reader: "vi.roster.flat-declarations/1", inputs: inputs,
                outcome: "unsupported", records: [], diagnostics: [diagnostic(error, fallback: files.first?.0 ?? "roster")])
        }
    }
    static func run(_ arguments: [String], replay: Bool = false) {
        do {
            var args = arguments, certificate: String?
            if replay {
                guard !args.isEmpty else { throw StructuralSource.AddressedFailure("roster:1: missing certificate") }
                certificate = args.removeFirst()
            }
            guard let at = args.firstIndex(of: "--protocol"), at + 1 < args.count,
                args.filter({ $0 == "--protocol" }).count == 1 else {
                throw StructuralSource.AddressedFailure("roster:1: usage: judge roster <files.swift...> --protocol <name>")
            }
            let predicate = args.remove(at: at + 1)
            args.remove(at: at)
            guard !args.isEmpty, args.allSatisfy({ !$0.hasPrefix("--") }) else {
                throw StructuralSource.AddressedFailure("roster:1: missing sources or unknown option")
            }
            let files = try args.map { ($0, try WhereJudge.fileText($0)) }
            let report: Report
            if let certificate {
                report = try CourtJSON.decoder().decode(Report.self, from: Data(contentsOf: URL(fileURLWithPath: certificate)))
                try World(files, predicate: predicate).replay(report)
            } else { report = answer(files, predicate: predicate) }
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
            var data = try encoder.encode(report)
            data.append(10)
            FileHandle.standardOutput.write(data)
            exit(report.outcome == "holds" ? 0 : (report.outcome == "not-established" ? 1 : 2))
        } catch {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
            let report = Report(schema: schema, question: "", reader: "vi.roster.flat-declarations/1", inputs: [],
                outcome: "unsupported", records: [], diagnostics: [diagnostic(error, fallback: arguments.first ?? "roster")])
            if let encoded = try? encoder.encode(report) {
                var data = encoded
                data.append(10)
                FileHandle.standardOutput.write(data)
            }
            exit(2)
        }
    }
}
