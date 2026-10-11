import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_CONTACT_RIGIDITY_PARTIAL && !LOCAL_PHASE_CONTACT_RIGIDITY_ONE_CONTACT && !LOCAL_PHASE_CONTACT_RIGIDITY_NO_CONTRAST
enum RigidityFromMerge01<T: TwoContactImage>: Null where T.Left.Left == T.Left.Right {
    typealias Left = ContactMerge01<T>.Left
    typealias Right = ContactMerge01<T>.Right
}
enum RigidityFromMerge02<T: TwoContactImage>: Null where T.Left.Left == T.Right.Left {
    typealias Left = ContactMerge02<T>.Left
    typealias Right = ContactMerge02<T>.Right
}
enum RigidityFromMerge03<T: TwoContactImage>: Null where T.Left.Left == T.Right.Right {
    typealias Left = ContactMerge03<T>.Left
    typealias Right = ContactMerge03<T>.Right
}
enum RigidityFromMerge12<T: TwoContactImage>: Null where T.Left.Right == T.Right.Left {
    typealias Left = ContactMerge12<T>.Left
    typealias Right = ContactMerge12<T>.Right
}
enum RigidityFromMerge13<T: TwoContactImage>: Null where T.Left.Right == T.Right.Right {
    typealias Left = ContactMerge13<T>.Left
    typealias Right = ContactMerge13<T>.Right
}
enum RigidityFromMerge23<T: TwoContactImage>: Null where T.Right.Left == T.Right.Right {
    typealias Left = ContactMerge23<T>.Left
    typealias Right = ContactMerge23<T>.Right
}

enum RigidityAllowsTotalCollapse: Null {
    typealias C = CollapsedContactImage
    typealias Left = Paired<ContactMerge01<C>.Left, ContactMerge23<C>.Left>
    typealias Right = Paired<ContactMerge01<C>.Right, ContactMerge23<C>.Right>
}

enum RigiditySeparateContacts<A: Structure, B: Structure>: Null {
    typealias Q = SeparateContactQuotients<A, B>
    typealias Left = AddressTriple<Q.WSurvives.Left, Q.ZSurvives.Left, Q.RequiredAnswers.Left>
    typealias Right = AddressTriple<Q.WSurvives.Right, Q.ZSurvives.Right, Q.RequiredAnswers.Right>
}

enum RigidityCommonTarget<T: Pair, K: Structure>: Null where T.Right: Structure {
    typealias C = SharedContactAtMergedImage<T, K>
    typealias Left = Paired<C.Left, C.Application.Left.Right>
    typealias Right = Paired<C.Right, K>
}

// The actual shared projections return both source generators, without
// separate inverse or period requirements on the target medium.
enum RigidityDerivedReturns<T: TwoContactImage>: Null {
    typealias A = T.Left.Left
    typealias B = T.Left.Right
    typealias C = T.Right.Left
    typealias D = T.Right.Right
    typealias W3 = BoundaryWorking<A.Left.Left.Left, B.Left.Left.Left, C.Left.Left.Left, D.Left.Left.Left>
    typealias Z2 = BoundaryWorking<A.Right.Right, B.Right.Right, C.Right.Right, D.Right.Right>
    typealias Left = Paired<W3, Z2>
    typealias Original = BoundaryWorking<A, B, C, D>
    typealias Right = Paired<Original, Original>
}
#endif

#if LOCAL_PHASE_CONTACT_RIGIDITY_PARTIAL
// W descends to this two-point image. Z cannot: its one A node would
// require both A and B as Right. The failing conformance is an edge law.
enum RejectedContactRigidityPartial: TwoContactImage {
    enum A: Pair { typealias Left = A; typealias Right = B }
    enum B: Pair { typealias Left = B; typealias Right = A }
    typealias Left = Paired<A, B>
    typealias Right = Paired<A, A>
}
#endif

#if LOCAL_PHASE_CONTACT_RIGIDITY_ONE_CONTACT
enum RejectedContactRigidityOneContact: Null {
    typealias Q = SeparateContactQuotients<Never, Lit1>
    typealias Left = Q.ZAfterWQuotient.Right.Left
    typealias Right = Q.ZAfterWQuotient.Right.Right
}
#endif

#if LOCAL_PHASE_CONTACT_RIGIDITY_NO_CONTRAST
// The same collapsed image with the same resident answer A can be read
// repeatedly, but does not thereby recover B at the other source position.
enum RejectedContactRigidityNoContrast: Null {
    typealias A = FaithfulContactImage.A
    typealias B = FaithfulContactImage.B
    typealias Root = Paired<CollapsedContactImage.Point, A>
    typealias Decoder = SecondEvidenceImage<Root, BeamSpace, SaturationEncoding, SecondProjection>
    typealias Left = Paired<Decoder.Answer, Decoder.Answer>
    typealias Right = Paired<A, B>
}
#endif
