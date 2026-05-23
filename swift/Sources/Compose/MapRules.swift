// §4.4 Positional features + §4.1 atom binding.

import Atom
import Engine

public enum SameRow<In: CellType, Out: CellType>: Rule
    where In.Row == Out.Row {
    public typealias Input = In
    public typealias Output = Out
}

public enum SameCol<In: CellType, Out: CellType>: Rule
    where In.Col == Out.Col {
    public typealias Input = In
    public typealias Output = Out
}

public enum ShiftRight<In: CellType, Out: CellType>: Rule
    where In.Row == Out.Row, S<In.Col> == Out.Col {
    public typealias Input = In
    public typealias Output = Out
}

public enum Transpose<In: CellType, Out: CellType>: Rule
    where In.Row == Out.Col, In.Col == Out.Row {
    public typealias Input = In
    public typealias Output = Out
}

/// Identity: same position, same value.
public enum IdentityMap<In: CellType, Out: CellType>: Rule
    where In.Row == Out.Row, In.Col == Out.Col, In.Val == Out.Val {
    public typealias Input = In
    public typealias Output = Out
}
