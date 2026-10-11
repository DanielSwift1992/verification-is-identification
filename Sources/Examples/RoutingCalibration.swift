import VerificationIsIdentification

/// These are the actual prepared arguments of the address-selection clauses.
public typealias RoutingProbeP = BoundaryWorking<Never, Never, Lit1, Lit1>
public typealias RoutingProbeQ = BoundaryWorking<Never, Lit1, Never, Lit1>

/// Each calibration is derived by applying its coordinate-selection clause
/// to both prepared arguments. No equality of the observed bits is requested.
public enum SelectionCalibration00: Null {
    public typealias Left = RoutingAddress00
    public typealias Right = Paired<Route00<RoutingProbeP>.Answer, Route00<RoutingProbeQ>.Answer>
}
public enum SelectionCalibration01: Null {
    public typealias Left = RoutingAddress01
    public typealias Right = Paired<Route01<RoutingProbeP>.Answer, Route01<RoutingProbeQ>.Answer>
}
public enum SelectionCalibration10: Null {
    public typealias Left = RoutingAddress10
    public typealias Right = Paired<Route10<RoutingProbeP>.Answer, Route10<RoutingProbeQ>.Answer>
}
public enum SelectionCalibration11: Null {
    public typealias Left = RoutingAddress11
    public typealias Right = Paired<Route11<RoutingProbeP>.Answer, Route11<RoutingProbeQ>.Answer>
}

/// Four established address calibrations compose with the existing decoder.
/// Its input consists only of the two assembled application images. The
/// equality to the calibrated routing follows from the four witnesses and
/// transposition; the caller does not supply the reconstructed whole answer.
/// Calibration alone does not certify a clause on an untested argument.
public enum CalibratedRoutingBasis<
    A: Null,
    C: Null,
    B: Null,
    D: Null
>: Null
where A.Right: Pair, C.Right: Pair, B.Right: Pair, D.Right: Pair,
      A.Right.Left: Structure, A.Right.Right: Structure,
      C.Right.Left: Structure, C.Right.Right: Structure,
      B.Right.Left: Structure, B.Right.Right: Structure,
      D.Right.Left: Structure, D.Right.Right: Structure {
    public typealias Routing = BoundaryWorking<A.Left, C.Left, B.Left, D.Left>
    public typealias FirstImage = BoundaryWorking<A.Right.Left, C.Right.Left, B.Right.Left, D.Right.Left>
    public typealias SecondImage = BoundaryWorking<A.Right.Right, C.Right.Right, B.Right.Right, D.Right.Right>
    public typealias Images = Paired<FirstImage, SecondImage>
    public typealias Left = RoutingCoordinates<Routing>.Answer
    public typealias Right = RoutingFromProbeImages<Images>.Answer
}
