#!/usr/bin/env python3
"""Run the Swift court and a replacement court on the same invocations and
compare exit, stdout and stderr byte for byte.

Usage: diff-court.py --swift <Tools> --other <binary> [--show N]
Run from the repository root. The invocation list is the repository's where
and count fixtures, judged alone and beside their definitions files, plus the
Examples the laws judge. Agreement on this list is evidence for these
invocations only; it does not establish general equivalence.
"""
import argparse
import glob
import json
from pathlib import Path
import os
import subprocess
import sys

PRIMITIVE = "Sources/VerificationIsIdentification/Primitive.swift"
LADDER = "Sources/Examples/RydbergLadder.swift"
COUNT_ARGS = ["--predicate", "TickCountQuestion", "--encoding", "UnaryArithmeticEncoding", "--sigma", "RydbergLevels"]


def invocations():
    jobs = []
    for directory in sorted(glob.glob("Checks/where-*/")):
        files = sorted(glob.glob(directory + "*.swift"))
        definitions = [f for f in files if "definitions" in os.path.basename(f)]
        for world in files:
            jobs.append(["where", world])
            for extra in definitions:
                if extra != world:
                    jobs.append(["where", world, extra])
            jobs.append(["where", world, PRIMITIVE])
    jobs.append(["where", "Sources/Examples/Light.swift", PRIMITIVE])
    jobs.append(["where", "Sources/Examples/Grants.swift"])
    jobs.append(["where", LADDER, PRIMITIVE])
    jobs.append(["count", LADDER, PRIMITIVE] + COUNT_ARGS)
    for control in sorted(glob.glob("Checks/rydberg-count/*.swift")):
        jobs.append(["count", control, LADDER, PRIMITIVE] + COUNT_ARGS)
        jobs.append(["where", control, LADDER, PRIMITIVE])
    for fixture in sorted(glob.glob("Contracts/Court/v0.1/fixtures/*.swift")):
        jobs.append(["where", fixture])
    jobs.append(["where", "fixtures/absent.swift"])
    jobs.append(["count", "fixtures/absent.swift", PRIMITIVE] + COUNT_ARGS)
    # The capacity suite keeps the same count question, with larger inputs and
    # explicit resource/primitive controls. Match their addressed CLI as well.
    for version in ("v0.2", "v0.3"):
        suite = Path("Contracts/Court") / version
        for case in json.loads((suite / "contract.json").read_text())["cases"]:
            jobs.append([case["pass"]] + [str(suite / f) for f in case["files"]] + case["args"])
    return jobs


def permitted(job, a, b):
    """The one difference the contract permits: the platform detail of the
    count missing-file line. Both courts exit 2 with one stderr line that
    names the absent file and says that there is no such file."""
    if job[0] != "count" or a[0] != 2 or b[0] != 2 or a[1] or b[1]:
        return False
    absent = os.path.basename(job[1]).encode()
    lines = []
    for text in (a[2], b[2]):
        parts = text.split(b"\n")
        if len(parts) != 2 or parts[1]:
            return False
        lines.append(parts[0])
    return all(
        line.startswith("✗ COUNT unresolved: ".encode()) and absent in line and b"No such file or directory" in line
        for line in lines
    )


def run(binary, job):
    result = subprocess.run([binary, "judge"] + job, capture_output=True, timeout=120)
    return result.returncode, result.stdout, result.stderr


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--swift", required=True)
    parser.add_argument("--other", required=True)
    parser.add_argument("--show", type=int, default=12, help="how many differing invocations to print in full")
    args = parser.parse_args()
    same = 0
    differ = []
    allowed = []
    jobs = invocations()
    by_exit = {}
    for job in jobs:
        a = run(args.swift, job)
        b = run(args.other, job)
        by_exit.setdefault(a[0], 0)
        by_exit[a[0]] += 1
        if a == b:
            same += 1
        elif permitted(job, a, b):
            allowed.append(job)
        else:
            differ.append((job, a, b))
    print(f"{same}/{len(jobs)} invocations identical (exit, stdout, stderr); Swift exits: {dict(sorted(by_exit.items()))}")
    for job in allowed:
        print("permitted platform difference (count missing-file line):", " ".join(job))
    for job, a, b in differ[: args.show]:
        print("=== DIFFER:", " ".join(job))
        print(f"  swift exit {a[0]} | other exit {b[0]}")
        for label, text_a, text_b in (("stdout", a[1], b[1]), ("stderr", a[2], b[2])):
            if text_a != text_b:
                print(f"  --- {label} swift:\n" + text_a.decode("utf-8", "replace")[:1500])
                print(f"  --- {label} other:\n" + text_b.decode("utf-8", "replace")[:1500])
    if len(differ) > args.show:
        print(f"... {len(differ) - args.show} more differing invocations not shown")
    return 0 if not differ else 1  # a permitted difference alone exits 0


if __name__ == "__main__":
    sys.exit(main())
