// ═══════════════════════════════════════════════════════
// V=I Proof Chain — §5.15 Structural Recurrence.
//
// Each claim is a protocol. Dependencies = protocol inheritance.
// Remove any protocol → all dependents fail to compile.
// The Swift compiler IS the proof chain verifier.
//
// 20 claims from §0–§5. Dependency DAG encoded as inheritance.
// ═══════════════════════════════════════════════════════


// ── §0 Foundations ───────────────────────────────────────

/// I1: All structures are finite. [postulate]
public protocol I1_Finite {}

/// I2: Operations closed under Σ (PAIR, NULL, COMPARE, proj). [from I1]
public protocol I2_Closed {}

/// A4: Structural equality on finite structures is decidable. [from I1]
public protocol A4_Decidable: I1_Finite {}


// ── §2 Derived Invariant ─────────────────────────────────

/// I3: Comparison graph is append-only (G' ⊇ G). [from I1, I2]
public protocol I3_Permanent: I1_Finite, I2_Closed {}


// ── §5 Inner Properties ─────────────────────────────────

/// §5.1: Every step operates on finite domain → terminates. [from I1]
public protocol S5_1_Termination: I1_Finite {}

/// §5.5: Pipeline is total: ENCODE → VALIDATE → EXTRACT → COMPILE → EXECUTE. [from §5.1]
public protocol S5_5_Totality: S5_1_Termination {}

/// §5.8: Same task + grammar + protocol → same result. [from I2]
public protocol S5_8_Deterministic: I2_Closed {}


// ── §5 Monotonicity ─────────────────────────────────────

/// §5.6: G_n ⊆ G_{n+1} — cached comparisons never retracted. [from I3]
public protocol S5_6_MonotoneOrder: I3_Permanent {}

/// §5.7: Diagnostic info monotonically non-decreasing. [from I3, §5.8]
public protocol S5_7_MonotoneInfo: I3_Permanent, S5_8_Deterministic {}

/// §5.22: |S_{n+1}| ≤ |S_n| — candidates only leave S, never enter. [from I3]
public protocol S5_22_SMonotone: I3_Permanent {}


// ── §5 Structural ────────────────────────────────────────

/// §5.23: No self-reference in pipeline (I2 ops don't take pipeline as input). [from I2]
public protocol S5_23_NoSelfRef: I2_Closed {}

/// §5.24: Pipeline sees only encoded representation. [from I2, §5.8]
public protocol S5_24_EncodingBounded: I2_Closed, S5_8_Deterministic {}


// ── §3 Problem Requirement ───────────────────────────────

/// R4: |S| = 1 — exactly one candidate passes verification. [from I1, A4]
public protocol R4_Unique: I1_Finite, A4_Decidable {}


// ── §5 Theorems ──────────────────────────────────────────

/// Theorem 1: PASS → f' ∈ S. [from §5.5, §5.8]
public protocol Thm1_Compilation: S5_5_Totality, S5_8_Deterministic {}

/// Theorem 2: |S|=1 ∧ PASS → f' = f*. Verification IS identification. [from Thm 1, R4]
public protocol Thm2_Safety: Thm1_Compilation, R4_Unique {}

/// Theorem 3: N atoms → ≤ N² COMPAREs classify all pairs. [from I1]
public protocol Thm3_Identifiability: I1_Finite {}

/// Theorem 5: F finite ∧ S decidable ∧ |S|=1 → certification yields PASS. [from I1, A4, R4]
public protocol Thm5_Completeness: I1_Finite, A4_Decidable, R4_Unique {}


// ── §5 Axis Alignment ────────────────────────────────────

/// AX1: All monotone properties co-oriented (info↑, rejections↑, |S|↓). [from I1, I3, I2, §5.8]
public protocol AX1_Alignment: I1_Finite, I3_Permanent, I2_Closed, S5_8_Deterministic {}

/// AX2: Saturation (1−|S|/|F|) is incorruptible progress metric. [from I1, I3]
public protocol AX2_Saturation: I1_Finite, I3_Permanent {}

/// AX3: I3 is the alignment generator — remove it and axes decouple. [from I3]
public protocol AX3_Generator: I3_Permanent {}
