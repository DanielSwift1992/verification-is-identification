"""
§4 core: Domain-agnostic rule engine.

Operates ONLY on feature dicts and rules.
Does not import, know, or reference any domain concepts
(cells, grids, Peano, rows, columns, mirrors).
"""

RULE_META_KEYS = frozenset({"pipeline"})


def match_score(features, rule):
    """How many rule features does this candidate satisfy? (§4.6 resolution)"""
    return sum(features.get(f) == rule[f] for f in rule if f not in RULE_META_KEYS)


def extract_rule(equations, background, feature_names):
    """Consistent + informative features → rule.
    A feature is consistent if it has the same value in every equation.
    A feature is informative if it varies across background pairs."""
    rule = {}
    for f in feature_names:
        if not equations:
            continue
        values = {eq[f] for eq in equations}
        if len(values) != 1:
            continue
        if len({b[f] for b in background}) < 2:
            continue
        rule[f] = next(iter(values))
    return rule


def resolve_ambiguous(ambiguous, rule):
    """Pick the candidate that best matches the rule."""
    return [max(candidates, key=lambda c: match_score(c, rule))
            for candidates in ambiguous]
