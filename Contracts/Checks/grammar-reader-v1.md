# Grammar carrier: the judged input and the source reader

The grammar law presents formations to a child Swift compiler. The builders in Sources/GrammarLexicon/Mirror.swift require the declared scope/context grants for emitted atoms, admit Formation references, and require only LintAtom in Exempt. The compiler resolves the emitted Swift names. This judgment concerns the presented formations, conditional on the carrier having read the declared source correctly; it does not establish that correspondence.

Law §T′ requires reader rules that decide which bytes matter to be declared as types. A derivation binds every source reference to a place and accounts for every input byte; the court checks the derivation against that declaration. Correctness of replay and of the type checker are named premises, not consequences of the child build.

## Open debt

T0095/Linter is open. No VC23a-form nonexpressibility proof or admitted exception is claimed. The portable findings path (Sources/Tools/Grammar/Linter.swift:448–463) runs no child type check and shares the reader obligation. Finite observations below expose gaps; they do not establish the general relation.

| Location | R | C | K | Removal criterion |
| --- | --- | --- | --- | --- |
| Sources/Tools/Grammar/Linter.swift:53–76, 103–366, 432–443, 541–549 | Read every byte of the declared input roster according to a type-declared grammar, bind every source reference to the live declaration it denotes, and present precisely the resulting formations | Arguments, ordered path roster, original UTF-8 bytes, scope assignments, live Alphabet/Schema, actual child-build sources and read derivation | Registry lookups and procedural word/span/context classification submit a type tree to Mirror for admission; original bytes, reference bindings and the full read derivation are not judged | Declare the reader relation as types and supply its source-bound derivation and court: full byte coverage, reference binding and classification under that declaration. Establish a bijection between the input path roster and emitted carrier files; refuse duplicate carrier identities, overwrites, missing or failed writes. Name replay/type-checker correctness as premises. Refusal controls must cover both cases below, including the raw-string-hidden declaration. Remove the procedural reader only once these obligations have that owner. |

| Gap | Source address | Required refusal/control |
| --- | --- | --- |
| Distinct paths can collapse to one carrier name | Linter.swift:360 sanitizes the type name; :546 sanitizes the carrier path; :547–549 suppress write errors; :589 reports the original input count | Two source paths differing only by nonidentifier characters must not silently overwrite a carrier. A refused declaration in either file must remain represented and refuse; the input-roster/carrier bijection must be checked. |
| Raw-string escape handling can swallow a declaration | Linter.swift:249–256 treats the backslash inside a raw string as escaping its closer; :355–358 merges unclosed frames | A source in DemoScope containing a raw string with the bytes `#"\"#` followed by `actor Hidden {}` must refuse, just as the visible actor does. Every consumed span must be accounted for under the declared grammar. |

The collision input places `actor T0095Hidden {}` in `Sources/Examples/T0095-A.swift` and `enum T0095Kept {}` in `Sources/Examples/T0095_A.swift`. Both paths select DemoScope and sanitize to the same carrier name. The actor-only file is the refusal control; adding the other path must not erase that obligation.

The raw-span input is `Sources/Examples/T0095RawSpan.swift` in DemoScope:

```swift
enum X { static let s = #"\"# }
actor Hidden {}
enum Y { static let t = "" }
```

The visible `actor Hidden {}` alone is the refusal control. These exact inputs name the outstanding obligation; no new control or repair is implemented in the carrier. With the reader body of 85604916 unchanged, the grammar law passed both inputs (exit 0) and refused both controls (exit 1); the receipt with input and log hashes is held with task T0095 and is not a proof of this relation. `removal_tasks` in Checks/dependency-boundary.json links to this record.
