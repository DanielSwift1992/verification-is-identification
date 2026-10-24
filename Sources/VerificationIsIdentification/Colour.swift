import Notation

import Swift

/// An exact fiber is represented by its common encoded image, as in CiQ1.
/// The supplied two readings certify that common image. They do not list
/// the whole fiber or establish a deterministic encoder on a larger domain.
/// Perceptual tolerance has the separate CiQ7 boundary. [CiQ CiQ1]
public protocol ColourIsQuotient: EncodingForgets
where Fiber == SharedImage {
    associatedtype Fiber
}

// The old GamutIsCone/Primaries coordinates had no bound response law or
// drive-domain certificate. They are retired. CiQ3-CiQ4 retain the cone and
// bounded-drive theorems; concrete finite gamut constructors remain in Examples.
