import DocumentKit
import VerificationIsIdentification

/// Reads Root.Left's declaration and independently requested readings, and
/// Root.Right.Left's actual covered readings. Root.Right.Right can retain an
/// archive, but cannot replace declaration, request or result. Coverage uses the
/// leaf/join/group constructor grammar described in Verdict §6b.
/// The text is a reading of these fields, not another proof-status field.
public enum CoveredStatement<Root: Pair>: Close
where Root.Left: Pair, Root.Left.Right: VerdictCoversBranches,
      Root.Right: Pair, Root.Right.Left: CoverageMatchesDeclaration,
      Root.Left.Left == Root.Right.Left.Right,
      Root.Left.Left == Root.Left.Right.Candidates,
      Root.Left.Right.Sigma == Root.Right.Left.Left.Sigma,
      Root.Left.Right.Encoding == Root.Right.Left.Left.Encoding,
      Root.Left.Right.Answer == Root.Right.Left.Left.Answer {}

extension CoveredStatement {
    public static var typeName: String {
        "The independently requested and proposed coverage records have the "
            + "same declared candidate representation, space, encoding and answer.\n\n"
            + "For finite leaf/join/group constructions, these relations establish "
            + "the requested answer at every represented leaf. Membership in that "
            + "constructor grammar is a separate requirement; open protocol "
            + "conformance alone does not establish it.\n\n"
            + "```text\n"
            + "support: " + String(reflecting: Root.Left.Left.self) + "\n"
            + "request: " + String(reflecting: Root.Left.Right.self) + "\n"
            + "space: " + String(reflecting: Root.Left.Right.Sigma.self) + "\n"
            + "encoding: " + String(reflecting: Root.Left.Right.Encoding.self) + "\n"
            + "question: " + String(reflecting: Root.Left.Right.Predicate.self) + "\n"
            + "requested answer: " + String(reflecting: Root.Left.Right.Answer.self) + "\n"
            + "derivation: " + String(reflecting: Root.Right.Left.Left.self) + "\n"
            + "derived operation: " + String(reflecting: Root.Right.Left.Left.Predicate.self) + "\n"
            + "answer: " + String(reflecting: Root.Right.Left.Left.Answer.self) + "\n"
            + "```\n"
    }
}
