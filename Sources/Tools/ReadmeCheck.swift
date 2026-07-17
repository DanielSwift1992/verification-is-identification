// README CHECK — the README's numbers are counted, not remembered.
//
// Every number the README states about the repository is re-counted here from the
// artifact that owns it: papers from the Papers directory, protocols from the theory's
// sources, people from the two team files, tests from the test sources, and the two
// numbers owned by a documentation page (the keypad's 6561, the curve's 12800) from
// those pages. A claim that drifts fails the gate by name, and a claim that
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

    /// The number a prose word states: the walk sentences spell small counts as words.
    static let numberWords = [
        "one": 1, "two": 2, "three": 3, "four": 4, "five": 5,
        "six": 6, "seven": 7, "eight": 8, "nine": 9, "ten": 10,
    ]

    static func run(_ arguments: [String]) {
        let readme = read("README.md")
        var lies: [String] = []

        // What the repository counts today.
        let papers = countFiles(
            "Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers",
            suffix: ".md"
        )
        let protocols = countMatches(
            swiftSources("Sources/VerificationIsIdentification"), of: "public protocol "
        )
        let named = countMatches(read("Sources/Organization/System/Team.swift"), of: ": *Employee\\b")
        let generated = countMatches(
            read("Sources/Organization/System/GeneratedTeam.swift"), of: ": *Employee\\b"
        )
        let people = named + generated
        let tests = countMatches(swiftSources("Tests"), of: "func test")
        let keypadSequences = claims(
            read("Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Neighbors.md"),
            "= (\\d+)"
        ).first ?? 0
        let curveEmployees = claims(
            read("Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Curve.md"),
            "N = ([\\d,]+)"
        ).first ?? 0

        // What the README says, each pattern read at every occurrence.
        let expectations: [(pattern: String, count: Int, name: String)] = [
            ("The (\\d+) papers", papers, "papers in the Papers directory"),
            ("in (\\d+) papers", papers, "papers in the Papers directory"),
            ("(\\d+) protocols", protocols, "public protocols in the theory"),
            ("the (\\d+)-person company", people, "people in the two team files"),
            ("the (\\d+) people", people, "people in the two team files"),
            ("(\\d+) protocols, one per claim", protocols, "public protocols in the theory"),
            ("Executed (\\d+) tests", tests, "test functions under Tests"),
            ("(\\d+) possible sequences", keypadSequences, "sequences the Neighbors page derives"),
            ("to ([\\d,]+) employees", curveEmployees, "employees the Curve page measures"),
            ("([\\d,]+)-person file", curveEmployees, "employees the Curve page measures"),
        ]

        for expectation in expectations {
            let found = claims(readme, expectation.pattern)
            if found.isEmpty {
                lies.append("the claim \"\(expectation.pattern)\" is gone from the README, and the gate holds it")
                continue
            }
            for value in found where value != expectation.count {
                lies.append(
                    "the README says \(value) where the repository counts \(expectation.count) (\(expectation.name))"
                )
            }
        }

        // The walk sentence, in both homes. The roster walk halves the roster at every door,
        // so its depth is implied by the people count. The site walk's depth has no formula
        // here, so the README and the Organization page must speak the same sentence.
        let organizationPage = read("Sources/Organization/Organization.docc/Organization.md")
        let rosterDepth = Int(ceil(log2(Double(max(people, 2)))))
        for home in [("README", readme), ("Organization page", organizationPage)] {
            let stated = words(home.1, "people in (\\w+)").compactMap { numberWords[$0] }
            if stated.isEmpty {
                lies.append("the roster-walk claim \"people in <depth>\" is gone from the \(home.0)")
            }
            for value in stated where value != rosterDepth {
                lies.append(
                    "the \(home.0) says the roster walk takes \(value) choices where "
                        + "\(people) people halve in \(rosterDepth)"
                )
            }
        }
        let readmeChoices = words(readme, "any page in (\\w+) choices")
        let pageChoices = words(organizationPage, "any page in (\\w+) choices")
        if readmeChoices.isEmpty || pageChoices.isEmpty {
            lies.append("the site-walk claim \"any page in <n> choices\" must stand in the README and the Organization page")
        } else if Set(readmeChoices + pageChoices).count > 1 {
            lies.append(
                "the site-walk depth disagrees: the README says \(readmeChoices.joined(separator: ", ")), "
                    + "the Organization page says \(pageChoices.joined(separator: ", "))"
            )
        }

        if lies.isEmpty {
            print(
                "✓ THE NUMBERS hold: \(papers) papers, \(protocols) protocols, "
                    + "\(people) people (\(named) named, \(generated) generated), \(tests) tests, "
                    + "\(keypadSequences) keypad sequences, \(curveEmployees) at the curve's end, "
                    + "walks \(pageChoices.first ?? "?") and \(rosterDepth) deep."
            )
        } else {
            for lie in lies { print("✗ \(lie)") }
            exit(1)
        }
    }
}
