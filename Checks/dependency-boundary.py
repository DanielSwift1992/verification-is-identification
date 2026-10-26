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
# T0109 removes one obsolete Foundation-only comment; scopes and exceptions stay fixed.
POLICY_SHA256 = 'eb59bd0adab691fc56823cefefefeeb072f58c6a08496a88e9628521482db84b'
LAW = ROOT / 'Checks/boundary-law.py'
exec(compile(LAW.read_bytes(), str(LAW), 'exec'), globals())

if __name__ == '__main__':
    sys.exit(run())
