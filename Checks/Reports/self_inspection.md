# Internal self-inspection and Boolean diagonalization

## Exact obstruction

A total evaluator E:C×C→{0,1} cannot represent its own diagonal complement
d(c)=1−E(c,c). If a represents d, substituting c=a gives E(a,a)=1−E(a,a).
All 530 Boolean matrices for code sets
of sizes 1, 2 and 3 obey this. Total self-application alone is allowed:
E=((0,0),(0,1)) has E(1,1)=1. Its missing diagonal complement is (1,0).
The proof excludes universality with this diagonal, not every self-inspection.

## Closed finite inspection

The whole has 49152 states: a four-bit resident implemented
gate C, four-bit resident reference S, four mismatch bits r, verdict v and
phase 0…5. No checker, reference register or clock is outside this model.
At phases i=0…3, r_i is flipped by C_i XOR S_i; at phase 4, v is flipped
iff r=0; phase 5 wraps to 0. Decreasing phase and repeating the corresponding
flip is the inverse. Every state and both inverse identities were checked.

From r=0, v=0, phase=0, five ticks produce v=1 iff C=S. All 256 candidate /
reference pairs were checked. For the equality reference (1,0,0,1), exactly
one of 16 candidate gates passes. A uniform preparation over candidates
retains four bits of whole entropy. The candidate is the same resident
implementation whose input/output table the inspection reads.

This proves relative correctness of an internal component under the declared
transition semantics. It does not prove those semantics or the intended
meaning of S without premises. Coherently wrong C=S passes. Unprepared r or
v can also produce false acceptance; the readout window is finite and the
clock continues. Physical closure and logical justification are separate.

## Circular test can fail

If the candidate gate itself compares each actual output with the equality
reference output, 5 of 16 gates accept themselves.
Four are wrong, including constant true and XOR. This finite counterexample
shows that a reassuring self-test needs an explicit soundness argument.
It is not an impossibility proof for all internal checking architectures.

The Swift witness only projects a represented evaluator's two self-readings.
Two independently compiled refusals reject identification of the missing
diagonal complement with either represented row. It does not implement the
finite machine, prove all truth-table sizes or certify the Swift compiler.

Sources: Lawvere, Diagonal Arguments and Cartesian Closed Categories,
[primary reprint](https://conceptualmathematics.wordpress.com/wp-content/uploads/2025/03/diagonal_arguments.pdf),
Theorem 1.1; [CakeML POPL 2014](https://cakeml.org/popl14.pdf), abstract and §2.1,
for an established example of verified bootstrapping relative to semantics.
Neither self-application nor verified bootstrapping is claimed as a VI novelty.
