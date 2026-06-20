// ═══════════════════════════════════════════════════════════════
// Learning Is Liquid (Phase) — paper L.
//
// Matter derived the crystal — the saturated library, permanent and
// irreducible — and named its complement only in passing: a LIQUID phase
// below saturation that, unlike a physical melt, never melts. This derives
// the liquid. The un-saturated regime is not a deficient crystal; it is a
// phase with its own dynamics, and for most domains (horns) it is the
// PERMANENT one. The liquid has two coupled dynamics: a crystallization
// FRONT (the frontier, the discriminator side — advances monotonically, I3:
// no melting) and a search FLOW (the generator — laminar where aligned α>0,
// turbulent where rugged). They couple as a Stefan problem: a supercooled
// liquid that only solidifies. The gate is the membrane between a guess
// (liquid) and a certificate (front).
//
// Pure types (§0′). The complement of Matter — the becoming of the crystal.
// Physics borrowed as TOOLS (Stefan, ruggedness, partition function), never
// as derived equations (§6). Knowledge is solid; learning is liquid. [Liquid]
// ═══════════════════════════════════════════════════════════════

/// Below saturation is a PHASE, not a deficit. For a horn (B8b) or prime-like
/// domain (B8a) it is permanent — the reach never crystallizes, only the basis.
/// The crystal (``Matter``) is the special case; the liquid is the norm.
/// Saturation is a FIELD — solid patches in a liquid surround, the library
/// accumulating (``KnowledgeAccumulates``, I3) while the unresolved region
/// shrinks (``Monotone``). [Liquid LQ1-2]
///
/// > Note: For most domains the liquid is the only phase there is. The crystal
/// > is a corner case; learning lives in the melt, and on a horn it stays
/// > there forever.
public protocol LiquidPhase: KnowledgeAccumulates, Monotone {}

/// The solid/liquid interface is the frontier: a ONE-SIDED free boundary of the
/// ``LiquidPhase``. It advances monotonically (I3: no melting, ``NoInverse``) and
/// never recedes; its geometry is the ``DistanceOnStructures`` W-metric,
/// dendritic — fastest along clustered directions. The discriminator side, a
/// one-phase Stefan front. [Liquid LQ3-4]
public protocol CrystallizationFront: LiquidPhase, DistanceOnStructures, NoInverse {}

/// The generator flows through the liquid by descending the loss. Where the
/// ``AlignmentCoefficient`` α>0 (aligned) the flow is LAMINAR — smooth descent,
/// no spurious minima. Where α≈0 (rugged) it is TURBULENT — multi-scale
/// roughness, no usable gradient, the search stalls. ~1/α is the Reynolds
/// number; the loss autocorrelation is its spectrum. The generator side that
/// feeds the ``LiquidPhase``. [Liquid LQ5-6]
public protocol SearchFlow: LiquidPhase, AlignmentCoefficient {}

/// The ``SearchFlow`` field and the ``CrystallizationFront`` couple exactly as a
/// Stefan problem — search finds a candidate, the gate freezes it (front
/// advances), the new crystal reshapes the loss landscape, the search shifts.
/// One field-and-free-boundary system, SUPERCOOLED: the front never recedes
/// (I3), so the liquid only freezes — the source of learning's arrow. [Liquid LQ8-9]
public protocol StefanCoupling: CrystallizationFront, SearchFlow {}

/// The gate is the membrane between a guess and a certificate. In a still-liquid
/// region the only honest output is a GUESS; past the ``StefanCoupling`` front, a
/// CERTIFICATE — certified answer out (``PassImpliesMembership``), honest silence
/// where still liquid (PP7). Current statistical AI is pure liquid with NEITHER
/// front nor membrane: no I3 (the freeze never sticks — catastrophic forgetting),
/// no gate (guesses leak out as if certified — hallucination). It flows
/// everywhere and solidifies nowhere. [Liquid LQ10]
///
/// > Note: Two failures, one missing membrane. Hallucination is a guess that
/// > crossed without a gate; forgetting is a freeze that melted without I3 —
/// > both are what a liquid does when nothing separates guess from certificate.
public protocol GateIsMembrane: StefanCoupling, PassImpliesMembership {}
