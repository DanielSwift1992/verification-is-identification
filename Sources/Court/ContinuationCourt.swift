import Foundation

/// System U5/U6 on a closed source type-field grammar. The reader, constructor,
/// and replay work on current declarations, never on payload observations.
/// This does not certify Swift method bodies or equality of runtime payloads.
enum ContinuationCourt {
    typealias R = DefinitionReduction
    typealias E = R.Expression
    typealias Failure = R.Failure

    enum Side: String, Codable, Hashable {
        case left = "Left", right = "Right"
        init?(name: String) {
            if WhereJudge.sameName(name, "Left") { self = .left }
            else if WhereJudge.sameName(name, "Right") { self = .right }
            else { return nil }
        }
    }
    typealias Path = [Side]

    indirect enum Shape: Equatable {
        case leaf(String), pair(Shape, Shape)
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.leaf(a), .leaf(b)): return WhereJudge.sameName(a, b)
            case let (.pair(a, b), .pair(c, d)): return a == c && b == d
            default: return false
            }
        }

        func at(_ path: Path) throws -> Shape {
            var node = self
            for side in path {
                guard case let .pair(l, r) = node else {
                    throw Failure("route projects an opaque leaf")
                }
                node = side == .left ? l : r
            }
            return node
        }
        var leaves: [(Path, String)] {
            switch self {
            case let .leaf(name): return [([], name)]
            case let .pair(l, r):
                return l.leaves.map { ([.left] + $0.0, $0.1) }
                    + r.leaves.map { ([.right] + $0.0, $0.1) }
            }
        }
    }

    /// Input expressions are reconstructed by replay. A definition step's
    /// body is obtained from the live source, not asserted by this certificate.
    indirect enum ReadProof: Codable {
        case leaf(ScalarName)
        case pair(ReadProof, ReadProof)
        case projection(Side, ReadProof)
        case definition(E, [ReadProof], ReadProof)
    }

    indirect enum Program: Codable, Equatable {
        case pick(Path), pair(Program, Program)
        func apply(to input: Shape) throws -> Shape {
            var remaining = 100_000
            func walk(_ program: Program, _ depth: Int) throws -> Shape {
                guard remaining > 0, depth < 256 else {
                    throw Failure("program exceeds replay limit")
                }
                remaining -= 1
                switch program {
                case let .pick(path): return try input.at(path)
                case let .pair(l, r): return try .pair(walk(l, depth + 1), walk(r, depth + 1))
                }
            }
            return try walk(self, 0)
        }
        func swift(_ input: String, constructor: String) -> String {
            switch self {
            case let .pick(path): return ContinuationCourt.pathText(input, path)
            case let .pair(l, r):
                return
                    "\(constructor)<\(l.swift(input,constructor:constructor)), \(r.swift(input,constructor:constructor))>"
            }
        }
    }

    struct Missing: Codable {
        let source: Path
        let question: Path
    }
    struct Certificate: Codable {
        let request: ScalarName
        let constructor: ScalarName
        var source: ReadProof
        var observation: ReadProof
        var question: ReadProof
        var missing: [Missing]
        var program: Program
    }
    struct Archive: Codable {
        let format: Int
        let certificate: Certificate
    }
    struct Checked {
        let source: Shape
        let observation: Shape
        let question: Shape
        let residual: Shape?
        let input: Shape
    }

    static func pathText(_ base: String, _ path: Path) -> String {
        base + path.map { "." + $0.rawValue }.joined()
    }
    static func bundle(_ shapes: [Shape]) -> Shape? {
        guard let first = shapes.first else { return nil }
        guard shapes.count > 1 else { return first }
        return .pair(first, bundle(Array(shapes.dropFirst()))!)
    }

    /// A deliberately small admission boundary. Opaque parameters range over
    /// Structure; arbitrary nominal conformances are not used as equations.
    final class Context {
        let source: StructuralSource
        let request: String
        let constructor: String
        let parameters: [String]
        let rigid: NameSet
        let root: E
        var raw: R.Source { R.Source(world: source.syntax, rigid: rigid) }

        init(_ request: String, source: StructuralSource, constructor: String = "Paired",
             requiredFields: [String] = ["Source", "Observation", "Question"]) throws {
            self.source = source
            self.request = request
            self.constructor = constructor
            guard StructuralSource.identifier(request), StructuralSource.identifier(constructor),
                let d = source.declarations[request]
            else { throw Failure("unknown request declaration") }
            self.parameters = d.parameters
            let variables = d.parameters.indices.map { "$continuation\($0)" }
            self.rigid = NameSet(variables)
            self.root = .application(request, variables.map { .application($0, []) })
            try checkFoundation()
            _ = try declaration(request)
            guard ["enum", "struct"].contains(d.kind), d.parents.isEmpty, !d.parameters.isEmpty,
                NameSet(d.parameters).isDisjoint(with: NameSet(["Self"] + requiredFields)),
                requiredFields.allSatisfy({ d.fields[$0] != nil }),
                structureParameters(d)
            else {
                throw Failure(
                    "request needs opaque Structure parameters and " + requiredFields.joined(separator: "/")
                        + " fields; no other premises"
                )
            }
        }

        func declaration(_ name: ScalarName) throws -> StructuralSource.Declaration { try declaration(name.text) }
        func declaration(_ name: String) throws -> StructuralSource.Declaration {
            guard let d = source.declarations[name], d.unsupported.isEmpty,
                !source.conditionalSubjects.contains(name),
                !["private", "fileprivate"].contains(source.access[name] ?? "internal")
            else {
                throw Failure("unsupported or conditional declaration: \(name)")
            }
            for ext in source.extensions[name] ?? [] {
                // Value implementations are outside this type-field calculus.
                guard ext.fields.isEmpty, ext.axes.isEmpty, ext.parents.isEmpty,
                    ext.unsupported.isEmpty
                else { throw Failure("structural extension outside routing grammar: \(name)") }
            }
            return d
        }

        func structureParameters(_ d: StructuralSource.Declaration) -> Bool {
            let required = d.requirements.compactMap { r -> String? in
                guard r.kind == .member, WhereJudge.sameName(r.right, "Structure"),
                    let term = try? R.parse(r.left), case let .application(name, args) = term,
                    args.isEmpty, d.parameters.containsName(name)
                else { return nil }
                return name.text
            }
            return required.count == d.requirements.count && NameSet(required) == NameSet(d.parameters)
        }

        func checkFoundation() throws {
            let structure = try declaration("Structure"), open = try declaration("Open")
            let pair = try declaration("Pair"), null = try declaration("Null")
            guard
                [structure, open, pair, null].allSatisfy({
                    $0.kind == "protocol" && $0.parameters.isEmpty && $0.fields.isEmpty
                }),
                structure.parents.isEmpty, structure.requirements.isEmpty, structure.axes.isEmpty,
                WhereJudge.sameNames(open.parents, ["Structure"]), open.requirements.isEmpty, open.axes.count == 1,
                WhereJudge.sameName(open.axes[0].name, "Body"), WhereJudge.sameName(open.axes[0].fallback, "Never"),
                open.axes[0].constraints.count == 1,
                open.axes[0].constraints[0]
                    == .init(kind: .member, left: "Body", right: "Structure"),
                WhereJudge.sameNames(pair.parents, ["Open"]), pair.requirements.isEmpty,
                NameSet(pair.axes.map(\.name)) == ["Left", "Right"], pair.axes.count == 2,
                pair.axes.allSatisfy({ $0.constraints.isEmpty && $0.fallback == nil }),
                WhereJudge.sameNames(null.parents, ["Pair"]), null.axes.isEmpty,
                null.requirements == [.init(kind: .equal, left: "Left", right: "Right")]
            else {
                throw Failure(
                    "structural protocol signature changed; routing interpretation unresolved")
            }
            let c = try declaration(constructor)
            guard ["enum", "struct"].contains(c.kind), c.parameters.count == 2,
                WhereJudge.sameNames(c.parents, ["Pair"]), structureParameters(c),
                ["Left", "Right"].allSatisfy({
                    !["private", "fileprivate"].contains(c.fieldAccess[$0] ?? "internal")
                }),
                try c.fields["Left"].map({ try R.parse($0) }) == .application(c.parameters[0], []),
                try c.fields["Right"].map({ try R.parse($0) }) == .application(c.parameters[1], [])
            else {
                throw Failure("constructor does not expose its two declared arguments")
            }
        }

        /// A guard may only address an argument or its exposed pair fields.
        /// Opaque Structure does not imply Pair; no implicit extra axis is read.
        func bound(_ expression: E, _ values: NameMap<Shape>) throws -> Shape {
            switch expression {
            case let .application(name, args):
                guard args.isEmpty, let value = values[name] else {
                    throw Failure("guard outside parameter-path grammar")
                }
                return value
            case let .field(owner, axis):
                guard let side = Side(name: axis.text) else {
                    throw Failure("guard uses an unsupported axis")
                }
                return try bound(owner, values).at([side])
            }
        }
        func checkArguments(_ owner: E, _ arguments: [(E, Shape)]) throws {
            guard case let .application(name, args) = owner else {
                throw Failure("definition has no nominal owner")
            }
            let d = try declaration(name)
            guard d.parameters.count == args.count, args == arguments.map({ $0.0 }) else {
                throw Failure("definition argument proof belongs to another application")
            }
            let values = NameMap(uniqueKeysWithValues: zip(d.parameters, arguments.map { $0.1 }))
            for requirement in d.requirements {
                let l = try bound(R.parse(requirement.left), values)
                switch requirement.kind {
                case .member:
                    if WhereJudge.sameName(requirement.right, "Structure") { continue }
                    if WhereJudge.sameName(requirement.right, "Pair"), case .pair = l { continue }
                    throw Failure(
                        "unproved or unsupported application guard: \(requirement.left) : \(requirement.right)"
                    )
                case .equal:
                    guard l == (try bound(R.parse(requirement.right), values)) else {
                        throw Failure("unproved application equality; no source relation added")
                    }
                }
            }
        }

        func owner(of expression: E) throws -> E {
            switch expression {
            case let .application(name, _):
                let d = try declaration(name)
                guard d.kind == "typealias", d.parents.isEmpty, d.alias != nil else {
                    throw Failure("only structural aliases can unfold here: \(name)")
                }
                return expression
            case let .field(owner, axis):
                guard owner == root, source.declarations[request]?.fields[axis] != nil,
                    !["private", "fileprivate"].contains(
                        source.declarations[request]?.fieldAccess[axis] ?? "internal")
                else {
                    throw Failure("only fields of this request record unfold here")
                }
                return owner
            }
        }

        // Inspect an already replayed shape proof, including definition arguments.
        func fieldsRead(_ proof: ReadProof) -> NameSet {
            var fields: NameSet = []
            func walk(_ p: ReadProof) {
                switch p {
                case .leaf: break
                case let .pair(l, r):
                    walk(l)
                    walk(r)
                case let .projection(_, child): walk(child)
                case let .definition(input, arguments, child):
                    if case let .field(owner, axis) = input, owner == root { fields.insert(axis) }
                    for argument in arguments { walk(argument) }
                    walk(child)
                }
            }
            walk(proof)
            return fields
        }
        func derive(_ expression: E) throws -> ReadProof {
            var remaining = 50_000
            func build(_ e: E, _ depth: Int) throws -> ReadProof {
                guard remaining > 0, depth < 128 else {
                    throw Failure("source unfolding limit; no impossibility inferred")
                }
                remaining -= 1
                switch e {
                case let .application(name, args):
                    if rigid.contains(name), args.isEmpty { return .leaf(name) }
                    if WhereJudge.sameName(name, constructor), args.count == 2 {
                        return try .pair(build(args[0], depth + 1), build(args[1], depth + 1))
                    }
                case let .field(owner, axis):
                    if owner != root {
                        guard let side = Side(name: axis.text) else {
                            throw Failure("unknown projection \(axis)")
                        }
                        return try .projection(side, build(owner, depth + 1))
                    }
                }
                let owner = try self.owner(of: e)
                guard case let .application(_, args) = owner, let body = try raw.expansion(e) else {
                    throw Failure("no source expansion")
                }
                return try .definition(
                    e, args.map { try build($0, depth + 1) }, build(body, depth + 1))
            }
            let proof = try build(expression, 0)
            _ = try replay(proof)
            return proof
        }

        /// Checks the presented finite steps. No derive, normalForm, routing
        /// search or equivalence closure is called during replay.
        func replay(_ proof: ReadProof) throws -> (E, Shape) {
            var remaining = 100_000
            func walk(_ p: ReadProof, _ depth: Int) throws -> (E, Shape) {
                guard remaining > 0, depth < 256 else {
                    throw Failure("read certificate exceeds replay limit")
                }
                remaining -= 1
                switch p {
                case let .leaf(name):
                    guard rigid.contains(name) else {
                        throw Failure("foreign leaf in read certificate")
                    }
                    return (.application(name, []), .leaf(name.text))
                case let .pair(l, r):
                    let a = try walk(l, depth + 1), b = try walk(r, depth + 1)
                    let input = E.application(constructor, [a.0, b.0])
                    try checkArguments(input, [a, b])
                    return (input, .pair(a.1, b.1))
                case let .projection(side, child):
                    let end = try walk(child, depth + 1)
                    return (.field(end.0, side.rawValue), try end.1.at([side]))
                case let .definition(input, arguments, child):
                    let owner = try self.owner(of: input)
                    let args = try arguments.map { try walk($0, depth + 1) }
                    try checkArguments(owner, args)
                    guard let body = try raw.expansion(input) else {
                        throw Failure("definition no longer unfolds")
                    }
                    let result = try walk(child, depth + 1)
                    guard body == result.0 else {
                        throw Failure("certificate body differs from the live source")
                    }
                    return (input, result.1)
                }
            }
            return try walk(proof, 0)
        }
    }

    static func derive(_ request: String, source: StructuralSource, constructor: String = "Paired")
        throws -> Certificate
    {
        let c = try Context(request, source: source, constructor: constructor)
        let s = try c.derive(.field(c.root, "Source"))
        let p = try c.derive(.field(c.root, "Observation"))
        let q = try c.derive(.field(c.root, "Question"))
        let ss = try c.replay(s).1, ps = try c.replay(p).1, qs = try c.replay(q).1
        try checkCoverage(source: ss, observation: ps, question: qs)
        let observed = NameSet(ps.leaves.map { $0.1 })
        var missing: [Missing] = [], included: NameSet = []
        for (path, name) in qs.leaves
        where !observed.contains(name) && included.insert(name).inserted {
            guard let sourcePath = ss.leaves.first(
                where: { WhereJudge.sameName($0.1, name) }
            )?.0 else {
                throw Failure("question outside source")
            }
            missing.append(Missing(source: sourcePath, question: path))
        }
        let residual = bundle(try missing.map { try ss.at($0.source) })
        let input = residual.map { Shape.pair(ps, $0) } ?? ps
        var available: NameMap<Path> = [:]
        for (path, name) in input.leaves
        where available[name] == nil { available[name] = path }
        func program(_ shape: Shape) throws -> Program {
            switch shape {
            case let .leaf(name):
                guard let path = available[name] else {
                    throw Failure("construction failed to cover question")
                }
                return .pick(path)
            case let .pair(l, r): return try .pair(program(l), program(r))
            }
        }
        let certificate = try Certificate(
            request: request, constructor: constructor, source: s, observation: p,
            question: q, missing: missing, program: program(qs))
        _ = try verify(request, certificate: certificate, source: source, constructor: constructor)
        return certificate
    }

    static func checkCoverage(source: Shape, observation: Shape, question: Shape) throws {
        let names = NameSet(source.leaves.map { $0.1 })
        guard NameSet((observation.leaves + question.leaves).map { $0.1 }).isSubset(of: names) else {
            throw Failure("observation or question introduces a leaf absent from Source")
        }
    }

    static func verify(
        _ request: String, certificate: Certificate, source: StructuralSource,
        constructor: String = "Paired"
    ) throws -> Checked {
        guard WhereJudge.sameName(certificate.request, request), WhereJudge.sameName(certificate.constructor, constructor) else {
            throw Failure("certificate belongs to another request")
        }
        let c = try Context(request, source: source, constructor: constructor)
        let s = try c.replay(certificate.source), p = try c.replay(certificate.observation),
            q = try c.replay(certificate.question)
        guard s.0 == .field(c.root, "Source"), p.0 == .field(c.root, "Observation"),
            q.0 == .field(c.root, "Question")
        else {
            throw Failure("source, observation or question endpoint substituted")
        }
        try checkCoverage(source: s.1, observation: p.1, question: q.1)
        let observed = NameSet(p.1.leaves.map { $0.1 })
        var seen: NameSet = [], residualLeaves: [Shape] = []
        for missing in certificate.missing {
            let a = try s.1.at(missing.source), b = try q.1.at(missing.question)
            guard case let .leaf(name) = a, a == b, !observed.contains(name),
                seen.insert(name).inserted
            else {
                throw Failure("residual has no distinct necessary source/question witness")
            }
            residualLeaves.append(a)
        }
        let residual = bundle(residualLeaves), input = residual.map { Shape.pair(p.1, $0) } ?? p.1
        guard try certificate.program.apply(to: input) == q.1 else {
            throw Failure("constructed program does not answer the original question")
        }
        return Checked(
            source: s.1, observation: p.1, question: q.1, residual: residual, input: input)
    }

    static func swift(_ request: String, certificate: Certificate, source: StructuralSource) throws
        -> String
    {
        let checked = try verify(
            request, certificate: certificate, source: source, constructor: certificate.constructor.text)
        let c = try Context(request, source: source, constructor: certificate.constructor.text)
        let generic = c.parameters.map { $0 + ": Structure" }.joined(separator: ", ")
        let applied = request + "<" + c.parameters.joined(separator: ", ") + ">"
        let prefix = request + "Continuation"
        var constraints: [String] = []
        func constrain(_ s: Shape, _ path: Path) {
            let name = pathText("M", path)
            switch s {
            case .leaf: constraints.append(name + ": Structure")
            case let .pair(l, r):
                constraints.append(name + ": Pair")
                constrain(l, path + [.left])
                constrain(r, path + [.right])
            }
        }
        constrain(checked.input, [])
        let bound = constraints.removeFirst().replacingOccurrences(of: "M: ", with: "")
        let clause = constraints.isEmpty ? "" : "\nwhere " + constraints.joined(separator: ", ")
        var extra = "", input = applied + ".Observation"
        if checked.residual != nil {
            func pack(_ fields: [String]) -> String {
                fields.count == 1
                    ? fields[0]
                    : "\(certificate.constructor)<\(fields[0]), \(pack(Array(fields.dropFirst())))>"
            }
            let value = pack(certificate.missing.map { pathText(applied + ".Source", $0.source) })
            extra = "typealias \(prefix)Residual<\(generic)> = \(value)\n\n"
            input =
                "\(certificate.constructor)<\(input), \(prefix)Residual<\(c.parameters.joined(separator:", "))>>"
        }
        return """
            import VerificationIsIdentification

            // Generated from the current \(request) definitions. Type-field theorem only.
            // Additional source leaves required BEFORE loss: \(certificate.missing.count).
            // Reusing a type does not assert equality of two runtime payload values.
            \(extra)enum \(prefix)<M: \(bound)>: Pair\(clause) {
                typealias Left = M
                typealias Right = \(certificate.program.swift("M",constructor:certificate.constructor.text))
                typealias Answer = Right
            }

            enum \(prefix)Proof<\(generic)>: Null {
                typealias Left = \(applied).Question
                typealias Right = \(prefix)<\(input)>.Answer
            }

            """
    }

    static func encode(_ certificate: Certificate) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(Archive(format: 1, certificate: certificate))
    }
    static func decode(_ data: Data) throws -> Certificate {
        guard data.count <= 8_000_000 else { throw Failure("certificate exceeds input limit") }
        let archive = try CourtJSON.decoder().decode(Archive.self, from: data)
        guard archive.format == 1 else { throw Failure("unsupported certificate format") }
        return archive.certificate
    }

    static func run(_ arguments: [String], replay: Bool = false) {
        if arguments.first == "--relations" {
            runRelations(Array(arguments.dropFirst()), replay: replay)
            return
        }
        do {
            var args = arguments
            let retain = args.first == "--retain"
            if retain { args.removeFirst() }
            var archivePath: String?
            if !replay, args.first == "--certificate" {
                args.removeFirst()
                guard !args.isEmpty else { throw Failure("missing certificate path") }
                archivePath = args.removeFirst()
            }
            var saved: Certificate?
            if replay {
                guard !args.isEmpty else { throw Failure("missing certificate file") }
                saved = try decode(Data(contentsOf: URL(fileURLWithPath: args.removeFirst())))
            }
            guard args.count >= 2 else {
                throw Failure(
                    replay
                        ? "usage: judge replay-continuation [--retain] <certificate.json> <generic-request-name> <source.swift ...>"
                        : "usage: judge continue [--retain] [--certificate output.json] <generic-request-name> <source.swift ...>"
                )
            }
            let request = args.removeFirst()
            let source = try StructuralSource(
                files: args.map { ($0, try String(contentsOfFile: $0, encoding: .utf8)) }, arguments: [("request", request)])
            let proof = try saved ?? derive(request, source: source)
            _ = try verify(request, certificate: proof, source: source)
            if let archivePath {
                try encode(proof).write(to: URL(fileURLWithPath: archivePath), options: .atomic)
            }
            if !retain && !proof.missing.isEmpty {
                let missing = proof.missing.map {
                    pathText("Question", $0.question) + " needs " + pathText("Source", $0.source)
                }.joined(separator: "; ")
                FileHandle.standardError.write(
                    Data(
                        "No uniform continuation in this structural grammar: \(missing). Minimum additional source leaves: \(proof.missing.count). --retain constructs a pre-loss retention plan; it does not recover already lost fields.\n"
                            .utf8))
                exit(1)
            }
            print(try swift(request, certificate: proof, source: source))
        } catch {
            FileHandle.standardError.write(Data("Continuation unresolved: \(error)\n".utf8))
            exit(2)
        }
    }
}

// The archive carries expression syntax, not an asserted normal form.
// Its parser and live-source replay re-establish every endpoint on import.
extension DefinitionReduction.Expression: Codable {
    init(from decoder: Decoder) throws {
        let text = try decoder.singleValueContainer().decode(String.self)
        self = try DefinitionReduction.parse(text, allowRigidNames: true)
    }
    func encode(to encoder: Encoder) throws {
        var value = encoder.singleValueContainer()
        try value.encode(text)
    }
}
