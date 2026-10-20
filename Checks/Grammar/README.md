# The source scope map

vi owns `vi-scope-map/1` and the six existing scope names and grants. A client owns its one map. `Tools grammar --scope-map Checks/Grammar/scopes.swift Sources Pages` replaces the repository's default `Schema.scopes`; it does not extend it. The Swift-shaped file is closed metadata, never executed:

```swift
public enum GrammarScopes {
    public static let format = "vi-scope-map/1"
    public static let entries: [(String, String)] = [
        ("Pages/Dictionary", "SurfaceScope"),
        ("Pages", "DemoScope"),
    ]
}
```

Whitespace and non-nested comments are allowed. Literal strings use JSON escapes, without interpolation. Unknown syntax, a different version, an unknown scope, an empty map, non-normal/absolute paths and conflicting entries for the same prefix refuse. Identical entries combine. A prefix ends at a component boundary; the longest matching prefix wins regardless of order. Every read source must be covered, including a source containing no declarations. There is no fallback for an uncovered path. Entries need not all be used by a particular invocation.

`--receipt <file>` writes `vi-grammar-coverage/1`: the map's SHA-256 and each repo-relative source path and selected scope. A consumer keeps source identity (repository/revision/path/hash) separately; resolver cache paths are never map paths. The invoking consumer records the vi revision with this receipt. Multiple maps for one source identity and law revision must agree in bytes, not merely happen to choose the same scope.

`--export-policy <file>` exports `vi-grammar-policy/1` from the actual registered metatypes and their conformances. `policy.json` is that census, checked against the schema by the `scope-map` law. The standalone `ScopeMap.swift` and `GrammarPolicy.swift` are the portable reader: a consumer pins and hashes these sources and this census together. Their code has no application paths or client-provided grants. The policy does not add an executable plugin or grant new Swift semantics.

`--portable` runs that reading and reports source addresses; it explicitly does not compile Swift bodies. The ordinary grammar command still carries the stream into typed mirror objects and asks Swift to build them. Differential controls compare portable and compiler answers for scope, context, neighbours, line position, foreign spans and unregistered characters. This engineering comparison does not replace the compiler law or the fixed-coordinate certificate.

The boundary battery compares fourteen concrete compiler/portable pairs, including closed-block Exempt/DeclarationHead state, a raw escape across overlapping punctuation and balanced interpolation with a nested foreign span. These controls cover those transition rules; they do not prove equivalence of the readers on arbitrary Swift.
