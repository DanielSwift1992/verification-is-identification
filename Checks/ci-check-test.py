#!/usr/bin/env python3
"""The log wrapper must preserve failure and escape workflow-command data."""
from pathlib import Path
import importlib.util
import io
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


if __name__ == '__main__':
    unittest.main()
