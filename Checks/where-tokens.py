#!/usr/bin/env python3
"""Compiler controls for spaces inside extension owners and generic headers.

Each bad world differs from its good control in one requirement. The good
control must compile without diagnostics; the bad world must fail only at
Required. The court names the unread scope in both, never a semantic verdict.
"""
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
extension Use: Admitted
where T: Required {}
func need<T: Admitted>(_: T.Type) {}
public typealias GoodClaim = Use<Good>
"""


def run(args):
    return subprocess.run(list(map(str, args)), capture_output=True, text=True)


def require(condition, message, result):
    if not condition:
        raise SystemExit(f"where-tokens: {message}\n{result.stdout}{result.stderr}")


def check(tools, scratch, name, text, good, refusal, definitions=None, argument="'Good'"):
    world = scratch / (name + ".swift")
    world.write_text(text)
    files = [world]
    if definitions is not None:
        extra = scratch / (name + "-definitions.swift")
        extra.write_text(definitions)
        files.append(extra)
    compiler = run(["swiftc", "-typecheck", "-module-cache-path", scratch / "cache", *files])
    if good:
        require(compiler.returncode == 0 and not compiler.stdout and not compiler.stderr,
                f"Swift did not accept the clean control {name}", compiler)
    else:
        errors = re.findall(r"^.*\.swift:\d+:\d+: error: (.*)$", compiler.stderr, re.MULTILINE)
        require(compiler.returncode == 1 and errors == [
            f"global function 'need' requires that {argument} conform to 'Required'"
        ], f"Swift did not refuse only Required in {name}", compiler)
    court = run([tools, "judge", "where", *files])
    require(court.returncode == 2 and not court.stdout and re.fullmatch(refusal, court.stderr),
            f"the court did not name the unread scope in {name}", court)


def main():
    tools = Path(sys.argv[1]).resolve()
    with tempfile.TemporaryDirectory(prefix="vi-where-tokens-") as temporary:
        scratch = Path(temporary)
        owners = {
            "spaces": "main . Owner",
            "before-dot": "main .Owner",
            "comment-before-dot": "main /* before dot */ .Owner",
            "newline-before-dot": "main\n    .Owner",
            "multiline-comments": "main /* a\n b */ . /* c */ Owner",
        }
        owner_world = COMMON + """public enum Left: Required {}
public protocol Holder {}
public enum Owner: Holder { public typealias Claim = Use<Left> }
func demand() { need(Owner.Claim.self) }
"""
        owner_refusal = re.escape("✗ THE WHERE: cannot read line 1: the extension of 'main.Owner' "
                                  "names its type through a qualifier, which this court does not resolve\n")
        for label, owner in owners.items():
            for good in [False, True]:
                check(tools, scratch, f"owner-{label}-{good}", owner_world, good, owner_refusal,
                      f"extension {owner} {{ public typealias Left = {'Good' if good else 'Bad'} }}\n",
                      argument="'Owner.Left' (aka 'Bad')")

        heads = {
            "less-separated-space": "func < < Good: CONSTRAINT>",
            "less-attached-space": "func << Good: CONSTRAINT>",
            "less-attached-comment": "func <</* between */Good: CONSTRAINT>",
            "less-attached-newline": "func <<\nGood: CONSTRAINT>",
            "equal-attached-space": "func ==< Good: CONSTRAINT>",
            "equal-attached-comment": "func ==</* between */Good: CONSTRAINT>",
            "plus-attached-space": "func +< Good: CONSTRAINT>",
            "less-separated-newline": "func < <\nGood: CONSTRAINT>",
            "word-vtab": "func\voperate<Good: CONSTRAINT>",
            "word-formfeed": "func\foperate<Good: CONSTRAINT>",
            "word-comment": "func /* before name */ operate<Good: CONSTRAINT>",
            "word-newline": "func\noperate<Good: CONSTRAINT>",
        }
        shadow_refusal = (re.escape("✗ THE WHERE: cannot read 'Good': it is declared at lines 4 and ")
                          + r"\d+" + re.escape(
                              ", and this court has no scope rule to choose between them\n"))
        for label, head in heads.items():
            for good in [False, True]:
                declaration = head.replace("CONSTRAINT", "Required" if good else "Setting")
                body = declaration + "(_ lhs: Good, _ rhs: Good) -> Bool {\n    need(Use<Good>.self)\n    return false\n}\n"
                check(tools, scratch, f"declaration-{label}-{good}", COMMON + body, good, shadow_refusal)

        # An operator ending in '<' before '(' has no generic parameter list.
        # A fresh parameter, ordinary whitespace and an unqualified extension
        # do not make an otherwise admitted world unreadable.
        control = scratch / "admitted.swift"
        control.write_text(COMMON + """func <<(_ lhs: Good, _ rhs: Good) -> Bool { false }
func ==< Fresh: Setting>(_ lhs: Fresh, _ rhs: Fresh) -> Bool { false }
extension Good /* between tokens */ { public typealias Extra = Good }
func demand() { need(Use<Good>.self) }
""")
        compiler = run(["swiftc", "-typecheck", "-module-cache-path", scratch / "cache", control])
        require(compiler.returncode == 0 and not compiler.stdout and not compiler.stderr,
                "Swift refused the admitted control", compiler)
        court = run([tools, "judge", "where", control])
        require(court.returncode == 0 and not court.stderr and court.stdout.startswith("✓ THE WHERE holds:"),
                "the court refused the admitted control", court)
        print(f"✓ where-tokens: {len(owners) + len(heads)} bad/good pairs keep their token boundaries; the control holds")


if __name__ == "__main__":
    main()
