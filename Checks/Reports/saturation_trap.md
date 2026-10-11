# Pairwise separation without a successful single-run experiment

A finite non-injective reduced model. It is not a complete finite reversible whole. No reset, fresh specimen, residual access or extra operation is available.

## Result

4 states, 2 initial classes, 4 final classes. Strict refinement steps: 2.

The result is the coarsest autonomous refinement of the initial reading
for exactly the declared total operations. Minimality concerns its
distinctions, not the number or cost of sensors, memory or feature words.

## Why each distinction was added

Words run from left to right. The empty word reads the current state.

1. Previously equal: `A` and `B`. Read after `ask_A`: `"signal"` versus `"quiet"`.
2. Previously equal: `B` and `C`. Read after `ask_B`: `"signal"` versus `"quiet"`.

## Certified quotient

| State | Class |
| --- | --- |
| A | 0 |
| B | 1 |
| C | 2 |
| signal | 3 |

```json
{
  "observation": [
    "quiet",
    "quiet",
    "quiet",
    "signal"
  ],
  "operations": {
    "ask_A": [
      3,
      0,
      0,
      0
    ],
    "ask_B": [
      0,
      3,
      0,
      0
    ]
  }
}
```

## Proof boundary

Every feature is a future reading of the original model. Consequently
no behaviorally equivalent states are separated. The checked quotient
preserves the original observation and every operation, so states it
merges agree on every future word. Together these two directions prove
minimality. A fingerprint binds the certificate to this supplied model;
it does not prove that model faithful to reality.

Synthesis reads the transition table. Physical acquisition of the feature
vector requires a separate experiment, preparation and internal memory.
In an irreversible reduced model, pairwise future distinctions may not
be jointly discoverable in a single run. No free reset or sensor is added.
