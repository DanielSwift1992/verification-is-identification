# Merge Is Commutation (Record)

Independent edits can share their results and the evidence for those results. The useful condition concerns what the edits read as well as what they write. A shared final position need not have the same history, and a successful merge need not mean that either branch already satisfied the entire task.

## §0. Derivation

The statements below use explicit finite record interfaces, actual deterministic edits and verdicts that factor through declared inputs. These are premises about the represented operations. Whole closure alone does not supply them. G14b constructs disjoint pair applications in bare Swift. Matter M66–M67 distinguish fixed prerequisites, permitted serializations and the richer records that can retain a chosen order.

## §1. Definitions

**Definition 1 (the support).** A law has a fixed interpretation and a declared set of input entries through which its verdict factors. This set is its support. It may be conservative rather than minimal. The factorization supplies the locality premise. A written list alone does not. If a law's definition changes, that definition is part of its inputs or the change requires a new certificate.

The factorization also has a source domain. A conditional certificate transfers only between positions in that domain. VC84 shows that correlated inputs can permit several different sufficient supports with no least one. Their intersection cannot automatically replace them. VC63 distinguishes knowledge of a domain relation from possession of one answer obtained under it.

**Definition 2 (the reach).** An edit has declared read and write sets. Its applicability and its written values depend only on the read set. Entries outside its write set are preserved. Its reach includes both sets. Added laws use fresh distinct keys and fixed definitions with declared supports. Changes of namespace, entry existence or law interpretation belong to the appropriate sets. The following model does not delete or replace old laws.

**Definition 3 (independence).** Two edits F and G of the same base are independent here when each is applicable at that base and

    W_F ∩ W_G = ∅,
    W_F ∩ R_G = ∅,
    W_G ∩ R_F = ∅.

Their added-law keys must also be disjoint. For transport of verdicts without a new joint check, additionally require that no retained law's support meets both write sets, and that each added law's support misses the other edit's write set. Read sets may overlap when neither edit changes the shared inputs. All inputs that affect an edit, including a resident controller, belong to these relations.

## §2. The locality lemma

**MiC1 (a verdict is a function of the support).** Two positions in the certified domain that agree on a law's support have the same verdict for that law.

*Proof.* Its declared factorization applies the same function to the same input image. Therefore the answers agree. An edit preserving that image can reuse the verdict. Disjointness from the write set is one sufficient way to establish this preservation. QED

## §3. The commutation theorem

**MiC2 (independent edits commute).** Under Definition 3's edit conditions, applying F then G or G then F gives the same merged position.

*Proof.* G changes no input used by F, so F has the same applicability and computes the same writes before and after G. The symmetric claim applies to G. Their write sets are disjoint, so the final value at each address is F's value, G's value, or the unchanged base value in both orders. Fresh distinct law keys permit both additions. QED

Disjoint writes alone are insufficient. On a pair (x,y), let F write x←y and G write y←x. At (0,1), F then G gives (1,1), while G then F gives (0,0). Their writes are disjoint but each changes the other's input. Conversely, the sufficient disjointness conditions are not necessary for commutation: two fixed writes of 1 to the same entry commute. Overlap identifies a relation to check, not an automatic conflict.

G14b's `IndependentReadingOrders<F,G>` constructs the commutation for actual applications to disjoint pair fields. Equality concerns its input and selected final answer. Its retained operation histories remain distinct. M67's exchanges of incomparable occurrences transfer an answer only when the actual applications and their surrounding uses preserve that answer.

## §4. The transport theorem

**MiC3 (the merged verdict is assembled from the applicable parts).** Under the additional law-support conditions, with the source and destination positions in the domains of the certificates being transported, partition the retained laws into those touched by neither edit, by F alone, and by G alone. Add F's and G's new laws to their respective groups. Then

    merged verdict =
        untouched-law verdicts at the base
        AND F-group verdicts at F(base)
        AND G-group verdicts at G(base).

*Proof.* MiC1 transports each group's verdicts because the other edit preserves their inputs. Conjoining precisely these verdicts gives the verdict of the merged position. No other retained law group exists under the support condition. QED

This is not the conjunction of the two complete branch verdicts. On two bits, require x=1 and y=1. From base (0,0), one edit writes x=1 and the other y=1. The edits and law supports are disjoint. Each branch fails one requirement, while the merged position (1,1) satisfies both. `Checks/Distance.swift` realizes the same example with two independent root constructions. The joint output equals the required pair, while an attempted equality for either unfinished branch is rejected.

If both complete branches are valid, the displayed formula does imply validity of the merge. The converse needs further premises, such as validity of the base for the old laws in this fixed-law model. Without such premises it is false. When a law reads both changed regions, a new joint certificate can still establish it. The disjoint-support theorem no longer supplies that certificate.

## §5. The incremental corollary

**MiC4 (locality supplies a sufficient rechecking set).** With a valid cache for the current law interpretations, an edit can retain every verdict whose support image it preserves. Rechecking all new or changed laws and old laws whose declared supports meet the write set is sufficient. If checking law i costs at most c_i, the additional checking cost is at most the sum of those c_i, plus the cost of establishing and locating that set.

This is an upper bound, not an exact necessary amount of work. A touched law may have a conservative support, remain true under a proved invariant, or reuse a transported certificate. For example, changing both bits from (0,0) to (1,1) touches both inputs of x=y while preserving its answer. An available proof of this change can carry the verdict. Even a touched input that actually changes does not force the judge to recompute the law from scratch.

Preserving a selected answer image is insufficient if the update leaves the domain that justified its decoder. For the domain x=y, either coordinate determines their common value. Changing only x preserves the y image while invalidating that domain relation. Reuse must therefore carry the relevant domain witness or use an interface that also reflects definedness, as VC46 requires. This is an applicability obligation, not a requirement to retain every old input forever.

## §6. Three ways, one base

Given actual edits from a common base, Definition 3 supplies a sufficient commutation test and MiC3 supplies the merged verdict from addressed evidence. Differences between the final snapshots alone do not identify every read dependency of the edits that produced them. Two histories can have the same endpoints while having used different intermediate inputs.

Compatible overlapping writes can merge, and disjoint writes can still interact through their inputs or a shared law. A failed disjointness check therefore identifies an unresolved obligation. It does not decide that no valid merge exists. Entry changes, affected laws, checking cost and G2's tree distance count different objects unless an explicit encoding and cost contract identify them.

## §7. Statement and scope

MiC1 transports a law's verdict through equality of its actual input image. MiC2 derives commutation from preserved read inputs and disjoint writes. MiC3 assembles the applicable groups of verdicts, and MiC4 bounds a sufficient set of fresh checks. Each result has an explicit interface condition.

The generic pair commutation and its retained histories have actual Swift constructions. The arbitrary finite edit-system arguments are the proofs above. `EdgesCarryTheJudgement` alone does not implement this whole family, but the existence of trajectories is no longer an obstacle to representing concrete applications in the corpus. Matching an interface to a physical or software process remains part of its interpretation.

## §8. Dependency

| Source | Used |
|---|---|
| Record Is System | positions and their declared laws |
| V=I | question factorization and conjunction of specified answers |
| Distance Is Cost | G14b, actual disjoint pair applications |
| Permanence Is Resistance | M21, the separate record-retention premise; M66–M67, prerequisites and serialization |
| Verdict Is Invariant | transport through actual observations and applications |
