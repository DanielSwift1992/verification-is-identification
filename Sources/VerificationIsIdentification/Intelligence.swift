// ═══════════════════════════════════════════════════════
// Intelligence Is Inevitable (IiI)
//
// Saturation theorem, crystallization axioms,
// phase transition dynamics.
// ═══════════════════════════════════════════════════════

/// This is the loop that lifts the agent's guess to a certified result. ``PassIsIdentification``
/// turns the agent path into a system path (Thm 2). ``IdentityCollapse`` adds the
/// fixpoint where verify-side and identify-side are one. [IiI §1]
public protocol AgentPathCertified: PassIsIdentification, IdentityCollapse {}

/// A permanent comparison cache beside a declared library. This intersection
/// does not itself constrain Library's update or predictive validity. [IiI §2]
public protocol KnowledgeAccumulates: CachePermanent, HasLibrary {}

/// A supplied Permanent library transition equals the declared saturation axis.
/// These constraints check that relation, not eventual coverage after K tasks.
///   1. `Library: Permanent` supplies an explicit retaining relation.
///   2. `Library == SaturatedLibrary` matches two type addresses.
/// Coverage needs fresh-class insertions, a finite common class set and visits.
/// Usable retrieval additionally needs dispatch sufficiency. [IiI §3, VI CS1–CS2]
public protocol LibrarySaturates: StructuresFinite, CachePermanent,
    HasLibrary, HasSaturation
    where Library: Permanent, Library == SaturatedLibrary {}

/// A declared IntegerValued basis coordinate beside library saturation.
/// This is a conformance premise. Its position in a where clause does not
/// prove finite generation of a semantic domain or termination of a basis
/// search. Those claims need separate witnesses. [IiI §3, Law §2, B6–B8]
public protocol BasisIsFinite: LibrarySaturates, HasBasis
where Basis: IntegerValued {}

/// A Permanent encoding axis beside a declared saturated library.
/// Retention does not prove coverage of an encoding grammar. Finite
/// coverage requires a finite common domain and an exhaustive policy.
/// This intersection does not supply that progress premise. [IiI §4–§5]
public protocol EncodingSelectionSaturates: LibrarySaturates,
    HasEncoding
    where Encoding: Permanent {}

// §5 A1: S₀ ⊇ S₁ ⊇ ..., solution set only shrinks. This IS the V=I
// inner-loop result CandidatesOnlyLeave (§5.22), and IiI reuses it directly
// (Law §1: the claim is written once, in Identification.swift, no rename here).

/// A2 carries the declared retaining cache relation and decidable comparison.
/// This does not supply unlimited physical storage or a stationary whole
/// with strictly growing accessible records. [IiI §5 · Matter M36–M37]
public protocol ResultsIrreversible: CachePermanent, EqualityDecidable {}

/// A3: membership in Sₙ is decidable at each step. ``EqualityDecidable`` over
/// ``HasSolutions``, compressing `SolutionSet: Decidable`. [IiI §5 · V=I A4]
public protocol MembershipDecidable: EqualityDecidable,
    HasSolutions
    where SolutionSet: Decidable {}

/// A declared Unique solution-set coordinate with monotonicity,
/// retained results and decidable membership. The compiler checks these
/// type relations. It does not prove eventual convergence of a runtime
/// search from every initial state or under every policy.
/// Finite candidate sets can stabilize with multiple survivors.
/// Repeated observations need not exclude any further candidate.
///
/// Finite identification requires soundness and eventual separation of
/// every competing candidate. Settling a question can require less than
/// whole-candidate uniqueness. These acquisition premises are separate
/// from the supplied Unique coordinate. [IiI §5, Liquid LQ11]
/// That coordinate's projection constraints alone do not count survivors.
/// V=I U1–U2 separates the fixpoint from a supported singleton claim.
public protocol SystemCrystallizes: CandidatesOnlyLeave, ResultsIrreversible,
    MembershipDecidable
    where SolutionSet: Unique {}

/// A declared unique pipeline result with PASS-to-identification.
/// Eventual acquisition requires the progress premise of IiI §5 Lemma 1.
public protocol PipelineCrystallizes: SystemCrystallizes, PassIsIdentification {}

/// A uniqueness declaration beside a library saturation relation.
/// Actual coverage requires eventual new-class insertions (IiI §5 Lemma 2).
public protocol LibraryCrystallizes: SystemCrystallizes, LibrarySaturates {}

/// A saturating-library declaration with bounded comparisons. The expected
/// time `K·H_K` additionally needs an empty start, IID uniform class arrivals
/// and successful learning on encounter. These are not encoded here. [IiI §6]
public protocol SaturationDynamics: LibrarySaturates, ComparisonsAreBounded {}

/// A declared saturation relation and a unique encoding-local survivor.
/// Connecting that survivor to an unknown actual law requires representability.
/// Raw feature records need not be unique across discoveries. [IiI §7, VI CS3]
public protocol DiscoveryIsRevelation: LibrarySaturates, ExactlyOneSurvives {}


// ── §3 Intelligence (η): §T-generated ───────────────────────

/// This names the coordinate for identification efficiency.
///
/// On a completed task τ, IiI §3 defines the intelligence of protocol P as
/// `η(P, τ) = T_min(τ) / T_actual(P, τ) ∈ (0,1]`: the least COMPARE count
/// that reaches `|S| ≤ 1` on τ, divided by the count P actually uses. The
/// ratio is defined only when `0 < T_min ≤ T_actual`, with both costs in the
/// same unit and the same available information, memory and query
/// capabilities. The inline ``Measurable`` bound dimensions the axis
/// (``Law`` §2): `Efficiency` has a ``Null`` output, whose two sides agree.
/// The application constructs the reading that relates it to a protocol, a
/// task and both costs. [IiI §3] [EiF EF10]
public protocol HasEfficiency: HasSigma {
    associatedtype Efficiency: Measurable
}

/// A saturation declaration beside a measured efficiency axis. No inequality
/// relates successive efficiencies here. Coverage does not prove improvement
/// or optimal dispatch: those require compatible cost units and a separate
/// comparison of implemented policies. [IiI §3, §8]
public protocol IntelligenceRises: LibrarySaturates, HasEfficiency {}
