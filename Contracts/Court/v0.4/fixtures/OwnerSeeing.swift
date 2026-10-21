import Swift

/// Two supplied readings of one question have the same encoded answer.
/// Their actual source and answer addresses bind the old coordinates.
/// Distinctness of the sources and coverage of an entire fiber remain
/// separate obligations. [SiE SiE3]
public protocol EncodingForgets: VerdictIsInvariant
where LeftSource == Left.Left, RightSource == Right.Left, SharedImage == Answer {
    associatedtype LeftSource
    associatedtype RightSource
    associatedtype SharedImage
}

/// The additional readings use exactly those two retained source addresses.
/// The supplied pair does not require unequal answers or identify every
/// source. SiE4 needs the actual distinguishing outputs as well. The legacy
/// name does not discharge that extra obligation. [SiE SiE4]
public protocol SeparatorIdentifies: EncodingForgets
where Separator.Left.Left == LeftSource, Separator.Right.Left == RightSource {
    associatedtype Separator: ComparedReadings
}
