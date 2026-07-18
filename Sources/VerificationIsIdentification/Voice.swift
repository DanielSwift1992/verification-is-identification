import Swift

// ═══════════════════════════════════════════════════════════════
// VOICE is the home of the two claims of A Verb Is an Act: an encoding can
// invent (in its image there is a parting with no parting at the source), and
// a faithful record is a sort-preserving, label-preserving morphism whose
// image adds no edge. The paper's worked instance is prose over a system: the
// facts are a typed graph, a sentence is the image of one edge, and a verb on
// a structure is an invented edge, refused by the source lemma. The claims
// are true of any encoding, so their place is here, beside the forgetting
// pair.
// ═══════════════════════════════════════════════════════════════

/// An encoding can invent: for one source there are two distinct images, so
/// in the image there is a parting with no fact behind it upstream. The
/// witnesses (one source, two images) are stated by the author on the
/// conformer, and the compiler checks the parting. The dual of
/// ``EncodingForgets``: there the image is too poor, here it is too rich.
/// [ViA 2]
public protocol EncodingInvents: HasEncoding {
    associatedtype OneSource
    associatedtype FirstImage
    associatedtype SecondImage
}

/// A faithful encoding is free of both wrongs: every distinction of the
/// source is in the image, and every distinction of the image is from the
/// source. Between the forgetting pair and the inventing pair, faithfulness
/// is the narrow door: a record is faithful exactly when reading it back is
/// identification. [ViA 6]
public protocol FaithfulEncoding: HasEncoding {}
