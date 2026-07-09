# The curve

This package generates a demo company of N employees as Swift types and `swift build` type-checks all of it. This page measures how build time grows as N grows. At N = 6400 the build takes 241 seconds.

## Overview

The company is generated: `swift package generate org N` writes N employees, one enum per person, plus the access rules and the walk pages over them. `swift build` then type-checks every declaration — every access that must hold, every page that must exist. The compiler is the only checker in this package, so its running time is the price of every guarantee. The measurement is build seconds against N:

![Build seconds against the number of generated employees: grouped bars on a log scale, one color per code layout, true seconds printed on each bar.](curve)

Horizontal axis: N, the number of generated employees. Vertical axis: seconds for `swift build`, drawn on a log scale, the true seconds printed on each bar. Each color is the same generated content in a different code layout.

### Why measure it

If build time grows faster than N, the approach works for demos and fails at real sizes. Model checking has fought this growth for forty years under the name state-space explosion, and this chart is that field's standard plot, taken for the Swift type checker.

The first series showed the growth was real: near N², so doubling the company roughly quadrupled the build.

### What each series changed

The generator can lay out the same declarations in different shapes, and the shape sets the compile cost:

| Series | The layout | The effect |
| --- | --- | --- |
| flat bodies | the company enum lists all N members in one body, which folds into a chain N deep, and every use re-walks that chain | near N² growth |
| folded into slices | members nest in slices of sixteen inside the same enum, so the chain becomes a tree of depth log N | growth fell to about N^1.7 |
| sliced and sharded | declarations split across files of ~120 and render calls across functions of 200, so the compiler works them in parallel | about three times faster, same growth |
| Organization target alone | the company and its rules, built without the demo executables that render the site | 6400 employees in 241 seconds |

After each change the 471 site pages were re-rendered and compared: zero bytes differed. The layout changed; the generated content did not.

### Reproduce it

`swift run Tools curve 400 800 1600 3200` checks HEAD out into a disposable worktree, generates each company size, times each build, and prints the seconds, the growth factor per step, and the implied exponent. Any point on the chart reproduces in one command.

### The current limit

At N = 6400 the Organization target builds in 241 seconds. The full package — the same company plus the demo executables — does not: the Swift frontend aborts (signal 4) during module emission. The same files compile when the target builds alone, so the failure sits in the compiler, not in the generated code. Two next steps: split the company across several targets, and reduce the abort to a standalone report for the Swift project.

### Provenance

The measurements are stated in `CurveChart.swift`, each with the run that produced it, and `swift run VectorDemo curve` redraws the figure from them. <doc:Neighbors> places this measurement in its literature: model checking and the state-space explosion.
