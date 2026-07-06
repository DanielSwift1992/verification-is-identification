# Encoding patterns

How to write a part of your own system as types, where a green build is the proof.

## Overview

The framework checks structure for free. Turning your problem into that structure is the one thing it leaves to you (Law §0′). The patterns here come from the lattice: two moves, and the few shapes a property can take.

**The two moves.** *Expand* opens an axis for each quantity (`associatedtype`). *Compress* pins its relations with `where`. Then ask the compiler. If it compiles, the part holds, and a version that contradicts itself will not build.

## The shapes are the markers

Each shape a property can take is one of the lattice's markers. Conform to the one that fits.

| Your property | The marker | How its freedom collapses |
| --- | --- | --- |
| a yes/no test | ``Decidable`` | forks to in or out |
| one determined value | ``Measurable`` | resolves to a point |
| a bounded count | ``IntegerValued`` | a ladder to ``Null`` |
| something that only narrows | ``Monotone`` | shrinks toward ``Null`` |
| something that only accumulates | ``Permanent`` | grows from ``Null`` |
| exactly one survivor | ``Unique`` | sits at the fixpoint |
| a distance between two | ``MetricProperty`` | a path through a shared midpoint |

The landing groups these as the medium. To turn a full claim into a protocol, follow the translation in ``Law`` (§T): quantity to an axis, premise to a parent, conclusion to a `where` at the fixpoint.

## A worked example

A scheduler, in three steps. Tasks run on two machines, and two conflicting tasks must land on opposite ones.

```swift
// 1. Pin one task to a machine — the seed the rest grows from.
typealias T0 = Pinned<MachineA>

// 2. Declare the conflicts. The compiler propagates the forced assignment.
typealias T1 = Conflicts<T0>   // forced to B
typealias T2 = Conflicts<T1>   // forced to A
typealias T3 = Conflicts<T2>   // forced to B
machineName(T3.self)           // "B" — derived, nothing ran

// 3. Require a conflict. It holds only if the schedule is consistent.
Require<Conflict<T3, T0>>.self      // ✅ B vs A — the schedule is proved
// Require<Conflict<T0, T2>>.self   // ❌ A vs A — will not compile
```

Checking the schedule and finding it are one act: the compiler derived the single assignment and certified it. A false schedule is one you cannot write down. The full source is in [Playground](https://danielswift1992.github.io/verification-is-identification/documentation/playground), beside ice's residual entropy and hydrogen's spectrum.

## The one caveat

The compiler proves your encoding is self-consistent, never that it matches what you meant. A wrong encoding compiles into a confident proof of the wrong thing (V=I §6: correctness is relative to the relation you wrote). The framework clears the structural bugs and hands back exactly one job: write the relation that says what you mean. That job is the craft, and it stays yours.

## Showing the part you encoded

The surface is the same discipline: a page is a type, and its markdown is the type's name. [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit) builds a page in five steps, and [Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization) is that surface run at scale — the encoded company and its site, one build.
