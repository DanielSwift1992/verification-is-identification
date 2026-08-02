# Which premises the build needs

Cut 12 premises one at a time in 22s. The premise list is the compiler's own symbol graph, the file tree-sort
reads, so the lattice has one reader. Each row cuts one declared premise,
rebuilds the core module, and restores the file. `build fails` lists the
names the compiler refused without the premise. `builds green` says the
module compiles without it: the premise still carries meaning for a
reader, and the papers, not this table, argue it.

| claim | premise | cut result | names refused |
|---|---|---|---|
| RulesCompose | CachePermanent | builds green |  |
| RulesCompose | HasCache | builds green |  |
| RulesCompose | HasLibrary | builds green |  |
| RulesCompose | HasSigma | builds green |  |
| RulesCompose | KnowledgeAccumulates | builds green |  |
| RulesCompose | Open | builds green |  |
| RulesCompose | OperationsClosed | builds green |  |
| RulesCompose | Pair | builds green |  |
| RulesCompose | Structure | builds green |  |
| RulesCompose | StructuresFinite | builds green |  |
| HasCompositionalNorm | HasDistance | build fails |  |
| HasCompositionalNorm | HasSigma | builds green |  |

The module builds green after the last restoration: true.
