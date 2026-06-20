// ═══════════════════════════════════════════════════════
// Intelligence Is Inevitable (IiI) — paper 2
//
// Saturation theorem, crystallization axioms,
// phase transition dynamics.
// ═══════════════════════════════════════════════════════

/// §1: Agent path → system path. The loop converts the agent's
/// guess into a certified result via Thm2. [IiI §1]
/// Introduces VI_Identity: Left == SolutionSet (verification = identification).
public protocol AgentPathCertified: PassIsIdentification, VI_Identity {}

/// §2: Knowledge accumulates irreversibly. I3 applied to
/// the agent's knowledge state. [IiI §2]
public protocol KnowledgeAccumulates: CachePermanent {}

/// §3: Library saturates — after K tasks, all rule classes covered.
/// Two compressions:
///   1. Library: Permanent — library is append-only (from I3)
///   2. Library == SaturatedLibrary — library converges to its fixed point
/// Before: Library and SaturatedLibrary are free (Pair, two axes).
/// After: Library == SaturatedLibrary (Null, one axis). [IiI §3]
public protocol LibrarySaturates: StructuresFinite, CachePermanent,
    HasLibrary, HasSaturation where Library: Permanent, Library == SaturatedLibrary {}

/// §4: Encoding selection at level 2 also saturates.
/// Coverage over encoding grammar, not uniqueness. [IiI §4]
public protocol EncodingSelectionSaturates: LibrarySaturates {}

/// §5 A1: S₀ ⊇ S₁ ⊇ ... — solution set only shrinks. [IiI §5; V=I §5.22]
/// Compresses SolutionSet: it only shrinks, never grows.
public protocol SolutionSetShrinks: CandidatesOnlyLeave,
    HasSolutions where SolutionSet: Monotone {}

/// §5 A2: Results never retracted. I3 guarantees permanence. [IiI §5; V=I I3]
public protocol ResultsIrreversible: CachePermanent {}

/// §5 A3: Membership in Sₙ decidable at each step. [IiI §5; V=I A4]
/// Compresses SolutionSet: membership is decidable.
public protocol MembershipDecidable: EqualityDecidable,
    HasSolutions where SolutionSet: Decidable {}

/// §5 A4: ∃n: |Sₙ| ≤ 1 — the system reaches a terminal state. [IiI §5]
/// Inherits SolutionSet: Monotone ∧ Decidable, Library: Permanent.
public protocol SystemCrystallizes: SolutionSetShrinks, ResultsIrreversible, MembershipDecidable {}

/// Lemma 1: V=I inner pipeline is a crystallizing system (A1–A4 hold). [IiI §5]
public protocol PipelineCrystallizes: SystemCrystallizes, PassIsIdentification {}

/// Lemma 2: Library accumulation is a crystallizing system (A1–A4 hold). [IiI §5]
public protocol LibraryCrystallizes: SystemCrystallizes, LibrarySaturates {}

/// §6: E[τ_sat] = K·H_K — saturation follows coupon-collector dynamics. [IiI §6]
public protocol SaturationDynamics: LibrarySaturates {}

/// §7: f* pre-exists. Library is revealed, not constructed. [IiI §7]
public protocol DiscoveryIsRevelation: LibrarySaturates {}
