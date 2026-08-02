# Atlas ablation: declared against measured

Measured 12 premises in 24s on 2026-08-02. Each row cuts one declared arrow and rebuilds
the core module. `load-bearing` means the compiler refused the tree
without the arrow, and the names it named are listed. `decorative`
means the build stayed green: the arrow is structurally decorative
for the compiler, which measures structure, never logical necessity;
the prose case for such an arrow rests on the papers alone.

| claim | premise | measured | breaks |
|---|---|---|---|
| RulesCompose | KnowledgeAccumulates | decorative |  |
| RulesCompose | OperationsClosed | decorative |  |
| HasCompositionalNorm | HasDistance | load-bearing |  |
| AtomBasis | RulesCompose | decorative |  |
| AtomBasis | BasisIsFinite | decorative |  |
| AtomBasis | HasCompositionalNorm | load-bearing |  |
| AtomnessIsTrajectory | AtomBasis | decorative |  |
| AtomnessIsTrajectory | NoInverse | decorative |  |
| ColourIsQuotient | EncodingForgets | decorative |  |
| GamutIsCone | ColourIsQuotient | decorative |  |
| Unique | Monotone | decorative |  |
| Unique | Null | decorative |  |

The tree builds green after every restoration: True.
