// ═══════════════════════════════════════════════════════════════
// Play Is Proof (Self-Play).
//
// Saturation (IiI §3) needs a stream the world may not supply. This paper
// removes the dependence: given a finite generating basis, the agent makes
// its stream: apply a certified rule to fresh inputs (the label is
// EXECUTED, not labelled), pose to a solver, gate the answer. Every
// self-made label is f* (Theorem 2): no label noise, the endpoint is
// basis-determined, not play-determined. The training signal is not a
// statistic of outcomes: it is a PROOF. The data problem dissolves into a
// basis and a gate.
//
// Pure types (§0′). The capstone of the numbered series: it composes the
// whole stack, and it names the floor (PP15): the comparison the agent
// runs on is given, certified by no game. [Play]
// ═══════════════════════════════════════════════════════════════

/// A certified rule f* ∈ L, applied to any input, yields a task whose label is
/// executed, not assumed. The gate certifies it: PASS gives f* = g
/// (Theorem 2). The library is a SOURCE of certified-labelled tasks, not only a
/// sink. The label is a proof. The poser is an oracle on its draw.
/// [Play PP1-2]
public protocol CertifiedRuleGenerates: PassIsIdentification, KnowledgeAccumulates {}

/// The ambiguity `|S|>1` names the discriminating input: the poser, knowing g,
/// generates it and eliminates the survivors (LT5 lifted from state-action to
/// example-input space). cert(g), the minimum discriminating set, is the floor,
/// approached by frontier-targeting. The failure names the next datum.
/// [Play PP3-4]
public protocol AmbiguityNamesInput: CertifiedRuleGenerates, HolesCarryAddresses {}

/// A directed poser saturates the closure with no external data and no critical
/// slowing: coverage is CHOSEN, not sampled. Any two self-players over the same
/// basis reach the SAME certified basis: the endpoint is basis-determined, not
/// play-determined. The whole guarantee (no noise, fixed endpoint) is exactly
/// I3 plus the gate, and fails without either. This is the central result of the
/// paper. [Play PP5-7]
///
/// > Note: The agent makes its stream, so saturation no longer waits on the
/// > world. ``TowerSelfPlay`` realises the poser/solver pair in time, present
/// > agent against past crystal.
public protocol SelfPlaySaturates: AmbiguityNamesInput, BasisIsFinite {}

/// One agent is closed under its encoding: it cannot self-generate a
/// distinction its lens collapses (its view *is* its encoding). The only
/// irreducible novelty is a SECOND encoding that resolves what the first
/// collapses. Self-play is bounded self-modification: within the grammar, never
/// to the grammar above. [Play PP8, PP14]
public protocol SecondEncodingIsNovelty: SelfPlaySaturates, ScopeBoundedByEncoding {}

/// A single agent climbing the tower self-plays against its crystal: at
/// level N+1 the fixed target is L_N, the agent's saturated permanent past
/// (Ignition, M8). The poser/solver pair is realised in time as present-agent /
/// past-crystal. Temporal self-play needs no second body. [Play PP9]
public protocol TowerSelfPlay: SelfPlaySaturates, Ignites {}

/// When a system learns by playing against itself, each thing it certifies is a proof,
/// and the pile of proofs is the learner, so learning and proving are one activity.
/// Every input is something already there, brought into the record by a comparison
/// rather than imported from outside. This is the capstone of the numbered series.
///
/// Mechanically, the training signal is a gate-certificate, proof accumulates, and the
/// accumulation is the agent, all on one closed substrate: Σ with the append-only
/// journal G, revealed by COMPARE, not imported. [Play PP10]
///
/// > Note: A decidable gate and a self-grounded one are mutually exclusive
/// > (Cantor/Lawvere: no surjection Σ → 2^Σ), so the loop makes proofs but cannot make
/// > the prover prove itself. The floor it runs on (PP15), the comparison itself, is
/// > given, certified by no game.
public protocol PlayIsProof: TowerSelfPlay, RevealsNotCreates {}

// ───────────────────────────────────────────────────────────────
// PP15: the floor. Certified self-play is SHARED and tower-deep witnessing,
// not SELF-witnessing on its ground. Trace any protocol above up its
// parents: it ends at Pair (Primitive.swift), the act of distinction, the
// postulate (V=I §0, §2.5). Pair is the one thing this whole lattice rests on
// and the one thing no protocol in it derives: an entry in no library,
// certified by no game. A decidable gate and a self-grounded gate are mutually
// exclusive (Cantor/Lawvere: no surjection Σ → 2^Σ). The agent grounds its
// rules, encodings, and strategies in its own certified record, but not the
// comparison it runs on. The floor is structural, and you can see it: every
// arrow points up to Pair, and Pair points to nothing. It makes proofs, and it
// cannot make the prover prove itself.
// ───────────────────────────────────────────────────────────────
