import Notation

// ═══════════════════════════════════════════════════════════════
// Basis Is Residue (Basis).
//
// The ordered sieve computes a residue relative to a finite word budget.
// This differs from a minimal algebraic generator set and from a useful
// macro library. B6 preserves unbounded generation, while expansion changes
// the bounded reach: at most d macros of length e give at most d*e factors.
// A fixed finite budget cannot leave finite residue on an infinite library
// (B8), even when one generator suffices without that budget. The additive
// example has residue 1 modulo d. Cost equality does not characterize this
// sieve (B4). Candidate search, execution and stored definitions have separate
// costs. The existing protocol intersections do not implement the sieve.
//
// Pure types (§0′). Grounds HasBasis / BasisIsFinite with the sieve. [Basis]
// ═══════════════════════════════════════════════════════════════

/// Total endofunctions on a shared domain form an ambient monoid. A library
/// need not be closed or contain identity. This intersection supplies neither
/// a concrete composition operator nor a semantic equality procedure. Their
/// faithful implementation is a premise of the bounded sieve. [Basis B1–B3]
public protocol RulesCompose: KnowledgeAccumulates, OperationsClosed {}

/// A represented compositional-cost axis beside Distance. IntegerValued
/// constrains its shape. It does not compute the minimum over expressions.
/// The concrete numeral witness, candidate domain and charging convention
/// must justify that interpretation. [Basis B4–B5]
public protocol HasCompositionalNorm: HasDistance {
    associatedtype CompositionalNorm: IntegerValued
}

/// This intersection pins equality of two represented counts and inherits
/// the declared finite-basis axis. It does not compute a minimum word cost,
/// an ordered sieve residue or a smallest generating set. B4 separates cost
/// equality from bounded membership: 2=1+1 can be derived at equal cost.
/// B6 distinguishes unbounded generation from bounded reach. Expanding each
/// macro consumes its definition length in the primitive word budget.
/// B8 shows that fixed-budget residue is infinite for any infinite library,
/// even if a finite algebraic generator set exists. Such a residue therefore
/// cannot justify finite total learning cost from this conjunction alone.
/// [Basis B4–B8]
///
/// > Note: The historical name is retained. Its actual equality and inherited
/// > axes must be read with these separate semantic and resource premises.
public protocol AtomBasis: RulesCompose, BasisIsFinite, HasCompositionalNorm
    where CompositionalNorm == Distance {}

/// The bounded residue depends on the presented library, order, word budget
/// and equality procedure. A finite terminating run can certify each result.
/// The residue can still have a short formula, as the additive example shows.
/// Retention of this record is distinct from algebraic irreducibility and
/// from predicting future residue. This conjunction supplies no general
/// complexity lower bound or infinite completion certificate. [Basis B9–B11]
public protocol AtomnessIsTrajectory: AtomBasis, NoInverse {}

// ───────────────────────────────────────────────────────────────
// B8b classifies a specified algebraic generating set and its unbounded
// reach. The bounded sieve is a different construction. B8f identifies
// unbounded generated closure as idempotent, while Cl_d(Cl_e(A))=Cl_(de)(A).
// B11 asks a separate complexity question for a declared family and model.
// Neither a Riemann-Hypothesis correspondence nor inherent incompressibility
// of arbitrary sieve residues is established by the type lattice.
// ───────────────────────────────────────────────────────────────
