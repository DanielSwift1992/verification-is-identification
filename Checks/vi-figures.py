#!/usr/bin/env python3
"""Read four DocumentKit worlds and verify their nine source-stamped projections."""
import argparse
import hashlib
from html import escape
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import urllib.request
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parent.parent
WORLD = Path('Worlds/Documentation')


def digest(data):
    return hashlib.sha256(data).hexdigest()


def command(argv, **kwargs):
    result = subprocess.run(argv, capture_output=True, timeout=kwargs.pop('timeout', 120), **kwargs)
    if result.returncode:
        raise ValueError(' '.join(map(str, argv[:3])) + ':\n' + (result.stdout + result.stderr).decode(errors='replace')[-16000:])
    return result.stdout


def pinned_bytes(pin, item, cache):
    address = pin['repository'] + '@' + pin['revision'] + ':' + item['path']
    target = cache / item['sha256']
    if target.exists():
        data = target.read_bytes()
    else:
        repository = pin['repository'].removeprefix('https://github.com/')
        if '/' not in repository or not re.fullmatch('[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', repository):
            raise ValueError(address + ': unsupported input repository')
        url = 'https://raw.githubusercontent.com/' + repository + '/' + pin['revision'] + '/' + item['path']
        try:
            data = urllib.request.urlopen(url, timeout=60).read()
        except Exception as error:
            raise ValueError(address + ': unavailable pinned input: ' + str(error)) from error
        if digest(data) != item['sha256']:
            raise ValueError(address + ': input SHA-256 differs')
        cache.mkdir(parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile(dir=cache, delete=False) as stream:
            stream.write(data)
            temporary = Path(stream.name)
        os.replace(temporary, target)
    if digest(data) != item['sha256']:
        raise ValueError(address + ': input SHA-256 differs')
    return data


def stamp(svg, input_hash):
    return svg.replace(b'\n', b'\n<!-- vi-input-sha256: ' + input_hash.encode() + b' -->\n', 1)


def input_digest(inputs):
    return digest(b''.join(name.encode() + b'\0' + inputs[name] + b'\0' for name in sorted(inputs)))


def namespace(svg, root):
    text = svg.decode()
    identifiers = re.findall(r'\bid="([^"]+)"', text)
    assert len(set(identifiers)) == len(identifiers), root + ': duplicate SVG id'
    references = re.findall(r'href="#([^"]+)"|url\(#([^)]+)\)', text)
    assert {name for pair in references for name in pair if name} <= set(identifiers), root + ': unresolved SVG id'
    mapping = {name: root + '-' + name for name in identifiers}
    text = re.sub(r'\bid="([^"]+)"', lambda m: 'id="' + mapping[m[1]] + '"', text)
    text = re.sub(r'href="#([^"]+)"', lambda m: 'href="#' + mapping[m[1]] + '"', text)
    text = re.sub(r'url\(#([^)]+)\)', lambda m: 'url(#' + mapping[m[1]] + ')', text)
    text = re.sub(r'aria-labelledby="([^"]+)"', lambda m: 'aria-labelledby="' + ' '.join(mapping[name] for name in m[1].split()) + '"', text)
    return text.encode()


def require_equal(path, actual, expected):
    if actual != expected:
        raise ValueError(str(path) + ': stale projection; run python3 Checks/vi-figures.py --write')


def require_coverage(font, measurements):
    required = font['required_codepoints']
    assert required and len(set(required)) == len(required), font['input'] + ': empty or repeated declared glyph coverage'
    available = {row['codepoint'] for row in measurements['glyphs'] if row['glyph'] > 0}
    for code in required:
        if code not in available:
            raise ValueError(font['input'] + ': missing declared glyph U+' + format(code, '04X'))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    manifest_path = WORLD / 'figures.json'
    manifest = json.loads((ROOT / manifest_path).read_text())
    outputs = manifest['outputs']
    assert len(outputs) == 9 and len({r['output'] for r in outputs}) == 9, 'expected nine distinct outputs'
    for row in outputs:
        assert re.fullmatch('[A-Za-z_][A-Za-z_0-9]*', row['root']), 'invalid root: ' + row['root']
        assert not Path(row['output']).is_absolute() and '..' not in Path(row['output']).parts
    font = manifest['font']
    subprocess.run(['swift', 'build', '--product', 'FontMetrics'], cwd=ROOT, check=True)
    subprocess.run(['swift', 'build', '--target', 'DocumentKit'], cwd=ROOT, check=True)
    # Palette and Bindings are verified source inputs. The showcase package is never built.
    subprocess.run(['swift', 'build', '--target', 'VerificationIsIdentification'], cwd=ROOT, check=True)
    binary = Path(subprocess.check_output(['swift', 'build', '--show-bin-path'], cwd=ROOT, text=True).strip())
    with tempfile.TemporaryDirectory(prefix='vi-figures-') as directory:
        temp = Path(directory)
        cache = ROOT / '.build/figure-inputs'
        pin = manifest['palette']
        assert re.fullmatch('[a-f0-9]{40}', pin['revision']), 'palette: revision must be a full pin'
        inputs = {}
        sources = []
        for item in pin['files']:
            assert re.fullmatch('[a-f0-9]{64}', item['sha256']), 'palette: invalid hash'
            data = pinned_bytes(pin, item, cache)
            path = temp / Path(item['path']).name
            path.write_bytes(data)
            sources.append(path)
            inputs[pin['repository'] + '@' + pin['revision'] + ':' + item['path']] = data
        asset_pin = json.loads((ROOT / 'Assets/DejaVuSans.json').read_text())
        for item in asset_pin['files']:
            require_equal(item['path'] + ': SHA-256', digest((ROOT / item['path']).read_bytes()), item['sha256'])
        fresh_font = temp / 'Font.swift'
        command([str(binary / 'FontMetrics'), '--outlines', font['input'], font['corpus'], str(fresh_font)], cwd=ROOT)
        measured = json.loads(Path(str(fresh_font) + '.json').read_text())
        require_coverage(font, measured)
        missing_declared = dict(measured, glyphs=[row for row in measured['glyphs'] if row['codepoint'] != font['required_codepoints'][0]])
        try:
            require_coverage(font, missing_declared)
        except ValueError as error:
            assert 'U+' + format(font['required_codepoints'][0], '04X') in str(error)
        else:
            raise ValueError('admitted lost declared glyph')
        for source, destination in [(fresh_font, ROOT / font['projection']),
                                    (Path(str(fresh_font) + '.json'), ROOT / (font['projection'] + '.json'))]:
            if args.write:
                destination.write_bytes(source.read_bytes())
            else:
                require_equal(destination.relative_to(ROOT), destination.read_bytes(), source.read_bytes())
        paths = [manifest_path, Path(font['input']), Path(font['license']), Path(font['corpus']), Path('Assets/DejaVuSans.json'), Path('Package.swift'), Path('Checks/vi-figures.py')]
        paths += [Path(name) for name in manifest['grounds']]
        paths += sorted((ROOT / WORLD).glob('*.swift'))
        for target in ['Notation', 'Alphabet', 'VerificationIsIdentification', 'DocumentKit', 'FontMetrics']:
            paths += sorted((ROOT / 'Sources' / target).glob('*.swift'))
        for path in paths:
            absolute = path if path.is_absolute() else ROOT / path
            relative = absolute.relative_to(ROOT)
            data = absolute.read_bytes()
            inputs[str(relative)] = data
            if relative.parent == WORLD and relative.suffix == '.swift':
                staged = temp / relative.name
                staged.write_bytes(data)
                sources.append(staged)
        input_hash = input_digest(inputs)
        native = temp / 'main.swift'
        contrast = ['TextOnPaper', 'MutedOnPaper', 'LawOnPaper', 'OkOnPaper', 'RefusalOnPaper', 'TextOnSurfaceCardDim', 'MutedOnSurfaceCardDim']
        checks = '\n'.join('precondition(' + name + '.R1.Left.count == ' + name + '.R1.Right.count, "figure contrast: ' + name + '")' for name in contrast)
        native.write_text('import Foundation\nimport Notation\nimport DocumentKit\n' + checks + '\n'
            + 'enum MissingRows: Close {}\nextension MissingRows { static var typeName: String { "32|260|" } }\n'
            + 'enum MissingFace: OutlineFontFace { typealias Units = FigureFontUnits; typealias Glyphs = MissingRows }\n'
            + 'enum Member: Close {}\nextension Member { static var typeName: String { "\\u{2208}" } }\n'
            + 'enum Zero: Close {}\nextension Zero { static var typeName: String { "0" } }\n'
            + 'enum Start: Close {}\nextension Start { static var typeName: String { "start" } }\n'
            + 'enum MissingLabel: OutlineLabel { typealias Font = MissingFace; typealias Content = Member; typealias X = Zero; typealias Y = Zero; typealias Size = FigureFontUnits; typealias Fill = FigureLight.Ink; typealias Anchor = Start }\n'
            + 'if CommandLine.arguments[1] == "--missing-glyph" { print(MissingLabel.typeName); exit(0) }\n'
            + 'switch CommandLine.arguments[1] {\n'
            + ''.join('case "' + r['root'] + '": print(' + r['root'] + '.typeName, terminator: "")\n' for r in outputs)
            + 'default: fputs("unknown figure root\\n", stderr); exit(2)\n}\n')
        objects = [str(p) for name in ['Notation', 'Alphabet', 'VerificationIsIdentification', 'DocumentKit'] for p in sorted((binary / (name + '.build')).glob('*.o'))]
        executable = temp / 'read'
        command(['swiftc', '-whole-module-optimization', '-module-name', 'ViDocumentationFigures', '-I', str(binary / 'Modules'), '-module-cache-path', str(temp / 'modules'), *map(str, sources), str(native), *objects, '-o', str(executable)], timeout=240)
        generated = {}
        raw = {}
        for row in outputs:
            svg = command([str(executable), row['root']], timeout=30)
            xml = ET.fromstring(svg)
            assert xml.tag == '{http://www.w3.org/2000/svg}svg', row['output'] + ': not SVG'
            assert not list(xml.iter('{http://www.w3.org/2000/svg}text')), row['output'] + ': installed font dependency'
            svg = namespace(svg, row['root'])
            license_data = escape((ROOT / font['license']).read_text()).encode()
            svg = svg.replace(b'\n', b'\n<metadata id="' + row['root'].encode() + b'-font-license">' + license_data + b'</metadata>\n', 1)
            raw[row['output']] = svg
            generated[row['output']] = stamp(svg, input_hash)
        # Controls exercise the production comparison and the native missing-glyph refusal.
        first = outputs[0]['output']
        changed_inputs = dict(inputs)
        source = str(WORLD / 'Method.swift')
        changed_inputs[source] += b'\n// input control\n'
        changed_input_hash = input_digest(changed_inputs)
        assert changed_input_hash != input_hash
        for label, changed in [('output byte', generated[first] + b'!'), ('input byte', stamp(raw[first], changed_input_hash))]:
            try:
                require_equal(first, changed, generated[first])
            except ValueError as error:
                assert first in str(error)
            else:
                raise ValueError(first + ': admitted changed ' + label)
        missing = subprocess.run([str(executable), '--missing-glyph'], capture_output=True, timeout=30)
        assert missing.returncode and b'Outline glyph missing: U+2208' in missing.stderr, 'native missing-glyph refusal lost its address'
        wrong_font = subprocess.run([str(binary / 'FontMetrics'), '--outlines', 'Assets/InterVariable.ttf', font['corpus'], str(temp / 'wrong-font.swift')], cwd=ROOT, capture_output=True, timeout=30)
        assert wrong_font.returncode == 2 and b'missing glyph U+' in wrong_font.stderr, 'FontMetrics silently substituted an absent glyph'
        summary = dict(inputSHA256=input_hash, inputs={name: digest(data) for name, data in sorted(inputs.items())},
                       outputs={name: digest(data) for name, data in generated.items()}, contrast=contrast)
        generated[str(WORLD / 'artifacts.json')] = (json.dumps(summary, indent=2) + '\n').encode()
        for name, data in generated.items():
            if args.write:
                (ROOT / name).write_bytes(data)
            else:
                require_equal(name, (ROOT / name).read_bytes(), data)
        print('vi figures: four worlds, nine stamped SVGs; seven contrast equalities; changed input/output and missing glyph refused')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, AssertionError, OSError, subprocess.SubprocessError) as error:
        raise SystemExit('vi figures: ' + str(error))
