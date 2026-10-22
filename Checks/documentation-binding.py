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
        _, registers = figures.read_registers(figures.pinned_bytes(pin, pin['registers'], ROOT / '.build/figure-inputs'), binary, temp, {'Speech', 'Caption', 'Fact', 'Headline'}, plan['font']['stressWeights'])
        roles = {}
        # All text-bearing documentation surfaces use paper, the stated contrast ground.
        links = {'Ink':'ink','Paper':'paper','Mist':'paper','Accent':'paper','Muted':'muted','Line':'line','InkPrimary':'ink','InkSecondary':'muted','Action':'action','ActionTint':'paper','NavyTint':'paper',
                 'SurfaceCard':'paper','SurfaceTrack':'paper','SurfacePage':'paper','TextPrimary':'ink','TextSecondary':'muted','AccentRole':'action','ActionRole':'action','LineRole':'line','OnAccent':'ink','ActionTintRole':'paper','OnActionRole':'ink','StatusMark':'ok','Ok':'ok','Bad':'bad','KnownName':'knownName','LocalType':'localType'}
        variables = {'SurfaceCard':'surface-card','SurfaceTrack':'surface-track','SurfacePage':'surface-page','TextPrimary':'text-primary','TextSecondary':'text-secondary','AccentRole':'accent','ActionRole':'action','LineRole':'line','OnAccent':'on-accent','ActionTintRole':'action-tint','OnActionRole':'on-action'}
        for role, owner in links.items():
            row = dict(light=paints[owner+'-Lit'], dark=paints[owner+'-Dim'], ownerRole=owner)
            if role in variables: row['variable'] = variables[role]
            for theme, suffix in [('light','Light'), ('dark','Dark')]:
                coordinates = [float(n) for n in row[theme].removeprefix('color(xyz-d65 ').removesuffix(')').split()]
                x,y,z=coordinates
                channels=[3.2406*x-1.5372*y-0.4986*z, -.9689*x+1.8758*y+.0415*z, .0557*x-.2040*y+1.0570*z]
                rgb=[max(0,min(255,round(255*(12.92*c if c<=.0031308 else 1.055*max(c,0)**(1/2.4)-.055)))) for c in channels]
                row['sRGB'+suffix]='#%02X%02X%02X'%tuple(rgb)
            roles[role] = row
        family = next(s['name'] for s in plan['font']['sources'] if s['name'] == 'Inter')
        value = dict(format='drawing-binding/1', name='DocumentationBinding', source=dict(input='Worlds/Documentation/figures.json',field='style',sha256=figures.digest((ROOT/'Worlds/Documentation/figures.json').read_bytes())),
                     roles=roles, registers={'BodyFace':family,'CaptionFace':family}, registerOrigins={'BodyFace':'Speech','CaptionFace':'Caption'}, registerReadings=registers,
                     weights={'WeightRegular':str(plan['font']['stressWeights'][registers['registers']['Speech']['stress']]),'WeightBold':str(plan['font']['stressWeights'][registers['registers']['Headline']['stress']])}, shadow=dict(paint=paints['ink-Lit'],opacity='0'), leafCountBases=['Structure','Close','Open','Pair'],
                     legible=[dict(foreground=fg,background=bg,witness=next(r['contrast'] for r in rows if r['role']==links[fg] and r['theme']=='Lit')) for fg,bg in [('TextPrimary','SurfaceCard'),('TextSecondary','SurfaceCard'),('ActionRole','SurfaceCard'),('TextPrimary','SurfaceTrack'),('TextSecondary','SurfaceTrack'),('ActionRole','SurfaceTrack'),('Ink','NavyTint'),('InkPrimary','NavyTint'),('InkSecondary','NavyTint')]])
        layout = json.loads((ROOT/'Worlds/Documentation/layout.json').read_text())['values']
        import re
        metrics=(ROOT/'Worlds/Documentation/GeneratedFontMetrics.swift').read_text()
        for name,text in re.findall(r'public enum (\w+): Close \{\}\nextension \1 \{\n    public static var typeName: String \{\s*"([^"]*)"\s*\}\n\}',metrics):
            layout[name]={'text':text}
        character=json.loads((ROOT/'Worlds/Documentation/layout.json').read_text())['missingAdvanceCharacter']
        assert len(character)==1,'layout: missing-advance character must be declared'
        advances=dict(pair.split(':') for pair in layout['FontAdvanceTable']['text'].split())
        layout['FontFallbackAdvance']={'text':advances[str(ord(character))]}
        # These are checked projections of gate registers; composition rungs remain this owner's choices.
        for name, register in {'TextXXS':'Caption','TextXS':'Caption','TextS':'Speech','TextM':'Speech','TextL':'Headline','TitleT':'Headline','DisplayS':'Headline','Display':'Headline'}.items():
            layout[name]={'text':format(registers['registers'][register]['sizeTenths']/10,'g')}
        layout['WeightRegular']={'text':value['weights']['WeightRegular']}
        layout['WeightBold']={'text':value['weights']['WeightBold']}
        layout['BoldWeight']={'text':value['weights']['WeightBold']}
        value['layout']=layout
        for pair in value['legible']:
            if pair['foreground'] in ['TextSecondary','InkSecondary']:pair['standard']='Readable'
        themes = projection.swift(value)
        for theme, mode, suffix in [('FigureLight','Lit',''),('FigureDark','Dim','Dark')]:
            pairs=[]
            for role in ['Ink','Muted','Ok','Bad','KnownName','LocalType']:
                owner=links[role]
                proof=next(r['contrast'] for r in rows if r['role']==owner and r['theme']==mode)
                pair=theme+role+'OnPaper'
                themes+='public enum '+pair+'Name: Close {}\nextension '+pair+'Name { public static var typeName: String { \"'+proof+'\" } }\n'
                themes+='public enum '+pair+': '+('ReadablePaintPair' if role=='Muted' else 'LegiblePaintPair')+' {\n    public typealias WitnessName = '+pair+'Name\n    public typealias Foreground = DocumentationBinding'+role+suffix+'\n    public typealias Background = DocumentationBindingPaper'+suffix+'\n    public typealias Proof = '+proof+'\n}\n'
                pairs.append((role+'OnPaper',pair))
            themes+='public enum '+theme+': DrawingPalette, Close {\n'
            for role in ['Paper','Ink','Muted','Line','Ok','Bad','KnownName','LocalType','TextSecondary','AccentRole']:
                themes+='    public typealias '+role+' = DocumentationBinding'+role+suffix+'\n'
            for key in ['BodyFace','CaptionFace','ShadowPaint','ShadowOpacity','LeafCountBases']:
                themes+='    public typealias '+key+' = DocumentationBinding'+key+'\n'
            for key,pair in pairs:themes+='    public typealias '+key+' = '+pair+'\n'
            themes+='    public typealias Values = DocumentationBindingValues\n    public typealias PaintFallbacks = DocumentationBindingPaintFallbacks\n    public typealias PaintValues = DocumentationBindingPaintValues\n}\n'
        fixture=dict(value,name='FixtureBinding')
        outputs = {'Worlds/Documentation/binding.json':json.dumps(value,indent=2)+'\n',
                   'Worlds/Documentation/DrawingBinding.swift':themes,
                   'Contracts/Drawing/v0.1/binding.json':json.dumps(fixture,indent=2)+'\n',
                   'Contracts/Drawing/v0.1/Binding.swift':projection.swift(fixture,aliases=True),
                   'Sources/DocumentKitDemo/Binding.swift':projection.swift(value,aliases=True),
                   'Sources/VerificationIsIdentification/VerificationIsIdentification.docc/footer.html':projection.footer(value),
                   'Sources/DocumentKit/DocumentKit.docc/footer.html':projection.footer(value)}
        for theme,suffix in [('light',''),('dark','~dark')]:
            paper=value['roles']['Paper'][theme]
            mark=value['roles']['StatusMark'][theme]
            outputs['Sources/DocumentKit/DocumentKit.docc/Resources/example'+suffix+'.svg'] = ('<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg">\n'
                + '  <rect width="120" height="120" rx="12" fill="'+value['roles']['Paper']['sRGB'+('Light' if theme=='light' else 'Dark')]+'" style="fill:'+value['roles']['Paper']['sRGB'+('Light' if theme=='light' else 'Dark')]+';fill:'+paper+';"/>\n'
                + '  <path d="M30 60 L55 85 L92 40" stroke="'+value['roles']['StatusMark']['sRGB'+('Light' if theme=='light' else 'Dark')]+'" style="stroke:'+value['roles']['StatusMark']['sRGB'+('Light' if theme=='light' else 'Dark')]+';stroke:'+mark+';" stroke-width="10" fill="none" stroke-linecap="round" stroke-linejoin="round"/>\n</svg>\n')
        for name,text in outputs.items():
            path = ROOT / name
            if args.write: path.write_text(text)
            elif not path.exists() or path.read_text()!=text: raise ValueError(name+': stale; run python3 Checks/documentation-binding.py --write')
    print('documentation binding: pinned gate paints/registers; eighteen native paper equalities; shared Swift and footer projections')

if __name__ == '__main__': main()
