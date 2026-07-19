# The neighbors

Four known results are beside this package. Each section names one in plain words, then states the exact point of difference.

## Overview

### Partial evaluation

A partial evaluator takes a program together with the part of its input that is already known, runs everything that depends on the known part, and outputs a smaller program, called the residual. The canonical account is Jones, Gomard, and Sestoft, and it includes the degenerate case that matters here: when all of the input is known, partial evaluation is ordinary evaluation. This package is in that case on purpose. The input domain is finite and fully stated, so the build specializes the whole system over every input at once, and the residual contains no computation: pages, verdicts, and drawings. "The build is the run" is this case, stated as a slogan.

### Materialized Datalog

Datalog is a query language over facts and rules, decidable because it gives up Turing completeness. A materialized Datalog database does not search at query time: it derives every derivable fact once, ahead of time, and stores the closure, so a query becomes a lookup. The saturation this package's papers prove, a checking system that eventually contains every answer and stops computing, is that fixpoint. The difference is in the terms. Datalog forbids function symbols, while this lattice composes types: `Pair`, generic parameters. Termination is kept by the theory's floor instead: every space is finite, width by ``Pair``, depth by ``Null``.

### Total languages

In Agda, Coq, or Idris, every program provably terminates, and non-termination is an effect a program must declare. That removes one class of runtime surprise, but the programs still run, because the input arrives at run time and cannot be enumerated in advance. Here the input is finite and stated, so it can be enumerated, and running is replaced by navigating what was enumerated.

### Automaton minimization

The login keypad in the Organization showcase accepts one four-digit code out of 9⁴ = 6561. Drawn as a tree, that is thousands of states. Every wrong digit, at any depth, has the same future: the dead state. States with the same future are one state under bisimulation, the standard equivalence on state machines, and the keypad ships that quotient: five states. The papers call the move a fold (Program Is Path), the automata literature calls it minimization. One mechanism, two vocabularies.

### The combination

Each neighbor keeps its own home. The package's claim is the combination: a decidable core, a finite stated input domain, and a residual artifact, rendered, counted, and re-proved by every build.
