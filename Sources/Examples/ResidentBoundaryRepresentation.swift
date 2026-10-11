import VerificationIsIdentification

// Two concrete presentations of the existing First reading. Their decoding
// is obtained from these fields; a presentation name is not a proof of it.
public typealias ResidentBoundaryDirect<S: ResidentHistoryShape> =
    Paired<S.Relative, S.First>

public typealias ResidentBoundaryTurned<S: ResidentHistoryShape> =
    Paired<S.First, S.Relative.Flipped>

public typealias ResidentBoundaryTurnedReading<S: ResidentHistoryShape> =
    Paired<ResidentBoundaryTurned<S>.Right.Flipped, ResidentBoundaryTurned<S>.Left>

public enum ResidentBoundaryRepresentationRoot: Close {
    public typealias Source = ResidentGoalSynthesisRoot
}
