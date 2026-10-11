import VerificationIsIdentification

/// Four source images, with two shared target projections as contacts.
/// Left on an image realizes W=(0 2 3), fixing 1; Right realizes Z=(0 1)(2 3).
/// These eight actual edge equations impose neither a contrast nor injectivity.
/// M64n proves that the images can only all coincide or all remain distinct.
public protocol TwoContactImage: Pair
where Left: Pair, Right: Pair,
      Left.Left: Pair, Left.Right: Pair, Right.Left: Pair, Right.Right: Pair,
      Left.Left.Left == Right.Left, Right.Left.Left == Right.Right,
      Right.Right.Left == Left.Left, Left.Right.Left == Left.Right,
      Left.Left.Right == Left.Right, Left.Right.Right == Left.Left,
      Right.Left.Right == Right.Right, Right.Right.Right == Right.Left {}

/// Each constructor receives one proposed merger and derives total collapse.
/// The conclusion is not requested as another condition of the caller.
public enum ContactMerge01<T: TwoContactImage>: Null
where T.Left.Left == T.Left.Right {
    public typealias Left = BoundaryWorking<T.Left.Left, T.Left.Right, T.Right.Left, T.Right.Right>
    public typealias Right = BoundaryWorking<T.Left.Left, T.Left.Left, T.Left.Left, T.Left.Left>
}

public enum ContactMerge02<T: TwoContactImage>: Null
where T.Left.Left == T.Right.Left {
    public typealias Left = BoundaryWorking<T.Left.Left, T.Left.Right, T.Right.Left, T.Right.Right>
    public typealias Right = BoundaryWorking<T.Left.Left, T.Left.Left, T.Left.Left, T.Left.Left>
}

public enum ContactMerge03<T: TwoContactImage>: Null
where T.Left.Left == T.Right.Right {
    public typealias Left = BoundaryWorking<T.Left.Left, T.Left.Right, T.Right.Left, T.Right.Right>
    public typealias Right = BoundaryWorking<T.Left.Left, T.Left.Left, T.Left.Left, T.Left.Left>
}

public enum ContactMerge12<T: TwoContactImage>: Null
where T.Left.Right == T.Right.Left {
    public typealias Left = BoundaryWorking<T.Left.Left, T.Left.Right, T.Right.Left, T.Right.Right>
    public typealias Right = BoundaryWorking<T.Left.Left, T.Left.Left, T.Left.Left, T.Left.Left>
}

public enum ContactMerge13<T: TwoContactImage>: Null
where T.Left.Right == T.Right.Right {
    public typealias Left = BoundaryWorking<T.Left.Left, T.Left.Right, T.Right.Left, T.Right.Right>
    public typealias Right = BoundaryWorking<T.Left.Left, T.Left.Left, T.Left.Left, T.Left.Left>
}

public enum ContactMerge23<T: TwoContactImage>: Null
where T.Right.Left == T.Right.Right {
    public typealias Left = BoundaryWorking<T.Left.Left, T.Left.Right, T.Right.Left, T.Right.Right>
    public typealias Right = BoundaryWorking<T.Left.Left, T.Left.Left, T.Left.Left, T.Left.Left>
}

/// A finite graph presentation, not runtime instances of recursive values.
/// The target contacts are the same two projections at every image.
public enum FaithfulContactImage: TwoContactImage {
    public enum A: Pair {
        public typealias Left = C
        public typealias Right = B
    }
    public enum B: Pair {
        public typealias Left = B
        public typealias Right = A
    }
    public enum C: Pair {
        public typealias Left = D
        public typealias Right = D
    }
    public enum D: Pair {
        public typealias Left = A
        public typealias Right = C
    }
    public typealias Left = Paired<A, B>
    public typealias Right = Paired<C, D>
}

public enum CollapsedContactImage: TwoContactImage {
    public enum Point: Pair {
        public typealias Left = Point
        public typealias Right = Point
    }
    public typealias Left = Paired<Point, Point>
    public typealias Right = Paired<Point, Point>
}

/// Each contact alone permits a rank-two image. The other contact cannot
/// descend through that same image: its two required outputs disagree.
public enum SeparateContactQuotients<A: Structure, B: Structure>: Close {
    public typealias WOnly = BoundaryWorking<A, B, A, A>
    public typealias ZOnly = BoundaryWorking<A, A, B, B>
    public enum WSurvives: Null {
        public typealias Left = PhaseWordCatalogue<A, B, A, A>.WW.Right
        public typealias Right = WOnly
    }
    public enum ZSurvives: Null {
        public typealias Left = PhaseWordCatalogue<A, A, B, B>.Z.Right
        public typealias Right = ZOnly
    }
    public enum ZAfterWQuotient: Pair {
        public typealias Left = Paired<WOnly.Left.Left, WOnly.Right.Left>
        public typealias Right = Paired<WOnly.Left.Right, WOnly.Right.Right>
    }
    public enum RequiredAnswers: Null {
        public typealias Left = Paired<ZAfterWQuotient.Left, ZAfterWQuotient.Right>
        public typealias Right = Paired<Paired<A, A>, Paired<B, A>>
    }
}

/// Two readings at the very same target node necessarily return its same
/// Right field, even when an arbitrary additional context is retained.
/// A larger target graph cannot give that one field two answers.
public enum SharedContactAtMergedImage<T: Pair, K: Structure>: Null
where T.Right: Structure {
    public typealias Root = Paired<T, K>
    public typealias Node = FirstEvidenceImage<Root, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Contact = SecondEvidenceImage<T, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Application = SequentialReading<Node, Contact>
    public typealias Left = Paired<Application.Answer, Application.Answer>
    public typealias Right = Paired<T.Right, T.Right>
}
