# Seeing Is Encoding (Sensor)

A reader receives an image through a specified interaction. Which question does that image settle? For a deterministic encoding, the answer must agree across every source that produces the same image. For a stochastic measurement, every possible record must admit only one answer, even when different sources assign that record different probabilities. Light and the qubit test these two conditions.

## §0. Premises

State the source domain X, the accessible record and the measurement conditions. All sources, instruments, observers and records belong to the same whole. Specifying which record a reader can access does not introduce anything outside that whole. The mathematical map describes that access. Its agreement with an actual instrument needs calibration or a physical derivation.

The finite spectral example below is a model choice. Existence Is Finite distinguishes a finite description from a proof that every physical object has finitely many degrees of freedom. Neither that paper nor the encoding axis derives a spectral basis, a detector response or the Born rule.

## §1. The beam

**SiE1 (A declared spectral carrier).** In the finite model, a source is a tuple of nonnegative levels on named spectral channels. A physical interpretation additionally specifies wavelengths or band profiles, units and the admitted source family. The hydrogen example uses three selected dipole-allowed transitions. Its selection rule checks membership in that transition model. It does not establish that every beam consists of those lines, exclude other emission mechanisms or represent a continuous spectrum exactly.

## §2. Matter and transport

**SiE2 (A restricted filter family).** The supplied slot filters either preserve a level or replace it with zero. Such a filter cannot increase any slot, by its definition. A diagonal attenuator with coefficients between zero and one extends this model. General passive optical interactions need not preserve spectral channels, and the slot rule is not a derivation of all matter-light interactions. A zero output in this record says nothing by itself about information retained in the material or other parts of the whole.

## §3. The image

**SiE3 (Exact metameric equality).** Fix a deterministic encoder E:X→Y. Define x∼y exactly when E(x)=E(y). Equality makes this relation reflexive, symmetric and transitive. Distinct sources in one fiber cannot be identified from their common image alone. A question q:X→A can nevertheless be answered: a decoder d:E(X)→A with q=d∘E exists exactly when q is constant on every fiber. Necessity follows by substitution. For sufficiency, define d(z) as the common q-value on the nonempty fiber over z.

The existing `VisibleReading` and `JoinedVerdict` bind the actual source, question, context and computed image of each supplied branch. Their finite joins certify agreement on those branches. They do not enumerate an unspecified source family. `EncodingForgets` now binds its two source fields and shared image to the supplied readings and their common answer. This certifies the addressed pair, without requiring distinct sources or enumerating a whole fiber. The deterministic source-family interpretation remains a premise.

Physical metamerism concerns distinct visible spectral stimuli with equal tristimulus values under specified conditions. Changing the observer or, for reflecting objects, the illuminant can break a match, as specified by [CIE](https://www.cie.co.at/publications/special-metamerism-index-change-observer). The infrared-only difference in `RedBeamWithIR` demonstrates a discarded coordinate. It is not yet that stronger visible-spectrum experiment.

## §4. A separator needs access

**SiE4 (Separation of a supplied pair).** Given x≠y with E(x)=E(y), a second specified reading F separates this pair exactly when F(x)≠F(y). It need not identify every source. Conversely, no deterministic processing h of the common image can separate the pair: h(E(x))=h(E(y)). A separator therefore needs an accessible distinction beyond that image.

`PrismImage` is an ideal readout of all three declared slots. Its injectivity on these tuples follows from coordinate equality. This does not prove that an actual prism and detector resolve every physical spectral difference. The new reading applies to the retained source or an adequate record, not to information reconstructed from the coarse image alone. `SeparatorIdentifies` now binds its additional reading pair to exactly those source addresses. Inequality of the resulting answers and physical availability of those readings remain separate obligations. Its legacy name does not establish them.

## §5. Exact finite transport

**SiE5 (Exactness within a finite model).** A finite sum of declared path contributions can be evaluated exactly when its coefficients and arithmetic admit exact representation. A finite graph alone can have infinitely many walks. A declared finite path list or a depth bound supplies the required restriction. Neither a spectral basis nor a depth bound proves that omitted physical contributions vanish. Finite sums may also remain expensive to enumerate, so specifying the basis does not eliminate every reason to use sampling.

**SiE6 (Source recovery requires injectivity).** An inverse on the image exists for a deterministic map exactly when it is injective. A zeroing filter fails that condition on a domain containing different erased levels. Recovering a symbolic map's input requires this premise on its stated domain. An inverse step, a reversal of traversal and optical path reciprocity are different relations. Space §5k reconstructs a reversing involution only with the relevant internal reading and admission conditions. Swapping this filter's input and output labels establishes none of those physical contacts.

## §6. Mixing

**SiE7 (Linear readings preserve addition).** For a linear spectral sensor E, E(s+t)=E(s)+E(t). Nonlinear encoding, clipping and quantization require their own laws and generally do not preserve that equality. The premise concerns the sensor response and its domain, rather than the name of a colour coordinate system.

## §7. Distance

**SiE8 (Equality does not determine a metric).** An encoder induces an equivalence relation, but it supplies no perceptual distance. Even an injective encoder can rescale distances. A proposed distance on source representations must be independent of equivalent representations before it can describe a physical spectrum. A distance on images requires its own definition and any empirical interpretation.

## §8. Records with several possible outcomes

**SiE9 (An exact answer from one finite outcome).** Let X be a nonempty source domain, Z a finite outcome set and p(z|x) a normalized response law. A decoder d:Z→A answers q:X→A with probability one for every admitted x exactly when

```
p(z|x)>0 and p(z|y)>0  imply  q(x)=q(y).
```

Necessity: any shared possible z would require d(z) to equal both answers. Sufficiency: assign each possible z the common answer of all sources that can produce it. Unused outcomes can be assigned arbitrarily. Equivalently, q must be constant on connected components of the graph joining sources whose outcome supports overlap. This graph condition does not assume that overlap itself is transitive. A finite deterministic encoder is the special case with one possible outcome per source, recovering SiE3.

Equality of whole response distributions is a different equivalence relation. Different distributions can still overlap and prevent a certain answer from one outcome. Repeating a preparation changes the available record. For a fixed nonadaptive protocol with independent repetitions, two sources sharing a possible outcome still share a possible finite repeated record, so repetition alone need not give an exact universal answer. Statistical estimation with a stated error probability asks a different question. Continuous outcome spaces need a measure-theoretic formulation rather than this positive-point-probability criterion.

Matter §5's qubit calculation shows why this distinction matters physically. The response law, accessible system and allowed measurement must be stated. No probability law follows from the mere presence of several candidates.

## §9. A finite sensor with no invisible channel

**SiE10 (Mixing alone can hide a distinction).** Consider the declared three-channel linear sensor

```
E(a,b,c,d) = (a+d, b+d, c+d).
```

Every source channel contributes to the image. Nevertheless x=(1,1,1,0) and y=(0,0,0,1) both produce (1,1,1). Measuring the fourth channel separates them. More generally, adding one unit to each of the first three channels has the same image as adding one unit to the fourth channel, for every starting source. This follows by substituting the four increments into E.

For real nonnegative levels, the full fiber over (u,v,w) is

```
(a,b,c,d) = (u-t,v-t,w-t,t),   0 ≤ t ≤ min(u,v,w).
```

Thus an additional exact reading of d identifies the whole tuple in that fiber. Over nonnegative integer levels, restrict t to integers. For a linear scalar question q=αa+βb+γc+δd, substitution gives αu+βv+γw+(δ−α−β−γ)t. It is determined by E for every source exactly when δ=α+β+γ. Necessity follows already from the displayed pair, and sufficiency gives the decoder explicitly. Many questions therefore need no fourth-channel reading.

The static constructors in `SpectralSensor.swift` derive channel counts and sensor responses from the same increments. `Checks/Seeing.swift` checks the generic image equality, the concrete mixed pair and refusal to equate their fourth-channel readings. This is an exact finite sensor model, not a calibrated CIE observer or a claim about four chosen physical wavelengths. A physical demonstration must supply the actual response coefficients and measurement uncertainty.

**SiE11 (A response matrix supplies a physical test contract).** The particular coefficients in SiE10 are unnecessary for the existence of a mixed pair. Let R be any real 3×4 response matrix with nonnegative entries and no zero column. Its four columns are linearly dependent, so choose v≠0 with Rv=0. The vector v has both positive and negative entries: if all were nonnegative, a positive entry and its nonzero column would make at least one response positive, and the nonpositive case follows by reversing the sign. Write v=v⁺−v⁻. These are distinct nonnegative spectra with Rv⁺=Rv⁻, and every input channel still affects at least one output. This constructs a pair for the declared linear model without requiring a channel invisible to every detector.

For the full nonnegative source domain, a linear question c·s factors through R exactly when c belongs to the row space of R. A row combination c=wR gives the decoder w·(Rs). Conversely, invariance across every equal-image pair implies c·v=0 for every v in ker R, since each such v is the difference of its nonnegative parts. The annihilator of ker R is the row space. Restricted source families can permit further questions, so that domain is part of the claim.

Calibration uncertainty can enter the certificate explicitly. Suppose the actual coefficients differ from R by at most εᵢⱼ in each entry. For the fixed pair just constructed, its actual response difference in channel i then has absolute value at most Σⱼεᵢⱼ|vⱼ|, by the triangle inequality. An extra analyzer with nominal row f and coefficient error bounds ηⱼ has a nonzero response difference whenever |f·v|>Σⱼηⱼ|vⱼ|. If each of its two recorded readings also has error at most ν, the stronger bound |f·v|>Σⱼηⱼ|vⱼ|+2ν guarantees separation of the recorded values. These are conditional bounds for the specified linear and bounded-error model. They distinguish exact metamerism in the nominal matrix from agreement within a measured tolerance. No calibration data or generic Swift matrix certificate is supplied yet.

## §10. A Contact Can Exclude Every Hidden Mode

**SiE12 (A local zero constraint can certify the whole declared graph).** Let H be a finite Hermitian matrix, with an edge ij exactly when Hᵢⱼ≠0 for i≠j. Let S be the independently read coordinates. Start with S marked. Whenever a marked vertex has exactly one unmarked neighbor, mark that neighbor. If a finite sequence marks every vertex, no nonzero eigenvector of H vanishes on S.

To prove this, suppose Hu=λu and u vanishes on every currently marked vertex. At a marked vertex i with just one unmarked neighbor j, its row reduces to Hᵢⱼuⱼ=0. All other terms vanish, including (Hᵢᵢ−λ)uᵢ. The nonzero edge forces uⱼ=0. Each step preserves the conclusion until u=0. The certificate uses the actual rows and a finite sequence of forced zeros. It needs neither the eigenvalues nor equal edge magnitudes, signs or phases. The graph rule is known as zero forcing. [Burgarth et al., §4](https://arxiv.org/html/1111.1475) connect it with network controllability. The eigenvector argument here does not assert their stronger Lie-algebra result or discard its additional premises.

For every eigenspace K, restriction to S is therefore injective and dim K≤|S|. In LiR13's notation, if B supplies independent nonzero coordinate contacts at S, then K∩ker B†={0}. There is no hidden resonant ambiguity at those contacts. One endpoint of a path forces the entire path, so every eigenvalue is simple and every mode reaches that endpoint. The conclusion permits arbitrary onsite detunings and nonzero Hermitian nearest-neighbor couplings. It certifies visibility within the given graph. Whether every frequency lies in an attached lead's propagating band is a separate question.

**An added connection can remove this guarantee.** For the three-site path, an endpoint forces all three coordinates. Closing it into a unit-coupling triangle permits u=(0,1,−1) with Hu=−u. The two branches cancel at the same endpoint. More edges have produced an invisible eigenvector. `TriangleHiddenMode` in `Checks/Seeing.swift` derives the image of (0,A,−A) from those neighboring fields and its equality to the reversed mode. The same file checks that the unit instance is nonzero and refuses its equality with the zero field. Without the closing edge, the contact row retains only one of the two branches, and the check refuses the same zero contact equation for this nonzero mode. The internal eigenvalue can still have another mode visible there: invisible vectors, invisible entire eigenspaces and absence of a scattering response are different claims.

Failure of the marking rule does not prove that a hidden mode exists. For the unit-coupling four-site path with zero diagonals, the single contact S={2} cannot begin a mark. Nevertheless an eigenvector with u₂=0 must vanish. If λ≠0, the first row forces u₁=0, the second u₃=0 and the third u₄=0. If λ=0, the fourth row forces u₃=0, the second u₁=0 and the third u₄=0. Thus the rule is sufficient, not necessary for each fixed matrix.

No uniform sensitivity bound follows just from nonzero edges. A coupling can approach zero while the exact graph and the forcing sequence are preserved. LiR13 gives an explicit vanishing overlap. Nor does the proof establish that a physical graph has no omitted edges or channels. Its useful demand is narrower: each forcing step must justify why exactly one uncancelled neighbor remains in the actual row. A small unknown term cannot be silently replaced by an exact zero.

**Even complete boundary scattering need not identify the internal dimension.** In LiR13, take N side sites with H=ωI and w=(g/√N,…,g/√N), where real g≠0. Each site is connected to the same lead junction, so the full graph is connected. For λ≠ω the feedback is U=g²/(λ−ω), independent of N. At an in-band λ=ω, every member also gives t=0,r=−1. Thus the full complex reflection and transmission functions at this contact agree for all N, while N−1 independent modes are orthogonal to w. A contact at a single leaf can reveal a distinction that the common junction cannot. Arbitrarily accurate readings over the whole band do not count those hidden modes. A unitary boundary map recovers its incident source. It does not identify every internal state or certify all physically possible contacts. This is the distinction between one accessible reading and every possible interaction in The Cut, Step 3.

## Topics

### Related type declarations

- ``EncodingForgets``
- ``SeparatorIdentifies``
