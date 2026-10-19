#!/usr/bin/env python3
"""A parsed outer term does not certify an inner conditional conformance."""
from pathlib import Path
import re
import subprocess
import sys
import tempfile


COMMON = """public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted where T: Required {}
func need<T: Admitted>(_: T.Type) {}
public typealias GoodClaim = Use<Good>
public typealias Pick = CHOICE
"""
OPTIONAL = "func unwrap<T>(_: Optional<T>.Type) -> T.Type { T.self }\n"
TWIN = """public enum Twin<A> {}
extension Twin: Admitted where A == Use<Pick> {}
public protocol Container { associatedtype Value }
extension Twin: Container { public typealias Value = A }
func unwrap<T: Container>(_: T.Type) -> T.Value.Type { T.Value.self }
"""
CASES = {
    "optional": OPTIONAL + "func demand() { need(unwrap(Optional<Use<Pick>>.self)) }\n",
    "array": "func unwrap<T>(_: Array<T>.Type) -> T.Type { T.self }\n"
             "func demand() { need(unwrap(Array<Use<Pick>>.self)) }\n",
    "alias-optional": OPTIONAL + "public typealias Box<X: Setting> = Optional<Use<X>>\n"
                      "func demand() { need(unwrap(Box<Pick>.self)) }\n",
    "gated-outer": TWIN + "func demand() { need(unwrap(Twin<Use<Pick>>.self)) }\n",
    "alias-gated-outer": TWIN + "public typealias Box<X: Setting> = Twin<Use<X>>\n"
                         "func demand() { need(unwrap(Box<Pick>.self)) }\n",
    "certificate": OPTIONAL + "public typealias Wrapped = Optional<Use<Pick>>\n"
                   "func demand() { need(unwrap(Wrapped.self)) }\n",
    "member-certificate": OPTIONAL + "public protocol Holder {}\n"
                          "public enum Owner: Holder { public typealias Wrapped = Optional<Use<Pick>> }\n"
                          "func demand() { need(unwrap(Owner.Wrapped.self)) }\n",
    "argument-alias": OPTIONAL + "public typealias Inner<X: Setting> = Use<X>\n"
                      "func demand() { need(unwrap(Optional<Inner<Pick>>.self)) }\n",
}


def run(args):
    return subprocess.run(list(map(str, args)), capture_output=True, text=True)


def require(condition, message, result):
    if not condition:
        raise SystemExit(f"where-nested-applications: {message}\n{result.stdout}{result.stderr}")


def main():
    tools = Path(sys.argv[1]).resolve()
    with tempfile.TemporaryDirectory(prefix="vi-where-nested-") as temporary:
        scratch = Path(temporary)
        for label, body in CASES.items():
            for good in [False, True]:
                world = scratch / (label + ("-good.swift" if good else "-bad.swift"))
                world.write_text(COMMON.replace("CHOICE", "Good" if good else "Bad") + body)
                compiler = run(["swiftc", "-typecheck", "-module-cache-path", scratch / "cache", world])
                if good:
                    require(compiler.returncode == 0 and not compiler.stdout and not compiler.stderr,
                            f"Swift did not accept {world.name} cleanly", compiler)
                else:
                    errors = re.findall(r"^.*\.swift:\d+:\d+: error: (.*)$", compiler.stderr, re.MULTILINE)
                    require(compiler.returncode == 1 and errors == [
                        "global function 'need' requires that 'Pick' (aka 'Bad') conform to 'Required'"
                    ], f"Swift did not refuse only Required in {world.name}", compiler)
                court = run([tools, "judge", "where", world])
                expected = (re.escape("✗ THE WHERE: cannot read line ") + r"\d+"
                            + re.escape(f" of '{world}': '") + r"[^\n]+"
                            + re.escape("' contains a gated application outside the root this court judges\n"))
                require(court.returncode == 2 and not court.stdout and re.fullmatch(expected, court.stderr),
                        f"the court did not name the nested application in {world.name}", court)

        # Preserve the old compiler-valid nested control as an explicit
        # narrowing, rather than deleting its application from the evidence.
        files = [Path("Checks/where-applications/nested-admitted.swift"),
                 Path("Checks/where-applications/admitted-definitions.swift")]
        compiler = run(["swiftc", "-typecheck", "-module-cache-path", scratch / "cache", *files])
        require(compiler.returncode == 0 and not compiler.stdout and not compiler.stderr,
                "Swift refused the previous nested control", compiler)
        court = run([tools, "judge", "where", *files])
        expected = ("✗ THE WHERE: cannot read line 25 of 'Checks/where-applications/nested-admitted.swift': "
                    "'Twin<Use<Good>>' contains a gated application outside the root this court judges\n")
        require(court.returncode == 2 and not court.stdout and court.stderr == expected,
                "the previous nested control was not explicitly narrowed", court)
        print("✓ where-nested-applications: eight compiler-checked pairs and the previous nested control are named")


if __name__ == "__main__":
    main()
