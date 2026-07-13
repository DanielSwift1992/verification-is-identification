# Purpose

To make correctness the cheapest thing to build — a notation where writing a structure down is the whole of proving it right.

## Overview

**Compile is proof.** You write a claim as a `protocol`. If it compiles, it is true. If not, it is false. Nothing runs, and no separate step proves it. The compiler can decide because the system is stated in exact, finite terms: every degree of freedom is a written type, so the type checker decides every question the code states, at build time.

**What it buys.** The usual way to trust a system is to build it, prove something about it, and keep the two in step. The proof is a second artifact, and it drifts. Here the system and its proof are one text: the compile is the whole proof, and every build re-proves every stated claim.

**What it costs.** Only the exact, finite, determinate part of a system fits. Turning a claim into that typed structure is the work that stays human. And whether you stated the right rule stays yours to judge: the build checks consistency with what you stated.

**One game under all of them.** Whatever you build, a company or a schedule or a learner, its determinate part is a finite structure, and finite structures play one game: draw a distinction, or close one (``Pair`` and ``Null``). Those are the only two moves. The rules of that game are the framework, your system is a position in it, and the rules are what every position already obeys. Nothing stands over the board.

**Trust grows one part at a time.** You need not convert the whole system. Write the one part you must be sure of, and it holds while the rest stays craft: the line between them sits exactly where the types stop.

**The record shows itself.** The types the compiler checks are the pages the reader browses: every page of this documentation is a type's rendered name, re-derived at each build. Documentation, reports, and audit are readings of the one record, with nothing beside it to fall out of step. The projection is written out in <doc:record_is_system>.

**Why it is cheap.** Every step is borrowed or free. The grammar fits a page (``Law``) and is learned in minutes. The proof checker is a compiler you already run, so its soundness is inherited rather than re-earned. And the grammar leaves the writer almost no choices (Law §0′): the same claim becomes the same code in any hand, so the only thing to review is whether the claim is true.

## The boundary

It is not a language, a proof assistant, or the most powerful tool.

| Taken for | What it is | The line |
| --- | --- | --- |
| a language | a notation to record structure in | nothing runs (Law §0′), so there is no program, only a form the compiler reads |
| a proof assistant | a way to write the thing that cannot be wrong | a proof assistant proves a theorem you pose. Here correctness is the system's own shape. |
| the most powerful tool | the cheapest tool that stays certain | the axis is least barrier, not greatest power |

> Note: A proof assistant asks how much you can prove. This asks how little it can cost to be sure. The same structure could be proved more powerfully elsewhere, but here it is proved more cheaply, and the cheap proof is the one that gets written.

## Where this goes

**To build your own:** <doc:Encoding> maps your part of a system onto the notation, and ``Law`` is the grammar you write in — one seed, two moves, one floor. **To see it at scale:** the [Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization) showcase is two hundred people, an access policy, and the company's whole site proved by one build. **To see why it holds:** <doc:verification_is_identification> proves the result from one postulate, <doc:existence_is_finite> grounds it, and <doc:play_is_proof> is the game played whole. The papers behind each claim are gathered in <doc:Sources>.
