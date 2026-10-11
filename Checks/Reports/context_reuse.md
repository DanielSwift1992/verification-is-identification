# A certificate's input scope must survive reuse

Let D be tested inputs and f,g total components. Agreement f|D=g|D
survives any common deterministic postprocessing k: k(f(x))=k(g(x)) on D.
Preprocessing h is different. Agreement implies f(h(x))=g(h(x)) for all
f,g agreeing on D exactly when h(D)⊆D, provided the output alphabet has at
least two values. Sufficiency is substitution. If h sends x∈D outside D,
choose f,g equal on D and different only at that new input for necessity.
This universal criterion can be stronger than what a restricted hypothesis
family needs. It does not demand an independent measurement at every input.

## Context-complete scope

For a family H of admissible preludes, R is the least H-closed set containing
D. It is exactly the union of w(D) over finite H-words, including identity.
Agreement on R is equivalent to safe replacement after every such prelude
from D when the component output itself is observable. A common deterministic
suffix preserves that equality. For replacements at multiple occurrences,
the reachable set must also cover the operations that feed those occurrences.
This is a specified context family, not all possible programming contexts.
Effects, timing or direct access to implementation identity require their
own state and observation axes. The suffix here uses only the equal output.

The result is an application of VI VC15's operational equivalence. Enlarging
H can enlarge R and require a stronger certificate. The old certificate
still proves its original statement. This does not refute a valid global
R4 identification; it forbids silently promoting sample agreement to one.

## Fully reversible counterexample

On {0,1,2}, f=identity, g swaps 1 and 2, h swaps 0 and 1.
Both components answer 0 at tested input 0. After h, f answers 1 and g 2.
With H={g}, the reachable scope is {0}. Adding h expands it to all three
inputs. Every map used in this counterexample is a permutation.

The complete whole has 36 states: local value,
resident implementation choice, context mode and internal phase 0…2.
The first phase optionally applies h, the second applies the chosen f/g,
the third wraps the phase. Its inverse and all states are checked.
With the implementation choice uniform and local value prepared at zero,
both modes preserve one bit of whole entropy. Without h, the ready local
value carries zero bits about the implementation. With h, it carries one.
The distinction was internal all along, and a changed experiment reveals it.
The ready phase is an explicit finite window. No physical energy or hardware
implementation theorem is inferred from these tables.

Checks: 157464 function-pair/prelude cases,
216 exact domain-invariance criteria,
11178 sample-agreeing failures,
512 context/reachable-scope models and
373248 contextual-agreement pairs.
State reachability, function-composition closure and every closed superset
are checked independently on the three-state instances.

Pure Swift lifts an existing verdict through one fixed output-pair context,
deriving the new answer equality. The table witness accepts first-input
agreement and refuses to reuse it as a second-input or whole-table equality.
This is not an arbitrary higher-order context checker or compiler certification.

Prior art: [Software Foundations, behavioral equivalence and congruence](https://www.cs.cornell.edu/courses/cs4160/2019sp/terse/plf/Equiv.html).
The congruence requirement is established program semantics. The finite
criterion, VI scope linkage and explicit counterexample are written here.
No new priority for contextual equivalence is claimed.
