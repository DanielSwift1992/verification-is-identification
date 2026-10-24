#!/usr/bin/env python3
"""Apply the owner boundary law to this repository's declared policy."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
CONFIG = 'Checks/dependency-boundary.json'
# 2026-10-24 merge review retains 303 declaration records and zero exceptions.
# T0095 adds its local open-debt destination; two Encoding sentence contexts change.
# Scope, vocabulary, probe classes and retirement limits remain unchanged.
# T0083 removes the obsolete Press header reference; no consumer debt is restored.
POLICY_SHA256 = 'bca3c57377ceaf8a216cdf6a98b3556dfaad6c1232d0bceb9754555061ad78e1'
LAW = ROOT / 'Checks/boundary-law.py'
exec(compile(LAW.read_bytes(), str(LAW), 'exec'), globals())

if __name__ == '__main__':
    sys.exit(run())
