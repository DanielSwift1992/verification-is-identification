# The neighbors

Five known results are beside this package. Each section names one in plain words, then states the exact point of difference.

## Overview

### Partial evaluation

A partial evaluator takes a program together with the part of its input that is already known, runs everything that depends on the known part, and outputs a smaller program, called the residual. The canonical account is Jones, Gomard, and Sestoft, and it includes the degenerate case that matters here: when all of the input is known, partial evaluation is ordinary evaluation. This package is in that case on purpose. The input domain is finite and fully stated, so the build specializes the whole system over every input at once, and the residual contains no computation: pages, verdicts, and drawings. "The build is the run" is this case, stated as a slogan.

### Materialized Datalog

Datalog is a query language over facts and rules, decidable because it gives up Turing completeness. A materialized Datalog database derives every derivable fact once, ahead of time, and stores the closure, so a query becomes a lookup instead of a search. The papers prove related coverage for a fixed task domain with a common finite rule interpretation. Once the task stream has solved and stored every class through sound retaining insertions, the library represents every class in that domain. A later task in the same domain can reuse a stored rule when an implemented dispatcher selects the required class (the Conditional saturation theorem of <doc:intelligence_is_inevitable>). The difference is in the terms. Datalog forbids function symbols, while this lattice composes types: `Pair`, generic parameters. The termination argument requires finite enumerations, terminating evaluations and terminating primitive checks (<doc:verification_is_identification>, §5.1). ``/Notation/Pair`` supplies two roles, and ``/Notation/Null`` constrains their equality. Finite depth is a separate obligation of their interpretation (``Law`` §4 and EF4–EF7 of <doc:existence_is_finite>).

### Total languages

Agda, Coq and Idris check termination or productivity under their respective rules. Idris also permits partial functions, Agda permits non-terminating definitions outside safe mode, and Coq supports productive coinductive definitions. These checks do not require a finite input domain: a checked function can still run on an input supplied later. This package uses supplied finite domains for advance enumeration and generated readings (<doc:verification_is_identification>, §5.1).

### Automaton minimization

The login keypad in the Organization showcase accepts one four-digit code out of 9⁴ = 6561. Drawn as a tree, that is thousands of states. The keypad uses four prefix fragments, `k0` through `k3`, and one shared `dead` fragment. Each wrong digit links to `dead`. The last correct digit links to the person's unlocked page. PiP6 of <doc:program_is_path> treats this failure response as part of the supplied execution rule.

### Policy engines

Policy-as-code engines state access rules as data and answer requests against them: OPA evaluates Rego policies at request time, and AWS's Cedar adds an analyzer beside the engine that proves properties of a policy with a solver. In both, the policy is one artifact and the system it governs is another, met at request time. Here the stated organization and its policy are one source record: people, documents, and rules are types. You assert an access with `Granted`, whose gate parameter must conform to `Authorized`. The compiler refuses an unauthorized gate at that assertion and names the failed premise. The artifact check regenerates the supplied readings and compares them with their committed copies.

### The combination

Each neighbor keeps its own home. The package's claim is the combination: a decidable core, a finite stated input domain, and a residual artifact.

| Check | What it checks |
| --- | --- |
| `build` | Compile the package and run its tests. |
| `census` | Count source declarations by target. |
| `artifacts` | Regenerate the named pages and figures and compare them with committed copies. |
