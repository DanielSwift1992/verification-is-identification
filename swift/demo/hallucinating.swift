// A LANGUAGE MODEL — identical to the certified system but for ONE line.
// Its solution set never collapses (|S| > 1): no gate. It cannot tell a proof
// from a guess, so it emits the guess as if certified — a hallucination.
struct LanguageModel {
    typealias Sigma       = Never
    typealias Left        = Never
    typealias Right       = Never
    typealias Cache       = Never
    typealias Equality    = Never
    typealias SolutionSet = Cell<Three, Never>   // NO GATE — |S| > 1  (not Unique)
}

// The compiler refuses to certify it, and names the missing coordinate:
extension LanguageModel: SystemCrystallizes {}
