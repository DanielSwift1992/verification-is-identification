# Verdict Is Invariant (Correspondence) — Return costs

This part contains the original derivations for return costs.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6zzd-Available-interventions-constrain-the-hidden-carrier>.

Required setting: VC100n uses VC100m’s complete carrier and program setting. <doc:verdict_is_invariant__action_interfaces#VC100m>, <doc:verdict_is_invariant#6zzj-Twelve-actual-words-supply-the-complete-four-phase-ambiguity>.

### VC100n

**VC100n (exact residue and the price of stronger return contracts).** Keep VC100m's carrier and fixed program M. Assume |X|≥2 and |Y|≥2 when distinguishing transformations on the entire carrier. Write

    R(t,y) = (t+1 mod 3, q^ε(t)(y)).

Then M=(q,R), W_work=(w,id), R³=(id_clock,q), and R has order nine. For any two forward interface words u,v, the full-action formula gives

    u=v on all of C  iff  u_phase=v_phase and m(u)=m(v) mod 9.

Here m counts M calls. Sufficiency is immediate. For necessity, two payload values already distinguish different slot permutations: place one value in a single slot and the other value everywhere else. Equal full actions therefore imply equal working permutations. Their environment factors then agree; R has order nine since clock return requires three steps and a non-fixed auxiliary tuple requires three such triples. This comparison concerns transformations on the entire carrier, not agreement on one tuple, a primitive trace, or its cost.

The two coordinates can be independently realized. In performed order,

    K = (W_work M)^2 = (id,R²),
    K⁵ = (id,R),
    N = K M⁷ = (q,id).

The first equation uses (wq)²=Z²=id; the others use R⁹=id and q³=id. Together with W_work=(w,id), these forward words generate all of A₄×C₉: w and q generate the twelve working permutations, while K⁵ generates the full environment factor. Thus there are exactly 108 full transformations and nine above each working transformation. This counts actions, not states; X and Y need not be finite. The kernel of the working projection is exactly {id}×C₉, rather than an unspecified hidden remainder.

There is an exact cost result in this same, restricted interface. Programs are fixed forward words over {M,W_work}; every M invokes its established nine-Q/W implementation and every W_work costs one Q/W call. No inverse primitive, read-dependent selection, or rewriting of M's implementation is added. On the full carrier, the minimum costs for these contracts are:

| Required final result | Exact cost | Attaining word |
| --- | --- | --- |
| Working q, with continued interface applicability | 9 | M |
| Working q and original clock; auxiliary unconstrained | 29 | B=K M |
| Working q, original clock and original auxiliary register | 83 | N=K M⁷ |

For the lower bounds, let a word have m calls to M and n to W_work. A working q requires m>0: w fixes slot b and q does not, so a word in w alone cannot give q. On the three partitions of four slots into pairs, w induces a three-cycle and q its square. Thus any word giving q satisfies

    n+2m = 2 mod 3.

Clock return requires m=0 mod 3; complete environment return requires m=0 mod 9. In either case n=2 mod 3, so n≥2. The respective positive minima of m are three and nine, giving 9·3+2=29 and 9·9+2=83. Without clock return, m≥1 alone gives cost≥9. The displayed words attain all three bounds. In particular 83 is a proved weighted-word minimum here, not a minimum among all programs in the original primitive contact language. Structural refocusing cost remains outside this Q/W count.

The full outputs also expose exactly where the stronger price disappears:

    B(x,t,y) = (q(x),t,q(y)),
    N(x,t,y) = (q(x),t,y).

On the invariant subdomain q(y)=y, B already restores the environment, so the full-return minimum there is 29 (with |X|≥2). Repeated payloads are not excluded to make the lower bound work: the 83 bound quantifies over all admitted y, including some that q changes. A demonstration on one fixed auxiliary tuple cannot certify return on that larger domain.

`PhaseInterfaceResidue.swift` constructs the actual K and B paths at all three clocks, then builds N=B M³ M³ from VC100m's actual cubes. Its generic `Endpoints: Null` witnesses identify short complete boundaries with the composed paths; no caller supplies the desired final equality. `Checks/PhaseInterfaceResidue.swift` checks these paths and permits B's full return on fixed auxiliary tuples. It rejects treating K as a whole identity, treating B as preserving arbitrary auxiliary data, and inferring full action equality from equal M counts alone. The classification and the all-word lower bounds above are mathematical proofs; these concrete Swift witnesses establish the attaining constructions and their stated boundaries, not an enumeration of every candidate word.

### VC100o

**VC100o (ten primitive contacts suffice and are necessary for full return).** Keep the known clock law and carrier C of VC100m. Let A=Q_work be the actual primitive that advances the clock, applying q at clocks zero/one and r=Q₂ at clock two. Write w=W, with w³=q³=id, (wq)²=id and r=w²q, all in performed order. The fixed word

    T = W_work A² W_work A⁴ W_work²
      = W Q Q W Q Q Q Q W W

acts as T(x,t,y)=(q(x),t,y) on all of C. Every call is on the working register: six Q calls return the clock and no call acts on y. No readout or special preparation is used.

To verify the phase action, set P=A² W_work A⁴. Its three clock clauses are

| Initial clock | Actual phase word in P | Phase result |
| --- | --- | --- |
| 0 | q² w r q² r | w q² |
| 1 | q r w q² r q | w q² |
| 2 | r q w q r q² | w q² |

Substitute r=w²q and use qwq=w², wqw=q². The first row reduces to q²w²q=wq²; the second to q w² (q w q²) w² q²=wq²; the third to w²(q²wq)w²=w²qw=wq². Thus T's phase action is w(wq²)w²=w²q²w²=q, proving the full output, including clock and context.

The exact minimum is ten in the following alphabet: Q_work, Q_aux, W_work, W_aux, each costing one. Each Q uses the same shared clock law; each W applies w to its addressed register without advancing the clock. Programs are fixed forward words, with no reading, conditional choice, clock reset or additional data-transforming operation. Structural refocusing only provides access to the named register; it is not an extra uncounted permutation of logical register contents. For the lower bound assume |X|≥2, |Y|≥2 and demand the displayed output for all of C.

Let m be the total number of Q calls and n the total number of W calls, on both registers. Clock return requires m=3k. On the three pair partitions the exponents of w,q,r are respectively 1,2,1 modulo three. Each global round of three Q calls contributes 2+2+1=5≡2 to the sum of the two register exponents, regardless of the addressed registers. A final q on working data and identity on auxiliary data therefore require

    n+2k = 2 mod 3.

Among words of length at most nine with m>0, only (m,n)=(3,0),(3,3), (3,6),(6,1) survive. With m=0 the working action is a power of w and cannot be q, since w fixes slot b and q does not.

For m=3 or 6, let a_j count working Q calls in global Q positions j mod 3, indexed from zero, and let s=a₀+a₁+a₂. If n_work counts working W calls, the working partition exponent at initial clock t is

    n_work+2s-a_(2-t mod 3).

Equality for all three initial clocks requires a₀=a₁=a₂ modulo three. Each a_j≤2, so these are integer equalities and s is zero, three or six. Zero cannot give q. If s=3, each residue appears once among the working calls, so r occupies each of their three possible positions as the initial clock varies. Equality between adjacent placements, after cancelling the common prefix and suffix, would require

    q w^e r = r w^e q

for the number e of intervening working W calls. Auxiliary calls act on a different register and contribute no factor to this working equation. Substitution and cancellation reduce it to q w²=w² q, which is false: the two actual slot permutations move b differently. This excludes three working Q calls for any number or placement of intervening W calls.

Only six working Q calls and one W remain. All Q calls then act on working data; the W must also be working, since one W_aux with no auxiliary Q would change some admitted y. The candidate is A^j W_work A^(6-j). Choose initial clock t=2-j modulo three, putting the W at clock two. At clock two A³ has phase w² and A⁶ has phase w. Writing the prefix phase as h, the full candidate phase is h w² h⁻¹. For j modulo three, h is respectively id, q, q² followed by a power of w², which cancels in this conjugation. The three possible results are

    w²,       q w² q²,       q² w² q = w q².

Their fixed slots are b,c,a respectively, whereas q fixes d. None gives the required full action. All words shorter than ten are excluded, and T attains ten. The same lower bound holds for the smaller alphabet without W_aux. It is a proof about the stated words, not a physical time or energy bound or a bound for controllers with additional observations.

The result closes VC100n's primitive-program question while preserving its weighted macro minima. N and T agree as complete transformations, but cost 83 and 10 in their respective implementations. It also preserves VC100k's single-register obstruction: that target advances the clock by one, whereas T returns it. Those are different complete questions.

P itself is a useful closed operation: P(x,t,y)=((wq²)(x),t,y), costing seven calls. Since q=w(wq²)w², P and W_work generate all twelve working actions while returning the entire context after every call. Every word over this pair acts as (g(x),t,y); equal working actions imply equal full boundary transformations. This does not identify their contact histories or costs, and seven is not claimed here as a general basis optimum. The pure phase factor already existed as N,W_work in VC100n; these primitive paths give it a substantially less expensive implementation.

`PrimitivePhaseReturn.swift` constructs P and T from the actual reached `PhaseCyclingContacts`, with generic working fields and an arbitrary carried structure. Parametric `Endpoints: Null` witnesses derive the short boundaries from the full paths. The consumer ties T to the independently defined q, compares its complete endpoints with N, and constructs T³ as a whole return. Refusals separate P from q, full context return from identity on the working register, and q w² from w² q. The all-word lower bound is the mathematical argument above; no runtime search or exhaustive Swift word enumeration is used as its foundation.

### VC100p

**VC100p (a complete basis preserving all twelve optimal costs).** Use exactly VC100o's four primitive contacts, fixed forward programs, unknown initial clock and complete return contract on C, with |X|,|Y|≥2. Write v=wq² for the phase action of the seven-contact P. Let c_primitive(g) be the least primitive cost of (x,t,y)↦(g(x),t,y), and let c_basis(g) be the least cost over P,W_work with weights seven and one. Then

    c_primitive(g)=c_basis(g) for every g in A₄.

The complete profile is below. Tuples describe output payloads from (A,B,C,D), rather than forward destinations of individual slots.

| Word | Working output | Both minimum costs |
| --- | --- | --- |
| I | (A,B,C,D) | 0 |
| W | (D,B,A,C) | 1 |
| WW | (C,B,D,A) | 2 |
| P | (A,D,B,C) | 7 |
| PW | (C,D,A,B) | 8 |
| PWW | (B,D,C,A) | 9 |
| WP | (D,C,B,A) | 8 |
| WPW | (A,C,D,B) | 9 |
| WPWW | (B,C,A,D) | 10 |
| WWP | (C,A,B,D) | 9 |
| WWPW | (D,A,C,B) | 10 |
| WWPWW | (B,A,D,C) | 11 |

The three powers of w and the nine distinct w^i v w^j, 0≤i,j≤2, give all twelve actions. A basis word with at least two P calls costs at least fourteen, exceeding every displayed upper bound. A word with one P reduces its surrounding W powers modulo three, and the nine resulting actions are distinct. Thus its minimum is exactly 7+i+j. Words with no P give only the three powers of w. This proves c_basis.

Here is a primitive lower bound for the entire profile. Only competitors of cost at most ten need exclusion. Clock return allows m=0,3,6,9 Q calls. For m=3 or 6, VC100o's working-position argument still applies to any fixed working action, not only q: zero working Q calls give a power of w; three are incompatible with clock independence. Hence an action outside H={id,w,w²} with m=6 must use all six Q calls on working data. For a shortest such program, auxiliary W calls can be removed: with no auxiliary Q they must sum to a multiple of three to return arbitrary auxiliary data, and commute with all working calls. It remains to classify short one-register words with six Q calls.

A small exact coordinate representation makes that classification transparent. Label the four slots b=0,a=1,c=z,d=z² in characteristic two, with z²+z+1=0. These are labels for the existing four-slot permutations:

    w(s)=z s,       q(s)=z² s+1,       r(s)=z s+1.

No extra physical or contact law is being assumed. Write a six-Q word as

    W^g₀ A W^g₁ A W^g₂ A W^g₃ A W^g₄ A W^g₅ A W^g₆,
    n=g₀+...+g₆,       c_j=z^(g_(j+1)+...+g₆),   j=0,...,5.

Its multiplier is z^(n+1). The vector of additive terms across initial clocks zero, one, two is exactly

    (z²c₀+c₃)(1,1,z)
      +(z²c₁+c₄)(z,z²,z²)
      +(z²c₂+c₅)(1,1,1).

Each Q contributes one, multiplied by all subsequent Q/W multipliers; grouping the six contributions in pairs three positions apart gives this formula. Differences of the first two components, then of the last two, show that clock independence is equivalent to

    g₁+g₂+g₃ = 1 mod 3,
    g₂+g₃+g₄ = 1 mod 3.

When these hold, the common additive term is

    z^g₆ (z^(2+g₃+g₄+g₅)+1).

For n≤2 the two sums must equal one as integers. Put h=g₁=g₄; then g₂+g₃=1−h and n=1+h+g₀+g₅+g₆. Substitution yields the full small-cost classification, without a program search:

| Working W calls n | Clock-independent actions of six working Q calls |
| --- | --- |
| 0 | none |
| 1 | w², v |
| 2 | id, wv, vw |

One more possible shortcut needs exclusion. With nine Q and no W, a complete-return word has total partition exponent zero. Let a_j count working Q calls in the three global Q residue classes. Clock independence and zero working exponent require each a_j=0 or 3. If one residue class is used, all three working contacts have the same law and cube to identity. If two classes are used, choose the initial clock making the omitted class the r class; all six working calls are q, again giving identity. If all three classes are used, choose initial clock two: A³ has phase w² and A⁹ has identity phase. With no working class the phase is also identity. Thus any fixed working action from such a complete-return word must be id.

To finish, the primitive total partition exponent for m=3k Q and n W calls is n+2k modulo three. For a complete return it equals the exponent of g, since the auxiliary permutation is identity. Outside H, the three exponent classes in the displayed profile are:

- exponent two: v at cost seven, and two other actions at cost ten;
- exponent zero: wv,vw at cost eight, and w²vw² at cost eleven;
- exponent one: all three actions at cost nine.

For m=6 the congruence and the small-cost classification exclude every cheaper candidate: n=1 gives only v outside H, n=2 gives only wv,vw, and n=0 gives none. The next possible n in each class is three larger. For m=9, n=0 was just excluded outside H; n=1 or 2 has the wrong exponent to beat any remaining bound (or already costs at least that bound). Cases m=0,3 were excluded outside H above. The minima for I,W,WW are immediate. This proves the full equality of the two cost profiles.

The seven-contact threshold proposed after VC100o follows as well: any individually context-returning, clock-independent command costing at most six has action in H. Arbitrarily many such commands still generate only H. P and W reach A₄ with maximum command cost seven, so seven is the least possible maximum command cost for this kind of complete interface.

Cost preservation means that an optimal realization is available within the basis for every specified final action. It does not mean that every basis word is optimal: P² and WPW have identical full endpoints, but cost fourteen and nine. Nor may they be exchanged in a question requiring the same intermediate observations. The theorem fixes complete boundary actions, the stated primitive alphabet and its cost, rather than all possible tasks.

`PhaseBasisProfile.swift` builds the twelve actual paths at each clock using the existing seven-contact P and actual W steps. The suffix helper requires only the actual intermediate source; it assumes no phase meaning for an arbitrary supplied prefix. The concrete instances supply that source from P's proved clauses. The consumer compares all complete outputs with the independently existing `PhaseWordCatalogue`, checks their common full sources and derives P²=WPW as an endpoint equality. Refusals reject merging distinct equal-cost actions and reusing P at the pre-W source. The general lower bounds remain the symbolic proofs above, not runtime enumeration or cost labels asserted as extra type premises.

### VC100q

**VC100q (four local replacements give a unique optimal boundary word).** Retain VC100o–p's fixed complete carrier, known contact laws and costs: W costs one and P costs seven. Words are performed from left to right. The following replacements preserve the complete endpoint at every source, including the original clock and the arbitrary retained context:

| Replacement | Old cost | New cost |
| --- | --- | --- |
| WWW → I | 3 | 0 |
| PP → WPW | 14 | 9 |
| PWP → WW | 15 | 2 |
| PWWP → WWPWW | 16 | 11 |

Here I is the empty word. These are equalities of applications on the complete carrier, not just of their working projections. For example, P has payload action (A,B,C,D)↦(A,D,B,C). Thus PP and WPW both yield (A,C,D,B), PWP and WW both yield (C,B,D,A), and PWWP and WWPWW both yield (B,A,D,C). Every constituent returns the clock and context. WWW returns the payload as well. No unobserved residue is discarded.

*Termination and uniqueness.* Every replacement strictly lowers the nonnegative integer cost. Hence every sequence of replacements terminates. An irreducible word has no W run of length three. If it had two P letters, take consecutive P letters: the intervening W run has length zero, one or two, giving one of the other three reducible patterns. Consequently the irreducibles are exactly

    I, W, WW, and W^i P W^j for 0≤i,j≤2.

VC100p supplies twelve distinct complete actions for these twelve words, when the payload domain has at least two values. Every replacement preserves the action, so any two terminating reductions of the same word must reach the same irreducible word. This establishes uniqueness independently of which available replacement is chosen first; no priority policy or enumeration of overlapping replacements is required. Equivalently the formal four-label actions separate the normal words, even when a particular payload tuple happens to contain repeated values.

VC100p also proves that each normal word has minimum cost among all fixed forward primitive words with the same complete action. Thus reducing a basis word reaches a primitive-optimal realization of its action. The largest resulting execution cost is eleven. This does **not** bound the cost of reading or reducing an arbitrarily long input word: each step decreases cost by at least three, giving only the separate elementary bound of floor(initial cost/3) replacements. It is not a complexity bound for finding a reducible occurrence or for the compiler.

*Replacement in context.* Let F and G be the two actual applications being substituted, with F.Left=G.Left and F.Right=G.Right. If an actual prefix ends at F.Left and a suffix starts at F.Right, the same two seams also admit G. The two complete composites then have the same input and output. This argument requires neither the entire intervening contact history nor a new equality premise about the composite outputs. It does require that the endpoints include every relation on which the continuation depends. A logger or instrument responding to intermediate contacts changes that question: PP and WPW already differ after their first macro contact.

`PhaseBasisReduction.swift` constructs all four longer paths at each clock from the actual prior P and W applications, and derives their full input/output equalities with the shorter paths. `EndpointSubstitution` constructs both surrounding composites from the replacement's own endpoint equality and the old seams; the new seams are consequences. The consumer checks all clock clauses, a nonidentity prefix and suffix, and rejects erasing the remaining WW action or inferring equal intermediate readings. The termination, uniqueness and cost arguments are the proofs above; the types do not pretend to execute a normalization algorithm or certify a cost by naming it.

This closes the normalization problem for the supplied interface. Its next application problem is different: when W and P are unknown contacts, which acquired relations justify these same replacements? Passing a local return observation alone must not be substituted for their full applicability.

## Cross-page mentions

Labels mentioned here: <doc:verdict_is_invariant__action_interfaces#VC100k>, <doc:verdict_is_invariant__action_interfaces#VC100m>.
