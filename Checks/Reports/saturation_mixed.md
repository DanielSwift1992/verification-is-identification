# Separate saturation misses a mixed continuation

A declared vocabulary of two coordinate permutations on (a,b,c,r). The r coordinate is retained by the whole and ignored by every allowed future reading. These maps alone do not supply an outside chooser or a measurement device.

## Result

16 states, 2 initial classes, 8 final classes. Strict refinement steps: 2.

The result is the coarsest autonomous refinement of the initial reading
for exactly the declared total operations. Minimality concerns its
distinctions, not the number or cost of sensors, memory or feature words.

## Why each distinction was added

Words run from left to right. The empty word reads the current state.

1. Previously equal: `0000` and `0100`. Read after `swap_ab`: `0` versus `1`.
2. Previously equal: `0000` and `0010`. Read after `swap_bc then swap_ab`: `0` versus `1`.

## Certified quotient

| State | Class |
| --- | --- |
| 0000 | 0 |
| 0001 | 0 |
| 0010 | 1 |
| 0011 | 1 |
| 0100 | 2 |
| 0101 | 2 |
| 0110 | 3 |
| 0111 | 3 |
| 1000 | 4 |
| 1001 | 4 |
| 1010 | 5 |
| 1011 | 5 |
| 1100 | 6 |
| 1101 | 6 |
| 1110 | 7 |
| 1111 | 7 |

```json
{
  "observation": [
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    1
  ],
  "operations": {
    "swap_ab": [
      0,
      1,
      4,
      5,
      2,
      3,
      6,
      7
    ],
    "swap_bc": [
      0,
      2,
      1,
      3,
      4,
      6,
      5,
      7
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
