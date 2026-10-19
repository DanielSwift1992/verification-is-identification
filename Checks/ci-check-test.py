#!/usr/bin/env python3
"""The log wrapper must preserve failure and escape workflow-command data."""
from pathlib import Path
import importlib.util
import io
import re
import sys
import unittest

spec = importlib.util.spec_from_file_location('ci_check', Path(__file__).with_name('ci-check.py'))
ci = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ci)


class CICheckTests(unittest.TestCase):
    def child(self, source):
        output = io.BytesIO()
        status = ci.run([sys.executable, '-c', source], cwd=Path(__file__).parent, output=output)
        return status, output.getvalue()

    def test_success_is_unchanged(self):
        status, output = self.child("import sys; sys.stdout.write('ok'); sys.stdout.flush(); sys.stderr.write(' err\\n')")
        self.assertEqual(status, 0)
        self.assertEqual(output, b'ok err\n')

    def test_child_failure_codes_survive(self):
        for code in [1, 2, 3, 7, 127]:
            with self.subTest(code=code):
                status, output = self.child(f"print('failure reason'); raise SystemExit({code})")
                self.assertEqual(status, code)
                self.assertTrue(output.startswith(b'failure reason\n::error '))
                self.assertIn(f'status {code}'.encode(), output)

    def test_signal_is_not_success(self):
        status, output = self.child('import os,signal; os.kill(os.getpid(),signal.SIGTERM)')
        self.assertEqual(status, 1)
        self.assertIn(b'status -15', output)

    def test_missing_executable_is_reported(self):
        output = io.BytesIO()
        status = ci.run(['/vi-no-such-ci-command'], cwd=Path(__file__).parent, output=output)
        self.assertEqual(status, 2)
        self.assertIn(b'::error ', output.getvalue())

    def test_annotation_data_cannot_open_a_new_command(self):
        message = '100%\r\n::warning::not a command\n%0A'
        encoded = ci.annotation(message)
        self.assertEqual(encoded.count('\n'), 1)
        self.assertNotIn('\r', encoded)
        self.assertIn('100%25%0D%0A::warning::not a command%0A%250A', encoded)

    def test_no_final_newline_still_has_an_annotation_boundary(self):
        status, output = self.child("import sys; sys.stdout.write('end'); raise SystemExit(3)")
        self.assertEqual(status, 3)
        self.assertTrue(output.startswith(b'end\n::error '))

    def test_tail_is_bounded_but_streamed_log_is_whole(self):
        status, output = self.child("print('old line'); print('x' * 20000); print('last reason'); raise SystemExit(1)")
        self.assertEqual(status, 1)
        original, report = output.split(b'::error ', 1)
        self.assertIn(b'x' * 20000, original)
        self.assertNotIn(b'old line', report)
        self.assertIn(b'last reason', report)
        self.assertLess(len(report), ci.TAIL_CHARACTERS + 200)

    def test_only_last_sixty_lines_are_retained(self):
        status, output = self.child("print('first sentinel'); [print(i) for i in range(70)]; raise SystemExit(1)")
        self.assertEqual(status, 1)
        original, report = output.split(b'::error ', 1)
        self.assertIn(b'first sentinel', original)
        self.assertNotIn(b'first sentinel', report)
        self.assertIn(b'69%0A', report)


    def test_failed_law_survives_later_successful_output(self):
        source = "print('── scope: bounded reader'); print('scope original reason'); print('── court: builds'); [print('later '+str(i)) for i in range(100)]; print('✗ RED: scope'); raise SystemExit(1)"
        status, output = self.child(source)
        self.assertEqual(status, 1)
        original, annotations = output.split(b'::error ', 1)
        self.assertIn(b'scope original reason', original)
        self.assertNotIn(b'scope original reason', annotations.split(b'::error ', 1)[0])
        self.assertIn(b'Reported failed law scope.', annotations)
        self.assertIn(b'scope original reason', annotations)
        self.assertNotIn(b'Reported failed law court.', annotations)

    def test_multiple_reported_failures_keep_their_own_sections(self):
        status, output = self.child("print('── first: test'); print('first reason'); print('── second: test'); print('second reason'); print('✗ RED: first second first'); raise SystemExit(7)")
        self.assertEqual(status, 7)
        self.assertEqual(output.count(b'Reported failed law first.'), 1)
        self.assertEqual(output.count(b'Reported failed law second.'), 1)
        first = output.split(b'Reported failed law first.', 1)[1].split(b'::error ', 1)[0]
        self.assertIn(b'first reason', first)
        self.assertNotIn(b'second reason', first)

    def test_success_does_not_emit_annotations_for_a_reported_failure(self):
        source = "print('── scope: text'); print('✗ RED: scope')"
        status, output = self.child(source)
        self.assertEqual(status, 0)
        self.assertNotIn(b'::error ', output)

    def test_sections_and_annotations_are_bounded(self):
        source = "[print('── law'+str(i)+': test\\n'+'x'*20000) for i in range(100)]; print('✗ RED: '+' '.join('law'+str(i) for i in range(90,100))); raise SystemExit(1)"
        status, output = self.child(source)
        self.assertEqual(status, 1)
        self.assertEqual(output.count(b'::error '), 1 + ci.LAW_ANNOTATIONS)
        self.assertNotIn(b'Reported failed law law98.', output)
        for annotation in output.split(b'::error ')[1:]:
            self.assertLess(len(annotation), ci.TAIL_CHARACTERS * 3 + 500)

    def test_old_section_eviction_preserves_the_global_fallback(self):
        status, output = self.child("[print('── law'+str(i)+': test') for i in range(100)]; print('✗ RED: law0 law99'); raise SystemExit(1)")
        self.assertEqual(status, 1)
        self.assertNotIn(b'Reported failed law law0.', output)
        self.assertIn(b'Reported failed law law99.', output)
        self.assertIn(b'Last log lines:', output)

    def test_section_diagnostics_are_escaped(self):
        status, output = self.child("print('── scope: text'); print('100%\\r\\n::warning::payload'); print('── later: test'); print('ok'); print('✗ RED: scope'); raise SystemExit(1)")
        report = output.split(b'Reported failed law scope.', 1)[1]
        self.assertIn(b'100%25%0D%0A::warning::payload%0A', report)
        self.assertEqual(report.count(b'\n'), 1)
        self.assertEqual(status, 1)

    def test_retained_tail_memory_is_bounded(self):
        tail = ci.BoundedTail()
        for i in range(100): tail.append('x' * 20000)
        self.assertLessEqual(tail.characters, ci.TAIL_CHARACTERS)
        self.assertLessEqual(len(tail.lines), ci.TAIL_LINES)
        self.assertEqual(tail.characters, len(tail.text()))


    def test_long_red_metadata_is_not_retained_after_later_lines(self):
        for prefix in ['', 'scope second third fourth fifth sixth seventh eighth ']:
            with self.subTest(prefix=prefix):
                states = []
                def trace(frame, event, arg):
                    if frame.f_code is ci.run.__code__ and event == 'line' and 'status' in frame.f_locals:
                        state = frame.f_locals
                        states.append({
                            'tags': [len(x) for x in state['failed']],
                            'matches': [len(v.string) for v in state.values() if isinstance(v, re.Match)],
                            'strings': [len(v) for v in state.values() if isinstance(v, (str, bytes))],
                        })
                    return trace
                previous = sys.gettrace()
                try:
                    sys.settrace(trace)
                    source = f"print('── scope: test'); print('✗ RED: '+{prefix!r}+'a'*200000); [print('later') for i in range(100)]; raise SystemExit(1)"
                    status, output = self.child(source)
                finally:
                    sys.settrace(previous)
                self.assertEqual(status, 1)
                self.assertTrue(states)
                for state in states:
                    self.assertTrue(all(n <= 64 for n in state['tags']))
                    self.assertTrue(all(n <= ci.SUMMARY_CHARACTERS for n in state['matches']))
                    self.assertTrue(all(n <= ci.TAIL_CHARACTERS for n in state['strings']))
                self.assertNotIn(b'Reported failed law', output)
                self.assertIn(b'Last log lines:', output)

    def test_failed_tags_use_the_bounded_header_grammar(self):
        self.assertEqual(ci.reported_failures('✗ RED: scope scope law-2\n'), ['scope', 'law-2'])
        self.assertIsNone(ci.reported_failures('✗ RED: ' + 'a' * 65))
        self.assertIsNone(ci.reported_failures('✗ RED: 2scope'))
        self.assertIsNone(ci.reported_failures('✗ RED: scope;other'))


if __name__ == '__main__':
    unittest.main()
