import Foundation
import XCTest
@testable import Court

final class CountDAGTests: XCTestCase {
    typealias R = DefinitionReduction
    private let base = """
    enum Unit {}
    enum Never {}
    enum Plus<A, B> {}
    typealias Twice<S> = Plus<S, S>
    """
    private func source(_ extra: String = "", identity: Bool = false) throws -> R.Source {
        let text = (identity ? base.replacingOccurrences(of: "Plus<S, S>", with: "S") : base) + "\n" + extra
        return try R.Source(world: StructuralSource(files: [("count.swift", text)]).syntax, rigid: [])
    }
    private func proof(_ text: String, source: R.Source) throws -> (CountCourt.SharedCountProof, Int, R.Expression) {
        let e = try R.parse(text)
        let builder = R.SharedBuilder(source: source, work: R.Work(50_000, phase: "construction"))
        let input = try builder.arena.read(e)
        let count = CountCourt.SharedCounter(builder)
        let root = try count.derive(input)
        return (count.proof, root, e)
    }
    private func replay(_ proof: CountCourt.SharedCountProof, root: Int, input: R.Expression, source: R.Source,
                        limit: Int = 100_000) throws -> Int {
        try CountCourt.replaySharedCount(proof, source: source, work: R.Work(limit, phase: "replay"), roots: [(root, input)]).1[root]
    }
    private func ladder(_ n: Int) -> String {
        "typealias N0 = Unit\n" + (1...n).map { "typealias N\($0) = Twice<N\($0 - 1)>" }.joined(separator: "\n")
    }

    func testLargeNamedCountSharesTermsAndReplaysTheAnswer() throws {
        let s = try source(ladder(20))
        let reader = CountCourt.Reader(source: s)
        XCTAssertEqual(try reader.count(R.parse("N20")), 1_048_576)
        XCTAssertLessThan(reader.construction.nodes, 200)
        XCTAssertLessThan(reader.construction.visits, 2_000)
        let (p, root, input) = try proof("N20", source: s)
        XCTAssertEqual(try replay(p, root: root, input: input, source: s), 1_048_576)
    }
    func testArgumentsAndProjectionOwnersArePartOfTheKey() throws {
        let s = try source("""
        typealias Answer = Never
        enum Box<A, B> {
            typealias Left = Plus<A, Twice<B>>
            typealias Right = Plus<A, Twice<B>>
            typealias Answer = Right
        }
        """)
        let reader = CountCourt.Reader(source: s)
        let root = try R.parse("Box<Unit, Twice<Unit>>")
        let value = try reader.reading(root)
        XCTAssertTrue(value.rightEqualsAnswer)
        XCTAssertEqual(value.actual, 5); XCTAssertEqual(value.declared, 5)
        XCTAssertEqual(try reader.count(R.parse("Plus<Twice<Unit>, Twice<Twice<Unit>>>")), 6)
        XCTAssertEqual(try reader.count(R.parse("Box<Never, Unit>.Left")), 2)
    }
    func testDefinitionEqualityIsNotEqualityOfCounts() throws {
        let s = try source("""
        enum Reading {
            typealias Left = Plus<Unit, Plus<Unit, Unit>>
            typealias Right = Plus<Plus<Unit, Unit>, Unit>
            typealias Answer = Plus<Unit, Plus<Unit, Unit>>
        }
        """)
        let result = try CountCourt.Reader(source: s).reading(R.parse("Reading"))
        XCTAssertFalse(result.rightEqualsAnswer)
        XCTAssertEqual(result.actual, 3); XCTAssertEqual(result.declared, 3)
    }
    func testHeadAndFullReductionHaveSeparateKeys() throws {
        let s = try source("typealias A = Unit")
        let b = R.SharedBuilder(source: s, work: R.Work(50_000, phase: "construction"))
        let t = try b.arena.read(R.parse("Plus<A, Unit>"))
        let head = try b.derive(t, head: true), full = try b.derive(t)
        let r = try R.replayShared(b.proof, source: s, work: R.Work(100_000, phase: "replay"))
        XCTAssertNotEqual(r.ends[head].output, r.ends[full].output)
    }
    func testForgedArithmeticOperandAndRuleAreRefused() throws {
        let s = try source()
        let (p, root, input) = try proof("Plus<Unit, Never>", source: s)
        XCTAssertEqual(try replay(p, root: root, input: input, source: s), 1)
        var bad = p
        guard case let .plus(a, _) = bad.nodes[root].rule else { return XCTFail("missing plus") }
        bad.nodes[root].rule = .plus(a, a)
        XCTAssertThrowsError(try replay(bad, root: root, input: input, source: s))
        bad = p; bad.nodes[root].rule = .unit
        XCTAssertThrowsError(try replay(bad, root: root, input: input, source: s))
        bad = p; bad.nodes[root].input = -1
        XCTAssertThrowsError(try replay(bad, root: root, input: input, source: s))
    }
    func testProofAndTermReferencesCannotCycleOrLookForward() throws {
        let s = try source()
        let (p, root, input) = try proof("Twice<Unit>", source: s)
        var bad = p
        bad.reduction.terms[0] = .field(0, "Left")
        XCTAssertThrowsError(try replay(bad, root: root, input: input, source: s))
        bad = p; bad.reduction.steps[0] = .join(0, 0)
        XCTAssertThrowsError(try replay(bad, root: root, input: input, source: s))
        bad = p; bad.nodes[root].rule = .plus(root, root)
        XCTAssertThrowsError(try replay(bad, root: root, input: input, source: s))
    }
    func testReplayRebindsTheSourceAndTheOriginalQuestion() throws {
        let s = try source()
        let (p, root, input) = try proof("Twice<Unit>", source: s)
        XCTAssertThrowsError(try replay(p, root: root, input: input, source: source(identity: true)))
        XCTAssertThrowsError(try replay(p, root: root, input: R.parse("Plus<Unit, Never>"), source: s))
        XCTAssertEqual(try CountCourt.Reader(source: source(identity: true)).count(input), 1)
    }
    func testPrimitiveInterpretationStillRequiresTheSuppliedRules() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let text = try String(contentsOf: root.appendingPathComponent("Contracts/Court/v0.1/fixtures/Primitive.swift"), encoding: .utf8)
        let files = [("Primitive.swift", text)]
        XCTAssertNoThrow(try CountCourt.checkPrimitiveRules(files, source: StructuralSource(files: files)))
        let changed = [("Primitive.swift", text.replacingOccurrences(of: "public enum Unit: Close {}", with: "public enum Unit: Close { public static var count: Int { 2 } }"))]
        XCTAssertNotEqual(files[0].1, changed[0].1)
        XCTAssertThrowsError(try CountCourt.checkPrimitiveRules(changed, source: StructuralSource(files: changed)))
    }
    func testConstructionReplayAndMemoHitsAllSpendWork() throws {
        let s = try source()
        XCTAssertThrowsError(try CountCourt.Reader(source: s, constructionLimit: 1).count(R.parse("Unit")))
        let (p, root, input) = try proof("Twice<Unit>", source: s)
        XCTAssertThrowsError(try replay(p, root: root, input: input, source: s, limit: 1))
        let work = R.Work(100, phase: "construction")
        let b = R.SharedBuilder(source: s, work: work), t = try b.arena.read(R.parse("Unit"))
        _ = try b.derive(t)
        let remaining = work.remaining
        _ = try b.derive(t)
        XCTAssertLessThan(work.remaining, remaining)
        work.remaining = 0
        XCTAssertThrowsError(try b.derive(t))
    }
    func testCyclesAndIntOverflowAreUnresolved() throws {
        XCTAssertThrowsError(try CountCourt.Reader(source: source("typealias Loop = Loop")).count(R.parse("Loop")))
        let s = try source(ladder(63))
        XCTAssertEqual(try CountCourt.Reader(source: s).count(R.parse("N62")), 4_611_686_018_427_387_904)
        XCTAssertThrowsError(try CountCourt.Reader(source: s).count(R.parse("N63"))) { error in
            XCTAssertTrue(String(describing: error).contains("count exceeds Int.max"))
        }
    }
}
