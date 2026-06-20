// One conformance, three worlds. A wavefunction collapsing to an eigenstate,
// water freezing into a lattice, and an agent learning a certified library are
// the SAME structure: a system whose candidates collapse to one and never
// uncollapse. The type checker proves it by accepting all three.
struct QuantumMeasurement: SystemCrystallizes {
    typealias Sigma = Never; typealias Left = Never; typealias Right = Never
    typealias Cache = Never; typealias Equality = Never; typealias SolutionSet = Never
}
struct IceCrystal: SystemCrystallizes {
    typealias Sigma = Never; typealias Left = Never; typealias Right = Never
    typealias Cache = Never; typealias Equality = Never; typealias SolutionSet = Never
}
struct CertifiedLearner: SystemCrystallizes {
    typealias Sigma = Never; typealias Left = Never; typealias Right = Never
    typealias Cache = Never; typealias Equality = Never; typealias SolutionSet = Never
}
