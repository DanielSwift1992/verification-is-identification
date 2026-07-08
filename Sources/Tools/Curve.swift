import Foundation

// ═══════════════════════════════════════════════════════════════
// THE CURVE names the saturation instrument: universes of growing size, each fully
// proved by one build, each timed, the law of growth read off the doublings.
//
// `swift run Tools curve 400 800 1600` runs the whole method in a disposable git
// worktree: check out HEAD, warm the build once, then for every size generate the
// universe and time the proof. The main tree is never touched, the worktree is
// removed on the way out, and a build that fails reports the wall instead of a
// number. The row factor is the growth per step, the exponent is its logarithm:
// 2.0 reads "doubling the world quadruples the proof". [DESIGN21 v28–v30]
// ═══════════════════════════════════════════════════════════════

enum Curve {
    @discardableResult
    private static func shell(_ arguments: [String], cwd: String? = nil) -> (status: Int32, output: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = arguments
        if let cwd { process.currentDirectoryURL = URL(fileURLWithPath: cwd) }
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        final class Box {
        var data = Data() }
        let box = Box()
        let drained = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            box.data = pipe.fileHandleForReading.readDataToEndOfFile()
            drained.signal()
        }
        try? process.run()
        process.waitUntilExit()
        _ = drained.wait(timeout: .now() + 10)
        return (process.terminationStatus, String(data: box.data, encoding: .utf8) ?? "")
    }

    static func run(_ args: [String]) {
        let sizes = args.compactMap { Int($0) }
        let universes = sizes.isEmpty ? [400, 800, 1600] : sizes

        let dirty = shell(["git", "status", "--porcelain"]).output
            .split(separator: "\n").filter { !$0.hasPrefix("??") }
        if !dirty.isEmpty {
            print("note: uncommitted changes stay behind — the curve measures HEAD.")
        }

        let worktree = NSTemporaryDirectory() + "vi-curve-\(ProcessInfo.processInfo.processIdentifier)"
        guard shell(["git", "worktree", "add", "-f", worktree, "HEAD"]).status == 0 else {
            FileHandle.standardError.write(Data("curve: git worktree add failed\n".utf8))
            exit(1)
        }
        defer {
            shell(["git", "worktree", "remove", "-f", worktree])
            shell(["git", "worktree", "prune"])
        }

        print("warming the build in a disposable worktree...")
        guard shell(["swift", "build"], cwd: worktree).status == 0 else {
            FileHandle.standardError.write(Data("curve: the warm build failed\n".utf8))
            exit(1)
        }

        print("")
        print("   N   proof   factor   exponent")
        var previous: (n: Int, seconds: Double)?
        for n in universes {
            guard shell([worktree + "/.build/debug/Tools", "generate", "org", String(n)], cwd: worktree).status == 0 else {
                print("\(String(format: "%6d", n))   GENERATE WALL — the universe would not state itself")
                break
            }
            let started = Date()
            let build = shell(["swift", "build"], cwd: worktree)
            let seconds = Date().timeIntervalSince(started)
            guard build.status == 0 else {
                let reason = build.output.split(separator: "\n").first { $0.contains("error") } ?? "unknown"
                print("\(String(format: "%6d", n))   BUILD WALL — \(reason.suffix(120))")
                break
            }
            var tail = ""
            if let previous {
                let factor = seconds / previous.seconds
                let exponent = log(factor) / log(Double(n) / Double(previous.n))
                tail = String(format: "   ×%.2f   N^%.2f", factor, exponent)
            }
            print(String(format: "%6d   %5.0fs%@", n, seconds, tail))
            previous = (n, seconds)
        }
        print("")
        print("every state proved by the build it timed; reproduce: swift run Tools curve \(universes.map(String.init).joined(separator: " "))")
    }
}
