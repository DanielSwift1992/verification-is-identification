import Foundation

/// The notation-independent, byte-bound source context owned by Court v0.4.
/// Addresses identify the caller's declared premises; they do not attest them.
struct CourtContext {
    struct Source {
        let input: String
        let source: String
        let sha256: String
        let namespace: String
        let imports: [String]
        let at: [String: String]
        let importAddresses: [String]
    }
    let sources: [Source]
    let intrinsicSwift: Bool

    static func refuse(_ at: String, _ why: String) throws -> Never {
        try WhereJudge.fail("context \(at): \(why)")
    }

    init(text: String, paths: [String], texts: [String: String]) throws {
        let raw: Any
        do { raw = try JSONSerialization.jsonObject(with: Data(text.utf8)) }
        catch { try Self.refuse("document", "invalid JSON") }
        guard let object = raw as? [String: Any],
              object["schema"] as? String == "vi.court.context/1" else {
            try Self.refuse("schema", "expected vi.court.context/1")
        }
        guard Set(object.keys) == ["schema", "sources", "intrinsics"],
              let entries = object["sources"] as? [[String: Any]],
              let intrinsic = object["intrinsics"] as? [[String: Any]] else {
            try Self.refuse("document", "expected exactly schema, sources and intrinsics")
        }
        var parsed: [Source] = [], seen: Set<String> = []
        for (i, item) in entries.enumerated() {
            let whereAt = "sources[\(i)]"
            guard Set(item.keys) == ["input", "source", "sha256", "namespace", "imports", "at"],
                  let provenance = item["at"] as? [String: Any],
                  Set(provenance.keys) == ["input", "source", "sha256", "namespace", "imports"] else {
                try Self.refuse(whereAt, "unsupported or missing source fields")
            }
            var values: [String: String] = [:], addresses: [String: String] = [:]
            for key in ["input", "source", "sha256", "namespace"] {
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
                  Set(imports).count == imports.count else {
                try Self.refuse(whereAt + ".imports", "imports need distinct names and provenance addresses")
            }
            let input = values["input"]!
            guard seen.insert(input).inserted else {
                try Self.refuse(addresses["input"]!, "duplicate input '\(input)'")
            }
            guard paths.contains(input), let content = texts[input] else {
                try Self.refuse(addresses["input"]!, "undeclared CLI input '\(input)'")
            }
            guard values["sha256"]!.range(of: #"^[0-9a-f]{64}$"#, options: .regularExpression) != nil,
                  courtSHA256(Data(content.utf8)) == values["sha256"]! else {
                try Self.refuse(addresses["sha256"]!, "SHA-256 differs for '\(input)'")
            }
            parsed.append(Source(input: input, source: values["source"]!, sha256: values["sha256"]!,
                namespace: values["namespace"]!, imports: imports, at: addresses, importAddresses: importAddresses))
        }
        guard Set(paths).count == paths.count else { try Self.refuse("sources", "duplicate CLI source") }
        for path in paths {
            guard !seen.contains(path) else { continue }
            try Self.refuse("sources", "supplied input '\(path)' is not declared")
        }
        var swift = false
        for (i, item) in intrinsic.enumerated() {
            let at = "intrinsics[\(i)]"
            guard Set(item.keys) == ["namespace", "version", "exports", "at"],
                  item["namespace"] as? String == "Swift",
                  item["version"] as? String == "vi.court.intrinsic-swift/1",
                  item["exports"] as? [String] == ["Never"], !swift,
                  let provenance = item["at"] as? [String: Any],
                  Set(provenance.keys) == ["namespace", "version", "exports"],
                  let nsAt = provenance["namespace"] as? String, !nsAt.isEmpty,
                  let verAt = provenance["version"] as? String, !verAt.isEmpty,
                  let expAt = provenance["exports"] as? [String], expAt.count == 1, !expAt[0].isEmpty else {
                try Self.refuse(at, "expected the closed Swift/1 export Never with provenance")
            }
            swift = true
        }
        let namespaces = Set(parsed.map(\.namespace))
        for source in parsed {
            guard source.namespace != "Swift" else {
                try Self.refuse(source.at["namespace"]!, "source cannot declare intrinsic namespace Swift")
            }
            for (index, imported) in source.imports.enumerated() {
                guard namespaces.contains(imported) || (swift && imported == "Swift") else {
                    try Self.refuse(source.importAddresses[index], "namespace '\(imported)' has no supplied source or intrinsic")
                }
            }
        }
        sources = parsed
        intrinsicSwift = swift
    }
}
