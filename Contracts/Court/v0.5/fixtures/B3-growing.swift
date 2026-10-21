public protocol Root {}
public enum Unit: Root {}
public enum Other: Root {}
public protocol Pair: Root { associatedtype Left; associatedtype Right }
public protocol Same: Pair where Left == Right {}
public enum Plus<L: Root, R: Root>: Root {}
public typealias Twice<T: Root> = Plus<T,T>
public typealias U1 = Unit
public typealias U2 = Twice<U1>
public typealias U4 = Twice<U2>
public typealias U8 = Twice<U4>
public typealias U16 = Twice<U8>
public typealias U32 = Twice<U16>
public typealias U64 = Twice<U32>
public typealias U128 = Twice<U64>
public typealias U256 = Twice<U128>
public typealias U512 = Twice<U256>
public typealias U1024 = Twice<U512>
public typealias U2048 = Twice<U1024>
public typealias U4096 = Twice<U2048>
public typealias U8192 = Twice<U4096>
public typealias U16384 = Twice<U8192>
public typealias U32768 = Twice<U16384>
public typealias U65536 = Twice<U32768>
public typealias U131072 = Twice<U65536>
public typealias U262144 = Twice<U131072>
public typealias Grow<T: Root> = Grow<Plus<T,T>>
public enum Use: Same { public typealias Left = Grow<Unit>; public typealias Right = Grow<Unit> }
