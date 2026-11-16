# Learning: What Is Established

This page gathers, in one order, what the papers state about learning. It adds no claim. Each line names a statement and links to it. The wording, premises and scope are in the paper.

## Overview

1. **What a learner knows.** The candidates compatible with every retained answer. A question is settled when it is constant on that set, even if several candidates remain. <doc:learning_is_liquid#LQ0>
2. **Three different changes.** A retained record, an excluded possibility and a cheaper computation. A successful computation can make none of them. <doc:learning_is_liquid#LQ3>, <doc:learning_is_liquid#LQ8>
3. **What is settled remains settled while the record only retains.** <doc:learning_is_liquid#LQ2>. The count of settled questions does not fall and can remain constant. <doc:learning_is_liquid#LQ9>. Current coverage differs from a retaining ledger: coverage need not grow across model updates. <doc:architecture_of_learning_machines#AI7>
4. **When a question settles.** Exactly when every candidate with another answer is eventually separated by a queried key. <doc:learning_is_liquid#LQ11>
5. **Soundness, coverage and retention are separate obligations.** <doc:architecture_of_learning_machines#AI6>
6. **Answering without knowing the state.** A belief with one answer label is sufficient. <doc:verdict_is_invariant__discovery_acquisition#VC30>, <doc:verdict_is_invariant__discovery_acquisition#VC31>
7. **How much must be kept.** The residual needed for prediction. <doc:verdict_is_invariant__recovery_memory#VC24>. An exact learned representation can be smaller than the state it had to acquire. <doc:architecture_of_learning_machines#AI15>
8. **Saturation is relative to the interaction family.** <doc:architecture_of_learning_machines#AI9>, <doc:verdict_is_invariant__discovery_acquisition#VC38>, <doc:verdict_is_invariant__discovery_acquisition#VC39>. An added capability can split an object. <doc:verdict_is_invariant__finite_records#VC16>
9. **A new question.** It needs either a different reading of old memory or one additional acquisition. <doc:verdict_is_invariant__relative_questions#VC80>, <doc:architecture_of_learning_machines#AI18>. An intervention changes what retained knowledge must determine. <doc:architecture_of_learning_machines#AI14>
10. **Transfer and reuse.** An answer is carried across representations when each link preserves the question. <doc:verdict_is_invariant__discovery_acquisition#VC36>. Reusing evidence requires its applicability relation, which can itself be acquired. <doc:architecture_of_learning_machines#AI12>, <doc:architecture_of_learning_machines#AI13>. Current agreement does not identify acquisition. <doc:learning_is_liquid#LQ8a>
11. **Loss.** An exact late answer cannot emerge from a boundary that merged its source distinction. <doc:continuation_carries_the_relation#E2>
12. **Without a reset.** Finite reversible operations preserve the possibility of discovery, and an exact finite image of a reversible whole is reversible. <doc:verdict_is_invariant__discovery_acquisition#VC27>, <doc:verdict_is_invariant__recovery_memory#VC20>. Pairwise distinguishability need not give one successful experiment. <doc:verdict_is_invariant__discovery_acquisition#VC26>
13. **Finite and infinite.** An infinite table differs from a finite generative description. <doc:learning_is_liquid#LQ1>
14. **Learning a law from observed transitions.** Candidates of a declared finite family are compared with the witnessed cells, and the survivor is the actual law only if the actual law belongs to the family. <doc:law_is_target#LT4>. Ambiguity is an exploration address. <doc:law_is_target#LT5>. A sound observation can only remove candidates. <doc:law_is_target#LT6>. With the state hidden and a bound of places declared, the wrong answers have a count. <doc:law_is_target#LT16>
15. **The record itself.** A retaining emission keeps each earlier record at its prefix address, and a question is carried through the retained history. <doc:program_is_path#PiP2>, <doc:program_is_path#PiP2a>

Several of these statements are about a declared, known model. Whether a participant can acquire what they describe is a separate obligation. <doc:EntryAcquisition> groups the statements by what the participant does not know.
