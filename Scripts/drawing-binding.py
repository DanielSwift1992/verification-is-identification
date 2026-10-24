#!/usr/bin/env python3
"""Project one owner's drawing-binding/1 record into Swift and a DocC footer."""
import argparse
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent.parent
NAME = re.compile(r'[A-Za-z_][A-Za-z_0-9]*\Z')


def validate(value, at='binding'):
    at = str(at)
    def demand(ok, field):
        if not ok:
            raise ValueError(at + '#' + field + ': missing or invalid drawing binding')
    demand(value.get('format') == 'drawing-binding/1', 'format')
    demand(isinstance(value.get('name'), str) and NAME.fullmatch(value['name']), 'name')
    roles = value.get('roles', {})
    demand(isinstance(roles, dict) and {'TextSecondary','AccentRole'} <= set(roles), 'roles')
    for name, row in roles.items():
        demand(NAME.fullmatch(name), 'roles/' + name)
        demand(isinstance(row, dict), 'roles/' + name)
        for theme in ['light', 'dark']:
            demand(isinstance(row.get(theme), str) and row[theme] and not any(c in row[theme] for c in '<>\n;{}"|'), 'roles/' + name + '/' + theme)
        for suffix in ['Light','Dark']:
            if 'sRGB'+suffix in row:
                demand(isinstance(row['sRGB'+suffix],str) and re.fullmatch(r'#[0-9A-Fa-f]{6}',row['sRGB'+suffix]), 'roles/'+name+'/sRGB'+suffix)
            if 'fallback'+suffix in row:
                demand(isinstance(row['fallback'+suffix],str) and bool(row['fallback'+suffix]) and not any(c in row['fallback'+suffix] for c in '<>\n;{}"|'), 'roles/'+name+'/fallback'+suffix)
        if 'variable' in row:
            demand(isinstance(row['variable'],str) and re.fullmatch('[a-z][a-z0-9-]*', row['variable']), 'roles/' + name + '/variable')
    registers = value.get('registers', {})
    for name in ['BodyFace', 'CaptionFace']:
        face = registers.get(name)
        demand(isinstance(face, str) and face and not any(c in face for c in '<>\n;{}"|'), 'registers/' + name)
    for name, face in registers.items():
        demand(NAME.fullmatch(name) and isinstance(face, str) and bool(face) and not any(c in face for c in '<>\n;{}"|'), 'registers/' + name)
    for name, reading in value.get('weights', {}).items():
        demand(NAME.fullmatch(name) and isinstance(reading, str) and re.fullmatch('[0-9]+(?:\\.[0-9]+)?', reading), 'weights/' + name)
    demand(isinstance(value.get('leafCountBases'), list) and all(isinstance(n,str) and NAME.fullmatch(n) for n in value['leafCountBases']), 'leafCountBases')
    demand(isinstance(value.get('shadow'), dict) and isinstance(value['shadow'].get('paint'), str) and isinstance(value['shadow'].get('opacity'), str), 'shadow')
    shadow=value['shadow']
    demand(bool(shadow['paint']) and not any(c in shadow['paint'] for c in '<>\n;{}"|'), 'shadow/paint')
    demand(re.fullmatch(r'(?:0(?:\.[0-9]+)?|1(?:\.0+)?)', shadow['opacity']), 'shadow/opacity')
    if 'variable' in shadow:
        demand(re.fullmatch('[a-z][a-z0-9-]*', shadow['variable']) and isinstance(shadow.get('darkOpacity'), str) and re.fullmatch(r'(?:0(?:\.[0-9]+)?|1(?:\.0+)?)', shadow['darkOpacity']), 'shadow/variable')
    for key, row in value.get('layout', {}).items():
        demand(NAME.fullmatch(key) and isinstance(row, dict) and len(set(row) & {'text', 'expression'}) == 1, 'layout/' + key)
        if 'text' in row:
            demand(isinstance(row['text'], str) and bool(row['text']) and not any(c in row['text'] for c in '<>\n"|'), 'layout/' + key)
        else:
            demand(isinstance(row['expression'], str) and re.fullmatch(r'[A-Za-z_0-9<>, \n]+', row['expression']), 'layout/' + key)
    for palette in value.get('cardPalettes', []):
        demand(isinstance(palette, dict) and isinstance(palette.get('name'), str) and NAME.fullmatch(palette['name']), 'cardPalettes/name')
        for field in ['surface','glyph']:
            choice=palette.get(field,{})
            demand(isinstance(choice,dict) and choice.get('role') in roles and choice.get('suffix') in ['', 'Dark'], 'cardPalettes/'+field)
    pending=set()
    visited=set()
    def walk(key):
        demand(key not in pending,'layout/'+key+': cyclic style expression')
        if key in visited: return
        pending.add(key)
        for child in re.findall(r'\b[A-Za-z_][A-Za-z_0-9]*\b',value['layout'][key].get('expression','')):
            if child in value['layout']: walk(child)
        pending.remove(key)
        visited.add(key)
    for key in value.get('layout', {}): walk(key)
    for pair in value.get('legible', []):
        demand(isinstance(pair.get('standard','Legible'),str) and NAME.fullmatch(pair.get('standard','Legible')), 'legible/standard')
        demand(pair.get('foreground') in roles and pair.get('background') in roles and NAME.fullmatch(pair.get('witness', '')), 'legible')
    return value


def read(path):
    return validate(json.loads(path.read_text()), str(path))


def value_hash(value):
    return hashlib.sha256(json.dumps(value,sort_keys=True,separators=(',',':'),ensure_ascii=False).encode()).hexdigest()


def source_input(record, base=None, address='binding#input', source=None):
    if not isinstance(record.get('input'), str) or not record['input']:
        raise ValueError(address + ': expected an owner-relative source')
    path = Path(record['input'])
    if path.is_absolute() or '..' in path.parts:
        raise ValueError(address + ': expected an owner-relative source')
    if source is None: source = (Path(base or ROOT) / path).read_bytes()
    if hashlib.sha256(source).hexdigest() != record.get('sha256'):
        raise ValueError(str(path) + ': source differs from the declared SHA-256')
    return source.decode('utf-8')


def style_contract(value, base=None, source=None):
    contract = value.get('styleContract')
    if not isinstance(contract, dict) or not NAME.fullmatch(contract.get('name', '')):
        raise ValueError('binding#styleContract/name: declare the owner protocol')
    return source_input(contract, base, 'binding#styleContract/input', source)


def swift(value, aliases=False, base=None, contract_source=None):
    validate(value)
    name = value['name']
    lines = ['import Notation', 'import DocumentKit', '', '// GENERATED from the world drawing-binding/1 record.', '// drawing-binding-value-sha256: ' + value_hash(value)]
    style_contract(value, base, contract_source)
    lines += ['// Owner requirement source: ' + json.dumps(value['styleContract']['input']) + '@sha256:' + value['styleContract']['sha256']]
    def atom(n, text, paint=False, role=None):
        parent='Paint, ' if paint else ''
        lines.extend(['public enum ' + n + ': ' + parent + 'Close {}', 'extension ' + n + ' {', '    public static var typeName: String { ' + json.dumps(text, ensure_ascii=False) + ' }', '}'])
    for role, row in value['roles'].items():
        literal = row.get('fallbackLight', row['light'])
        if row.get('variable'):
            literal = 'var(--vi-' + row['variable'] + ', ' + literal + ')'
        atom(name + role, literal, True, role)
        atom(name + role + 'Dark', row.get('fallbackDark', row['dark']), True, role)
    for register, face in value['registers'].items():
        atom(name + register, face)
    for weight, reading in value.get('weights', {}).items():
        if weight in value.get('layout', {}):
            assert value['layout'][weight] == {'text':reading}, 'layout weight differs from register'
            continue
        atom(name + weight, reading)
    atom(name + 'ShadowPaint', value['shadow']['paint'], True)
    atom(name + 'ShadowOpacity', value['shadow']['opacity'])
    atom(name + 'LeafCountBases', ' '.join(value['leafCountBases']))
    layout = value.get('layout', {})
    for key, row in layout.items():
        if 'text' in row:
            atom(name + key, row['text'], role=key)
        else:
            expression = re.sub(r'\b[A-Za-z_][A-Za-z_0-9]*\b', lambda m: name + m[0] if m[0] in layout else m[0], row['expression'])
            lines += ['public enum ' + name + key + ': Open {', '    @StructureBuilder', '    public static var body: some Structure {', '        ' + expression + '.self', '    }', '}']
    lines += ['public enum ' + name + ': ' + value['styleContract']['name'] + ', Close {']
    for field in [*value['roles'], *value['registers'], 'ShadowPaint', 'ShadowOpacity', 'LeafCountBases']:
        lines.append('    public typealias ' + field + ' = ' + name + field)
    fallbacks = {}
    for role, row in value['roles'].items():
        for theme, suffix in [('light', 'Light'), ('dark', 'Dark')]:
            paint = row.get('fallback' + suffix, row[theme])
            if theme == 'light' and row.get('variable'):
                paint = 'var(--vi-' + row['variable'] + ', ' + paint + ')'
            if 'sRGB' + suffix not in row: continue
            fallback = row['sRGB' + suffix]
            if paint in fallbacks and fallbacks[paint] != fallback:
                raise ValueError('roles/' + role + ': conflicting fallback for a shared paint')
            fallbacks[paint] = fallback
    for key in layout:
        lines.append('    public typealias ' + key + ' = ' + name + key)
    lines += ['    public typealias PaintFallbacks = ' + name + 'PaintFallbacks', '}']
    atom(name + 'PaintFallbacks', '\n'.join(paint+'|'+fallback for paint,fallback in fallbacks.items()))
    for pair in value.get('legible', []):
        lines.append('extension ' + name + pair['foreground'] + ': ' + pair.get('standard','Legible') + 'On' + pair['background'] + ' {} // owner witness: ' + pair['witness'])
    if aliases:
        lines += ['extension StyleBound {', '    public typealias Binding = ' + name, '}']
        for key in layout:
            lines.append('public typealias ' + key + ' = ' + name + key)
        lines += ['public typealias TimedReveal<B: Structure, D: Structure, C: Structure> = BoundTimedReveal<' + name + ', B, D, C>',
                  'public typealias FrozenReveal<B: Structure, C: Structure> = BoundFrozenReveal<' + name + ', B, C>',
                  'public typealias TextWidth<C: Structure, S: Structure> = BoundTextWidth<' + name + ', C, S>',
                  'public typealias CenteredBaseline<Z: Structure, S: Structure> = BoundCenteredBaseline<' + name + ', Z, S>',
                  'public typealias LineTally<C: Structure, W: Structure, S: Structure> = BoundLineTally<' + name + ', C, W, S>',
                  'public typealias GlyphStroke<C: Paint> = BoundGlyphStroke<' + name + ', C>',
                  'public typealias SoftShadow = DocumentKit.SoftShadow<' + name + '>',
                  'public typealias SurfaceCardShadow = DocumentKit.SurfaceCardShadow<' + name + '>',
                  'public typealias HoverStyle = BoundHoverStyle<' + name + '>',
                  'public typealias HoverRevealStyle = DocumentKit.HoverRevealStyle<' + name + '>',
                  'public typealias ArrowMarkers = DocumentKit.ArrowMarkers<' + name + '>']
        if {'TrackHeight','TextS'} <= set(layout):
            lines.append('public typealias TrackBaseline = CenteredBaseline<TrackHeight, TextS>')
        for weight in value.get('weights', {}):
            if weight in layout: continue
            lines.append('public typealias ' + weight + ' = ' + name + weight)
        for role in value['roles']:
            lines += ['public typealias ' + role + ' = ' + name + role,
                      'public typealias ' + role + 'Dark = ' + name + role + 'Dark']
    for palette in value.get('cardPalettes', []):
        lines.append('public enum '+palette['name']+': CardPalette {')
        for field,key in [('Surface','surface'),('Glyph','glyph')]:
            selection=palette[key]
            lines.append('    public typealias '+field+' = '+name+selection['role']+selection['suffix'])
        lines.append('}')
    return '\n'.join(lines) + '\n'


def typecheck_style(value, includes, base=None, contract_source=None):
    """Ask Swift to check the declared owner requirements, independently of use."""
    import subprocess
    import tempfile
    with tempfile.TemporaryDirectory(prefix='owner-binding-') as directory:
        root = Path(directory)
        source = root / 'Binding.swift'
        declaration = root / 'OwnerRequirements.swift'
        declaration.write_text(style_contract(value,base,contract_source),encoding='utf-8')
        source.write_text(swift(value, base=base, contract_source=contract_source),encoding='utf-8')
        result = subprocess.run(['swiftc','-typecheck',*includes,'-module-cache-path',str(root/'modules'),str(declaration),str(source)],capture_output=True,timeout=120)
        if result.returncode:
            raise ValueError(value['styleContract']['input']+'#binding/'+value['name']+': owner requirements refused by Swift\n'+result.stderr.decode(errors='replace'))


def css(value, dark_selector=None):
    result = []
    for theme in ['light', 'dark']:
        declarations=[]
        for role,row in value['roles'].items():
            slot='--vi-role-'+role
            fallback=row.get('sRGB'+('Light' if theme=='light' else 'Dark'))
            if fallback:declarations.append(slot+':'+fallback+';')
            declarations.append(slot+':'+row[theme]+';')
            if row.get('variable'):declarations.append('--vi-'+row['variable']+':var('+slot+');')

        shadow=value['shadow']
        if shadow.get('variable'):
            declarations.append('--vi-'+shadow['variable']+':'+(shadow['opacity'] if theme=='light' else shadow['darkOpacity'])+';')
        rule = ':root {' + ''.join(declarations) + '}'
        result.append(rule if theme == 'light' else (dark_selector+' {'+''.join(declarations)+'}' if dark_selector else '@media (prefers-color-scheme: dark) {' + rule + '}'))
    return '\n'.join(result)


def table_css(value):
    def reading(cell):
        if isinstance(cell,str):return cell
        if set(cell)=={'layout'}:
            return value['layout'][cell['layout']]['text']
        if set(cell)=={'role'}:
            if cell['role'] not in value['roles']:raise ValueError(value['name']+'#tableStyle: missing paint')
            return 'var(--vi-role-'+cell['role']+')'
        raise ValueError(value['name']+'#tableStyle: unknown owner reference')
    return ''.join(rule['selector']+' {'+''.join(key+':'+reading(cell)+';' for key,cell in rule['declarations'].items())+'}' for rule in value['tableStyle'])


def project_paints(value):
    """Run the owner's one pinned projection and write portable spellings to its record."""
    import importlib.util,subprocess,tempfile
    declared=value['portableColour'];source=declared['source'];span=declared['span']
    if declared['rounding']!='nearest-even' or not NAME.fullmatch(declared['symbol']):raise ValueError(value['name']+'#portableColour: unsupported projection')
    spec=importlib.util.spec_from_file_location('pinned_input',ROOT/'Scripts/pinned-input.py')
    reader=importlib.util.module_from_spec(spec);spec.loader.exec_module(reader)
    raw=reader.pinned_bytes(source,source,ROOT/'.build/figure-inputs')
    code=raw[span['start']:span['end']]
    if hashlib.sha256(code).hexdigest()!=span['sha256']:raise ValueError(value['name']+'#portableColour/span: input differs')
    inputs=[]
    for role,row in value['roles'].items():
        for theme,suffix in [('light','Light'),('dark','Dark')]:
            text=row[theme]
            if not text.startswith('color(xyz-d65 ') or not text.endswith(')'):raise ValueError(value['name']+'#roles: XYZ input required')
            xyz=list(map(float,text[len('color(xyz-d65 '):-1].split()))
            if len(xyz)!=3:raise ValueError(value['name']+'#roles: three coordinates required')
            inputs.append([role,suffix,*xyz])
    with tempfile.TemporaryDirectory(prefix='owner-paint-projection-') as directory:
        temp=Path(directory);program=temp/'main.swift'
        program.write_bytes(b'import Foundation\n'+code+b'\n'+('let input = try JSONSerialization.jsonObject(with: FileHandle.standardInput.readDataToEndOfFile()) as! [[Any]]\nlet output = input.map { row in '+declared['symbol']+'((row[2] as! NSNumber).doubleValue,(row[3] as! NSNumber).doubleValue,(row[4] as! NSNumber).doubleValue) }\nprint(String(data: try JSONSerialization.data(withJSONObject: output),encoding:.utf8)!)\n').encode())
        result=subprocess.run(['swiftc','-module-cache-path',str(temp/'modules'),str(program),'-o',str(temp/'read')],capture_output=True)
        if result.returncode:raise ValueError(result.stderr.decode(errors='replace'))
        result=subprocess.run([str(temp/'read')],input=json.dumps(inputs).encode(),capture_output=True,check=True)
        for (role,suffix,*_),paint in zip(inputs,json.loads(result.stdout)):
            value['roles'][role]['sRGB'+suffix]=paint
            value['roles'][role].pop('fallback'+suffix,None)
    return value


def check_paints(value, address, repair):
    """Compare stored hex with the pinned projector on a copy; keep the input unchanged."""
    import copy
    projected=project_paints(copy.deepcopy(value))
    for role,row in projected['roles'].items():
        for suffix in ['Light','Dark']:
            field='sRGB'+suffix
            if value['roles'][role].get(field)!=row[field]:
                raise ValueError(address+'#roles/'+role+'/'+field+': differs from pinned portableColour projection; run '+repair)
    return value


def footer(value):
    template = (ROOT / 'Sources/DocumentKit/Resources/footer.html').read_text()
    return ('<!-- drawing-binding-value-sha256: '+value_hash(value)+' -->\n'+template).replace('/* WORLD_ROLE_CSS */ null', json.dumps(css(value)).replace('<', '\\u003c')).replace('/* WORLD_TABLE_CSS */ null',json.dumps(table_css(value)).replace('<','\\u003c'))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('binding', type=Path)
    p.add_argument('--swift', type=Path)
    p.add_argument('--footer', type=Path)
    p.add_argument('--aliases', action='store_true')
    p.add_argument('--repository',type=Path,default=Path.cwd(),help='owner repository for declared contract inputs')
    args = p.parse_args()
    value = read(args.binding)
    for target, text in [(args.swift, swift(value, args.aliases, base=args.repository)), (args.footer, footer(value))]:
        if target:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(text)

if __name__ == '__main__':
    main()
