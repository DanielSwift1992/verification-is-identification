import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// LIGHT works the Seeing Is Encoding claims on a real physical instance. A beam
// is a finite structure: a stated basis of spectral lines with one brightness
// level per line. The basis is written by matter — each line IS a dipole-allowed
// hydrogen transition from Hydrogen.swift, so a forbidden line cannot enter the
// alphabet: it has no type. The eye is a projection that reads only the visible
// slots; two beams that differ in the infrared slot land on one visible image,
// and the compiler checks the sharing (metamerism, |S| > 1). The prism reads
// every slot, so the same two beams land apart again: the separator returns the
// lost distinction. Filters are type functions that can only dim or kill a slot,
// and a chain of filters is a counted transport: its depth is in the type.
// ═══════════════════════════════════════════════════════════════

/// The fourth-shell p orbital extends the hydrogen set upward: ℓ = 1, one step
/// above s, the same ladder every orbital rides.
public enum Orbital4p: Orbital {
    public typealias L = EllP
    public static let label = "4p"
}

// ── The basis: three lines, each a dipole-allowed transition. H-α and H-β are
// visible (Balmer, down to the second shell); Paschen-α lands on the third
// shell and is infrared. A transition with Δℓ ≠ ±1 would not compile here. ──

/// The visible red line: the third shell drops to the second, 656 nm.
public typealias LineHAlpha = Lowers<Orbital3d, Orbital2p>
/// The visible blue-green line: the fourth shell drops to the second, 486 nm.
public typealias LineHBeta = Lowers<Orbital4p, Orbital2s>
/// The infrared line: the fourth shell drops to the third, 1875 nm. No eye reads it.
public typealias LinePaschenAlpha = Lowers<Orbital4p, Orbital3s>

// ── The beam: one brightness level per line of the stated basis. ──

/// A beam assigns one level to each line of the basis: light is this structure,
/// whole. The three slots ride the same integer ladder the orbitals ride.
public protocol BeamShape {
    associatedtype AlphaLevel: IntegerValued
    associatedtype BetaLevel: IntegerValued
    associatedtype PaschenLevel: IntegerValued
}

/// One step of brightness: the unit level over the dark floor.
public typealias Lit1 = Succ<Never>

/// A concrete beam: bright H-α, dark H-β, dark infrared.
public enum RedBeam: BeamShape {
    public typealias AlphaLevel = Lit1
    public typealias BetaLevel = Never
    public typealias PaschenLevel = Never
}

/// The same visible light with the infrared line burning: it differs from
/// ``RedBeam`` in the one slot no eye reads.
public enum RedBeamWithIR: BeamShape {
    public typealias AlphaLevel = Lit1
    public typealias BetaLevel = Never
    public typealias PaschenLevel = Lit1
}

// ── The eye and the prism: two readings of one beam. ──

/// The eye reads the visible slots and nothing else: a projection that forgets
/// the infrared coordinate. What it returns is the whole of what it can ever
/// compare.
public typealias EyeImage<B: BeamShape> = Paired<B.AlphaLevel, B.BetaLevel>

/// The prism reads every slot: each line lands at its own place, so the image
/// is the beam itself, spread out. Nothing is forgotten.
public typealias PrismImage<B: BeamShape> = Paired<B.AlphaLevel, Paired<B.BetaLevel, B.PaschenLevel>>

/// Two beams the eye cannot tell apart: the claim compiles exactly when their
/// visible images are one type. This is metamerism as a compiled fact.
public protocol MetamericPair {}
public enum SeenAlike<X: BeamShape, Y: BeamShape> {}
extension SeenAlike: MetamericPair
where EyeImage<X> == EyeImage<Y> {}

/// The compiled witness: ``RedBeam`` and ``RedBeamWithIR`` are distinct types,
/// and the eye's images coincide. |S| > 1 at the eye.
public let metamerism: MetamericPair.Type = SeenAlike<RedBeam, RedBeamWithIR>.self

#if SHOW_METAMER_SPLIT
/// The same pair under the prism refuses: the prism images differ in the third
/// slot, so the conformance does not exist. Build with -DSHOW_METAMER_SPLIT to
/// watch the refusal name the mismatch.
public protocol PrismBlindPair {}
public enum PrismAlike<X: BeamShape, Y: BeamShape> {}
extension PrismAlike: PrismBlindPair
where PrismImage<X> == PrismImage<Y> {}
public let prismCannotTell: PrismBlindPair.Type = PrismAlike<RedBeam, RedBeamWithIR>.self
#endif

// ── Passive matter: a filter is a type function that can only dim or kill. ──

/// A filter that kills the H-β slot and passes the rest: passive by shape, since
/// its output levels are the input's or the floor, never above.
public enum BlockBeta<B: BeamShape>: BeamShape {
    public typealias AlphaLevel = B.AlphaLevel
    public typealias BetaLevel = Never
    public typealias PaschenLevel = B.PaschenLevel
}

/// A filter that kills the infrared slot: hot glass.
public enum BlockIR<B: BeamShape>: BeamShape {
    public typealias AlphaLevel = B.AlphaLevel
    public typealias BetaLevel = B.BetaLevel
    public typealias PaschenLevel = Never
}

/// A counted transport: two filters in a written chain. The depth is the type's
/// own nesting, and the result is again a beam, judged whole.
public typealias ThroughTwoPanes = BlockIR<BlockBeta<RedBeamWithIR>>

/// The transported beam agrees with plain ``RedBeam`` under the prism: the chain
/// removed exactly the infrared line, and the compiler checks the agreement.
public protocol SameUnderPrism {}
public enum PrismAgrees<X: BeamShape, Y: BeamShape> {}
extension PrismAgrees: SameUnderPrism
where PrismImage<X> == PrismImage<Y> {}
public let transportChecked: SameUnderPrism.Type = PrismAgrees<ThroughTwoPanes, RedBeam>.self

// ── The lattice conformance: this world instantiates the Seeing pair. ──

/// The space the instance lives in: beams over the three-line basis.
public enum BeamSpace {}
/// The eye, named as the encoding under judgement.
public enum EyeEncoding {}
/// The prism, named as the presented separator.
public enum PrismSeparator {}

/// Light instantiates ``SeparatorIdentifies``: the eye forgets (the twins and
/// their shared image stand above), and the prism, presented, tells the twins
/// apart. Compiling this conformance is the certificate.
public enum LightSeeing: SeparatorIdentifies {
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias LeftSource = RedBeam
    public typealias RightSource = RedBeamWithIR
    public typealias SharedImage = EyeImage<RedBeam>
    public typealias Separator = PrismSeparator
}
