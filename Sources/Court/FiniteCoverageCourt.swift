import Foundation

/// An inductive reading of the declared coverage interface. This is a query
/// about a finite family of source-relative reading records, not execution.
/// Unlike ApplicationCourt's recursive structural graph, a witness here is a
/// finite tree. Protocol names select the query's roles; equations and actual
/// source declarations still have to be replayed at every occurrence.
enum FiniteCoverageCourt {
    typealias C = ApplicationCourt
    typealias R = DefinitionReduction
    typealias E = R.Expression
    typealias Failure = R.Failure
    enum Role: String { case leaf, group, join }
    struct Equality {
        let leftFormation: C.Derivation
        let rightFormation: C.Derivation
        let left: R.Derivation
        let right: R.Derivation
    }
    indirect enum Proof {
        case node(E, Role, C.Derivation, [Equality], [Proof])
        var root: E {
            switch self {
            case let .node(e, _, _, _, _): return e
            }
        }
        var count: Int {
            switch self {
            case let .node(_, _, _, _, children):
                return 1 + children.reduce(0) { $0 + $1.count }
            }
        }
    }
    static func field(_ root: E, _ path: String) -> E {
        path.split(separator: ".").reduce(root) { .field($0, String($1)) }
    }
    static func raw(_ source: StructuralSource) -> R.Source {
        R.Source(world: source.syntax, rigid: [])
    }
    static func head(_ expression: E, application: C.Derivation, source: StructuralSource) throws
        -> E
    {
        guard let p = application.nodes[.root(expression)]?.reductions.first else {
            throw Failure("missing application root reduction")
        }
        let ends = try R.replay(p, source: raw(source), nodeLimit: 100_000)
        guard ends.input == expression else { throw Failure("changed application root") }
        return ends.output
    }
    static func roles(_ resolved: E, source: StructuralSource) throws -> [Role] {
        guard case let .application(name, _) = resolved,
            let d = source.declarations[name]
        else { throw Failure("coverage owner is not declared") }
        // Root application checks these direct conformances. Extension-only
        // role discovery is intentionally not inferred by this finite reader.
        let protocols = source.protocolClosure(d.parents)
        return [Role.leaf, .group, .join].filter { role in
            let name: String
            switch role {
            case .leaf: name = "CandidateLeafReading"
            case .group: name = "CandidateGroupReading"
            case .join: name = "VerdictCoversBranches"
            }
            return protocols.contains(name)
        }
    }
    static func equations(_ e: E, _ role: Role) -> [(E, E)] {
        let at: (String) -> E = { field(e, $0) }
        var result: [(E, E)] = []
        switch role {
        case .leaf:
            result = [
                (at("Candidates.Left"), at("Left")),
                (at("Candidates.Right"), .application("Never", [])),
                (at("Right"), at("Answer")),
            ]
        case .group:
            result = [
                (at("Left"), at("Certificate")),
                (at("Candidates"), at("Certificate.Candidates")),
                (at("Right"), at("Answer")),
            ]
            result += ["Answer", "Sigma", "Encoding", "Predicate"].map {
                (at($0), at("Certificate." + $0))
            }
        case .join:
            result = [
                (at("Candidates.Left"), at("Left.Candidates")),
                (at("Candidates.Right"), at("Right.Candidates")),
            ]
            for axis in ["Answer", "Sigma", "Encoding", "Predicate"] {
                result += [(at(axis), at("Left." + axis)), (at(axis), at("Right." + axis))]
            }
        }
        return result
    }
    static func children(_ e: E, _ role: Role) -> [E] {
        switch role {
        case .leaf: return []
        case .group: return [field(e, "Certificate")]
        case .join: return [field(e, "Left"), field(e, "Right")]
        }
    }
    static func equality(_ left: E, _ right: E, source: StructuralSource) throws -> Equality {
        let lf = try C.derive(left, source: source), rf = try C.derive(right, source: source)
        let lp = try R.derive(left, source: raw(source), depthLimit: 128, nodeLimit: 50_000)
        let rp = try R.derive(right, source: raw(source), depthLimit: 128, nodeLimit: 50_000)
        let proof = Equality(leftFormation: lf, rightFormation: rf, left: lp, right: rp)
        try verifyEquality(left, right, proof, source: source)
        return proof
    }
    static func verifyEquality(_ left: E, _ right: E, _ proof: Equality, source: StructuralSource)
        throws
    {
        try C.verify(left, derivation: proof.leftFormation, source: source)
        try C.verify(right, derivation: proof.rightFormation, source: source)
        let l = try R.replay(proof.left, source: raw(source), nodeLimit: 100_000)
        let r = try R.replay(proof.right, source: raw(source), nodeLimit: 100_000)
        guard l.input == left, r.input == right, l.output == r.output else {
            throw Failure("finite coverage equation changed: \(left.text) / \(right.text)")
        }
    }
    static func derive(_ root: E, source: StructuralSource, depthLimit: Int = 64) throws -> Proof {
        func build(_ e: E, ancestors: Set<E>, depth: Int) throws -> Proof {
            guard depth < depthLimit else { throw Failure("finite coverage depth limit reached") }
            let application = try C.derive(e, source: source)
            let subject = try head(e, application: application, source: source)
            guard !ancestors.contains(subject) else {
                throw Failure("cyclic coverage is not a finite construction")
            }
            let available = try roles(subject, source: source)
            guard available.count == 1, let role = available.first else {
                throw Failure("coverage needs one established constructor role: \(e.text)")
            }
            let equalities = try equations(e, role).map { try equality($0.0, $0.1, source: source) }
            let nested = try children(e, role).map {
                try build($0, ancestors: ancestors.union([subject]), depth: depth + 1)
            }
            return .node(e, role, application, equalities, nested)
        }
        let proof = try build(root, ancestors: [], depth: 0)
        try verify(root, proof: proof, source: source)
        return proof
    }
    static func verify(_ root: E, proof: Proof, source: StructuralSource, nodeLimit: Int = 10_000)
        throws
    {
        var remaining = nodeLimit
        func check(_ expected: E, _ proof: Proof) throws {
            remaining -= 1
            guard remaining >= 0 else { throw Failure("finite coverage proof limit reached") }
            guard case let .node(e, role, application, equalities, nested) = proof, e == expected
            else {
                throw Failure("finite coverage proof belongs to a different expression")
            }
            try C.verify(e, derivation: application, source: source)
            let subject = try head(e, application: application, source: source)
            guard try roles(subject, source: source) == [role] else {
                throw Failure("changed coverage role")
            }
            let required = equations(e, role), inputs = children(e, role)
            guard required.count == equalities.count, inputs.count == nested.count else {
                throw Failure("missing finite coverage premise")
            }
            for ((l, r), p) in zip(required, equalities) {
                try verifyEquality(l, r, p, source: source)
            }
            for (input, p) in zip(inputs, nested) { try check(input, p) }
        }
        try check(root, proof)
    }
    static func run(_ arguments: [String]) {
        do {
            guard arguments.count >= 2 else {
                throw Failure("usage: judge coverage <coverage-expression> <source.swift ...>")
            }
            let root = try R.parse(arguments[0])
            let files = try arguments.dropFirst().map {
                ($0, try String(contentsOfFile: $0, encoding: .utf8))
            }
            let source = try StructuralSource(files: files, arguments: [("arguments[0]", arguments[0])])
            let proof = try derive(root, source: source)
            print(
                "✓ FINITE COVERAGE: \(root.text); \(proof.count) source-bound constructor occurrences"
            )
            print(
                "Scope: finite declared reading records; not correctness of runtime or physical readings."
            )
        } catch {
            FileHandle.standardError.write(Data("✗ FINITE COVERAGE unresolved: \(error)\n".utf8))
            exit(2)
        }
    }
}
