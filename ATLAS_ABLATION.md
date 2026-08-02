# Every Atlas arrow, cut once and rebuilt

Cut 12 premises one at a time in 24s on 2026-08-02. Each row cuts one declared arrow, rebuilds
the core module, and restores the file. `build fails` lists the names
the compiler refused without the arrow. `builds green` says the module
compiles without it: the arrow still carries meaning for a reader, and
the papers, not this table, argue it.

| claim | premise | cut result | names refused |
|---|---|---|---|
| RulesCompose | KnowledgeAccumulates | builds green |  |
| RulesCompose | OperationsClosed | builds green |  |
| HasCompositionalNorm | HasDistance | build fails |  |
| AtomBasis | RulesCompose | builds green |  |
| AtomBasis | BasisIsFinite | builds green |  |
| AtomBasis | HasCompositionalNorm | build fails |  |
| AtomnessIsTrajectory | AtomBasis | builds green |  |
| AtomnessIsTrajectory | NoInverse | builds green |  |
| ColourIsQuotient | EncodingForgets | builds green |  |
| GamutIsCone | ColourIsQuotient | builds green |  |
| Unique | Monotone | builds green |  |
| Unique | Null | builds green |  |

The module builds green after the last restoration: True.
