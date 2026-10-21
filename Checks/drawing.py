#!/usr/bin/env python3
"""Compile each generic Drawing request natively and compare its exact readout."""
import hashlib
import json
import re
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path
ROOT = Path(__file__).resolve().parent.parent
CONTRACT = ROOT / 'Contracts/Drawing/v0.1'
def sha(data): return hashlib.sha256(data).hexdigest()
def run(args, seconds, **kwargs):
    return subprocess.run(args, capture_output=True, timeout=seconds, **kwargs)
def input_bytes(request, base):
    return b''.join(p.encode() + b'\0' + (base / p).read_bytes() + b'\0' for p in request['sources'])
def read(request, binary, base=ROOT):
    address = request['address']
    if request.get('status') == 'not-compared':
        result = {'status': 'not-compared', 'address': address, 'reason': request['reason']}
        if request.get('sources'):
            result['inputSHA256'] = sha(input_bytes(request, base))
        return result
    root = request['root']
    if not re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*', root):
        raise ValueError('root must name a declared Swift type')
    result = {'address': address, 'inputSHA256': sha(input_bytes(request, base))}
    dependencies = request.get('dependencies', ['Notation', 'Alphabet', 'DocumentKit'])
    with tempfile.TemporaryDirectory(prefix='drawing-') as directory:
        tmp = Path(directory)
        main = tmp / 'main.swift'
        imports = ['Notation', 'DocumentKit']
        if request.get('target'):
            imports.append(request['target'])
        read_root = request['target'] + '.' + root if request.get('target') else root
        main.write_text(''.join('import ' + module + '\n' for module in imports)
                        + 'print(' + read_root + '.typeName, terminator: "")\n')
        executable = tmp / 'read'
        try:
            # The library target itself is compiled by SwiftPM, including all its
            # declared files and settings. Only an external request compiles raw files.
            modules = [request['target']] if request.get('target') else [
                m for m in dependencies if m not in ['Notation', 'Alphabet', 'DocumentKit']]
            for module in modules:
                prepared = run(['swift', 'build', '--target', module], request.get('compileSeconds', 120), cwd=ROOT)
                if prepared.returncode:
                    return dict(result, status='failed', reason='compile',
                                diagnostic=(prepared.stderr + prepared.stdout).decode(errors='replace'))
            objects = [str(p) for module in dependencies for p in sorted((binary / (module + '.build')).glob('*.o'))]
            if any(not list((binary / (module + '.build')).glob('*.o')) for module in dependencies):
                return dict(result, status='failed', reason='missing-object-module')
            sources = [] if request.get('target') else [str(base / p) for p in request['sources']]
            compiled = run(['swiftc', '-I', str(binary / 'Modules'),
                            '-module-cache-path', str(tmp / 'modules'),
                            *sources, str(main), *objects,
                            '-o', str(executable)], request.get('compileSeconds', 120))
            if compiled.returncode:
                return dict(result, status='failed', reason='compile', diagnostic=compiled.stderr.decode(errors='replace'))
            readout = run([str(executable)], request.get('readSeconds', 20))
        except subprocess.TimeoutExpired:
            return dict(result, status='failed', reason='budget')
        if readout.returncode:
            diagnostic = readout.stderr.decode(errors='replace')
            # A killed/crashed process alone is not a semantic refusal. These are
            # the owner's named preconditions; other failures remain red errors.
            for message, code in [('Half of an odd magnitude:', 'half-odd'),
                                  ('Rest underflow:', 'rest-underflow'),
                                  ('Wrapped overflow in ', 'text-overflow'),
                                  ('Fitted overflow in ', 'text-overflow')]:
                if message in diagnostic:
                    return dict(result, status='refused', code=code)
            return dict(result, status='failed', reason='runtime', diagnostic=diagnostic)
        try:
            xml = ET.fromstring(readout.stdout)
            if xml.tag != '{http://www.w3.org/2000/svg}svg':
                raise ValueError('root is not SVG')
        except (ET.ParseError, ValueError) as error:
            return dict(result, status='failed', reason='xml', diagnostic=str(error))
        return dict(result, status='svg', svgSHA256=sha(readout.stdout), svg=readout.stdout.decode())


def main():
    subprocess.run(['swift', 'build', '--target', 'DocumentKit'], cwd=ROOT, check=True)
    binary = Path(subprocess.check_output(['swift', 'build', '--show-bin-path'], cwd=ROOT, text=True).strip())
    requests = json.loads((CONTRACT / 'requests.json').read_text())
    assert len(requests) == 11 and len({r['id'] for r in requests}) == 11, 'incomplete generic Drawing suite'
    svg = refused = 0
    for request in requests:
        result = read(request, binary)
        address = request['address']
        assert result['status'] == request.get('expect', 'svg'), (address, result)
        if result['status'] == 'svg':
            expected = (CONTRACT / 'cases' / (request['id'] + '.svg')).read_bytes()
            assert result['svg'].encode() == expected, (address, 'SVG bytes differ')
            ET.fromstring(expected)
            svg += 1
        else:
            code = 'rest-underflow' if request['id'] == 'row-underflow' else request['id']
            assert result['code'] == code, (address, result)
            refused += 1
        print(address + ': ' + result['status'])
    assert (svg, refused) == (7, 4)
    print('Drawing: 7 exact SVG readouts; 4 addressed native refusals')
if __name__ == '__main__': main()
