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
        demand(pair.get('foreground') in roles and pair.get('background') in roles and NAME.fullmatch(pair.get('witness', '')), 'legible')
    return value


def value_hash(value):
    return hashlib.sha256(json.dumps(value,sort_keys=True,separators=(',',':'),ensure_ascii=False).encode()).hexdigest()


def swift(value, aliases=False):
    name = value['name']
    lines = ['import Notation', 'import DocumentKit', '', '// GENERATED from the world drawing-binding/1 record.', '// drawing-binding-value-sha256: ' + value_hash(value)]
    vocabulary=set(re.findall(r'^public protocol (\w+): (?:Paint|Structure) \{\}', (ROOT/'Sources/DocumentKit/Design.swift').read_text(),re.M))
    def atom(n, text, paint=False, role=None):
        parent='DocumentKit.'+role+', ' if role in vocabulary else ('Paint, ' if paint else '')
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
            lines += ['public enum ' + name + key + ': DocumentKit.' + key + ', Open {', '    @StructureBuilder', '    public static var body: some Structure {', '        ' + expression + '.self', '    }', '}'] if key in vocabulary else ['public typealias ' + name + key + ' = ' + expression]
    lines += ['public enum ' + name + ': DrawingStyle, Close {']
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
    lines += ['    public typealias Values = ' + name + 'Values', '    public typealias PaintFallbacks = ' + name + 'PaintFallbacks', '    public typealias PaintValues = ' + name + 'PaintValues', '}']
    rows = []
    for key,row in layout.items():
        reading = name + key + '.typeName' if 'text' in row else 'String(' + name + key + '.count)'
        rows.append('            "' + key + '|" + ' + reading + ',')
    lines += ['public enum ' + name + 'Values: Close {}', 'extension ' + name + 'Values {', '    public static var typeName: String {', '        [', *rows, '        ].joined(separator: "\\n")', '    }', '}']
    atom(name + 'PaintFallbacks', '\n'.join(paint+'|'+fallback for paint,fallback in fallbacks.items()))
    paint_values=[]
    for role,row in value['roles'].items():
        reading=row.get('fallbackLight',row['light'])
        if row.get('variable'):reading='var(--vi-'+row['variable']+', '+reading+')'
        paint_values.append(role+'|'+reading)
    atom(name + 'PaintValues', '\n'.join(paint_values))
    for pair in value.get('legible', []):
        lines.append('extension ' + name + pair['foreground'] + ': LegibleOn' + pair['background'] + ' {} // owner witness: ' + pair['witness'])
    if aliases:
        lines += ['extension StyleBound {', '    public typealias Binding = ' + name, '}']
        for key in layout:
            lines.append('public typealias ' + key + ' = ' + name + key)
        lines += ['public typealias TextWidth<C: Structure, S: Structure> = BoundTextWidth<' + name + ', C, S>',
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
        if {'Mist','Ink'} <= set(value['roles']):
            lines += ['public enum LightCardPalette: CardPalette {', '    public typealias Surface = Mist', '    public typealias Glyph = Ink', '}']
        if {'SurfaceTrack','TextPrimary'} <= set(value['roles']):
            lines += ['public enum DarkCardPalette: CardPalette {', '    public typealias Surface = SurfaceTrackDark', '    public typealias Glyph = TextPrimaryDark', '}']
    return '\n'.join(lines) + '\n'


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
