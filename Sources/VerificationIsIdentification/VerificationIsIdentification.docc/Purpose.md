# Purpose

To make correctness the cheapest thing to build — a notation where writing a structure down is the whole of proving it right.

## Overview

**What it buys you.** Point this at a part of a system you need to be sure of, and the compiler checks it for free — every contradiction in the structure becomes a build error, and the wrong versions refuse to build. You give up reach: only the exact, finite, determinate part fits, and the rest stays craft. What you gain is certainty for the price of a build.

**One game under all of them.** Whatever you build — a crystal, a schedule, a learner — the part of it that is *determinate* is a finite structure, and finite structures play one game: draw a distinction, or close one (``Pair`` and ``Null``). Those are the only two moves. The rules of that game are the framework. Your system is a position in it, and the rules are what every position already obeys. There is no rulebook standing over the board — there is only the board.

**The cost of being sure.** The usual way to trust a system is to build it, then prove something about it, then keep the two in step. The proof is a second artifact. It can drift from the system it describes, and holding them aligned is its own standing cost.

**The move is the proof.** Writing your system in the notation is making the game's moves. A legal position is a true one, and the compiler is the referee. A claim is a `protocol`, its proof is that the protocol compiles — the structure and its certificate are the same object. There is no second thing to keep in sync. Write it correctly and it is already proved. Write it wrong and it does not compile.

**Why it spreads.** A method is adopted when every step down the path costs less than the step before. Here each one is borrowed or free: the grammar is learned in minutes, the proof checker is a compiler you already run, the check is a build, and the soundness is the compiler's rather than yours to re-earn. Correctness stops being a tax paid after the fact and becomes the shape of what you wrote.

## The method

Five principles. The first four each remove a cost. The last names the one that stays.

- term Compile is proof: A claim is a `protocol`, its proof is that the protocol compiles, and nothing runs. The structure and its proof are one object, so correctness is not a second step — writing it is proving it.
- term Pin every choice: The grammar leaves the writer almost no choices: no style, no idiom, no second way to say one thing (Law §0′). The same claim becomes the same code in any hand, so the only thing to decide is the claim itself — and the only thing to review is whether it is true.
- term Borrow the engine and its trust: The proof checker is an off-the-shelf compiler, and its soundness is inherited rather than re-earned. You stand on a tool that millions already run and already believe.
- term The grammar fits a page: One seed, two moves, one floor — the whole notation lives in ``Law``, learnable in minutes. Writing it is a skill, not a degree.
- term Verification is free, encoding is craft: Checking a written structure costs a build, and the machine does it. Turning a claim into that structure is the work that stays human — and the framework draws the line, naming where its guarantee stops and your craft starts.

## The boundary

What this is decides what it is not. Three things it is taken for, and what it is in each case instead.

| Taken for | What it is | The line |
| --- | --- | --- |
| a language | a notation to record structure in | nothing runs (Law §0′) — there is no program, only a form the compiler reads |
| a proof assistant | a way to write the thing that cannot be wrong | a proof assistant proves a theorem you pose. Here correctness is the system's own shape. |
| the most powerful tool | the cheapest tool that stays certain | the axis is least barrier, not greatest reach |

> Note: The contrast with a proof assistant is the whole axis. One asks how much you can prove. This asks how little it can cost to be sure. The same structure could be proved more powerfully elsewhere — here it is proved more cheaply, and the cheap proof is the one that gets written.

## Where this goes

The board is laid in <doc:existence_is_finite>: to be is to be a finite structure. That a legal play is a proof is <doc:play_is_proof>. The winning position, one survivor identified, is <doc:verification_is_identification>. The grammar that governs every move is ``Law``, the full construction is the ``VerificationIsIdentification`` overview, and the papers behind each claim are gathered in <doc:Sources>.
