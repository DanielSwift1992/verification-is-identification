// §4.4 Value feature — source and target share the same value.

import Atom
import Engine

public enum SameValue<In: CellType, Out: CellType>: Rule
    where In.Val == Out.Val {
    public typealias Input = In
    public typealias Output = Out
}
