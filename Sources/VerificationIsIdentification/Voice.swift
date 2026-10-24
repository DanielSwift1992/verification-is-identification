import Notation

import Swift

/// Two supplied readings use the same source, question and encoding labels.
/// Their image fields are the actual answers, rather than free coordinates.
/// This contract does not require unequal answers or prove unsupported
/// graph edges. A deterministic interpretation also needs consistency of
/// its admitted readings. [ViA 2]
public protocol EncodingInvents: ComparedReadings, HasEncoding
where OneSource == Left.Left, OneSource == Right.Left, FirstImage == Left.Answer, SecondImage == Right.Answer,
      Sigma == Left.Sigma, Encoding == Left.Encoding {
    associatedtype OneSource
    associatedtype FirstImage
    associatedtype SecondImage
}

/// The decoder of the actual observation returns its actual original source.
/// ReadingFactors supplies the observation-to-decoder seam and answer
/// agreement. The identity target closes recovery on the supplied reading.
/// A full family needs coverage and correct constructors. Graph sorts,
/// incidence and labels have their additional obligations. [ViA 6]
public protocol FaithfulEncoding: ReadingFactors
where Left.Answer == Left.Left {}
