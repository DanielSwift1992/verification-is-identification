"""
§2 Primitives — Peano encoding and structural equality.

NULL  = boundary (0)
PAIR  = distinction (nested tuple)
compare(a, b) = structural equality

These are domain-agnostic. They define HOW data is represented,
not WHAT data represents.
"""

NULL = 0

def peano(n):
    if n == 0: return NULL
    return (peano(n - 1), NULL)

def from_peano(p):
    n = 0
    while p != NULL: p, n = p[0], n + 1
    return n

def compare(a, b):
    return a == b
