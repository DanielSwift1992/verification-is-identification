import VerificationIsIdentification

// A finite source language for one logical qubit and four binary controls.
// Row i denotes control bits (s0,s1,s2,s3), with s0 the most significant.
// These types construct frame and record relations; they do not execute a
// quantum operation, infer a probability law, or certify an external device.
// Export accepts the explicitly interpreted constructors, not arbitrary
// conformers to their open interfaces.

public protocol QuantumBit: Open {
    associatedtype Flipped: QuantumBit
}

public enum QBit0: Close, QuantumBit {
    public typealias Flipped = QBit1
}

public enum QBit1: Close, QuantumBit {
    public typealias Flipped = QBit0
}

/// Pauli frames are X^a Z^b modulo a scalar. ForQ is the sign bit for Q.
public protocol QuantumPauli: Open {
    associatedtype AfterH: QuantumPauli
    associatedtype AfterS: QuantumPauli
    associatedtype AfterZ: QuantumPauli
    associatedtype ForX: QuantumBit
    associatedtype ForY: QuantumBit
    associatedtype ForZ: QuantumBit
}

public enum QI: Close, QuantumPauli {
    public typealias AfterH = QI
    public typealias AfterS = QI
    public typealias AfterZ = QZ
    public typealias ForX = QBit0
    public typealias ForY = QBit0
    public typealias ForZ = QBit0
}

public enum QX: Close, QuantumPauli {
    public typealias AfterH = QZ
    public typealias AfterS = QY
    public typealias AfterZ = QY
    public typealias ForX = QBit0
    public typealias ForY = QBit1
    public typealias ForZ = QBit1
}

public enum QY: Close, QuantumPauli {
    public typealias AfterH = QY
    public typealias AfterS = QX
    public typealias AfterZ = QX
    public typealias ForX = QBit1
    public typealias ForY = QBit0
    public typealias ForZ = QBit1
}

public enum QZ: Close, QuantumPauli {
    public typealias AfterH = QX
    public typealias AfterS = QZ
    public typealias AfterZ = QI
    public typealias ForX = QBit1
    public typealias ForY = QBit1
    public typealias ForZ = QBit0
}

/// Sixteen supplied nonnegative weight expressions; normalization is external.
public protocol QuantumWeightTable: Open {
    associatedtype Row0: Structure
    associatedtype Row1: Structure
    associatedtype Row2: Structure
    associatedtype Row3: Structure
    associatedtype Row4: Structure
    associatedtype Row5: Structure
    associatedtype Row6: Structure
    associatedtype Row7: Structure
    associatedtype Row8: Structure
    associatedtype Row9: Structure
    associatedtype Row10: Structure
    associatedtype Row11: Structure
    associatedtype Row12: Structure
    associatedtype Row13: Structure
    associatedtype Row14: Structure
    associatedtype Row15: Structure
}

public enum QuantumWeights16<
    W0: Structure,
    W1: Structure,
    W2: Structure,
    W3: Structure,
    W4: Structure,
    W5: Structure,
    W6: Structure,
    W7: Structure,
    W8: Structure,
    W9: Structure,
    W10: Structure,
    W11: Structure,
    W12: Structure,
    W13: Structure,
    W14: Structure,
    W15: Structure
>: Close, QuantumWeightTable {
    public typealias Row0 = W0
    public typealias Row1 = W1
    public typealias Row2 = W2
    public typealias Row3 = W3
    public typealias Row4 = W4
    public typealias Row5 = W5
    public typealias Row6 = W6
    public typealias Row7 = W7
    public typealias Row8 = W8
    public typealias Row9 = W9
    public typealias Row10 = W10
    public typealias Row11 = W11
    public typealias Row12 = W12
    public typealias Row13 = W13
    public typealias Row14 = W14
    public typealias Row15 = W15
}

/// The actual Pauli frame at each declared control valuation.
public protocol QuantumFrameTable: Open {
    associatedtype Row0: QuantumPauli
    associatedtype Row1: QuantumPauli
    associatedtype Row2: QuantumPauli
    associatedtype Row3: QuantumPauli
    associatedtype Row4: QuantumPauli
    associatedtype Row5: QuantumPauli
    associatedtype Row6: QuantumPauli
    associatedtype Row7: QuantumPauli
    associatedtype Row8: QuantumPauli
    associatedtype Row9: QuantumPauli
    associatedtype Row10: QuantumPauli
    associatedtype Row11: QuantumPauli
    associatedtype Row12: QuantumPauli
    associatedtype Row13: QuantumPauli
    associatedtype Row14: QuantumPauli
    associatedtype Row15: QuantumPauli
}

public enum QuantumFrame16<
    P0: QuantumPauli,
    P1: QuantumPauli,
    P2: QuantumPauli,
    P3: QuantumPauli,
    P4: QuantumPauli,
    P5: QuantumPauli,
    P6: QuantumPauli,
    P7: QuantumPauli,
    P8: QuantumPauli,
    P9: QuantumPauli,
    P10: QuantumPauli,
    P11: QuantumPauli,
    P12: QuantumPauli,
    P13: QuantumPauli,
    P14: QuantumPauli,
    P15: QuantumPauli
>: Close, QuantumFrameTable {
    public typealias Row0 = P0
    public typealias Row1 = P1
    public typealias Row2 = P2
    public typealias Row3 = P3
    public typealias Row4 = P4
    public typealias Row5 = P5
    public typealias Row6 = P6
    public typealias Row7 = P7
    public typealias Row8 = P8
    public typealias Row9 = P9
    public typealias Row10 = P10
    public typealias Row11 = P11
    public typealias Row12 = P12
    public typealias Row13 = P13
    public typealias Row14 = P14
    public typealias Row15 = P15
}

/// One classical bit at each declared control valuation.
public protocol QuantumBitTable: Open {
    associatedtype Row0: QuantumBit
    associatedtype Row1: QuantumBit
    associatedtype Row2: QuantumBit
    associatedtype Row3: QuantumBit
    associatedtype Row4: QuantumBit
    associatedtype Row5: QuantumBit
    associatedtype Row6: QuantumBit
    associatedtype Row7: QuantumBit
    associatedtype Row8: QuantumBit
    associatedtype Row9: QuantumBit
    associatedtype Row10: QuantumBit
    associatedtype Row11: QuantumBit
    associatedtype Row12: QuantumBit
    associatedtype Row13: QuantumBit
    associatedtype Row14: QuantumBit
    associatedtype Row15: QuantumBit
}

public enum QuantumBits16<
    B0: QuantumBit,
    B1: QuantumBit,
    B2: QuantumBit,
    B3: QuantumBit,
    B4: QuantumBit,
    B5: QuantumBit,
    B6: QuantumBit,
    B7: QuantumBit,
    B8: QuantumBit,
    B9: QuantumBit,
    B10: QuantumBit,
    B11: QuantumBit,
    B12: QuantumBit,
    B13: QuantumBit,
    B14: QuantumBit,
    B15: QuantumBit
>: Close, QuantumBitTable {
    public typealias Row0 = B0
    public typealias Row1 = B1
    public typealias Row2 = B2
    public typealias Row3 = B3
    public typealias Row4 = B4
    public typealias Row5 = B5
    public typealias Row6 = B6
    public typealias Row7 = B7
    public typealias Row8 = B8
    public typealias Row9 = B9
    public typealias Row10 = B10
    public typealias Row11 = B11
    public typealias Row12 = B12
    public typealias Row13 = B13
    public typealias Row14 = B14
    public typealias Row15 = B15
}

/// Occurrence identity and the joint control law belong to the same source.
/// Equality of separate marginal laws does not identify two such sources.
public protocol QuantumSourceModel: Pair
where Left: Structure, Right: QuantumWeightTable {}

public enum QuantumSource<Tag: Structure, Law: QuantumWeightTable>: QuantumSourceModel {
    public typealias Left = Tag
    public typealias Right = Law
}

/// Right is constructed from the actual predecessor's frame. Source carries
/// the same occurrence and joint law through every program constructor.
public protocol QuantumProgram: Pair
where Right == Frame {
    associatedtype Source: QuantumSourceModel
    associatedtype Frame: QuantumFrameTable
}

public typealias QuantumIdentityFrame = QuantumFrame16<
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI,
    QI
>

public enum QuantumStart<S: QuantumSourceModel>: QuantumProgram {
    public typealias Source = S
    public typealias Left = S
    public typealias Frame = QuantumIdentityFrame
    public typealias Right = Frame
}

public enum QuantumFrameAfterH<F: QuantumFrameTable>: Close, QuantumFrameTable {
    public typealias Row0 = F.Row0.AfterH
    public typealias Row1 = F.Row1.AfterH
    public typealias Row2 = F.Row2.AfterH
    public typealias Row3 = F.Row3.AfterH
    public typealias Row4 = F.Row4.AfterH
    public typealias Row5 = F.Row5.AfterH
    public typealias Row6 = F.Row6.AfterH
    public typealias Row7 = F.Row7.AfterH
    public typealias Row8 = F.Row8.AfterH
    public typealias Row9 = F.Row9.AfterH
    public typealias Row10 = F.Row10.AfterH
    public typealias Row11 = F.Row11.AfterH
    public typealias Row12 = F.Row12.AfterH
    public typealias Row13 = F.Row13.AfterH
    public typealias Row14 = F.Row14.AfterH
    public typealias Row15 = F.Row15.AfterH
}
public enum QuantumFrameAfterS<F: QuantumFrameTable>: Close, QuantumFrameTable {
    public typealias Row0 = F.Row0.AfterS
    public typealias Row1 = F.Row1.AfterS
    public typealias Row2 = F.Row2.AfterS
    public typealias Row3 = F.Row3.AfterS
    public typealias Row4 = F.Row4.AfterS
    public typealias Row5 = F.Row5.AfterS
    public typealias Row6 = F.Row6.AfterS
    public typealias Row7 = F.Row7.AfterS
    public typealias Row8 = F.Row8.AfterS
    public typealias Row9 = F.Row9.AfterS
    public typealias Row10 = F.Row10.AfterS
    public typealias Row11 = F.Row11.AfterS
    public typealias Row12 = F.Row12.AfterS
    public typealias Row13 = F.Row13.AfterS
    public typealias Row14 = F.Row14.AfterS
    public typealias Row15 = F.Row15.AfterS
}
public enum QuantumFrameAfterZ0<F: QuantumFrameTable>: Close, QuantumFrameTable {
    public typealias Row0 = F.Row0
    public typealias Row1 = F.Row1
    public typealias Row2 = F.Row2
    public typealias Row3 = F.Row3
    public typealias Row4 = F.Row4
    public typealias Row5 = F.Row5
    public typealias Row6 = F.Row6
    public typealias Row7 = F.Row7
    public typealias Row8 = F.Row8.AfterZ
    public typealias Row9 = F.Row9.AfterZ
    public typealias Row10 = F.Row10.AfterZ
    public typealias Row11 = F.Row11.AfterZ
    public typealias Row12 = F.Row12.AfterZ
    public typealias Row13 = F.Row13.AfterZ
    public typealias Row14 = F.Row14.AfterZ
    public typealias Row15 = F.Row15.AfterZ
}
public enum QuantumFrameAfterZ1<F: QuantumFrameTable>: Close, QuantumFrameTable {
    public typealias Row0 = F.Row0
    public typealias Row1 = F.Row1
    public typealias Row2 = F.Row2
    public typealias Row3 = F.Row3
    public typealias Row4 = F.Row4.AfterZ
    public typealias Row5 = F.Row5.AfterZ
    public typealias Row6 = F.Row6.AfterZ
    public typealias Row7 = F.Row7.AfterZ
    public typealias Row8 = F.Row8
    public typealias Row9 = F.Row9
    public typealias Row10 = F.Row10
    public typealias Row11 = F.Row11
    public typealias Row12 = F.Row12.AfterZ
    public typealias Row13 = F.Row13.AfterZ
    public typealias Row14 = F.Row14.AfterZ
    public typealias Row15 = F.Row15.AfterZ
}
public enum QuantumFrameAfterZ2<F: QuantumFrameTable>: Close, QuantumFrameTable {
    public typealias Row0 = F.Row0
    public typealias Row1 = F.Row1
    public typealias Row2 = F.Row2.AfterZ
    public typealias Row3 = F.Row3.AfterZ
    public typealias Row4 = F.Row4
    public typealias Row5 = F.Row5
    public typealias Row6 = F.Row6.AfterZ
    public typealias Row7 = F.Row7.AfterZ
    public typealias Row8 = F.Row8
    public typealias Row9 = F.Row9
    public typealias Row10 = F.Row10.AfterZ
    public typealias Row11 = F.Row11.AfterZ
    public typealias Row12 = F.Row12
    public typealias Row13 = F.Row13
    public typealias Row14 = F.Row14.AfterZ
    public typealias Row15 = F.Row15.AfterZ
}
public enum QuantumFrameAfterZ3<F: QuantumFrameTable>: Close, QuantumFrameTable {
    public typealias Row0 = F.Row0
    public typealias Row1 = F.Row1.AfterZ
    public typealias Row2 = F.Row2
    public typealias Row3 = F.Row3.AfterZ
    public typealias Row4 = F.Row4
    public typealias Row5 = F.Row5.AfterZ
    public typealias Row6 = F.Row6
    public typealias Row7 = F.Row7.AfterZ
    public typealias Row8 = F.Row8
    public typealias Row9 = F.Row9.AfterZ
    public typealias Row10 = F.Row10
    public typealias Row11 = F.Row11.AfterZ
    public typealias Row12 = F.Row12
    public typealias Row13 = F.Row13.AfterZ
    public typealias Row14 = F.Row14
    public typealias Row15 = F.Row15.AfterZ
}
public enum QuantumH<P: QuantumProgram>: QuantumProgram {
    public typealias Previous = P
    public typealias Source = P.Source
    public typealias Left = Previous
    public typealias Frame = QuantumFrameAfterH<Previous.Frame>
    public typealias Right = Frame
}

public enum QuantumS<P: QuantumProgram>: QuantumProgram {
    public typealias Previous = P
    public typealias Source = P.Source
    public typealias Left = Previous
    public typealias Frame = QuantumFrameAfterS<Previous.Frame>
    public typealias Right = Frame
}

public enum QuantumZ0<P: QuantumProgram>: QuantumProgram {
    public typealias Previous = P
    public typealias Source = P.Source
    public typealias Left = Previous
    public typealias Frame = QuantumFrameAfterZ0<Previous.Frame>
    public typealias Right = Frame
}

public enum QuantumZ1<P: QuantumProgram>: QuantumProgram {
    public typealias Previous = P
    public typealias Source = P.Source
    public typealias Left = Previous
    public typealias Frame = QuantumFrameAfterZ1<Previous.Frame>
    public typealias Right = Frame
}

public enum QuantumZ2<P: QuantumProgram>: QuantumProgram {
    public typealias Previous = P
    public typealias Source = P.Source
    public typealias Left = Previous
    public typealias Frame = QuantumFrameAfterZ2<Previous.Frame>
    public typealias Right = Frame
}

public enum QuantumZ3<P: QuantumProgram>: QuantumProgram {
    public typealias Previous = P
    public typealias Source = P.Source
    public typealias Left = Previous
    public typealias Frame = QuantumFrameAfterZ3<Previous.Frame>
    public typealias Right = Frame
}

/// A record expression is sourced from the declared control occurrence.
/// Its table is constructed, never supplied as an independent claimed answer.
public protocol QuantumRecord: Pair
where Right == Table {
    associatedtype Source: QuantumSourceModel
    associatedtype Table: QuantumBitTable
}

public typealias QuantumZeroBits = QuantumBits16<
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0,
    QBit0
>

public enum RecordZero<S: QuantumSourceModel>: QuantumRecord {
    public typealias Source = S
    public typealias Left = S
    public typealias Table = QuantumZeroBits
    public typealias Right = Table
}

public enum QuantumBitsToggled0<T: QuantumBitTable>: Close, QuantumBitTable {
    public typealias Row0 = T.Row0
    public typealias Row1 = T.Row1
    public typealias Row2 = T.Row2
    public typealias Row3 = T.Row3
    public typealias Row4 = T.Row4
    public typealias Row5 = T.Row5
    public typealias Row6 = T.Row6
    public typealias Row7 = T.Row7
    public typealias Row8 = T.Row8.Flipped
    public typealias Row9 = T.Row9.Flipped
    public typealias Row10 = T.Row10.Flipped
    public typealias Row11 = T.Row11.Flipped
    public typealias Row12 = T.Row12.Flipped
    public typealias Row13 = T.Row13.Flipped
    public typealias Row14 = T.Row14.Flipped
    public typealias Row15 = T.Row15.Flipped
}
public enum RecordToggle0<R: QuantumRecord>: QuantumRecord {
    public typealias Previous = R
    public typealias Source = R.Source
    public typealias Left = Previous
    public typealias Table = QuantumBitsToggled0<Previous.Table>
    public typealias Right = Table
}

public enum QuantumBitsToggled1<T: QuantumBitTable>: Close, QuantumBitTable {
    public typealias Row0 = T.Row0
    public typealias Row1 = T.Row1
    public typealias Row2 = T.Row2
    public typealias Row3 = T.Row3
    public typealias Row4 = T.Row4.Flipped
    public typealias Row5 = T.Row5.Flipped
    public typealias Row6 = T.Row6.Flipped
    public typealias Row7 = T.Row7.Flipped
    public typealias Row8 = T.Row8
    public typealias Row9 = T.Row9
    public typealias Row10 = T.Row10
    public typealias Row11 = T.Row11
    public typealias Row12 = T.Row12.Flipped
    public typealias Row13 = T.Row13.Flipped
    public typealias Row14 = T.Row14.Flipped
    public typealias Row15 = T.Row15.Flipped
}
public enum RecordToggle1<R: QuantumRecord>: QuantumRecord {
    public typealias Previous = R
    public typealias Source = R.Source
    public typealias Left = Previous
    public typealias Table = QuantumBitsToggled1<Previous.Table>
    public typealias Right = Table
}

public enum QuantumBitsToggled2<T: QuantumBitTable>: Close, QuantumBitTable {
    public typealias Row0 = T.Row0
    public typealias Row1 = T.Row1
    public typealias Row2 = T.Row2.Flipped
    public typealias Row3 = T.Row3.Flipped
    public typealias Row4 = T.Row4
    public typealias Row5 = T.Row5
    public typealias Row6 = T.Row6.Flipped
    public typealias Row7 = T.Row7.Flipped
    public typealias Row8 = T.Row8
    public typealias Row9 = T.Row9
    public typealias Row10 = T.Row10.Flipped
    public typealias Row11 = T.Row11.Flipped
    public typealias Row12 = T.Row12
    public typealias Row13 = T.Row13
    public typealias Row14 = T.Row14.Flipped
    public typealias Row15 = T.Row15.Flipped
}
public enum RecordToggle2<R: QuantumRecord>: QuantumRecord {
    public typealias Previous = R
    public typealias Source = R.Source
    public typealias Left = Previous
    public typealias Table = QuantumBitsToggled2<Previous.Table>
    public typealias Right = Table
}

public enum QuantumBitsToggled3<T: QuantumBitTable>: Close, QuantumBitTable {
    public typealias Row0 = T.Row0
    public typealias Row1 = T.Row1.Flipped
    public typealias Row2 = T.Row2
    public typealias Row3 = T.Row3.Flipped
    public typealias Row4 = T.Row4
    public typealias Row5 = T.Row5.Flipped
    public typealias Row6 = T.Row6
    public typealias Row7 = T.Row7.Flipped
    public typealias Row8 = T.Row8
    public typealias Row9 = T.Row9.Flipped
    public typealias Row10 = T.Row10
    public typealias Row11 = T.Row11.Flipped
    public typealias Row12 = T.Row12
    public typealias Row13 = T.Row13.Flipped
    public typealias Row14 = T.Row14
    public typealias Row15 = T.Row15.Flipped
}
public enum RecordToggle3<R: QuantumRecord>: QuantumRecord {
    public typealias Previous = R
    public typealias Source = R.Source
    public typealias Left = Previous
    public typealias Table = QuantumBitsToggled3<Previous.Table>
    public typealias Right = Table
}

/// The supported finite list grammar is QuantumNoRecords/QuantumRecordsCons.
/// Each record and the list tail must belong to the very same source.
public protocol QuantumRecordList: Pair {
    associatedtype Source: QuantumSourceModel
}

public enum QuantumNoRecords<S: QuantumSourceModel>: QuantumRecordList {
    public typealias Source = S
    public typealias Left = Never
    public typealias Right = Never
}

public enum QuantumRecordsCons<R: QuantumRecord, Rest: QuantumRecordList>: QuantumRecordList
where R.Source == Rest.Source {
    public typealias Source = R.Source
    public typealias Left = R
    public typealias Right = Rest
}

public enum QuantumHistorySpace: Close {}
public enum QuantumHistoryEncoding: Close {}
public enum QuantumMeasureXQuestion: Close {}
public enum QuantumMeasureYQuestion: Close {}
public enum QuantumMeasureZQuestion: Close {}
public enum QuantumStateQuestion: Close {}

public enum QuantumBitsForX<F: QuantumFrameTable>: Close, QuantumBitTable {
    public typealias Row0 = F.Row0.ForX
    public typealias Row1 = F.Row1.ForX
    public typealias Row2 = F.Row2.ForX
    public typealias Row3 = F.Row3.ForX
    public typealias Row4 = F.Row4.ForX
    public typealias Row5 = F.Row5.ForX
    public typealias Row6 = F.Row6.ForX
    public typealias Row7 = F.Row7.ForX
    public typealias Row8 = F.Row8.ForX
    public typealias Row9 = F.Row9.ForX
    public typealias Row10 = F.Row10.ForX
    public typealias Row11 = F.Row11.ForX
    public typealias Row12 = F.Row12.ForX
    public typealias Row13 = F.Row13.ForX
    public typealias Row14 = F.Row14.ForX
    public typealias Row15 = F.Row15.ForX
}

public enum ReadX<F: QuantumFrameTable>: PredicateReading {
    public typealias Left = F
    public typealias Answer = QuantumBitsForX<F>
    public typealias Right = Answer
    public typealias Sigma = QuantumHistorySpace
    public typealias Encoding = QuantumHistoryEncoding
    public typealias Predicate = QuantumMeasureXQuestion
}

public enum QuantumBitsForY<F: QuantumFrameTable>: Close, QuantumBitTable {
    public typealias Row0 = F.Row0.ForY
    public typealias Row1 = F.Row1.ForY
    public typealias Row2 = F.Row2.ForY
    public typealias Row3 = F.Row3.ForY
    public typealias Row4 = F.Row4.ForY
    public typealias Row5 = F.Row5.ForY
    public typealias Row6 = F.Row6.ForY
    public typealias Row7 = F.Row7.ForY
    public typealias Row8 = F.Row8.ForY
    public typealias Row9 = F.Row9.ForY
    public typealias Row10 = F.Row10.ForY
    public typealias Row11 = F.Row11.ForY
    public typealias Row12 = F.Row12.ForY
    public typealias Row13 = F.Row13.ForY
    public typealias Row14 = F.Row14.ForY
    public typealias Row15 = F.Row15.ForY
}

public enum ReadY<F: QuantumFrameTable>: PredicateReading {
    public typealias Left = F
    public typealias Answer = QuantumBitsForY<F>
    public typealias Right = Answer
    public typealias Sigma = QuantumHistorySpace
    public typealias Encoding = QuantumHistoryEncoding
    public typealias Predicate = QuantumMeasureYQuestion
}

public enum QuantumBitsForZ<F: QuantumFrameTable>: Close, QuantumBitTable {
    public typealias Row0 = F.Row0.ForZ
    public typealias Row1 = F.Row1.ForZ
    public typealias Row2 = F.Row2.ForZ
    public typealias Row3 = F.Row3.ForZ
    public typealias Row4 = F.Row4.ForZ
    public typealias Row5 = F.Row5.ForZ
    public typealias Row6 = F.Row6.ForZ
    public typealias Row7 = F.Row7.ForZ
    public typealias Row8 = F.Row8.ForZ
    public typealias Row9 = F.Row9.ForZ
    public typealias Row10 = F.Row10.ForZ
    public typealias Row11 = F.Row11.ForZ
    public typealias Row12 = F.Row12.ForZ
    public typealias Row13 = F.Row13.ForZ
    public typealias Row14 = F.Row14.ForZ
    public typealias Row15 = F.Row15.ForZ
}

public enum ReadZ<F: QuantumFrameTable>: PredicateReading {
    public typealias Left = F
    public typealias Answer = QuantumBitsForZ<F>
    public typealias Right = Answer
    public typealias Sigma = QuantumHistorySpace
    public typealias Encoding = QuantumHistoryEncoding
    public typealias Predicate = QuantumMeasureZQuestion
}

public enum ReadState<F: QuantumFrameTable>: PredicateReading {
    public typealias Left = F
    public typealias Answer = F
    public typealias Right = Answer
    public typealias Sigma = QuantumHistorySpace
    public typealias Encoding = QuantumHistoryEncoding
    public typealias Predicate = QuantumStateQuestion
}

/// One source of the path, accessible record expressions, and final question.
/// These seams do not assert that the records suffice for the question.
/// A proposed decoder must be checked against the resulting actual row tables.
public enum QuantumContinuation<
    P: QuantumProgram,
    R: QuantumRecordList,
    Q: PredicateReading
>: Pair
where R.Source == P.Source, Q.Left == P.Frame,
      Q.Sigma == QuantumHistorySpace, Q.Encoding == QuantumHistoryEncoding {
    public typealias Program = P
    public typealias Records = R
    public typealias Question = Q
    public typealias Source = Program.Source
    public typealias Frame = Program.Frame
    public typealias Answer = Question.Answer
    public typealias Left = Program
    public typealias Right = Paired<Records, Question>
}
