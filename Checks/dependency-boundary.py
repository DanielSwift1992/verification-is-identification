#!/usr/bin/env python3
"""Apply the owner boundary law to this repository's declared policy."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
CONFIG = 'Checks/dependency-boundary.json'
POLICY_SHA256 = 'e094ac00782181b91d7cdc5db9f005b1c4f392dca748bc1b33dbb30963588f05'
LAW = ROOT / 'Checks/boundary-law.py'
exec(compile(LAW.read_bytes(), str(LAW), 'exec'), globals())

if __name__ == '__main__':
    sys.exit(run())
