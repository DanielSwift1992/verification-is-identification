"""
§1 Grammar — finite rule space F over the feature language.

feature_rules():  F — all non-empty feature-conjunction rules (§3.3).
NAMED:            human-readable labels for known rules.
name_rule():      best matching label for an extracted rule.
"""

from itertools import product as _product


NAMED = {
    "identity": {"same_row": True, "same_col": True},
    "hflip":    {"same_row": True, "col_mirror": True},
    "vflip":    {"same_col": True, "row_mirror": True},
    "rot180":   {"row_mirror": True, "col_mirror": True},
    "rank0":    {"rank": 0},
    "rank1":    {"rank": 1},
}

_BOOLS = ("same_row", "same_col", "row_mirror", "col_mirror")


def feature_rules(rank_values=()):
    """F: all non-empty feature-conjunction rules (§3.3).

    Boolean features ∈ {True, False, absent}.
    Rank ∈ observed values only (avoids vacuous constraints).
    """
    rules = []
    for combo in _product((True, False, None), repeat=len(_BOOLS)):
        for rank_val in [None] + sorted(rank_values):
            rule = {}
            for feat, val in zip(_BOOLS, combo):
                if val is not None:
                    rule[feat] = val
            if rank_val is not None:
                rule["rank"] = rank_val
            if rule:
                rules.append(rule)
    return rules


def name_rule(rule):
    """Best matching label: the named rule with most constraints satisfied."""
    best, best_n = None, 0
    for label, named in NAMED.items():
        if all(rule.get(k) == v for k, v in named.items()):
            if len(named) > best_n:
                best, best_n = label, len(named)
    return best or repr(rule)
