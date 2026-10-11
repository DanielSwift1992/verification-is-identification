# An internal controller reads observations, not original-answer tags

The executable program contains a boot table and numbered memory states.
The separate proof annotations are unavailable to the running controller.

| Memory | Action | Answer when finished | Next observation → memory |
|---|---|---|---|
| 0 | ask_A | None | quiet → 2, signal → 3 |
| 1 | None | was_not_A |  |
| 2 | None | was_not_A |  |
| 3 | None | was_A |  |

| Initial observation | Prepared memory becomes |
|---|---|
| quiet | 0 |
| signal | 1 |

| Origin | Scene / controller memory / readable answer |
|---|---|
| A | A / -1 / None → A / 0 / None → signal / 3 / was_A |
| B | B / -1 / None → B / 0 / None → A / 2 / was_not_A |
| C | C / -1 / None → C / 0 / None → A / 2 / was_not_A |
| signal | signal / -1 / None → signal / 1 / was_not_A → signal / 1 / was_not_A |

The prepared experiment finishes within **2** joint steps, including boot.
Its finite history completion has **12** whole states in cycles of length **3**.
Different origins remain in different whole histories even when scene and controller merge.
The next transition after the demonstrated window restores the prepared configuration.
Consequently the output is available in a finite window, not as a newly acquired permanent absorbing state.
History recovery is an abstract whole-system transition. It is not a new action supplied to the agent.
The construction assumes a prepared controller and enough history capacity. It establishes no physical cost or locality bound.
