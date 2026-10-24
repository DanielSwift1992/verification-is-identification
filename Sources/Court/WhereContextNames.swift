import Foundation

/// Resolves supplied module declarations before the nominal reduction reads
/// their terms. The source context continues to bind the original bytes.
enum WhereContextNames {
    typealias Key = ScalarName
    static func key(_ name: String) -> Key { ScalarName(name) }
    static func less(_ left: Key, _ right: Key) -> Bool {
        left.text.unicodeScalars.lexicographicallyPrecedes(right.text.unicodeScalars)
    }

    struct Origin {
        let file: Int
        let name: String
        let module: Key
        let line: Int
    }
    struct Application {
        let text: String
        let address: String
        let bound: NameSet
    }
    struct Resolution {
        let files: [CourtNotation.File]
        let applications: [Application]
    }

    static func resolve(_ files: [CourtNotation.File], selected: String,
                        version: Int) throws -> Resolution {
        var origins: [Key: [Origin]] = [:], exports: [Key: Set<Key>] = [:]
        let modules = Set(files.map { key($0.context.module) })
        for (index, file) in files.enumerated() {
            let module = key(file.context.module)
            for name in file.world.fileTypes {
                origins[key(name), default: []].append(Origin(file: index, name: name,
                    module: module, line: file.world.declared[name]?.first ?? 1))
            }
            // Comments and excluded conditional branches are already absent
            // from this read view. An imports row alone is not a re-export.
            for hit in WhereJudge.captures(#"@_exported\s+import\s+(\w+)"#, file.world.clean) {
                exports[module, default: []].insert(key(hit[0]))
            }
        }
        for found in origins.values {
            var seen: [Key: Origin] = [:]
            for origin in found.sorted(by: { (files[$0.file].context.source, $0.line) < (files[$1.file].context.source, $1.line) }) {
                if let previous = seen[origin.module] {
                    try WhereJudge.fail("\(files[origin.file].context.source):\(origin.line): declaration '\(origin.name)' conflicts with '\(files[previous.file].context.source):\(previous.line)' in module '\(files[origin.file].context.module)'")
                }
                seen[origin.module] = origin
            }
        }
        func visible(_ file: CourtNotation.File) -> Set<Key> {
            var result = Set(file.context.imports.map(key))
            result.insert(key(file.context.module))
            var pending = Array(result)
            while let next = pending.popLast() {
                for imported in exports[next] ?? []
                where result.insert(imported).inserted {
                    pending.append(imported)
                }
            }
            return result
        }
        let builders = try files.reduce(into: NameSet()) {
            $0.formUnion(try WhereJudge.declaredBuilders($1.world.clean))
        }
        let tapes = try files.map { file -> StructuralSource.Lexed in
            let scanned = try WhereJudge.lexicalReading(file.view, scope: .notation,
                lent: builders, carrying: true).tape
            let lines = file.world.clean.components(separatedBy: "\n")
            let active = Set(lines.indices.filter { !lines[$0].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.map { $0 + 1 })
            let indices = scanned.words.indices.filter {
                key(scanned.words[$0]) != key("\n") && active.contains(scanned.lines[$0])
            }
            var tape = StructuralSource.Lexed()
            tape.words = indices.map { scanned.words[$0] }
            tape.starts = indices.map { scanned.starts[$0] }
            tape.ends = indices.map { scanned.ends[$0] }
            tape.lines = indices.map { scanned.lines[$0] }
            return tape
        }
        var qualified: Set<Key> = []
        for tape in tapes
        where tape.words.count >= 3 {
            for i in 0..<(tape.words.count - 2)
            where modules.contains(key(tape.words[i])) && key(tape.words[i + 1]) == key(".") {
                qualified.insert(key(tape.words[i + 2]))
            }
        }
        // A collision that no source qualifies retains the earlier admission
        // boundary. An ambiguous imported reference is diagnosed at its use.
        // In particular an unused, unimported duplicate premise does not widen
        // the old context/1 fragment merely by being supplied beside it.
        for (name, found) in origins.sorted(by: { less($0.key, $1.key) })
        where found.count > 1 && !qualified.contains(name) {
            guard !files.contains(
                where: { file in found.filter { visible(file).contains($0.module) }.count > 1 }) else { continue }
            let ordered = found.sorted {
                (files[$0.file].context.source, $0.line) < (files[$1.file].context.source, $1.line)
            }
            try WhereJudge.fail("\(files[ordered[0].file].context.source):\(ordered[0].line): declaration '\(ordered[0].name)' conflicts with '\(files[ordered[1].file].context.source):\(ordered[1].line)'; qualified foreign-name resolution is outside this fragment")
        }
        // Existing unambiguous names keep their spelling. Distinct declarations
        // with one short spelling receive distinct nominal symbols; these are
        // identifiers of the read view, never new declarations in the input.
        let ownModule = key(files.first { key($0.context.input) == key(selected) }!.context.module)
        var prefix = "__courtContext"
        while files.contains(
            where: { $0.world.clean.contains(prefix) }) { prefix += "_" }
        var symbols: [Key: [Key: String]] = [:], serial = 0
        for name in origins.keys.sorted(by: { less($0, $1) }) {
            let found = origins[name]!
            for origin in found.sorted(by: { less($0.module, $1.module) }) {
                let symbol: String
                if found.count == 1 || origin.module == ownModule { symbol = origin.name }
                else {
                    let module = files[origin.file].context.module
                    let hint = StructuralSource.identifier(module) ? module : "module"
                    symbol = prefix + String(serial) + "_" + hint + "_"
                        + origin.name.replacingOccurrences(of: ".", with: "_")
                    serial += 1
                }
                symbols[name, default: [:]][origin.module] = symbol
            }
        }
        var moduleSpellings = Dictionary(grouping: files.map(\.context.module), by: key).mapValues { $0[0] }
        moduleSpellings[key("Swift")] = "Swift"
        var applications: [Application] = []
        let resolved = try files.enumerated().map { fileIndex, file in
            let accessible = visible(file), local = key(file.context.module)
            var context = file.context
            context = CourtContext.Source(input: context.input, source: context.source, sha256: context.sha256,
                namespace: context.namespace, module: context.module, role: context.role,
                imports: accessible.filter { $0 != local }.compactMap { moduleSpellings[$0] }.sorted(),
                at: context.at, importAddresses: context.importAddresses)
            let collisions = Set(origins.filter { $0.value.count > 1 }.keys)
            let bound = Set((file.world.parameters.values.flatMap { $0 }
                + file.world.conformers.values.flatMap { Array($0.table.keys) }
                + file.world.protocolAxes.values.flatMap { Array($0) }).map(key))
            // The flat declaration reader has no lexical owner for a shadowed
            // parameter/axis. Renaming that spelling would choose a false owner.
            let clean = file.view
            // Use the existing structural token reader, including its original
            // byte coordinates; no second identifier alphabet is introduced.
            let tokens = tapes[fileIndex]
            var replacements: [(Int, Int, String)] = [], genericRanges: [(Int, Int, String)] = [], i = 0
            func address(_ index: Int) -> String { file.context.source + ":\(tokens.lines[index])" }
            func choose(_ name: String, at index: Int) throws -> Origin? {
                let found = origins[key(name)] ?? []
                if let own = found.first(
                    where: { $0.module == local }) { return own }
                let imported = found.filter { accessible.contains($0.module) }
                if imported.count > 1 {
                    let addresses = imported.map { files[$0.file].context.source + ":\($0.line)" }.sorted().joined(separator: "', '")
                    try WhereJudge.fail("\(address(index)): unqualified name '\(name)' is ambiguous between '\(addresses)'")
                }
                if !found.isEmpty && imported.isEmpty {
                    try WhereJudge.fail("\(address(index)): '\(name)' belongs to unimported namespace '\(files[found[0].file].context.namespace)'")
                }
                return imported.first
            }
            while i < tokens.words.count {
                let word = tokens.words[i], name = key(word)
                if name == key("import") { i += 2; continue }
                if i > 0 && key(tokens.words[i - 1]) == key(".") { i += 1; continue }
                if modules.contains(name), i + 2 < tokens.words.count, key(tokens.words[i + 1]) == key(".") {
                    guard tokens.lines[i] == tokens.lines[i + 2] else {
                        try WhereJudge.fail("\(address(i)): a module qualifier across lines is outside this context fragment")
                    }
                    guard !bound.contains(name), !(origins[name] ?? []).contains(
                        where: { $0.module == local }) else {
                        try WhereJudge.fail("\(address(i)): module qualifier '\(word)' is shadowed by a local declaration; this binding is outside the nominal context fragment")
                    }
                    guard accessible.contains(name) else {
                        try WhereJudge.fail("\(address(i)): module '\(word)' is not imported")
                    }
                    let member = tokens.words[i + 2]
                    guard let origin = (origins[key(member)] ?? []).first(
                        where: { $0.module == name }),
                          let symbol = symbols[key(member)]?[name] else {
                        try WhereJudge.fail("\(address(i)): module '\(word)' has no declaration '\(member)'")
                    }
                    let declaration = files[origin.file].world
                    let parameters = declaration.parameters[member] ?? declaration.aliases[member]?.parameters ?? []
                    if !parameters.isEmpty && (i + 3 == tokens.words.count || key(tokens.words[i + 3]) != key("<")) {
                        try WhereJudge.fail("\(address(i)): generic declaration '\(word).\(member)' needs explicit arguments in this fragment")
                    }
                    replacements.append((tokens.starts[i], tokens.ends[i + 2], symbol))
                    if i + 3 < tokens.words.count, key(tokens.words[i + 3]) == key("<") {
                        guard version == 2 else {
                            try WhereJudge.fail("\(address(i)): qualified generic application requires context/2 applicability grounds")
                        }
                        var end = i + 3, depth = 0
                        repeat {
                            if key(tokens.words[end]) == key("<") { depth += 1 }
                            if key(tokens.words[end]) == key(">") { depth -= 1 }
                            end += 1
                        } while end < tokens.words.count && depth > 0
                        guard depth == 0 else {
                            try WhereJudge.fail("\(address(i)): qualified generic application has unbalanced arguments")
                        }
                        genericRanges.append((tokens.starts[i], tokens.ends[end - 1], address(i)))
                    }
                    i += 3
                    continue
                }
                if collisions.contains(name), let origin = try choose(word, at: i),
                   let symbol = symbols[name]?[origin.module], key(symbol) != name {
                    guard !bound.contains(name) else {
                        try WhereJudge.fail("\(address(i)): context name '\(word)' is shadowed by a parameter or axis; this binding is outside the nominal context fragment")
                    }
                    replacements.append((tokens.starts[i], tokens.ends[i], symbol))
                }
                i += 1
            }
            guard !replacements.isEmpty else {
                return CourtNotation.File(context: context, text: file.text, view: file.view,
                    world: file.world, notation: file.notation, excluded: file.excluded, unchecked: file.unchecked)
            }
            var bytes = Array(clean.utf8)
            func replacementBytes(_ start: Int, _ end: Int, _ replacement: String) -> [UInt8] {
                let lines = bytes[start..<end].filter { $0 == 10 }.count
                return Array((replacement + String(repeating: "\n", count: lines)).utf8)
            }
            for (start, end, at) in genericRanges {
                var fragment = Array(bytes[start..<end])
                for (lower, upper, replacement) in replacements.reversed()
                where lower >= start && upper <= end {
                    fragment.replaceSubrange((lower - start)..<(upper - start),
                        with: replacementBytes(lower, upper, replacement))
                }
                applications.append(Application(text: String(decoding: fragment, as: UTF8.self), address: at,
                    bound: NameSet(bound.map(\.text)).union(["Self"])))
            }
            for (start, end, replacement) in replacements.reversed() {
                // Preserve source line breaks in the rewritten view so refusal
                // addresses still refer to the source-bound input.
                bytes.replaceSubrange(start..<end, with: replacementBytes(start, end, replacement))
            }
            let view = String(decoding: bytes, as: UTF8.self)
            let world = try WhereJudge.read(view, lent: builders, contextV2: version == 2)
            return CourtNotation.File(context: context, text: file.text, view: view, world: world,
                notation: try NotationScope(world.clean), excluded: file.excluded, unchecked: file.unchecked)
        }
        return Resolution(files: resolved, applications: applications)
    }

    /// Checks the application that qualification exposed before an equality
    /// can use its nominal head. Existing membership derivations supply bounds.
    static func applications(_ applications: [Application], in world: WhereJudge.World) throws {
        for application in applications {
            func check(_ expression: DefinitionReduction.Expression) throws {
                switch expression {
                case let .field(owner, _): try check(owner)
                case let .application(name, arguments):
                    guard !application.bound.contains(name) else {
                        try WhereJudge.fail("\(application.address): qualified generic application depends on bound name '\(name)'; its application context is outside this reading")
                    }
                    for argument in arguments { try check(argument) }
                    guard !arguments.isEmpty else { return }
                    guard let parameters = world.parameters[name], parameters.count == arguments.count else {
                        try WhereJudge.fail("\(application.address): generic application '\(expression.text)' has no matching declaration parameters")
                    }
                    if let conditions = world.genericUnsupported[name], !conditions.isEmpty {
                        try WhereJudge.fail("\(application.address): generic application '\(expression.text)' carries unread conditions")
                    }
                    guard !(world.genericRequirements[name] ?? []).isEmpty else { return }
                    guard let conformer = world.conformers[name], let proto = conformer.protocols.sorted().first(
                        where: {
                        world.protocolParents[$0] != nil && WhereJudge.inheritedProtocols([$0], world)
                            .allSatisfy { world.gatedProtocols[$0] == nil }
                    }) else {
                        try WhereJudge.fail("\(application.address): generic applicability of '\(expression.text)' has no unconditional conformance path in this fragment")
                    }
                    var counted = 0
                    do {
                        let refusals = try GenericMembership.check(expression.legacy, proto: proto,
                            site: expression.text, world: world, rigid: [], counted: &counted)
                        if !refusals.isEmpty { throw WhereJudge.Failure.refused(refusals) }
                    } catch WhereJudge.Failure.refused(let messages) {
                        throw WhereJudge.Failure.refused(messages.map { application.address + ": " + $0 })
                    } catch WhereJudge.Failure.unsupported(let messages) {
                        throw WhereJudge.Failure.unsupported(messages.map { application.address + ": " + $0 })
                    }
                }
            }
            try check(DefinitionReduction.parse(application.text))
        }
    }
}
