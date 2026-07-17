import Swift

// ═══════════════════════════════════════════════════════════════
// SEEING pins the two claims of Seeing Is Encoding: a projection into a smaller
// carrier can hold two sources to one image, and a presented separator hands the
// lost distinction back. The paper's worked instance is light — a beam is a tree,
// an eye is the projection, a prism is the separator — but the claims stand for
// any sensor over any structure, so they live here, on the encoding axis.
// ═══════════════════════════════════════════════════════════════

/// An encoding can forget: two distinct sources share one image under it, so the
/// image alone leaves `|S| > 1` and identification stops at the reading edge. The
/// claim is carried by its witnesses — the conformer presents the twin sources and
/// their shared image, and the compiler checks the sharing. Builds on
/// ``HasEncoding``: the encoding bounds what a reader of images can ever
/// distinguish. [SiE 4]
public protocol EncodingForgets: HasEncoding {
    associatedtype LeftSource
    associatedtype RightSource
    associatedtype SharedImage
}

/// A presented separator returns the distinction the encoding forgot: routed
/// through it, the twin sources land on distinct images, and identification is
/// restored without touching the sources. The separator is presented, never
/// searched for — the same author's move a presented law makes. Builds on
/// ``EncodingForgets``: the forgetting names the pair the separator must part.
/// [SiE 5]
public protocol SeparatorIdentifies: EncodingForgets {
    associatedtype Separator
}
