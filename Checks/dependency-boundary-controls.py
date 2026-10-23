#!/usr/bin/env python3
"""Exercise the owner law against this repository's boundary policy."""
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
specification = importlib.util.spec_from_file_location('boundary', ROOT / 'Checks/dependency-boundary.py')
law = importlib.util.module_from_spec(specification)
specification.loader.exec_module(law)
exec(compile((ROOT / 'Checks/boundary-controls.py').read_bytes(), 'boundary-controls.py', 'exec'), globals())

if __name__ == '__main__':
    controls(law)
