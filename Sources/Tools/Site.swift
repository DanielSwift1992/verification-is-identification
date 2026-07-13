import Foundation

// ═══════════════════════════════════════════════════════
// Site serves the current site locally: `swift run Tools site [fast]`.
//
// Kills whatever held its port, rebuilds the package, regenerates the drawings and the
// pages (`fast` skips that), renders the combined documentation for every module, and
// serves it at http://localhost:4141 with caching disabled — a reload always shows the
// build you just made, byte-for-byte what the deploy would publish. The SPM-native twin
// of the docs workflow; Xcode's own preview shows one module and misses the combined
// navigation and the inline hook, so this is the one faithful local view.
// ═══════════════════════════════════════════════════════

enum Site {
    private static let port = "4141"
    private static let siteDirectory = ".site"
    private static let targets = [
        "VerificationIsIdentification", "Organization", "DocumentKit",
        "Examples", "GrammarLexicon", "Alphabet",
    ]

    @discardableResult
    private static func step(_ executable: String, _ arguments: [String]) -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = arguments
        try? process.run()
        process.waitUntilExit()
        return process.terminationStatus
    }

    static func run(_ args: [String]) {
        let fast = args.first == "fast"

        step("/bin/sh", ["-c", "lsof -ti tcp:\(port) | xargs kill 2>/dev/null; true"])

        guard step("/usr/bin/env", ["swift", "build"]) == 0 else {
            FileHandle.standardError.write(Data("site: swift build failed\n".utf8))
            exit(1)
        }
        if !fast {
            step(".build/debug/VectorDemo", ["all"])
            step(".build/debug/OrgDemo", ["render-doc"])
            step(".build/debug/DocumentKitDemo", ["render-doc"])
        }

        try? FileManager.default.removeItem(atPath: siteDirectory)
        var docs = ["package", "--allow-writing-to-directory", siteDirectory,
                    "generate-documentation",
                    "--enable-experimental-combined-documentation",
                    "--experimental-enable-custom-templates"]
        for target in targets {
            docs += ["--target", target]
        }
        docs += ["--transform-for-static-hosting", "--output-path", siteDirectory]
        guard step("/usr/bin/env", ["swift"] + docs) == 0 else {
            FileHandle.standardError.write(Data("site: documentation build failed\n".utf8))
            exit(1)
        }
        let redirect = "<!DOCTYPE html><meta charset=\"utf-8\">"
            + "<title>Verification Is Identification</title>"
            + "<meta http-equiv=\"refresh\" content=\"0; url=./documentation/verificationisidentification/\">"
            + "<a href=\"./documentation/verificationisidentification/\">Documentation</a>"
        try? redirect.write(toFile: siteDirectory + "/index.html", atomically: true, encoding: .utf8)

        print("")
        print("→ http://localhost:\(port)/documentation/organization/")
        print("")
        let server = """
        import functools
        import sys
        from http.server import HTTPServer, SimpleHTTPRequestHandler

        class FreshHandler(SimpleHTTPRequestHandler):
            def end_headers(self):
                self.send_header("Cache-Control", "no-store")
                super().end_headers()

        HTTPServer(("", \(port)), functools.partial(FreshHandler, directory="\(siteDirectory)")).serve_forever()
        """
        step("/usr/bin/env", ["python3", "-c", server])
    }
}
