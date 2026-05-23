// Appendix C — one CompilationGate per atom mapping.
// Identity: every cell maps to itself.

import Atom
import Compose
import Engine

enum IdentityProof {
    // Train: [[1,2],[3,4]] → [[1,2],[3,4]]
    typealias T_00 = IdentityMap<Cell<N0, N0, N1>, Cell<N0, N0, N1>>
    typealias T_01 = IdentityMap<Cell<N0, N1, N2>, Cell<N0, N1, N2>>
    typealias T_10 = IdentityMap<Cell<N1, N0, N3>, Cell<N1, N0, N3>>
    typealias T_11 = IdentityMap<Cell<N1, N1, N4>, Cell<N1, N1, N4>>

    // Test: [[2,0],[0,3]] → [[2,0],[0,3]]
    typealias X_00 = IdentityMap<Cell<N0, N0, N2>, Cell<N0, N0, N2>>
    typealias X_01 = IdentityMap<Cell<N0, N1, N0>, Cell<N0, N1, N0>>
    typealias X_10 = IdentityMap<Cell<N1, N0, N0>, Cell<N1, N0, N0>>
    typealias X_11 = IdentityMap<Cell<N1, N1, N3>, Cell<N1, N1, N3>>

    static let gates: [any Gate.Type] = [
        CompilationGate<T_00>.self, CompilationGate<T_01>.self,
        CompilationGate<T_10>.self, CompilationGate<T_11>.self,
        CompilationGate<X_00>.self, CompilationGate<X_01>.self,
        CompilationGate<X_10>.self, CompilationGate<X_11>.self,
    ]
}
