// §4.2 Basis gate — output value must exist in input.

import Atom
import Engine

public enum BasisGate<In: CellType, Out: CellType>: Rule
    where In.Val == Out.Val {
    public typealias Input = In
    public typealias Output = Out
}
