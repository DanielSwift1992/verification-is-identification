# Proposal Is Order (Generation)

A proposed candidate and a certificate about it are different objects in one system. Proposal order affects which candidates are reached and what work is spent. Checking establishes the declared relation for the actual candidate and evidence. This paper connects those roles without claiming that generation contains no information, that checking is automatically cheap, or that every efficient proposal method requires a clustered metric.

## §0. The Interface

Fix the candidate grammar, available observations, acceptance relation and charged operations. A proposal policy uses its current input and record to construct a candidate. A checking application returns evidence about that candidate. The next proposal may depend on that evidence. Both therefore share context and can be coupled through the history. Their formal separation does not prove disjoint physical mechanisms or probabilistic independence.

## §1. Proposal and Certification

**GD1 (Order alone does not add an observation).** Rearranging the same known candidates without a new observation does not change which candidates satisfy a fixed predicate. It can change when an acceptable one is encountered. A policy reading additional task structure or retained evidence can extract a distinction and must account for that reading. Thus the limited statement about order does not mean every generator carries zero information. The relevant distinction is between reordering given information and obtaining another answer within the whole.

**GD2 (Different relations).** A confusion family records which observations distinguish candidates. A loss associates candidates with output differences on specified examples, as in G13. Both can depend on the same applications and evidence. Neither description alone supplies the proposal policy, complete candidate coverage or the cost of evaluating the observations.

## §2. Different Obligations

**GD3 (A fitting proposal need not identify a rule).** Several rules can agree on every available example. Producing one of them satisfies that output test, but leaves the intended rule unidentified within the declared family. V=I U2 requires separating evidence or a justified equivalence of the remaining alternatives. Conversely a supplied unique survivor does not by itself provide a cheap method for constructing or finding it from the permitted input.

These are distinct obligations. The former examples about primes and ambiguous rules did not establish universal easy/hard complexity quadrants: a binary acceptance predicate does not exclude a useful generator, and ambiguity does not prove expensive verification. Any such complexity comparison must fix the input access, allowed operations, distributions and cost unit.

## §3. Retention and Proposal Cost

**GD4 (Coverage does not force optimal ordering).** IiI CS1–CS3 separate retained class coverage, dispatch and efficiency. A complete library can support reusable answers while its implemented dispatcher remains expensive. Full finite query tables can make an optimal decision policy a finite optimization problem, but a class list alone does not supply those tables or the optimum. Therefore no unconditional convergence to optimal checking or generation follows from retention and finite classes.

For a fixed task, encoding, candidate domain, loss definition and sampling weights, a correlation statistic computed from those fixed quantities does not change when more tested candidates are recorded under those fixed premises. Changing the sampling weights, available operations, encoding or proposal policy is a different experiment. Retention can improve what the policy knows without altering a fixed mathematical loss function.

**GD5 (Efficiency is not a correlation coefficient).** G10a gives the exact check-count comparison for an actual candidate order: its mean accepted rank versus the random-order baseline, with additional accounting for variable check and ordering costs. GA6 already exhibits why correlation alone does not establish a descending path or exclude decodable information. Feature entropy, target-distance correlation and expected proposal cost are not one quantity. G12 likewise rejects metric clustering as a necessary condition for exact reusable construction.

## §4. Failures, Factorization, Monism

**GD6 (Failure reports need their own witnesses).** An explicitly covered empty candidate domain supports EMPTY. Distinct surviving candidates support ambiguity. An exhausted work budget supports BUDGET. These reports do not identify a unique failed component: a representational gap, inadequate observation or costly search can interact. Failure to produce a candidate is not a proof that none exists.

**GD7 (A conditional implementation split).** E2 specifies sufficient conditions for an anchored-search implementation. C3 is optional representative economy, while actual applications, adequate identification and access to an accepted candidate are necessary for that implementation's promised result. The encoder/backend split does not localize all difficulty to the encoder and does not force every solver to route through metric balls. Checking and interpretation remain substantive obligations.

**GD8 (Both roles belong to the same whole).** Proposal, checking, records and observers are internal relations. Within a chosen comparison-based implementation, different projections of its trace can describe selection and verification. This is consistent with relational closure. It does not derive that every physical mechanism is the same operation or authorize erasing the records and observations on which a proposal depends. PP15's scope and Verdict's application seams remain applicable.

**GD9 (Infinite reach does not eliminate lookup or compilation).** A
finite table cannot list every distinct member of an infinite reachable
domain. This does not prevent caching a useful finite subset or applying
a compact algorithm to infinitely many inputs. A finite generating set
supplies eventual compositional reach under its semantics, not a fixed
word budget or a free execution path (Basis B6–B8).

A candidate can be proposed in one attempt even when its primitive word is
long. Conversely many short candidates can be tried before finding one.
Thus candidate attempts have no generic lower bound equal to solution word
length. Efficiency must name its charged operations, search distribution,
macro definitions and stored records. The bounded-basis counterexample
makes these costs distinct within a complete reversible machine.

## §5. Boundaries

Exact reuse requires the relevant question to factor through the retained representation, as in Verdict §6c. A metric neighborhood is one possible search aid. It does not replace that factorization or identify undeclared behavior from examples. Sound application and model premises apply equally to a candidate found by enumeration, a generic constructor, or a statistical proposer.

## §6. Statement

Proposal and certification can be separate interfaces while sharing inputs and records. A candidate fitting examples need not be uniquely identified. Retention can support reuse without optimizing dispatch. Expected proposal cost, loss correlation and metric covering number measure different relations. The useful common requirement is a supplied application connecting the actual input, construction, evidence and answer.

## §7. Dependency

| Source | Used |
|---|---|
| V=I | U1–U2, membership and adequate identification |
| IiI | CS1–CS3, coverage, dispatch and efficiency |
| InI | question selection and actual observation costs |
| GA | GA6, correlation versus supplied descent conditions |
| DiC | G10a actual proposal cost, G12 approximation versus exact reuse, G13 actual outputs |
| Verdict | §6c question factorization and application seams |
| B | B6–B8, bounded reach and charged execution |
| PP | PP15, scope of internal comparison |
| E2 | E2.1 conditional solving and E2.4 sufficient architecture |

The historical interface names are retained. Their protocol intersections do not by themselves establish the semantic and operational premises stated above.

## Topics

### Related type declarations

- ``DiscriminatorAndGenerator``
- ``OrthogonalOrgans``
- ``InevitabilityIsDiscriminator``
- ``OrgansAreOneCompare``
