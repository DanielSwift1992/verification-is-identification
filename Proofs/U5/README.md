# Lean proofs of the continuation checkers

This Lean 4 project proves that the finite checkers for the continuation relations U5–U11 accept a certificate only when the certificate's claim holds. It also proves that `record-check` reads exactly the record bytes the contract defines. The relations, the world schemas and the certificate formats are defined in [continuation-record-v1](../../Contracts/Court/continuation-record-v1/README.md). The toolchain is pinned in `lean-toolchain`, and the project has no external packages.

## What is proved

Each checker is a total Lean function. Its soundness theorem says: if `check … = true`, then the claim the certificate makes holds for every filling compatible with the world, under every interpretation of the opaque sorts by nonempty sets. `true` means the certificate was accepted, which can be a correctly justified obstruction. `false` means the input or the certificate was not accepted, and it is not a proof of impossibility.

| Library | Relation | Main theorems |
| --- | --- | --- |
| `U5` | Construction of the Question from the Observation, or an obstruction | `U5.check_sound`; `construction_sound` and `construction_full_input` (the program reproduces the Question and consumes the whole selection list); `obstruction_witnesses` and `obstruction_no_decoder` (two compatible fillings with the same Observation and different Questions, so no decoder of the Observation gives the Question); codec `decode_encode`, `decode_iff`, `decoding_unique` |
| `U6` | Retained residual classes | `U6.check_sound`; `missing_class_iff`, `missing_classes_complete`; `decoder_covers_missing` |
| `U7`, `U8` | Stable view and decoder under declared actions; common action, outside witness or disagreement on the Observation | `U8.check_sound`; `stable_least`, `stable_closed`, `stable_decoder`; `universal_iff_class_conditions`, `disagreement_no_source_decoder` |
| `U9` | Image and promise | `U9.check_sound`; `promise_iff`, `hidden_promise_iff` |
| `U10` | Allocation by an optimal plan | `U10.check_sound`; `admissible_iff_optimal_plan`, `optimal_plan_minimal` |
| `U11` | Return of the declared actions | `U11.check_sound`; `universal_return_iff_cycles`, `finite_common_return_iff` |
| `Record` | Reading world records of schemas 1–3 | `read_write`, `write_read`, `write_injective` for each schema; `exit_bytes_sound` |

`exit_bytes_sound` joins the parts: an exit code 0 or 1 from `record-check` means that the input bytes were read into an admitted world, that writing that world back gives the same bytes, and that the soundness theorem of the selected checker holds for the resulting model.

## Checking

From `Proofs/U5`:

```sh
lake build
lake exe record-check proof.json world.json
```

The first argument selects the checker: none for U5, `--retain` for U6, `--actions` for U7 and U8, `--image` for U9, `--agreement` for U10, `--repeat` for U11. Exit 0 and 1 are judged answers. Exit 2 means the record or the certificate was not read, and it is never an obstruction.

`Axioms.lean` is the single roster of claims. From the repository root, `python3 Checks/proofs.py` builds the project and reads Lean's `#print axioms` output for every rostered claim. It accepts only `propext`, `Classical.choice` and `Quot.sound`. The same law runs as the `proofs` job in CI.

## Limits

The theorems are about these Lean models of the checkers. The Swift court is compared with `record-check` on fixtures by the scripts in `Record/Tools` and `Record/*/Tools`; that comparison is a test, not a proof that the two implementations agree. Admission has named resource bounds (input size, JSON depth, tree size, path depth); an input beyond them exits 2 and is not judged. The Lean kernel, the toolchain and the IO driver in `Record/Main.lean` are premises of these results.
