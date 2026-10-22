#!/usr/bin/env python3
"""Project one owner's drawing-binding/1 record into Swift and a DocC footer."""
import argparse
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent.parent
NAME = re.compile(r'[A-Za-z_][A-Za-z_0-9]*\Z')


def read(path):
    value = json.loads(path.read_text())
    at = str(path)
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
            demand(isinstance(row.get(theme), str) and row[theme] and not any(c in row[theme] for c in '<>\n;{}'), 'roles/' + name + '/' + theme)
        if 'variable' in row:
            demand(isinstance(row['variable'],str) and re.fullmatch('[a-z][a-z0-9-]*', row['variable']), 'roles/' + name + '/variable')
    registers = value.get('registers', {})
    for name in ['BodyFace', 'CaptionFace']:
        face = registers.get(name)
        demand(isinstance(face, str) and face and not any(c in face for c in '<>\n;{}'), 'registers/' + name)
    for name, face in registers.items():
        demand(NAME.fullmatch(name) and isinstance(face, str) and bool(face) and not any(c in face for c in '<>\n;{}'), 'registers/' + name)
    for name, reading in value.get('weights', {}).items():
        demand(NAME.fullmatch(name) and isinstance(reading, str) and re.fullmatch('[0-9]+(?:\\.[0-9]+)?', reading), 'weights/' + name)
    demand(isinstance(value.get('leafCountBases'), list) and all(isinstance(n,str) and NAME.fullmatch(n) for n in value['leafCountBases']), 'leafCountBases')
    demand(isinstance(value.get('shadow'), dict) and isinstance(value['shadow'].get('paint'), str) and isinstance(value['shadow'].get('opacity'), str), 'shadow')
    shadow=value['shadow']
    demand(bool(shadow['paint']) and not any(c in shadow['paint'] for c in '<>\n;{}'), 'shadow/paint')
    demand(re.fullmatch(r'(?:0(?:\.[0-9]+)?|1(?:\.0+)?)', shadow['opacity']), 'shadow/opacity')
    if 'variable' in shadow:
        demand(re.fullmatch('[a-z][a-z0-9-]*', shadow['variable']) and isinstance(shadow.get('darkOpacity'), str) and re.fullmatch(r'(?:0(?:\.[0-9]+)?|1(?:\.0+)?)', shadow['darkOpacity']), 'shadow/variable')
    for pair in value.get('legible', []):
        demand(pair.get('foreground') in roles and pair.get('background') in roles and NAME.fullmatch(pair.get('witness', '')), 'legible')
    return value


def value_hash(value):
    return hashlib.sha256(json.dumps(value,sort_keys=True,separators=(',',':'),ensure_ascii=False).encode()).hexdigest()


def swift(value, aliases=False):
    name = value['name']
    lines = ['import Notation', 'import DocumentKit', '', '// GENERATED from the world drawing-binding/1 record.', '// drawing-binding-value-sha256: ' + value_hash(value)]
    def atom(n, text, paint=False):
        lines.extend(['public enum ' + n + ': ' + ('Paint, ' if paint else '') + 'Close {}', 'extension ' + n + ' {', '    public static var typeName: String { ' + json.dumps(text, ensure_ascii=False) + ' }', '}'])
    for role, row in value['roles'].items():
        literal = row.get('fallbackLight', row['light'])
        if row.get('variable'):
            literal = 'var(--vi-' + row['variable'] + ', ' + literal + ')'
        atom(name + role, literal, True)
        atom(name + role + 'Dark', row.get('fallbackDark', row['dark']), True)
    for register, face in value['registers'].items():
        atom(name + register, face)
    for weight, reading in value.get('weights', {}).items():
        atom(name + weight, reading)
    atom(name + 'ShadowPaint', value['shadow']['paint'], True)
    atom(name + 'ShadowOpacity', value['shadow']['opacity'])
    atom(name + 'LeafCountBases', ' '.join(value['leafCountBases']))
    lines += ['public enum ' + name + ': DrawingStyle, Close {']
    for field in [*value['roles'], *value['registers'], 'ShadowPaint', 'ShadowOpacity', 'LeafCountBases']:
        lines.append('    public typealias ' + field + ' = ' + name + field)
    lines += ['}']
    for pair in value.get('legible', []):
        lines.append('extension ' + name + pair['foreground'] + ': LegibleOn' + pair['background'] + ' {} // owner witness: ' + pair['witness'])
    if aliases:
        for weight in value.get('weights', {}):
            lines.append('public typealias ' + weight + ' = ' + name + weight)
        for role in value['roles']:
            lines += ['public typealias ' + role + ' = ' + name + role,
                      'public typealias ' + role + 'Dark = ' + name + role + 'Dark']
        lines += ['public enum LightCardPalette: CardPalette {', '    public typealias Surface = Mist', '    public typealias Glyph = Ink', '}',
                  'public enum DarkCardPalette: CardPalette {', '    public typealias Surface = SurfaceTrackDark', '    public typealias Glyph = TextPrimaryDark', '}']
    return '\n'.join(lines) + '\n'


def css(value):
    result = []
    for theme in ['light', 'dark']:
        declarations = ['--vi-' + row['variable'] + ':' + row[theme] + ';' for row in value['roles'].values() if row.get('variable')]
        shadow=value['shadow']
        if shadow.get('variable'):
            declarations.append('--vi-'+shadow['variable']+':'+(shadow['opacity'] if theme=='light' else shadow['darkOpacity'])+';')
        rule = ':root {' + ''.join(declarations) + '}'
        result.append(rule if theme == 'light' else '@media (prefers-color-scheme: dark) {' + rule + '}')
    return '\n'.join(result)


def footer(value):
    template = (ROOT / 'Sources/DocumentKit/Resources/footer.html').read_text()
    return ('<!-- drawing-binding-value-sha256: '+value_hash(value)+' -->\n'+template).replace('/* WORLD_ROLE_CSS */ null', json.dumps(css(value)).replace('<', '\\u003c'))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('binding', type=Path)
    p.add_argument('--swift', type=Path)
    p.add_argument('--footer', type=Path)
    p.add_argument('--aliases', action='store_true')
    args = p.parse_args()
    value = read(args.binding)
    for target, text in [(args.swift, swift(value, args.aliases)), (args.footer, footer(value))]:
        if target:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(text)

if __name__ == '__main__':
    main()
