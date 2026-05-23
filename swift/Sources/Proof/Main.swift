import Atom
import Compose
import Engine

@main
struct Proof {
    // §4.7 demonstration: ShiftRight ∧ SameValue
    typealias In  = Cell<N1, N1, N5>
    typealias Out = Cell<N1, N2, N5>
    typealias Demo = And<ShiftRight<In, Out>, SameValue<In, Out>>

    static func main() {
        print("Appendix C — Compile-Time Verification")
        print("CompilationGate<R> = §4.7: compiler = verifier")
        print()

        // This line compiles ⟺ the type constraints hold.
        // That IS the verification. No runtime check needed.
        CompilationGate<Demo>.verify()
        let out = CompilationGate<Demo>.identify(input: In.self).materialized
        print("  ✓  ShiftRight ∧ SameValue")
        print("     \(In.materialized) → \(out)")

        // Identity proof: every cell maps to itself.
        print()
        print("── Identity (all cells) ──")
        for gate in IdentityProof.gates {
            print("  ✓  \(gate)")
        }

        print()
        print("── REJECT demonstrations ──")
        #if REJECT_COMPILE_TESTS
        print("  REJECT_COMPILE_TESTS — expect build failure")
        #else
        print("  \(RejectDemos.note)")
        #endif

        print()
        print("What this proves:")
        print("  • Each CompilationGate<R> compiles ⟺ R's type constraints hold")
        print("  • The Swift compiler IS the verifier (§4.7)")
        print("  • REJECT = the code does not compile (demonstrated with -DREJECT_COMPILE_TESTS)")
    }
}
