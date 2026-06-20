# narration-style — the argument shape

Exposition is itself a structure (a concept is a finite structure, [EiF Thm 2]),
so it is read by navigating it, and navigation needs a fixed shape. This pins the
shape of an explanation the way `comment-style` pins the sentence and `tree-sort`
pins the lattice order: the reader moves by slot and never re-reads to re-find a
part. (V=I §5.25: order is the sole freedom — pin the shape, leave only the
content free.)

Scope: the argument shape at every scale, in `///` doc-comments and in the
papers. `comment-style` governs the sentences; this governs their order and the
larger units they build.

## The shape — What · How · Where

One shape repeats at every scale. It is `comment-style`'s three beats, lifted:

- **What** — the positive identification: what the thing *is*. It identifies
  (`|S|=1`), never rejects ("not Y").
- **How** — the mechanism: the move (*expand* / *compress* / *intersect*) and the
  `where` or parent that realizes it; at paper scale, the derivation.
- **Where** — the address: the provenance tag, and at larger scales the
  navigation (spine vs web) and the skeleton.

Read in order. Each slot has one job. A returning reader jumps to the slot needed.

| scale | What | How | Where |
| --- | --- | --- | --- |
| symbol (`///`) | the claim sentence | the mechanism sentence | `[Tag §x]` |
| page / Overview | the central result | the construction (seed, moves, floor) | navigation + `<doc:>` |
| paper | the thesis, one paragraph | the derivation (`§`-sections) | Scope + the skeleton + tags |

## Reach — the disciplined fourth

A claim's consequence — what it buys, how far it reaches — is real content, but a
mandatory "so what" breeds selling. So reach is *placed*, not slotted:

- symbol: reach is the single optional `> Note` (`comment-style`), never required.
- paper: reach is a visible **Scope** — what is shown, what is not, how far it
  reaches. [EiF]'s Corollary is the model: the reach is a theorem, stated plainly.

## The skeleton — the re-entry map

Every derivation ends with an **Argument in order** block: its claims and their
dependencies, as a skeleton. [EiF]'s `C1 → … → Thm` chain is the model:

```
C1 something is        (undeniable)
C2 determinate         [C1]
  ⟹ Thm 1  one space
  ⟹ Thm 2  to be is to be a finite structure
```

On return you read the skeleton, not the prose, and dive into one slot. A
derivation with no skeleton is not re-enterable.

## Landmarks, not a straitjacket

Pin the landmarks — claim first, predictable headings, the skeleton block — not
every sentence. The goal is skimmability and re-entry, never robotic templating.
Deviate when the content demands it, and make the deviation visible.

## Register — two voices

The papers and a page's thesis line are aphoristic — earned, the framework's
identity. The reference layer — the `///` comments, the How beat, every
mechanism — is plain and actionable. Aphorism a reader cannot act on belongs in
the paper, not the reference. (`comment-style` pins this at the sentence.)

## The test

- Returning, can you reach the one slot you need without re-reading? If not, the
  shape is not visible enough.
- Does the first sentence *identify* (What), or defer (context, negation,
  apology)? If it defers, the order is wrong.
- Is there a skeleton to jump to? A derivation with no *Argument in order* map is
  not done.
