#!/usr/bin/env python3
"""Keep world style data outside the mechanism and exercise the native binding boundary."""
import importlib.util
import json
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('binding', ROOT / 'Scripts/drawing-binding.py')
binding = importlib.util.module_from_spec(spec)
spec.loader.exec_module(binding)


def mechanism(sources):
    for path, text in sources.items():
        closed=set(re.findall(r'\benum\s+(\w+)\s*:[^{}]*\{\}',text))
        for atom in re.finditer(r'extension\s+(\w+)\s*\{(.*?)\n\}',text,re.S):
            if atom[1] in closed and re.search(r'\b(?:Lit|Veiled|XYZWrite|XYZRatioWrite)\s*<',atom[2]):
                raise ValueError(path+':'+str(text[:atom.start()].count('\n')+1)+': concrete colour walk belongs to a world')
        for alias in re.finditer(r'typealias\s+(\w+)\s*=\s*(?:Lit|Veiled|XYZWrite|XYZRatioWrite)\s*<',text):
            if alias[1] not in ['White','Black']:
                raise ValueError(path+':'+str(text[:alias.start()].count('\n')+1)+': concrete colour alias belongs to a world')
        for face in re.finditer(r'enum\s+(\w*(?:Face|Font|Typeface)\w*)\s*:[^{}]*\{\}\s*extension[^{}]*\{[^{}]*var typeName:[^{}]*\{\s*"([^"]+)"',text):
            if re.search('[A-Za-z]',face[2]):
                raise ValueError(path+':'+str(text[:face.start()].count('\n')+1)+': concrete face belongs to a world')
        for number, line in enumerate(text.splitlines(), 1):
            code = '' if line.lstrip().startswith('//') else line
            if re.search(r'#[A-Fa-f0-9]{3}(?:[A-Fa-f0-9]{3})?\b|(?:rgba?|color)\(\s*[0-9.]', code):
                raise ValueError(path + ':' + str(number) + ': world colour in drawing mechanism')
            if re.search(r'\b(?:Inter|Roboto|DejaVu|system-ui|sans-serif)\b', code):
                raise ValueError(path + ':' + str(number) + ': world face in drawing mechanism')
            if 'font-family=' in code and 'Binding.' not in code:
                raise ValueError(path + ':' + str(number) + ': literal face in drawing mechanism')
            if re.search(r'enum\s+\w+\s*:\s*Paint\s*,', code):
                raise ValueError(path + ':' + str(number) + ': concrete paint belongs to a world')


def main():
    sources = {str(p.relative_to(ROOT)):p.read_text() for p in (ROOT / 'Sources/DocumentKit').glob('*.swift')}
    sources['Sources/DocumentKit/Resources/footer.html'] = (ROOT / 'Sources/DocumentKit/Resources/footer.html').read_text()
    mechanism(sources)
    for line in ['public enum Stowaway: Paint, Close {}', 'let paint = "#123ABC"', 'let face = "Inter"', 'let svg = "font-family=SecretTypeface"', 'enum NewFace: Close {} extension NewFace { static var typeName: String { "Avenir" } }', 'typealias SecretTone = Lit<Quenched, Undimmed, Quenched>', 'let svg = \"<svg xmlns=\\\"http://example.test\\\" fill=\\\"#123456\\\"/>\"']:
        try: mechanism({'Sources/DocumentKit/negative.swift':line})
        except ValueError as e: assert 'negative.swift:1:' in str(e)
        else: raise AssertionError('mechanism admitted ' + line)
    fixture = ROOT / 'Contracts/Drawing/v0.1/binding.json'
    value = binding.read(fixture)
    assert (ROOT / 'Contracts/Drawing/v0.1/Binding.swift').read_text() == binding.swift(value), str(fixture) + ': stale Swift binding'
    binary = Path(subprocess.check_output(['swift','build','--show-bin-path'],cwd=ROOT,text=True).strip())
    with tempfile.TemporaryDirectory(prefix='vi-binding-control-') as directory:
        temp = Path(directory)
        source = (ROOT / 'Contracts/Drawing/v0.1/cases/half-even.swift').read_text()
        source = source.replace('    public typealias Binding = FixtureBinding\n','')
        file = temp / 'MissingBinding.swift';file.write_text(source)
        p = subprocess.run(['swiftc','-typecheck','-I',str(binary/'Modules'),'-module-cache-path',str(temp/'modules'),str(file)],capture_output=True)
        assert p.returncode and b'MissingBinding.swift:' in p.stderr and b'Binding' in p.stderr, p.stderr.decode()
    print('drawing binding: no owner paint or face in mechanism; colour/face/paint controls refuse; native missing Binding refuses at source')

if __name__ == '__main__': main()
