import Foundation

/// Joins declarations only after the explicit source context establishes their
/// ownership. The equations and obligations still come from source declarations.
enum WhereContext {
    typealias Unit = CourtNotation.File

    static func prepare(_ paths: [String], contextPath: String,
                        load: (String) throws -> String, documents: NameSet = [],
                        batch: Bool = false, notationOnly: Bool = false,
                        bindingCertificate: ContextNameBinding.Certificate? = nil) throws -> WhereJudge.Prepared {
        guard let first = paths.first else { throw WhereJudge.Failure.input(["context needs a world source"]) }
        var texts: NameMap<String> = [:]
        for path in paths { texts[path] = try load(path) }
        let context = try CourtContext(text: load(contextPath), paths: paths, texts: texts)
        if context.version == 2 && !batch {
            throw WhereJudge.Failure.input(["context/2 requires --report for complete source coverage"])
        }
        let readUnits = try CourtNotation.read(context, texts: texts, selected: notationOnly ? nil : first, documents: documents)
        let resolved = try WhereContextNames.resolve(readUnits, selected: first, version: context.version)
        let units = resolved.files
        let intrinsicNames = ["Never"] + (context.version == 2 ? ["String"] : [])
        if !units.filter({ $0.world.intrinsicSwift }).isEmpty {
            for unit in units.sorted(by: { $0.context.source < $1.context.source }) {
                for name in ["Swift"] + intrinsicNames {
                    if let line = unit.world.declared[name]?.first {
                        try WhereJudge.fail("cannot read line \(line) of '\(unit.context.source)': declaration '\(name)' conflicts with intrinsic Swift/\(context.version)")
                    }
                }
            }
        }
        guard let own = units.filter({ WhereJudge.sameName($0.context.input, first) }).first else {
            throw WhereJudge.Failure.input(["context has no world source"])
        }
        struct Origin {
            let unit: Unit
            let line: Int
            var address: String { unit.context.source + ":\(line)" }
        }
        var origins: NameMap<[Origin]> = [:]
        for unit in units {
            for name in unit.world.fileTypes {
                origins[name, default: []].append(Origin(unit: unit, line: unit.world.declared[name]?.first ?? 1))
            }
        }
        for name in origins.keys.sorted() {
            let found = origins[name]!.sorted { $0.address < $1.address }
            if found.count > 1 {
                try WhereJudge.fail("\(found[0].address): declaration '\(name)' conflicts with '\(found[1].address)'; qualified foreign-name resolution is outside this fragment")
            }
        }
        var world = own.world
        world.contextual = true
        world.contextNameBindings = resolved.nameBindings
        world.contextNameBindingCertificate = bindingCertificate ?? resolved.nameBindings?.certificate
        if let bindingCertificate {
            guard let index = resolved.nameBindings else { try WhereJudge.fail("name bindings require context/2") }
            try index.replay(bindingCertificate)
        }
        world.contextVersion = context.version
        world.contextSource = own.context.source
        world.excludedDefinitions = units.flatMap(\.unchecked).sorted()
        world.intrinsicSwift = units.contains { $0.world.intrinsicSwift }
        let ownAliases = own.world.aliases
        for unit in units {
            for name in unit.world.fileTypes { world.addresses[name] = origins[name]!.first!.address }
            for (name, line) in unit.world.certificateLines { world.addresses[name] = unit.context.source + ":\(line)" }
            guard !WhereJudge.sameName(unit.context.input, first) else { continue }
            world.aliases.merge(unit.world.aliases) { old, _ in old }
            world.conformers.merge(unit.world.conformers) { old, _ in old }
            world.parameters.merge(unit.world.parameters) { old, _ in old }
            world.genericRequirements.merge(unit.world.genericRequirements) { old, _ in old }
            world.genericUnsupported.merge(unit.world.genericUnsupported) { old, _ in old }
            world.protocolParents.merge(unit.world.protocolParents) { old, _ in old }
            world.protocolAxes.merge(unit.world.protocolAxes) { old, _ in old }
            world.gatedProtocols.merge(unit.world.gatedProtocols) { old, _ in old }
            world.gates += unit.world.gates
            world.namespaces.formUnion(unit.world.namespaces)
            world.nestedNames.formUnion(unit.world.nestedNames)
            world.presentedBodies.formUnion(unit.world.presentedBodies)
            world.conditionalDeclarations.formUnion(unit.world.conditionalDeclarations)
        }
        for unit in units {
            let scope = WhereJudge.Scope(unit.world.clean)
            for hit in try WhereJudge.declarations(#"extension\s+(\w+)\s*:\s*([\w,\s]+?)\s*\{"#, unit.world.clean, scope) {
                let name = hit[0]
                guard unit.world.conformers[name] == nil else { continue }
                let parents = hit[1].split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                if intrinsicNames.containsName(name), world.conformers[name] == nil {
                    world.conformers[name] = WhereJudge.Conformer(name: name, parameters: [], protocols: [], table: [:])
                }
                if world.conformers[name] != nil { world.conformers[name]!.protocols += parents }
            }
            for hit in try WhereJudge.declarations(#"extension\s+(\w+)\s*(?::\s*[\w,\s]+?)?\s*\{([^{}]*)\}"#, unit.world.clean, scope) {
                let name = hit[0]
                guard unit.world.conformers[name] == nil, world.conformers[name] != nil else { continue }
                for alias in try WhereJudge.readAliases(hit[1]) {
                    guard alias[1].isEmpty else { continue }
                    guard world.conformers[name]!.table[alias[0]] == nil else {
                        try WhereJudge.fail("\(unit.context.source):1: duplicate definition of '\(name).\(alias[0])'")
                    }
                    world.conformers[name]!.table[alias[0]] = alias[2]
                }
            }
        }
        if context.version == 2 { try WhereContextNames.members(units, in: world) }
        try WhereContextNames.applications(resolved.applications, in: world)
        // Availability is checked from source declarations and explicit import
        // edges. A context does not turn an opaque spelling into a supplied type.
        for unit in units {
            for name in (try references(unit.world, in: world)).sorted() {
                guard let origin = origins[name]?.first,
                      WhereContextNames.key(origin.unit.context.module) != WhereContextNames.key(unit.context.module) else { continue }
                guard unit.context.imports.map(WhereContextNames.key).contains(WhereContextNames.key(origin.unit.context.module)) else {
                    try WhereJudge.fail("\(unit.context.source):1: '\(name)' belongs to unimported namespace '\(origin.unit.context.namespace)'")
                }
            }
        }
        func named(_ text: String) -> NameSet {
            NameSet(WhereJudge.captures(#"\b(\w+(?:\s*\.\s*\w+)*)\b"#, text).map {
                $0[0].replacingOccurrences(of: #"\s*\.\s*"#, with: ".", options: .regularExpression)
            }).union(WhereJudge.captures(#"\b(\w+)\b"#, text).map { $0[0] })
        }
        var reached = own.world.names.union(named(own.world.clean)), changed = true
        while changed {
            let before = reached
            for name in before {
                var words = world.protocolParents[name] ?? []
                if let c = world.conformers[name] { words += c.protocols + Array(c.table.values) }
                for requirement in world.genericRequirements[name] ?? [] {
                    words += [requirement.left, requirement.right]
                }
                if let a = world.aliases[name] { words.append(a.body) }
                for gate in world.gates {
                    guard WhereJudge.sameName(gate.head, name) else { continue }
                    words.append(gate.proto)
                    words += gate.equalities.flatMap { [$0.0, $0.1] } + gate.memberships.flatMap { [$0.0, $0.1] }
                }
                if let g = world.gatedProtocols[name] {
                    words += g.equalities.flatMap { [$0.0, $0.1] } + g.memberships.flatMap { [$0.0, $0.1] }
                }
                for text in words { reached.formUnion(named(text)) }
            }
            changed = before != reached
        }
        // Missing declarations are not opaque declared content. Keep this
        // admission residue beside the judgment; an existing false/unsupported
        // obligation retains its addressed answer, and reflexivity cannot turn
        // an incomplete context into a positive certificate.
        for unit in units {
            for name in (try references(unit.world, in: world)).sorted() {
                guard reached.contains(name) && origins[name] == nil && !intrinsicNames.containsName(name)
                    && !(WhereJudge.sameName(name, "Swift") && world.intrinsicSwift) else { continue }
                var at = unit.context.source
                if context.version == 2, units.contains(where: { $0.world.protocolAxes.values.contains { $0.contains(name) } }),
                   let alias = unit.world.aliases.keys.sorted().first(where: {
                       (try? StructuralSource.tokens(unit.world.aliases[$0]!.body))?.containsName(name) == true
                   }) {
                    at += ":\(unit.world.certificateLines[alias] ?? 1)"
                }
                world.contextUnresolved.append("\(at): no declared definition for '\(name)' in the supplied context")
            }
        }
        world.contextUnresolved.sort()
        world.gates = world.gates.filter { reached.contains($0.head) }
        world.gatedProtocols = world.gatedProtocols.filter { reached.contains($0.key) }
        world.contextConformers = NameSet(own.world.conformers.keys)
        for unit in units {
            for (name, lines) in unit.world.extensions {
                guard reached.contains(name) else { continue }
                let at = unit.context.source + ":\(lines[0])"
                if world.aliases[name] != nil { try WhereJudge.fail("\(at): extension through typealias '\(name)' is unsupported") }
                if !intrinsicNames.containsName(name) {
                    guard let origin = origins[name]?.first else { try WhereJudge.fail("\(at): extension target '\(name)' has no declared owner") }
                    guard WhereContextNames.key(origin.unit.context.module) == WhereContextNames.key(unit.context.module)
                        || unit.context.imports.map(WhereContextNames.key).contains(WhereContextNames.key(origin.unit.context.module)) else {
                        try WhereJudge.fail("\(at): extension target '\(name)' is not imported")
                    }
                    if !WhereJudge.sameName(origin.unit.context.input, unit.context.input),
                       unit.world.clean.range(of: #"\b(?:private|fileprivate)\b"#, options: .regularExpression) != nil {
                        try WhereJudge.fail("\(at): private extension members have no established cross-source reachability")
                    }
                }
            }
            for gate in unit.world.gates {
                guard reached.contains(gate.head) else { continue }
                world.addresses[gate.head + ": " + gate.proto] = unit.context.source + ":\(unit.world.extensions[gate.head]?.first ?? 1)"
            }
        }
        if notationOnly {
            return WhereJudge.Prepared(path: own.context.source, world: world, ownAliases: ownAliases,
                excludesConditional: units.contains { WhereJudge.sourceLines($0.text).range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil })
        }
        // A cycle supplies no independent conformance premise. Sorting fixes the
        // named obstruction independently of the order of definitions arguments.
        var done: NameSet = [], active: NameSet = []
        func visit(_ name: String) throws {
            if active.contains(name) {
                try WhereJudge.fail("\(world.addresses[name] ?? own.context.source + ":1"): protocol refinement cycle at '\(name)' has no independent ground")
            }
            if done.contains(name) { return }
            active.insert(name)
            for parent in (world.protocolParents[name] ?? []).sorted() { try visit(parent) }
            active.remove(name)
            done.insert(name)
        }
        for name in world.protocolParents.keys.sorted() {
            guard reached.contains(name) else { continue }
            try visit(name)
        }
        // A bare alias edge selects a declaration before reduction. Give a
        // cycle its declaration address rather than exhausting the reducer's
        // work allowance without an owner. Other reduction failures retain
        // their existing boundary.
        var aliasDone: NameSet = [], aliasActive: NameSet = []
        func visitAlias(_ name: String) throws {
            guard let alias = world.aliases[name], alias.parameters.isEmpty else { return }
            if aliasActive.contains(name) {
                try WhereJudge.fail("\(world.addresses[name] ?? own.context.source + ":1"): cyclic alias resolution at '\(name)' has no declared nominal ground")
            }
            if aliasDone.contains(name) { return }
            aliasActive.insert(name)
            if case let .application(next, arguments) = try DefinitionReduction.parse(alias.body), arguments.isEmpty {
                try visitAlias(next)
            }
            aliasActive.remove(name)
            aliasDone.insert(name)
        }
        for name in world.aliases.keys.sorted() where reached.contains(name) { try visitAlias(name) }
        for name in world.gatedProtocols.keys.sorted() {
            let gate = world.gatedProtocols[name]!
            for part in gate.unjudged {
                try WhereJudge.fail("\(world.addresses[name] ?? own.context.source + ":1"): the gated protocol '\(name)' carries '\(part)', a conjunct this court does not judge")
            }
        }
        var gates: [WhereJudge.GatedExtension] = []
        for gate in world.gates {
            let at = world.addresses[gate.head + ": " + gate.proto] ?? own.context.source + ":1"
            for part in gate.unjudged { try WhereJudge.fail("\(at): the gate '\(gate.head): \(gate.proto)' carries '\(part)', a conjunct this court does not judge") }
            var equalities = gate.equalities, memberships = gate.memberships
            for proto in WhereJudge.inheritedProtocols([gate.proto], world).sorted() {
                if let inherited = world.gatedProtocols[proto] {
                    equalities += inherited.equalities
                    memberships += inherited.memberships
                }
            }
            gates.append(WhereJudge.GatedExtension(head: gate.head, proto: gate.proto, equalities: equalities,
                memberships: memberships, unjudged: []))
        }
        world.gates = gates
        try selectConformers(&world, aliases: ownAliases)
        try groundedMemberships(world)
        let extras = units.filter { !WhereJudge.sameName($0.context.input, first) }.map { (path: $0.context.source, text: $0.text, world: $0.world) }
        return try WhereJudge.finish(path: own.context.source, world: world, ownAliases: ownAliases,
            excludesConditional: units.contains { WhereJudge.sourceLines($0.text).range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil }, extras: extras)
    }
    // Only free type references use imports. A field/parameter named Reading or
    // A in a borrowed declaration is not a reference to a world's type of that name.
    static func references(_ source: WhereJudge.World, in world: WhereJudge.World) throws -> NameSet {
        var result: NameSet = []
        func axes(_ name: String, _ seen: NameSet = []) -> NameSet {
            guard !seen.contains(name) else { return [] }
            return (world.protocolAxes[name] ?? []).union((world.protocolParents[name] ?? []).reduce(into: NameSet()) {
                $0.formUnion(axes($1, seen.union([name])))
            })
        }
        func walk(_ expression: DefinitionReduction.Expression, _ bound: NameSet) {
            switch expression {
            case let .application(name, args):
                if !bound.contains(name) { result.insert(name) }
                for arg in args { walk(arg, bound) }
            case let .field(owner, _):
                if world.nestedNames.contains(expression.text) { result.insert(expression.text) }
                else { walk(owner, bound) }
            }
        }
        func term(_ text: String, _ bound: NameSet = []) throws {
            do { walk(try DefinitionReduction.parse(text), bound) }
            catch { try WhereJudge.fail("context type reference '\(text)' is unsupported: \(error)") }
        }
        for name in source.aliases.keys.sorted() {
            let rule = source.aliases[name]!
            try term(rule.body, NameSet(rule.parameters))
        }
        for name in source.conformers.keys.sorted() {
            let c = source.conformers[name]!
            let bound = NameSet(c.parameters + Array(c.table.keys) + ["Self"])
            for proto in c.protocols { try term(proto) }
            for field in c.table.keys.sorted() { try term(c.table[field]!, bound) }
            for requirement in source.genericRequirements[name] ?? [] {
                try term(requirement.left, bound)
                try term(requirement.right, bound)
            }
        }
        for name in source.protocolParents.keys.sorted() {
            for parent in source.protocolParents[name]! { try term(parent) }
        }
        for name in source.gatedProtocols.keys.sorted() {
            let g = source.gatedProtocols[name]!, bound = axes(name).union(["Self"])
            for (left, right) in g.equalities + g.memberships {
                try term(left, bound)
                try term(right, bound)
            }
        }
        for gate in source.gates {
            let bound = NameSet(world.parameters[gate.head] ?? []).union(axes(gate.head))
                .union(world.conformers[gate.head].map { NameSet($0.table.keys) } ?? []).union(["Self"])
            try term(gate.head)
            try term(gate.proto)
            for (left, right) in gate.equalities + gate.memberships {
                try term(left, bound)
                try term(right, bound)
            }
        }
        for name in source.extensions.keys { try term(name) }
        for use in source.uses { try term(use) }
        return result
    }
    // A borrowed nominal used as an equality leaf does not assert every one of
    // its conformances. Its conformance obligations enter when membership uses it.
    // Local declarations and every conditional-head certificate retain the old question.
    static func selectConformers(_ world: inout WhereJudge.World, aliases: NameMap<WhereJudge.AliasRule>) throws {
        var changed = true
        while changed {
            var selected = world.contextConformers
            func members(_ clauses: [(String, String)], _ bindings: NameMap<WhereJudge.Term>, _ rigid: NameSet = []) throws {
                for (lhs, _) in clauses {
                    let term = try WhereJudge.substitute(WhereJudge.parseTerm(Substring(lhs)), bindings)
                    let target = world.contextVersion == 2
                        ? try GenericMembership.head(term, world: world, rigid: rigid)
                        : try WhereJudge.normalize(term, world, rigid: rigid)
                    if target.args.isEmpty, world.conformers[target.head] != nil { selected.insert(target.head) }
                }
            }
            func certificate(_ term: WhereJudge.Term, _ rigid: NameSet = []) throws {
                let claim = try WhereJudge.gatedForm(term, world, rigid: rigid)
                let matching = world.gates.filter { WhereJudge.sameName($0.head, claim.head) }
                guard !matching.isEmpty else { return }
                let bindings = try WhereJudge.gateBindings(claim, world)
                for gate in matching { try members(gate.memberships, bindings, rigid) }
            }
            for name in aliases.keys.sorted() {
                guard aliases[name]!.parameters.isEmpty else { continue }
                try certificate(WhereJudge.parseTerm(Substring(aliases[name]!.body)))
            }
            for use in world.uses { try certificate(WhereJudge.parseTerm(Substring(use))) }
            for name in world.contextConformers.sorted() {
                guard let c = world.conformers[name] else { continue }
                let (bindings, rigid) = try WhereJudge.conformerContext(c, world)
                for field in c.table.keys.sorted() {
                    try certificate(WhereJudge.substitute(WhereJudge.parseTerm(Substring(c.table[field]!)), bindings), rigid)
                }
                for proto in WhereJudge.inheritedProtocols(c.protocols, world).sorted() {
                    if let g = world.gatedProtocols[proto] { try members(g.memberships, bindings, rigid) }
                }
            }
            changed = selected != world.contextConformers
            world.contextConformers = selected
        }
    }
    static func groundedMemberships(_ world: WhereJudge.World) throws {
        func address(_ name: String) -> String { world.addresses[name] ?? world.contextSource + ":1" }
        func protocols(_ names: [String], at: String) throws {
            for name in WhereJudge.inheritedProtocols(names, world).sorted() {
                guard world.protocolParents[name] != nil else {
                    try WhereJudge.fail("\(at): no declared protocol grounds for '\(name)'")
                }
            }
        }
        func independentlyWears(_ names: [String], _ required: String, _ seen: NameSet = []) -> Bool {
            for name in names {
                guard !seen.contains(name) && world.gatedProtocols[name] == nil else { continue }
                if WhereJudge.sameName(name, required) || independentlyWears(world.protocolParents[name] ?? [], required, seen.union([name])) { return true }
            }
            return false
        }
        var edges: NameMap<NameSet> = [:], locations: NameMap<String> = [:]
        for name in world.contextConformers.sorted() {
            guard let conformer = world.conformers[name] else { continue }
            try protocols(conformer.protocols, at: address(name))
            let (bindings, rigid) = try WhereJudge.conformerContext(conformer, world)
            for proto in WhereJudge.inheritedProtocols(conformer.protocols, world).sorted() {
                guard let gate = world.gatedProtocols[proto] else { continue }
                let node = name + ": " + proto
                edges[node] = []
                locations[node] = address(name)
                for (lhs, required) in gate.memberships {
                    try protocols([required], at: address(name))
                    let term = try WhereJudge.substitute(WhereJudge.parseTerm(Substring(lhs)), bindings)
                    let target = world.contextVersion == 2
                        ? try GenericMembership.head(term, world: world, rigid: rigid)
                        : try WhereJudge.normalize(term, world, rigid: rigid)
                    guard target.args.isEmpty, let wearer = world.conformers[target.head] else { continue }
                    try protocols(wearer.protocols, at: address(target.head))
                    if independentlyWears(wearer.protocols, required) { continue }
                    for inherited in WhereJudge.inheritedProtocols(wearer.protocols, world) {
                        guard world.gatedProtocols[inherited] != nil else { continue }
                        edges[node]!.insert(target.head + ": " + inherited)
                    }
                }
            }
        }
        for gate in world.gates {
            let at = address(gate.head + ": " + gate.proto)
            try protocols([gate.proto] + gate.memberships.map { $0.1 }, at: at)
        }
        var done: NameSet = [], active: NameSet = []
        func visit(_ node: String) throws {
            if active.contains(node) {
                try WhereJudge.fail("\(locations[node] ?? world.contextSource + ":1"): gated membership cycle at '\(node)' has no independent ground")
            }
            if done.contains(node) { return }
            guard let dependencies = edges[node] else {
                try WhereJudge.fail("\(world.contextSource):1: dependent gated conformance '\(node)' was not read")
            }
            active.insert(node)
            for next in dependencies.sorted() { try visit(next) }
            active.remove(node)
            done.insert(node)
        }
        for node in edges.keys.sorted() { try visit(node) }
    }
}
