#!/usr/bin/env python3
"""Regenerate the kit's projections in scratch, leaving the source tree unchanged."""
import argparse
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser()
parser.add_argument('--write', action='store_true', help='replace the declared generated projections')
args = parser.parse_args()
for product in ['DocumentKitDemo', 'FontMetrics']:
    subprocess.run(['swift', 'build', '--product', product], cwd=ROOT, check=True)
binary = Path(subprocess.check_output(['swift', 'build', '--show-bin-path'], cwd=ROOT, text=True).strip())
catalog = Path('Sources/DocumentKitDemo/DocumentKitDemo.docc')
pages = ['DocumentKitDemo', 'SelfShowingExampleSource', 'VectorTourStationA', 'VectorTourStationB', 'CoveredVisibleClaim']
svgs = ['vector-canvas-example', 'vector-hover-example', 'vector-selfshowing-example',
        'vector-tour-station-a', 'vector-tour-station-b', 'roles-plate', 'roles-plate~dark']
outputs = [catalog / (n + '.md') for n in pages] + [catalog / 'Resources' / (n + '.svg') for n in svgs]
outputs += [Path('Worlds/Documentation/GeneratedFontMetrics.swift')]
with tempfile.TemporaryDirectory(prefix='vi-kit-artifacts-') as temp:
    root = Path(temp)
    (root / catalog / 'Resources').mkdir(parents=True)
    (root / 'Assets').mkdir()
    (root / 'Worlds/Documentation').mkdir(parents=True)
    shutil.copyfile(ROOT / 'Assets/InterVariable.ttf', root / 'Assets/InterVariable.ttf')
    for command in [[str(binary / 'DocumentKitDemo'), 'render-doc'],
                    [str(binary / 'DocumentKitDemo'), 'claim', '--write'],
                    [str(binary / 'FontMetrics')]]:
        subprocess.run(command, cwd=root, check=True)
    for path in outputs:
        expected = (root / path).read_bytes()
        if args.write:
            (ROOT / path).write_bytes(expected)
        else:
            assert (ROOT / path).read_bytes() == expected, str(path) + ': stale; run python3 Checks/documentkit-artifacts.py --write'
print('DocumentKit: 13 generated projections reproduce their bytes')
