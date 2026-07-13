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

// ── The standing accesses — asserted through the policy's own gates ──

/// The accesses the company asserts on every build. Each line instantiates ``Granted``,
/// and a gate satisfies ``Authorized`` only while the policy allows it, so revoking any
/// line's premise refuses the build and names it: tighten ``View`` past Carol's rank and
/// the error reads `'Carol.Rank' does not conform`. [V=I Thm 2]
public enum CertifiedAccesses: AccessLedger {
    @StructureBuilder
    public static var body: some Structure {
        Granted<View<Carol, FinanceShare>>.self           // an individual contributor reads her department's share
        Granted<View<Bob, EngineeringShare>>.self         // a lead reads his department's share
        Granted<Administer<Alice, FinanceVault>>.self     // a manager administers her department's vault
        Granted<Administer<Dave, EngineeringRepo>>.self   // the same rule, the other department
        Granted<Delete<Alice, FinanceVault>>.self         // only the owner, and only at manager rank, deletes
    }
}
