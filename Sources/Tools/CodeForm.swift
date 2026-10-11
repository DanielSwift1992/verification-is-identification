import Foundation

// Packing parameters for generated code. Curve records historical comparisons.
// Reassociation preserves content under the renderer conditions in FiG1.
// A selected fanout belongs to its workload and environment, without a
// universal optimum implied by the interface witnesses.

enum CodeForm {
    /// Members per generated slice. The historical DESIGN21 v35 comment
    /// reports 79 seconds at sixteen and 66 at sixty-four for N=3200, with
    /// no reported gain beyond that run's variation. This is the selected
    /// default, not a certified universal or permanent minimum. [FiG3–FiG4]
    static var sliceFanout = 64

    /// A body longer than this nests into slices; a shorter one stays flat, because a
    /// tree of two is noise. Held at 1.5 fanouts, the same ratio the override applies.
    static var sliceThreshold = 96

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
