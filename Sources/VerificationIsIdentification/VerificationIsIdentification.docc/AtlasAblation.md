# What a premise deletion checks

A declaration states a relation. Its generic constructor supplies a derivation under explicit premises. A nearby false conformance tests whether the compiler refuses a broken relation. These checks establish the typed boundary used by the papers.

A deletion experiment asks a different question: after removing one parent premise, do the remaining core declarations still compile? It can locate dependencies or redundancy. It does not compile the downstream constructors or establish the mathematical necessity of every premise.

## When to run it

Use a targeted type check when changing a constructor or its relation. Run a deletion experiment when investigating a particular dependency, suspected redundancy, or the deletion tool itself. A complete sweep is an explicit research experiment, not a prerequisite for each edit or a mathematical proof.

The saved experiment is outside the corpus, at `Research/ablation/current.md`. It records the source snapshot it examined. It may become historical as the types change. `./check.sh --only ablation` explicitly checks whether its premise list still matches the current graph. The normal build and documentation checks do not require that report to be refreshed.

To perform a new complete sweep, build Tools, emit the symbol graph, and pass the core module's graph to `Tools ablate`. The tool restores every temporary cut and writes its report only after restoration succeeds. Its internal `--self-test` checks cutting and restoration without sweeping the lattice.
