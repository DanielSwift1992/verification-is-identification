import Foundation

/// Complete source coverage for an explicitly requested context/2 question.
/// The court binds bytes; it does not attest a caller's provenance assertions.
enum CourtSourcesReport {
    struct Row {
        let path: String
        let source: String
        var outcome = "empty"
        var equalities = 0
        var memberships = 0
        var readings = 0
        var unchecked: [String] = []
        var diagnostics: [String] = []
        var object: [String: Any] {
            ["path": path, "source": source, "outcome": outcome,
             "equalities": equalities, "memberships": memberships, "readings": readings,
             "unchecked": unchecked, "diagnostics": diagnostics]
        }
    }

    static func aggregate(_ rows: [Row]) -> String {
        for outcome in ["unsupported", "refused", "not-established", "holds"] {
            if rows.contains { $0.outcome == outcome } { return outcome }
        }
        return "empty"
    }

    struct Answer {
        let exit: Int32
        let stdout: Data
        let stderr: Data
    }

    static func run(_ arguments: [String], question: String) {
        let result = answer(arguments, question: question, load: WhereJudge.fileText)
        FileHandle.standardOutput.write(result.stdout)
        FileHandle.standardError.write(result.stderr)
        exit(result.exit)
    }

    /// The transport supplies original named bytes. CLI and the embedded court
    /// call the same question without manufacturing or concatenating sources.
    static func answer(_ arguments: [String], question: String,
                       load: (String) throws -> String) -> Answer {
        var inputs: [[String: String]] = []
        var results: [Row] = []
        var diagnostics: [String] = []
        var outcome = "unsupported"
        do {
            var paths: [String] = [], contextPath: String?, documents = Set<String>()
            var options: [String: String] = [:], reports = 0, i = 0
            while i < arguments.count {
                let word = arguments[i]
                if word == "--report" {
                    reports += 1
                    i += 1
                    continue
                }
                if word.hasPrefix("--") {
                    guard i + 1 < arguments.count, !arguments[i + 1].hasPrefix("--") else {
                        throw WhereJudge.Failure.input(["incomplete source reading option '\(word)'"])
                    }
                    let value = arguments[i + 1]
                    if word == "--context" && contextPath == nil { contextPath = value }
                    else if word == "--document" && documents.insert(value).inserted { }
                    else if question == "count" && ["--predicate", "--encoding", "--sigma"].contains(word)
                                && options[word] == nil { options[word] = value }
                    else { throw WhereJudge.Failure.input(["unsupported or duplicate source reading option '\(word)'"]) }
                    i += 2
                } else {
                    paths.append(word)
                    i += 1
                }
            }
            guard reports == 1, let contextPath else {
                throw WhereJudge.Failure.input(["source reading requires one --report and --context"])
            }
            var texts: [String: String] = [:]
            for path in (paths + [contextPath]).sorted() {
                let raw = try load(path)
                texts[path] = raw
                inputs.append(["path": path, "sha256": courtSHA256(Data(raw.utf8))])
            }
            let context = try CourtContext(text: texts[contextPath]!, paths: paths, texts: texts)
            guard context.version == 2 else {
                throw WhereJudge.Failure.input(["--report requires vi.court.context/2"])
            }
            let own = context.sources.filter { $0.role == "own" }
            guard question != "where" || !own.isEmpty else {
                throw WhereJudge.Failure.input(["where context has no own source"])
            }
            guard documents.isSubset(of: Set(own.map(\.input))) else {
                throw WhereJudge.Failure.input(["--document must name a distinct own source"])
            }
            if question == "where" {
                for source in own.sorted(by: { $0.input < $1.input }) {
                    var row = Row(path: source.input, source: source.source)
                    do {
                        let ordered = [source.input] + paths.filter { $0 != source.input }
                        let prepared = try WhereContext.prepare(ordered, contextPath: contextPath,
                            load: { texts[$0]! }, documents: documents, batch: true)
                        row.unchecked = prepared.world.excludedDefinitions
                        let answer = try WhereJudge.evaluate(prepared)
                        row.equalities = answer.equalities
                        row.memberships = answer.memberships
                        row.diagnostics = answer.refusals
                        row.outcome = answer.refusals.isEmpty ? "holds" : "not-established"
                    } catch let failure as WhereJudge.Failure {
                        switch failure {
                        case .empty: row.outcome = "empty"
                        case .refused: row.outcome = "refused"
                        case .open: row.outcome = "not-established"
                        default: row.outcome = "unsupported"
                        }
                        row.diagnostics = failure.messages
                    } catch {
                        row.outcome = "unsupported"
                        row.diagnostics = [String(describing: error)]
                    }
                    results.append(row)
                }
            } else {
                results = try CountCourt.contextRead(context, texts: texts, documents: documents, options: options)
            }
            outcome = aggregate(results)
        } catch let failure as WhereJudge.Failure {
            diagnostics = failure.messages
        } catch {
            diagnostics = [String(describing: error)]
        }
        let object: [String: Any] = ["schema": "vi.court.sources/1", "question": question,
            "inputs": inputs, "outcome": outcome,
            "results": results.sorted { $0.path < $1.path }.map(\.object), "diagnostics": diagnostics]
        do {
            var data = try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys, .withoutEscapingSlashes])
            data.append(10)
            let status: Int32 = outcome == "holds" ? 0 : (["refused", "not-established"].contains(outcome) ? 1 : 2)
            return Answer(exit: status, stdout: data, stderr: Data())
        } catch {
            return Answer(exit: 2, stdout: Data(), stderr: Data("cannot encode source reading: \(error)\n".utf8))
        }
    }
}
