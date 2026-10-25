# Grammar carrier: the judged input and the source reader

The grammar law presents formations to a child Swift compiler. The builders in Sources/GrammarLexicon/Mirror.swift require the declared scope/context grants for emitted atoms, admit Formation references, and require only LintAtom in Exempt. The compiler resolves the emitted Swift names. This judgment concerns the presented formations, conditional on the carrier having read the declared source correctly; it does not establish source byte coverage or reference bindings.

Law §T′ requires reader rules that decide which bytes matter to be declared as types. A derivation binds every source reference to a place and accounts for every input byte; the court checks the derivation against that declaration. Correctness of replay and of the type checker are named premises, not consequences of the child build.

## Carrier delivery (T0097 part 1)

One plan assigns a distinct destination to each discovered input path and to the generated manifest and copied lexicon, lattice, Alphabet and Notation files. Destination keys use Foundation case-insensitive folding and Swift's canonical string equality, so case aliases refuse before writing with both origins even on a case-sensitive volume. Before deduplicating repeated input arguments, byte-distinct but canonically equal source paths also refuse with both origins; a normalization-sensitive volume cannot silently lose one discovered path. This deliberately refuses aliases rather than qualifying the guarantee only for APFS. Listing, reading and writing errors refuse; writes do not replace existing files. Copies include nested Swift files, every planned file is read back and compared byte for byte, and the recursive Swift-file inventory of each target root must equal the plan. The carrier count is taken from those verified reads, repeated after the child build. Only then may the command report that the emitted formations build. This host delivery check is not a derivation of the reader's word, span or context choices.

Checks/grammar-chunks.py retains the formation-group controls and exercises the same production plan with injected write errors for the manifest, lexicon, lattice, Alphabet, Notation and source carrier. Missing or changed bytes, an extra Swift input (including a nested one), a repeated or case-folded destination, canonically equal source spellings, an overwrite and an incomplete roster refuse. Nested planned Swift inputs are copied and verified. The CLI controls reject the original colliding pair and T-A/T_a with both source addresses, reject the actor by itself, and accept the ordinary neighbour with one read-back carrier. On a non-root Unix host a chmod-000 subdirectory also refuses with its address. These are finite regression observations; the delivery construction is the unique plan, non-overwriting writes and mandatory verification, not the sample count.

## Open debt

T0095/Linter is open. No VC23a-form nonexpressibility proof or admitted exception is claimed. The portable findings path (Linter.run, --portable) runs no child type check and shares the reader obligation. Finite observations below expose gaps; they do not establish the general relation.

| Location | R | C | K | Removal criterion |
| --- | --- | --- | --- | --- |
| Sources/Tools/Grammar/Linter.swift: glyphTable, wordSpellings, punctuationSpellings, carried and run | Read every byte of the declared input roster according to a type-declared grammar, bind every source reference to the live declaration it denotes, and present precisely the resulting formations | Arguments, ordered path roster, original UTF-8 bytes, scope assignments, live Alphabet/Schema, actual child-build sources and read derivation | Registry lookups and procedural word/span/context classification submit a type tree to Mirror for admission; original bytes, reference bindings and the full read derivation are not judged. Carrier delivery is checked as described above, not admitted as a full read derivation | Declare the reader relation as types and supply its source-bound derivation and court: full byte coverage, reference binding and classification under that declaration. Keep the input-roster/carrier bijection and its refusal controls. Name replay/type-checker correctness as premises. T0097 part 2 routes opaque bounds through the common scalar lexer; its raw-string-hidden declaration now refuses. Byte coverage, source binding and the read derivation remain open. Remove the procedural reader only once these obligations have that owner. |

| Gap | Source address | Required refusal/control |
| --- | --- | --- |
| Distinct paths can collapse to one carrier name (delivery repaired by T0097 part 1) | carrierName preserves the former spelling; CarrierPlan rejects a repeated destination, requires a roster bijection and verifies written bytes and inventory | Two source paths differing only by nonidentifier characters refuse with both paths before a child build. Failed or missing writes refuse instead of contributing to the reported count. |
| Raw-string escape handling could swallow a declaration (delivery through shared spans repaired by T0097 part 2) | Linter.carried and GrammarPolicy.findings consume Judge.sourceSpans; the old foreign-span scanners are removed | A source in DemoScope containing a raw string with the bytes `#"\"#` followed by `actor Hidden {}` must refuse, just as the visible actor does. Every consumed span must be accounted for under the declared grammar. |

The collision input places `actor T0095Hidden {}` in `Sources/Examples/T0095-A.swift` and `enum T0095Kept {}` in `Sources/Examples/T0095_A.swift`. Both paths select DemoScope and sanitize to the same carrier name. The actor-only file is the refusal control; adding the other path must not erase that obligation.

The raw-span input is `Sources/Examples/T0095RawSpan.swift` in DemoScope:

```swift
enum X { static let s = #"\"# }
actor Hidden {}
enum Y { static let t = "" }
```

The visible `actor Hidden {}` alone is the refusal control. Part 1 did not repair span classification. Part 2 makes this input refuse in both grammar modes: the owner lexer closes the raw string at its hash-delimited quote and the following actor reaches the unchanged grammar grants. Incomplete opaque forms refuse at their opener, with original line and byte address. Compiler grammar refusals retain the named read-back carrier address; this is not a derivation of original-source reference bindings. Historically, with the reader body of 85604916 unchanged, the grammar law passed both inputs (exit 0) and refused both controls (exit 1); the receipt with input and log hashes is held with task T0095 and is not a proof of this relation. The path-collision repair does not discharge the remaining reader debt. `removal_tasks` in Checks/dependency-boundary.json links to this record.
