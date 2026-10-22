# Consumer-declared strictness

A target using LawCheck declares strict mode with a UTF-8 `LawCheck.strict` file containing the word `strict` in its target directory. Exclude it from SwiftPM sources with `exclude: ["LawCheck.strict"]` in `Package.swift`. A valid declaration selects `lint --strict`; absence retains report mode. An invalid or unreadable declaration fails the build. Target names appear in diagnostics only and never select behavior.

Demo drivers legitimately use the §0′ value edge, so strict lint would refuse lawful runtime drivers. Report mode retains their diagnostics while allowing the build. A library consumer declares strictness at its own boundary.

The declaration is an input to the build command. SwiftPM can reuse a plugin plan when only an input's contents change, so the command passes `--strict-declaration PATH` to the linter. This selects strict mode and validates the current UTF-8 bytes before checking sources or writing a stamp. The plugin also validates the declaration when planning. Manual `lint --strict` remains available without a declaration file.

`bash Checks/lawcheck-policy.sh` exercises the actual plugin source through SwiftPM and the current build's real linter. The same `IllegalRename` is reported without failing the build on three target names; adding the declaration refuses it, and removing the declaration restores report mode without cleaning. Further controls refuse an unexpected declaration word, accept a clean target in strict mode, refuse a changed word and a declaration whose bytes cannot be read as UTF-8 after a successful strict build, and accept the repaired declaration without cleaning. The unreadable case exercises the throwing file read separately from word validation.
