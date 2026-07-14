import VerificationIsIdentification
import DocumentKit
import Examples

// THE WORLD: one file, four slots, and that is the whole state of the system.
// Three slots are terms moved by the dictionary's triples; the fourth is a
// LITERAL slot: free text in a typeName, the medium's prose genre. Its three
// movements — append, rubout, clear — are the applier's own
// (`swift run Tools press append Note …`), the judge vets the FORM of the
// file, and a label draws the literal with no reader in between.

typealias LampMode = LampOff
typealias Count = Never
typealias PinProgress = PinStage0

enum Note: Close {}
extension Note {
    static var typeName: String { "" }
}
