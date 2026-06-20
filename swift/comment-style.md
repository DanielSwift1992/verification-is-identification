# comment-style — the doc-comment law

Doc-comments (`///`) render as the documentation. They are pinned the way the
types are pinned (Law.swift §0′): minimize the writer's freedom so the *content*,
not the author, fixes the text. Two writers given the same protocol should produce
nearly the same comment. This is §5.25 — order is the sole freedom — applied to
prose: pin everything pinnable, leave only the claim free.

(Scope: `///` doc-comments. The `//` file headers are source notes, not docs, and
are exempt.)

## Shape — three beats, in order

1. **Claim.** One sentence: what the symbol is, or what it proves. Positive,
   present tense, subject first. No em-dash in this sentence.
2. **Mechanism.** One or two sentences: how the types encode it — the move
   (expand / compress / intersect) and the `where` or parent that realizes it, or
   the witness that inhabits it.
3. **Provenance.** The tag, in brackets, last: `[Tag §x]`.

At most one aside, each with a fixed job:

- `> Note` — a consequence, or the intuition behind the claim.
- `> Tip` — a test or heuristic the reader can apply.
- `> Important` — a caveat that changes what is true (correctness, not taste).
- `> Warning` — a forbidden form.

## Punctuation — the pinned part

- **Em-dash: at most one per sentence, none in the claim sentence.** Where a
  second would go, use a period (split the sentence), a colon (the tail explains
  the head), or commas (a light appositive). The em-dash is one sharp break, not a
  general connector.
- **State what holds, not what fails.** A negation earns its place only when it
  *identifies* — when the solution set it leaves is one (``NoInverse``,
  ``NoSelfReference``: the absence names the unique fact). A negation that merely
  rejects (`|S|>1` — "not a loose collection" is true of a banana too) names
  nothing; write the positive that identifies. Never "not X but Y" for emphasis;
  write "Y". No double negatives, no "it is not the case that".
- **Names in code, never bold.** Symbols in ``double backticks``, literals in
  `single`. The only bold is a fixed label, like the `**Premises**` footer.
- **Sentence case.** Headings, asides, labels. The papers' `PAIR` / `NULL` /
  `COMPARE` become ``Pair`` / ``Null`` / `COMPARE` here.
- **Present tense, active voice, one idea per sentence.** Two short sentences beat
  one long sentence held together by dashes.

## Vocabulary — one word per concept

- the moves: *expand*, *compress*, *intersect*. Not "adds an axis" / "constrains"
  / "combines" as free synonyms.
- the kinds: *axis* (a generator), *theorem*, *bridge*.
- the fixed nouns: *the seed*, *the gate*, *the cache*, *the library*, *the
  crystal*, *the floor*, *the spine*, *the web*.

## The test

Read the comment aloud.

- If a sentence needs two em-dashes to stand, it is two sentences.
- If it says what something is *not*, and you cannot name the theorem the absence
  states, rewrite it positively.
- If a word could be swapped for a synonym with no loss, it was the wrong word —
  use the pinned one.
