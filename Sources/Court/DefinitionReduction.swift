import Foundation

/// Definitional reduction relative to the definitions actually read by WhereJudge.
/// See Research/2026-09-18-source-reduction-calculus.md for the five rules and
/// their conditional soundness proof. This is not a Swift declaration parser.
enum DefinitionReduction {
    struct Failure: Error, CustomStringConvertible {
        let description: String
        init(_ description: String) { self.description = description }
    }

    indirect enum Expression: Hashable {
        case application(String, [Expression])
        case field(Expression, String)

        var text: String {
            switch self {
            case let .application(name, args):
                return args.isEmpty
                    ? name : name + "<" + args.map(\.text).joined(separator: ", ") + ">"
            case let .field(owner, axis): return owner.text + "." + axis
            }
        }

        var legacy: Press.Term {
            switch self {
            case let .application(name, args):
                return Press.Term(head: name, args: args.map(\.legacy))
            case .field: return Press.Term(head: text, args: [])
            }
        }

        /// Simultaneous substitution: an inserted expression is not visited again.
        func substituting(_ bindings: [String: Expression]) throws -> Expression {
            switch self {
            case let .application(name, args):
                if let replacement = bindings[name] {
                    guard args.isEmpty else {
                        throw Failure("parameter '\(name)' used as a type constructor")
                    }
                    return replacement
                }
                return .application(name, try args.map { try $0.substituting(bindings) })
            case let .field(owner, axis):
                return .field(try owner.substituting(bindings), axis)
            }
        }
    }

    /// Whole-input grammar: identifier [<term (, term)*>] (.identifier)*.
    /// Unsupported suffixes and empty argument slots cannot become equal atoms.
    private struct Parser {
        let characters: [Character]
        let allowRigidNames: Bool
        var position = 0

        mutating func spaces() {
            while position < characters.count, characters[position].isWhitespace { position += 1 }
        }

        mutating func take(_ character: Character) -> Bool {
            spaces()
            guard position < characters.count, characters[position] == character else {
                return false
            }
            position += 1
            return true
        }

        mutating func name() throws -> String {
            spaces()
            let start = position
            if allowRigidNames, position < characters.count, characters[position] == "$" {
                position += 1
            }
            guard position < characters.count,
                characters[position].isLetter || characters[position] == "_"
            else {
                throw Failure("expected an identifier at character \(position)")
            }
            position += 1
            while position < characters.count,
                characters[position].isLetter || characters[position].isNumber
                    || characters[position] == "_"
            {
                position += 1
            }
            return String(characters[start..<position])
        }

        mutating func expression(depth: Int = 0) throws -> Expression {
            guard depth < 128 else { throw Failure("term exceeds the reader depth limit") }
            let head = try name()
            var arguments: [Expression] = []
            if take("<") {
                arguments.append(try expression(depth: depth + 1))
                while take(",") { arguments.append(try expression(depth: depth + 1)) }
                guard take(">") else { throw Failure("unclosed arguments of '\(head)'") }
            }
            var result = Expression.application(head, arguments)
            while take(".") { result = .field(result, try name()) }
            return result
        }
    }

    static func parse(_ text: String, allowRigidNames: Bool = false) throws -> Expression {
        var parser = Parser(characters: Array(text), allowRigidNames: allowRigidNames)
        let result = try parser.expression()
        parser.spaces()
        guard parser.position == parser.characters.count else {
            throw Failure("unsupported term suffix at character \(parser.position) in '\(text)'")
        }
        return result
    }

    struct Source {
        let world: WhereJudge.World
        let rigid: Set<String>

        func validate(_ expression: Expression, depth: Int = 0) throws {
            guard depth < 128 else { throw Failure("expression exceeds validation depth limit") }
            switch expression {
            case let .application(name, arguments):
                guard try parse(name, allowRigidNames: true) == .application(name, []) else {
                    throw Failure("malformed name in derivation input")
                }
                try checkApplication(name, arguments.count)
                for argument in arguments { try validate(argument, depth: depth + 1) }
            case let .field(owner, axis):
                guard try parse(axis) == .application(axis, []) else {
                    throw Failure("malformed field")
                }
                try validate(owner, depth: depth + 1)
            }
        }

        func checkApplication(_ name: String, _ count: Int) throws {
            if rigid.contains(name) {
                guard count == 0 else {
                    throw Failure("free parameter '\(name)' applied to arguments")
                }
                return
            }
            if name.hasPrefix("$") { throw Failure("unbound internal parameter '\(name)'") }
            if world.conditionalDeclarations.contains(name) {
                throw Failure("cannot read conditional declaration '\(name)'")
            }
            if world.aliases[name] != nil && world.conformers[name] != nil {
                throw Failure("ambiguous alias and nominal definition of '\(name)'")
            }
            if let parameters = world.aliases[name]?.parameters ?? world.parameters[name]
                ?? world.conformers[name]?.parameters
            {
                guard Set(parameters).count == parameters.count else {
                    throw Failure("duplicate parameters on '\(name)'")
                }
                guard parameters.count == count else {
                    throw Failure(
                        "'\(name)' requires \(parameters.count) arguments, received \(count)")
                }
            }
        }

        /// The only elementary equations: instantiate the addressed source definition.
        /// No right-hand side or equation is supplied by a proposed derivation.
        func expansion(_ expression: Expression) throws -> Expression? {
            switch expression {
            case let .application(name, arguments):
                try checkApplication(name, arguments.count)
                guard !rigid.contains(name), let definition = world.aliases[name] else {
                    return nil
                }
                let bindings = Dictionary(
                    uniqueKeysWithValues: zip(definition.parameters, arguments))
                return try parse(definition.body).substituting(bindings)
            case let .field(owner, axis):
                if world.intrinsicSwift, expression.text == "Swift.Never" { return .application("Never", []) }
                if world.intrinsicSwift, world.contextVersion == 2, expression.text == "Swift.String" {
                    return .application("String", [])
                }
                if world.nestedNames.contains(expression.text) { return nil }
                if world.namespaces.contains(owner.text) {
                    throw Failure("no declaration of nested name '\(expression.text)'")
                }
                let name: String, arguments: [Expression]
                if case let .application(n, a) = owner { name = n; arguments = a }
                else if world.nestedNames.contains(owner.text) { name = owner.text; arguments = [] }
                else { return nil }
                try checkApplication(name, arguments.count)
                if rigid.contains(name) { return nil }
                if world.conformers[name] == nil, world.presentedBodies.contains(name) {
                    throw Failure(
                        "cannot read declaration '\(name)': body outside flat-definition fragment")
                }
                guard let declaration = world.conformers[name] else { return nil }
                guard let body = declaration.table[axis] else {
                    throw Failure(
                        "cannot read projection '\(expression.text)': no definition of '\(axis)' on '\(name)'"
                    )
                }
                // Generic parameters and sibling names are bound at this owner,
                // before any global alias with the same spelling can be consulted.
                var bindings = Dictionary(
                    uniqueKeysWithValues: zip(declaration.parameters, arguments))
                bindings["Self"] = owner
                for sibling in declaration.table.keys
                where bindings[sibling] == nil {
                    bindings[sibling] = .field(owner, sibling)
                }
                return try parse(body).substituting(bindings)
            }
        }
    }

    /// A finite proposed derivation, not a trusted verdict. Its endpoints are
    /// reconstructed by replay; the caller cannot append an asserted result.
    indirect enum Derivation: Codable {
        case name(String)
        case arguments(String, [Derivation])
        case field(Derivation, String)
        case unfold(Expression, Derivation)
        case join(Derivation, Derivation)
    }

    struct Ends: Equatable {
        let input: Expression
        let output: Expression
    }

    /// Replay follows only the presented proof. It never calls derive/normalForm.
    static func replay(
        _ derivation: Derivation, source: Source,
        nodeLimit: Int = 20_000
    ) throws -> Ends {
        var remaining = nodeLimit
        func walk(_ proof: Derivation, depth: Int) throws -> Ends {
            guard remaining > 0, depth < 512 else {
                throw Failure("derivation replay limit reached")
            }
            remaining -= 1
            switch proof {
            case let .name(name):
                // Parsing the leaf rules out malformed names forged inside a proof.
                let term = try parse(name, allowRigidNames: true)
                guard term == .application(name, []) else { throw Failure("not a derivation leaf") }
                try source.checkApplication(name, 0)
                return Ends(input: term, output: term)
            case let .arguments(name, arguments):
                guard try parse(name, allowRigidNames: true) == .application(name, []) else {
                    throw Failure("not a constructor name")
                }
                try source.checkApplication(name, arguments.count)
                let ends = try arguments.map { try walk($0, depth: depth + 1) }
                return Ends(
                    input: .application(name, ends.map(\.input)),
                    output: .application(name, ends.map(\.output)))
            case let .field(owner, axis):
                guard try parse(axis) == .application(axis, []) else {
                    throw Failure("not a field name")
                }
                let ends = try walk(owner, depth: depth + 1)
                return Ends(input: .field(ends.input, axis), output: .field(ends.output, axis))
            case let .unfold(input, continuation):
                try source.validate(input)
                guard let body = try source.expansion(input) else {
                    throw Failure("no source definition to unfold at '\(input.text)'")
                }
                let ends = try walk(continuation, depth: depth + 1)
                guard ends.input == body else {
                    throw Failure("unfolded body differs from source at '\(input.text)'")
                }
                return Ends(input: input, output: ends.output)
            case let .join(first, second):
                let left = try walk(first, depth: depth + 1)
                let right = try walk(second, depth: depth + 1)
                guard left.output == right.input else {
                    throw Failure("derivations have different shared boundaries")
                }
                return Ends(input: left.input, output: right.output)
            }
        }
        return try walk(derivation, depth: 0)
    }

    static func derive(
        _ expression: Expression, source: Source,
        depthLimit: Int = 64, nodeLimit: Int = 10_000,
        headOnly: Bool = false
    ) throws -> Derivation {
        try source.validate(expression)
        var remaining = nodeLimit
        func unchanged(_ term: Expression) -> Derivation {
            switch term {
            case let .application(name, args):
                return args.isEmpty ? .name(name) : .arguments(name, args.map(unchanged))
            case let .field(owner, axis): return .field(unchanged(owner), axis)
            }
        }
        func build(_ term: Expression, depth: Int, headOnly: Bool) throws -> (
            Derivation, Expression
        ) {
            guard depth <= depthLimit, remaining > 0 else {
                throw Failure(
                    "normalization limit reached at '\(term.text)'; no impossibility inferred")
            }
            remaining -= 1
            switch term {
            case let .application(name, arguments):
                if let body = try source.expansion(term) {
                    let (proof, end) = try build(body, depth: depth + 1, headOnly: headOnly)
                    return (.unfold(term, proof), end)
                }
                if arguments.isEmpty { return (.name(name), term) }
                if headOnly { return (unchanged(term), term) }
                let children = try arguments.map {
                    try build($0, depth: depth + 1, headOnly: false)
                }
                return (
                    .arguments(name, children.map { $0.0 }),
                    .application(name, children.map { $0.1 })
                )
            case let .field(owner, axis):
                let (ownerProof, ownerEnd) = try build(owner, depth: depth + 1, headOnly: true)
                let fieldProof = Derivation.field(ownerProof, axis)
                let at = Expression.field(ownerEnd, axis)
                guard let body = try source.expansion(at) else { return (fieldProof, at) }
                let (bodyProof, end) = try build(body, depth: depth + 1, headOnly: headOnly)
                return (.join(fieldProof, .unfold(at, bodyProof)), end)
            }
        }
        return try build(expression, depth: 0, headOnly: headOnly).0
    }

    static func normalForm(_ expression: Expression, source: Source) throws -> Ends {
        let proof = try derive(expression, source: source)
        let ends = try replay(proof, source: source)
        guard ends.input == expression else { throw Failure("normalization changed the question") }
        return ends
    }

    /// Unfolds definitions only until the outermost constructor is a name no
    /// source definition rewrites. Arguments stay as written.
    static func headForm(_ expression: Expression, source: Source) throws -> Ends {
        let proof = try derive(expression, source: source, headOnly: true)
        let ends = try replay(proof, source: source)
        guard ends.input == expression else { throw Failure("normalization changed the question") }
        return ends
    }

    /// Re-use requires these actual question endpoints and the current source.
    /// A derivation for a different question is not accepted merely because its
    /// outputs match. Changed definitions can invalidate the same proof tree.
    static func verifyEquality(
        _ left: Expression, _ right: Expression,
        leftProof: Derivation, rightProof: Derivation,
        source: Source
    ) throws {
        let l = try replay(leftProof, source: source)
        let r = try replay(rightProof, source: source)
        guard l.input == left, r.input == right else {
            throw Failure("equality belongs to a different question")
        }
        guard l.output == r.output else { throw Failure("no common derived expression") }
    }
}
