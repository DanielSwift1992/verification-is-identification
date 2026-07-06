import Foundation

// SourceFile names the generation layer's notation. Tools cannot depend on
// VerificationIsIdentification (LawCheck, a build plugin, depends ON Tools, the reverse
// dependency would cycle), so this is not a reuse of `Structure`/`Open`/`Paired`; it is the same
// PATTERN, instantiated independently for the one medium Tools actually produces: source text,
// not markdown. `Screen`'s `body` composes pages that render through `typeName`; a `SourceFile`
// composes fragments that ARE the file, through the same reading.
//
// Generation is a GATED CONSTRUCTION (Program Is Path): a template proposes a file, the build is
// the gate — compilation, LawCheck, `Tools grammar`, and this round's own parity-idempotence all
// cut the space of accepted outputs to one survivor. Where the template and the rules admit
// exactly one emission, |S| = 1 holds at the artifact level, and the md5 gates below measure
// exactly that, without naming it.
protocol SourceFile {
    static var typeName: String { get }
}

/// This joins two `SourceFile`s, concatenated: the one join this file needs, the same role
/// `Paired` plays in the real lattice, sized to what generation actually composes (a handful of
/// fixed pieces, not two hundred).
struct Joined<A: SourceFile, B: SourceFile>: SourceFile {
    static var typeName: String { A.typeName + B.typeName }
}

// A fixed block of text (a file's header comment, a boilerplate wrapper) is one `SourceFile`
// atom, its whole content the `typeName`, the same §S22 discipline the real surface uses for
// long prose: spelled once, as a literal, not rebuilt from smaller pieces that would only
// re-fragment something that never varies. See GenerateOrg/GenerateLogin/GenerateCards for the
// instances (`…Header: SourceFile`).

// ── The wall, named honestly (Canon §1: generation is the edge where external text is
// produced), NOT worked around below. ──
//
// A data pool (12 given names, 12 family names, 12 birth years) can be, and is, a typed chain:
// each name is its `SourceFile` atom, read back through `.typeName` the same way `labels`
// reads a real `Structure`'s leaves, the pool's membership lives in the notation, not a bare
// string array. But WHICH pool member applies to employee `i`, and WHICH generated enum results,
// is chosen by `i % k` at the driver's runtime: two hundred distinct compile-time types would
// have to exist for two hundred distinct choices, and nothing selects a Swift generic parameter
// from a runtime integer. So the per-employee template stays a plain Swift function: a
// combinator with named holes (`rank`, `home`, `given`, …), not a generic type with type holes,
// called from a thin `for` loop, the fold this wall leaves as the only honest shape.
