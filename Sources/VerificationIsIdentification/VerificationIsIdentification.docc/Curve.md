# The curve

The saturation law, measured: how the cost of proving a whole universe grows with its size, and how far each instrument moved the wall.

## Overview

The largest fully proved universe today is 6400 states, in 241 seconds, on a laptop. Every state of that universe — people, rules, walk shelves — is enumerated and proved by one `swift build`.

![The saturation curve: build seconds against universe size, grouped bars on a log scale, one bar per emitter generation, the proof frontier at 6400.](curve)

### How it is measured

`swift run Tools curve 400 800 1600 3200` runs the whole method: it checks HEAD out into a disposable worktree, generates a universe of each size, times the build that proves it, and prints the growth law. The universe generator takes the size as one argument, so any point on the chart reproduces in one command.

### What moved each line

| Line | The instrument | What it moved |
| --- | --- | --- |
| flat bodies | none: a body of N statements folds into a Pair chain N deep, and every reader re-walks that depth | the starting law, near N² |
| folded into slices | past twenty-four leaves the emitter nests slices of sixteen, so chain depth falls to the logarithm | the exponent: N^2.3 to N^1.7 |
| sliced and sharded | generated declarations write in files of ~120 and render calls in functions of 200, so the type checker works shards in parallel | the constant, about three times |
| the proof layer | the same instruments, measured at the frontier | 6400 states in 241 seconds |

Each regrouping is a fold over `Pair` sums, so counts, labels, and rendered pages stay byte-identical: 471 pages re-rendered with zero diff after every instrument.

### The frontier

At 6400 states the proof layer passes and the full site pipeline does not: the compiler's own frontend aborts (signal 4) while emitting modules of that size, and the failing job moves between runs. The wall standing today is the toolchain's, not the notation's, and the next instruments are known: splitting the universe across modules, and a reproducer for the frontend abort.

### Where the numbers live

The chart is drawn by the package's own vector engine from stated measurements, each with its provenance, and re-drawn by `swift run VectorDemo curve`. The neighbors this axis belongs to — model checking and its forty years of state-space walls — are on <doc:Neighbors>.
