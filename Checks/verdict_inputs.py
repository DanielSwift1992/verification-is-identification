#!/usr/bin/env python3
"""Physical verdict input/compilation transport; collection debt T0106."""
from pathlib import Path, PurePosixPath
import argparse
import datetime
import hashlib
import json
import os
import shutil
import subprocess
import sys

MANIFEST = 'Checks/verdict-inputs.json'


def encoded(value):
    return json.dumps(value, sort_keys=True, separators=(',', ':'), ensure_ascii=True).encode()


def digest(value):
    return hashlib.sha256(value).hexdigest()


def write_json(path, value):
    Path(path).write_text(json.dumps(value, indent=2, ensure_ascii=True) + '\n', encoding='utf-8')


def relative(value, at):
    if not isinstance(value, str): raise ValueError(at + ': expected a relative source address')
    path = PurePosixPath(value)
    if (not value or path.is_absolute()
            or path.as_posix() != value or any(p in ('.', '..') for p in path.parts)
            or any(c in value for c in '\r\n\0\\')):
        raise ValueError(at + ': expected a relative source address')
    return value


def declaration(root):
    data = json.loads((root / MANIFEST).read_text(encoding='utf-8'))
    if set(data) != {'schema', 'targets', 'fixtures', 'law_inputs'} or data['schema'] != 'vi.verdict-inputs/1':
        raise ValueError(MANIFEST + ': unsupported input declaration')
    for key in ('targets', 'fixtures', 'law_inputs'):
        items = data[key]
        if not isinstance(items, list) or not items:
            raise ValueError(MANIFEST + '.' + key + ': expected distinct nonempty addresses')
        for n, value in enumerate(items):
            relative(value, MANIFEST + '.' + key + '[' + str(n) + ']')
        if len(set(items)) != len(items):
            raise ValueError(MANIFEST + '.' + key + ': repeated address')
    if any(not p.endswith('.swift') for p in data['fixtures']):
        raise ValueError(MANIFEST + '.fixtures: expected Swift source addresses')
    return data


def fixture_paths(root):
    return declaration(root)['fixtures']


def make_dependencies(text, at):
    """Read the finite Make dependency transport emitted by Swift, not Swift."""
    # Backslash quotes a path character or joins lines. Dollar is doubled by
    # Make. A colon followed by whitespace ends a target (not a drive letter).
    rules, rule, word = [], [], ''
    i = 0
    while i < len(text):
        c = text[i]
        if c == '\\':
            if i + 1 >= len(text):
                raise ValueError(at + ': unfinished dependency escape')
            following = text[i + 1]
            if following == '\r' and text[i + 2:i + 3] == '\n':
                i += 3
                continue
            if following == '\n':
                i += 2
                continue
            word += following
            i += 2
            continue
        if c == '$':
            if text[i:i + 2] != '$$':
                raise ValueError(at + ': dependency variables are unread')
            word += '$'; i += 2
            continue
        if c == '#' or c in '\r\n':
            if word: rule.append(word); word = ''
            if rule: rules.append(rule); rule = []
            if c == '#':
                while i < len(text) and text[i] not in '\r\n': i += 1
                continue
        elif c == ':' and (i + 1 == len(text) or text[i + 1].isspace()):
            if word: rule.append(word); word = ''
            rule.append(None)
        elif c.isspace():
            if word: rule.append(word); word = ''
        else:
            word += c
        i += 1
    if word: rule.append(word)
    if rule: rules.append(rule)
    result = set()
    if not rules:
        raise ValueError(at + ': empty compiler dependency record')
    for n, rule in enumerate(rules):
        if rule.count(None) != 1 or rule.index(None) == 0:
            raise ValueError(at + '.rule[' + str(n) + ']: unread dependency rule')
        result.update(rule[rule.index(None) + 1:])
    return result


def actual_path(root, value):
    path = Path(value)
    return (path if path.is_absolute() else root / path).resolve()


def target_closure(description, roots):
    index = {t['name']: t for t in description['targets']}
    result, active = {}, set()
    def visit(name):
        at = 'Package.swift: target.' + name
        if name in result: return
        if name in active: raise ValueError(at + ': target dependency cycle')
        if name not in index: raise ValueError(at + ': external target is unread')
        target = index[name]
        if not {'module_type', 'c99name', 'path', 'sources'} <= target.keys():
            raise ValueError(at + ': target description is unread')
        if target.get('module_type') != 'SwiftTarget' or target.get('product_dependencies'):
            raise ValueError(at + ': unsupported target dependency form')
        active.add(name)
        for dependency in target.get('target_dependencies', []): visit(dependency)
        active.remove(name)
        result[name] = dict(name=name, path=relative(target['path'], at),
                            module=target['c99name'],
                            sources=sorted(target['sources']),
                            dependencies=sorted(target.get('target_dependencies', [])))
    for root in roots: visit(root)
    return [result[name] for name in sorted(result)]


def snapshot(root, modules):
    root, modules = root.resolve(), modules.resolve()
    declared = declaration(root)
    graph = target_closure(json.loads(subprocess.check_output(
        ['swift', 'package', 'describe', '--type', 'json'], cwd=root)), declared['targets'])
    project = {'Package.swift', 'Package.resolved', MANIFEST,
               'Checks/' + Path(__file__).name, *declared['law_inputs'], *declared['fixtures']}
    for target in graph:
        for source in target['sources']:
            project.add(relative(target['path'] + '/' + source, 'Package.swift: ' + target['name']))
    files, paths = {}, {}
    def include(path, name):
        path = path.resolve()
        files[name] = files[paths[str(path)]] if str(path) in paths else digest(path.read_bytes())
        paths[str(path)] = name
    for name in sorted(project):
        path = (root / name).resolve()
        if root not in path.parents: raise ValueError(name + ': source leaves the package')
        include(path, name)
    info = json.loads(subprocess.check_output(['swiftc', '-print-target-info'], cwd=root))
    version = subprocess.check_output(['swiftc', '--version'], cwd=root, stderr=subprocess.STDOUT).decode()
    launcher = Path(shutil.which('swiftc') or 'swiftc')
    driver = Path(subprocess.check_output(['xcrun', '--find', 'swiftc'], text=True).strip()) if sys.platform == 'darwin' else launcher
    include(launcher, 'compiler:launcher')
    include(driver, 'compiler:driver')
    frontend = driver.parent / ('swift-frontend.exe' if os.name == 'nt' else 'swift-frontend')
    include(frontend, 'compiler:frontend')
    anchors = {}
    for name, field in [('sdk', 'sdkPath'), ('resource', 'runtimeResourcePath')]:
        if info['paths'].get(field): anchors[name] = Path(info['paths'][field]).resolve()
    if sys.platform == 'darwin' and 'sdk' not in anchors:
        anchors['sdk'] = Path(subprocess.check_output(['xcrun', '--show-sdk-path'], text=True).strip()).resolve()
    for target in graph: include(modules / (target['module'] + '.swiftmodule'), 'module:' + target['name'])
    build = json.loads((modules.parent / 'description.json').read_text(encoding='utf-8'))['swiftCommands']
    module_records = []
    for target in graph:
        at = 'Package.swift: target.' + target['name']
        output = modules / (target['module'] + '.swiftmodule')
        commands = [v for v in build.values() if actual_path(root, v['moduleOutputPath']) == output]
        if len(commands) != 1: raise ValueError(at + ': no unique prepared compiler command')
        command = commands[0]
        if 'executable' in command and Path(command['executable']).resolve() != driver.resolve():
            raise ValueError(at + '.compiler: prepared module used a different compiler')
        sources = {str((root / target['path'] / s).resolve()) for s in target['sources']}
        # Compare the compiler's sources by their actual paths: a root reached
        # through a symbolic link (/tmp, /var) names the same files.
        prepared = {str(actual_path(root, s)) for s in command['sources']}
        if prepared != sources:
            extra = sorted(prepared - sources)
            raise ValueError(at + '.sources: unannounced compiler input ' + str(extra or 'missing source'))
        mapping = Path(command['outputFileMapPath'])
        if modules.parent not in mapping.resolve().parents:
            raise ValueError(at + '.output-file-map: map leaves the prepared build')
        outputs = json.loads(mapping.read_text(encoding='utf-8'))
        depfiles = []
        for source, entries in outputs.items():
            if not source: continue
            if str(actual_path(root, source)) not in sources:
                raise ValueError(at + '.output-file-map: unannounced compiler input ' + source)
            if 'dependencies' not in entries:
                raise ValueError(at + '.output-file-map: missing compiler dependencies for ' + source)
            dependency = Path(entries['dependencies']).resolve()
            if dependency.parent != mapping.parent.resolve() or dependency.suffix != '.d':
                raise ValueError(at + '.output-file-map: dependency record leaves its build target')
            depfiles.append(dependency)
        depfiles.append(mapping.parent / (target['module'] + '.emit-module.d'))
        for depfile in depfiles:
            text = depfile.read_bytes().decode('utf-8'); address = at + '.dependencies.' + depfile.name
            observed = sorted(make_dependencies(text, address))
            for value in observed:
                path = actual_path(root, value)
                if str(path) in paths: continue
                if root == path or root in path.parents:
                    raise ValueError(address + ': unannounced compiler input ' + str(path.relative_to(root)))
                matches = [(name, anchor) for name, anchor in anchors.items() if anchor in path.parents]
                if not matches: raise ValueError(address + ': compiler input outside declared toolchain: ' + str(path))
                name, anchor = max(matches, key=lambda pair: len(pair[1].parts))
                include(path, 'compiler:' + name + '/' + path.relative_to(anchor).as_posix())
            module_records.append(dict(at=address, make=text, inputs=observed))
    core = dict(schema='vi.verdict-key/2', graph=graph, files=files, compiler_version=version,
                compiler_target=info)
    return dict(key=digest(encoded(core)), core=core, paths=paths, modules=str(modules),
                module_compilations=module_records)


def capture_command(command, directory, label):
    folder = directory / digest(label.encode())
    folder.mkdir()
    sources = [arg for arg in command[1:] if arg.endswith('.swift')]
    if not sources: raise ValueError(label + ': no compiler source input')
    mapping = {'': {'dependencies': str(folder / 'whole.d')}}
    for n, source in enumerate(sources): mapping[source] = {'dependencies': str(folder / (str(n) + '.d'))}
    write_json(folder / 'outputs.json', mapping)
    return [*command, '-emit-dependencies', '-disable-only-one-dependency-file',
            '-output-file-map', str(folder / 'outputs.json')], folder


def finish_capture(root, folder, label, command, status):
    depfiles = sorted(folder.glob('*.d'))
    if not depfiles: raise ValueError(label + ': compiler wrote no dependency record')
    dependencies = set(); makes = []
    for depfile in depfiles:
        text = depfile.read_bytes().decode('utf-8')
        dependencies.update(str(actual_path(root, p)) for p in make_dependencies(text, label + '.' + depfile.name))
        makes.append(dict(name=depfile.name, text=text, sha256=digest(text.encode())))
    explicit = {str(actual_path(root, p)) for p in command[1:] if p.endswith('.swift')}
    if not explicit <= dependencies: raise ValueError(label + ': dependency record omits an explicit compiler input')
    record = dict(label=label, root=str(root.resolve()), command=command,
                  status=status, dependencies=sorted(dependencies), make=makes)
    write_json(folder / 'record.json', record)
    return record


def covered(start, record):
    label = record['label']
    expected = 1 if label.startswith('mutation:') else 0
    if record['status'] != expected:
        raise ValueError('verdict receipt: ' + label + ': unexpected compiler status')
    parsed = set()
    for make in record['make']:
        if digest(make['text'].encode()) != make['sha256']:
            raise ValueError('verdict receipt: ' + label + ': changed dependency bytes')
        # Dependency records carry their compilation working directory.
        parsed.update(str(actual_path(Path(record['root']), p)) for p in make_dependencies(make['text'], label))
    if parsed != set(record['dependencies']):
        raise ValueError('verdict receipt: ' + label + ': dependency addresses differ from compiler bytes')
    for n, path in enumerate(record['dependencies']):
        if path not in start['paths'] or start['paths'][path] not in start['core']['files']:
            raise ValueError('verdict receipt: ' + record['label'] + '.dependencies[' + str(n)
                             + ']: unannounced compiler input ' + path)


def audit_records(start, directory):
    summary = json.loads((directory / 'completed.json').read_text(encoding='utf-8'))
    rows = [json.loads(f.read_text(encoding='utf-8')) for f in sorted(directory.glob('*/record.json'))]
    expected = {'global-positive', *summary['labels']}
    if {r['label'] for r in rows} != expected or len(rows) != len(expected):
        raise ValueError('verdict receipt: compilations: incomplete compiler input coverage')
    for row in rows: covered(start, row)
    return rows, summary


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action', required=True)
    sub.add_parser('fixtures')
    p = sub.add_parser('snapshot'); p.add_argument('--modules', type=Path, required=True); p.add_argument('--output', type=Path, required=True)
    for action in ('hit', 'seal'):
        p = sub.add_parser(action); p.add_argument('--snapshot', type=Path, required=True); p.add_argument('--receipt', type=Path, required=True)
        if action == 'seal': p.add_argument('--audit', type=Path, required=True)
    p = sub.add_parser('compile'); p.add_argument('--audit', type=Path, required=True); p.add_argument('--snapshot', type=Path, required=True); p.add_argument('--label', required=True); p.add_argument('command', nargs=argparse.REMAINDER)
    args = parser.parse_args(); root = Path(__file__).resolve().parent.parent
    try:
        if args.action == 'fixtures':
            print('\n'.join(fixture_paths(root))); return 0
        if args.action == 'snapshot':
            value = snapshot(root, args.modules); write_json(args.output, value); print(value['key']); return 0
        if args.action == 'compile':
            command = args.command[1:] if args.command[:1] == ['--'] else args.command
            tracked, folder = capture_command(command, args.audit, args.label)
            done = subprocess.run(tracked)
            row = finish_capture(root, folder, args.label, tracked, done.returncode)
            covered(json.loads(args.snapshot.read_text(encoding='utf-8')), row)
            return done.returncode
        start = json.loads(args.snapshot.read_text(encoding='utf-8'))
        if args.action == 'hit':
            if not args.receipt.exists(): return 3
            saved = json.loads(args.receipt.read_text(encoding='utf-8'))
            if saved['schema'] != 'vi.verdict-receipt/2' or saved['key'] != start['key']: return 3
            rows = saved['compilations']; expected = {'global-positive', *saved['completed']['labels']}
            if len(expected) < 3 or len(rows) != len(expected) or {r['label'] for r in rows} != expected:
                raise ValueError(str(args.receipt) + ': incomplete compiler input coverage')
            for row in rows: covered(start, row)
            print('verdict: declared target closure and recorded compiler inputs are unchanged since '
                  + str(args.receipt) + '; not run again here. CI runs it in full, and VERDICT_FULL=1 runs it here.')
            return 0
        rows, completed = audit_records(start, args.audit)
        current = snapshot(root, Path(start['modules']))
        if current['key'] != start['key']:
            print('verdict: declared compiler inputs changed while it ran; no receipt is written')
            return 0
        value = dict(schema='vi.verdict-receipt/2', key=start['key'], inputs=start,
                     compilations=rows, completed=completed,
                     created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat())
        args.receipt.parent.mkdir(parents=True, exist_ok=True)
        temporary = args.receipt.with_suffix('.tmp'); write_json(temporary, value); temporary.replace(args.receipt)
        print('verdict: receipt records ' + str(len(rows)) + ' compiler calls; every observed input is declared')
        return 0
    except (OSError, ValueError, KeyError, TypeError, subprocess.CalledProcessError) as error:
        print('verdict receipt: ' + str(error), file=sys.stderr)
        return 1


if __name__ == '__main__': sys.exit(main())
