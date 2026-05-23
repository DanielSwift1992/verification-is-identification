// REJECT gate demonstrations — enable with: swift build -Xswiftc -DREJECT_COMPILE_TESTS
//
// Expected: compiler error at the named gate.

import Atom
import Compose
import Engine

#if REJECT_COMPILE_TESTS

/// REJECT(basis): output value N5 not in input basis {N3}.
enum RejectBasisDemo {
    typealias Bad = BasisGate<Cell<N0, N0, N3>, Cell<N0, N0, N5>>
    static let gate = CompilationGate<Bad>.self
}

/// REJECT(map): ShiftRight expects S<N0>==N1 col, not N2.
enum RejectMapDemo {
    typealias Bad = ShiftRight<Cell<N0, N0, N1>, Cell<N0, N2, N1>>
    static let gate = CompilationGate<Bad>.self
}

#else

enum RejectDemos {
    static let note = """
    REJECT gates compile only with -DREJECT_COMPILE_TESTS (expect failure):
      RejectBasisDemo  — value ∉ input basis
      RejectMapDemo    — ShiftRight col mismatch
    """
}

#endif
