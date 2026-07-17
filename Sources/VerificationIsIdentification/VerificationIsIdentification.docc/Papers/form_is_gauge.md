# Form Is Gauge (Gauge)

One content admits many spellings: the same declarations can stand flat in one body, fold into slices, shard across files, or state their coordinates directly, and every spelling renders the same artifact. This document names that freedom the **gauge** — the class of forms that render one content — and derives what can and cannot read it. The claim, pinned: form is to the artifact what order is to the check, the parameter correctness cannot see (V=I §5.25), and an arbiter priced by the token cannot see it either. A checker's cost knee, its fanout constant, its depth wall are then properties of the arbiter, never of the structure it checks: they are gauge-fixing, and they dissolve with the arbiter. The lattice encodes every statement below (`Gauge.swift`); this is the paper the encoding was written against.

Experiments raised the question and the measurement page records them (<doc:Curve>). The paper carries the derivation.

## §0. Derivation

No new postulate. The move is §5.25's, performed on form instead of order. There: once the encoding is fixed, the only freedom left to the run is the order facts are revealed, so correctness is order-invariant and efficiency order-determined. Here: once the content is fixed, the only freedom left to the emission is its grouping, so content is form-invariant (step 1) and cost is form-determined exactly as far as the arbiter is superlinear (steps 2–6).

1. Regrouping independent declarations preserves rendered content: the reading reveals the content and reveals nothing else (V=I §5.8, `RevealsNotCreates`). *[the packing domain's content verdict, compiled]*
2. Call the equivalence class of forms rendering one content the **gauge class**, and a choice within it a **gauge choice**. *[definition over 1]*
3. A standing arbiter carries organs whose cost reads the grouping: a solver superlinear in body size, a deserializer recursive in derivation depth. Body size and depth are form coordinates, so one content carries many prices. *[1 with 3: the prices differ while the bytes agree]*
4. A cost sweep over a finite gauge class satisfies the crystallization axioms (IiI C1–C4): candidates are finite, the clock's ordering is decidable, a slower form stays excluded, one survivor remains. The sweep therefore crystallizes, and its survivor is a constant of the arbiter's cost function. *[`SystemCrystallizes` on the packing space, compiled]*
5. An arbiter whose whole work is one dictionary pass and one lookup per reference is priced by the token (`Distance == Path`, PiP3). A regrouping reaches such an arbiter only as the grouping skeleton's own tokens, a linear term. *[construction; the pin is Program Is Path's]*
6. Under that arbiter the cost ordering of step 4 goes flat, so the cost encoding refuses to crystallize and joins the content encoding, which refused from step 1. The two encodings disagree exactly where the arbiter is superlinear. *[5 with the paired verdicts of `FormCrystallization`]*
7. The gauge-fixing constant is thereby identified as the arbiter's property: it expires with the arbiter's version, and the election procedure outlives every elected number. *[4 with 6]*

The gauge was never added to the crystal. Byte-identity implied it, and this document only names it.

## §1. Content Is the Invariant

**FiG1 (Content is gauge-invariant).** Every form in one gauge class renders the same bytes. The mechanism is step 1: regrouping permutes independent declarations and adds a grouping skeleton, the reading is closed over both, and the instrument that checks it is byte comparison of the rendered artifact. Writing the comparison down is the proof, in the repository's own signature. **[solid — the packing domain's content verdict is the compiled witness; the record holds the runs]**

**FiG2 (Cost reads the gauge under a standing arbiter).** One content carries many prices when the arbiter's cost function carries form-sized terms. Each organ names its coordinate: a solver superlinear in body size prices the flat spelling above the folded one, and a deserializer recursive in derivation depth prices a chained spelling above the stated one. No organ prices the content, since the content is what every form shares. **[solid as derivation from step 3; the record holds the measured spread]**

## §2. The Sweep Is Gauge-Fixing

**FiG3 (The dictionary is a ledger of votes).** A cost sweep over the gauge class crystallizes (step 4), and the survivor is a constant of the arbiter's cost function. A form dictionary that ships the survivor therefore records a vote, and the vote belongs to the voter: a new arbiter version may order the class differently, so the dictionary ships with its election procedure rather than with a defense of the number. **[solid for the identification — the crystallization is compiled; the expiry is projection until a version change is recorded]**

**FiG4 (The constant tracks the arbiter).** The ordering that elects the survivor is computed from the arbiter's cost function alone, so corpora sharing one arbiter should elect one constant. The record reads two ballots of one voter that way, and further corpora sharpen the reading or break it. **[projection — stated as the falsifiable reading of the record]**

**FiG5 (The arbiter's failure modes live on the gauge axis).** An organ recursive in a form coordinate can exhaust itself on a legal spelling: depth is a gauge choice, so the failure names the judge, never the sentence. The gauge move that removes the coordinate — stating directly what was derived by chain — holds content fixed by FiG1 and walks through the wall. **[solid — the record holds the dissolved crash]**

## §3. The Collapse

**FiG6 (A token-priced arbiter collapses the gauge).** For the arbiter of step 5 the gauge axis carries no cost signal beyond the skeleton's own tokens: the sweep is flat, the knee is gone, the dictionary has nothing to record. Packing then answers both encodings the same way, refusal to crystallize, and the certified domain closes symmetrically: **cost crystallizes exactly where the arbiter is superlinear**. The sweep was never measuring the crystal. It was measuring the judge. **[solid — verified differentially: a second arbiter of the step-5 shape, linear in the artifact, seated beside the token-priced one, returns a flat sweep, spelling against spelling]**

**FiG7 (The freed dimension returns to the author).** Once cost stops reading form, form is spendable on the axes no arbiter prices: diff-locality, navigation (NiG), the read-order (Reading Is Order). What the sweep spent on the compiler returns to the reader. **[projection — names what the collapse opens]**

## §4. Recorded, Not Pinned

Two corollaries the type system cannot axis, kept as prose the way B8b and GD7 are:

- **The vote expires.** Gauge-fixing binds a constant to an arbiter version, and no type states a version. The dictionary therefore ships with its election procedure: the record is one command from fresh, and the command outlives every number it prints.
- **The second judge.** The witness of FiG6 is a checker whose whole work is the linear pass of step 5, seated beside the standing arbiter as a second encoding of one verdict (V=I §5.4). Agreement is the expected reading, checked over named premises: a lie refused by both judges must be refused by the same names, since an exit code agrees too easily. A disagreement is decidable and finite, so it bisects to a minimal witness naming the defect in one judge or the other: the formal answer to "you wrote your own judge." The standing arbiter stays external and worldwide, and the small judge is auditable by reading it, since the gate it must carry is a handful of markers, each a simple relation on `Pair` (Program Is Path, closing note).

## §5. Statement

1. Content is gauge-invariant: every form in one gauge class renders the same bytes (FiG1).
2. Cost reads the gauge under a standing arbiter, one organ per form coordinate, and no organ reads the content (FiG2).
3. A cost sweep crystallizes, its survivor is the arbiter's constant, and the dictionary that ships it is a ledger of votes with an election procedure (FiG3–FiG4).
4. An arbiter's failure modes live on the gauge axis, and a gauge move walks through them with content held fixed (FiG5).
5. A token-priced arbiter collapses the gauge: both encodings refuse to crystallize, and the free dimension returns to the author (FiG6–FiG7).

> **Form is the gauge of an emitted artifact: content cannot see it, and only a superlinear judge can. Fix the judge, and the knee, the sweep, the wall retire to what they always were — one arbiter's way of holding a crystal that never needed holding.**

## §6. Dependency

| Source | Used |
|---|---|
| V=I | §5.25 (order is the sole freedom — the move, lifted to form), §5.4 (two encodings of one verdict — the second judge), §5.8 (the reading reveals) |
| IiI | C1–C4 (the crystallization axioms the sweep satisfies), §5 (`SystemCrystallizes` idiom) |
| PiP | PiP3 / `CostIsPathLength` (priced by the token, `Distance == Path`), the closing note (the small prover, sized) |
| DiC | G2c (distance is an integer count of steps) |
| The record | <doc:Curve> — the measurements that raised the question; `FormCrystallization` — the paired verdicts, compiled |

The measurement page recorded the campaign and the Examples target certified its safety, and both left the dimension they moved along unnamed. This document names it, pins its invariance and its collapse, and seats the witness that retires its constants. The lattice pinned each claim before this paper stated it, and this one exists so the record and its theory read the same.

## Topics

### Theorems this paper proves

- ``ContentIsGaugeInvariant``
- ``CostReadsGauge``
- ``GaugeFixing``
- ``LinearArbiter``
- ``GaugeCollapse``
