#!/usr/bin/env python3
"""Stream check.sh unchanged and expose a bounded failure tail as a CI annotation."""
from collections import deque
from pathlib import Path
import subprocess
import sys

TAIL_LINES = 60
TAIL_CHARACTERS = 12000


def annotation(message):
    # Workflow-command data must remain one physical line. In particular, a
    # percent escape in the original log is text, not a second decoding step.
    return '::error title=VI check failed::' + message.replace('%', '%25').replace('\r', '%0D').replace('\n', '%0A') + '\n'


def run(command, *, cwd, output):
    tail = deque(maxlen=TAIL_LINES)
    try:
        process = subprocess.Popen(command, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    except OSError as exc:
        output.write(annotation(f'Cannot start check.sh: {exc}').encode())
        output.flush()
        return 2
    for line in process.stdout:
        output.write(line)
        output.flush()
        # Bound retained data even if a child produces an exceptionally long line.
        tail.append(line.decode('utf-8', errors='replace')[-TAIL_CHARACTERS:])
    process.stdout.close()
    status = process.wait()
    if status:
        ending = ''.join(tail)[-TAIL_CHARACTERS:]
        # A child may finish without a newline. Keep the annotation at a line
        # boundary without changing any earlier bytes of its combined output.
        if tail and not tail[-1].endswith('\n'):
            output.write(b'\n')
        output.write(annotation(f'check.sh exited with status {status}. Last log lines:\n{ending}').encode())
        output.flush()
    return status if status >= 0 else 1


if __name__ == '__main__':
    root = Path(__file__).resolve().parents[1]
    sys.exit(run(['./check.sh', *sys.argv[1:]], cwd=root, output=sys.stdout.buffer))
