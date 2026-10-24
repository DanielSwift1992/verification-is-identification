#!/usr/bin/env python3
"""Apply the owner boundary law to this repository's declared policy."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
CONFIG = 'Checks/dependency-boundary.json'
POLICY_SHA256 = '7ab4ac6caf18950bee221fc3e58bc98a6e799a126ba3dac8476185274e4d32e7'
LAW = ROOT / 'Checks/boundary-law.py'
exec(compile(LAW.read_bytes(), str(LAW), 'exec'), globals())

if __name__ == '__main__':
    sys.exit(run())
