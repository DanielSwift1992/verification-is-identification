#!/usr/bin/env python3
"""The bounded executor preserves fixture gates, independent mutations and failures."""
import importlib.util
import io
import json
import os
from pathlib import Path
import tempfile
import subprocess
import shutil
import sys
import unittest
from unittest import mock
from verdict_inputs_test import VerdictReceiptControls

spec = importlib.util.spec_from_file_location('verdict_cases', Path(__file__).with_name('verdict-cases.py'))
engine = importlib.util.module_from_spec(spec); spec.loader.exec_module(engine)


class ExecutorControls(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='vi-verdict-executor-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root/'Checks').mkdir(); (self.root/'bin').mkdir()
        self.trace = self.root/'trace.jsonl'
        (self.root/'Checks/verdict-inputs.json').write_text(json.dumps({
            'schema':'vi.verdict-inputs/1','targets':['Synthetic'],
            'fixtures':['Checks/A.swift','Checks/B.swift','Checks/C.swift'],
            'law_inputs':['Checks/synthetic-driver.py']}))
        self.cases = [('A_ONE', 'RejectedAOne'), ('B_ONE', 'RejectedBOne'),
                      ('A_TWO', 'RejectedATwo'), ('C_ONE', 'RejectedCOne')]
        for file, flags in [('A', ['A_ONE','A_TWO']), ('B',['B_ONE']), ('C',['C_ONE'])]:
            (self.root/f'Checks/{file}.swift').write_text(''.join(f'#if {flag}\n#endif\n' for flag in flags))
        compiler = self.root/'bin/swiftc'
        compiler.write_text('''#!/usr/bin/python3
import fcntl,json,os,sys,time
args=sys.argv[1:]; flag=next((a[2:] for a in args if a.startswith('-D')),None)
def log(event):
 with open(os.environ['EXECUTOR_TRACE'],'a') as f:
  fcntl.flock(f,fcntl.LOCK_EX); f.write(json.dumps(dict(event=event,at=time.time(),args=args,pid=os.getpid()))+'\\n')
log('start'); time.sleep(10 if os.environ.get('EXECUTOR_SLOW') and 'Checks/C.swift' in args else 0.04); log('end')
fault=os.environ.get('EXECUTOR_FAULT','')
if flag is None:
 if fault=='positive': print('error: the unmutated fixture failed'); sys.exit(1)
 sys.exit(0)
if flag=='A_TWO':
 if fault=='accepted': sys.exit(0)
 if fault=='crash': print('Stack dump: compiler failed'); sys.exit(70)
 if fault=='solver': print('error: cannot build rewrite system'); sys.exit(1)
 if fault=='dependency': print('error: no such module Lost'); print('error: RejectedATwo'); sys.exit(1)
 if fault=='unrelated': print('error: Unrelated'); sys.exit(1)
print('error: '+{'A_ONE':'RejectedAOne','A_TWO':'RejectedATwo','B_ONE':'RejectedBOne','C_ONE':'RejectedCOne'}[flag]); sys.exit(1)
'''); compiler.chmod(0o755)
        self.env = {**os.environ, 'PATH':str(self.root/'bin')+os.pathsep+os.environ['PATH'],
                    'EXECUTOR_TRACE':str(self.trace)}

    def run_cases(self, jobs, fault=''):
        self.trace.unlink(missing_ok=True)
        output = io.StringIO()
        with mock.patch.dict(os.environ, {**self.env,'EXECUTOR_FAULT':fault}):
            status = engine.run(self.root, self.cases, 'Modules', 'cache', jobs, output)
        records = [json.loads(line) for line in self.trace.read_text().splitlines()]
        return status, output.getvalue(), records

    def test_parallel_and_serial_publish_identical_ordered_refusals(self):
        serial = self.run_cases(1)
        parallel = self.run_cases(2)
        self.assertEqual(serial[:2], parallel[:2])
        self.assertEqual(serial[0], 0)
        self.assertEqual(serial[1].splitlines(), ['verdict: refused '+flag for flag,_ in self.cases])
        for _, _, records in (serial, parallel):
            calls=[row['args'] for row in records if row['event']=='start']
            positives=[args for args in calls if not any(a.startswith('-D') for a in args)]
            self.assertEqual(len(positives),3)
            self.assertEqual(sorted(a[2:] for args in calls for a in args if a.startswith('-D')),
                             sorted(flag for flag,_ in self.cases))
            ended={tuple(row['args']):row['at'] for row in records if row['event']=='end'}
            for row in records:
                args=row['args']
                if row['event']=='start' and args[-1].startswith('-D'):
                    self.assertLess(ended[tuple(args[:-1])],row['at'])
        for jobs, result in [(1,serial),(2,parallel)]:
            active=peak=0
            for row in sorted(result[2],key=lambda row:row['at']):
                active += 1 if row['event']=='start' else -1
                peak=max(peak,active)
                self.assertLessEqual(active,jobs)
            self.assertEqual(active,0)
            self.assertEqual(peak,jobs)

    def test_every_wrong_failure_remains_red_and_names_the_actual_late_case(self):
        for fault, reason in [('positive','standalone positive failed'), ('accepted','A_TWO was accepted'),
                              ('crash','compiler could not check A_TWO'), ('solver','compiler could not check A_TWO'),
                              ('dependency','missing dependency while checking A_TWO'),
                              ('unrelated','failure did not name RejectedATwo')]:
            with self.subTest(fault=fault):
                status, output, records=self.run_cases(3,fault)
                self.assertEqual(status,1)
                self.assertIn(reason,output)
                if fault!='positive': self.assertIn('verdict: refused A_ONE',output)
                self.assertNotIn('verdict: refused A_TWO',output)
                if fault=='positive': self.assertFalse(any(a.startswith('-D') for row in records for a in row['args']))

    def test_missing_duplicate_ambiguous_and_empty_cases_do_not_run_a_compiler(self):
        invalid = [[], self.cases+[self.cases[0]], [('LOST','RejectedLost')]]
        (self.root/'Checks/Twin.swift').write_text('#if A_ONE\n#endif\n')
        manifest=self.root/'Checks/verdict-inputs.json'
        declaration=json.loads(manifest.read_text());declaration['fixtures'].append('Checks/Twin.swift')
        manifest.write_text(json.dumps(declaration))
        invalid.append(self.cases)
        for cases in invalid:
            with self.subTest(cases=cases), mock.patch.object(engine.subprocess,'Popen') as run:
                with self.assertRaises(ValueError):
                    engine.run(self.root,cases,'Modules','cache',2,io.StringIO())
                run.assert_not_called()

    def test_failed_law_stops_its_other_compiler_process_groups(self):
        with mock.patch.dict(os.environ, {'EXECUTOR_SLOW':'1'}):
            status, output, records=self.run_cases(3,'accepted')
        self.assertEqual(status,1)
        self.assertIn('A_TWO was accepted',output)
        slow=[row for row in records if 'Checks/C.swift' in row['args']]
        self.assertTrue(any(row['event']=='start' for row in slow))
        self.assertFalse(any(row['event']=='end' for row in slow))
        for row in slow:
            with self.assertRaises(ProcessLookupError):os.kill(row['pid'],0)

    def test_cleanup_reaps_an_exited_but_uncollected_session_leader(self):
        process = subprocess.Popen([sys.executable, '-c', 'import os; os._exit(0)'],
                                   start_new_session=True, stdout=subprocess.PIPE)
        self.addCleanup(process.wait)
        # EOF comes from process exit; do not poll/communicate/wait beforehand.
        with process.stdout:
            self.assertEqual(process.stdout.read(), b'')
        self.assertIsNone(process.returncode)
        engine.stop_compiler(process)
        self.assertEqual(process.returncode, 0)

    def test_cleanup_handles_exit_after_poll_but_preserves_live_permission_denial(self):
        exited = mock.Mock(pid=123)
        exited.poll.return_value = 0
        with mock.patch.object(engine.os, 'killpg') as kill:
            engine.stop_compiler(exited)
            kill.assert_not_called()
        for completed in (True, False):
            with self.subTest(completed=completed):
                process = mock.Mock(pid=123)
                process.poll.return_value = None
                denied = PermissionError('injected Darwin EPERM before collection')
                if not completed:
                    process.wait.side_effect = subprocess.TimeoutExpired('compiler', 1)
                with mock.patch.object(engine.os, 'killpg', side_effect=denied):
                    if completed:
                        engine.stop_compiler(process)
                    else:
                        with self.assertRaises(PermissionError) as caught:
                            engine.stop_compiler(process)
                        self.assertIs(caught.exception, denied)
                process.wait.assert_called_once_with(timeout=1)

    def test_missing_compiler_is_not_a_refusal(self):
        with mock.patch.dict(os.environ, {'PATH':str(self.root/'absent')}):
            with self.assertRaises(FileNotFoundError):
                engine.run(self.root,self.cases,'Modules','cache',2,io.StringIO())


class LawSchedulingControls(unittest.TestCase):
    def test_independent_laws_overlap_but_barriers_and_failure_sections_hold(self):
        with tempfile.TemporaryDirectory(prefix='vi-law-schedule-') as directory:
            root=Path(directory); (root/'Checks').mkdir()
            source=Path(__file__).resolve().parent.parent
            script=(source/'check.sh').read_text()
            a=script.index('# This list is a Court roster projection')
            b=script.index('if [ "$MODE_LIST" = "yes" ]; then',a)
            entries=[f'"{tag}|{group}|probe|python3 probe.py {tag}"'
                     for tag,group in [('census','parallel'),('voice','parallel'),('readme','parallel'),('topics','serial')]]
            script=script[:a]+'LAWS=(\n'+'\n'.join(entries)+'\n)\n'+script[b:]
            (root/'check.sh').write_text(script)
            shutil.copy(source/'Checks/build-tools.sh',root/'Checks/build-tools.sh')
            (root/'probe.py').write_text('''import fcntl,json,os,sys,time
from pathlib import Path
def log(event):
 with Path('trace').open('a') as f:
  fcntl.flock(f,fcntl.LOCK_EX); f.write(json.dumps(dict(at=time.time(),tag=sys.argv[1],event=event))+'\\n')
log('start');time.sleep(0.08);print('probe '+sys.argv[1]);log('end')
if os.environ.get('FAIL_TAG')==sys.argv[1]:print('original failure '+sys.argv[1]);sys.exit(9)
''')
            for jobs,failed in [('1',''),('3',''),('3','voice')]:
                with self.subTest(jobs=jobs,failed=failed):
                    (root/'trace').unlink(missing_ok=True)
                    result=subprocess.run(['bash','check.sh'],cwd=root,
                                          env={**os.environ,'VI_CHECK_JOBS':jobs,'FAIL_TAG':failed},
                                          capture_output=True,text=True)
                    self.assertEqual(result.returncode,1 if failed else 0,result.stdout+result.stderr)
                    headers=engine.re.findall(r'^── (\w+):',result.stdout,engine.re.M)
                    self.assertEqual(headers,['census','voice','readme','topics'])
                    sections=engine.re.split(r'^── ',result.stdout,flags=engine.re.M)[1:]
                    for tag,section in zip(headers,sections):
                        self.assertIn('probe '+tag+'\n',section)
                        self.assertFalse(any('probe '+other+'\n' in section for other in headers if other!=tag))
                    events=[json.loads(line) for line in (root/'trace').read_text().splitlines()]
                    active=peak=0; ended={}
                    for event in sorted(events,key=lambda x:x['at']):
                        if event['event']=='start':
                            active+=1;peak=max(peak,active)
                            if event['tag']=='topics':
                                self.assertEqual(active,1)
                                self.assertEqual(set(ended),{'census','voice','readme'})
                        else: active-=1;ended[event['tag']]=event['at']
                    self.assertEqual(active,0);self.assertEqual(peak,int(jobs))
                    if failed:
                        self.assertIn('✗ RED: voice',result.stdout)
                        self.assertIn('original failure voice',sections[1])
                        self.assertNotIn('LAWS HOLD',result.stdout)
            for invalid in ('0','65','no','9'*50):
                (root/'trace').unlink()
                result=subprocess.run(['bash','check.sh'],cwd=root,
                                      env={**os.environ,'VI_CHECK_JOBS':invalid},capture_output=True)
                self.assertEqual(result.returncode,2)
                self.assertFalse((root/'trace').exists())
                (root/'trace').touch()


class WholeModuleControls(unittest.TestCase):
    def test_whole_module_checks_every_body_and_keeps_file_boundaries(self):
        vectors=[
            ('func first() -> Int { 1 }\n','func last() -> Int { "wrong" }\n',1),
            ('fileprivate enum Hidden {}\n','func use(_ value: Hidden) {}\n',1),
            ('fileprivate enum Local {}\n','fileprivate enum Local {}\n',0),
        ]
        with tempfile.TemporaryDirectory(prefix='vi-whole-module-') as directory:
            root=Path(directory)
            for first,last,wanted in vectors:
                (root/'First.swift').write_text(first); (root/'Second.swift').write_text(last)
                observations=[]
                for mode in ([],['-whole-module-optimization']):
                    result=subprocess.run(['swiftc','-typecheck',*mode,'-module-cache-path',
                                           str(root/'cache'),'First.swift','Second.swift'],cwd=root,
                                          capture_output=True,text=True)
                    self.assertEqual(result.returncode,wanted,result.stdout+result.stderr)
                    errors=set(engine.re.findall(r'^(?:First|Second)\.swift:\d+:\d+: error: .*',
                                                 result.stdout+result.stderr,engine.re.M))
                    if wanted: self.assertTrue(errors,result.stdout+result.stderr)
                    observations.append(errors)
                self.assertEqual(*observations)


class BuildReuseControls(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory(prefix='vi-check-build-')
        self.addCleanup(self.temp.cleanup)
        self.scratch=Path(self.temp.name)
        self.bin=self.scratch/'bin'; self.bin.mkdir()
        self.trace=self.scratch/'trace'
        self.root=Path(__file__).resolve().parent.parent
        (self.bin/'swift').write_text('''#!/usr/bin/env bash
printf '%s\\n' "$*" >> "$BUILD_TRACE"
if [ "${1:-}" = test ] && [ -n "${BUILD_MUTATE:-}" ]; then echo changed >> "$BUILD_MUTATE"; fi
if [ "${2:-}" = --show-bin-path ]; then printf '%s\\n' "$BUILD_BIN"; fi
''')
        (self.bin/'Tools').write_text('#!/usr/bin/env bash\necho "Tools: $*"\n')
        for p in self.bin.iterdir(): p.chmod(0o755)
        self.env={**os.environ,'PATH':str(self.bin)+os.pathsep+os.environ['PATH'],
                  'BUILD_TRACE':str(self.trace),'BUILD_BIN':str(self.bin)}
        self.env.pop('VI_CHECK_BUILD_BIN',None)

    def driver(self, root):
        # A physical-runner fixture supplies the Court projection at its boundary;
        # it does not claim to prove the roster or profile relation (debt T0084).
        (root/'Checks').mkdir(parents=True,exist_ok=True)
        script=(self.root/'check.sh').read_text()
        a=script.index('# This list is a Court roster projection')
        b=script.index('if [ "$MODE_LIST" = "yes" ]; then',a)
        script=script[:a]+'LAWS=("build|serial|probe|swift build --build-tests && swift test --skip-build" "census|parallel|probe|bash Checks/tools.sh census")\n'+script[b:]
        (root/'check.sh').write_text(script)
        shutil.copy(self.root/'Checks/build-tools.sh',root/'Checks/build-tools.sh')
        shutil.copy(self.root/'Checks/tools.sh',root/'Checks/tools.sh')

    def helper(self, prepared=None):
        env=dict(self.env)
        if prepared is not None: env['VI_CHECK_BUILD_BIN']=str(prepared)
        return subprocess.run(['bash','-c','. Checks/build-tools.sh; vi_check_tools_bin'],
                              cwd=self.root,env=env,capture_output=True,text=True)

    def test_standalone_builds_and_prepared_run_reuses_the_exact_tool(self):
        fresh=self.helper()
        self.assertEqual(fresh.returncode,0,fresh.stderr)
        self.assertEqual(fresh.stdout.strip(),str(self.bin))
        self.assertEqual(self.trace.read_text().splitlines(),['build --product Tools','build --show-bin-path'])
        self.trace.unlink()
        prepared=self.helper(self.bin)
        self.assertEqual(prepared.returncode,0,prepared.stderr)
        self.assertEqual(prepared.stdout,fresh.stdout)
        self.assertFalse(self.trace.exists())

    def test_lost_prepared_tool_refuses_with_its_address(self):
        lost=self.helper(self.scratch/'missing')
        self.assertNotEqual(lost.returncode,0)
        self.assertIn(str(self.scratch/'missing/Tools'),lost.stderr)
        self.assertFalse(self.trace.exists())

    def test_changed_projection_cannot_execute_a_stale_roster(self):
        root=self.scratch/'projection'; (root/'Checks').mkdir(parents=True)
        (root/'Sources').mkdir()
        (root/'Sources/Probe.swift').write_text('before')
        shutil.copy(self.root/'check.sh',root/'check.sh')
        shutil.copy(self.root/'Checks/build-tools.sh',root/'Checks/build-tools.sh')
        (root/'Checks/profiles.py').write_text("from pathlib import Path\nPath('Sources/Probe.swift').write_text('after')\nprint('probe|serial|physical witness|touch executed')\n")
        result=subprocess.run(['bash','check.sh'],cwd=root,env=self.env,capture_output=True,text=True)
        self.assertEqual(result.returncode,1,result.stdout+result.stderr)
        self.assertIn('Checks/Laws.swift:1: inputs changed',result.stderr)
        self.assertFalse((root/'executed').exists())

    def test_changed_build_inputs_cannot_receive_a_green_receipt(self):
        root=self.scratch/'source'; (root/'Checks').mkdir(parents=True)
        (root/'Sources').mkdir()
        source=root/'Sources/Probe.swift'; source.write_text('original')
        self.driver(root)
        shutil.copy(self.root/'Checks/build-tools.sh',root/'Checks/build-tools.sh')
        env={**self.env,'BUILD_MUTATE':str(source)}
        result=subprocess.run(['bash','check.sh','--only','build'],cwd=root,env=env,
                              capture_output=True,text=True)
        self.assertEqual(result.returncode,1,result.stdout+result.stderr)
        self.assertIn('build inputs changed',result.stderr)
        self.assertIn('✗ RED: build',result.stdout)
        self.assertNotIn('LAWS HOLD',result.stdout)

    def test_check_discards_an_inherited_build_and_names_partial_selection(self):
        env={**self.env,'VI_CHECK_BUILD_BIN':str(self.scratch/'stale')}
        root=self.scratch/'selection'; self.driver(root)
        result=subprocess.run(['bash','check.sh','--only','census'],cwd=root,env=env,
                              capture_output=True,text=True)
        self.assertEqual(result.returncode,0,result.stdout+result.stderr)
        self.assertIn('Tools: census',result.stdout)
        self.assertIn('not a full gate',result.stdout)
        self.assertNotIn('ALL LAWS HOLD',result.stdout)
        self.assertEqual(self.trace.read_text().splitlines(),['build --product Tools','build --show-bin-path'])




if __name__=='__main__': unittest.main()
