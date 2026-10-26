#!/usr/bin/env python3
"""Apply the owner boundary law to this repository's declared policy."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
CONFIG = 'Checks/dependency-boundary.json'
# T0105 merges the published SDK ledger with scalar-name reading.
# The retired Press producer reference is removed; T0105 names its open debt.
# T0109 removes one obsolete Foundation-only comment; scopes and exceptions stay fixed.
# Vocabulary, scope and retirement limits are unchanged.
POLICY_SHA256 = '2211429c4ad36abe9d1114ed044d3e6309552f7b3a7cd45a33ec404d18dd7ee4'
LAW = ROOT / 'Checks/boundary-law.py'
exec(compile(LAW.read_bytes(), str(LAW), 'exec'), globals())

if __name__ == '__main__':
    sys.exit(run())
