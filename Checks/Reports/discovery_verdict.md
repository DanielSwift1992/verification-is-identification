# A verdict is discoverable even when initial identity is not

The target is whether the original state was A. This is a reduced evolving scene, with no reset or fresh specimen. Current-state identity is a different question.

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

## The fixed question about the original state

Guaranteed verdict discovery: **True**.

| Origin | Certified answer | Actions | Remaining original candidates |
|---|---|---|---|
| A | was_A | ask_A | A |
| B | was_not_A | ask_A | B, C |
| C | was_not_A | ask_A | B, C |
| signal | was_not_A | none | signal |
