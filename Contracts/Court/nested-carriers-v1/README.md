# Nested declarations in enum carriers

A nested enum belongs to its lexical enclosing enum independently of that owner's conformances. `Company.Slice` and `Ledger.Slice` are different declared places; neither is a file-scope `Slice`. ContextNameBinding supplies and replays their full T0105 identities. No additional lookup by a short name is introduced. Where and contextual count reading use the same NotationScope and bound declaration projection.

A conforming owner retains its parents, member fields, body witness and obligations. It is not converted into a plain namespace. NotationScope reads each admitted child separately; the parent's member projection skips that child's balanced declaration, so the child's fields and body do not become the parent's. Member access is reset after the child. Only the existing plain enum namespace is omitted as a carrier. Generic enclosing types and non-enum nested declarations remain outside this finite fragment.

The contract declares a positive use of two carriers with equal short child names and different full places, and a qualification `Box.Leaf` made ambiguous by two imported modules. The latter refuses at the source reference. The native compiler checks the same modules. Unit controls also retain the parent's fields/body, preserve internal access after a child, and refuse the neighbouring generic-container and nested-struct forms.

This is an extension of the finite source-reading fragment, not a proof for arbitrary Swift. Source-to-reading correctness remains debt T0105-R/T0141; physical execution and comparison remain debt T0105-C. The finite contract is not a proof of reader correctness or of non-expressibility in the medium. No physical section 12 result is advanced.
