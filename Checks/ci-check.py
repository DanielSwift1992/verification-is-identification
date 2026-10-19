#!/usr/bin/env python3
"""Stream check.sh unchanged; annotate bounded global and reported failing-law tails."""
from collections import deque, OrderedDict
from pathlib import Path
import re
import subprocess
import sys

TAIL_LINES = 60
TAIL_CHARACTERS = 12000
LAW_WINDOWS = 64
LAW_ANNOTATIONS = 8
SUMMARY_CHARACTERS = 4096
LAW_HEADER = re.compile(r"^── ([a-z][a-z0-9-]{0,63}): ")
FAILED_LAWS = re.compile(r"^✗ RED: ([a-z][a-z0-9-]{0,63}(?: [a-z][a-z0-9-]{0,63})*)$")


def annotation(message):
    # Workflow-command data must remain one physical line. In particular, a
    # percent escape in the original log is text, not a second decoding step.
    return '::error title=VI check failed::' + message.replace('%', '%25').replace('\r', '%0D').replace('\n', '%0A') + '\n'


class BoundedTail:
    def __init__(self):
        self.lines = deque()
        self.characters = 0

    def append(self, text):
        text = text[-TAIL_CHARACTERS:]
        self.lines.append(text)
        self.characters += len(text)
        while len(self.lines) > TAIL_LINES:
            self.characters -= len(self.lines.popleft())
        while self.characters > TAIL_CHARACTERS:
            excess = self.characters - TAIL_CHARACTERS
            first = self.lines.popleft()
            cut = min(excess, len(first))
            self.characters -= cut
            if cut < len(first):
                self.lines.appendleft(first[cut:])

    def text(self):
        return ''.join(self.lines)



def reported_failures(text):
    # Parse within a short-lived frame. No match object or unbounded token is
    # retained by the streaming loop after the current input line is handled.
    if len(text) > SUMMARY_CHARACTERS:
        return None
    summary = FAILED_LAWS.fullmatch(text.rstrip('\r\n'))
    if summary is None:
        return None
    return list(dict.fromkeys(summary.group(1).split()))[:LAW_ANNOTATIONS]


def run(command, *, cwd, output):
    tail = BoundedTail()
    sections = OrderedDict()
    active = None
    failed = []
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
        text = line.decode('utf-8', errors='replace')
        tail.append(text)
        header = LAW_HEADER.match(text)
        if header:
            active = header.group(1)
            sections[active] = BoundedTail()
            sections.move_to_end(active)
            while len(sections) > LAW_WINDOWS:
                sections.popitem(last=False)
        if active in sections:
            sections[active].append(text)
        names = reported_failures(text)
        if names is not None:
            failed = names
        del header, text, line
    process.stdout.close()
    status = process.wait()
    if status:
        ending = tail.text()
        # A child may finish without a newline. Keep the annotation at a line
        # boundary without changing any earlier bytes of its combined output.
        if ending and not ending.endswith('\n'):
            output.write(b'\n')
        output.write(annotation(f'check.sh exited with status {status}. Last log lines:\n{ending}').encode())
        # Headers and the RED summary are diagnostic text, not execution control.
        # Keep a bounded window for reported failures even when later laws succeed.
        for tag in failed[:LAW_ANNOTATIONS]:
            if tag in sections:
                output.write(annotation(f'Reported failed law {tag}. Retained log lines:\n{sections[tag].text()}').encode())
        output.flush()
    return status if status >= 0 else 1


if __name__ == '__main__':
    root = Path(__file__).resolve().parents[1]
    sys.exit(run(['./check.sh', *sys.argv[1:]], cwd=root, output=sys.stdout.buffer))
