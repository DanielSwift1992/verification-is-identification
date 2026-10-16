# The curve

This package generates a demo company of N employees as Swift types and `swift build` type-checks all of it. This page measures how build time grows as N grows. At N = 12800 the whole build, site included, takes 199 seconds.

## Overview

The company is generated: `swift package generate org N` writes N employees, one enum per person, plus access assertions and declarations for the walk pages over them. `swift build` checks the presented type relations in these declarations. Curve measures the running time of this package build (a second, linear checker is beside it: the second judge, below). The measurement is seconds against N, both checkers on one corpus:

![One company, two checkers: paired bars per corpus size, the build bar as wide as its seconds, the judge's hair-wide bar with its seconds in the label.](curve)

Each N carries a pair: the build's bar is as wide as its seconds, and the judge's bar is one hair wide, its exact seconds in the label. The four code layouts the build crossed to reach these numbers are the series table below.

### Why measure it

If build time grows faster than N, the approach works for demos and fails at real sizes. Model checking has fought this growth for forty years under the name state-space explosion, and this chart is that field's standard plot, taken for the Swift type checker.

The termination theorem for the inner pipeline assumes finite enumerations and terminating evaluations and primitive checks (<doc:verification_is_identification>, §5.1 and §5.5). Swift's build time and scaling exponent are measured here.

The first series showed the growth was real: near N², so doubling the company roughly quadrupled the build.

### What each series changed

The generator can lay out the same declarations in different shapes, and the shape sets the compile cost:

| Series | The layout | The effect |
| --- | --- | --- |
| flat bodies | the company enum lists all N members in one body, which folds into a chain N deep, and every use re-walks that chain | near N² growth |
| folded into slices | members nest in slices of sixteen inside the same enum, so the chain becomes a tree of depth log N | growth fell to about N^1.7 |
| sliced and sharded | declarations split across files of ~120 and render calls across functions of 200, so the compiler works them in parallel | about three times faster, same growth |
| direct coordinates | each hire states its rank, department, and name by index, so no person's type depends on the previous person's | 12800 employees in 199 seconds, near N^1.3 |

After each change the 471 site pages were re-rendered and compared: zero bytes differed. The layout changed. The generated content did not. <doc:form_is_gauge> names this freedom and derives when it stops costing.

### Reproduce it

`swift run Tools curve 400 800 1600 3200 6400 12800` checks HEAD out into a disposable worktree, generates each company size, times each build, and prints the seconds, the growth factor per step, and the implied exponent. Any point on the chart reproduces in one command.

### The wall that fell

At N = 6400 the third layout hit a wall: the Swift frontend aborted (signal 4) during module emission, on legal code. Bisection reduced the crash to one person: the generator typed each hire's rank from the previous hire's, so one person's serialized type was a chain as deep as their index, and the compiler's deserializer unwound it one stack frame per link. The fourth layout states each coordinate directly by the same rotation formulas, the render is byte-identical, and the wall is gone: 12800 employees, the full package, 199 seconds. A legal program should not crash its compiler, and the reduced case is kept for a standalone report.

### The second judge

The package carries a second checker beside the compiler: `swift run Tools judge` reads the generated company file, resolves every reference through one dictionary of declarations, and checks every access premise as a table row. No solver runs. The corpus the compiler proves in seconds is judged in milliseconds:

| N | `swift build`, full package | the judge | the judge, chained spelling |
| --- | --- | --- | --- |
| 3200 | 34 s | 0.28 s | 0.27 s |
| 6400 | 82 s | 0.55 s | 0.55 s |
| 12800 | 199 s | 1.10 s | 1.09 s |

The checkers read different scopes: the package build and the company file. These columns therefore do not compare equal workloads. At the three measured sizes, the judge's times approximately double with N, and the chained and direct spellings give similar timings and matching checked coordinates. The reported packing sweep at N=3200 across fanouts 16, 32 and 64 gives compiler times of 49, 32 and 29 seconds and judge times of 283, 272 and 283 milliseconds. These observations show different sensitivity on the sampled cases. They do not establish exact cost invariance or a universal complexity law. <doc:form_is_gauge> (FiG6) states the factorization condition that cost invariance would require.

A second judge earns trust differentially, never by assertion. `swift run Tools judge diff 200` runs the compiler and the second checker on the generated company, first unchanged and then with four deliberate input errors: a cross-department access, a misspelled rank, a site pointing at a department, and a team claiming a foreign rank. For each altered input, the test requires both checkers to reject it. It also checks that the judge's refusal premises and the compiler's build output contain every string selected for that case: person and coordinate names, or just `Misspelled` for the misspelled rank. These are substring checks. An exit code alone would not pass this check. `swift run Tools judge chain 6400` uses the second checker to check the chained rank spelling at the size that crashed the compiler and compare its coordinates with the direct spelling. `swift run Tools curve --judge` adds the judge's column to any measurement on this page.

### Provenance

CurveChart.swift supplies the plotted scaling measurements, and `swift run VectorDemo curve` redraws them. This page also records a packing sweep of 79, 68 and 61 seconds for fanouts 16, 32 and 64 at N=3200. CodeForm ships 64 and describes another timing in its comments. These are historical reported comparisons, not one immutable cost function. No fresh sweep is implied by this text. Form Is Gauge FiG3–FiG3a separates a recorded minimum from a robust minimum with candidate coverage and uncertainty bounds. Its FiG1 gives the conditions for content-preserving reassociation. The legacy FormCrystallization declarations do not prove either obligation. <doc:Neighbors> places the measurements beside model checking and state-space explosion.
