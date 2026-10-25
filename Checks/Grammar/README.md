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

`--export-policy <file>` exports `vi-grammar-policy/1` from the actual registered metatypes and their conformances. `policy.json` is that census, checked against the schema by the `scope-map` law. `ScopeMap.swift` and `GrammarPolicy.swift` carry the map and portable findings. Opaque bounds now come from `Judge.sourceSpans` in the same pinned Court module (T0097 part 2); this reading is no longer a standalone two-file program. A consumer pins that lexer dependency together with these sources and the census. Existing external ports remain on their older pins until migrated; no cross-port equivalence is asserted. Their code has no application paths or client-provided grants. The policy does not add an executable plugin or grant new Swift semantics.

`--portable` runs that reading and reports source addresses; it explicitly does not compile Swift bodies. The ordinary grammar command still carries the stream into typed mirror objects and asks Swift to build them. Differential controls compare portable and compiler answers for scope, context, neighbours, line position, foreign spans and unregistered characters. This engineering comparison does not replace the compiler law or the fixed-coordinate certificate.

The boundary battery keeps fourteen concrete compiler/portable pairs, including closed-block Exempt/DeclarationHead state, an unread overlapping block comment and balanced interpolation with a nested foreign span. `raw-strings.json` adds fourteen observations for one/multiple hash delimiters, multiline strings, nested interpolation, comments, the original hidden actor, addressed incomplete forms and a refused Character-splitting boundary. Both grammar modes use the common scalar lexer's opaque-span projection; neither scans a closer again. Outside those spans the existing grammar registry still classifies atoms. This projection neither widens the structural court's fragment nor judges interpolated code as a separate grammar body. These controls cover those transition rules; they do not prove equivalence of the readers on arbitrary Swift.
