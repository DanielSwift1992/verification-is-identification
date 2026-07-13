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
        var fanouts: [Int] = []
        var seatJudge = false
        var rest: [String] = []
        var index = 0
        while index < args.count {
            if args[index] == "--fanout", index + 1 < args.count {
                fanouts = args[index + 1].split(separator: ",").compactMap { Int($0) }
                index += 2
            } else if args[index] == "--judge" {
                seatJudge = true
                index += 1
            } else {
                rest.append(args[index])
                index += 1
            }
        }
        if !fanouts.isEmpty {
            sweep(fanouts, at: rest.compactMap { Int($0) }.first ?? 1600, seatJudge: seatJudge)
            return
        }
        let sizes = rest.compactMap { Int($0) }
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
        print(seatJudge ? "   N   proof     judge   proof growth    judge growth"
                        : "   N   proof   factor   exponent")
        var previous: (n: Int, seconds: Double)?
        var judgePrevious: (n: Int, milliseconds: Double)?
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
                tail = String(format: seatJudge ? "   ×%.2f N^%.2f" : "   ×%.2f   N^%.2f",
                    factor, exponent)
            }
            if seatJudge {
                let corpus = worktree + "/Sources/Organization/System/GeneratedTeam.swift"
                guard let judged = Judge.judge(paths: [corpus]), judged.refusals.isEmpty else {
                    print(String(format: "%6d   %5.0fs   JUDGE REFUSES", n, seconds))
                    break
                }
                var judgeTail = ""
                if let judgePrevious {
                    let factor = judged.milliseconds / judgePrevious.milliseconds
                    let exponent = log(factor) / log(Double(n) / Double(judgePrevious.n))
                    judgeTail = String(format: "   ×%.2f N^%.2f", factor, exponent)
                }
                print(String(format: "%6d   %5.0fs   %5.0f ms%@%@", n, seconds,
                    judged.milliseconds, tail, judgeTail))
                judgePrevious = (n, judged.milliseconds)
            } else {
                print(String(format: "%6d   %5.0fs%@", n, seconds, tail))
            }
            previous = (n, seconds)
        }
        print("")
        print("every state proved by the build it timed; reproduce: swift run Tools curve \(universes.map(String.init).joined(separator: " "))")
    }

    // The sweep: one universe size, several packings, the compiler votes. The fanout is
    // the form dictionary's one dial (CodeForm), and the best value is measured, not
    // chosen by taste.
    private static func sweep(_ fanouts: [Int], at n: Int, seatJudge: Bool) {
        let worktree = NSTemporaryDirectory() + "vi-sweep-\(ProcessInfo.processInfo.processIdentifier)"
        guard shell(["git", "worktree", "add", "-f", worktree, "HEAD"]).status == 0 else {
            FileHandle.standardError.write(Data("curve: git worktree add failed\n".utf8))
            exit(1)
        }
        defer {
            shell(["git", "worktree", "remove", "-f", worktree])
            shell(["git", "worktree", "prune"])
        }
        print("sweeping fanout at N=\(n) in a disposable worktree...")
        guard shell(["swift", "build"], cwd: worktree).status == 0 else {
            FileHandle.standardError.write(Data("curve: the warm build failed\n".utf8))
            exit(1)
        }
        print("")
        print(seatJudge ? "fanout   proof     judge" : "fanout   proof")
        var best: (fanout: Int, seconds: Double)?
        for f in fanouts {
            guard shell([worktree + "/.build/debug/Tools", "generate", "org", String(n), "fanout=\(f)"], cwd: worktree).status == 0 else {
                print(String(format: "%6d   GENERATE WALL", f))
                continue
            }
            let started = Date()
            guard shell(["swift", "build"], cwd: worktree).status == 0 else {
                print(String(format: "%6d   BUILD WALL", f))
                continue
            }
            let seconds = Date().timeIntervalSince(started)
            if seatJudge {
                let corpus = worktree + "/Sources/Organization/System/GeneratedTeam.swift"
                let judged = Judge.judge(paths: [corpus])
                let milliseconds = judged?.milliseconds ?? -1
                print(String(format: "%6d   %5.0fs   %5.0f ms", f, seconds, milliseconds))
            } else {
                print(String(format: "%6d   %5.0fs", f, seconds))
            }
            if best == nil || seconds < best!.seconds { best = (f, seconds) }
        }
        if let best {
            print("")
            print("the compiler votes fanout=\(best.fanout) at N=\(n): \(Int(best.seconds))s")
        }
    }
}
