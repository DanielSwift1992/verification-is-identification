import Foundation

// ═══════════════════════════════════════════════════════════════
// JUDGE — the door of the court: one entry point that routes each pass to the reader that
// owns it. `where` and `count` and the continuation, coverage and application courts are
// this package's questions. The plain court over the company's fragment lives with the
// policy it reads, in the showcase (OrganizationCourt, `swift run ShowcaseTools judge`), and
// gate builds it from there (T-0028). Tools, the court-library consumer and gate's CLI all
// enter here.
// ═══════════════════════════════════════════════════════════════

public enum Judge {
    public static func run(_ arguments: [String]) {
        if arguments.first == "cover-law" || arguments.first == "replay-cover-law" {
            ContinuationCourt.runLawCover(Array(arguments.dropFirst()), replay: arguments.first == "replay-cover-law")
            return
        }
        if arguments.first == "roster" || arguments.first == "roster-replay" {
            RosterResponse.run(Array(arguments.dropFirst()), replay: arguments.first == "roster-replay")
            return
        }
        if let question = arguments.first, ["where", "count"].contains(question), arguments.contains("--report") {
            CourtSourcesReport.run(Array(arguments.dropFirst()), question: question)
            return
        }
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
        // The plain court reads the company's fragment against the company's policy, and both
        // live in the showcase now (T-0028).
        FileHandle.standardError.write(Data(
            "✗ the plain court moved with the company: run `swift run ShowcaseTools judge <paths>` in the showcase package\n".utf8))
        exit(2)
    }
}
