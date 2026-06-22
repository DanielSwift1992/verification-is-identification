// ═══════════════════════════════════════════════════════════════
// Basis Is Residue (Basis).
//
// IiI saturates after K tasks. This sharpens K: most rule classes are
// recompositions of structure already certified. The genuinely new
// entries — the domain's ATOMS — are defined as the primes are: by
// survival of a sieve. A rule is atomic iff no composition of
// strictly-smaller certified rules reaches it (B4); the atom basis is the
// residue of running the composition-sieve in norm order (Eratosthenes,
// lifted from multiplication to composition). The basis generates the
// reachable domain; the true generating count is |A| ≤ K (B7); a domain
// is saturable at finite cost iff its atom basis is finite (B8).
//
// Pure types (§0′). Grounds HasBasis / BasisIsFinite with the sieve. [Basis]
// ═══════════════════════════════════════════════════════════════

/// Certified rules denote functions and COMPOSE: R∘Q is itself a
/// gate-checkable candidate. Composition is total, associative, with an
/// identity: certified rules form a MONOID, the algebraic substrate this paper
/// adds (derived from function composition, not postulated). [Basis B1]
public protocol RulesCompose: KnowledgeAccumulates, OperationsClosed {}

/// The compositional norm ‖·‖_comp: the cheapest build of a rule from atoms
/// (B5). A SECOND norm on Σ beside the intrinsic ‖·‖ (= Distance from NULL,
/// G1a / ``NullIsOrigin``). A finite count of distinctions, so ``IntegerValued``
/// inline (§2: a norm is a count by typing, exactly like Distance). [Basis B5]
public protocol HasCompositionalNorm: HasDistance {
    associatedtype CompositionalNorm: IntegerValued
}

/// An atom is the FIXED POINT where the two norms COINCIDE,
/// ‖R‖_comp = ‖R‖ (B4–B5), the prime characterization generalized: "primality
/// is the equality of the two axial norms." Conclusion pinned (§T): the gap
/// between the compositional and intrinsic norm collapses — `where
/// CompositionalNorm == Distance`. Composites drop strictly below (a cheaper
/// name, a shortcut). Atoms are where no shortcut exists — a path that does not
/// fold, already at the floor of its norm. The residue GENERATES the reachable
/// domain, is the true generating count |A| ≤ K (B7), and a domain is saturable
/// at finite cost iff it is finite (B8 — the primes, infinite by Euclid, are the
/// canonical negative). [Basis B4-B8]
///
/// > Note: Atoms are the residue of the composition-sieve in norm order — the
/// > domain's primes, where the two axial norms meet.
public protocol AtomBasis: RulesCompose, BasisIsFinite, HasCompositionalNorm
    where CompositionalNorm == Distance {}

/// Atom-ness is a property of the sieve TRAJECTORY, not of a rule read
/// in isolation: library- and depth-relative. Statically the basis looks
/// structureless. Dynamically, over a finite window, every atom has a witnessed
/// cause (the gate rejected every bounded composition of its predecessors), so
/// the residue is fully determined and permanent (I3) — determined, not
/// random, exactly as the primes are. [Basis B9, B10]
public protocol AtomnessIsTrajectory: AtomBasis, NoInverse {}

// ───────────────────────────────────────────────────────────────
// B8b (trichotomy) and B11 (the open question) — recorded, not pinned.
//
// B8b: by (basis, reach) a composition domain is CLOSED (finite basis, bounded
// reach), HORN (finite basis, INFINITE reach — ℕ-under-+: one atom, every
// numeral), or PRIMES (infinite basis). The HORN's infinite reach is the
// unbounded Pair-type itself (each element finite, the closure not) — not
// expressible as a finite axis, so it stays prose.
//
// B11: the sieve COMPUTES the basis (terminates by I1), but whether the residue
// is COMPRESSIBLE — foreseeable more cheaply than running the sieve — is open
// per domain. That is the prime-distribution question (Riemann) in the
// framework's clothes: named precisely, left honest. A boundary, like PP15.
// ───────────────────────────────────────────────────────────────
