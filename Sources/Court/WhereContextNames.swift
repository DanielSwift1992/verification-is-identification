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
        let nameBindings: ContextNameBinding.Index?
    }

    /// Alias-head cycles cannot supply a nominal ground. Parameters are bound
    /// leaves, even when a module alias has the same short spelling.
    static func aliasCycles(_ world: WhereJudge.World, names: NameSet, source: String) throws {
        var done = NameSet(), active = NameSet()
        func visit(_ name: String) throws {
            guard let alias = world.aliases[name] else { return }
            if active.contains(name) {
                try WhereJudge.fail("\(world.addresses[name] ?? source + ":1"): cyclic alias resolution at '\(name)' has no declared nominal ground")
            }
            guard !done.contains(name) else { return }
            active.insert(name)
            if case let .application(next, _) = try DefinitionReduction.parse(alias.body),
               !alias.parameters.containsName(next.text) { try visit(next.text) }
            active.remove(name)
            done.insert(name)
        }
        for name in world.aliases.keys.sorted() where names.contains(name) { try visit(name) }
    }

    static func resolve(_ files: [CourtNotation.File], selected: String,
                        version: Int) throws -> Resolution {
        var origins: [Key: [Origin]] = [:]
        let modules = Set(files.map { key($0.context.module) })
        for (index, file) in files.enumerated() {
            let module = key(file.context.module)
            for name in file.world.fileTypes {
                origins[key(name), default: []].append(Origin(file: index, name: name,
                    module: module, line: file.world.declared[name]?.first ?? 1))
            }
        }
        let builders = try files.reduce(into: NameSet()) {
            $0.formUnion(try WhereJudge.declaredBuilders($1.world.clean))
        }
        let readings = try WhereJudge.lexicalReadings(files.map { ($0.context.source, $0.world.clean) },
            scope: .notation, lent: builders, carrying: true)
        let tapes = zip(files, readings).map { file, reading -> StructuralSource.Lexed in
            let scanned = reading.tape
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
        let imports = try ContextImports(files, words: tapes.map(\.words))
        let nameBindings: ContextNameBinding.Index? = try ContextNameBinding.read(files, selected: selected, reading: readings, imports: imports)
        if let proof = nameBindings { try proof.replay(proof.certificate) }
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
            Set(imports.visible(file.context).map(key))
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
            // Tokens and lexical owners share this one line-preserving view.
            // Original bytes/hash remain in File.text and File.context.
            let clean = file.world.clean
            let aliasScopes = try WhereJudge.readAliasSpans(WhereJudge.outsideBodies(file.world.clean), lent: builders)
                .filter { !$0.fields[1].isEmpty }
            let declarationTable = Dictionary(uniqueKeysWithValues: nameBindings!.certificate.declarations.map { ($0.place, $0) })
            func spelling(_ place: ContextNameBinding.Place) -> String {
                let parts = place.parts
                if declarationTable[place]?.kind == ScalarName("parameter") { return parts.last! }
                if declarationTable[place]?.kind == ScalarName("associatedtype") { return "Self." + parts.last! }
                guard parts.count > 1 else { return place.text }
                let symbol = symbols[key(parts[1])]?[key(parts[0])] ?? parts[1]
                return ([symbol] + parts.dropFirst(2)).joined(separator: ".")
            }
            func boundNames(_ start: Int, _ end: Int) -> NameSet {
                NameSet(nameBindings!.certificate.references.compactMap { reference in
                    guard reference.input == ScalarName(file.context.input), start <= reference.offset, reference.offset < end,
                          let declaration = declarationTable[reference.declaration],
                          ["parameter", "associatedtype"].containsName(declaration.kind.text) else { return nil }
                    return reference.declaration.parts.last
                })
            }
            // Use the existing structural token reader, including its original
            // byte coordinates; no second identifier alphabet is introduced.
            let tokens = tapes[fileIndex]
            var replacements: [(Int, Int, String)] = [], genericRanges: [(Int, Int, String)] = [], i = 0
            func address(_ index: Int) -> String { file.context.source + ":\(tokens.lines[index])" }
            while i < tokens.words.count {
                let word = tokens.words[i]
                if key(word) == key("import") { i += 2; continue }
                if i > 0 && key(tokens.words[i - 1]) == key(".") { i += 1; continue }
                let offset = tokens.starts[i]
                if let reference = nameBindings!.reference(input: file.context.input, offset: offset) {
                    let rendered: String
                    if let receiver = reference.receiver {
                        rendered = (reference.spelling.text.hasPrefix("Self.") ? "Self" : spelling(receiver))
                            + "." + reference.declaration.parts.last!
                    } else { rendered = spelling(reference.declaration) }
                    var endIndex = i
                    while endIndex + 1 < tokens.words.count && tokens.ends[endIndex] < reference.end { endIndex += 1 }
                    let moduleQualified = modules.contains(key(word)) && endIndex > i
                    if moduleQualified {
                        guard tokens.lines[i] == tokens.lines[min(i + 2, endIndex)] else {
                            try WhereJudge.fail("\(address(i)): a module qualifier across lines is outside this context fragment")
                        }
                        let parts = reference.declaration.parts
                        if parts.count == 2, let origin = (origins[key(parts[1])] ?? []).first(where: { $0.module == key(parts[0]) }) {
                            let declaration = files[origin.file].world
                            let parameters = declaration.parameters[parts[1]] ?? declaration.aliases[parts[1]]?.parameters ?? []
                            if !parameters.isEmpty && (endIndex + 1 == tokens.words.count || key(tokens.words[endIndex + 1]) != key("<")) {
                                try WhereJudge.fail("\(address(i)): generic declaration '\(reference.spelling.text)' needs explicit arguments in this fragment")
                            }
                        }
                        if endIndex + 1 < tokens.words.count, key(tokens.words[endIndex + 1]) == key("<") {
                            guard version == 2 else { try WhereJudge.fail("\(address(i)): qualified generic application requires context/2 applicability grounds") }
                            var end = endIndex + 1, depth = 0
                            repeat {
                                if key(tokens.words[end]) == key("<") { depth += 1 }
                                if key(tokens.words[end]) == key(">") { depth -= 1 }
                                end += 1
                            } while end < tokens.words.count && depth > 0
                            guard depth == 0 else { try WhereJudge.fail("\(address(i)): qualified generic application has unbalanced arguments") }
                            genericRanges.append((offset, tokens.ends[end - 1], address(i)))
                        }
                    }
                    if !WhereJudge.sameName(rendered, reference.spelling.text) {
                        replacements.append((offset, reference.end, rendered))
                    }
                    i = endIndex + 1
                } else {
                    // Only declaration sites can introduce symbols here. Every
                    // reference decision above is the replayed certificate row.
                    if let place = nameBindings!.place(input: file.context.input, offset: offset), place.parts.count == 2,
                       declarationTable[place]?.kind != ScalarName("function") {
                        let rendered = spelling(place)
                        if !WhereJudge.sameName(rendered, word) { replacements.append((offset, tokens.ends[i], rendered)) }
                    }
                    i += 1
                }
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
            var unread = NameMap<String>()
            for (start, end, at) in genericRanges {
                var fragment = Array(bytes[start..<end])
                for (lower, upper, replacement) in replacements.reversed()
                where lower >= start && upper <= end {
                    fragment.replaceSubrange((lower - start)..<(upper - start),
                        with: replacementBytes(lower, upper, replacement))
                }
                let position = clean.utf8.index(clean.utf8.startIndex, offsetBy: start).utf16Offset(in: clean)
                if version == 2, file.context.role == "borrowed",
                   let alias = aliasScopes.first(
                    where: { NSLocationInRange(position, $0.body) }) {
                    let symbol = symbols[key(alias.fields[0])]?[local] ?? alias.fields[0]
                    unread[symbol] = at + " (unapplied generic alias: bound application context)"
                } else {
                    applications.append(Application(text: String(decoding: fragment, as: UTF8.self), address: at,
                        bound: boundNames(start, end).union(["Self"])))
                }
            }
            for (start, end, replacement) in replacements.reversed() {
                // Preserve source line breaks in the rewritten view so refusal
                // addresses still refer to the source-bound input.
                bytes.replaceSubrange(start..<end, with: replacementBytes(start, end, replacement))
            }
            let view = String(decoding: bytes, as: UTF8.self)
            var world = try WhereJudge.read(view, lent: builders, contextV2: version == 2, source: context.source)
            // Preserve the written question separately from its bound view.
            // Positional transport changes no equation or declaration order.
            for (name, original) in file.world.gatedProtocols {
                let boundName = symbols[key(name)]?[local] ?? name
                if world.gatedProtocols[boundName] != nil {
                    world.gatedProtocols[boundName]!.writtenEqualities = original.equalities
                    world.gatedProtocols[boundName]!.writtenUnjudged = original.unjudged
                }
            }
            guard world.gates.count == file.world.gates.count else {
                try WhereJudge.fail("\(context.source):1: bound view changed gate coverage")
            }
            for index in world.gates.indices {
                world.gates[index].writtenEqualities = file.world.gates[index].equalities
                world.gates[index].writtenUnjudged = file.world.gates[index].unjudged
            }
            for (name, values) in symbols {
                for (module, symbol) in values where !WhereJudge.sameName(symbol, name.text) {
                    world.contextSpellings[symbol] = module.text + "." + name.text
                }
            }
            for reference in nameBindings!.certificate.references
            where reference.input == ScalarName(file.context.input) && reference.declaration.parts.count == 2 {
                let rendered = spelling(reference.declaration)
                if reference.spelling.text.contains("."), !rendered.hasPrefix(prefix) {
                    world.contextSpellings[rendered] = reference.spelling.text
                }
            }
            // The existing conditional-declaration boundary prevents an unread
            // bound application from becoming a nominal reflexivity premise.
            world.conditionalDeclarations.formUnion(unread.keys)
            return CourtNotation.File(context: context, text: file.text, view: view, world: world,
                notation: try NotationScope(world.clean), excluded: file.excluded,
                unchecked: (file.unchecked + Array(unread.values)).sorted())
        }
        return Resolution(files: resolved, applications: applications, nameBindings: nameBindings)
    }

    /// Reports the addressed missing or unread member of a supplied owner.
    /// Bound projections and declarations outside the nominal fragment retain
    /// their existing reduction/admission rules.
    static func members(_ files: [CourtNotation.File], in world: WhereJudge.World) throws {
        for file in files {
            for (name, alias) in file.world.aliases.sorted(by: { $0.key < $1.key }) {
                let at = file.context.source + ":\(file.world.certificateLines[name] ?? 1)"
                func boundRoot(_ expression: DefinitionReduction.Expression) -> Bool {
                    switch expression {
                    case let .application(name, _): return alias.parameters.containsName(name)
                    case let .field(owner, _): return boundRoot(owner)
                    }
                }
                func check(_ expression: DefinitionReduction.Expression) throws {
                    switch expression {
                    case let .application(_, arguments):
                        for argument in arguments { try check(argument) }
                    case let .field(owner, axis):
                        try check(owner)
                        if boundRoot(owner) { return }
                        if world.nestedNames.contains(expression.text) { return }
                        if world.namespaces.contains(owner.text) {
                            try WhereJudge.fail("\(at): owner '\(owner.text)' has no declaration '\(axis)'")
                        }
                        let head: String
                        if case let .application(name, arguments) = owner, arguments.isEmpty { head = name.text }
                        else if world.nestedNames.contains(owner.text) { head = owner.text }
                        else { return }
                        guard world.aliases[head] == nil else { return }
                        let source = DefinitionReduction.Source(world: world, rigid: NameSet(alias.parameters))
                        do { _ = try source.memberDefinition(head, axis: axis.text, spelled: expression.text) }
                        catch { try WhereJudge.fail("\(at): \(error)") }
                    }
                }
                try check(DefinitionReduction.parse(alias.body))
            }
        }
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
