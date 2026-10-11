# Pairwise separation without a successful single-run experiment

A finite non-injective reduced model. It is not a complete finite reversible whole. No reset, fresh specimen, residual access or extra operation is available.

Behavioral classes: **4**.
Minimum extra label alphabet for predictive sufficiency: **3** values.
Guaranteed initial-state identification in one run: **False**.

| State | Current observation | ask_A | ask_B |
|---|---|---|---|
| A | quiet | signal | A |
| B | quiet | A | signal |
| C | quiet | A | A |
| signal | signal | A | A |

## Shortest pair separators

| Pair | Operation word |
|---|---|
| A / B | ask_A |
| A / C | ask_A |
| A / signal | current observation |
| B / C | ask_B |
| B / signal | current observation |
| C / signal | current observation |

## Checked obstruction

The JSON certificate lists a closed family of losing beliefs. For each available action, either two origins merge or some possible outcome remains in that family. A finite successful policy cannot leave such a family on every outcome.

Unresolved initial belief: A, B, C.
- ask_A merges B and C into A.
- ask_B merges A and C into A.
