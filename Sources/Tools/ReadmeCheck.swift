// README CHECK — the README's numbers are counted, not remembered.
//
// Every number the README states about the repository is re-counted here from the
// artifact that owns it: paper families from their complete pages, protocols from the theory's
// sources and tests from the test sources. The company's numbers moved with it to the
// showcase package, whose readme check counts them (T-0015). A claim that drifts fails the gate by name, and a claim that
// disappears fails it too: silence is also a drift.

import Foundation

enum ReadmeCheck {
    static let root = FileManager.default.currentDirectoryPath

    static func read(_ path: String) -> String {
        (try? String(contentsOfFile: root + "/" + path, encoding: .utf8)) ?? ""
    }

    static func countFiles(_ directory: String, suffix: String) -> Int {
        ((try? FileManager.default.contentsOfDirectory(atPath: root + "/" + directory)) ?? [])
            .filter { $0.hasSuffix(suffix) }.count
    }

    static func countMatches(_ text: String, of pattern: String) -> Int {
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.numberOfMatches(in: text, range: NSRange(text.startIndex..., in: text))
    }

    static func swiftSources(_ directory: String) -> String {
        let base = root + "/" + directory
        let paths = (FileManager.default.enumerator(atPath: base)?.allObjects as? [String]) ?? []
        return paths.filter { $0.hasSuffix(".swift") }
            .map { (try? String(contentsOfFile: base + "/" + $0, encoding: .utf8)) ?? "" }
            .joined(separator: "\n")
    }

    /// Every capture of `pattern`, as text.
    static func words(_ text: String, _ pattern: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).compactMap { match in
            guard match.numberOfRanges > 1,
                  let captured = Range(match.range(at: 1), in: text) else { return nil }
            return String(text[captured])
        }
    }

    /// Every capture of `pattern`, as digits with the thousands comma shed.
    static func claims(_ text: String, _ pattern: String) -> [Int] {
        words(text, pattern).compactMap { Int($0.replacingOccurrences(of: ",", with: "")) }
    }

    static func run(_ arguments: [String]) {
        let readme = read("README.md")
        var lies: [String] = []

        // What the repository counts today.
        let corpus = PaperFamilies.require(
            root + "/Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers"
        )
        let papers = corpus.families.count
        let protocols = countMatches(
            swiftSources("Sources/VerificationIsIdentification") + swiftSources("Sources/Notation"), of: "public protocol "
        )
        let tests = countMatches(swiftSources("Tests"), of: "func test")

        // What the README says, each pattern read at every occurrence.
        let expectations: [(pattern: String, count: Int, name: String)] = [
            ("(\\d+) papers", papers, "complete paper families"),
            ("(\\d+) protocols", protocols, "public protocols in the theory"),
            ("(\\d+) protocols, one per claim", protocols, "public protocols in the theory"),
            ("Executed (\\d+) tests", tests, "test functions under Tests"),
        ]

        for expectation in expectations {
            let found = claims(readme, expectation.pattern)
            if found.isEmpty {
                lies.append("the claim \"\(expectation.pattern)\" is gone from the README, and the gate holds it")
                continue
            }
            let drifted = found.filter { $0 != expectation.count }
            for value in drifted {
                lies.append(
                    "the README says \(value) where the repository counts \(expectation.count) (\(expectation.name))"
                )
            }
        }

        if lies.isEmpty {
            print(
                "✓ THE NUMBERS hold: \(papers) papers (\(corpus.texts.count) pages), \(protocols) protocols, "
                    + "\(tests) tests."
            )
        } else {
            for lie in lies { print("✗ \(lie)") }
            exit(1)
        }
    }
}
