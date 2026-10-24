import Foundation

/// The notation-independent, byte-bound source context owned by Court v0.4.
/// Addresses identify the caller's declared premises; they do not attest them.
struct CourtContext {
    struct Source {
        let input: String
        let source: String
        let sha256: String
        let namespace: String
        let module: String
        let role: String
        let imports: [String]
        let at: [String: String]
        let importAddresses: [String]
    }
    let sources: [Source]
    let intrinsicSwift: Bool
    let version: Int

    static func refuse(_ at: String, _ why: String) throws -> Never {
        try WhereJudge.fail("context \(at): \(why)")
    }

    init(text: String, paths: [String], texts: NameMap<String>) throws {
        let raw: Any
        do { raw = try JSONSerialization.jsonObject(with: Data(text.utf8)) }
        catch { try Self.refuse("document", "invalid JSON") }
        guard let object = raw as? [String: Any],
              let schema = object["schema"] as? String,
              ["vi.court.context/1", "vi.court.context/2"].contains(schema) else {
            try Self.refuse("schema", "expected vi.court.context/1")
        }
        let second = schema == "vi.court.context/2"
        version = second ? 2 : 1
        guard Set(object.keys) == ["schema", "sources", "intrinsics"],
              let entries = object["sources"] as? [[String: Any]],
              let intrinsic = object["intrinsics"] as? [[String: Any]] else {
            try Self.refuse("document", "expected exactly schema, sources and intrinsics")
        }
        var parsed: [Source] = [], seen = NameSet()
        for (i, item) in entries.enumerated() {
            let whereAt = "sources[\(i)]"
            let scalars: Set<String> = second
                ? ["input", "source", "sha256", "namespace", "module", "role"]
                : ["input", "source", "sha256", "namespace"]
            guard Set(item.keys) == scalars.union(["imports", "at"]),
                  let provenance = item["at"] as? [String: Any],
                  Set(provenance.keys) == scalars.union(["imports"]) else {
                try Self.refuse(whereAt, "unsupported or missing source fields")
            }
            var values: [String: String] = [:], addresses: [String: String] = [:]
            for key in ["input", "source", "sha256", "namespace"] + (second ? ["module", "role"] : []) {
                guard let at = provenance[key] as? String, !at.isEmpty else {
                    try Self.refuse(whereAt + "." + key, "missing provenance address")
                }
                guard let value = item[key] as? String, !value.isEmpty else {
                    try Self.refuse(at, "missing " + key)
                }
                values[key] = value
                addresses[key] = at
            }
            guard let imports = item["imports"] as? [String],
                  let importAddresses = provenance["imports"] as? [String],
                  imports.count == importAddresses.count,
                  imports.allSatisfy({ !$0.isEmpty }), importAddresses.allSatisfy({ !$0.isEmpty }),
                  NameSet(imports).count == imports.count else {
                try Self.refuse(whereAt + ".imports", "imports need distinct names and provenance addresses")
            }
            let input = values["input"]!
            guard seen.insert(input).inserted else {
                try Self.refuse(addresses["input"]!, "duplicate input '\(input)'")
            }
            guard paths.containsName(input), let content = texts[input] else {
                try Self.refuse(addresses["input"]!, "undeclared CLI input '\(input)'")
            }
            guard values["sha256"]!.range(of: #"^[0-9a-f]{64}$"#, options: .regularExpression) != nil,
                  courtSHA256(Data(content.utf8)) == values["sha256"]! else {
                try Self.refuse(addresses["sha256"]!, "SHA-256 differs for '\(input)'")
            }
            parsed.append(Source(input: input, source: values["source"]!, sha256: values["sha256"]!,
                namespace: values["namespace"]!, module: values["module"] ?? values["namespace"]!,
                role: values["role"] ?? (WhereJudge.sameName(input, paths.first) ? "own" : "borrowed"),
                imports: imports, at: addresses, importAddresses: importAddresses))
        }
        guard NameSet(paths).count == paths.count else { try Self.refuse("sources", "duplicate CLI source") }
        for path in paths {
            guard !seen.contains(path) else { continue }
            try Self.refuse("sources", "supplied input '\(path)' is not declared")
        }
        var swift = false
        let exports = second ? ["Never", "String"] : ["Never"]
        let intrinsicVersion = second ? "vi.court.intrinsic-swift/2" : "vi.court.intrinsic-swift/1"
        for (i, item) in intrinsic.enumerated() {
            let at = "intrinsics[\(i)]"
            guard Set(item.keys) == ["namespace", "version", "exports", "at"],
                  WhereJudge.sameName(item["namespace"] as? String, "Swift"),
                  item["version"] as? String == intrinsicVersion,
                  WhereJudge.sameNames(item["exports"] as? [String], exports), !swift,
                  let provenance = item["at"] as? [String: Any],
                  Set(provenance.keys) == ["namespace", "version", "exports"],
                  let nsAt = provenance["namespace"] as? String, !nsAt.isEmpty,
                  let verAt = provenance["version"] as? String, !verAt.isEmpty,
                  let expAt = provenance["exports"] as? [String], expAt.count == exports.count,
                  expAt.allSatisfy({ !$0.isEmpty }) else {
                try Self.refuse(at, second ? "expected the closed Swift/2 exports Never and String with provenance"
                    : "expected the closed Swift/1 export Never with provenance")
            }
            swift = true
        }
        let namespaces = NameSet(parsed.map { second ? $0.module : $0.namespace })
        for source in parsed {
            if second {
                guard ["own", "borrowed"].contains(source.role) else {
                    try Self.refuse(source.at["role"]!, "expected own or borrowed source role")
                }
                guard !WhereJudge.sameName(source.module, "Swift") else {
                    try Self.refuse(source.at["module"]!, "source cannot declare intrinsic module Swift")
                }
            }
            guard !WhereJudge.sameName(source.namespace, "Swift") else {
                try Self.refuse(source.at["namespace"]!, "source cannot declare intrinsic namespace Swift")
            }
        }
        // Validate the supplied declarations before following their imports.
        // A forged intrinsic module is named at its own declaration address.
        for source in parsed {
            for (index, imported) in source.imports.enumerated() {
                guard namespaces.contains(imported) || (swift && WhereJudge.sameName(imported, "Swift")) else {
                    let subject = second ? "module" : "namespace"
                    try Self.refuse(source.importAddresses[index], "\(subject) '\(imported)' has no supplied source or intrinsic")
                }
            }
        }
        sources = parsed
        intrinsicSwift = swift
    }
}
