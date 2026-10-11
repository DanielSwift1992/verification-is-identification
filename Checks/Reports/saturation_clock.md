# Repairing the entropy example

The eight complete states include an internal two-phase clock. This is the finite model of M38-M40, with a fixed reading and a permutation.

## Result

8 states, 4 initial classes, 6 final classes. Strict refinement steps: 1.

The result is the coarsest autonomous refinement of the initial reading
for exactly the declared total operations. Minimality concerns its
distinctions, not the number or cost of sensors, memory or feature words.

## Why each distinction was added

Words run from left to right. The empty word reads the current state.

1. Previously equal: `1@0` and `2@0`. Read after `tick`: `[1,"small"]` versus `[1,"large"]`.

## Certified quotient

| State | Class |
| --- | --- |
| 0@0 | 0 |
| 0@1 | 1 |
| 1@0 | 2 |
| 1@1 | 3 |
| 2@0 | 4 |
| 2@1 | 5 |
| 3@0 | 4 |
| 3@1 | 5 |

```json
{
  "observation": [
    [
      0,
      "small"
    ],
    [
      1,
      "small"
    ],
    [
      0,
      "large"
    ],
    [
      1,
      "large"
    ],
    [
      0,
      "large"
    ],
    [
      1,
      "large"
    ]
  ],
  "operations": {
    "tick": [
      3,
      2,
      1,
      0,
      5,
      4
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
