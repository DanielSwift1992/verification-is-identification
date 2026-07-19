# The curve

This package generates a demo company of N employees as Swift types and `swift build` type-checks all of it. This page measures how build time grows as N grows. At N = 12800 the whole build, site included, takes 199 seconds.

## Overview

The company is generated: `swift package generate org N` writes N employees, one enum per person, plus the access rules and the walk pages over them. `swift build` then type-checks every declaration — every access that must be in force, every page that must exist. The compiler is the arbiter under every guarantee, so its running time is the price of every guarantee (a second, linear checker is beside it: the second judge, below). The measurement is seconds against N, both checkers on one corpus:

![One company, two checkers: paired bars per corpus size, the build bar as wide as its seconds, the judge's hair-wide bar with its seconds in the label.](curve)

Each N carries a pair: the build's bar is as wide as its seconds, and the judge's bar is one hair wide, its exact seconds in the label. The four code layouts the build crossed to reach these numbers are the series table below.

### Why measure it

If build time grows faster than N, the approach works for demos and fails at real sizes. Model checking has fought this growth for forty years under the name state-space explosion, and this chart is that field's standard plot, taken for the Swift type checker.

The theory fixes what the chart cannot: every build terminates, because every stated space is finite. What it does not fix is the speed, so the exponent is measured, not derived.

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

The two checkers read different scopes (the build proves the whole package, the judge reads the company file alone), so the columns compare arbiters, never equal workloads. Three facts survive that caveat. The judge's growth is linear: each doubling of N doubles its time. The chained spelling, whose depth crashed the compiler (the wall above), settles link by link on a worklist and costs the same as the direct spelling at every size. And the two spellings settle identical coordinates, checked value by value. The packing sweep repeats the reading: at N = 3200 across fanouts 16, 32, and 64 the compiler reads 49, 32, and 29 seconds, and the judge reads 283, 272, and 283 milliseconds. The knee belongs to the compiler, the flat line to the judge, so the sweep the form dictionary needed is gauge-fixing for one arbiter and nothing for the other: the derivation is in <doc:form_is_gauge> (FiG6), and this page is that derivation's record.

A second judge earns trust differentially, never by assertion. `swift run Tools judge diff 200` seats both checkers on one corpus: clean, both agree, then under four planted lies (a cross-department access, a rank spelled to nothing, a site pointing at a department, a team claiming a foreign rank) both refuse, and the refusals are compared token by token: the same person, the same conflicting values, named by each judge. An exit code alone would not pass this check. `swift run Tools judge chain 6400` replays the wall's own spelling at the depth that killed the compiler, and `swift run Tools curve --judge` adds the judge's column to any measurement on this page.

### Provenance

The measurements are stated in `CurveChart.swift`, each with the run that produced it, and `swift run VectorDemo curve` redraws the figure from them. The packing itself is stated in one dictionary (`CodeForm`), and its shipped fanout is the compiler's own vote: `swift run Tools curve --fanout 16,32,64 3200` read 79, 68, and 61 seconds, so sixty-four ships. The packing space is also one of the lattice's certified domains, beside ice and the Higgs vacuum: under the cost encoding the measured packings crystallize to the one survivor, and under the content encoding they refuse to, because every packing renders the same bytes: the stated reason re-packing is safe. <doc:Neighbors> places this measurement in its literature: model checking and the state-space explosion.
