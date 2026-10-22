# Check profiles after the package split

`python3 Checks/profiles.py --list` lists three profiles and checks that every law registered by `check.sh --list` is assigned to exactly one. The fourth profile of [profiles-v1](profiles-v1.md), `showcase`, moved with the company to the showcase package (T-0015): its publication positives and seven `PUBLICATION_*` refusals run there as `Checks/publication.sh`, and its demo rules, regenerated artifacts and differential judge are laws of that package's `check.sh`.

| Profile | What it asks | Remaining shared dependencies |
| --- | --- | --- |
| `vi` | Every verdict certificate and refusal; lattice names, Topics, paper families and quotations | Existing Swift package, Tools and plugins |
| `court` | Actual library consumer; existing where/count controls, finite contract and structured response/admission controls | Tools build and current example fixtures; this is the registered acceptance set, not general equivalence |
| `integration` | Whole-package build/tests; repository census, voice, README, grammar, consumer-declared LawCheck policy, frozen research-reader boundary and check-driver controls | The whole repository |

`bash Checks/verdict.sh core` and `bash Checks/verdict.sh all` now ask the same fixtures and flags: no publication source remains in this package, and `verdict.sh publication` is refused as an unknown scope. The profile driver and its measurement rules are those of profiles-v1, unchanged.
