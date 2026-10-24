#!/usr/bin/env python3
"""Apply the owner boundary law to this repository's declared policy."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
CONFIG = 'Checks/dependency-boundary.json'
# 2026-10-24 merge review retains 304 declaration records and zero exceptions.
# T0095 adds its local open-debt destination; two Encoding sentence contexts change.
# Scope, vocabulary, probe classes and retirement limits remain unchanged.
POLICY_SHA256 = 'acff0e5a792c3279d68ec827dffd761806dcb5c0d035d82cff5112b87ac52011'
LAW = ROOT / 'Checks/boundary-law.py'
exec(compile(LAW.read_bytes(), str(LAW), 'exec'), globals())

if __name__ == '__main__':
    sys.exit(run())
