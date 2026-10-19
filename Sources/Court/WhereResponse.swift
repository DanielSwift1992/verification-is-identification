import Foundation

/// Addressed judgments of explicitly requested applications in named source snapshots.
/// The byte binding identifies the input; it is not an attestation of an untrusted judge.
public enum WhereResponse {
    public static let inputSchema = "vi.where.requests/1"
    public static let responseSchema = "vi.where.responses/1"
    public static let question = "vi.where.selected-applications/1"

    public struct Source: Codable {
        public let name: String
        public let text: String
    }
    public struct Application: Codable {
        public let kind: String
        public let name: String
        public let line: Int?
    }
    public struct Request: Codable {
        public let id: String
        public let application: Application
    }
    public struct Batch: Codable {
        public let schema: String
        public let question: String
        public let world: Source
        public let definitions: [Source]
        public let requests: [Request]
    }
    public struct Versions: Codable, Equatable {
        public let question: String
        public let reader: String
        public let normalizationCanon: Int
    }
    public enum Outcome: String, Codable {
        case holds
        case notEstablished = "not-established"
        case open
        case unsupported
        case inputError = "input-error"
    }
    public struct Result: Codable {
        public let id: String
        public let application: Application
        public let source: String
        public let line: Int?
        public let construction: String?
        public let outcome: Outcome
        public let equalities: Int
        public let memberships: Int
        public let diagnostics: [String]
    }
    public struct Report: Codable {
        public let schema: String
        public let versions: Versions
        public let requestBytes: String
        public let results: [Result]
    }
    public struct InputFailure: Error, CustomStringConvertible {
        public let description: String
    }

    static var versions: Versions {
        Versions(question: question, reader: "vi.where.flat-declarations/1",
                 normalizationCanon: WhereJudge.canonVersion)
    }

    static func decode(_ data: Data) throws -> Batch {
        let batch: Batch
        do { batch = try JSONDecoder().decode(Batch.self, from: data) }
        catch { throw InputFailure(description: "cannot decode the request: \(error)") }
        guard batch.schema == inputSchema, batch.question == question else {
            throw InputFailure(description: "unsupported request schema or question version")
        }
        guard !batch.requests.isEmpty else {
            throw InputFailure(description: "the request list is empty")
        }
        let ids = batch.requests.map(\.id)
        guard ids.allSatisfy({ !$0.isEmpty }), Set(ids).count == ids.count else {
            throw InputFailure(description: "request IDs must be nonempty and distinct")
        }
        let names = ([batch.world] + batch.definitions).map(\.name)
        guard names.allSatisfy({ !$0.isEmpty }), Set(names).count == names.count else {
            throw InputFailure(description: "source names must be nonempty and distinct")
        }
        return batch
    }

    static func selected(_ application: Application, in prepared: WhereJudge.Prepared)
        throws -> (selection: WhereJudge.Selection, construction: String, line: Int?) {
        let world = prepared.world
        let name = application.name
        guard !name.isEmpty else { throw WhereJudge.Failure.input(["application name is empty"]) }
        if application.kind != "use", application.line != nil {
            throw WhereJudge.Failure.input(["only a use selector takes a line"])
        }
        if world.conditionalDeclarations.contains(name) {
            throw WhereJudge.Failure.unsupported(["conditional declaration '\(name)' is excluded"])
        }
        switch application.kind {
        case "certificate":
            if let alias = prepared.ownAliases[name] {
                guard alias.parameters.isEmpty else {
                    throw WhereJudge.Failure.unsupported(["generic alias '\(name)' is not a parameterless certificate"])
                }
                return (.certificate(name), alias.body, world.certificateLines[name])
            }
            let parts = name.split(separator: ".", omittingEmptySubsequences: false).map(String.init)
            if parts.count == 2, let owner = world.conformers[parts[0]], let body = owner.table[parts[1]] {
                return (.certificate(name), body, world.certificateLines[name])
            }
            if world.declared[name] != nil || (parts.count == 2 && world.presentedBodies.contains(parts[0])) {
                throw WhereJudge.Failure.unsupported(["'\(name)' is not a certificate in the read fragment"])
            }
            throw WhereJudge.Failure.open(["no declared certificate '\(name)' in the world"])
        case "use":
            guard let line = application.line, line > 0 else {
                throw WhereJudge.Failure.input(["a use selector needs a positive source line"])
            }
            let matches = world.uses.indices.filter {
                world.useLines[$0] == line && Data(world.uses[$0].utf8) == Data(name.utf8)
            }
            guard matches.count <= 1 else {
                throw WhereJudge.Failure.unsupported(["the use selector names more than one application on line \(line)"])
            }
            guard let index = matches.first else {
                throw WhereJudge.Failure.open(["no read use '\(name)' on line \(line)"])
            }
            return (.use(index), world.uses[index], line)
        case "conformer":
            if let conformer = world.conformers[name] {
                return (.conformer(name), name + ": " + conformer.protocols.joined(separator: ", "),
                        world.declared[name]?.first)
            }
            if world.declared[name] != nil || world.presentedBodies.contains(name) {
                throw WhereJudge.Failure.unsupported(["'\(name)' is not a conformer in the read fragment"])
            }
            throw WhereJudge.Failure.open(["no declared conformer '\(name)' in the world"])
        default:
            throw WhereJudge.Failure.unsupported(["unknown application kind '\(application.kind)'"])
        }
    }

    static func failed(_ request: Request, source: String, error: Error,
                       construction: String? = nil, line: Int? = nil) -> Result {
        let outcome: Outcome
        let messages: [String]
        switch error {
        case WhereJudge.Failure.unsupported(let reasons): outcome = .unsupported; messages = reasons
        case WhereJudge.Failure.open(let reasons): outcome = .open; messages = reasons
        case WhereJudge.Failure.input(let reasons): outcome = .inputError; messages = reasons
        default: outcome = .inputError; messages = [String(describing: error)]
        }
        return Result(id: request.id, application: request.application, source: source,
                      line: line ?? request.application.line, construction: construction,
                      outcome: outcome, equalities: 0, memberships: 0, diagnostics: messages)
    }

    /// Each valid requested ID gets one result. An unread global dependency may
    /// conservatively make every result unsupported; it never disappears from coverage.
    public static func judge(_ data: Data) throws -> Report {
        let batch = try decode(data)
        let sources = [batch.world] + batch.definitions
        let byName = Dictionary(uniqueKeysWithValues: sources.map { ($0.name, $0.text) })
        let prepared: WhereJudge.Prepared
        do {
            prepared = try WhereJudge.prepare(sources.map(\.name)) { name in
                guard let text = byName[name] else { throw WhereJudge.Failure.input(["missing source '\(name)'"]) }
                return text
            }
            if prepared.excludesConditional {
                throw WhereJudge.Failure.unsupported(["conditional compilation is excluded from this reader fragment"])
            }
            let unread = prepared.world.gates.flatMap { gate in
                gate.unjudged.map { "unread conjunct '\($0)' on '\(gate.head): \(gate.proto)'" }
            } + prepared.world.gatedProtocols.values.sorted(by: { $0.name < $1.name }).flatMap { gate in
                gate.unjudged.map { "unread conjunct '\($0)' on protocol '\(gate.name)'" }
            }
            if !unread.isEmpty { throw WhereJudge.Failure.unsupported(unread) }
        } catch {
            return Report(schema: responseSchema, versions: versions, requestBytes: data.base64EncodedString(),
                          results: batch.requests.map { failed($0, source: batch.world.name, error: error) })
        }
        let results = batch.requests.map { request -> Result in
            var construction: String?
            var line: Int?
            do {
                let found = try selected(request.application, in: prepared)
                construction = found.construction
                line = found.line
                let result = try WhereJudge.evaluate(prepared, selection: found.selection, requireGrounds: true)
                return Result(id: request.id, application: request.application, source: batch.world.name,
                              line: line, construction: construction,
                              outcome: result.refusals.isEmpty ? .holds : .notEstablished,
                              equalities: result.equalities, memberships: result.memberships,
                              diagnostics: result.refusals)
            } catch {
                return failed(request, source: batch.world.name, error: error, construction: construction, line: line)
            }
        }
        return Report(schema: responseSchema, versions: versions, requestBytes: data.base64EncodedString(), results: results)
    }

    static func encoded<T: Encodable>(_ value: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return try encoder.encode(value)
    }

    /// A consumer checks its own expected request, not only producer counters.
    /// A complete report containing any non-holding result does not admit work.
    public static func admits(expected: Data, response: Data) throws -> Bool {
        let batch = try decode(expected)
        let report: Report
        do { report = try JSONDecoder().decode(Report.self, from: response) }
        catch { throw InputFailure(description: "cannot decode the response: \(error)") }
        guard report.schema == responseSchema, report.versions == versions,
              Data(base64Encoded: report.requestBytes) == expected,
              report.results.count == batch.requests.count else { return false }
        let ids = report.results.map { Data($0.id.utf8) }
        guard Set(ids).count == ids.count else { return false }
        let byID = Dictionary(uniqueKeysWithValues: zip(ids, report.results))
        for request in batch.requests {
            guard let result = byID[Data(request.id.utf8)],
                  try encoded(result.application) == encoded(request.application),
                  Data(result.source.utf8) == Data(batch.world.name.utf8),
                  result.outcome == .holds,
                  result.equalities >= 0, result.memberships >= 0,
                  result.equalities > 0 || result.memberships > 0,
                  result.diagnostics.isEmpty, result.construction != nil else { return false }
        }
        return true
    }

    static func run(_ arguments: [String], admission: Bool = false) {
        do {
            if admission {
                guard arguments.count == 2 else {
                    throw InputFailure(description: "usage: judge where-admit <request.json> <response.json>")
                }
                let accepted = try admits(expected: Data(contentsOf: URL(fileURLWithPath: arguments[0])),
                                          response: Data(contentsOf: URL(fileURLWithPath: arguments[1])))
                print(accepted ? "admitted" : "not-admitted")
                if !accepted { exit(1) }
            } else {
                guard arguments.count == 1 else {
                    throw InputFailure(description: "usage: judge where-report <request.json>")
                }
                let report = try judge(Data(contentsOf: URL(fileURLWithPath: arguments[0])))
                FileHandle.standardOutput.write(try encoded(report))
                FileHandle.standardOutput.write(Data([0x0a]))
            }
        } catch {
            // Invalid transport cannot produce a valid empty report.
            let failure = ["schema": responseSchema, "status": "input-error", "message": String(describing: error)]
            if let data = try? encoded(failure) { FileHandle.standardError.write(data + Data([0x0a])) }
            exit(2)
        }
    }
}
