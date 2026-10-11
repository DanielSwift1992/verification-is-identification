# Mixed continuation under a resident program and clock

The complete 48-state whole includes (a,b,c,r) and a three-phase clock. Phase 0 swaps b,c, phase 1 swaps a,b, and phase 2 changes no bit. Every step advances phase. This fixed permutation has no external action selector.

## Result

48 states, 6 initial classes, 24 final classes. Strict refinement steps: 6.

The result is the coarsest autonomous refinement of the initial reading
for exactly the declared total operations. Minimality concerns its
distinctions, not the number or cost of sensors, memory or feature words.

## Why each distinction was added

Words run from left to right. The empty word reads the current state.

1. Previously equal: `0000@1` and `0100@1`. Read after `tick`: `[2,0]` versus `[2,1]`.
2. Previously equal: `0000@0` and `0010@0`. Read after `tick then tick`: `[2,0]` versus `[2,1]`.
3. Previously equal: `0000@2` and `0010@2`. Read after `tick then tick then tick`: `[2,0]` versus `[2,1]`.
4. Previously equal: `0000@1` and `0010@1`. Read after `tick then tick then tick then tick`: `[2,0]` versus `[2,1]`.
5. Previously equal: `0000@0` and `0100@0`. Read after `tick then tick then tick then tick then tick`: `[2,0]` versus `[2,1]`.
6. Previously equal: `0000@2` and `0100@2`. Read after `tick then tick then tick then tick then tick then tick`: `[2,0]` versus `[2,1]`.

## Certified quotient

| State | Class |
| --- | --- |
| 0000@0 | 0 |
| 0000@1 | 1 |
| 0000@2 | 2 |
| 0001@0 | 0 |
| 0001@1 | 1 |
| 0001@2 | 2 |
| 0010@0 | 3 |
| 0010@1 | 4 |
| 0010@2 | 5 |
| 0011@0 | 3 |
| 0011@1 | 4 |
| 0011@2 | 5 |
| 0100@0 | 6 |
| 0100@1 | 7 |
| 0100@2 | 8 |
| 0101@0 | 6 |
| 0101@1 | 7 |
| 0101@2 | 8 |
| 0110@0 | 9 |
| 0110@1 | 10 |
| 0110@2 | 11 |
| 0111@0 | 9 |
| 0111@1 | 10 |
| 0111@2 | 11 |
| 1000@0 | 12 |
| 1000@1 | 13 |
| 1000@2 | 14 |
| 1001@0 | 12 |
| 1001@1 | 13 |
| 1001@2 | 14 |
| 1010@0 | 15 |
| 1010@1 | 16 |
| 1010@2 | 17 |
| 1011@0 | 15 |
| 1011@1 | 16 |
| 1011@2 | 17 |
| 1100@0 | 18 |
| 1100@1 | 19 |
| 1100@2 | 20 |
| 1101@0 | 18 |
| 1101@1 | 19 |
| 1101@2 | 20 |
| 1110@0 | 21 |
| 1110@1 | 22 |
| 1110@2 | 23 |
| 1111@0 | 21 |
| 1111@1 | 22 |
| 1111@2 | 23 |

```json
{
  "observation": [
    [
      0,
      0
    ],
    [
      1,
      0
    ],
    [
      2,
      0
    ],
    [
      0,
      0
    ],
    [
      1,
      0
    ],
    [
      2,
      0
    ],
    [
      0,
      0
    ],
    [
      1,
      0
    ],
    [
      2,
      0
    ],
    [
      0,
      0
    ],
    [
      1,
      0
    ],
    [
      2,
      0
    ],
    [
      0,
      1
    ],
    [
      1,
      1
    ],
    [
      2,
      1
    ],
    [
      0,
      1
    ],
    [
      1,
      1
    ],
    [
      2,
      1
    ],
    [
      0,
      1
    ],
    [
      1,
      1
    ],
    [
      2,
      1
    ],
    [
      0,
      1
    ],
    [
      1,
      1
    ],
    [
      2,
      1
    ]
  ],
  "operations": {
    "tick": [
      1,
      2,
      0,
      7,
      5,
      3,
      4,
      14,
      6,
      10,
      17,
      9,
      13,
      8,
      12,
      19,
      11,
      15,
      16,
      20,
      18,
      22,
      23,
      21
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
