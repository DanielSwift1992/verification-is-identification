import VerificationIsIdentification

// A symbolic rearrangement of three addressed roles. This is NOT a claim
// about a coherent physical SWAP, a channel, or an available Hamiltonian.
// Those interpretations require the separate premises in the research note.
public enum DerivedContactTriple<A: Structure, B: Structure, C: Structure>: Pair {
    public typealias Left = A
    public typealias Right = Paired<B, C>
    public typealias P = DerivedContactTriple<B, A, C>
    public typealias Q = DerivedContactTriple<A, C, B>
}

// The equality is applied to arbitrary role contents, not a table of bits.
public enum DerivedContactWordLaws<A: Structure, B: Structure, C: Structure>: Null {
    public typealias T = DerivedContactTriple<A, B, C>
    public typealias Left = Paired<T.P.P, Paired<T.Q.Q, T.P.Q.P.Q.P.Q>>
    public typealias Right = Paired<T, Paired<T, T>>
}

public enum DerivedContactBraid<A: Structure, B: Structure, C: Structure>: Null {
    public typealias T = DerivedContactTriple<A, B, C>
    public typealias Left = T.P.Q.P
    public typealias Right = T.Q.P.Q
}

// Distinct constructor forms provide a concrete contrast. The contrast is
// tested by an expected refusal of P.Q == Q.P; naming it is not the proof.
public typealias DerivedContactContrast = DerivedContactTriple<
    Never,
    Paired<Never, Never>,
    Paired<Never, Paired<Never, Never>>
>
