import Notation
import DocumentKit
public enum FirstFace: OutlineFontFace, Close { public typealias Units = U1; public typealias Glyphs = Never }
public enum OtherFace: OutlineFontFace, Close { public typealias Units = U1; public typealias Glyphs = Never }
public enum DeclaredRegister: OutlineRegister { public typealias Font = FirstFace; public typealias Size = U1 }
public enum PairProof: Pair { public typealias Left = U1; public typealias Right = U1 }
public enum PairWitness: ReadablePaintPair { public typealias WitnessName = Never; public typealias Foreground = Ink; public typealias Background = Paper; public typealias Proof = PairProof }
public enum TypedLabel: OutlineLabel {
    public typealias Register = DeclaredRegister
    public typealias Font = OtherFace
    public typealias Size = U1
    public typealias Content = Never
    public typealias X = Never
    public typealias Y = Never
    public typealias Fill = Ink
    public typealias Legibility = PairWitness
    public typealias Anchor = Never
}
