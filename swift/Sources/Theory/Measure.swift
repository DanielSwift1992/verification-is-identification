// ═══════════════════════════════════════════════════════════════
// The measured boundary — where the proven core stops.
//
// The theory derives a chain, but its load-bearing CONDITIONAL claims —
// modulus (G10), compressibility (G12), navigability at small radius (N11),
// strategy clustering (O15), alignment (α, GA) — are NOT derivable from
// I1–I3. They are measurable properties of a domain. This file names that
// boundary at the type level: the proven core (Theorems 1–5, unconditional)
// against the measured core (the conditional faces a domain has or lacks).
// The instrument that measures them is empirical and lives in `python/`; E2
// specifies what such an instrument must satisfy. [Spec]
// ═══════════════════════════════════════════════════════════════

/// The conditional faces the theory cannot derive from I1–I3 are what an
/// instrument measures, per domain. Searchability (clustered ∧ aligned,
/// ``SearchableIffClusteredAndAligned``) and the ``FourthFace``, skill
/// compressibility (O18), are bundled as exactly those properties. This names
/// the proven/measured split: the proven core holds unconditionally, the
/// measured core is a property a domain has or lacks. [Spec]
///
/// > Note: This is the line between the proven core (Theorems 1–5 —
/// > ``PassIsIdentification`` and its ancestry) and the measured core. Whether a
/// > domain's faces hold is settled by an instrument, and the instrument is
/// > empirical: it lives in `python/`, not in these types.
public protocol MeasuredGeometry: SearchableIffClusteredAndAligned, FourthFace {}
