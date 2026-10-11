# The same questions as reversible internal exchanges

A finite reversible transition model. Executing a word physically still requires an internal prepared controller and recording resources.

Behavioral classes: **4**.
Minimum extra label alphabet for predictive sufficiency: **3** values.
Guaranteed initial-state identification in one run: **True**.

| State | Current observation | ask_A | ask_B |
|---|---|---|---|
| A | quiet | signal | A |
| B | quiet | B | signal |
| C | quiet | C | C |
| signal | signal | A | B |

## Shortest pair separators

| Pair | Operation word |
|---|---|
| A / B | ask_A |
| A / C | ask_A |
| A / signal | current observation |
| B / C | ask_B |
| B / signal | current observation |
| C / signal | current observation |

## Verified adaptive execution

| Original state | Actions | Observations |
|---|---|---|
| A | ask_A | quiet → signal |
| B | ask_A → ask_B | quiet → quiet → signal |
| C | ask_A → ask_B | quiet → quiet → quiet |
| signal | none | signal |

Preset word separating behavioral classes: ask_A → ask_B.
