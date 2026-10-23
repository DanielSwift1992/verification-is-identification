#!/usr/bin/env python3
"""Read the pinned gate style and project the documentation world's binding."""
import argparse
import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result

ROOT = Path(__file__).resolve().parent.parent
figures = module('vi_figures', ROOT / 'Checks/vi-figures.py')
projection = module('drawing_binding', ROOT / 'Scripts/drawing-binding.py')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    plan = json.loads((ROOT / 'Worlds/Documentation/figures.json').read_text())
    pin = plan['style']
    owner_layout=json.loads((ROOT/'Worlds/Documentation/layout.json').read_text())
    declared=owner_layout['documentationProjection']
    for target in ['DocumentKit', 'VerificationIsIdentification']:
        subprocess.run(['swift', 'build', '--target', target], cwd=ROOT, check=True)
    binary = Path(subprocess.check_output(['swift', 'build', '--show-bin-path'], cwd=ROOT, text=True).strip())
    with tempfile.TemporaryDirectory(prefix='vi-doc-binding-') as directory:
        temp = Path(directory)
        source = temp / 'palette.swift'
        source.write_bytes(b'import VerificationIsIdentification\n' + figures.pinned_bytes(pin, pin['palette'], ROOT / '.build/figure-inputs'))
        native = temp / 'main.swift'
        rows = pin['colours']
        checks = '\n'.join('precondition(' + r['contrast'] + '.Left.count == ' + r['contrast'] + '.Right.count, "' + r['contrast'] + '")' for r in rows if r['contrast'])
        fields = []
        for row in rows:
            coordinates = ['String(Double(' + row['coordinates'][axis] + '.count) / 1000)' for axis in 'XYZ']
            expression = '\"color(xyz-d65 \" + ' + ' + \" \" + '.join(coordinates) + ' + \")\"'
            fields.append('paints["' + row['role'] + '-' + row['theme'] + '"] = ' + expression)
        native.write_text('import Foundation\nimport Notation\nimport DocumentKit\nimport VerificationIsIdentification\npublic enum UnaryArithmeticEncoding {}\n' + checks + '\nvar paints: [String: String] = [:]\n' + '\n'.join(fields) + '\nprint(String(data: try! JSONSerialization.data(withJSONObject: paints, options: [.sortedKeys]), encoding: .utf8)!)\n')
        objects = [str(p) for name in ['Notation', 'Alphabet', 'VerificationIsIdentification', 'DocumentKit'] for p in sorted((binary / (name + '.build')).glob('*.o'))]
        executable = temp / 'read'
        figures.command(['swiftc', '-whole-module-optimization', '-I', str(binary / 'Modules'), '-module-cache-path', str(temp / 'modules'), str(source), str(native), *objects, '-o', str(executable)], timeout=240)
        paints = json.loads(figures.command([str(executable)]))
        _, registers = figures.read_registers(figures.pinned_bytes(pin, pin['registers'], ROOT / '.build/figure-inputs'), binary, temp, set(declared['readRegisters']), plan['font']['stressWeights'])
        roles = {}
        links = declared['links']
        variables = declared['variables']
        for role, owner in links.items():
            row = dict(light=paints[owner+'-'+declared['themeModes']['light']], dark=paints[owner+'-'+declared['themeModes']['dark']], ownerRole=owner)
            if role in variables: row['variable'] = variables[role]
            saved=json.loads((ROOT/'Worlds/Documentation/binding.json').read_text())['roles'][role]
            for suffix in ['Light','Dark']:row['sRGB'+suffix]=saved['sRGB'+suffix]
            roles[role] = row
        family = next(s['name'] for s in plan['font']['sources'] if s['name'] == declared['primaryFace'])
        value = dict(format='drawing-binding/1', name='DocumentationBinding', source=dict(input='Worlds/Documentation/figures.json',field='style',sha256=figures.digest((ROOT/'Worlds/Documentation/figures.json').read_bytes())),
                     roles=roles, registers={key:family for key in declared['faces']}, registerOrigins=declared['faces'], registerReadings=registers,
                     weights={key:str(plan['font']['stressWeights'][registers['registers'][register]['stress']]) for key,register in declared['weights'].items()}, shadow=dict(paint=paints[declared['shadow']['role']+'-'+declared['shadow']['theme']],opacity=declared['shadow']['opacity']), leafCountBases=declared['leafCountBases'],
                     legible=[dict(pair,witness=next(r['contrast'] for r in rows if r['role']==links[pair['foreground']] and r['theme']==declared['legibleTheme'])) for pair in declared['legible']])
        value['styleContract']=owner_layout['styleContract']
        value['cardPalettes']=owner_layout['cardPalettes']
        value['tableStyle']=owner_layout['tableStyle']
        value['portableColour']=owner_layout['portableColour']
        if args.write:projection.project_paints(value)
        else:projection.check_paints(value, 'Worlds/Documentation/binding.json', 'python3 Checks/documentation-binding.py --write')
        layout = owner_layout['values']
        import re
        metrics=(ROOT/'Worlds/Documentation/GeneratedFontMetrics.swift').read_text()
        for name,text in re.findall(r'public enum (\w+): Close \{\}\nextension \1 \{\n    public static var typeName: String \{\s*"([^"]*)"\s*\}\n\}',metrics):
            layout[name]={'text':text}
        character=json.loads((ROOT/'Worlds/Documentation/layout.json').read_text())['missingAdvanceCharacter']
        assert len(character)==1,'layout: missing-advance character must be declared'
        advances=dict(pair.split(':') for pair in layout['FontAdvanceTable']['text'].split())
        layout['FontFallbackAdvance']={'text':advances[str(ord(character))]}
        # These are checked projections of gate registers; composition rungs remain this owner's choices.
        for name, register in declared['sizeRegisters'].items():
            layout[name]={'text':format(registers['registers'][register]['sizeTenths']/10,'g')}
        for key,weight in declared['weightAliases'].items():
            layout[key]={'text':value['weights'][weight]}
        value['layout']=layout
        projection.typecheck_style(value,['-I',str(binary/'Modules')],ROOT)
        themes = projection.swift(value)
        for selection in declared['figureThemes']:
            theme, mode, suffix = (selection[key] for key in ['name','theme','suffix'])
            pairs=[]
            for pair_spec in declared['figurePairs']:
                role=pair_spec['role']
                owner=links[role]
                proof=next(r['contrast'] for r in rows if r['role']==owner and r['theme']==mode)
                background=pair_spec['background']
                field=pair_spec['name']
                pair=theme+field
                themes+='public enum '+pair+'Name: Close {}\nextension '+pair+'Name { public static var typeName: String { \"'+proof+'\" } }\n'
                themes+='public enum '+pair+': '+pair_spec['standard']+' {\n    public typealias WitnessName = '+pair+'Name\n    public typealias Foreground = DocumentationBinding'+role+suffix+'\n    public typealias Background = DocumentationBinding'+background+suffix+'\n    public typealias Proof = '+proof+'\n}\n'
                pairs.append((field,pair))
            themes+='public enum '+theme+': DrawingPalette, '+value['styleContract']['name']+', Close {\n'
            for role in value['roles']:
                themes+='    public typealias '+role+' = DocumentationBinding'+role+suffix+'\n'
            for key in [*value['registers'], *value['layout'], 'ShadowPaint','ShadowOpacity','LeafCountBases']:
                themes+='    public typealias '+key+' = DocumentationBinding'+key+'\n'
            for key,pair in pairs:themes+='    public typealias '+key+' = '+pair+'\n'
            themes+='    public typealias PaintFallbacks = DocumentationBindingPaintFallbacks\n}\n'
        fixture=dict(value,name='FixtureBinding')
        outputs = {'Worlds/Documentation/binding.json':json.dumps(value,indent=2)+'\n',
                   'Worlds/Documentation/DrawingBinding.swift':themes,
                   'Contracts/Drawing/v0.1/binding.json':json.dumps(fixture,indent=2)+'\n',
                   'Contracts/Drawing/v0.1/Binding.swift':projection.swift(fixture,aliases=True),
                   'Sources/DocumentKitDemo/Binding.swift':projection.swift(value,aliases=True),
                   'Sources/VerificationIsIdentification/VerificationIsIdentification.docc/footer.html':projection.footer(value),
                   'Sources/DocumentKit/DocumentKit.docc/footer.html':projection.footer(value)}
        for destination in value['styleContract']['projections']:
            outputs[destination] = projection.style_contract(value,ROOT)
        publication=owner_layout['publication']
        outputs[publication['projection']] = ('// GENERATED owner publication: '+publication['input']+'@sha256:'+publication['sha256']+'\n'
            +projection.source_input(publication,ROOT,'documentation#publication'))
        from xml.sax.saxutils import quoteattr
        for theme,suffix in [('light',''),('dark','~dark')]:
            example=declared['example']
            def element(tag, spec, attribute):
                attributes=dict(spec); role=attributes.pop('role');row=value['roles'][role]
                paint=row['sRGB'+('Light' if theme=='light' else 'Dark')]
                attributes[attribute]=paint
                attributes['style']=attribute+':'+paint+';'+attribute+':'+row[theme]+';'
                return '  <'+tag+' '+ ' '.join(key+'='+quoteattr(text) for key,text in attributes.items())+'/>\n'
            outputs['Sources/DocumentKit/DocumentKit.docc/Resources/example'+suffix+'.svg'] = ('<svg viewBox='+quoteattr(example['viewBox'])+' xmlns="http://www.w3.org/2000/svg">\n'
                +element('rect',example['background'],'fill')+element('path',example['mark'],'stroke')+'</svg>\n')
        for name,text in outputs.items():
            path = ROOT / name
            if args.write: path.write_text(text)
            elif not path.exists() or path.read_text()!=text: raise ValueError(name+': stale; run python3 Checks/documentation-binding.py --write')
    print('documentation binding: pinned gate paints/registers; declared native contrast equalities; shared Swift and footer projections')

if __name__ == '__main__': main()
