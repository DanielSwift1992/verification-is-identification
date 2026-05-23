# Verification Is Identification

A formal framework for provably safe AI derived from first principles.

## Core result

One postulate – *a finite structure exists* – yields a mathematical proof that any system certifying solutions over finite structures must converge to a single architecture: fixed space, decidable test, append-only memory. Safety is structural: the system cannot produce an output that fails its own verification, by construction. When exactly one candidate passes (|S| = 1), verification is identification.

Five theorems, 25 properties, three invariants (I1–I3) – all derived from the postulate.

## Paper

- **[Zenodo Publication](https://zenodo.org/records/20319580)** (Preprint & DOI)
- [Verification Is Identification](paper/Verification%20Is%20Identification.md) (Markdown source)
- [PDF Version](paper/Verification_Is_Identification.pdf)

## Implementations

### Swift — Appendix C (compile-time proof)

```
swift/Sources/
├── Engine/
│   ├── Primitives.swift      # §2: Z, S<N> (Peano naturals as types)
│   └── Engine.swift           # §4: State, Rule, Gate, CompilationGate
├── Atom/
│   └── Cell.swift             # §4.1: Cell<Row, Col, Val>
├── Compose/
│   ├── BasisGate.swift        # §4.2: In.Val == Out.Val
│   ├── MapRules.swift         # §4.4: SameRow, SameCol, ShiftRight, etc.
│   ├── ValueRules.swift       # §4.4: SameValue
│   └── ComposeRules.swift     # §4.5: And<R1, R2>
├── Agent/
│   └── AgentOS.swift          # §5.15: 20 protocol proof chain (DAG)
├── Proof/
│   ├── Main.swift             # Appendix C demonstrations
│   ├── IdentityProof.swift    # Identity mapping: 8 gates
│   └── RejectDemos.swift      # REJECT(basis) + REJECT(map)
└── SelfTest/
    └── Main.swift             # VIProofWitness — compile = verify all 20 claims
```

**Principle:** `CompilationGate<R>` compiles ⟺ rule constraints hold (§4.7). The Swift compiler IS the verifier. `enum` (uninhabited) = type-level only, no runtime.

Run: `cd swift && swift build && swift run Proof && swift run SelfTest`

### Python — Appendix B (runtime solver)

```
python/
├── primitives.py       # §2: NULL, PAIR, COMPARE
├── graph.py            # §2.3: append-only comparison cache (I3)
├── engine.py           # §4: domain-agnostic rule extraction
├── representation.py   # §3–4: atoms, features, compile, execute
├── grammar.py          # §3.3: F = all feature-conjunction rules
├── vi_core.py          # §5.5: full pipeline + §3.6 R4 check
├── tasks.py            # 5 demo tasks
└── main.py             # → pass_manifest.json
```

Pipeline: `ENCODE → VALIDATE(basis) → EXTRACT → COMPILE → EXECUTE` + R4 check (|S| counted extensionally).

Run: `cd python && python main.py`

## Full verification

```bash
cd python && python main.py && cd ../swift && swift build && swift run Proof && swift run SelfTest
```

## License

MIT
