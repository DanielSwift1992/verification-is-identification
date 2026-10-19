#!/usr/bin/env python3
"""Four views of the declared three-beam construction; see beam-study-sources.md."""
from html import escape
from pathlib import Path
import re

from render import Figure


TITLE = 'One reading, three possible sources'
DESC = ('The source is one of three symbolic states: (1,0,0), (1,0,1), (1,0,2). '
        'The reading E keeps the first two coordinates, giving (1,0) in all three cases. '
        'It determines the visible pair, but not the hidden value. SwapVisible exchanges '
        'the first two coordinates and retains the third: the full outputs still differ, '
        'but all have visible pair (0,1). Starting from the original states, ExposeHidden '
        'instead maps (alpha,beta,r) to (r,0,0), giving three different visible pairs. '
        'The original reading alone cannot determine this new answer. These are checked '
        'relations in a symbolic model, not a demonstrated physical implementation.')
HEIGHT = 1830
f = Figure(TITLE, DESC, HEIGHT)
# Larger type belongs to this sequence; the other diagrams keep their own layout.
f.parts.append('''<style>
.body{font-size:24px}.small{font-size:22px}.label{font-size:26px;font-weight:600}
.heading{font-size:32px;font-weight:650}.title{font-size:40px;font-weight:650}
.tuple{font-family:'DejaVu Sans',sans-serif;font-size:32px}
.number{font-size:26px;font-weight:700;fill:#204f8f}
</style>''')


def heading(y, number, text):
    f.text(65, y, str(number), 'number')
    f.text(110, y, text, 'heading')


def state(x, y, a, b, r, exposed=False):
    """Retain every full coordinate; color identifies what E can read."""
    first = 'amber' if exposed else 'green'
    f.text(x, y, '(', 'tuple muted')
    f.text(x + 19, y, str(a), f'tuple {first}')
    f.text(x + 41, y, ',', 'tuple muted')
    f.text(x + 61, y, str(b), f'tuple {first}')
    f.text(x + 83, y, ',', 'tuple muted')
    f.text(x + 103, y, str(r), 'tuple muted')
    f.text(x + 126, y, ')', 'tuple muted')


f.text(40, 57, TITLE, 'title')
f.lines(40, 100, [
    'The source is one of these three symbolic cases. All give the reading (1, 0).',
    'We do not know which one is present.'
], 'body', 34)

# 1: three complete states converge to one reading. No state is selected.
f.rect(40, 166, 1040, 320)
heading(210, 1, 'Three sources, one reading')
f.text(105, 258, 'Possible source states', 'small muted')
f.text(776, 258, 'Visible pair', 'small muted')
for i, r in enumerate(range(3)):
    y = 309 + i * 56
    state(150, y, 1, 0, r)
    f.path(f'M320 {y - 10}H390L506 355')
f.text(476, 294, 'The reading keeps', 'small muted')
f.text(476, 323, 'two coordinates', 'small muted')
f.path('M518 355H734')
f.text(526, 394, 'E(α, β, r) = (α, β)', 'small math blue')
f.rect(752, 301, 285, 108, '#edf7f1', '#bad9c8')
f.text(894, 368, '(1, 0)', 'title green', text_anchor='middle')
f.text(65, 458, 'Only the third coordinate, r, differs. It is hidden from this reading.', 'body')

# 2: the same information answers one question and leaves another open.
f.rect(40, 510, 1040, 230)
heading(555, 2, 'What can this reading answer?')
f.text(76, 610, 'What is the visible pair?', 'body')
f.text(76, 688, 'What is the hidden value?', 'body')
f.rect(540, 579, 497, 59, '#edf7f1', '#bad9c8')
f.text(563, 617, '(1, 0) in every case', 'label green')
f.rect(540, 657, 497, 59, '#fff8ec', '#e8d2aa')
f.text(563, 695, 'Could be 0, 1, or 2', 'label amber')

# 3: list full outputs before projecting them. The shared answer does not
# imply an identical full state, an identified source, or physical execution.
f.rect(40, 774, 1040, 454)
heading(820, 3, 'One operation, the same visible result')
f.text(65, 863, 'SwapVisible exchanges the first two coordinates and keeps the hidden one.', 'body')
f.text(119, 913, 'Original state', 'small muted')
f.text(490, 913, 'After SwapVisible', 'small muted')
f.text(830, 913, 'Visible pair', 'small muted')
for i, r in enumerate(range(3)):
    y = 962 + i * 55
    state(122, y, 1, 0, r)
    f.path(f'M298 {y - 10}H445')
    state(494, y, 0, 1, r)
    f.path(f'M670 {y - 10}H795')
    f.rect(811, y - 35, 226, 47, '#edf7f1', '#bad9c8')
    f.text(924, y, '(0, 1)', 'tuple green', text_anchor='middle')
f.text(65, 1131, 'The full states still differ. The visible pair is (0, 1) in every case.', 'body')
f.text(65, 1170, 'The new reading follows by swapping the old pair: (1, 0) → (0, 1).', 'body')
f.text(65, 1205, 'T(α, β, r) = (β, α, r)', 'small math blue')
f.text(530, 1205, 'E ∘ T = swap ∘ E', 'small math blue')

# 4 starts again at the original states. It is an alternative operation,
# not the next arrow in an unannounced composition of operations.
f.rect(40, 1252, 1040, 454)
heading(1298, 4, 'A different operation makes the hidden value matter')
f.text(65, 1341, 'From the same original states, ExposeHidden puts r in the visible pair.', 'body')
f.text(119, 1391, 'Original state', 'small muted')
f.text(480, 1391, 'After ExposeHidden', 'small muted')
f.text(830, 1391, 'Visible pair', 'small muted')
for i, r in enumerate(range(3)):
    y = 1440 + i * 55
    state(122, y, 1, 0, r)
    f.path(f'M298 {y - 10}H445')
    state(494, y, r, 0, 0, exposed=True)
    f.path(f'M670 {y - 10}H795')
    f.rect(811, y - 35, 226, 47, '#fff8ec', '#e8d2aa')
    f.text(924, y, f'({r}, 0)', 'tuple amber', text_anchor='middle')
f.text(65, 1608, 'The old reading (1, 0) alone cannot tell us which new pair results.', 'body')
f.text(65, 1646, 'For this new answer, we need an observation that distinguishes these cases.', 'body')
f.text(65, 1682, 'U(α, β, r) = (r, 0, 0)', 'small math blue')

f.lines(40, 1751, [
    'These relations are checked in a symbolic model. The diagram does not establish',
    'that the operations can be performed on a physical source.'
], 'small muted', 32)
f.save('beam-study.svg')

full = (Path(__file__).resolve().parent / 'beam-study.svg').read_text()
views = [
    ('beam-questions.svg', 0, 752, TITLE,
     'Three symbolic source states yield the same visible pair (1,0). '
     'The reading determines that pair but leaves the hidden value at 0, 1, or 2.'),
    ('beam-continuation.svg', 758, 1072, 'Two operations on the same three possible sources',
     'SwapVisible produces distinct full states with the same visible pair (0,1). '
     'Starting again from the original states, ExposeHidden gives visible pairs '
     '(0,0), (1,0), and (2,0). The old reading alone cannot determine this new answer. '
     'These are symbolic operations with checked type relations; physical execution '
     'is not established.'),
]
for name, top, height, title, desc in views:
    view = full.replace(f'height="{HEIGHT}" viewBox="0 0 1120 {HEIGHT}"',
                        f'height="{height}" viewBox="0 {top} 1120 {height}"', 1)
    view = re.sub(r'<title id="title">.*?</title>',
                  f'<title id="title">{escape(title)}</title>', view, count=1)
    view = re.sub(r'<desc id="desc">.*?</desc>',
                  f'<desc id="desc">{escape(desc)}</desc>', view, count=1)
    (Path(__file__).resolve().parent / name).write_text(view)
