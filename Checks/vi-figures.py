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


def read_registers(data, binary, temp, requested, weights):
    """Read the owner's actual register types and count equalities in their own scope."""
    text = data.decode()
    names = re.findall(r'^public enum (\w+): Register \{', text, re.M)
    assert names and set(requested) <= set(names), 'style: undeclared gate register'
    laws = re.findall(r'^public typealias (\w+) = (?:Taller|AtLeast)<', text, re.M)
    source = temp / 'bench-registers.swift'
    source.write_bytes(b'import VerificationIsIdentification\n' + data)
    native = temp / 'main.swift'
    checks = '\n'.join('precondition(' + n + '.Left.count == ' + n + '.Right.count, "gate register: ' + n + '")' for n in laws)
    records = []
    for name in names:
        lead = name + 'Lead.count' if re.search(r'^public typealias ' + name + r'Lead = ', text, re.M) else 'NSNull()'
        records.append('records["' + name + '"] = ["face": String(describing: ' + name + '.On.self), "stress": String(describing: ' + name + '.Set.self), "sizeTenths": ' + name + 'Size.count, "leadingHundredths": ' + lead + '] as [String: Any]')
    native.write_text('import Foundation\nimport VerificationIsIdentification\npublic enum UnaryArithmeticEncoding {}\n' + checks + '\nvar records: [String: Any] = [:]\n' + '\n'.join(records) + '\nprint(String(data: try! JSONSerialization.data(withJSONObject: records, options: [.sortedKeys]), encoding: .utf8)!)\n')
    objects = [str(p) for name in ['Notation', 'Alphabet', 'VerificationIsIdentification'] for p in sorted((binary / (name + '.build')).glob('*.o'))]
    executable = temp / 'registers'
    command(['swiftc', '-whole-module-optimization', '-module-name', 'ViFigureRegisters', '-I', str(binary / 'Modules'), '-module-cache-path', str(temp / 'modules'), str(source), str(native), *objects, '-o', str(executable)], timeout=240)
    records = json.loads(command([str(executable)]))
    projection = 'import Notation\nimport DocumentKit\n\n// GENERATED from the pinned gate registers by Checks/vi-figures.py.\n'
    for name in sorted(requested):
        row = records[name]
        face = 'Figure' + row['face'] + str(weights[row['stress']])
        if face not in ['FigureSans400', 'FigureSans600', 'FigureMono400']:
            raise ValueError('stdlib/bench-registers.swift:' + name + ': no measured face for ' + face)
        size = format(row['sizeTenths'] / 10, 'g')
        projection += 'public enum Figure' + name + 'Size: Close {}\nextension Figure' + name + 'Size { public static var typeName: String { "' + size + '" } }\n'
        projection += 'public enum Figure' + name + ': FigureRegister {\n    public typealias Font = ' + face + '\n    public typealias Size = Figure' + name + 'Size\n}\n'
    fresh = temp / 'Registers.swift'
    fresh.write_text(projection)
    report = dict(registers=records, used=sorted(requested), equalities=laws)
    Path(str(fresh) + '.json').write_text(json.dumps(report, indent=2) + '\n')
    return fresh, report


def label_registers():
    """Read each label's explicit register and paint from the world's sole declaration."""
    ledger = []
    for world in ['Method', 'Architecture', 'ThreeSources', 'Construction']:
        path = WORLD / (world + '.swift')
        source = (ROOT / path).read_text()
        atoms = {n: json.loads('"' + v + '"') for n, v in re.findall(r'extension (\w+) \{ public static var typeName: String \{ "((?:[^"\\]|\\.)*)" \} \}', source)}
        for name, body in re.findall(r'public enum (\w+)<Theme: DrawingPalette>: OutlineLabel \{(.*?)\n\}', source, re.S):
            fields = dict(re.findall(r'public typealias (\w+) = ([^\n]+)', body))
            register = re.fullmatch(r'Figure([A-Za-z_0-9]+)', fields.get('Register', ''))
            paint = re.fullmatch(r'Theme\.([A-Za-z_0-9]+)', fields.get('Fill', ''))
            if not register or not paint or fields.get('Font') != 'Register.Font' or fields.get('Size') != 'Register.Size':
                raise ValueError(str(path) + ':' + name + ': face and size must name the declared gate register')
            ledger.append(dict(world=world, declaration=name, text=atoms[fields['Content']], register=register[1], paint=paint[1]))
    assert ledger, 'figures: no declared labels'
    return ledger


def require_registers(svg, ledger, registers, paints, theme, weights, address):
    """Check the rendered face and size against the owner's measured register."""
    declared = {row['declaration']:row for row in ledger}
    used = set()
    for node in ET.fromstring(svg):
        text = node.get('data-vi-text')
        if text is None: continue
        name = (node.get('data-declaration') or '').split('<')[0].split('.')[-1]
        row = declared.get(name)
        if row is None or row['text'] != text:
            raise ValueError(address + ': missing or changed label declaration ' + name)
        register = registers[row['register']]
        scale = float(re.fullmatch(r'translate\([^)]+\) scale\(([^ ]+) [^)]+\)', node.get('transform'))[1])
        size_tenths = round(scale * 2048 * 10, 7)
        expected_face = 'Figure' + register['face'] + str(weights[register['stress']])
        expected_paint = paints[row['paint'][0].lower() + row['paint'][1:] + '-' + theme]
        # Paint attributes have the clipped sRGB fallback; the following CSS retains exact XYZ.
        style = node.get('style', '')
        if (node.get('data-font-face'), size_tenths) != (expected_face, register['sizeTenths']) or ('fill:'+expected_paint+';' not in style and node.get('fill') != expected_paint):
            raise ValueError(address + ':' + name + ': undeclared register, size or paint')
        used.add((node.get('data-font-face'), size_tenths))
    return sorted(used)


def prepare_font(font, binary, temp):
    """Measure explicit source assignments and each requested variable-font instance."""
    sources = {s['name']: s for s in font['sources']}
    assert set(sources) == {'Inter', 'DejaVu', 'DejaVuMono'}, 'font: expected the declared sans, signs and mono sources'
    assignments = json.loads((ROOT / font['assignments']).read_text())
    codes = sorted(set(map(ord, (ROOT / font['corpus']).read_text().replace('\n', '').replace('\r', ''))))
    assert [r['codepoint'] for r in assignments] == codes, 'font: assignment corpus differs'
    assert all(r['character'] == chr(r['codepoint']) for r in assignments), 'font: assignment character differs'
    expected_sources = {'Sans': {r['codepoint']: r['source'] for r in assignments},
                        'Mono': {r['codepoint']: r['monoSource'] for r in assignments}}
    assert {c for c in codes if expected_sources['Sans'][c] == 'DejaVu'} == {0x2208, 0x2286, 0x22C2, 0x2218}, 'font: undeclared supplementary sign'
    assert set(expected_sources['Mono'].values()) == {'DejaVuMono'}, 'font: undeclared mono source'
    coverage = {}
    for name, source in sources.items():
        require_equal(source['input'] + ': SHA-256', digest((ROOT / source['input']).read_bytes()), source['sha256'])
        require_equal(source['license'] + ': SHA-256', digest((ROOT / source['license']).read_bytes()), source['licenseSHA256'])
        destination = temp / (name + '-coverage.json')
        command([str(binary / 'FontMetrics'), '--coverage', source['input'], font['corpus'], str(destination)], cwd=ROOT)
        coverage[name] = json.loads(destination.read_text())
    primary = {r['codepoint']: r['glyph'] for r in coverage['Inter']['glyphs']}
    mono = {r['codepoint']: r['glyph'] for r in coverage['DejaVuMono']['glyphs']}
    for row in assignments:
        code = row['codepoint']
        expected = 'Inter' if primary[code] else 'DejaVu'
        if row['source'] != expected:
            raise ValueError(font['assignments'] + ': wrong source for U+' + format(code, '04X'))
        if not mono[code]:
            raise ValueError(font['assignments'] + ': missing mono glyph U+' + format(code, '04X'))
    if font['weights'] != [400, 600] or font['stressWeights'] != {'Plain': 400, 'Firm': 600}:
        raise ValueError('font: gate Plain/Firm must use measured 400/600 instances')
    measured = {}
    rows = {}
    for name, source in sources.items():
        corpus = temp / (name + '-characters.txt')
        corpus.write_text(''.join(chr(c) for c in codes if any(a[c] == name for a in expected_sources.values())) + '\n')
        for weight in font['weights'] if name == 'Inter' else [400]:
            output = temp / (name + str(weight) + '.swift')
            argv = [str(binary / 'FontMetrics'), '--outlines', source['input'], str(corpus), str(output), '--name', name + str(weight), '--source', name]
            if name == 'Inter':
                argv += ['--weight', str(weight)]
            command(argv, cwd=ROOT)
            report = json.loads(Path(str(output) + '.json').read_text())
            if name == 'Inter':
                axis = {a['identifier']: a['selected'] for a in report['variationAxes']}
                assert axis[0x77676874] == weight, 'font: wght axis differs'
            measured[name + str(weight)] = report
            glyphs = output.read_text().split('    """')[1].strip().splitlines()
            rows[name + str(weight)] = {int(r.strip().split('|', 1)[0]): r.strip().split('|', 4) for r in glyphs}
    units = measured['Inter400']['unitsPerEm']
    assert all(r['unitsPerEm'] == units for r in measured.values()), 'font: source units require an explicit conversion'
    text = 'import Notation\nimport DocumentKit\n\n// GENERATED by FontMetrics from the explicit character-source table and wght instances.\n'
    mono_advances = {r[1] for r in rows['DejaVuMono400'].values()}
    assert len(mono_advances) == 1, 'font: declared mono advances differ'
    for family, weight in [('Sans', w) for w in font['weights']] + [('Mono', 400)]:
        face = 'Figure' + family + str(weight)
        atlas = []
        for code in codes:
            source = expected_sources[family][code]
            used_weight = weight if source == 'Inter' else 400
            row = rows[source + str(used_weight)][code]
            atlas.append('|'.join([row[0], row[1], source, str(used_weight), row[4]]))
        text += 'public enum ' + face + 'Units: Close {}\nextension ' + face + 'Units { public static var typeName: String { "' + str(units) + '" } }\n'
        text += 'public enum ' + face + 'Glyphs: Close {}\nextension ' + face + 'Glyphs { public static var typeName: String {\n    """\n' + '\n'.join('    ' + r for r in atlas) + '\n    """\n} }\n'
        text += 'public enum ' + face + ': OutlineFontFace {\n    public typealias Units = ' + face + 'Units\n    public typealias Glyphs = ' + face + 'Glyphs\n}\n'
    # Genuine weight variation must alter both outlines and advances at the source.
    assert rows['Inter400'][65][4] != rows['Inter600'][65][4], 'font: firm outline equals plain'
    assert rows['Inter400'][65][1] != rows['Inter600'][65][1], 'font: instance advances were not measured'
    report = dict(unitsPerEm=units, assignments=assignments, instances=measured, coverage=coverage,
                  glyphs=[dict(r, source=name) for name in sources for r in measured[name + '400']['glyphs']])
    fresh = temp / 'Font.swift'
    fresh.write_text(text)
    Path(str(fresh) + '.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    return fresh, report, expected_sources


def require_sources(svg, assignments, address):
    xml = ET.fromstring(svg)
    ns = '{http://www.w3.org/2000/svg}'
    definitions = {r.get('id'): r for r in xml.iter(ns + 'path') if r.get('data-font-source')}
    count = dict(Inter=0, DejaVu=0, DejaVuMono=0)
    weights = set()
    for label in xml.iter(ns + 'g'):
        if label.get('data-vi-text') is None:
            continue
        face = label.get('data-font-face')
        match = re.fullmatch(r'Figure(Sans|Mono)(400|600)', face or '')
        if not match or (match[1] == 'Mono' and match[2] != '400'):
            raise ValueError(address + ': unmeasured font face ' + str(face))
        family, requested_weight = match[1], int(match[2])
        uses = list(label)
        codes = [ord(c) for c in label.get('data-vi-text')]
        if len(uses) != len(codes):
            raise ValueError(address + ': text placements differ')
        for use, code in zip(uses, codes):
            glyph = definitions.get(use.get('href', '').removeprefix('#'))
            if glyph is None or glyph.get('data-font-source') != assignments[family][code] or use.get('data-codepoint') != str(code):
                raise ValueError(address + ': wrong glyph source U+' + format(code, '04X'))
            source = glyph.get('data-font-source')
            weight = int(glyph.get('data-font-weight'))
            if source == 'Inter' and requested_weight != weight:
                raise ValueError(address + ': wrong Inter weight U+' + format(code, '04X'))
            if source in ['DejaVu', 'DejaVuMono'] and weight != 400:
                raise ValueError(address + ': supplementary sign uses an undeclared weight')
            count[source] += 1
            weights.add(weight)
    return dict(placements=count, weights=sorted(weights))


def require_grounds(svg, paints, colours, address):
    """Match each label's actual panel with its native LegiblePaintPair ground."""
    xml = ET.fromstring(svg)
    ns = '{http://www.w3.org/2000/svg}'
    panels = []
    used = set()
    def paint(node, property):
        rules=[r.split(':',1)[1] for r in node.get('style','').split(';') if r.startswith(property+':')]
        return rules[-1] if rules else node.get(property)
    for node in xml:
        if node.tag in [ns+'rect',ns+'circle'] and paint(node,'fill') != 'none': panels.append(node)
        if node.get('data-vi-text') is None: continue
        x,y,scale,_=map(float,re.fullmatch(r'translate\(([^ ]+) ([^)]+)\) scale\(([^ ]+) ([^)]+)\)',node.get('transform')).groups())
        positions=[float(re.fullmatch(r'translate\(([^ ]+) 0\)',g.get('transform'))[1])*scale+x for g in node]
        if positions:x=(min(positions)+max(positions))/2
        y-=scale*2048*.35
        def contains(p):
            if p.tag==ns+'circle':return (x-float(p.get('cx')))**2+(y-float(p.get('cy')))**2<=float(p.get('r'))**2
            return float(p.get('x','0'))<=x<=float(p.get('x','0'))+float(p.get('width')) and float(p.get('y','0'))<=y<=float(p.get('y','0'))+float(p.get('height'))
        background=next((paint(p,'fill') for p in reversed(panels) if contains(p)),None)
        proof=node.get('data-legibility')
        if not proof or background!=node.get('data-background'):
            raise ValueError(address+':'+str(node.get('data-declaration'))+': undeclared text/background pair')
        used.add(proof)
    return sorted(used)


def prune_glyphs(svg):
    xml=ET.fromstring(svg)
    ns='{http://www.w3.org/2000/svg}'
    used={node.get('href','').removeprefix('#') for node in xml.iter(ns+'use')}
    # The native outline writer's one-line definitions are retained only when referenced.
    return re.sub(rb'^<path id="([^"]+)" data-font-source=[^\n]*\n',lambda m:m[0] if m[1].decode() in used else b'',svg,flags=re.M)


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
    # Gate colours and registers are read-only data; no gate product is built.
    subprocess.run(['swift', 'build', '--target', 'VerificationIsIdentification'], cwd=ROOT, check=True)
    binary = Path(subprocess.check_output(['swift', 'build', '--show-bin-path'], cwd=ROOT, text=True).strip())
    with tempfile.TemporaryDirectory(prefix='vi-figures-') as directory:
        temp = Path(directory)
        cache = ROOT / '.build/figure-inputs'
        pin = manifest['style']
        assert re.fullmatch('[a-f0-9]{40}', pin['revision']), 'style: revision must be a full pin'
        assert pin['coordinateScale'] == 1000, 'style: gate coordinates are thousandths'
        ledger = label_registers()
        inputs = {}
        sources = []
        style_data = {}
        for kind in ['palette', 'registers', 'rule', 'fonts', 'weightRule']:
            item = pin[kind]
            assert re.fullmatch('[a-f0-9]{64}', item['sha256']), 'style: invalid hash'
            data = pinned_bytes(pin, item, cache)
            style_data[kind] = data
            inputs[pin['repository'] + '@' + pin['revision'] + ':' + item['path']] = data
        assert '600 ' in style_data['weightRule'].decode() and 'func registerTokens' in style_data['weightRule'].decode(), 'style: missing Plain/Firm projection rule'
        gate_fonts = json.loads(style_data['fonts'])
        assert gate_fonts['fonts'] == [next(s['sha256'] for s in font['sources'] if s['name'] == 'Inter')], 'style: primary Inter differs from gate font declaration'
        # Add the vi import context to these bare declarations; the input hash
        # records the owner's exact bytes before this compilation preamble.
        palette = temp / 'bench-palette.swift'
        palette.write_bytes(b'import VerificationIsIdentification\n' + style_data['palette'])
        sources.append(palette)
        fresh_registers, register_report = read_registers(style_data['registers'], binary, temp,
                                                        {r['register'] for r in ledger}, font['stressWeights'])
        asset_pin = json.loads((ROOT / 'Assets/DejaVuSans.json').read_text())
        for item in asset_pin['files']:
            require_equal(item['path'] + ': SHA-256', digest((ROOT / item['path']).read_bytes()), item['sha256'])
        fresh_font, measured, assignments = prepare_font(font, binary, temp)
        require_coverage(font, measured)
        missing_declared = dict(measured, glyphs=[row for row in measured['glyphs'] if row['codepoint'] != font['required_codepoints'][0]])
        try:
            require_coverage(font, missing_declared)
        except ValueError as error:
            assert 'U+' + format(font['required_codepoints'][0], '04X') in str(error)
        else:
            raise ValueError('admitted lost declared glyph')
        for source, destination in [(fresh_font, ROOT / font['projection']),
                                    (Path(str(fresh_font) + '.json'), ROOT / (font['projection'] + '.json')),
                                    (fresh_registers, ROOT / pin['projection']),
                                    (Path(str(fresh_registers) + '.json'), ROOT / (pin['projection'] + '.json'))]:
            if args.write:
                destination.write_bytes(source.read_bytes())
            else:
                require_equal(destination.relative_to(ROOT), destination.read_bytes(), source.read_bytes())
        paths = [Path(manifest['layout']['input']), Path('Worlds/Documentation/binding.json'), Path('Scripts/drawing-binding.py'), Path('Checks/documentation-binding.py'), manifest_path, Path(font['input']), Path(font['license']), Path(font['corpus']), Path('Assets/DejaVuSans.json'), Path(font['assignments']), Path('Package.swift'), Path('Checks/vi-figures.py')]
        paths += [Path(item[key]) for item in font['sources'] for key in ['input', 'license']]
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
        colours = pin['colours']
        contrast = [r['contrast'] for r in colours if r['contrast']]
        assert len(set(contrast)) == len(contrast) == 18, 'style: expected the eighteen gate paper pairs'
        checks = '\n'.join('precondition(' + name + '.Left.count == ' + name + '.Right.count, "gate figure contrast: ' + name + '")' for name in contrast)
        declarations = []
        paint_fields = []
        value=json.loads((ROOT/WORLD/'binding.json').read_text())
        for row in colours:
            values=['String(Double('+row['coordinates'][axis]+'.count) / 1000)' for axis in 'XYZ']
            expression='"color(xyz-d65 " + '+' + " " + '.join(values)+' + ")"'
            paint_fields.append('paints["'+row['role']+'-'+row['theme']+'"] = '+expression)
        paint_case = 'case "--paints": print(String(data: try! JSONSerialization.data(withJSONObject: paints, options: [.sortedKeys]), encoding: .utf8)!)\n'
        native.write_text('import Foundation\nimport Notation\nimport DocumentKit\nimport VerificationIsIdentification\npublic enum UnaryArithmeticEncoding {}\n' + checks + '\n' + '\n'.join(declarations) + '\nvar paints: [String: String] = [:]\n' + '\n'.join(paint_fields) + '\n'
            + 'enum MissingRows: Close {}\nextension MissingRows { static var typeName: String { "32|260|Inter|400|" } }\n'
            + 'enum MissingFace: OutlineFontFace { typealias Units = FigureSans400Units; typealias Glyphs = MissingRows }\n'
            + 'enum Member: Close {}\nextension Member { static var typeName: String { "\\u{2208}" } }\n'
            + 'enum Zero: Close {}\nextension Zero { static var typeName: String { "0" } }\n'
            + 'enum Start: Close {}\nextension Start { static var typeName: String { "start" } }\n'
            + 'enum MissingLabel: OutlineLabel { typealias Font = MissingFace; typealias Content = Member; typealias X = Zero; typealias Y = Zero; typealias Size = FigureSans400Units; typealias Fill = FigureLight.Ink; typealias Legibility = FigureLight.InkOnPaper; typealias Anchor = Start }\n'
            + 'if CommandLine.arguments[1] == "--missing-glyph" { print(MissingLabel.typeName); exit(0) }\n'
            + 'switch CommandLine.arguments[1] {\n'
            + paint_case
            + ''.join('case "' + r['root'] + '": print(' + r['root'] + '.typeName, terminator: "")\n' for r in outputs)
            + 'default: fputs("unknown figure root\\n", stderr); exit(2)\n}\n')
        objects = [str(p) for name in ['Notation', 'Alphabet', 'VerificationIsIdentification', 'DocumentKit'] for p in sorted((binary / (name + '.build')).glob('*.o'))]
        executable = temp / 'read'
        command(['swiftc', '-whole-module-optimization', '-module-name', 'ViDocumentationFigures', '-I', str(binary / 'Modules'), '-module-cache-path', str(temp / 'modules'), *map(str, sources), str(native), *objects, '-o', str(executable)], timeout=240)
        generated = {}
        raw = {}
        typography = {}
        paints = json.loads(command([str(executable), "--paints"]))
        for row in outputs:
            svg = command([str(executable), row['root']], timeout=30)
            assert svg == prune_glyphs(svg), row['output'] + ': native writer left unused glyph definitions'
            xml = ET.fromstring(svg)
            assert xml.tag == '{http://www.w3.org/2000/svg}svg', row['output'] + ': not SVG'
            assert not list(xml.iter('{http://www.w3.org/2000/svg}text')), row['output'] + ': installed font dependency'
            typography[row['output']] = require_sources(svg, assignments, row['output'])
            typography[row['output']]['contrast'] = require_grounds(svg, paints, colours, row['output'])
            typography[row['output']]['registers'] = require_registers(svg, ledger, register_report['registers'], paints, row['theme'], font['stressWeights'], row['output'])
            svg = namespace(svg, row['root'])
            license_data = escape('\n'.join((ROOT / path).read_text() for path in dict.fromkeys(source['license'] for source in font['sources']))).encode()
            svg = svg.replace(b'\n', b'\n<metadata id="' + row['root'].encode() + b'-font-license">' + license_data + b'</metadata>\n', 1)
            raw[row['output']] = svg
            generated[row['output']] = stamp(svg, input_hash)
        first_svg = raw[outputs[0]['output']]
        for before, after in [(b'data-font-source="Inter"', b'data-font-source="DejaVu"'),
                              (b'data-font-source="DejaVuMono"', b'data-font-source="Inter"')]:
            substituted = first_svg.replace(before, after)
            try:
                require_sources(substituted, assignments, outputs[0]['output'])
            except ValueError as error:
                assert 'wrong glyph source U+' in str(error)
            else:
                raise ValueError('admitted a replaced sans or mono source')
        changed_size = ET.fromstring(first_svg)
        label = next(n for n in changed_size if n.get('data-vi-text') is not None)
        label.set('transform', re.sub(r'scale\(([^ ]+) ([^)]+)\)',
                  lambda m: 'scale(' + str(float(m[1]) * 2) + ' ' + str(float(m[2]) * 2) + ')', label.get('transform')))
        try:
            require_registers(ET.tostring(changed_size), ledger, register_report['registers'], paints, 'Lit', font['stressWeights'], outputs[0]['output'])
        except ValueError as error:
            assert 'undeclared register, size or paint' in str(error)
        else:
            raise ValueError('admitted a label outside its owner register size')
        # Identical text at different declarations cannot exchange semantic paints.
        repeated=ET.fromstring(raw[outputs[4]['output']])
        duplicate=next(n for n in repeated if n.get('data-vi-text')=='0' and 'fill:'+paints['ink-Lit']+';' in n.get('style',''))
        duplicate.set('style',duplicate.get('style').replace('fill:'+paints['ink-Lit']+';', 'fill:'+paints['muted-Lit']+';'))
        try:
            require_registers(ET.tostring(repeated),ledger,register_report['registers'],paints,'Lit',font['stressWeights'],outputs[4]['output'])
        except ValueError as error:
            assert duplicate.get('data-declaration').split('<')[0] in str(error)
        else:
            raise ValueError('admitted a paint exchange between identical text at different declarations')
        # Paper witnesses do not license text on mist, even in the same theme.
        changed_panel = first_svg.replace(('fill:' + paints['paper-Lit'] + ';').encode(), ('fill:' + paints['mist-Lit'] + ';').encode())
        try:
            require_grounds(changed_panel, paints, colours, outputs[0]['output'])
        except ValueError as error:
            assert 'undeclared text/background pair' in str(error)
        else:
            raise ValueError('admitted text on mist without a contrast witness')
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
                       outputs={name: digest(data) for name, data in generated.items()}, contrast=contrast, registers=register_report, labelRegisters=ledger, typography=typography)
        generated[str(WORLD / 'artifacts.json')] = (json.dumps(summary, indent=2) + '\n').encode()
        for name, data in generated.items():
            if args.write:
                (ROOT / name).write_bytes(data)
            else:
                require_equal(name, (ROOT / name).read_bytes(), data)
        print('vi figures: four worlds, nine stamped SVGs; eighteen gate paper equalities; owner registers, Inter 400/600 and measured mono; changed input/output and missing glyph refused')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, AssertionError, OSError, subprocess.SubprocessError) as error:
        raise SystemExit('vi figures: ' + str(error))
