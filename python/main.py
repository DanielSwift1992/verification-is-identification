"""
Verification Is Identification — reference implementation.

Pipeline (§5.5): ENCODE → VALIDATE → EXTRACT → COMPILE → EXECUTE.
R4 check (§3.6): |S| in F (full feature space).

Run: python main.py
"""

from graph import ComparisonGraph
from vi_core import corpus_metrics, identify_task, write_manifest


if __name__ == '__main__':
    from tasks import TASKS

    graph = ComparisonGraph()
    records = []
    for name, task in TASKS:
        r = identify_task(name, task, graph)
        records.append(r)
        tag = "✓" if r.get("theorem2") else "✗"
        sat = r.get("saturation")
        sat_s = f"  sat={sat:.2%}" if sat is not None else ""
        print(f"  {tag}  {name:20s}  f*={str(r.get('f_star', '-')):<12s}"
              f"  |S|={r.get('S', '?')}/{r.get('F', '?')}{sat_s}")

    manifest = write_manifest(records, graph=graph)
    c = corpus_metrics(records)
    print(f"\n  Theorem 2: {c['theorem2']}/{c['n']}  coverage: {c['coverage']:.0%}")
    print(f"  I3 cache: {len(graph)} pairs ({graph.hits} hits, {graph.misses} misses)")
    print(f"  Manifest → {manifest}")
