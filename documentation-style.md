# documentation-style — one door for the whole package

Doc-comments (`///`) and DocC landings (`.md`) render as the documentation. They are
pinned the way the types are pinned (Law §0′): minimize the writer's freedom, so the
content fixes the text, not the author. Two writers given the same protocol produce
nearly the same page. This is Law §5.25 — order is the sole freedom — lifted onto
prose: pin everything pinnable, leave only the claim free.

One law at three scales: the sentence, the name, the shape. Below: first the two jobs
that force the form, then the form itself.

(Scope: `///` doc-comments and DocC `.md` landings. The `//` file headers are source
notes, exempt. The papers under `Papers/` keep the aphoristic voice — that register
is theirs by design.)

## The two jobs

Documentation does two things, and each one forbids free prose.

- **It teaches.** The reader does not yet hold the idea. V=I separates *checking*
  (cheap, for someone who can already produce the answer) from *finding* (the hard
  half, for someone who cannot). Documentation is the finding half. A comment that
  only confirms the idea to someone who already holds it is a note to a colleague.
- **It is navigated.** The reader moves by jumping, never straight through. You jump
  through form: a table by row, a term list by entry, a skeleton by slot. Prose is
  the one shape that must be read in sequence.

Both demand the same discipline: **pin the form, ration the prose.**

## Teach the idea before you name it

- Lead with the idea, in plain words. A name — `V=I`, an axis, a protocol — is a
  handle for an idea already in hand. Named cold, it defers to a legend the reader
  does not have. (The name law forbids exactly this deferral.)
- The lattice's bookkeeping — which axis a protocol names, what it inherits, the tag
  — is mechanism and provenance. Place it after the idea, phrased as a reason
  (`because X, Y`). It never stands in for the substance.

> Tip: The strip test. Delete every backtick, bracket, and axis-name. If a sentence
> that teaches what the thing *is* remains, it is documentation. If only wiring
> remains, rewrite.

```
Wired (a note to a colleague):
  /// Same task + grammar + protocol yields the same result. [V=I §5.8]
  /// Names the Result axis (Measurable) — input determines output, one value.
  /// Inherits OperationsClosed.

Taught (idea first, wiring as the reason):
  /// The system is deterministic: one input has one answer, the same on every run.
  /// An output could spread across many possible values. This one settles each
  /// input on a single measured value (Measurable).
  /// Builds on OperationsClosed: because the operations are fixed, the result is too. [V=I §5.8]
```

## Oppositions are collapsed branches

Every `not` is a branch read backward. A negation names the branch the writer did
*not* take, and leaves the reader to invert it to the one taken. That inversion is
the loop: the reader rebuilds the fork from its pruned leaf. Any tangle (a stacked
`not`, a tail contrast, a buried thesis) is the same shape: a decision tree
collapsed into a denial.

The fix is one move. **Expand the `NOT` into the positive tree:** state the branch
point first, walk the taken branch forward, show only the branches that inform. The
cascade then reads in the direction of thought, and the candidate space compresses
to one leaf. That compression is understanding, and it is V=I: the set, then the
collapse.

The classifier is one test. **Say it positively.** If nothing is lost, it was a
tangle: prune the dead branch, or front-load the live one. If the positive loses the
fact, the negation identifies (`|S| = 1`) and stays.

| tangle | the hidden tree | forward rewrite |
| --- | --- | --- |
| phantom contrast (`X, not Y`, Y never live) | a fork with one real branch | prune `Y`, state `X` |
| tail fork (`X …, not Y`, Y real but last) | a real fork read backward | branch point first: `Y or X, and it is X because …` |
| buried thesis (`not A, it is B`) | `B` hidden behind `¬A` | lead with `B`, keep `A` only as a visible branch the reader actually holds |
| negation stack (`does not fail to …`) | nested `not`s | collapse to the positive leaf (`terminates`) |
| identifying negation (`Retraction is impossible`, `NoInverse`) | a fork whose one leaf is the absence | keep, it is already the compressed positive |

> Important: The last row is the framework's signature and stays. What tells it from
> a tangle: positivizing an identifying negation loses information, positivizing a
> tangle loses nothing.

## This logic, this block

Documentation is a form. Pick the block the logic already has, never narrate it as
prose.

| logic | block |
| --- | --- |
| a definition, a primitive triple (seed · move · floor) | term list |
| n parallel cases of one shape (REJECT types, boundaries, task kinds) | table |
| a sequence, a pipeline, a dependency chain | fenced diagram or the skeleton |
| a consequence, a caveat, a test, a forbidden form | aside — Note · Tip · Important · Warning, one job each |
| what a symbol is | prose, three beats |
| where to go next | a Topics group + `<doc:>` |

Prose is rationed to the three-beat claim. Any logic with a shape in this table takes
its block. Deviate when the content demands it, and make the deviation visible.

## The sentence — three beats

1. **Claim.** One sentence: what the symbol is, or what it proves. Positive, present
   tense, subject first. No em-dash here.
2. **Mechanism.** One or two sentences: the move (*expand* / *compress* /
   *intersect*) and the `where` or parent that realizes it, or the witness that
   inhabits it.
3. **Provenance.** The tag, last, in brackets: `[Tag §x]`.

At most one aside, each with a fixed job: `> Note` a consequence or the intuition,
`> Tip` a test the reader can apply, `> Important` a caveat that changes what is true,
`> Warning` a forbidden form.

### Punctuation

- **Em-dash: one break per sentence, none in the claim.** A break is a single dash,
  or one appositive pair (`— x —`). Where a second, independent break wants in, the
  sentence is two: split it, or use a colon or commas.
- **No semicolon.** A semicolon is a soft join that leaves it undecided whether this
  is one thought or two. Decide: a period (two sentences), a colon (head and tail),
  or a block (a table, a term list). `;` → `.` / `:` / block.
- **Names in code, never bold.** Symbols in ``double backticks``, literals in
  `single`. The only bold is a fixed label, like a `**Premises**` footer.
- **Emphasis: all-caps the one pivotal word, sparingly.** This is the reference
  layer's single emphasis device, since bold is reserved for labels and names live
  in backticks. Cap the load-bearing word, not the tone.
- **Sentence case. Present tense, active voice, one idea per sentence.**

### One word per concept

- the moves: *expand*, *compress*, *intersect*.
- the kinds: *axis*, *theorem*, *bridge*.
- the fixed nouns: the seed, the gate, the cache, the library, the crystal, the
  floor, the spine, the web.

## The name — clarity over brevity

- A name identifies, it never defers to a legend. Full descriptive names, no
  initialism, no underscore. A reader who never opened the paper knows what a file or
  symbol is from the name alone.
- Initialisms live in one place: provenance tags in brackets — `[V=I §5.22]`,
  `[IiI §3]` — decoded once in `Sources`. The tag is the controlled vocabulary, the
  name is the open one.
- **Files:** the paper's subject-noun, one word (`Identification.swift`).
  Infrastructure takes a role-noun (`Law`, `Witness`).
- **Symbols:** a full claim-phrase in PascalCase (`PassIsIdentification`). An axis or
  `associatedtype` is a full noun (`Sigma`, `SolutionSet`).

## The shape — What · How · Where

One shape at every scale, the three beats lifted.

| scale | What | How | Where |
| --- | --- | --- | --- |
| symbol (`///`) | the claim sentence | the mechanism sentence | `[Tag §x]` |
| page / Overview | the central result | the construction (seed, moves, floor) | navigation + `<doc:>` |
| paper | the thesis, one paragraph | the derivation (`§`-sections) | Scope + the skeleton + tags |

- Reach (what a claim buys) is placed, not slotted: the single optional `> Note` at
  symbol scale, a visible **Scope** at paper scale.
- Every derivation ends with an **Argument in order** skeleton: its claims and their
  dependencies, as a re-entry map. On return you read the skeleton, then dive into
  one slot.
- Pin the landmarks — claim first, predictable headings, the skeleton — not every
  sentence.

## Two registers

Two voices exist. The papers and a page's thesis line are aphoristic, earned, the
framework's identity. The reference layer — the `///` comments, every How beat, every
mechanism — is plain and actionable. An aphorism the reader cannot act on belongs in
the paper.

## The test

Read the page back.

- **Strip test:** remove every backtick, bracket, and axis-name. A sentence that
  teaches what the thing *is* must remain.
- **Opposition audit:** for every contrast, does the alternative inform, and does it
  come before the resolution?
- **Em-dash and semicolon:** two dashes are two sentences, a semicolon is an
  undecided join.
- **One word per concept:** a word swappable for a synonym with no loss was the wrong
  word.
