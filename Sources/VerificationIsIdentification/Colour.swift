import Swift

// ═══════════════════════════════════════════════════════════════
// COLOUR pins the two claims of Colour Is a Quotient: a colour is a fiber of
// the eye's projection — the class of all beams sharing one image — and a
// display's reach is the cone of its stated primaries, so a colour outside the
// cone is refused, never clipped. The paper's worked instance is light, and the
// claims are true for any encoding's quotient and any presented generator.
// ═══════════════════════════════════════════════════════════════

/// A colour is a quotient's point: the fiber of the encoding over one image,
/// the class of every source that lands there. Coordinates (any colour
/// space) parameterize the quotient, never the light, so two sources in one
/// fiber are one colour and remain two beams. Builds on ``EncodingForgets``:
/// the forgetting is what makes the class bigger than one member. [CiQ 1]
public protocol ColourIsQuotient: EncodingForgets {
    associatedtype Fiber
}

/// A display is a presented source: stated primaries with nonnegative levels,
/// and its reach is the cone those primaries span in the quotient. A colour
/// inside the cone is matched by stated levels. A colour outside has no
/// matching levels at all, so the display refuses it by name: an empty
/// candidate set, never a silent clip. Builds on ``ColourIsQuotient``: the
/// cone is in the quotient, where colours are, and the reach is decidable
/// from the stated primaries before anything shines. [CiQ 3]
public protocol GamutIsCone: ColourIsQuotient {
    associatedtype Primaries
}
