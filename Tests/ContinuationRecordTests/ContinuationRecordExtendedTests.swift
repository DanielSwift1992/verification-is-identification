import Foundation
import XCTest
import ContinuationRecord

final class ContinuationRecordExtendedTests: XCTestCase {
    typealias C = ContinuationCore
    typealias R = RecordExtension
    private let source: C.Shape = .pair(.leaf("S"),.leaf("S"))
    private var whole: C.WholeReading { .init(source:source,edges:[]) }
    private var equalOutput: C.WholeReading { .init(source:source,edges:[.init(address:[],left:[.left],right:[.right])]) }
    private var q: C.Places { C.sourcePlaces(source) }
    func testImagePromiseAndHiddenCodomainAreIndependentOfSourceShape() throws {
        let dup: C.Places = .pair(.leaf([.left]),.leaf([.left]))
        let other: C.Places = .pair(.leaf([.right]),.leaf([.right]))
        let hs = [C.ActionMember(address:[.left],image:dup),C.ActionMember(address:[.right],image:other)]
        let data = R.encodeImage(whole:whole,image:dup,promise:equalOutput.edges,hiddenActions:hs)
        let w = try R.read(data,mode:.image), c = try R.derive(w)
        XCTAssertTrue(try R.verify(c,world:w)); XCTAssertEqual(c.image?.images.count,2)
        let wrong = R.encodeImage(whole:whole,image:q,promise:equalOutput.edges,hiddenActions:hs)
        XCTAssertThrowsError(try R.read(wrong,mode:.image)) { XCTAssertTrue(String(describing:$0).contains("record.image")) }
        let twoSorts = C.WholeReading(source:.pair(.leaf("S"),.leaf("T")),edges:[])
        let foreign = R.encodeImage(whole:twoSorts,image:.leaf([.left]),hiddenActions:[.init(address:[],image:.leaf([.right]))])
        XCTAssertThrowsError(try R.read(foreign,mode:.image)) { XCTAssertTrue(String(describing:$0).contains("record.hiddenActions[0].image[0]")) }
        let marginal = try R.read(R.encodeImage(whole:whole,image:.leaf([.left])),mode:.image)
        XCTAssertTrue(try R.verify(R.derive(marginal),world:marginal))
    }
    func testAgreementBindingsAndAllThreeObstructions() throws {
        let data = try R.encodeAgreement(whole:whole,output:equalOutput,question:q,boundOutputs:.leaf([.left]),boundSources:.leaf([.left]))
        let w = try R.read(data,mode:.agreement), c = try R.derive(w)
        guard case let .constructed(p)? = c.agreement?.conclusion else { return XCTFail("expected a plan") }
        XCTAssertEqual(p.residualLeaves.count,1); XCTAssertTrue(try R.verify(c,world:w))
        let unavailable = try R.read(R.encodeAgreement(whole:whole,output:.init(source:.leaf("T"),edges:[]),question:q,promiseDeclared:false),mode:.agreement)
        let missing = try R.derive(unavailable)
        guard case .unavailable? = missing.agreement?.conclusion else { return XCTFail("missing unavailable witness") }
        XCTAssertFalse(try R.verify(missing,world:unavailable))
        let wrongSort = try R.read(R.encodeAgreement(whole:.init(source:.pair(.leaf("S"),.leaf("T")),edges:[]),output:equalOutput,question:q,
            boundOutputs:.leaf([.left]),boundSources:.leaf([.right])),mode:.agreement)
        let wrong = try R.derive(wrongSort)
        guard case .wrongSort? = wrong.agreement?.conclusion else { return XCTFail("missing sort witness") }
        XCTAssertFalse(try R.verify(wrong,world:wrongSort))
        let conflicting = try R.read(R.encodeAgreement(whole:whole,output:equalOutput,question:q,boundOutputs:q,boundSources:q),mode:.agreement)
        let conflict = try R.derive(conflicting)
        guard case .incompatible? = conflict.agreement?.conclusion else { return XCTFail("missing class witness") }
        XCTAssertFalse(try R.verify(conflict,world:conflicting))
    }
    func testMissingCutsExtraAxesAndRecordSubstitutionRefuseAtAddresses() throws {
        let text = String(decoding:R.encodeImage(whole:whole,image:.leaf([.left])),as:UTF8.self)
        for (bad,address) in [(text.replacingOccurrences(of:"\"place\":[0]",with:"\"place\":[]"),"record.image.place"),
                              (String(text.dropLast()) + ",\"question\":{\"place\":[0]}}","record.question"),
                              ("\u{FEFF}" + text,"record")] {
            XCTAssertThrowsError(try R.read(Data(bad.utf8),mode:.image)) { XCTAssertTrue(String(describing:$0).contains(address),String(describing:$0)) }
        }
        let missing = try R.encodeAgreement(whole:whole,output:equalOutput,question:q,boundOutputs:.leaf([.left]))
        XCTAssertThrowsError(try R.read(missing,mode:.agreement)) { XCTAssertTrue(String(describing:$0).contains("record.boundSources")) }
        let mismatch = try R.encodeAgreement(whole:whole,output:equalOutput,question:q,boundOutputs:q,boundSources:.leaf([.left]))
        XCTAssertThrowsError(try R.read(mismatch,mode:.agreement)) { XCTAssertTrue(String(describing:$0).contains("record.boundSources")) }
        let a = try R.read(Data(text.utf8),mode:.image), b = try R.read(R.encodeImage(whole:whole,image:.leaf([.right])),mode:.image)
        XCTAssertThrowsError(try R.verify(R.derive(a),world:b)) { XCTAssertTrue(String(describing:$0).contains("certificate.record")) }
    }
    func testRepeatDoesNotAssertU7ForAnOptionalVisibleFamily() throws {
        let s: C.Shape = .pair(.leaf("S"),.pair(.leaf("S"),.leaf("S")))
        let places = C.sourcePlaces(s)
        let r = C.Reading(whole:.init(source:s,edges:[.init(address:[],left:[.left],right:[.right,.left])]),
            observation:.leaf([.left]),question:places,
            actions:[.init(address:[],image:.pair(.leaf([.left]),.pair(.leaf([.right,.right]),.leaf([.right,.right]))))],
            hiddenActions:[.init(address:[],image:places)])
        let bytes = try RecordContinuation.encodeActions(r)
        let w = try R.read(bytes,mode:.repeats), c = try R.derive(w)
        XCTAssertTrue(try R.verify(c,world:w))
        guard case let .returned(b)? = c.repetition?.conclusion else { return XCTFail("expected a return") }
        XCTAssertEqual(b.calls,"1")
        let u7 = try RecordContinuation.read(bytes)
        XCTAssertFalse(try RecordContinuation.verify(RecordContinuation.derive(u7,actions:true),world:u7,actions:true))
        let without = C.Reading(whole:r.whole,observation:r.observation,question:r.question)
        XCTAssertThrowsError(try R.read(RecordContinuation.encodeActions(without),mode:.repeats)) { XCTAssertTrue(String(describing:$0).contains("record.hiddenActions")) }
    }
    func testCapacitySortOrderAndStrictCertificateAxes() throws {
        func chain(_ n: Int) -> C.Shape { n == 11 ? .leaf("S11") : .pair(.leaf("S\(n)"),chain(n+1)) }
        let s=chain(0), w = try R.read(R.encodeAgreement(whole:.init(source:s,edges:[]),output:.init(source:s,edges:[]),question:C.sourcePlaces(s),promiseDeclared:false),mode:.agreement)
        let c = try R.derive(w)
        XCTAssertTrue(try R.verify(c,world:w))
        guard case let .constructed(p)? = c.agreement?.conclusion else { return XCTFail("expected plan") }
        XCTAssertEqual(p.capacities.map(\.sort),["0","1","10","11","2","3","4","5","6","7","8","9"])
        XCTAssertEqual(p.residualLeaves.count,0)
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with:R.encodeCertificate(c)) as? [String:Any])
        object["image"] = ["classes":[],"connections":[],"images":[]]
        let bad = try R.decodeCertificate(JSONSerialization.data(withJSONObject:object,options:[.sortedKeys]))
        XCTAssertThrowsError(try R.verify(bad,world:w)) { XCTAssertTrue(String(describing:$0).contains("certificate.agreement")) }
        object["unknown"] = 1
        XCTAssertThrowsError(try R.decodeCertificate(JSONSerialization.data(withJSONObject:object))) { XCTAssertTrue(String(describing:$0).contains("certificate.unknown")) }
    }
}
