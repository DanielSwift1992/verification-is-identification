# Purpose

To make correctness the cheapest thing to build — a notation where writing a structure down is the whole of proving it right.

## Overview

**What it buys you.** Write the part of a system you need to be sure of as types, and the compiler checks it for free: every contradiction in the structure becomes a build error, and a wrong version does not build. You give up scope: only the exact, finite, determinate part fits, and the rest stays craft. You gain certainty for the price of a build.

**One game under all of them.** Whatever you build, a crystal or a schedule or a learner, its determinate part is a finite structure, and finite structures play one game: draw a distinction, or close one (``Pair`` and ``Null``). Those are the only two moves. The rules of that game are the framework. Your system is a position in it, and the rules are what every position already obeys. Nothing stands over the board.

**The cost of being sure.** The usual way to trust a system is to build it, then prove something about it, then keep the two in step. The proof is a second artifact. It can drift from the system it describes, and holding them aligned is a cost of its own.

**The move is the proof.** Writing your system in the notation is making the game's moves, and the compiler is the referee: a position that compiles is a true one. The compile is the whole proof, so there is no second artifact to keep in sync.

**The record shows itself.** The types the compiler checks are also what the reader browses: every page of this documentation is a type's rendered name, re-derived at each build. Documentation, reports, audit — readings of the one record, with nothing beside it to fall out of step. The projection is written out in <doc:record_is_system>.

**Trust grows one part at a time.** A part you write in the notation is a part you can trust: the compiler checked it, and a wrong version would not build. You need not convert the whole system. Write down the one part you must be sure of, and it holds while the rest stays craft. The line between them is visible, exactly where the types stop. Each further part you move in widens the part you can trust.

> Note: One act does two things. Writing a part down certifies it, and it lays out the part's legal forms — the positions that conform — then collapses them to the one that survives. What secures the part also maps it.

**Why it spreads.** A method spreads when each step to adopt it costs less than the last. Here every step is borrowed or free: the grammar is learned in minutes, the proof checker is a compiler you already run, the check is a build, and the soundness is the compiler's rather than yours to re-earn. Correctness is no longer something you add afterward. It is the structure you already wrote.

## The method

Five principles. The first four each remove a cost. The last names the one that stays.

#### Compile is proof

You write a claim as a `protocol`. If it compiles, it is true. If not, it is false. Nothing runs, and no separate step proves it.

#### Pin every choice

The grammar leaves the writer almost no choices: no style, no idiom, no second way to say one thing (Law §0′). The same claim becomes the same code in any hand. The only thing to decide is the claim, and the only thing to review is whether it is true.

#### Borrow the engine and its trust

The proof checker is an off-the-shelf compiler, and its soundness is inherited rather than re-earned. You stand on a tool that millions already run and already believe.

#### The grammar fits a page

One seed, two moves, one floor: the whole notation lives in ``Law``, learnable in minutes. Writing it is a skill, not a degree.

#### Verification is free, encoding is craft

Checking a written structure costs a build, and the machine does it. Turning a claim into that structure is the work that stays human. The framework draws the line, naming where its guarantee stops and your craft starts.

## The boundary

It is not a language, a proof assistant, or the most powerful tool.

| Taken for | What it is | The line |
| --- | --- | --- |
| a language | a notation to record structure in | nothing runs (Law §0′), so there is no program, only a form the compiler reads |
| a proof assistant | a way to write the thing that cannot be wrong | a proof assistant proves a theorem you pose. Here correctness is the system's own shape. |
| the most powerful tool | the cheapest tool that stays certain | the axis is least barrier, not greatest power |

> Note: A proof assistant asks how much you can prove. This asks how little it can cost to be sure. The same structure could be proved more powerfully elsewhere, but here it is proved more cheaply, and the cheap proof is the one that gets written.

## Where this goes

Two ways on, by what you came for. **To use it:** the scheduler in [Playground](https://danielswift1992.github.io/verification-is-identification/documentation/playground) is the method in nine lines, and the [Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization) showcase is the same method at scale — two hundred people, an access policy, and the company's whole site proved by one build. **To see why it holds**, read on. The winning position — one survivor, identified — is <doc:verification_is_identification>: start there. The board it stands on is laid in <doc:existence_is_finite>: to be is to be a finite structure. And <doc:play_is_proof> is the game played whole — a legal play is a proof — read after the two it builds on. The grammar that governs every move is ``Law``, the full construction is the ``VerificationIsIdentification`` overview, and the papers behind each claim are gathered in <doc:Sources>.
