#!/usr/bin/env python3
"""Formation groups preserve each builder's ordered statements and refusals."""
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
    ('ToolsScope', '/* \\/*/ actor Uninvited {} */\n', 1),
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
let jobs = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))) as! [[String: String]]
for job in jobs {
 let source = try String(contentsOfFile: job["source"]!, encoding: .utf8)
 try ("import GrammarLexicon\\n" + Linter.carried(source, path: "Probe.swift", scopeName: job["scope"]!)).write(toFile: job["mirror"]!, atomically: true, encoding: .utf8)
}
''')
        flags = ['-module-cache-path', str(temp/'modules'), '-I', str(bin_dir/'Modules')]
        objects = [str(path) for module in ('Notation', 'VerificationIsIdentification', 'Alphabet', 'GrammarLexicon')
                   for path in sorted((bin_dir/(module+'.build')).glob('*.swift.o'))]
        assert objects
        subprocess.run(['swiftc', *flags, *objects, *map(str, sorted((ROOT/'Sources/Tools/Grammar').glob('*.swift'))), str(main), '-o', str(temp/'probe')], check=True, capture_output=True)
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
        print('grammar-chunks: 48 compiler pairs keep verdicts, leaf addresses, columns and scope/context; all groups bounded at 128')

if __name__ == '__main__':
    main()
