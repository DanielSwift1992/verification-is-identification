"""
Paper 6 (Distance Is Cost) — derived metric on Sigma.

W(s, t) = |D(s) symmetric-difference D(t)| : the minimal number of
single-distinction changes transforming s into t (Theorem G2).

NULL = 0, PAIR = nested tuple (primitives.py conventions).

Self-test: python delta.py
  G1  D is a bijection (reconstruction round-trip)
  G2  W(recursion) == |D(s) ^ D(t)| == BFS shortest path over
      single-distinction adjacency (exhaustive on small universe)
  G2b metric axioms incl. triangle inequality (random triples)
  G4a overlap identity |D(s) & D(t)| = (|s| + |t| - W) / 2
  G5  d_k pseudometric family: monotone in k, converges to W
  G6  Peano: W(peano(n), peano(m)) = |n - m|
  G7  cells: W = |dr| + |dc| + |dv| (taxicab)
"""

import random
from collections import deque
from primitives import NULL, peano, compare


# --- G1: the set of distinctions -------------------------------------------

def is_pair(t):
    return isinstance(t, tuple)

def D(t, prefix=()):
    """Addresses of PAIR nodes: the distinctions constituting t."""
    if not is_pair(t):
        return set()
    out = {prefix}
    out |= D(t[0], prefix + ('L',))
    out |= D(t[1], prefix + ('R',))
    return out

def reconstruct(addresses):
    """Inverse of D on finite prefix-closed address sets."""
    def build(prefix):
        if prefix not in addresses:
            return NULL
        return (build(prefix + ('L',)), build(prefix + ('R',)))
    return build(())

def norm(t):
    """|D(t)| = W(t, NULL): the form's count of maintained distinctions."""
    if not is_pair(t):
        return 0
    return 1 + norm(t[0]) + norm(t[1])


# --- G2: the metric ---------------------------------------------------------

def W(s, t):
    """One simultaneous traversal (G2a). W(s,t) = |D(s) ^ D(t)|."""
    if not is_pair(s) and not is_pair(t):
        return 0
    if not is_pair(s):
        return norm(t)
    if not is_pair(t):
        return norm(s)
    return W(s[0], t[0]) + W(s[1], t[1])


# --- G4a: invariant of a pair ----------------------------------------------

def overlap(s, t):
    """|D(s) & D(t)| = (norm(s) + norm(t) - W(s,t)) / 2."""
    return (norm(s) + norm(t) - W(s, t)) // 2


# --- G5: resolution family --------------------------------------------------

def d_k(s, t, k):
    """Distance visible at depth k: |D_k(s) ^ D_k(t)|, D_k = addresses < k."""
    if k <= 0:
        return 0
    if not is_pair(s) and not is_pair(t):
        return 0
    if not is_pair(s):
        return norm_k(t, k)
    if not is_pair(t):
        return norm_k(s, k)
    return d_k(s[0], t[0], k - 1) + d_k(s[1], t[1], k - 1)

def norm_k(t, k):
    if k <= 0 or not is_pair(t):
        return 0
    return 1 + norm_k(t[0], k - 1) + norm_k(t[1], k - 1)


# --- adjacency (for machine verification of G2) -----------------------------

def neighbors(t):
    """Trees at W = 1: grow one NULL leaf, or shrink one childless PAIR."""
    out = []
    if not is_pair(t):
        return [(NULL, NULL)]                       # grow the root
    a, b = t
    if a == NULL and b == NULL:
        out.append(NULL)                            # shrink this PAIR
    out += [(x, b) for x in neighbors(a)]
    out += [(a, y) for y in neighbors(b)]
    return out


def all_trees(max_pairs):
    """All of Sigma with norm <= max_pairs (Catalan-sized universe)."""
    by_size = {0: [NULL]}
    for n in range(1, max_pairs + 1):
        acc = []
        for i in range(n):
            for a in by_size[i]:
                for b in by_size[n - 1 - i]:
                    acc.append((a, b))
        by_size[n] = acc
    return [t for n in range(max_pairs + 1) for t in by_size[n]]


def bfs_distance(s, t, max_pairs):
    """Shortest path in the adjacency graph, staying within the universe."""
    if s == t:
        return 0
    seen, frontier, dist = {s}, deque([(s, 0)]), None
    while frontier:
        cur, d = frontier.popleft()
        for nb in neighbors(cur):
            if norm(nb) > max_pairs or nb in seen:
                continue
            if nb == t:
                return d + 1
            seen.add(nb)
            frontier.append((nb, d + 1))
    raise RuntimeError("disconnected (should be impossible)")


# --- random trees ------------------------------------------------------------

def random_tree(max_depth, p=0.6, rng=random):
    if max_depth == 0 or rng.random() > p:
        return NULL
    return (random_tree(max_depth - 1, p, rng),
            random_tree(max_depth - 1, p, rng))


# --- cells (representation.py conventions) -----------------------------------

def cell(r, c, v):
    return ((peano(r), peano(c)), peano(v))


# --- self-test ----------------------------------------------------------------

if __name__ == '__main__':
    rng = random.Random(3)
    checks = []

    def check(name, ok):
        checks.append((name, ok))
        print(f"  {'✓' if ok else '✗'}  {name}")

    # G1: bijection round-trip
    trees = [random_tree(5, rng=rng) for _ in range(300)]
    check("G1  reconstruct(D(t)) == t",
          all(reconstruct(D(t)) == t for t in trees))

    # G2: recursion == set symmetric difference
    pairs = [(random_tree(5, rng=rng), random_tree(5, rng=rng))
             for _ in range(300)]
    check("G2a W(s,t) == |D(s) ^ D(t)|",
          all(W(s, t) == len(D(s) ^ D(t)) for s, t in pairs))

    # G2: exhaustive machine verification against BFS on the full
    # universe of trees with <= 4 distinctions (23 trees, 253 pairs)
    U = all_trees(4)
    ok = all(W(s, t) == bfs_distance(s, t, max_pairs=8)
             for i, s in enumerate(U) for t in U[i + 1:])
    check(f"G2  W == BFS geodesic, exhaustive |U|={len(U)}", ok)

    # G2b: metric axioms
    check("G2b W(t,t) == 0 and W=0 -> s==t",
          all(W(t, t) == 0 for t in trees) and
          all((W(s, t) > 0) == (s != t) for s, t in pairs))
    check("G2b symmetry", all(W(s, t) == W(t, s) for s, t in pairs))
    triples = [tuple(random_tree(4, rng=rng) for _ in range(3))
               for _ in range(500)]
    check("G2b triangle inequality",
          all(W(a, c) <= W(a, b) + W(b, c) for a, b, c in triples))

    # zero test = COMPARE
    check("G4  (W == 0) == compare(s,t)",
          all((W(s, t) == 0) == compare(s, t) for s, t in pairs))

    # G4a: overlap identity
    check("G4a |D&D| == (|s|+|t|-W)/2",
          all(len(D(s) & D(t)) == overlap(s, t) for s, t in pairs))

    # G5: resolution family
    ok = True
    for s, t in pairs[:100]:
        prev = 0
        for k in range(0, 8):
            cur = d_k(s, t, k)
            if cur < prev:
                ok = False
            prev = cur
        if prev != W(s, t):
            ok = False
    check("G5  d_k monotone in k, d_inf == W", ok)

    # G6: Peano recovers arithmetic distance
    check("G6  W(peano(n), peano(m)) == |n-m|",
          all(W(peano(n), peano(m)) == abs(n - m)
              for n in range(12) for m in range(12)))

    # G7: cells recover taxicab geometry
    cells = [(r, c, v) for r in range(4) for c in range(4) for v in range(4)]
    check("G7  W(cells) == |dr|+|dc|+|dv| (taxicab)",
          all(W(cell(*a), cell(*b)) ==
              abs(a[0]-b[0]) + abs(a[1]-b[1]) + abs(a[2]-b[2])
              for a in cells for b in cells))

    n_ok = sum(1 for _, ok in checks if ok)
    print(f"\n  {n_ok}/{len(checks)} verified")
    if n_ok != len(checks):
        raise SystemExit(1)
