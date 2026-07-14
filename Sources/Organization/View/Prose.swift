import VerificationIsIdentification

/// A block of prose, spelled from `Glyph` atoms (DocumentKit/Alphabet.swift): the category
/// generated prose strings conform to, rather than writing `: Open` directly (Law §0″: `Open`
/// is a protocol). The strings themselves are generated (private/gen_prose.py, from
/// private/prose.json): every character is a real atom, and a `{hole}` in the template becomes
/// a generic parameter here, filled by a real `Structure` (`Tally`, `Reference`) at the
/// call site, never a hand-set string.
public protocol Prose: Open {}
