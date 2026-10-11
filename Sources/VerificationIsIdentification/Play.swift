// ═══════════════════════════════════════════════════════════════
// Play Is Proof (Self-Play).
//
// Self-play can make examples exact for a known generated rule. Identifying
// that rule needs compatible representation, faithful evaluation and R4.
// Such examples do not alone identify an unknown empirical law. PP19
// separates generated information from new access within the closed whole.
// PP20 gives reversible reuse with a complete finite clock and cost model.
// Coverage still needs a declared class set, a successful solver and visits.
// A finite generating basis does not itself make the full closure finite.
// The data and computational obligations therefore remain distinct.
//
// Pure types (§0′). The capstone of the numbered series: it composes the
// whole stack. PP15 bounds universal Boolean evaluation; PP21 constructs
// relative inspection with the reference and checker inside the whole. [Play]
// ═══════════════════════════════════════════════════════════════

/// A known total rule can supply exact examples on its declared input domain.
/// Identification of its draw requires representability, faithful evaluation
/// and R4. This intersection alone supplies neither an evaluator nor evidence
/// that the generated target equals an unmeasured actual law.
/// [Play PP1-2, PP19]
public protocol CertifiedRuleGenerates: PassIsIdentification, KnowledgeAccumulates {}

/// Finite distinct extensional candidates have a separating input. Finding it
/// and reading the target there are separate capabilities. A poser knowing g
/// can evaluate its draw, but an unknown actual law may require another
/// internal measurement. This intersection does not construct that query.
/// [Play PP3-4, PP19]
public protocol AmbiguityNamesInput: CertifiedRuleGenerates, HolesCarryAddresses {}

/// A declared basis and a generation axis. Coverage needs a finite class set
/// or a separate generative completeness argument, actual visits and successful
/// certification. Retention alone does not provide them. Raw endpoints need
/// not coincide even when their rule projections do. Generated evidence is
/// exact for its own task under the evaluation and representation premises.
/// [Play PP5-7, PP19]
///
/// > Note: ``TowerSelfPlay`` names a temporal poser/solver relation. Neither
/// > this relation nor generation supplies an unmeasured law. The full
/// > information inputs and observation window must be stated.
public protocol SelfPlaySaturates: AmbiguityNamesInput, BasisIsFinite {}

/// Combining available readings refines their common observation partition
/// only when the added reading separates an old fiber. Recoding the same
/// complete inputs cannot create such a split. A new correlated internal
/// source can, without a second body or anything outside the whole.
/// [Play PP8, PP14, PP19]
public protocol SecondEncodingIsNovelty: SelfPlaySaturates, ScopeBoundedByEncoding {}

/// A single agent climbing the tower self-plays against its crystal: at
/// level N+1 the fixed target is L_N, the agent's saturated permanent past
/// (Ignition, M8). The poser/solver pair is realised in time as present-agent /
/// past-crystal. Temporal self-play needs no second body. [Play PP9]
public protocol TowerSelfPlay: SelfPlaySaturates, Ignites {}

/// A sound gate certifies a generated example relative to its rule, encoding
/// and evaluation premises. Preserving that certificate and making it
/// accessible require the stated memory and reading conditions. The same
/// whole may contain both the generated target and its checking machinery.
///
/// This protocol composes the declared tower and revelation relations.
/// Their intersection alone supplies neither physical implementation fidelity
/// nor new evidence about an unmeasured target. [Play PP19, PP21]
///
/// > Note: A total Boolean evaluator cannot represent its own diagonal
/// > complement (PP15). Finite self-application and relative internal inspection
/// > remain possible (PP21). Their soundness requires stated transition and
/// > reference premises. Physical closure alone does not discharge them.
public protocol PlayIsProof: TowerSelfPlay, RevealsNotCreates {}

// ───────────────────────────────────────────────────────────────
// PP15 bounds expressive completeness, not physical closure. If a total
// E:C×C→{0,1} represents d(c)=1−E(c,c) at code a, evaluating a at itself
// gives E(a,a)=1−E(a,a), a contradiction. A restricted finite table may
// still apply a code to itself.
// PP15 also gives the answer-domain form: representing t(E(c,c)) forces
// a fixed point of t. FirstDiagonalFixedPoint and SecondDiagonalFixedPoint
// derive that equality from actual applications and a represented row.
// Neither requires a fixed-point equality as a caller premise.
// PP21 places a candidate implementation,
// reference, mismatch register, verdict and clock in one finite whole.
// Relative correctness follows from that specified transition and prepared
// state. It does not establish the transition semantics without premises.
// Pair remains a declared primitive of this grammar. The lattice does not
// derive every premise of its interpretation, but this logical dependence
// neither places an object outside Ω nor excludes every internal self-test.
// No universal evaluator or axiom-free justification is constructed here.
// ───────────────────────────────────────────────────────────────
