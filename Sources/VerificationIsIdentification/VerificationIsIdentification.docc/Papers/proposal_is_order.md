# Proposal Is Order (Generation)

A proposed candidate and a certificate about it are different objects in one system. Proposal order affects which candidates are reached and what work is spent. Checking establishes the declared relation for the actual candidate and evidence. This paper connects those roles. Generation may carry information, checking may be expensive, and an efficient proposal method may work without a clustered metric.

## §0. The Interface

Fix the candidate grammar, available observations, acceptance relation and charged operations. A proposal policy uses its current input and record to construct a candidate. A checking application returns evidence about that candidate. The next proposal may depend on that evidence. Both therefore share context and can be coupled through the history. The separation is formal: the two roles may share a physical mechanism and may be statistically dependent.

## §1. Proposal and Certification

**GD1 (Order alone does not add an observation).** Rearranging the same known candidates without a new observation leaves unchanged which candidates satisfy a fixed predicate. It can change when an acceptable one is encountered. A policy reading additional task structure or retained evidence can extract a distinction and must account for that reading, so a generator can carry information. The line runs between reordering given information and obtaining another answer within the whole.

**GD2 (Different relations).** A confusion family records which observations distinguish candidates. A loss associates candidates with output differences on specified examples, as in G13. Both can depend on the same applications and evidence. Neither description alone supplies the proposal policy, complete candidate coverage or the cost of evaluating the observations.

## §2. Different Obligations

**GD3 (A fitting proposal need not identify a rule).** Several rules can agree on every available example. Producing one of them satisfies that output test and leaves the intended rule unidentified within the declared family. V=I U2 requires separating evidence or a justified equivalence of the remaining alternatives. Conversely a supplied unique survivor needs its own method for being constructed or found cheaply from the permitted input.

These are distinct obligations. The former examples about primes and ambiguous rules are instances and establish no universal easy/hard complexity quadrants: a binary acceptance predicate allows a useful generator, and ambiguity is compatible with cheap verification. A complexity comparison must fix the input access, allowed operations, distributions and cost unit.

## §3. Retention and Proposal Cost

**GD4 (Coverage does not force optimal ordering).** IiI CS1–CS3 separate retained class coverage, dispatch and efficiency. A complete library can support reusable answers while its implemented dispatcher remains expensive. Full finite query tables can make an optimal decision policy a finite optimization problem, but a class list alone does not supply those tables or the optimum. Therefore no unconditional convergence to optimal checking or generation follows from retention and finite classes.

For a fixed task, encoding, candidate domain, loss definition and sampling weights, a correlation statistic computed from those fixed quantities is unchanged when more tested candidates are recorded under those fixed premises. Changing the sampling weights, available operations, encoding or proposal policy is a different experiment. Retention can improve what the policy knows without altering a fixed mathematical loss function.

**GD5 (Efficiency is not a correlation coefficient).** G10a gives the exact check-count comparison for an actual candidate order: its mean accepted rank versus the random-order baseline, with additional accounting for variable check and ordering costs. GA6 already exhibits why a descending path, or the absence of decodable information, needs more than correlation. Feature entropy, target-distance correlation and expected proposal cost are three quantities. G12 likewise shows that exact reusable construction can work without metric clustering.

## §4. Failures, Factorization, Monism

**GD6 (Failure reports need their own witnesses).** An explicitly covered empty candidate domain supports EMPTY. Distinct surviving candidates support ambiguity. An exhausted work budget supports BUDGET. Each report names an outcome. Several components can interact behind it: a representational gap, inadequate observation, costly search. A proof that no candidate exists needs more than a failure to produce one.

**GD7 (A conditional implementation split).** E2 specifies sufficient conditions for an anchored-search implementation. C3 is optional representative economy. Actual applications, adequate identification and access to an accepted candidate are necessary for that implementation's promised result. Under the encoder/backend split, difficulty can lie outside the encoder, and a solver can route around metric balls. Checking and interpretation remain substantive obligations.

**GD8 (Both roles belong to the same whole).** Proposal, checking, records and observers are internal relations. Within a chosen comparison-based implementation, different projections of its trace can describe selection and verification. This is consistent with relational closure. It does not derive that every physical mechanism is the same operation or authorize erasing the records and observations on which a proposal depends. PP15's scope and Verdict's application seams remain applicable.

**GD9 (Infinite reach does not eliminate lookup or compilation).** A finite table lists finitely many members of an infinite reachable domain. A useful finite subset can still be cached, and a compact algorithm can still apply to infinitely many inputs. A finite generating set supplies eventual compositional reach under its semantics, not a fixed word budget or a free execution path (Basis B6–B8).

A candidate can be proposed in one attempt even when its primitive word is long. Conversely many short candidates can be tried before finding one. Thus candidate attempts have no generic lower bound equal to solution word length. Efficiency must name its charged operations, search distribution, macro definitions and stored records. The bounded-basis counterexample makes these costs distinct within a complete reversible machine.

## §5. Boundaries

Exact reuse requires the relevant question to factor through the retained representation, as in Verdict §6c. A metric neighborhood is one possible search aid. The factorization is still required, and examples alone leave undeclared behavior unidentified. Sound application and model premises apply equally to a candidate found by enumeration, a generic constructor, or a statistical proposer.

## §6. Statement

Proposal and certification can be separate interfaces while sharing inputs and records. A candidate can fit the examples and remain one of several. Retention can support reuse without optimizing dispatch. Expected proposal cost, loss correlation and metric covering number measure different relations. The useful common requirement is a supplied application connecting the actual input, construction, evidence and answer.

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
