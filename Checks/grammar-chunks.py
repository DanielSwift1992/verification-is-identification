#!/usr/bin/env python3
"""Formation groups and distinct, read-back carriers preserve emitted inputs."""
import json, re, subprocess, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

def bodies(source):
    nodes, stack, body = {}, [], False
    for number, line in enumerate(source.splitlines(), 1):
        match = re.fullmatch(r'\s*enum (\w+): Formation \{', line)
        if match:
            stack.append(match[1])
            nodes[stack[-1]] = {'attribute': None, 'lines': []}
        elif match := re.fullmatch(r'\s*@(\w+) static var body: Never.Type \{', line):
            nodes[stack[-1]]['attribute'] = match[1]
            body = True
        elif line.strip() == '}':
            if body:
                body = False
            else:
                stack.pop()
        elif body:
            nodes[stack[-1]]['lines'].append((line, number))
    return nodes

def expanded(nodes):
    def leaves(name):
        result = []
        for line, number in nodes[name]['lines']:
            group = re.fullmatch(r'\s*(CarrierGroup\d+)\.self', line)
            if group:
                child = group[1]
                assert nodes[child]['attribute'] == nodes[name]['attribute']
                result.extend(leaves(child))
            else:
                result.append((line, number))
        return result
    return {name: {'attribute': node['attribute'], 'lines': leaves(name)}
            for name, node in nodes.items() if not name.startswith('CarrierGroup')}

def flattened(source):
    nodes = expanded(bodies(source))
    text = source[:re.search(r'^enum ', source, re.M).start()]
    root = next(iter(nodes))
    text += 'enum ' + root + ': Formation {\n'
    text += '    static let verdict = Linter(Self.self)\n'
    for name, node in list(nodes.items())[1:]:
        text += '    enum ' + name + ': Formation {\n'
        text += '        @' + node['attribute'] + ' static var body: Never.Type {\n'
        text += ''.join(line + '\n' for line, _ in node['lines']) + '        }\n    }\n'
    text += '    @' + nodes[root]['attribute'] + ' static var body: Never.Type {\n'
    return text + ''.join(line + '\n' for line, _ in nodes[root]['lines']) + '    }\n}\n'

def diagnostics(output, mirror):
    # Compiler line numbers belong to the generated file. Compare the same leaf
    # and its column in the same scope/context after expanding only our groups.
    tree = expanded(bodies(mirror.read_text()))
    addresses = {number: (name, node['attribute'], i, line)
                 for name, node in tree.items() for i, (line, number) in enumerate(node['lines'])}
    result = []
    for line in output.splitlines():
        hit = re.match(re.escape(str(mirror)) + r':(\d+):(\d+): error: (.*)', line)
        if hit:
            number, column, message = hit.groups()
            assert int(number) in addresses, line
            result.append((*addresses[int(number)], int(column), message))
    return result

# The ordinary controls are also tested at the 127/128 boundary, in each
# context. DeclarationHead, Exempt and neighbour state live in the reader.
VECTORS = [
    ('ToolsScope', 'actor Uninvited {}\n', 1),
    ('ToolsScope', '/* outer /* nested */ end */\nactor Uninvited {}\n', 1),
    ('ToolsScope', 'public enum A {\npublic typealias Marker = GrammarExempt\n}\npublic enum B {\nactor Uninvited {}\n}\n', 1),
    ('ToolsScope', 'func f() { let x = 1 }\nCall { A; B }\n', 0),
    ('ToolsScope', 'public enum A {\npublic typealias Marker = Ordinary\n}\npublic enum B {\nactor Uninvited {}\n}\n', 1),
    ('ToolsScope', 'public enum Page {\npublic static let text = "a \\(call("actor /*", [1, 2]))"\n}\n', 0),
    ('ToolsScope', 'public enum A: GrammarExempt {\nactor Uninvited {}\n}\n', 0),
    ('ToolsScope', 'func f() {}\nCall {\n A; B\n}\n', 0),
    ('ToolsScope', 'public enum A {\n A; B\n}\n', 1),
    ('ToolsScope', 'let x = 1 public typealias Width = Word\n', 1),
    ('ToolsScope', 'public enum A {\n🦄\n}\n', 1),
    ('DemoScope', 'public typealias Width = U512\n', 1),
    ('SurfaceScope', 'public typealias Width = U512\n', 0),
    ('ToolsScope', '', 0),
    ('SystemScope', 'public enum Page {\npublic static var count: Int { 1 }\n}\n', 0),
    ('SystemScope', 'public enum A {\npublic static var mutable: Int { 1 }\n}\n', 1),
]

def main():
    bin_dir = Path(subprocess.check_output(['swift', 'build', '--show-bin-path'], cwd=ROOT, text=True).strip())
    with tempfile.TemporaryDirectory(prefix='vi-grammar-chunks-') as directory:
        temp = Path(directory)
        main = temp/'main.swift'
        main.write_text('''import Foundation
import GrammarLexicon
func refuse(_ needles: [String], _ body: () throws -> Void) {
 do { try body(); fatalError("unexpected carrier delivery acceptance") }
 catch {
  let said = String(describing: error)
  precondition(needles.allSatisfy { Data(said.utf8).range(of: Data($0.utf8)) != nil }, said)
  print("grammar-carriers refused: " + said)
 }
}
let host = URL(fileURLWithPath: CommandLine.arguments[1]).deletingLastPathComponent().appendingPathComponent("delivery")
let owner = [
 ("manifest", "Package.swift"),
 ("lexicon", "Sources/MirrorSource/Mirror.swift"),
 ("lattice", "Sources/VerificationIsIdentification/Core.swift"),
 ("alphabet", "Sources/Alphabet/Alphabet.swift"),
 ("notation", "Sources/Notation/Primitive.swift")
].map { Linter.CarrierFile(source: $0.0, path: $0.1, bytes: Data($0.0.utf8), carrier: false) }
let source = "Sources/Examples/Ordinary.swift"
let row = Linter.CarrierFile(source: source, path: "Sources/MirrorSource/" + Linter.carrierName(source) + ".swift", bytes: Data("formation".utf8), carrier: true)
let plan = try Linter.CarrierPlan(roster: [source], files: owner + [row])
let normal = host.appendingPathComponent("normal")
let installed = try plan.install(at: normal)
let verified = try plan.verify(at: normal)
precondition(installed == 1 && verified == 1)
for (index, target) in plan.files.enumerated() {
 let root = host.appendingPathComponent("failure-" + String(index))
 refuse([target.source + ":1", target.path, "cannot write"]) {
  _ = try plan.install(at: root, write: { bytes, url in
   if url == root.appendingPathComponent(target.path) { throw CocoaError(.fileWriteOutOfSpace) }
   try bytes.write(to: url, options: .withoutOverwriting)
  })
 }
}
let missing = host.appendingPathComponent("missing")
refuse([source + ":1", "cannot read back"]) {
 _ = try plan.install(at: missing, write: { bytes, url in
  if url != missing.appendingPathComponent(row.path) { try bytes.write(to: url) }
 })
}
let corrupt = host.appendingPathComponent("corrupt")
refuse([source + ":1", "written bytes differ"]) {
 _ = try plan.install(at: corrupt, write: { bytes, url in
  try (url == corrupt.appendingPathComponent(row.path) ? Data("wrong".utf8) : bytes).write(to: url)
 })
}
refuse(["cannot write"]) { _ = try plan.install(at: normal) }
let extra = normal.appendingPathComponent("Sources/MirrorSource/Undeclared.swift")
try Data("extra".utf8).write(to: extra)
refuse(["Sources/MirrorSource:1", "written Swift inputs differ"]) { _ = try plan.verify(at: normal) }
try FileManager.default.removeItem(at: extra)
let nested = normal.appendingPathComponent("Sources/MirrorSource/Sub/Undeclared.swift")
try FileManager.default.createDirectory(at: nested.deletingLastPathComponent(), withIntermediateDirectories: true)
try Data("extra".utf8).write(to: nested)
refuse(["Sources/MirrorSource:1", "written Swift inputs differ"]) { _ = try plan.verify(at: normal) }
try FileManager.default.removeItem(at: nested)
let nestedRow = Linter.CarrierFile(source: source, path: "Sources/MirrorSource/Sub/Expected.swift", bytes: row.bytes, carrier: true)
let nestedPlan = try Linter.CarrierPlan(roster: [source], files: owner + [nestedRow])
let nestedRoot = host.appendingPathComponent("nested")
let nestedCount = try nestedPlan.install(at: nestedRoot)
precondition(nestedCount == 1)
let copied = try Linter.swiftInputs(in: nestedRoot.appendingPathComponent("Sources/MirrorSource"))
precondition(copied == ["Mirror.swift", "Sub/Expected.swift"])
try FileManager.default.removeItem(at: normal.appendingPathComponent(row.path))
refuse([source + ":1", "cannot read back"]) { _ = try plan.verify(at: normal) }
refuse(["not one-to-one"]) { _ = try Linter.CarrierPlan(roster: [source], files: owner) }
refuse(["not one-to-one"]) { _ = try Linter.CarrierPlan(roster: [source, source], files: owner + [row]) }
let a = "Sources/Examples/T0095-A.swift"
let b = "Sources/Examples/T0095_A.swift"
let colliding = [a, b].map {
 Linter.CarrierFile(source: $0, path: "Sources/MirrorSource/" + Linter.carrierName($0) + ".swift", bytes: Data(), carrier: true)
}
refuse([a + ":1", b + ":1", "collision"]) { _ = try Linter.CarrierPlan(roster: [a, b], files: owner + colliding) }
let upper = "Sources/Examples/T-A.swift"
let lower = "Sources/Examples/T_a.swift"
let folded = [upper, lower].map {
 Linter.CarrierFile(source: $0, path: "Sources/MirrorSource/" + Linter.carrierName($0) + ".swift", bytes: Data(), carrier: true)
}
refuse([upper + ":1", lower + ":1", "collision"]) { _ = try Linter.CarrierPlan(roster: [upper, lower], files: owner + folded) }
let nfc = "Sources/Examples/Café.swift"
let nfd = "Sources/Examples/Café.swift"
precondition(nfc == nfd && !nfc.utf8.elementsEqual(nfd.utf8))
refuse([nfc + ":1", nfd + ":1", "different UTF-8 bytes"]) { _ = try Linter.inputRoster([nfc, nfd]) }
let repeated = try Linter.inputRoster([source, source])
precondition(repeated == [source])
let reserved = Linter.CarrierFile(source: source, path: "Sources/MirrorSource/Mirror.swift", bytes: Data(), carrier: true)
refuse([source + ":1", "lexicon:1", "collision"]) { _ = try Linter.CarrierPlan(roster: [source], files: owner + [reserved]) }
print("grammar-carriers: installed/read-back count; exact/folded collisions, canonical source aliases, all six write failures, missing/corrupt bytes, overwrite and recursive inputs controlled")
let jobs = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))) as! [[String: String]]
for job in jobs {
 let source = try String(contentsOfFile: job["source"]!, encoding: .utf8)
 try ("import GrammarLexicon\\n" + Linter.carried(source, path: "Probe.swift", scopeName: job["scope"]!)).write(toFile: job["mirror"]!, atomically: true, encoding: .utf8)
}
''')
        flags = ['-module-cache-path', str(temp/'modules'), '-I', str(bin_dir/'Modules')]
        objects = [str(path) for module in ('Notation', 'VerificationIsIdentification', 'Alphabet', 'GrammarLexicon', 'ContinuationRecord', 'Court')
                   for path in sorted((bin_dir/(module+'.build')).glob('*.swift.o'))]
        assert objects
        compile_probe = subprocess.run(['swiftc', *flags, *objects, *map(str, sorted((ROOT/'Sources/Tools/Grammar').glob('*.swift'))), str(main), '-o', str(temp/'probe')], capture_output=True, text=True)
        assert compile_probe.returncode == 0, compile_probe.stderr
        jobs, cases = [], []
        for index, (scope, source, wanted) in enumerate(VECTORS):
            for pad in (0, 127, 128):
                # Padding inside each block keeps context transitions close to a
                # group boundary; raw spans stay intact in the input stream.
                source_padded = 'Word\n'*pad + source.replace('{\n', '{\n' + 'Word\n'*pad)
                path = temp/f'input-{index}-{pad}.swift'; path.write_text(source_padded)
                mirror = temp/f'grouped-{index}-{pad}.swift'
                jobs.append(dict(source=str(path), scope=scope, mirror=str(mirror)))
                cases.append((mirror, wanted))
        # Exercises a second grouping level, rather than an unbounded parent.
        path = temp/'wide.swift'; path.write_text('Word\n'*(128*128+1))
        mirror = temp/'wide-mirror.swift'
        jobs.append(dict(source=str(path), scope='ToolsScope', mirror=str(mirror)))
        (temp/'jobs.json').write_text(json.dumps(jobs))
        subprocess.run([str(temp/'probe'), str(temp/'jobs.json')], check=True)
        for mirror, wanted in cases:
            nodes = bodies(mirror.read_text())
            assert all(len(node['lines']) <= 128 for node in nodes.values())
            flat = mirror.with_name('flat-'+mirror.name); flat.write_text(flattened(mirror.read_text()))
            outcomes = []
            for file in (mirror, flat):
                p = subprocess.run(['swiftc', '-typecheck', *flags, str(file)], capture_output=True, text=True, timeout=120)
                assert p.returncode == wanted, (file.name, wanted, p.stderr)
                outcomes.append(diagnostics(p.stderr, file))
            assert outcomes[0] == outcomes[1], (mirror.name, outcomes)
        wide = bodies((temp/'wide-mirror.swift').read_text())
        assert all(len(node['lines']) <= 128 for node in wide.values())
        assert len(expanded(wide)['Probe_swift']['lines']) == 128*128+1
        p = subprocess.run(['swiftc', '-typecheck', *flags, str(temp/'wide-mirror.swift')], capture_output=True, text=True, timeout=120)
        assert p.returncode == 0, p.stderr
        # Exercise the production CLI, not just the host delivery helper.
        import os, shutil
        world = temp/'world'; examples = world/'Sources/Examples'
        examples.mkdir(parents=True)
        actor = examples/'T0095-A.swift'; kept = examples/'T0095_A.swift'
        actor.write_text('actor T0095Hidden {}\n')
        kept.write_text('enum T0095Kept {}\n')
        env = dict(os.environ, VI_THEORY_PATH=str(ROOT))
        def grammar():
            p = subprocess.run([str(bin_dir/'Tools'), 'grammar'], cwd=world, env=env,
                               capture_output=True, text=True, timeout=240)
            for line in p.stdout.splitlines():
                if line.startswith('scratch kept at '):
                    shutil.rmtree(line.removeprefix('scratch kept at '), ignore_errors=True)
            return p
        p = grammar()
        assert p.returncode == 2 and 'collision' in p.stdout and all('Sources/Examples/'+name+':1' in p.stdout for name in (actor.name, kept.name)), (p.returncode, p.stdout)
        kept.unlink()
        p = grammar()
        assert p.returncode == 1 and 'ActorWord' in p.stdout, (p.returncode, p.stdout)
        actor.unlink(); kept.write_text('enum T0095Kept {}\n')
        p = grammar()
        assert p.returncode == 0 and '1 carrier file(s) written and read back' in p.stdout, (p.returncode, p.stdout)
        kept.unlink()
        upper, lower = examples/'T-A.swift', examples/'T_a.swift'
        upper.write_text('enum Upper {}\n'); lower.write_text('enum Lower {}\n')
        p = grammar()
        assert p.returncode == 2 and 'collision' in p.stdout and all('Sources/Examples/'+name+':1' in p.stdout for name in (upper.name, lower.name)), (p.returncode, p.stdout)
        upper.unlink(); lower.unlink()
        if hasattr(os, 'geteuid') and os.geteuid() != 0:
            closed = examples/'Unreadable'; closed.mkdir()
            (closed/'Hidden.swift').write_text('enum Hidden {}\n')
            try:
                closed.chmod(0)
                p = grammar()
                assert p.returncode == 2 and 'cannot enumerate source path' in p.stdout and 'Unreadable:1' in p.stdout, (p.returncode, p.stdout)
            finally:
                closed.chmod(0o700)
            print('grammar-carriers CLI: unreadable subdirectory refuses with its address')
        print('grammar-carriers CLI: exact/folded collisions name both inputs; actor alone refuses; ordinary neighbour holds with one read-back carrier')
        print('grammar-chunks: 48 compiler pairs keep verdicts, leaf addresses, columns and scope/context; all groups bounded at 128')

if __name__ == '__main__':
    main()
