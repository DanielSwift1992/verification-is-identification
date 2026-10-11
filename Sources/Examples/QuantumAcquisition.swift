import VerificationIsIdentification

// A bounded extension of the quantum source language. Residents describe
// currently available internal carriers; they are not accessible records.
// Only the explicitly interpreted constructors establish that distinction.
public protocol QuantumResidentProgram: QuantumProgram {
    associatedtype Residents: Structure
}

extension QuantumStart: QuantumResidentProgram {
    public typealias Residents = Never
}

extension QuantumH: QuantumResidentProgram
where P: QuantumResidentProgram {
    public typealias Residents = P.Residents
}

extension QuantumS: QuantumResidentProgram
where P: QuantumResidentProgram {
    public typealias Residents = P.Residents
}

extension QuantumZ0: QuantumResidentProgram
where P: QuantumResidentProgram {
    public typealias Residents = P.Residents
}

extension QuantumZ1: QuantumResidentProgram
where P: QuantumResidentProgram {
    public typealias Residents = P.Residents
}

extension QuantumZ2: QuantumResidentProgram
where P: QuantumResidentProgram {
    public typealias Residents = P.Residents
}

extension QuantumZ3: QuantumResidentProgram
where P: QuantumResidentProgram {
    public typealias Residents = P.Residents
}

/// The predecessor identifies this occurrence of retained Z1 in the word.
public enum QuantumRetainedZ1Control<P: QuantumResidentProgram>: Close {}

/// Apply Z using control 1 and retain that same classical control carrier.
/// The interpreter must bind the gate and the resident to the same handle.
/// The source law and table alone do not certify a physical implementation.
public enum RetainedQuantumZ1<P: QuantumResidentProgram>: QuantumResidentProgram {
    public typealias Previous = P
    public typealias Primitive = QuantumZ1<Previous>
    public typealias Source = Previous.Source
    public typealias Left = Previous
    public typealias Frame = Primitive.Frame
    public typealias Right = Frame
    public typealias ControlRecord = RecordToggle1<RecordZero<Source>>

    public enum ControlReading: PredicateReading {
        public typealias Left = Primitive
        public typealias Right = ControlRecord.Table
        public typealias Sigma = QuantumHistorySpace
        public typealias Encoding = QuantumHistoryEncoding
        public typealias Predicate = QuantumRetainedZ1Control<Previous>
        public typealias Answer = Right
    }

    public enum StoredFact: Close, HasVerdict {
        public typealias Sigma = ControlReading.Sigma
        public typealias Encoding = ControlReading.Encoding
        public typealias Predicate = ControlReading.Predicate
        public typealias Answer = ControlReading.Answer
    }

    /// Bind the stored fact to the actual control reading of this primitive.
    public enum Production: RetainedReadingRecord {
        public typealias Reading = ControlReading
        public typealias Left = Reading.Left
        public typealias Right = Paired<Left, StoredFact>
    }

    public typealias Residents = Paired<Production.Right.Right, Previous.Residents>
}

/// Remove contact availability while leaving the logical frame unchanged.
/// This constructor makes no claim that discarded storage is physically erased.
public enum DestroyResidents<P: QuantumResidentProgram>: QuantumResidentProgram {
    public typealias Previous = P
    public typealias Source = Previous.Source
    public typealias Left = Previous
    public typealias Frame = Previous.Frame
    public typealias Right = Frame
    public typealias Residents = Never
}

/// Read the first fact at its current resident address, not an ancestor's
/// forgotten field or a separately supplied record with a matching source.
public enum ReadFirstResident<P: QuantumResidentProgram>: PredicateReading
where P.Residents: Pair, P.Residents.Left: HasVerdict,
      P.Residents.Left.Answer: QuantumBitTable,
      P.Residents.Left.Sigma == QuantumHistorySpace,
      P.Residents.Left.Encoding == QuantumHistoryEncoding {
    public typealias Resident = P.Residents.Left
    public typealias Left = P
    public typealias Right = Resident.Answer
    public typealias Sigma = Resident.Sigma
    public typealias Encoding = Resident.Encoding
    public typealias Predicate = Resident.Predicate
    public typealias Answer = Right
}

/// Record this particular available contact. These current-contact endpoints
/// implement the core AcquiresAnswer relation without a caller-supplied answer.
public enum AcquireFirstResident<P: QuantumResidentProgram>: AcquiresAnswer
where P.Residents: Pair, P.Residents.Left: HasVerdict,
      P.Residents.Left.Answer: QuantumBitTable,
      P.Residents.Left.Sigma == QuantumHistorySpace,
      P.Residents.Left.Encoding == QuantumHistoryEncoding {
    public typealias Left = ReadFirstResident<P>

    public enum ReplyFact: Close, HasVerdict {
        public typealias Sigma = ReadFirstResident<P>.Sigma
        public typealias Encoding = ReadFirstResident<P>.Encoding
        public typealias Predicate = ReadFirstResident<P>.Predicate
        public typealias Answer = ReadFirstResident<P>.Answer
    }

    public enum RecordedContact: RetainedReadingRecord {
        public typealias Reading = ReadFirstResident<P>
        public typealias Left = Reading.Left
        public typealias Right = Paired<Left, ReplyFact>
    }

    public enum ObserveReply: PredicateReading {
        public typealias Left = RecordedContact.Left
        public typealias Right = RecordedContact.Right.Right
        public typealias Sigma = ReadFirstResident<P>.Sigma
        public typealias Encoding = ReadFirstResident<P>.Encoding
        public typealias Predicate = ReadFirstResident<P>
        public typealias Answer = Right
    }

    public enum ReadReply: RecordedAnswerReading {
        public typealias Left = RecordedContact.Right.Right
        public typealias Right = Left.Answer
        public typealias Sigma = Left.Sigma
        public typealias Encoding = Left.Encoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Right
    }

    public typealias Record = RecordedContact
    public typealias Observation = ObserveReply
    public typealias Right = ReadReply
    public typealias Sigma = Left.Sigma
    public typealias Encoding = Left.Encoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

/// Accessible memory is the answer in the actual acquisition's recorded fact.
/// An external interpreter admits the nominal contact acquisitions it supports;
/// arbitrary conformers to AcquiresAnswer are not an execution authorization.
public enum ContactReplyRecord<A: AcquiresAnswer>: QuantumRecord
where A.Left.Left: QuantumResidentProgram,
      A.Record.Right.Right.Answer: QuantumBitTable {
    public typealias Acquisition = A
    public typealias Source = Acquisition.Left.Left.Source
    public typealias Left = Acquisition.Record.Right.Right
    public typealias Table = Left.Answer
    public typealias Right = Table
}

/// One construction for all contact replies. The reply precedes the old list;
/// no observed bit or independent replacement record is a type parameter.
public enum ContactAugmented<
    P: QuantumResidentProgram,
    R: QuantumRecordList,
    Q: PredicateReading
>: Pair
where R.Source == P.Source, Q.Left == P.Frame,
      Q.Sigma == QuantumHistorySpace, Q.Encoding == QuantumHistoryEncoding,
      P.Residents: Pair, P.Residents.Left: HasVerdict,
      P.Residents.Left.Answer: QuantumBitTable,
      P.Residents.Left.Sigma == QuantumHistorySpace,
      P.Residents.Left.Encoding == QuantumHistoryEncoding {
    public typealias Program = P
    public typealias Source = Program.Source
    public typealias Question = Q
    public typealias Base = QuantumContinuation<Program, R, Question>
    public typealias Acquisition = AcquireFirstResident<Program>
    public typealias Reply = ContactReplyRecord<Acquisition>
    public typealias Records = QuantumRecordsCons<Reply, R>
    public typealias Continuation = QuantumContinuation<Program, Records, Question>
    public typealias Left = Base
    public typealias Right = Continuation
}
