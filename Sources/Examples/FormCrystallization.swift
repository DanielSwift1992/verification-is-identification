import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// A DOMAIN names crystallization of code form. [Matter §5 shape, measurements: the curve]
//
//   Σ         packings of one generated statement (fanout 16, 32, 64 — the measured set)
//   PAIR      two packings side by side (the pair COMPARE reads)
//   COMPARE   cost comparison: does packing x build faster than y? Measured by
//             `swift run Tools curve --fanout 16,32,64 3200`: 79s, 68s, 61s.
//   NULL      the unpacked statement itself: the content every packing regroups
//   I1        groupings of a finite statement → finitely many packings          ✓
//   I2        the content is fixed during comparison (byte-identical renders)    ✓
//   I3        a packing measured slower is excluded for good (the sweep's records)     ✓
//   A4        unique cheapest packing, depends on the encoding:
//               cost (build seconds)    → |S| = 1   (conforms: fanout 64)
//               content (rendered bytes) → |S| > 1  (all packings render the same)
//
// The second verdict is the safety of the whole campaign, stated as a refusal: under
// the content encoding no packing can be told from another, so re-packing can break
// nothing — and the type checker rejects the crystallization claim for exactly that
// reason. Same code, two encodings, two verdicts: the lens fixes |S|.
// ═══════════════════════════════════════════════════════════════

/// Code form under the COST encoding crystallizes: of the three measured packings the
/// build clock orders strictly (79s, 68s, 61s at N = 3200), one survivor remains, the
/// fanout of sixty-four the form dictionary ships. The type checker certifies the claim
/// by accepting this conformance; the measurements stand in `CodeForm` and on the
/// curve page, each with the run that produced it.
public struct PackingUnderCost: SystemCrystallizes {
    public typealias Sigma       = Three              // the measured packings (I1)
    public typealias Left        = Cell<
        Never,
        Never
    > // the packing pair COMPARE reads
    public typealias Right       = Cell<
        Never,
        Never
    >
    public typealias Cache       = Grew<
        Never,
        Never
    > // slower packings ACCUMULATE as excluded, append-only (I3)
    public typealias SolutionSet = Never              // unique cheapest: |S| = 1, fanout 64
    public typealias Equality    = Verdict<Never>     // faster or not: decidable by the clock (A3)
}

/// Code form under the CONTENT encoding carries the whole set: every measured packing
/// renders the same 471 pages byte for byte, so no reading tells one from another and
/// `|S| = 3`. The solution set is a genuine `Pair` of survivors, the case `Unique`
/// excludes — and that refusal is the campaign's safety: re-packing cannot change what
/// the code states.
public struct PackingUnderContent {
    public typealias SolutionSet = Cell<
        Three,
        Never
    > // |S| > 1: the fold-equivalence class, indistinguishable by content
}
// `extension PackingUnderContent: SystemCrystallizes {}` is rejected: SolutionSet is
// not Unique. Same packings, two encodings, two verdicts: the lens fixes |S|.
