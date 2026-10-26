#!/usr/bin/env python3
"""A qualification gap or a Unicode name must not hide a gated application."""
from pathlib import Path
import re
import subprocess
import sys
import tempfile


COMMON = """public enum Optional<T> {}
public enum Array<T> {}
public protocol Setting {}
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
CASES = {
    "qualified-gap-parameter": "func demand(_ value: main .Use<Pick>.Type) { need(value) }\n",
    "qualified-gap-parenthesized": "func demand() { need((main .Use<Pick>).self) }\n",
    "qualified-gap-alias": "public typealias Wrap<X: Setting> = Use<X>\n"
                           "func demand(_ value: main .Wrap<Pick>.Type) { need(value) }\n",
    "qualified-comment": "func demand(_ value: main /* gap */ .Use<Pick>.Type) { need(value) }\n",
    "qualified-newline": "func demand(_ value: main\n.Use<Pick>.Type) { need(value) }\n",
    "qualified-tight": "func demand(_ value: main.Use<Pick>.Type) { need(value) }\n",
    "qualified-both-spaces": "func demand(_ value: main . Use<Pick>.Type) { need(value) }\n",
    "unicode-alias-nested": "public typealias Обертка<X: Setting> = Use<X>\n" + OPTIONAL
                            + "func demand() { need(unwrap(Optional<Обертка<Pick>>.self)) }\n",
    "unicode-head-nested": OPTIONAL + "func demand() { need(unwrap(Optional<Use<Pick>>.self)) }\n",
    "unicode-head-alias-parameter": "public typealias Wrap<X: Setting> = Use<X>\n"
                                    "func demand(_ value: Wrap<Pick>.Type) { need(value) }\n",
    "unicode-head-direct-control": "func demand() { need(Use<Pick>.self) }\n",
    "unicode-alias-direct-control": "public typealias Обертка<X: Setting> = Use<X>\n"
                                    "func demand() { need(Обертка<Pick>.self) }\n",
}


def run(args):
    return subprocess.run(list(map(str, args)), capture_output=True, text=True)


def require(condition, message, result):
    if not condition:
        raise SystemExit(f"where-application-names: {message}\n{result.stdout}{result.stderr}")


def good_source(text):
    return "\n".join(line if re.match(r"\s*public enum Bad:", line)
                     else re.sub(r"\bBad\b", "Good", line) for line in text.split("\n"))


def main():
    tools = Path(sys.argv[1]).resolve()
    fixtures = Path("Checks/where-applications")
    with tempfile.TemporaryDirectory(prefix="vi-where-names-") as temporary:
        scratch = Path(temporary)
        cases = []
        for label, body in CASES.items():
            source = COMMON + body
            if label.startswith("unicode-head-"):
                source = source.replace("Use", "Исп")
            cases.append((label, source, None))
        for label, original, before, after in [
            ("unicode-lent-gate", "lent-gate", "Use", "Исп"),
            ("unicode-lent-protocol", "lent-protocol", "Balanced", "Баланс"),
        ]:
            source = (fixtures / (original + ".swift")).read_text().replace(before, after)
            definitions = (fixtures / (original + "-definitions.swift")).read_text().replace(before, after)
            cases.append((label, source, definitions))

        for label, source, definitions in cases:
            for good in [False, True]:
                world = scratch / (label + ("-good.swift" if good else "-bad.swift"))
                source_text = source.replace("CHOICE", "Good" if good else "Bad")
                world.write_text(good_source(source_text) if good else source_text)
                files = [world]
                if definitions is not None:
                    extra = scratch / (world.stem + "-definitions.swift")
                    extra.write_text(good_source(definitions) if good else definitions)
                    files.append(extra)
                compiler = run(["swiftc", "-typecheck", "-module-cache-path", scratch / "cache", *files])
                if good:
                    require(compiler.returncode == 0 and not compiler.stdout and not compiler.stderr,
                            f"Swift did not accept {world.name} cleanly", compiler)
                else:
                    errors = re.findall(r"^.*\.swift:\d+:\d+: error: (.*)$", compiler.stderr, re.MULTILINE)
                    expected = ["global function 'need' requires that 'Pick' (aka 'Bad') conform to 'Required'"]
                    if label == "unicode-lent-gate":
                        expected = ["global function 'need' requires that 'Bad' conform to 'Required'"]
                    if label == "unicode-lent-protocol":
                        expected = ["type 'Witness' does not conform to protocol 'Баланс'",
                                    "'Баланс' requires the types 'Witness.Left' (aka 'Good') and "
                                    "'Witness.Right' (aka 'Bad') be equivalent"]
                    require(compiler.returncode == 1 and errors == expected,
                            f"Swift did not refuse the expected obligation in {world.name}", compiler)
                court = run([tools, "judge", "where", *files])
                if label.endswith("direct-control"):
                    if good:
                        require(court.returncode == 0 and not court.stderr
                                and court.stdout.startswith("✓ THE WHERE holds: 0 equalities and 2 memberships judged across 1 uses,"),
                                f"the direct Unicode control was not admitted in {world.name}", court)
                    else:
                        require(court.returncode == 1 and not court.stderr
                                and "conform to 'Required', and 'Bad: Setting' does not carry it" in court.stdout,
                                f"the direct Unicode obligation was not judged in {world.name}", court)
                else:
                    # Unsupported coverage has no semantic verdict. Its reason
                    # must address this world or its supplied definitions file.
                    require(court.returncode == 2 and not court.stdout
                            and court.stderr.startswith("✗ THE WHERE: cannot read ")
                            and any(str(path) in court.stderr for path in files)
                            and "gate" in court.stderr,
                            f"the court did not name the unread obligation in {world.name}", court)
        print("✓ where-application-names: fourteen compiler-checked pairs, including two judged Unicode controls")


if __name__ == "__main__":
    main()
