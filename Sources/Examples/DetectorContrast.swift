import VerificationIsIdentification

/// Arithmetic is constructed from AddZero and ProductZero, not supplied
/// through arbitrary arithmetic conformances. The source is the nonnegative
/// corner table (2,1,1,0); the pointwise square is injective on this domain.
public enum DetectorContrast: Close {
    public typealias One = Examples.Succ<Never>
    public typealias Two = Examples.Succ<One>
    public typealias PlusOne<N: IntegerValued> = AddSuccessor<AddZero<N>>
    public typealias PlusTwo<N: IntegerValued> = AddSuccessor<PlusOne<N>>
    public typealias TimesOne<N: IntegerValued> =
        ProductSuccessor<ProductZero<N>, AddZero<N>>
    public typealias TwiceTwo = ProductSuccessor<TimesOne<Two>, PlusTwo<Two>>
    public typealias OneTimesOne = TimesOne<One>
    public typealias ZeroTimesZero = ProductZero<Never>
    public typealias Source = Paired<Paired<TwiceTwo.Left.Left, OneTimesOne.Left.Left>,
        Paired<OneTimesOne.Left.Left, ZeroTimesZero.Left.Left>>
    public typealias Image = Paired<Paired<TwiceTwo.Answer, OneTimesOne.Answer>,
        Paired<OneTimesOne.Answer, ZeroTimesZero.Answer>>
    public typealias SourceDiagonal = AddZero<Source.Left.Left>
    public typealias SourceOffDiagonal = PlusOne<Source.Right.Left>
    public typealias ImageDiagonal = AddZero<Image.Left.Left>
    public typealias ImageOffDiagonal = PlusOne<Image.Right.Left>

    public enum SourcesAreTheActualCorners: Null {
        public typealias Left = Paired<
            Paired<SourceDiagonal.Left, SourceOffDiagonal.Left>,
            Paired<ImageDiagonal.Left, ImageOffDiagonal.Left>>
        public typealias Right = Paired<
            Paired<Paired<Source.Right.Right, Source.Left.Left>,
                Paired<Source.Left.Right, Source.Right.Left>>,
            Paired<Paired<Image.Right.Right, Image.Left.Left>,
                Paired<Image.Left.Right, Image.Right.Left>>>
    }
    public enum OriginalContrastVanishes: Null {
        public typealias Left = SourceDiagonal.Answer
        public typealias Right = SourceOffDiagonal.Answer
    }
    // Two genuine predecessor projections preserve a compact distinction.
    public typealias ImageDiagonalTail = ImageDiagonal.Answer.Right.Right
    public typealias ImageOffDiagonalTail = ImageOffDiagonal.Answer.Right.Right
    public enum ReadImageDifference: Null {
        public typealias Left = Paired<ImageDiagonalTail, ImageOffDiagonalTail>
        public typealias Right = Paired<Two, Never>
    }

    // Four distinct application roles need not use identical offsets.
    public typealias Shift0 = PlusOne<Source.Left.Left>
    public typealias Shift1 = AddZero<Source.Left.Right>
    public typealias Shift2 = PlusTwo<Source.Right.Left>
    public typealias Shift3 = PlusOne<Source.Right.Right>
    public typealias ShiftedDiagonal = PlusOne<Shift0.Answer>
    public typealias ShiftedOffDiagonal = PlusOne<Shift2.Answer>
    public enum ShiftedSourcesAndContrast: Null {
        public typealias Left = Paired<
            Paired<ShiftedDiagonal.Left, ShiftedOffDiagonal.Left>,
            ShiftedDiagonal.Answer>
        public typealias Right = Paired<
            Paired<Paired<Shift3.Answer, Shift0.Answer>,
                Paired<Shift1.Answer, Shift2.Answer>>,
            ShiftedOffDiagonal.Answer>
    }
}
