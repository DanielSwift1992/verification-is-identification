# How These Pages Read

Five facts are true on every page of this documentation. They are stated once, here, so no other page has to restate them.

## Overview

**A type is its own content.** Most named things here are empty `enum`s. Such a type stores nothing and is never created: the name is the content, and a page, a diagram, or a table shows that name by reading it off the type. When a comment says a value is "read at render", it means this: the fact is in the type, and the surface prints it.

**Bodies never run.** A `body` lists types inside `{ }`. The compiler checks that list, readers walk it, and no statement in it ever executes. A build log full of "will never be executed" warnings reports the design working, not a defect.

**A green build is the proof.** Claims are written as protocols and conformances. The claim is true when the build passes, and fails to compile when it does not. There is no separate proof artifact to keep in step with the code.

**The badge is provenance.** A bracket like `[Nav N5]` at the end of a comment names the paper section where the claim is proved. The sentence before it teaches the idea, and the badge names where the proof is, for the reader who wants it.

**"Checked directly" marks a wall.** Where "checked directly" is in a comment, the stated limit was verified against the real toolchain rather than assumed. Such limits are stopped at and named, not patched around.

The construction vocabulary (the seed, the two moves, the floor) is one page: ``Law``.
