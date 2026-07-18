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
    public typealias RadialNodes = Succ<Succ<Never>>
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
/// Two steps: the unit, once more.
public typealias Lit2 = Succ<Lit1>

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

// ── Ranging: the same Seeing pair, worked on directions instead of lines. A
// matte wall forgets which side its light came from; a mirror keeps the
// direction whole. So a glint is the observer written into the image, and the
// glint path measures the distance to its own eye. ──

/// A lighting of the scene: how much light arrives from the east, from the
/// west, and in total. The total is part of the statement, and the judge holds
/// the images below to it.
public protocol SceneLight {
    associatedtype FromEast: IntegerValued
    associatedtype FromWest: IntegerValued
    associatedtype Total: IntegerValued
}

/// One unit of light from the east, nothing from the west.
public enum LitFromEast: SceneLight {
    public typealias FromEast = Lit1
    public typealias FromWest = Never
    public typealias Total = Lit1
}

/// The same total from the opposite side.
public enum LitFromWest: SceneLight {
    public typealias FromEast = Never
    public typealias FromWest = Lit1
    public typealias Total = Lit1
}

/// A matte wall reads the total and drops the side: a diffuse surface is an
/// encoding of directions with a kernel.
public typealias MatteImage<S: SceneLight> = S.Total

/// A mirror reads both sides apart: nothing about the direction is forgotten.
public typealias MirrorImage<S: SceneLight> = Paired<S.FromEast, S.FromWest>

/// Two lightings a matte wall cannot tell apart: directional metamerism,
/// compiled. The mirror parts the same pair, and the refusal names the side.
public protocol MatteBlindPair {}
public enum MatteAlike<X: SceneLight, Y: SceneLight> {}
extension MatteAlike: MatteBlindPair
where MatteImage<X> == MatteImage<Y> {}
public let directionalMetamerism: MatteBlindPair.Type = MatteAlike<LitFromEast, LitFromWest>.self

/// The direction world instantiates the same lattice pair a second time: the
/// matte wall is the eye of directions, the mirror is their prism. One pair,
/// two worlds, one certificate form.
public enum MirrorSpace {}
public enum MatteEncoding {}
public enum MirrorSeparator {}
public enum DirectionSeeing: SeparatorIdentifies {
    public typealias Sigma = MirrorSpace
    public typealias Encoding = MatteEncoding
    public typealias LeftSource = LitFromEast
    public typealias RightSource = LitFromWest
    public typealias SharedImage = MatteImage<LitFromEast>
    public typealias Separator = MirrorSeparator
}

// ── The glint measures: a round trip is twice the distance, and the compiler
// checks the halving. ──

/// The distance to the wall, in ticks of the stated unit: three.
public typealias WallDistance = Succ<Succ<Succ<Never>>>

/// The glint path goes there and back: the round trip is the pair of the
/// distance with itself.
public typealias GlintPath = Twice<WallDistance>

/// The halving certificate: a distance is half its round trip exactly when the
/// round trip is the distance paired with itself. Ranging reads the glint and
/// halves it, and the halving is checked, never computed at run time.
public protocol HalfOfRoundTrip {}
public enum Halves<D, R> {}
extension Halves: HalfOfRoundTrip
where R == Plus<D, D> {}
public let rangingChecked: HalfOfRoundTrip.Type = Halves<WallDistance, GlintPath>.self

// ── The wave: a contribution is a magnitude with a phase, phase is a residue,
// and interference is rewriting. Two contributions of equal magnitude and
// opposite phase annihilate; a dark fringe is a bag that settles to nothing. ──

/// The two residues of the half-turn cycle: in phase, and opposite.
public enum Phase0 {}
public enum PhaseHalf {}

/// One contribution to a wave: a magnitude on the ladder, a phase residue.
public enum Contribution<Magnitude: IntegerValued, Phase> {}

/// The annihilation schema, generic over magnitude: two contributions of equal
/// magnitude and opposite phase settle to darkness. The claim compiles for
/// every magnitude at once — the rule is judged on its edge, never per state.
public protocol SettlesToDark {}
public enum OppositePair<A, B> {}
extension OppositePair: SettlesToDark
where A == Contribution<Lit1, Phase0>, B == Contribution<Lit1, PhaseHalf> {}

/// The two-slit dark node: the two paths to it differ by half a tick, so their
/// contributions arrive opposite and cancel. Darkness is reached, not measured.
public let darkFringe: SettlesToDark.Type = OppositePair<
    Contribution<Lit1, Phase0>,
    Contribution<Lit1, PhaseHalf>
>.self

/// The bright node beside it: the paths agree, and agreement doubles. The
/// magnitude of the settled bag is the pair of the contribution with itself.
public typealias BrightNode = Twice<Lit1>

// ── Polarization: the tick carries two orthogonal slots. A polarizer kills
// one slot; crossed polarizers compile to darkness; the diagonal pane halves,
// and the halvings are checked, not computed. ──

/// Polarized light: one magnitude per orthogonal slot.
public protocol PolarizedLight {
    associatedtype Horizontal
    associatedtype Vertical
}

/// Eight units of horizontally polarized light: the lamp behind the panes.
public typealias Lit8 = Plus<Twice<Twice<Lit1>>, Twice<Twice<Lit1>>>
public enum LampH: PolarizedLight {
    public typealias Horizontal = Lit8
    public typealias Vertical = Never
}

/// A vertical-pass polarizer: kills the horizontal slot.
public enum PassVertical<P: PolarizedLight>: PolarizedLight {
    public typealias Horizontal = Never
    public typealias Vertical = P.Vertical
}

/// A horizontal-pass polarizer: kills the vertical slot.
public enum PassHorizontal<P: PolarizedLight>: PolarizedLight {
    public typealias Horizontal = P.Horizontal
    public typealias Vertical = Never
}

/// Crossed panes: horizontal light through a vertical pass. Both slots reach
/// the floor, and the darkness is a checked identity, not an observation.
public typealias Crossed = PassVertical<LampH>
public protocol AllDark {}
public enum Extinct<P: PolarizedLight> {}
extension Extinct: AllDark
where P.Horizontal == Never, P.Vertical == Never {}
public let crossedPanesGoDark: AllDark.Type = Extinct<Crossed>.self

/// The diagonal pane, presented on the stated 45° angle: it passes half the
/// arriving light and turns it, so each output slot carries half of the sum.
/// The pane is presented with its concrete levels, and the halving is checked
/// by the same identity ranging uses.
public enum DiagonalAfterLampH: PolarizedLight {
    public typealias Horizontal = Twice<Lit1>
    public typealias Vertical = Twice<Lit1>
}
public let diagonalHalvingChecked: HalfOfRoundTrip.Type = Halves<
    Plus<DiagonalAfterLampH.Horizontal, DiagonalAfterLampH.Vertical>,
    Lit8
>.self

/// Three panes: horizontal light, the diagonal pane, a vertical pass. A quarter
/// of the lamp survives — where crossed panes alone give darkness, the middle
/// pane revives the beam. The surviving level is checked as the half of the
/// half.
public typealias ThreePanes = PassVertical<DiagonalAfterLampH>
public let threePanesRevive: HalfOfRoundTrip.Type = Halves<
    ThreePanes.Vertical,
    Plus<DiagonalAfterLampH.Horizontal, DiagonalAfterLampH.Vertical>
>.self

// ── The phantom: an encoding that invents. Under salt, one beam is parted
// into two readings — the difference is the salt's, never the light's — so
// downstream there is a distinction with no source. A verb on a structure is
// this phantom, worn by prose. ──

/// Two salts: marks with no upstream fact behind them.
public enum SaltA: Close {}
extension SaltA {
    public static var typeName: String { "salt-a" }
}
public enum SaltB: Close {}
extension SaltB {
    public static var typeName: String { "salt-b" }
}

/// A salted reading of a beam: the eye's image with a mark that is no part of
/// the light.
public typealias SaltedImage<B: BeamShape, Salt: Structure> = Paired<EyeImage<B>, Salt>

/// The compiled phantom: one beam, two salted images, and the two are
/// distinct types — a difference downstream with no difference upstream.
public enum SaltedSeeing: EncodingInvents {
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias OneSource = RedBeam
    public typealias FirstImage = SaltedImage<RedBeam, SaltA>
    public typealias SecondImage = SaltedImage<RedBeam, SaltB>
}

// ── Colour and gamut: a colour is the class of beams behind one image, and a
// display reaches only the cone of its stated primaries. One gray primary
// spans one ray: equal channels are reachable, unequal ones are refused. ──

/// A display with one stated primary whose image lights both eye channels
/// equally: a gray laser. Its levels scale one direction and nothing else.
public enum GrayPrimaryAt<Level: IntegerValued> {}

/// Reachability, compiled: a target image is matched exactly when some stated
/// level of the primary lands on it. Equal channels match; the certificate is
/// the level itself.
public protocol WithinGamut {}
public enum Reaches<Level: IntegerValued, TargetLeft, TargetRight> {}
extension Reaches: WithinGamut
where TargetLeft == Level, TargetRight == Level {}
public let equalGrayReached: WithinGamut.Type = Reaches<Lit2, Lit2, Lit2>.self

#if SHOW_GAMUT
/// An unequal target under the gray primary: no level satisfies both channels,
/// the candidate set is empty, and the refusal names the mismatch. Build with
/// -DSHOW_GAMUT to watch out-of-gamut fail as a type, never clip as a value.
public let unequalRefused: WithinGamut.Type = Reaches<Lit2, Lit2, Lit1>.self
#endif

// ── Hue is a residue: the wheel is a finite ring, complement is the half-turn,
// and taking the complement twice is the identity, checked once for the ring. ──

/// The six-spoke hue wheel: each hue names its opposite, and the wheel is the
/// statement — no arithmetic computes it.
public protocol Hue {
    associatedtype Opposite: Hue
}
public enum HueRed: Hue {
    public typealias Opposite = HueCyan
}
public enum HueYellow: Hue {
    public typealias Opposite = HueBlue
}
public enum HueGreen: Hue {
    public typealias Opposite = HueMagenta
}
public enum HueCyan: Hue {
    public typealias Opposite = HueRed
}
public enum HueBlue: Hue {
    public typealias Opposite = HueYellow
}
public enum HueMagenta: Hue {
    public typealias Opposite = HueGreen
}

/// The involution certificate: the complement of the complement is the hue
/// itself, and the claim is generic — one check covers every spoke.
public protocol SelfInverse {}
public enum DoubleComplement<H: Hue> {}
extension DoubleComplement: SelfInverse
where H.Opposite.Opposite == H {}
public let complementInvolutes: SelfInverse.Type = DoubleComplement<HueRed>.self

// ── The lattice conformances: colour as a quotient, the display as a cone. ──

public enum ColourSpace {}
public enum GrayPrimaryMark {}

/// Colour instantiates ``ColourIsQuotient``: the metameric twins above are two
/// beams in one fiber, so the fiber is the colour and the beams stay two.
public enum ColourWorld: ColourIsQuotient {
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias LeftSource = RedBeam
    public typealias RightSource = RedBeamWithIR
    public typealias SharedImage = EyeImage<RedBeam>
    public typealias Fiber = EyeImage<RedBeam>
}

/// The gray display instantiates ``GamutIsCone``: one stated primary, a reach
/// of equal-channel images, and everything off the ray refused by name.
public enum GrayDisplay: GamutIsCone {
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias LeftSource = RedBeam
    public typealias RightSource = RedBeamWithIR
    public typealias SharedImage = EyeImage<RedBeam>
    public typealias Fiber = EyeImage<RedBeam>
    public typealias Primaries = GrayPrimaryAt<Lit1>
}

// ── A real display: two primaries over a three-channel eye. The gamut is a
// protocol — its `where` clause is the span of the primaries — so a colour
// inside conforms, and a colour outside fails the conformance by channel name. ──

/// A three-channel appearance: how much red, green, and blue the eye receives.
public protocol Glow {
    associatedtype RedChannel: IntegerValued
    associatedtype GreenChannel: IntegerValued
    associatedtype BlueChannel: IntegerValued
}

/// The gamut of a red-green display, stated as a protocol: both primaries are
/// dark in blue, so every mix is dark in blue, and the `where` clause says
/// exactly that. Out of gamut is a failed conformance, named by its channel.
public protocol OnRedGreenDisplay: Glow
where BlueChannel == Never {}

/// Yellow at full: both primaries lit, blue necessarily dark. It conforms —
/// the levels are the certificate.
public enum YellowAtFull: OnRedGreenDisplay {
    public typealias RedChannel = Lit1
    public typealias GreenChannel = Lit1
    public typealias BlueChannel = Never
}

#if SHOW_GAMUT
/// A laser blue on the red-green display: the conformance fails, and the
/// refusal names the blue channel. The display does not clip the colour — the
/// colour has no type on this display.
public enum LaserBlueOnRG: OnRedGreenDisplay {
    public typealias RedChannel = Never
    public typealias GreenChannel = Never
    public typealias BlueChannel = Lit1
}
#endif

// ── The two-slit scene: stated geometry, judged parity. A screen node states
// its left path and the extra length of its right path, and the SPELLING of
// that extra carries its parity: an even gap is written as a pair, an odd gap
// as one more beside a pair. The judge reads the spelling — even settles bright,
// odd settles dark — and the dark node is the annihilation pair above. ──

/// A screen node of the two-slit scene: the counted path through the left
/// slit, and the gap the right path adds. The scene is stated; nothing
/// measures it.
public protocol SlitNode {
    associatedtype ThroughLeft: IntegerValued
    associatedtype Gap
}

/// An even gap settles bright: the two contributions arrive in phase, and
/// agreement doubles. The certificate is the gap's own spelling as a pair.
public protocol BrightFringe {}
public enum EvenGap<N: SlitNode, K> {}
extension EvenGap: BrightFringe
where N.Gap == Twice<K> {}

/// An odd gap settles dark: the two contributions arrive opposite, and the
/// pair annihilates — the same rule ``OppositePair`` states in general.
public protocol DarkFringe {}
public enum OddGap<N: SlitNode, K> {}
extension OddGap: DarkFringe
where N.Gap == Plus<Lit1, Twice<K>> {}

/// Four nodes up the screen: gaps of zero, one, two, and three half-ticks,
/// spelled so their parity shows. The fringe pattern is four certificates.
public enum NodeCenter: SlitNode {
    public typealias ThroughLeft = Succ<Lit2>
    public typealias Gap = Twice<Never>
}
public enum NodeFirst: SlitNode {
    public typealias ThroughLeft = Succ<Lit2>
    public typealias Gap = Plus<Lit1, Twice<Never>>
}
public enum NodeSecond: SlitNode {
    public typealias ThroughLeft = Succ<Lit2>
    public typealias Gap = Twice<Lit1>
}
public enum NodeThird: SlitNode {
    public typealias ThroughLeft = Succ<Lit2>
    public typealias Gap = Plus<Lit1, Twice<Lit1>>
}

public let centerBright: BrightFringe.Type = EvenGap<NodeCenter, Never>.self
public let firstDark: DarkFringe.Type = OddGap<NodeFirst, Never>.self
public let secondBright: BrightFringe.Type = EvenGap<NodeSecond, Lit1>.self
public let thirdDark: DarkFringe.Type = OddGap<NodeThird, Lit1>.self
