import Foundation

// ═══════════════════════════════════════════════════════════════
// THE FORM DICTIONARY names how generated code is packed, in one place.
//
// The content of the generated company never depends on these numbers: every reading is
// a fold sum over Pair, so any regrouping renders byte-identical pages (proved by diff,
// DESIGN21 v29–v33). What the numbers set is the PRICE the compiler pays to read the
// code — chain depth, file parallelism, function emission — the same way Design.swift's
// rungs set where a drawing's ink falls. The curve tool measures a form, and
// `generate org N fanout=F` overrides the fanout for one run, so the best value is
// found by sweep, not by taste.
// ═══════════════════════════════════════════════════════════════

enum CodeForm {
    /// Members per slice inside a generated body: the chain becomes a tree of this
    /// fanout, so a reader walks log-fanout levels instead of N members.
    static var sliceFanout = 16

    /// A body longer than this nests into slices; a shorter one stays flat, because a
    /// tree of two is noise.
    static var sliceThreshold = 24

    /// Top-level declarations per generated file: one file is one frontend job, so this
    /// is the unit of type-checking parallelism.
    static let fileDeclarations = 120

    /// Render calls per generated function: one body is one SIL emission, and past a few
    /// thousand statements the frontend dies emitting it (signal 4, DESIGN21 v30).
    static let renderCalls = 200

    /// The form gate: a generated file may not exceed this many top-level declarations.
    /// The generators hold themselves under it by construction; the gate catches the
    /// future edit that would quietly regrow a wall of declarations in one job.
    static let fileDeclarationLimit = 150

    /// Reads `fanout=N` from generate's arguments: the sweep's one dial.
    static func applyOverrides(_ args: [String]) {
        for a in args
        where a.hasPrefix("fanout=") {
            if let f = Int(a.dropFirst("fanout=".count)), f >= 2 {
                sliceFanout = f
                sliceThreshold = f + f / 2
                print("form: fanout=\(f), threshold=\(sliceThreshold)")
            }
        }
    }
}
