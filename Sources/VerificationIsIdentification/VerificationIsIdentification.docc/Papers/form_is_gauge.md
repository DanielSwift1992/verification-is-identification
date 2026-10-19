# Form Is Gauge (Gauge)

A rendered artifact can have several source representations. Call two forms equivalent when a specified renderer gives them identical bytes. This paper studies that equivalence, transformations that preserve it and the cost of checking particular representatives. The renderer, candidate domain, workload and cost law must be specified. Gauge.swift names interfaces, while the equations and conditional arguments below establish their intended scope.

The historical measurements are recorded on [the curve page of the showcase](https://danielswift1992.github.io/verification-is-identification-showcase/documentation/organization/curve). They motivate the question without proving a universal preferred packing.

## §0. Derivation

1. Fix a renderer R and define f ~ g exactly when R(f)=R(g).
2. To establish preservation of a class by a transformation, prove R(T(f))=R(f) on its admitted domain. Naming the class does not prove this equation.
3. Fix a nonempty finite candidate set F and a cost function C for a specified workload and environment. A minimum exists, but need not be unique.
4. If one candidate has strictly smaller cost than every other candidate, it is the unique minimum in F. Coverage and the strict comparisons are the necessary links.
5. If cost is constant on each R-class, equivalent forms have equal cost. Linear asymptotic growth alone does not establish this invariance.

## §1. Content Is the Invariant

**FiG1 (Content equivalence and preservation).** Equality of rendered bytes is an equivalence relation. A concrete preservation argument is available when ordered leaves render strings, a grouping node renders the concatenation of its children and an empty group renders the empty string. Associativity of concatenation proves that reassociation preserves the rendered string. Induction on a grouping tree gives the concatenation of its leaves in order, independent of parenthesization.

The argument covers reassociation. It does not authorize arbitrary permutation, since concatenation need not commute, and it does not cover a grouping node that emits additional markup. Such transformations require their own renderer equations. Byte comparisons validate the compared artifacts. A compiled PackingUnderContent declaration with a chosen SolutionSet is not a proof of all regroupings. Equality of rendered bytes also concerns that renderer's answer, without asserting equal compile cost or every other behavior.

Interference Is Substitution IiS10 supplies a physical model of this scope requirement. Unitaries U and −U induce one standalone quantum channel, yet diag(I,U) and diag(I,−U) differ. This particular controlled extension requires a relation absent from the channel description. Controlling the order of two channel inputs is different: the fixed quantum switch is well-defined on those inputs. In the unitary case, each primitive phase appears equally in both orders and cancels from their relative operation. IiS10 derives this balance and its signed-mode static instance. An insufficient interface for one continuation can therefore suffice for another. VC15 asks for the actual preservation equation.

**FiG2 (Cost may distinguish equivalent forms).** Fixing rendered content permits study of cost differences between its forms. It does not make cost independent of content across other equivalence classes. A cost C(f,w,e) may depend jointly on form f, workload w and environment e. Holding w and e fixed defines the particular comparison. Changes in either can change its ordering.

## §2. The Sweep Is a Scoped Selection

**FiG3 (A checked minimum requires strict dominance and coverage).** For a nonempty finite F and a real-valued fixed C, let S be the set of its minimizers. It is nonempty. It is a singleton exactly when some f* satisfies C(f*)<C(g) for every g in F distinct from f*. This follows directly in both directions from the definition of a minimum. Finite candidates alone do not imply strictness. A tie-breaker defines another selection criterion.

A timing sweep supplies recorded observations. A unique least recorded duration identifies that entry within the recorded comparison. It does not establish an immutable cost ordering for future runs. The record in Curve and the comments in CodeForm describe several timings, not one context-free cost function. No new timings are inferred here. PackingUnderCost's Never coordinate contains neither the candidates nor those comparisons.

**FiG3a (Exact robustness criterion for interval evidence).** Suppose F has at least two members and each candidate's cost can independently take any value in its nonempty closed finite interval [l(f),u(f)]. Then f* is the unique minimizer for every admitted cost assignment exactly when

```
u(f*) < min { l(g) : g ∈ F, g ≠ f* }.
```

*Proof.* Strict separation puts every admitted C(f*) below every competing C(g). Conversely, if it fails for some g, the admitted choice C(f*)=u(f*) and C(g)=l(g) makes g no more expensive than f*, so f* is not the unique minimizer. QED

This condition exposes what uncertain measurements would need to establish. Overlapping intervals do not establish a robust unique winner under these premises. Correlated cost constraints can admit fewer assignments and need their own comparison. Neither arbitrary intervals nor their coverage are inferred from a single timing.

**FiG4 (A selected constant belongs to its full comparison context).** The selected fanout can depend on the corpus and environment even with the compiler version fixed. It can also change with compiler version. A reusable result therefore needs a relation between the old and new comparison contexts, as M64 requires for calibration reuse. Shipping a reproduction command makes a comparison inspectable without proving the winner invariant.

**FiG5 (A representation change can avoid a specific failure).** A proven content-preserving transformation can change depth, grouping or file layout. If the tested checker succeeds on the transformed source, this demonstrates a way around that observed failure. It does not prove every legal source tractable or every future failure a form-only phenomenon.

## §3. When Cost Ignores the Class Representative

**FiG6 (Cost invariance requires factorization).** If C(f)=c(R(f)) for a function c, then f~g implies C(f)=C(g). Conversely, if C is constant on every R-class, define c on realized outputs by c(R(f))=C(f). Class constancy makes this well-defined. Thus factorization through content is exactly the condition for cost invariance on these classes.

Linear growth does not imply that condition. If equivalent forms have different source-token counts, a cost equal to that count is linear and distinguishes them. Even a linear bound can contain form-dependent constants. Conversely, a cost equal to the square of the rendered length is nonlinear and constant on each rendered-content class. Therefore neither a unique packing minimum nor its absence characterizes superlinearity. The former claim that cost crystallizes exactly where the arbiter is superlinear is withdrawn. CostIsPathLength's coordinate equality does not supply a complexity proof (PiP3).

A nearly flat finite timing sweep is evidence about those runs. It does not establish exact factorization over every admitted form. Verdict's existing factorization relations state the relevant kind of mathematical obligation. `ContentIsGaugeInvariant` binds its form to the actual observation source of `ReadingFactors`. `CostReadsGauge` binds its form and distance to an actual cost reading's input and answer. These supplied-reading equations do not establish a complete measured cost family. `LinearArbiter` was an unused synonym of `CostIsPathLength` and is retired. `GaugeCollapse` names the original parent directly.

**FiG7 (Choice after the checked requirements).** When several forms satisfy the requested semantic and cost conditions, other criteria can choose among them: navigation, readable diffs or a stable convention. Such selection does not weaken the properties already checked. Multiple admissible choices need not be errors (PiP7).

## §4. Comparing Checkers

Agreement on a finite corpus and targeted refusals test the represented cases. Matching the same conflicting coordinates is stronger evidence than matching exit codes alone. It still does not prove equivalence over an unrestricted source language. A reduced disagreement can expose a defect relative to a stated specification. The number of primitive markers does not bound the cost of solving their constraint system, and a version can be represented explicitly when needed.

## §5. Statement

1. A specified renderer defines content classes. Actual transformations require preservation proofs (FiG1).
2. Cost belongs to a complete comparison context (FiG2, FiG4).
3. Coverage and strict dominance establish a finite unique minimum. Interval separation gives its robust form under stated uncertainty (FiG3–FiG3a).
4. Content-preserving changes can avoid particular observed checker failures (FiG5).
5. Factorization through rendered content, rather than a linear complexity label, establishes cost invariance (FiG6).

## §6. Dependency

| Source | Used |
|---|---|
| V=I | U2–U2b (supported uniqueness), Theorem 2 (membership and identification) |
| Verdict | ReadingFactors and question-specific agreement |
| PiP | PiP3 (cost units), PiP7 (admissibility and uniqueness) |
| Matter | M64 (reuse requires a relation between comparison occasions) |
| The record | [the curve page of the showcase](https://danielswift1992.github.io/verification-is-identification-showcase/documentation/organization/curve) (historical measurements), CodeForm (selected parameters) |

## Topics

### Related type declarations

- ``ContentIsGaugeInvariant``
- ``CostReadsGauge``
- ``GaugeFixing``
- ``GaugeCollapse``
