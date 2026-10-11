# A question across different representations

VC36 composes q_B(t(a))=q_A(a) on D_A and q_C(s(b))=q_B(b)
on D_B when t(D_A) is contained in D_B. Substitution proves the
result for s after t. The intermediate question and its interpretation
must be shared. The Swift constructor requires the same actual reading.

The audit enumerates binary questions, total maps and all certificate
domains for carrier sizes (2,2,2) and (2,3,2). Empty scopes are included
and nonempty compatible scopes counted separately.

```json
{
  "cases": 311296,
  "compatible_certificates": 46112,
  "compatible_nonempty": 12704,
  "unsafe_scope_failures": 15136
}
```

## A complete internally clocked realization

Whole state is (x,h,u,v,z,phase): five bits and phase in {0,1,2}.
The source is (x,h), the wire has resident buffers (u,v), and the
receiver has z. Phase 0 XORs (h,x) into the wire, phase 1 XORs the
wire payload v into z, and phase 2 changes only the phase. Every step
advances phase modulo three. Reverse the phase and repeat its XORs
to recover the previous whole. All 96 states and both inverse equations
are checked. No outside controller, random tape or disposal is added.

Prepare u=v=z=0 at phase 0. At phase 1 the wire is (h,x), and at
phase 2 the receiver is x. This realizes the symbolic type path
(native,(x,h)) -> (wire,(h,x)) -> (scalar,x) on this prepared slice.
The original source and the wire remain inside the whole. The receiver
alone cannot recover h. All four complete prepared alternatives remain
distinct, while their two possible final payloads do not identify them.

| Native source | Wire representation | Scalar answer | Ready whole |
| --- | --- | --- | --- |
| [0, 0] | [0, 0] | 0 | [0, 0, 0, 0, 0, 2] |
| [0, 1] | [1, 0] | 0 | [0, 1, 1, 0, 0, 2] |
| [1, 0] | [0, 1] | 1 | [1, 0, 0, 1, 1, 2] |
| [1, 1] | [1, 1] | 1 | [1, 1, 1, 1, 1, 2] |

## Correct output does not certify every intermediate interpretation

For arbitrary buffers at phase 0 the wire is (u XOR h, v XOR x),
and the final payload is z XOR v XOR x. The first payload is correct
exactly when v=0. The final payload is correct exactly when z=v.
Both are correct exactly when v=z=0, independently of u. Reproducing
the full intended wire representation additionally requires u=0.

```json
{
  "starts": 32,
  "first_payload_correct": 16,
  "final_payload_correct": 16,
  "both_payloads_correct": 8,
  "cancelled_errors": 8
}
```

With v=z=1 the intermediate payload is wrong, yet the final payload
is right. This is an actual end-to-end equality on that preparation,
but not evidence that each stage preserved the declared question.
A direct certificate can therefore be valid without the proposed
factorization into locally preserving certificates being valid.

Counterexample traces use the same complete transition law:

```json
{
  "unprepared_wire": [
    [
      0,
      0,
      0,
      1,
      0,
      0
    ],
    [
      0,
      0,
      0,
      1,
      0,
      1
    ],
    [
      0,
      0,
      0,
      1,
      1,
      2
    ]
  ],
  "unprepared_receiver": [
    [
      0,
      0,
      0,
      0,
      1,
      0
    ],
    [
      0,
      0,
      0,
      0,
      1,
      1
    ],
    [
      0,
      0,
      0,
      0,
      1,
      2
    ]
  ],
  "cancelled_errors": [
    [
      0,
      0,
      0,
      1,
      1,
      0
    ],
    [
      0,
      0,
      0,
      1,
      1,
      1
    ],
    [
      0,
      0,
      0,
      1,
      0,
      2
    ]
  ]
}
```

Readiness is a phase, not an everlasting result or a permanent blank
buffer supply. This is a finite logical model, not a hardware efficiency
claim, a new physical law, or an implementation of every symbolic path.

## Evidence boundary

The universal set-theoretic proof and generic Swift constructor are
given in Verdict Is Invariant VC36. Finite enumeration checks nearby
scope failures. VC37 records the closed realization and cancelling-error
boundary. The type constructors prove projection and composition in
the supplied tagged grammar. Physical interpretation and preparation
still require their own evidence. No theorem of category theory or
information theory is claimed as new.
