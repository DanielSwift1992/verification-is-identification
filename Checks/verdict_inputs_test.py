#!/usr/bin/env python3
"""Addressed declaration/actual-input controls; physical qualification, T0106."""
import json
import io
from pathlib import Path
import subprocess
import tempfile
import sys
import unittest
from unittest import mock
import verdict_inputs as receipts


class VerdictReceiptControls(unittest.TestCase):
    def test_empty_receipt_cannot_skip_the_compilers(self):
        with tempfile.TemporaryDirectory(prefix='vi-verdict-incomplete-') as directory:
            root=Path(directory); start=root/'start.json'; saved=root/'receipt.json'
            start.write_text(json.dumps({'key':'controlled-key','paths':{}}))
            saved.write_text(json.dumps({'schema':'vi.verdict-receipt/2','key':'controlled-key',
                                         'compilations':[],'completed':{'labels':[]}}))
            diagnostic=io.StringIO()
            with mock.patch.object(sys,'argv',['verdict_inputs.py','hit','--snapshot',str(start),'--receipt',str(saved)]), \
                 mock.patch.object(sys,'stderr',diagnostic):
                self.assertEqual(receipts.main(),1)
            self.assertIn('incomplete compiler input coverage',diagnostic.getvalue())
            print('T0106 empty-receipt: refused: '+diagnostic.getvalue().strip())

    def test_make_dependency_transport_and_unread_forms(self):
        text = 'first.o : source\\ file.swift SDK\\#1.swiftmodule dollar$$name\r\n' + \
               'second.o : one.swift \\\r\n two.swift\r\n'
        self.assertEqual(receipts.make_dependencies(text, 'native.d'),
                         {'source file.swift','SDK#1.swiftmodule','dollar$name','one.swift','two.swift'})
        self.assertEqual(receipts.make_dependencies(r'o : C\:\\SDK\\A.swiftmodule'+'\n', 'windows.d'),
                         {r'C:\SDK\A.swiftmodule'})
        with tempfile.TemporaryDirectory(prefix='vi-verdict-crlf-') as directory:
            root=Path(directory);folder=root/'records';folder.mkdir()
            source=root/'Input.swift';source.write_bytes(b'enum Input {}\n')
            address=str(source).replace('\\','\\\\').replace(' ','\\ ')
            raw=('object : '+address+'\r\n').encode('utf-8')
            (folder/'input.d').write_bytes(raw)
            row=receipts.finish_capture(root,folder,'global-positive',['swiftc',str(source)],0)
            self.assertEqual(row['make'][0]['text'].encode('utf-8'),raw)
            self.assertEqual(row['make'][0]['sha256'],receipts.digest(raw))
        for text in ('', 'object source.swift', 'o : unfinished\\', 'o : $(UNREAD)'):
            with self.subTest(text=text), self.assertRaisesRegex(ValueError, 'native.d'):
                receipts.make_dependencies(text, 'native.d')

    def test_declared_target_closure_and_actual_module_inputs_bind_the_key(self):
        with tempfile.TemporaryDirectory(prefix='vi-verdict-key-') as directory:
            outer=Path(directory); root=outer/'package'; root.mkdir()
            sdk=outer/'compiler sdk';sdk.mkdir()
            compiler=outer/'compiler';compiler.mkdir()
            for name in ('swiftc','swift-frontend','swift-frontend.exe'):(compiler/name).write_bytes(name.encode())
            source=root/'Sources/Lattice/Law.swift';source.parent.mkdir(parents=True);source.write_text('struct Law {}\n')
            court=root/'Sources/Court/Reader.swift';court.parent.mkdir(parents=True);court.write_text('struct Reader {}\n')
            checks=root/'Checks';checks.mkdir()
            fixture=checks/'Fixture.swift';fixture.write_text('let proof = 1\n')
            for name in ('law.sh','verdict_inputs.py'):(checks/name).write_text(name+'\n')
            manifest=checks/'verdict-inputs.json'
            manifest.write_text(json.dumps({'schema':'vi.verdict-inputs/1','targets':['Lattice'],
                                           'fixtures':['Checks/Fixture.swift'],'law_inputs':['Checks/law.sh']}))
            for name in ('Package.swift','Package.resolved','README.md'):(root/name).write_text(name+'\n')
            modules=root/'.build/debug/Modules';modules.mkdir(parents=True)
            (modules/'Lattice.swiftmodule').write_bytes(b'controlled module artifact')
            build=modules.parent/'Lattice.build';build.mkdir()
            dependency=sdk/'Swift.swiftinterface';dependency.write_bytes(b'controlled compiler input')
            def quote(path):return str(path).replace('\\','\\\\').replace(' ','\\ ')
            raw='module : '+quote(source)+' '+quote(dependency)+'\n'
            (build/'Law.d').write_text(raw, encoding='utf-8');(build/'Lattice.emit-module.d').write_text(raw, encoding='utf-8')
            mapping=build/'output-file-map.json';mapping.write_text(json.dumps({str(source):{'dependencies':str(build/'Law.d')}}))
            command=dict(moduleOutputPath=str(modules/'Lattice.swiftmodule'),sources=[str(source)],outputFileMapPath=str(mapping))
            description=modules.parent/'description.json'
            description.write_text(json.dumps({'swiftCommands':{'C.Lattice':command}}))
            graph={'targets':[dict(name='Lattice',c99name='Lattice',module_type='SwiftTarget',path='Sources/Lattice',sources=['Law.swift']),
                              dict(name='Court',c99name='Court',module_type='SwiftTarget',path='Sources/Court',sources=['Reader.swift'])]}
            def native(args,**kwargs):
                if args==['xcrun','--find','swiftc']:return str(compiler/'swiftc')+'\n'
                if args[:2]==['swift','package']:return json.dumps(graph).encode()
                if args==['swiftc','--version']:return b'controlled compiler version\n'
                if args==['swiftc','-print-target-info']:
                    return json.dumps({'paths':{'sdkPath':str(sdk),'runtimeResourcePath':str(sdk)}}).encode()
                self.fail(str(args))
            with mock.patch.object(receipts.subprocess,'check_output',side_effect=native), \
                 mock.patch.object(receipts.shutil,'which',return_value=str(compiler/'swiftc')):
                original=receipts.snapshot(root,modules)
                for path,changes in [(court,False),(root/'README.md',False),
                                     (source,True),(fixture,True),(checks/'law.sh',True),
                                     (root/'Package.resolved',True),(dependency,True)]:
                    before=path.read_bytes();path.write_bytes(before+b'\n')
                    with self.subTest(path=path):
                        self.assertEqual(receipts.snapshot(root,modules)['key']!=original['key'],changes)
                        print('T0106 key '+path.name+': '+('invalidated' if changes else 'preserved'))
                    path.write_bytes(before)
                omitted=checks/'NotDeclared.swift';omitted.write_text('struct Other {}\n')
                (build/'Law.d').write_text(raw.rstrip()+' '+quote(omitted)+'\n', encoding='utf-8')
                with self.assertRaisesRegex(ValueError,'dependencies.Law.d: unannounced compiler input Checks/NotDeclared.swift') as error:
                    receipts.snapshot(root,modules)
                print('T0106 module-omitted: refused: '+str(error.exception))
                (build/'Law.d').write_text(raw, encoding='utf-8')
                command['sources'].append(str(omitted));description.write_text(json.dumps({'swiftCommands':{'C.Lattice':command}}))
                with self.assertRaisesRegex(ValueError,'target.Lattice.sources: unannounced compiler input') as error:
                    receipts.snapshot(root,modules)
                print('T0106 command-omitted: refused: '+str(error.exception))

    def test_native_positive_and_refusal_record_an_omitted_actual_input(self):
        with tempfile.TemporaryDirectory(prefix='vi-verdict-actual-') as directory:
            root=Path(directory); audit=root/'audit';audit.mkdir()
            first=root/'First.swift';first.write_text('struct Carried {}\nstruct Other {}\nprotocol HasValue { associatedtype Value }\nstruct Carrier: HasValue { typealias Value = Carried }\nstruct RequiresOther<T: HasValue> where T.Value == Other {}\n')
            second=root/'Second.swift'
            second.write_text('func use(_ value: Carried) -> Int { 1 }\n#if BROKEN\ntypealias InvalidRequirement = RequiresOther<Carrier>\n#endif\n')
            base=['swiftc','-typecheck','-whole-module-optimization','-module-cache-path',str(root/'cache'),str(first),str(second)]
            for label,extra,wanted in [('global-positive',[],0),('mutation:BROKEN',['-DBROKEN'],1)]:
                tracked,folder=receipts.capture_command([*base,*extra],audit,label)
                done=subprocess.run(tracked,cwd=root,capture_output=True,text=True)
                self.assertEqual(done.returncode,wanted,done.stdout+done.stderr)
                row=receipts.finish_capture(root,folder,label,tracked,done.returncode)
                paths={p:p for p in row['dependencies']}
                hashes={p:receipts.digest(Path(p).read_bytes()) for p in row['dependencies']}
                declared={'paths':paths,'core':{'files':hashes}}
                receipts.covered(declared,row)
                key=str(second.resolve());value=hashes.pop(key)
                with self.assertRaisesRegex(ValueError,r'dependencies\[[0-9]+\]: unannounced compiler input') as error:
                    receipts.covered(declared,row)
                self.assertIn(str(second),str(error.exception))
                print('T0106 native '+label+'/omitted-key-member: refused: '+str(error.exception))
                hashes[key]=value
                del paths[key]
                with self.assertRaisesRegex(ValueError,r'dependencies\[[0-9]+\]: unannounced compiler input') as error:
                    receipts.covered(declared,row)
                print('T0106 native '+label+'/omitted-address: refused: '+str(error.exception))
                self.assertTrue(row['make'])
                self.assertIn(str(first),row['dependencies']);self.assertIn(str(second),row['dependencies'])


if __name__ == '__main__': unittest.main()
