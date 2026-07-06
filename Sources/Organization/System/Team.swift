import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// A readable slice of the company. GeneratedTeam.swift scales this to hundreds;
// here are a few named people so the policy stays legible.
// ═══════════════════════════════════════════════════════════════

// ── Passcodes — each composed through the body pattern ──

/// This is Alice's passcode: 3-1-4-1
public enum AlicePass: SpelledSecret {
    @StructureBuilder
    public static var body: some Structure & Spelled {
        Numeral._3.self
        Numeral._1.self
        Numeral._4.self
        Numeral._1.self
    }
}

/// This is Bob's passcode: 2-7-1-8
public enum BobPass: SpelledSecret {
    @StructureBuilder
    public static var body: some Structure & Spelled {
        Numeral._2.self
        Numeral._7.self
        Numeral._1.self
        Numeral._8.self
    }
}

/// This is Carol's passcode: 1-6-1-8
public enum CarolPass: SpelledSecret {
    @StructureBuilder
    public static var body: some Structure & Spelled {
        Numeral._1.self
        Numeral._6.self
        Numeral._1.self
        Numeral._8.self
    }
}

/// This is Dave's passcode: 1-4-1-4
public enum DavePass: SpelledSecret {
    @StructureBuilder
    public static var body: some Structure & Spelled {
        Numeral._1.self
        Numeral._4.self
        Numeral._1.self
        Numeral._4.self
    }
}

// ── The named people ──

/// This is Alice Lovelace, a manager in Finance, owner of the Finance vault. `Given` is
/// ``HandleName/Alice``, the same word every link on the site already uses for her.
public enum Alice: Employee, Credentialed {
    public typealias Rank = Manager
    public typealias Home = Finance
    public typealias Given = HandleName.Alice
    public typealias Family = Lovelace
    public typealias Sex = Female
    public typealias Born = Y1815
    public typealias Site = OnSite
    public typealias Pass = AlicePass
}

/// This is Bob Turing, a lead in Engineering. `Given` is ``HandleName/Bob``.
public enum Bob: Employee, Credentialed {
    public typealias Rank = Lead
    public typealias Home = Engineering
    public typealias Given = HandleName.Bob
    public typealias Family = Turing
    public typealias Sex = Male
    public typealias Born = Y1912
    public typealias Site = Hybrid
    public typealias Pass = BobPass
}

/// This is Carol Hopper, an individual contributor in Finance. `Given` is ``HandleName/Carol``.
public enum Carol: Employee, Credentialed {
    public typealias Rank = IndividualContributor
    public typealias Home = Finance
    public typealias Given = HandleName.Carol
    public typealias Family = Hopper
    public typealias Sex = Female
    public typealias Born = Y1906
    public typealias Site = Remote
    public typealias Pass = CarolPass
}

/// This is Dave Torvalds, a manager in Engineering, owner of the Engineering repo. `Given` is
/// ``HandleName/Dave``.
public enum Dave: Employee, Credentialed {
    public typealias Rank = Manager
    public typealias Home = Engineering
    public typealias Given = HandleName.Dave
    public typealias Family = Torvalds
    public typealias Sex = Male
    public typealias Born = Y1969
    public typealias Site = OnSite
    public typealias Pass = DavePass
}

// ── Documents — the vaults the policy gates ──

/// This is the Finance vault, owned by Alice.
public enum FinanceVault: Doc, Owned {
    public typealias Home = Finance
    public typealias Owner = Alice
}

/// This is the Engineering repository, owned by Dave.
public enum EngineeringRepo: Doc, Owned {
    public typealias Home = Engineering
    public typealias Owner = Dave
}

// The accesses are proved by the types that compile:
//   View<Carol, FinanceVault>:       Carol views Finance (same department)
//   Administer<Alice, FinanceVault>: Alice admins Finance (manager rank)
//   Delete<Alice, FinanceVault>:     Alice deletes her vault (owner gate, |S|=1)
// OwnerGate: SystemCrystallizes:     the gate crystallizes, V=I Thm 2.
//
// The conformance IS the proof. No binding needed.
