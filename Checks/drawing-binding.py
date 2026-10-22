#!/usr/bin/env python3
"""Keep world style data outside the mechanism and exercise the native binding boundary."""
import importlib.util
import json
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('binding', ROOT / 'Scripts/drawing-binding.py')
binding = importlib.util.module_from_spec(spec)
spec.loader.exec_module(binding)


def mechanism(sources):
    for path, text in sources.items():
        closed=set(re.findall(r'\benum\s+(\w+)\s*:[^{}]*\{\}',text))
        for atom in re.finditer(r'extension\s+(\w+)\s*\{(.*?)\n\}',text,re.S):
            if atom[1] in closed and re.search(r'\b(?:Lit|Veiled|XYZWrite|XYZRatioWrite)\s*<',atom[2]):
                raise ValueError(path+':'+str(text[:atom.start()].count('\n')+1)+': concrete colour walk belongs to a world')
        for alias in re.finditer(r'typealias\s+(\w+)\s*=\s*(?:Lit|Veiled|XYZWrite|XYZRatioWrite)\s*<',text):
            if alias[1] not in ['White','Black']:
                raise ValueError(path+':'+str(text[:alias.start()].count('\n')+1)+': concrete colour alias belongs to a world')
        for face in re.finditer(r'enum\s+(\w*(?:Face|Font|Typeface)\w*)\s*:[^{}]*\{\}\s*extension[^{}]*\{[^{}]*var typeName:[^{}]*\{\s*"([^"]+)"',text):
            if re.search('[A-Za-z]',face[2]):
                raise ValueError(path+':'+str(text[:face.start()].count('\n')+1)+': concrete face belongs to a world')
        if path.endswith(('Design.swift','Vector.swift')) or path.endswith('negative.swift'):
            for atom in re.finditer(r'extension\s+(\w+)\s*\{[^{}]*var typeName: String\s*\{\s*"([0-9]+(?:\.[0-9]+)?)"',text):
                if float(atom[2])>0:
                    raise ValueError(path+':'+str(text[:atom.start()].count('\n')+1)+': numeric style atom belongs to a world')
            for alias in re.finditer(r'typealias\s+\w+\s*=\s*(?:U(?:[1-9][0-9]*)|(?:Plus|Times|Half|Rest)<\s*U[1-9])',text):
                raise ValueError(path+':'+str(text[:alias.start()].count('\n')+1)+': layout value belongs to a world')
        for number, line in enumerate(text.splitlines(), 1):
            code = '' if line.lstrip().startswith('//') else line
            if re.search(r'#[A-Fa-f0-9]{3}(?:[A-Fa-f0-9]{3})?\b|(?:rgba?|color)\(\s*[0-9.]', code):
                raise ValueError(path + ':' + str(number) + ': world colour in drawing mechanism')
            if re.search(r'\b(?:Inter|Roboto|DejaVu|system-ui|sans-serif)\b', code):
                raise ValueError(path + ':' + str(number) + ': world face in drawing mechanism')
            if 'font-family=' in code and 'Binding.' not in code:
                raise ValueError(path + ':' + str(number) + ': literal face in drawing mechanism')
            if re.search(r'enum\s+\w+\s*:\s*Paint\s*,', code):
                raise ValueError(path + ':' + str(number) + ': concrete paint belongs to a world')


def main():
    sources = {str(p.relative_to(ROOT)):p.read_text() for p in (ROOT / 'Sources/DocumentKit').glob('*.swift')}
    sources['Sources/DocumentKit/Resources/footer.html'] = (ROOT / 'Sources/DocumentKit/Resources/footer.html').read_text()
    mechanism(sources)
    for line in ['enum Sneak: Close {} extension Sneak { static var typeName: String { \"12\" } }', 'typealias SecretMargin = U16', 'public enum Stowaway: Paint, Close {}', 'let paint = "#123ABC"', 'let face = "Inter"', 'let svg = "font-family=SecretTypeface"', 'enum NewFace: Close {} extension NewFace { static var typeName: String { "Avenir" } }', 'typealias SecretTone = Lit<Quenched, Undimmed, Quenched>', 'let svg = \"<svg xmlns=\\\"http://example.test\\\" fill=\\\"#123456\\\"/>\"']:
        try: mechanism({'Sources/DocumentKit/negative.swift':line})
        except ValueError as e: assert 'negative.swift:1:' in str(e)
        else: raise AssertionError('mechanism admitted ' + line)
    fixture = ROOT / 'Contracts/Drawing/v0.1/binding.json'
    value = binding.read(fixture)
    assert (ROOT / 'Contracts/Drawing/v0.1/Binding.swift').read_text() == binding.swift(value,aliases=True), str(fixture) + ': stale Swift binding'
    binary = Path(subprocess.check_output(['swift','build','--show-bin-path'],cwd=ROOT,text=True).strip())
    with tempfile.TemporaryDirectory(prefix='vi-binding-control-') as directory:
        temp = Path(directory)
        source = (ROOT / 'Contracts/Drawing/v0.1/cases/half-even.swift').read_text()
        source = source.replace('    public typealias Binding = FixtureBinding\n','')
        file = temp / 'MissingBinding.swift';file.write_text(source)
        p = subprocess.run(['swiftc','-typecheck','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(file)],capture_output=True)
        assert p.returncode and b'MissingBinding.swift:' in p.stderr and b'Binding' in p.stderr, p.stderr.decode()
    # The world has the same source and imports under two owner projections.
    world = '''import VerificationIsIdentification
import DocumentKit
public enum OwnerTitle: Close {}
extension OwnerTitle { public static var typeName: String { "Owner" } }
public enum OwnerWorld: GrownDiagram {
    public typealias Across = U64
    public typealias AriaLabel = OwnerTitle
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Air<TrackHeight>.self
        Air<DotSlot>.self
    }
}
'''
    with tempfile.TemporaryDirectory(prefix='vi-style-names-') as directory:
        temp=Path(directory)
        file=temp/'Unchanged.swift';file.write_text(world)
        main=temp/'main.swift';main.write_text('print(OwnerWorld.typeName, terminator: "")\n')
        objects=[str(p) for name in ['Notation','Alphabet','DocumentKit','VerificationIsIdentification'] for p in sorted((binary/(name+'.build')).glob('*.o'))]
        for name,edge,height in [('FirstOwner','U16',60),('OtherOwner','U8',52)]:
            record=json.loads(json.dumps(value));record['name']=name
            record['layout']['EdgeMargin']={'expression':edge}
            for key,expr in [('TrackHeight','U32'),('DotSlot','Plus<U8,U4>')]:record['layout'][key]={'expression':expr}
            companion=temp/'Binding.swift';companion.write_text(binding.swift(record,aliases=True))
            executable=temp/'read'
            result=subprocess.run(['swiftc','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(companion),str(file),str(main),*objects,'-o',str(executable)],capture_output=True)
            assert result.returncode==0,result.stderr.decode()
            readout=subprocess.check_output([str(executable)],text=True)
            assert 'viewBox="0 0 64 '+str(height)+'"' in readout,readout
        # A library can forward named paints while its build has no owner style dependency.
        library=temp/'UnboundSlots.swift'
        library.write_text('''import Notation
import DocumentKit
public enum LibraryLine: Close {}
extension LibraryLine { public static var typeName: String { LineRole.typeName } }
public enum LibraryAction: Close {}
extension LibraryAction { public static var typeName: String { ActionRole.typeName } }
''')
        module=temp/'UnboundSlots.swiftmodule';obj=temp/'UnboundSlots.o'
        result=subprocess.run(['swiftc','-parse-as-library','-emit-module','-emit-object','-module-name','UnboundSlots','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(library),'-emit-module-path',str(module),'-o',str(obj)],capture_output=True)
        assert result.returncode==0,result.stderr.decode()
        slot_world=temp/'SlotWorld.swift';slot_world.write_text('''import Notation
import DocumentKit
import UnboundSlots
public enum SlotTitle: Close {}
extension SlotTitle { public static var typeName: String { "Bound at root" } }
public enum SlotTrack: SpanTrack {
    public typealias H = Tally<U32>
    public typealias Radius = Tally<Never>
    public typealias Fill = LibraryLine
}
public enum SlotWorld: GrownDiagram {
    public typealias Across = U64
    public typealias AriaLabel = SlotTitle
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<U32, SlotTrack>.self
    }
}
''')
        main.write_text('print(SlotWorld.typeName, terminator: "")\n')
        command=['swiftc','-I',str(binary/'Modules'),'-I',str(temp),'-module-cache-path',str(temp/'modules'),str(companion),str(slot_world),str(main),str(obj),*objects,'-o',str(executable)]
        companion.write_text(binding.swift(record,aliases=True))
        result=subprocess.run(command,capture_output=True);assert result.returncode==0,result.stderr.decode()
        readout=subprocess.check_output([str(executable)],text=True)
        assert 'var(--vi-role-' not in readout and record['roles']['LineRole']['sRGBLight'] in readout,readout
        assert '--vi-role-LineRole:' in binding.css(record)
        missing_paint=json.loads(json.dumps(record));missing_paint['roles'].pop('LineRole')
        companion.write_text(binding.swift(missing_paint,aliases=True))
        result=subprocess.run(command,capture_output=True);assert result.returncode==0,result.stderr.decode()
        refusal=subprocess.run([str(executable)],capture_output=True)
        assert refusal.returncode and b'#roles/LineRole: missing paint' in refusal.stderr,refusal.stderr.decode()
        missing=subprocess.run(['swiftc','-typecheck','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(file)],capture_output=True)
        assert missing.returncode and b'Unchanged.swift:' in missing.stderr,missing.stderr.decode()
        broken=json.loads(json.dumps(record));broken['layout'].pop('EdgeMargin',None)
        companion.write_text(binding.swift(broken,aliases=True))
        missing=subprocess.run(['swiftc','-typecheck','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(companion),str(file)],capture_output=True)
        assert missing.returncode and b'EdgeMargin' in missing.stderr,missing.stderr.decode()
        broken=json.loads(json.dumps(record));broken['layout']['EdgeMargin']={'expression':'EdgeMargin'}
        path=temp/'cyclic.json';path.write_text(json.dumps(broken))
        try:binding.read(path)
        except ValueError as error:assert '#layout/EdgeMargin' in str(error)
        else:raise AssertionError('admitted cyclic layout expression')
    print('drawing binding: owner paint, face, metrics and layout; colour/face/number controls refuse; native missing Binding refuses at source')

if __name__ == '__main__': main()
