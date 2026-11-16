#!/usr/bin/env python3
"""Reads the pure Swift sources as rows, prints them back, and stores the rows as one table of pairs (Record Is System SW8 to SW10).
  the rows    a declaration: its name, parameters with bounds, conformances, where-conditions, members. A member 'name = type' with its
              parameters, its where-conditions and the type as a tree (head, arguments, member steps after a dot). An associated type.
              Only that type is read as a tree: bounds, conformances and the two sides of a where-condition are kept as text.
              A comment is a label on the row it precedes or on the row whose line it ends. Whatever is none of these rows is kept as text.
  the table   address -> (left address, right address). A Null place is a row whose two sides are its own address. A piece of text is one
              Null place with a label. Every other place is an occurrence. A list is Pair(first, rest) down to one end place.
Two comparisons can fail and make the program exit with 1: the text printed from the rows must equal the file up to whitespace, and the rows
read back from the table must be the rows that were stored. The table records the text by rows. It does not record which declaration a word
refers to.
The reader is fitted to the constructs of these two folders. It refuses a block comment, a multi-line string and a comment between a
declaration header and its brace. It is known to misread, without notice, an operator '<' or a ';' in a value and a string with a quote inside
an interpolation; none of these stands in the two folders at the revision the paper names.
  python3 Checks/record-rows.py                 read Sources/Examples and the lattice, print the counts
  python3 Checks/record-rows.py --print-to DIR  also write the Swift printed from the rows of every file into DIR/<source folder>/
  python3 Checks/record-rows.py --selftest      made-up files with planted changes that the comparisons must see
"""
import re, sys, json, pathlib, collections
ROOT = pathlib.Path(__file__).resolve().parents[1]
SQ = lambda s: re.sub(r'\s+', '', s)


def split_top(s, sep=','):
    """Split at separators that stand outside every bracket."""
    parts = []; depth = 0; cur = ''
    for ch in s:
        if ch in '<([{':
            depth += 1
        elif ch in '>)]}':
            depth -= 1
        if ch == sep and depth == 0:
            parts.append(cur); cur = ''
        else:
            cur += ch
    parts.append(cur); return [p.strip() for p in parts if p.strip()]

def type_tree(s):
    """A type as a tree: (head, [arguments], [member steps]). Returns None if the text is not of that shape."""
    s = re.sub(r'\s*([<>,.])\s*', r'\1', s.strip()); m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*)', s)      # 'In <In <Out<X>>>' is the same tree as 'In<In<Out<X>>>'
    if not m:
        return None
    head = m.group(1); rest = s[m.end():]; args = []; steps = []
    while rest:
        if rest[0] == '<':
            depth = 0
            for i, ch in enumerate(rest):
                depth += ch == '<'; depth -= ch == '>'
                if depth == 0:
                    break
            else:
                return None
            inner = [type_tree(a) for a in split_top(rest[1:i])]
            if any(a is None for a in inner):
                return None
            if steps:
                steps[-1] = (steps[-1][0], inner)
            else:
                args = inner
            rest = rest[i + 1:]
        elif rest[0] == '.':
            m = re.match(r'^\.([A-Za-z_][A-Za-z0-9_]*)', rest)
            if not m:
                return None
            steps.append((m.group(1), [])); rest = rest[m.end():]
        else:
            return None
    return (head, args, steps)

def show_type(t):
    head, args, steps = t; s = head + ('<' + ', '.join(show_type(a) for a in args) + '>' if args else '')
    for name, a in steps:
        s += '.' + name + ('<' + ', '.join(show_type(x) for x in a) + '>' if a else '')
    return s


HEAD = re.compile('^((?:public |private |fileprivate |internal |indirect |final )*)(enum|struct|protocol|extension|class)\\s+([A-Za-z_][\\w.]*)')
ALIAS = re.compile('^((?:public |private |fileprivate |internal )*)typealias\\s+([A-Za-z_]\\w*)\\s*(<[^=]*>)?\\s*=\\s*(.*)$', re.S)
ASSOC = re.compile('^((?:public )?)associatedtype\\s+([A-Za-z_]\\w*)\\s*(?::\\s*(.*?))?(?:\\s*=\\s*(.*))?$', re.S)


def parse_header(h):
    m = HEAD.match(h)
    if not m:
        return None
    mods, kind, name = m.groups(); rest = h[m.end():].strip(); params = []
    if rest.startswith('<'):
        depth = 0
        for i, ch in enumerate(rest):
            depth += ch == '<'; depth -= ch == '>'
            if depth == 0:
                break
        for p in split_top(rest[1:i]):
            nm, _, bound = p.partition(':'); params.append((nm.strip(), bound.strip()))
        rest = rest[i + 1:].strip()
    where = []
    w = re.search(r'\bwhere\b', rest)
    if w:
        for c in split_top(rest[w.end():]):
            mm = re.match(r'^(.*?)\s*(==|:)\s*(.*)$', c); where.append((mm.group(1), mm.group(2), mm.group(3)) if mm else (c, '', ''))
        rest = rest[:w.start()].strip()
    conf = split_top(rest[1:]) if rest.startswith(':') else ([] if not rest else None)
    if conf is None:
        return None
    return dict(mods=mods, kind=kind, name=name, params=params, conforms=conf, where=where)

def show_header(d):
    s = d['mods'] + d['kind'] + ' ' + d['name']
    if d['params']:
        s += '<' + ', '.join(n + (': ' + b if b else '') for n, b in d['params']) + '>'
    if d['conforms']:
        s += ': ' + ', '.join(d['conforms'])
    if d['where']:
        s += ' where ' + ', '.join((l + ' ' + o + ' ' + r) if o else l for l, o, r in d['where'])
    return s


def skip_string(t, j):
    k = j + 1
    while k < len(t) and t[k] != '"':
        k += 2 if t[k] == '\\' else 1
    return k + 1

def match_brace(t, j):
    d = 0; k = j
    while k < len(t):
        if t[k] == '"':
            k = skip_string(t, k); continue
        if t.startswith('//', k):
            e = t.find('\n', k); k = len(t) if e < 0 else e; continue
        d += t[k] == '{'; d -= t[k] == '}'
        if d == 0:
            return k
        k += 1
    raise ValueError('brace not closed')

def units(t):
    """The units of a text at its own level: ('label', text), ('decl', header, body, trail) or ('stmt', text, the same text as it stands with its comments, trail)."""
    out = []; i = 0; n = len(t)
    while i < n:
        while i < n and t[i].isspace():
            i += 1
        if i >= n:
            break
        if t.startswith('//', i):
            e = t.find('\n', i); e = n if e < 0 else e; out.append(('label', t[i:e], None, [])); i = e; continue
        j = i; depth = 0; buf = ''; trail = []; done = False
        while j < n:
            ch = t[j]
            if ch == '"':
                k = skip_string(t, j); buf += t[j:k]; j = k; continue
            if t.startswith('//', j):
                e = t.find('\n', j); e = n if e < 0 else e; trail.append(t[j:e]); j = e; continue
            if ch == '{' and depth <= 0:
                if trail:
                    raise ValueError('a comment stands between a declaration header and its brace')
                k = match_brace(t, j); e = t.find('\n', k); e = n if e < 0 else e; after = t[k + 1:e]
                if after.strip().startswith('//'):      # a comment that ends the line of the closing brace belongs to this declaration
                    trail = [after.strip()]; k = e - 1
                out.append(('decl', buf.strip(), t[j + 1:match_brace(t, j)], trail)); j = k + 1; done = True; break
            if ch in '<([':
                depth += 1
            elif ch in ')]' or (ch == '>' and not (j > 0 and t[j - 1] == '-')):
                depth -= 1
            if ch == '\n' and depth <= 0:
                s = buf.rstrip(); nxt = t[j + 1:j + 80].lstrip()
                if s.endswith(('=', ',', ':', '&', '<', '(', '->')) or re.match(r'(where\b|==|[:,&{.?]|->)', nxt):
                    buf += ch; j += 1; continue
                out.append(('stmt', s, t[i:j].rstrip(), trail)); j += 1; done = True; break
            buf += ch; j += 1
        if not done and buf.strip():
            out.append(('stmt', buf.strip(), t[i:j].rstrip(), trail))
        i = j
    return out

def split_where(s):
    """'type where conditions' -> (type text, [(left, relation, right)]). The where must stand outside every bracket. (text, None) if a condition is not 'left == right' or 'left: right'."""
    depth = 0
    for m in re.finditer(r'[<(\[]|[>)\]]|\bwhere\b', s):
        g = m.group(0)
        if g == 'where' and depth == 0:
            conds = []
            for c in split_top(s[m.end():]):
                mm = re.match(r'^(.*?)\s*(==|:)\s*(.*)$', c)
                if not mm:
                    return s, None
                conds.append((mm.group(1), mm.group(2), mm.group(3)))
            return s[:m.start()], conds
        depth += g in '<([' if g != 'where' else 0; depth -= g in '>)]' if g != 'where' else 0
    return s, []

def rows_of(t, count):
    rows = []; labels = []
    for kind, a, body, trail in units(t):
        if kind == 'label':
            labels.append(a); count['label lines'] += 1; continue
        count['label lines'] += len(trail)
        if kind == 'stmt':
            flat = ' '.join(a.split()); m = ALIAS.match(flat); r = None; rhs, wh = split_where(m.group(4)) if m else (None, None)
            if m and wh is not None and type_tree(rhs) is not None:
                r = dict(row='alias', mods=m.group(1), name=m.group(2), params=[tuple(x.strip() for x in (p.partition(':')[0], p.partition(':')[2])) for p in split_top((m.group(3) or '<>').strip()[1:-1])], type=type_tree(rhs), where=wh)
                count['alias parameters'] += len(r['params']); count['alias where conditions'] += len(wh)
            else:
                m = ASSOC.match(flat)
                if m and not re.search(r'\bwhere\b', flat):
                    r = dict(row='associated', mods=m.group(1), name=m.group(2), bound=m.group(3) or '', default=m.group(4) or '')
            if r is None:
                r = dict(row='import' if flat.startswith('import ') else 'raw', text=a)
                if trail and '\n' in body:      # raw text over several lines with comments inside: keep it as it stands, comments in their places
                    r['text'] = body; trail = []
            count[r['row']] += 1
        else:
            d = parse_header(' '.join(a.split()))
            if d is None:
                r = dict(row='raw declaration', head=a, body=body); count['raw declaration'] += 1
            else:
                r = dict(d, row='declaration', members=rows_of(body, count)); count['declaration'] += 1; count['parameters'] += len(d['params']); count['conformances'] += len(d['conforms']); count['where conditions'] += len(d['where'])
        r['labels'] = labels; r['trail'] = trail; labels = []; rows.append(r)
    if labels:
        rows.append(dict(row='labels only', labels=labels, trail=[]))
    return rows

def show(rows, indent=''):
    out = []
    for r in rows:
        out += [indent + l for l in r['labels']]; tr = (' ' + ' '.join(r['trail'])) if r['trail'] else ''
        if r['row'] == 'alias':
            gen = ('<' + ', '.join(n + (': ' + b if b else '') for n, b in r['params']) + '>') if r['params'] else ''; wh = ('\n' + indent + 'where ' + ', '.join(l + ' ' + o + ' ' + x for l, o, x in r['where'])) if r['where'] else ''
            out.append(indent + r['mods'] + 'typealias ' + r['name'] + gen + ' = ' + show_type(r['type']) + wh + tr)
        elif r['row'] == 'associated':
            out.append(indent + r['mods'] + 'associatedtype ' + r['name'] + (': ' + r['bound'] if r['bound'] else '') + (' = ' + r['default'] if r['default'] else '') + tr)
        elif r['row'] in ('raw', 'import'):
            out.append(indent + r['text'] + tr)
        elif r['row'] == 'raw declaration':
            out.append(indent + r['head'] + ' {' + r['body'] + '}' + tr)
        elif r['row'] == 'declaration':
            h = show_header(r); k = h.find(' where ')      # the repository's own grammar law refuses a where in the middle of a line
            out.append(indent + (h if k < 0 else h[:k] + '\n' + indent + h[k + 1:]) + ' {'); out += show(r['members'], indent + '    '); out.append(indent + '}' + tr)
    return out

def raw_size(rows):
    n = 0
    for r in rows:
        if r['row'] == 'raw':
            n += len(SQ(r['text']))
        elif r['row'] == 'raw declaration':
            n += len(SQ(r['head'])) + len(SQ(r['body']))
        elif r['row'] == 'declaration':
            n += raw_size(r['members'])
    return n

def read_file(text):
    if '/*' in text or '"""' in text:      # block comments and multi-line strings are not known to this reader; it refuses the file instead of reading it wrongly
        raise ValueError('a block comment or a multi-line string: this reader does not read them')
    count = collections.Counter(); rows = rows_of(text, count); printed = '\n'.join(show(rows)) + '\n'; return rows, count, SQ(text) == SQ(printed), printed


FIELDS = {'alias': ['mods', 'name', 'params', 'type', 'where'], 'associated': ['mods', 'name', 'bound', 'default'], 'raw': ['text'], 'import': ['text'], 'raw declaration': ['head', 'body'], 'declaration': ['mods', 'kind', 'name', 'params', 'conforms', 'where', 'members'], 'labels only': []}


class Table:
    def __init__(self):
        self.rows = []; self.label = {}; self.word = {}; self.end = self.null('end')
    def null(self, label):
        a = len(self.rows); self.rows.append((a, a)); self.label[a] = label; return a
    def atom(self, text):
        if text not in self.word:
            self.word[text] = self.null(text)
        return self.word[text]
    def pair(self, l, r):
        self.rows.append((l, r)); return len(self.rows) - 1
    def is_null(self, a):
        return self.rows[a] == (a, a)

def enc(T, v):
    if isinstance(v, str):
        return T.atom(v)
    if isinstance(v, (list, tuple)):
        a = T.end
        for x in reversed([enc(T, x) for x in v]):
            a = T.pair(x, a)
        return a
    if isinstance(v, dict):
        return T.pair(T.atom('row:' + v['row']), enc(T, [v[f] for f in FIELDS[v['row']]] + [v['labels'], v['trail']]))
    raise TypeError(type(v))

def items(T, a):
    out = []; seen = set()
    while a != T.end:
        if a in seen or not 0 <= a < len(T.rows) or T.rows[a] == (a, a):      # a place met twice, an address outside the table, or a Null place that is not 'end': this is not a list. Without these stops a wrong table makes the walk run for ever.
            raise ValueError('a list does not end at the place end')
        seen.add(a); l, r = T.rows[a]; out.append(l); a = r
    return out

def dec_tree(T, a):
    head, args, steps = items(T, a); return (T.label[head], [dec_tree(T, x) for x in items(T, args)], [(T.label[items(T, s)[0]], [dec_tree(T, x) for x in items(T, items(T, s)[1])]) for s in items(T, steps)])

def dec_row(T, a):
    k, rest = T.rows[a]; kind = T.label.get(k, '')[4:]
    if kind not in FIELDS or T.label[k][:4] != 'row:':
        raise ValueError('the first side of a row is not one of the kinds of a row')
    vals = items(T, rest); r = dict(row=kind); names = FIELDS[kind] + ['labels', 'trail']
    if len(vals) != len(names):      # without this a list that is too long reads as the same row
        raise ValueError('a row of kind %s has %d fields, not %d' % (kind, len(vals), len(names)))
    for f, v in zip(names, vals):
        if f in ('labels', 'trail', 'conforms'):
            r[f] = [T.label[x] for x in items(T, v)]
        elif f == 'type':
            r[f] = dec_tree(T, v)
        elif f == 'params':
            r[f] = [tuple(T.label[y] for y in items(T, x)) for x in items(T, v)]
        elif f == 'where':
            r[f] = [tuple(T.label[y] for y in items(T, x)) for x in items(T, v)]
        elif f == 'members':
            r[f] = [dec_row(T, x) for x in items(T, v)]
        else:
            r[f] = T.label[v]
    return r

def norm(rows):
    """The rows in the shape the table gives back (tuples and lists made uniform), for the comparison."""
    out = []
    for r in rows:
        r = dict(r)
        if 'params' in r:
            r['params'] = [tuple(p) for p in r['params']]
        if 'where' in r:
            r['where'] = [tuple(w) for w in r['where']]
        if 'type' in r:
            r['type'] = fix(r['type'])
        if 'members' in r:
            r['members'] = norm(r['members'])
        out.append(r)
    return out

def fix(t):
    return (t[0], [fix(a) for a in t[1]], [(n, [fix(a) for a in args]) for n, args in t[2]])


WORD = re.compile(r'[A-Za-z_][A-Za-z0-9_]*$')
KEYWORDS = set('public private fileprivate internal indirect final static enum struct protocol extension class let var func import typealias associatedtype where some any get set return if endif true false self Self Type'.split())


def remainder_kind(r):
    """The kind of a place kept as text, by its first words."""
    f = ' '.join((r.get('text') or r['head']).split())
    if f.startswith('#'):
        return 'conditional compilation line'
    if f.startswith('@'):
        return 'attributed import'
    if 'typealias' in f.split('=')[0]:
        return 'type alias not read as a tree'
    if re.search(r'\bfunc\b', f):
        return 'function'
    if r['row'] == 'raw declaration':
        return 'computed property'
    if re.search(r'\.self\b', f):
        return 'value of the form T.self'
    return 'string value' if '"' in f else 'other'


def walk(rows, count, kinds):
    for r in rows:
        count['labels'] += sum(len(SQ(x)) for x in r['labels'] + r['trail'])
        if r['row'] in ('raw', 'raw declaration'):
            kinds[remainder_kind(r)] += 1
        if r['row'] == 'declaration':
            walk(r['members'], count, kinds)


def label_kind(label):
    if label.startswith('row:') or label == 'end':
        return 'kind of a row or the end place'
    if label in ('==', ':', ''):
        return 'relation sign or empty'
    if label.lstrip().startswith('//'):
        return 'comment line'
    if WORD.match(label.strip()):
        return 'keyword or modifier' if label.strip() in KEYWORDS else 'single word'
    return 'unread text'


def selftest():
    src = 'import X\n\n/// a label\npublic enum A<B: P, C>: Q, R\nwhere B.S == C.S, B: T,\n      F<B.S>\n        == F<C.S> {\n    /// inner label\n    public typealias Left = B // at the end\n    public enum Inner: Null {\n        public typealias Right = Paired<\n            B.Left,\n            F <C>.G\n        >\n    }   // after the brace\n    public static let label = "4p // not a comment"\n}\n\npublic typealias H<R: P, S> = A<R, S>.Right\nwhere R.Left: P, R.Right == S\n'
    rows, count, same, printed = read_file(src); T = Table(); a = enc(T, rows); back = [dec_row(T, x) for x in items(T, a)]; stored = norm(rows) == back and SQ('\n'.join(show(back))) == SQ(src)
    placed = rows[1]['members'][1]['trail'] == ['// after the brace'] and rows[2]['where'] == [('R.Left', ':', 'P'), ('R.Right', '==', 'S')] and rows[1]['where'][2] == ('F<B.S>', '==', 'F<C.S>')
    refused = 0
    for bad in ('enum A { /* } */ typealias L = B }\n', 'enum A // note\n{ typealias L = B }\n'):
        try:
            read_file(bad)
        except ValueError:
            refused += 1
    changed = [dict(r) for r in rows]; changed[1] = dict(changed[1], name='Changed'); seen_print = SQ(src) != SQ('\n'.join(show(changed)))
    second = items(T, a)[1]; keep = list(T.rows); seen = []; raw_kind = T.atom('row:raw'); no_kind = T.atom('not a kind'); keep = list(T.rows)
    def wrong(place, row):      # a planted change of one table row must be seen: a different reading or a refusal, never the same rows and never an endless walk
        T.rows[:] = keep; T.rows[place] = row
        try:
            seen.append([dec_row(T, x) for x in items(T, a)] != back)
        except ValueError:
            seen.append(True)
    wrong(second, (raw_kind, keep[second][1]))                                # the kind of a row replaced by another kind
    wrong(second, (no_kind, keep[second][1]))                                 # a first side that is not a kind
    wrong(a, (keep[a][0], a))                                                 # a pair whose right side is its own address
    wrong(keep[second][1], (keep[keep[second][1]][0], keep[a][1]))            # the list of fields of a row made longer
    ok = same and stored and placed and refused == 2 and seen_print and all(seen)
    print(json.dumps(dict(printed_back_equal=same, read_back_from_table_equal=stored, comments_and_conditions_in_their_places=placed, unknown_constructs_refused=refused, changed_row_seen_by_print=seen_print, changed_table_rows_seen=seen))); print('selftest', 'passed' if ok else 'FAILED'); return 0 if ok else 1


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    out = pathlib.Path(sys.argv[sys.argv.index('--print-to') + 1]) if '--print-to' in sys.argv else None
    T = Table(); report = {}; bad = []; roots = []
    for folder in ('Sources/Examples', 'Sources/VerificationIsIdentification'):
        total = collections.Counter(); chars = 0; raw = 0; files = sorted((ROOT / folder).glob('*.swift')); extra = collections.Counter(); kinds = collections.Counter()
        for f in files:
            text = f.read_text(); rows, count, same, printed = read_file(text); total.update(count); chars += len(SQ(text)); raw += raw_size(rows); walk(rows, extra, kinds); a = enc(T, rows); roots.append(a); back = [dec_row(T, x) for x in items(T, a)]
            if not same:
                bad.append(folder + '/' + f.name + ': printed rows differ from the file')
            if norm(rows) != back or SQ('\n'.join(show(back))) != SQ(text):
                bad.append(folder + '/' + f.name + ': rows read back from the table differ')
            if out is not None:
                (out / folder).mkdir(parents=True, exist_ok=True); (out / folder / f.name).write_text(printed)
        report[folder] = dict(files=len(files), characters=chars, kept_as_text=raw, share_in_rows_and_labels=round(1 - raw / max(1, chars), 4), comment_characters=extra['labels'], share_of_comments=round(extra['labels'] / max(1, chars), 4),
                              share_of_other_characters_in_rows=round(1 - raw / max(1, chars - extra['labels']), 4), places_kept_as_text=dict(sorted(kinds.items())), rows=dict(sorted((k, v) for k, v in total.items() if v)))
    nulls = [i for i in range(len(T.rows)) if T.is_null(i)]; by_label = collections.Counter(label_kind(T.label[i]) for i in nulls); intern = {}; stack = list(roots); words = collections.Counter()
    while stack:      # every pair is met once (an occurrence has one address), so this walk meets each use of a Null place once
        a = stack.pop(); l, r = T.rows[a]
        if (l, r) == (a, a):
            k = label_kind(T.label[a])
            if k == 'single word':
                words['a word standing as its own place'] += 1
            elif k == 'unread text':
                words['a word inside unread text'] += sum(1 for w in re.findall(r'[A-Za-z_][A-Za-z0-9_]*', re.sub(r'//[^\n]*|"[^"\n]*"', '', T.label[a])) if w not in KEYWORDS)
        else:
            stack.append(l); stack.append(r)
    for a in range(len(T.rows)):      # children are stored before their pair, so one pass in address order gives every structure its class
        l, r = T.rows[a]; intern[a] = intern.setdefault(('n', a), len(intern)) if (l, r) == (a, a) else intern.setdefault(('p', intern[l], intern[r]), len(intern))
    report['table'] = dict(rows=len(T.rows), null_places=len(nulls), pair_places=len(T.rows) - len(nulls), null_places_by_label=dict(sorted(by_label.items())), word_occurrences_outside_comments=dict(sorted(words.items())), distinct_structures_if_equal_ones_shared_a_place=len(set(intern[a] for a in range(len(T.rows)))))
    report['not_equal'] = bad; print(json.dumps(report, indent=1)); sys.exit(1 if bad else 0)
