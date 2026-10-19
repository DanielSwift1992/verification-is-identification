import Foundation

// ═══════════════════════════════════════════════════════════════
// JUDGE — the door of the court: one entry point that routes each pass to the reader that
// owns it. `where` and `count` and the continuation, coverage and application courts are
// this package's questions; the plain court over the company's fragment is
// ``OrganizationJudge``. Tools, the court-library consumer and gate's CLI all enter here.
// ═══════════════════════════════════════════════════════════════

public enum Judge {
    public static func run(_ arguments: [String]) {
        if arguments.first == "where-report" || arguments.first == "where-admit" {
            WhereResponse.run(Array(arguments.dropFirst()), admission: arguments.first == "where-admit")
            return
        }
        if arguments.first == "count" {
            CountCourt.run(Array(arguments.dropFirst()))
            return
        }
        if arguments.first == "replay-continuation" {
            ContinuationCourt.run(Array(arguments.dropFirst()),replay:true)
            return
        }
        if arguments.first == "continue" {
            ContinuationCourt.run(Array(arguments.dropFirst()))
            return
        }
        if arguments.first == "coverage" {
            FiniteCoverageCourt.run(Array(arguments.dropFirst()))
            return
        }
        if arguments.first == "apply" {
            ApplicationCourt.run(Array(arguments.dropFirst()))
            return
        }
        if arguments.first == "diff" || arguments.first == "chain" {
            // The differential seat builds the company, and moved with it (T-0015).
            FileHandle.standardError.write(Data(
                "✗ judge \(arguments[0]) moved with the company: run `swift run ShowcaseTools judge \(arguments[0])` in the showcase package\n".utf8))
            exit(2)
        }
        if arguments.first == "where" {
            WhereJudge.run(Array(arguments.dropFirst()))
            return
        }
        OrganizationJudge.run(arguments)
    }
}
