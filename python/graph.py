"""
§2.3 Graph G — append-only comparison cache (I3).

COMPARE results are permanent; G_n ⊆ G_{n+1} (§5.18).
"""

from primitives import compare as _compare_raw


class ComparisonGraph:
    """I3: append-only set of (atom, atom) → equal | not_equal."""

    __slots__ = ("_g", "_hits", "_misses")

    def __init__(self):
        self._g = {}
        self._hits = 0
        self._misses = 0

    def compare(self, a, b):
        k = (a, b) if id(a) <= id(b) else (b, a)
        if k in self._g:
            self._hits += 1
            return self._g[k]
        self._misses += 1
        result = _compare_raw(a, b)
        self._g[k] = result
        return result

    def __len__(self):
        return len(self._g)

    @property
    def hits(self):
        return self._hits

    @property
    def misses(self):
        return self._misses
