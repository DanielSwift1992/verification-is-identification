#!/usr/bin/env python3
"""Apply the owner boundary law to this repository's declared policy."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
CONFIG = 'Checks/dependency-boundary.json'
# T0105 merges the published SDK ledger with scalar-name reading.
# The retired Press producer reference is removed; T0105 names its open debt.
# Vocabulary, scope and retirement limits are unchanged.
POLICY_SHA256 = '388b0d341bda5a8140756b05c419d4daa73164e8e53856fbb47e308e06a5e322'
LAW = ROOT / 'Checks/boundary-law.py'
exec(compile(LAW.read_bytes(), str(LAW), 'exec'), globals())

if __name__ == '__main__':
    sys.exit(run())
