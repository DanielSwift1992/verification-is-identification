# Where response contract 1

This route judges an explicit list of applications in one named world and its supplied definition sources. It returns a result for each requested ID. It does not assert that the whole Swift program is valid, that every application was requested, or that a different judge implementation is equivalent. The existing `judge where` text interface and questions suite0.1 remain separate contracts.

A request is UTF-8 JSON. Sources are inline snapshots; no source paths are opened by the batch reader. `world` is the declaration world; `definitions` lends aliases under the same restrictions as the legacy reader. Source names and request IDs must be nonempty and distinct. `requests` must be nonempty. For example:

```json
{
  "schema": "vi.where.requests/1",
  "question": "vi.where.selected-applications/1",
  "world": {
    "name": "example.swift",
    "text": "enum A {}\nenum Match<L, R> {}\nprotocol Admitted {}\nextension Match: Admitted where L == R {}\ntypealias Claim = Match<A, A>\n"
  },
  "definitions": [],
  "requests": [
    {"id": "claim-1", "application": {"kind": "certificate", "name": "Claim"}}
  ]
}
```

The declared selectors are `certificate` (a parameterless alias, including `Owner.Member` in a read conformer's table), `use` (the exact read metatype expression without `.self`, plus its positive source `line`), and `conformer` (a declared conformer and all its inherited gated-protocol obligations). A use selector matching more than one occurrence on its line is unsupported. Other selector kinds are addressed unsupported. The optional `line` belongs only to use selectors. A missing selected declaration or use is open. A known declaration outside the read fragment is unsupported. Addresses are logical source names and selectors, with source lines where the reader has one.

The report schema is `vi.where.responses/1`. It carries question `vi.where.selected-applications/1`, reader fragment `vi.where.flat-declarations/1`, normalization canon4, and `requestBytes`: the exact input JSON bytes encoded as base64. This includes source contents, names, definitions, IDs and selectors. Changing even JSON whitespace creates a different byte binding. It is a binding to the requested input, not a signature, an execution attestation, or proof that an untrusted implementation ran those rules.

Each result contains its ID, application, source, optional line/construction, outcome, equality/membership counts and diagnostics. The report's versions apply to every result, including unsupported ones. A located construction is retained even when its evaluation fails. Global lexical/preflight boundaries conservatively make every requested result unsupported; the report does not hide an unread neighbor behind a successful one.

| Outcome | Meaning in this profile |
| --- | --- |
| `holds` | At least one obligation was evaluated for the selected application; every evaluated equality/membership held in this fragment. |
| `not-established` | The selected obligations were read, but the required result was not established. Different normal forms do not prove general type inequality. |
| `open` | The selected declaration/use, a requested obligation, or required membership grounds are not supplied by the read world. |
| `unsupported` | Reading, generic applicability, excluded conditional declarations, unread conjuncts or bounded normalization cannot establish the requested result. |
| `input-error` | The selector is malformed or another input operation fails. Malformed transport is reported separately and is not a valid empty batch. |

Conditional compilation blocks and any unread gate conjunct prevent admission in this profile. Generic membership remains unsupported. Every directly listed or reachable protocol required by a selected conformer, gate or membership must have declared grounds; a missing node is open. Membership through a conformer with gated-protocol obligations is also unsupported: the declaration of conformance does not discharge those dependent obligations, and this profile does not perform that dependency closure. Selecting its conformer separately does not automatically discharge the membership request. For supported plain membership, a presented conformer that does not carry a declared required protocol is not-established. Existing reader and reduction boundaries are preserved; this is not a complete grammar or an automatic construction of sufficient representations.

```sh
swift build --product Tools
.build/debug/Tools judge where-report request.json > response.json
.build/debug/Tools judge where-admit request.json response.json
./check.sh --only response
```

`where-report` exits0 when it produces a well-formed report, including reports containing unsupported, open or not-established results. Its exit alone is never admission. `where-admit` checks the consumer's own expected request bytes, all versions, exact ID coverage without omissions/duplicates, selectors and source names, then requires every result to hold with a nonempty obligation count and no diagnostics. It exits0 only for admission,1 for non-admission, and2 for input/decoding errors. A malformed request or unavailable request/response file exits2 with an `input-error` JSON diagnostic on stderr. The old CLI keeps its original text and exit meanings.

The callable Swift API is `WhereResponse.judge(Data)` and `WhereResponse.admits(expected:response:)`. They return or throw without using the CLI exit boundary. Admission checks the report envelope from an implementation whose semantics the caller has accepted; it cannot establish the honesty of an arbitrary producer from JSON alone. Gate delivery and independent replacement implementations remain separate work.
