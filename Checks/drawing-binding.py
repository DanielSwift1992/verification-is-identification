#!/usr/bin/env python3
"""Keep world style data outside the mechanism and exercise the native binding boundary."""
import importlib.util
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('binding', ROOT / 'Scripts/drawing-binding.py')
binding = importlib.util.module_from_spec(spec)
spec.loader.exec_module(binding)


style_spec=importlib.util.spec_from_file_location('style_literals',ROOT/'Scripts/style-literals.py')
style_literals=importlib.util.module_from_spec(style_spec);style_spec.loader.exec_module(style_literals)
footer_spec=importlib.util.spec_from_file_location('footer_check',ROOT/'Scripts/footer-check.py')
footer_check=importlib.util.module_from_spec(footer_spec);footer_spec.loader.exec_module(footer_check)

def mechanism(sources):
    for path,text in sources.items():style_literals.check(text,path,swift=path.endswith('.swift'))


def main():
    sources = {str(p.relative_to(ROOT)):p.read_text() for p in (ROOT / 'Sources/DocumentKit').rglob('*.swift')}
    sources['Sources/DocumentKit/Resources/footer.html'] = (ROOT / 'Sources/DocumentKit/Resources/footer.html').read_text()
    sources.update({str(p.relative_to(ROOT)):p.read_text() for p in (ROOT/'Sources/DocumentKit').rglob('*.md')})
    mechanism(sources)
    boundary=(ROOT/'Scripts/style-literals.md').read_text()
    assert 'SVG: '+', '.join(style_literals.SVG_ATTRIBUTES)+'.' in boundary
    assert 'CSS: '+', '.join(style_literals.CSS_PROPERTIES)+'.' in boundary
    closed=style_literals.controls()
    print("style positions: "+json.dumps(closed,sort_keys=True))
    refusals=['enum X: Paint {}','enum X: Close, Paint {}',
              'let svg = "<text font-family=\\\"Helvetica\\\"/>"',
              'let svg = "<text font-family=\\\"serif\\\"/>"',
              'let svg = "<text font-family=\\\"monospace\\\"/>"',
              'let svg = "<rect fill=\\\"hsl(0 0% 0%)\\\"/>"',
              'let svg = "<rect fill=\\\"oklch(50% 0 0)\\\"/>"',
              'let svg = "<rect fill=\\\"red\\\"/>"',
              'let svg = "<rect fill=\\\"#33" + "6FEE\\\"/>"',
              'let paint = 0x336FEE; let svg = "<rect fill=\\\"\\(paint)\\\"/>"',
              'let svg = "<path stroke-width=\\\"9\\\"/>"',
              'let svg = "<text font-weight=\\\"700\\\"/>"',
              'let svg = "<marker markerWidth=\\\"9\\\"/>"',
              'enum Cover99: Close {} extension Cover99 { static var typeName: String { "0.99" } }']
    for line in refusals:
        try:mechanism({'Sources/DocumentKit/subfolder/negative.swift':line})
        except ValueError as e:assert 'negative.swift:1:' in str(e)
        else:raise AssertionError('mechanism admitted '+line)
    for source,swift in [(r'let svg = "<path stroke-width=\"\(9)\"/>"',True),
                         (r'let svg = "<text font-family=\"\(face("Inter"))\"/>"',True),
                         ('const svg = `<path stroke-width="${9}"/>`;',False),
                         ('const svg = `<text font-family="${face("Inter")}"/>`;',False)]:
        try:style_literals.check(source,'interpolated-value.swift' if swift else 'interpolated-value.js',swift)
        except ValueError:pass
        else:raise AssertionError('literal interpolation admitted: '+source)
    style_literals.check(r'let svg = "<path stroke-width=\"\(Binding.width / 2)\"/>"','arithmetic.swift')
    mechanism({'Sources/DocumentKit/positive.swift':'let title="Inter-world"; let text="#abc"; let count=12/2'})
    footer=binding.footer(binding.read(ROOT/'Worlds/Documentation/binding.json'))
    assert footer_check.check(footer,'documentation/footer.html')==2
    broken='<script>unquoted prose document' + footer
    try:footer_check.check(broken,'broken/footer.html')
    except ValueError:pass
    else:raise AssertionError('broken footer comment admitted')
    for path in [ROOT/'Sources/DocumentKitDemo/DocumentKitDemo.docc/footer.html',ROOT/'Sources/VerificationIsIdentification/VerificationIsIdentification.docc/footer.html']:
        assert footer_check.check(path.read_text(),str(path.relative_to(ROOT)))==2
    fixture = ROOT / 'Contracts/Drawing/v0.1/binding.json'
    value = binding.read(fixture)
    binding.check_paints(value, str(fixture.relative_to(ROOT)), 'python3 Checks/documentation-binding.py --write')
    forged = json.loads(json.dumps(value))
    forged['roles']['TextSecondary']['sRGBLight'] = '#010203'
    before = json.dumps(forged, sort_keys=True)
    try:
        binding.check_paints(forged, 'forged/binding.json', 'regenerate the owner binding')
    except ValueError as error:
        assert 'forged/binding.json#roles/TextSecondary/sRGBLight' in str(error), str(error)
    else:
        raise AssertionError('stored hex escaped the pinned projector relation')
    assert json.dumps(forged, sort_keys=True) == before, 'checking rewrote the owner input'
    assert (ROOT / 'Contracts/Drawing/v0.1/Binding.swift').read_text() == binding.swift(value,aliases=True), str(fixture) + ': stale Swift binding'
    binary = Path(subprocess.check_output(['swift','build','--show-bin-path'],cwd=ROOT,text=True).strip())
    with tempfile.TemporaryDirectory(prefix='vi-binding-control-') as directory:
        temp = Path(directory)
        source = (ROOT / 'Contracts/Drawing/v0.1/cases/half-even.swift').read_text()
        source = source.replace('    public typealias Binding = FixtureBinding\n','')
        file = temp / 'MissingBinding.swift';file.write_text(source)
        p = subprocess.run(['swiftc','-typecheck','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(file)],capture_output=True)
        assert p.returncode and b'MissingBinding.swift:' in p.stderr and b'Binding' in p.stderr, p.stderr.decode()
    # Font and size are equalities of the label protocol, not a source spelling test.
    controls=ROOT/'Contracts/Drawing/BindingControls'
    declarations=json.loads((controls/'requests.json').read_text())
    with tempfile.TemporaryDirectory(prefix='vi-register-relation-') as directory:
        temp=Path(directory)
        for request in declarations['registers']:
            source=controls/request['file']
            result=subprocess.run(['swiftc','-typecheck','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(source)],capture_output=True)
            assert (result.returncode==0)==request['admitted'],result.stderr.decode()
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
        requirements=ROOT/value['styleContract']['input']
        objects=[str(p) for name in ['Notation','Alphabet','DocumentKit','VerificationIsIdentification'] for p in sorted((binary/(name+'.build')).glob('*.o'))]
        for name,edge,height in [('FirstOwner','U16',60),('OtherOwner','U8',52)]:
            record=json.loads(json.dumps(value));record['name']=name
            record['layout']['EdgeMargin']={'expression':edge}
            for key,expr in [('TrackHeight','U32'),('DotSlot','Plus<U8,U4>')]:record['layout'][key]={'expression':expr}
            companion=temp/'Binding.swift';companion.write_text(binding.swift(record,aliases=True))
            executable=temp/'read'
            result=subprocess.run(['swiftc','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(requirements),str(companion),str(file),str(main),*objects,'-o',str(executable)],capture_output=True)
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
        command=['swiftc','-I',str(binary/'Modules'),'-I',str(temp),'-module-cache-path',str(temp/'modules'),str(requirements),str(companion),str(slot_world),str(main),str(obj),*objects,'-o',str(executable)]
        companion.write_text(binding.swift(record,aliases=True))
        result=subprocess.run(command,capture_output=True);assert result.returncode==0,result.stderr.decode()
        readout=subprocess.check_output([str(executable)],text=True)
        assert 'var(--vi-role-' not in readout and record['roles']['LineRole']['sRGBLight'] in readout,readout
        assert '--vi-role-LineRole:' in binding.css(record)
        for request in declarations['incompleteStyles']:
            incomplete=json.loads(json.dumps(record));incomplete[request['section']].pop(request['key'])
            companion.write_text(binding.swift(incomplete,aliases=True))
            result=subprocess.run(command,capture_output=True)
            assert result.returncode and request['key'].encode() in result.stderr,result.stderr.decode()
            print('required style slot '+request['key']+': missing value refused by Swift')
        # These owner requirements are independent of the supplied layout values.
        # No drawing reads either extent; the compiler still requires its witness.
        for request in declarations['ownerStyles']:
            contract=controls/request['file']
            owner_contract=temp/'OwnerRequirements.swift';owner_contract.write_bytes(contract.read_bytes())
            candidate=json.loads(json.dumps(record))
            candidate['styleContract']=dict(name=request['protocol'],input=owner_contract.name,
                                           sha256=hashlib.sha256(owner_contract.read_bytes()).hexdigest())
            candidate['layout'][request['key']]={'text':'1'}
            companion.write_text(binding.swift(candidate,aliases=True,base=temp))
            owner_command=[str(owner_contract) if argument==str(requirements) else argument for argument in command]
            admitted=subprocess.run(owner_command,capture_output=True)
            assert admitted.returncode==0,admitted.stderr.decode()
            if 'deliveredInput' in request:
                delivered=json.loads(json.dumps(candidate))
                delivered['styleContract']['input']=request['deliveredInput']
                binding.typecheck_style(delivered,['-I',str(binary/'Modules')],temp,contract_source=owner_contract.read_bytes())
            candidate['layout'].pop(request['key'])
            companion.write_text(binding.swift(candidate,aliases=True,base=temp))
            refused=subprocess.run(owner_command,capture_output=True)
            assert refused.returncode and request['key'].encode() in refused.stderr,refused.stderr.decode()
            print('owner protocol '+request['protocol']+': '+request['key']+' admitted; absent unused key refused by Swift')
        companion.write_text(binding.swift(record,aliases=True))
        missing=subprocess.run(['swiftc','-typecheck','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(file)],capture_output=True)
        assert missing.returncode and b'Unchanged.swift:' in missing.stderr,missing.stderr.decode()
        broken=json.loads(json.dumps(record));broken['layout'].pop('EdgeMargin',None)
        companion.write_text(binding.swift(broken,aliases=True))
        missing=subprocess.run(['swiftc','-typecheck','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(requirements),str(companion),str(file)],capture_output=True)
        assert missing.returncode and b'EdgeMargin' in missing.stderr,missing.stderr.decode()
        broken=json.loads(json.dumps(record));broken['layout']['EdgeMargin']={'expression':'EdgeMargin'}
        path=temp/'cyclic.json';path.write_text(json.dumps(broken))
        try:binding.read(path)
        except ValueError as error:assert '#layout/EdgeMargin' in str(error)
        else:raise AssertionError('admitted cyclic layout expression')
    print('drawing binding: owner paint, face, metrics and layout; colour/face/number controls refuse; native missing Binding refuses at source')

if __name__ == '__main__': main()
