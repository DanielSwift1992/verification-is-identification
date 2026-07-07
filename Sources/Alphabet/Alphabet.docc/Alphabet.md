# ``Alphabet``

One type per character: the vocabulary the renderer and the style linter both read.

## Overview

Every character that matters to the system is one atom with two readings: the character
it renders (`typeName`) and the identifier the linter carries (its Swift name). One
registry serves both readings, so the renderer and the linter cannot disagree about a
name — there is exactly one `Comma`, and both mean the same thing by it.

## Topics

### The kinds of atom

- ``Lexeme``
- ``Glyph``
- ``MediumAtom``
- ``LintAtom``
- ``OpeningAtom``
- ``ClosingAtom``
- ``AlwaysPairs``
- ``Escapes``
- ``ForeignAtom``
- ``ForeignOpener``
- ``Spelled``

### The registry

- ``Alphabet/Alphabet``
- ``LexemeCensus``
- ``WordAtom``

### The punctuation

- ``Ampersand``
- ``AngleClose``
- ``AngleOpen``
- ``Apostrophe``
- ``Asterisk``
- ``At``
- ``Backslash``
- ``Backtick``
- ``BraceClose``
- ``BraceOpen``
- ``Caret``
- ``CarriageReturn``
- ``Colon``
- ``Comma``
- ``Dash``
- ``Dollar``
- ``Equals``
- ``Exclamation``
- ``Hash``
- ``Newline``
- ``ParenClose``
- ``ParenOpen``
- ``Percent``
- ``Period``
- ``PipeAtom``
- ``PlusSign``
- ``Question``
- ``Quote``
- ``Semicolon``
- ``Slash``
- ``Space``
- ``SquareClose``
- ``SquareOpen``
- ``Tab``
- ``Tilde``
