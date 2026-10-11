import VerificationIsIdentification

/// Two questions are paired at the same four input positions. This is an
/// invertible reassociation of the supplied fields, not an inferred alignment.
public enum ZipFourQuestions<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Pair {
    public typealias Left = Paired<BoundaryWorking<A, B, C, D>, BoundaryWorking<E, F, G, H>>
    public typealias Right = BoundaryWorking<Paired<A, E>, Paired<B, F>, Paired<C, G>, Paired<D, H>>
    public enum Undo: Pair {
        public typealias Left = ZipFourQuestions.Right
        public typealias First = BoundaryWorking<Left.Left.Left.Left, Left.Left.Right.Left,
            Left.Right.Left.Left, Left.Right.Right.Left>
        public typealias Second = BoundaryWorking<Left.Left.Left.Right, Left.Left.Right.Right,
            Left.Right.Left.Right, Left.Right.Right.Right>
        public typealias Right = Paired<First, Second>
    }
    public enum RestoresInput: Null {
        public typealias Left = Undo.Right
        public typealias Right = ZipFourQuestions.Left
    }
}

/// The actual W and Z generators act on the paired values exactly as on
/// both aligned questions separately. Their composition preserves this
/// equation. Distinct operations on the two sides are a different contract.
public enum JointPhaseQuestions<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Close {
    public typealias Input = ZipFourQuestions<A, B, C, D, E, F, G, H>
    public typealias WX = FourLeafPhaseWord<A, B, C, D>
    public typealias WY = FourLeafPhaseWord<E, F, G, H>
    public typealias WBoth = FourLeafPhaseWord<Paired<A, E>, Paired<B, F>, Paired<C, G>, Paired<D, H>>
    public typealias WSeparate = ZipFourQuestions<
        WX.Right.Left.Left, WX.Right.Left.Right, WX.Right.Right.Left, WX.Right.Right.Right,
        WY.Right.Left.Left, WY.Right.Left.Right, WY.Right.Right.Left, WY.Right.Right.Right>
    public typealias ZX = FourLeafShortPhaseWord<A, B, C, D>
    public typealias ZY = FourLeafShortPhaseWord<E, F, G, H>
    public typealias ZBoth = FourLeafShortPhaseWord<Paired<A, E>, Paired<B, F>, Paired<C, G>, Paired<D, H>>
    public typealias ZSeparate = ZipFourQuestions<
        ZX.Right.Left.Left, ZX.Right.Left.Right, ZX.Right.Right.Left, ZX.Right.Right.Right,
        ZY.Right.Left.Left, ZY.Right.Left.Right, ZY.Right.Right.Left, ZY.Right.Right.Right>

    public enum SameJointInput: Null {
        public typealias Left = Paired<WBoth.Left, ZBoth.Left>
        public typealias Right = Paired<Input.Right, Input.Right>
    }
    public enum WDistributes: Null {
        public typealias Left = WBoth.Right
        public typealias Right = WSeparate.Right
    }
    public enum ZDistributes: Null {
        public typealias Left = ZBoth.Right
        public typealias Right = ZSeparate.Right
    }
}
