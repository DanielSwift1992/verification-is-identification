import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE DIRECTORIES names pure types, the way the framework is written (Law §0′).
//
// A directory (справочник) is a protocol: a finite category. Each element is an
// empty enum conforming to it, an ATOM. An empty enum is uninhabited, so it is a
// fixpoint: `Never`-like, a leaf, an id with nothing to distinguish behind it. A
// name IS such an atom. It carries no string of its own, the type is the value.
// Rendering converts the type to text (`label`, in View/ViewModel.swift), nothing here does.
//
// Kept as types, not enum cases, on purpose: a type stays open. You can hang a
// conformance on `Edsger` later (a claim for analytics, a condition), which a case can
// not carry. The set is closed only at the render boundary, not in the system.
//
// An attribute gains structure (a marker) exactly when a claim needs it: a birth year
// is an atom here because nothing yet orders it; the day a rule says "born before X",
// it becomes `IntegerValued`. Atom by default, marker on demand.
// ═══════════════════════════════════════════════════════════════

/// This names the directory of given names. `Open`, so an atom is `Structure`-conforming and can
/// be read directly (`Symbol`, DocumentKit), not a stored string (Law §0′).
public protocol GivenName: Open {}

/// This gives the named team's given names, nested so each reads as the bare word (`Symbol` /
/// `String(describing:)` on a nested type reads its short name, not the qualified path, the same
/// reading `Nav`'s places already rely on) WITHOUT colliding with the handle enum of
/// the same word (`Alice: Employee`, Team.swift: one Swift module cannot declare two top-level
/// types named `Alice`). Deliberately equal to the handle: a named person's displayed given name
/// and the identifier every link/breadcrumb on the site already uses for them read the same
/// word, so a reader does not have to map "Alice" the handle onto a different "real" first name.
public enum HandleName {
    /// This is Alice.
    public enum Alice: GivenName {}
    /// This is Bob.
    public enum Bob: GivenName {}
    /// This is Carol.
    public enum Carol: GivenName {}
    /// This is Dave.
    public enum Dave: GivenName {}
}

/// This names a given name, cyclic: the generator's round-robin seed for a hire's name pool,
/// propagated the way `Coloring`'s `Machine.Opposite` derives one task's assignment from
/// another's. Only the generated pool conforms (GeneratedTeam.swift): the named four are each
/// their pick, not a position in a cycle. `Sex` is the gender the name itself carries (documented
/// intent, GeneratedTeam.swift's header), so a hire's `Sex` reads off its OWN `Given.Sex`
/// rather than stepping its separate chain.
public protocol GivenNameCycle: GivenName {
    associatedtype Next: GivenNameCycle
    associatedtype Sex: Gender
}

/// This names the directory of family names. `Open`, so an atom is directly readable (`Symbol`).
public protocol FamilyName: Open {}
/// This is Lovelace.
public enum Lovelace: FamilyName {}
/// This is Turing.
public enum Turing: FamilyName {}
/// This is Hopper.
public enum Hopper: FamilyName {}
/// This is Torvalds.
public enum Torvalds: FamilyName {}

/// This names a family name, cyclic: the generator's round-robin seed, the same shape as
/// ``GivenNameCycle``. Only the generated pool conforms.
public protocol FamilyNameCycle: FamilyName {
    associatedtype Next: FamilyNameCycle
}

/// This names the directory of genders. `Open`, so an atom is directly readable (`Symbol`).
public protocol Gender: Open {}
/// This is Female.
public enum Female: Gender {}
/// This is Male.
public enum Male: Gender {}
/// This is Non-binary.
public enum Nonbinary: Gender {}

/// This names the directory of birth years. An atom per year for now: no claim orders them yet.
/// The day one does, `BirthYear` becomes `IntegerValued`. `Open`, so an atom is directly
/// readable (`Symbol`).
public protocol BirthYear: Open {}
/// This is 1815.
public enum Y1815: BirthYear {}
/// This is 1906.
public enum Y1906: BirthYear {}
/// This is 1912.
public enum Y1912: BirthYear {}
/// This is 1969.
public enum Y1969: BirthYear {}

/// This names a birth year, cyclic: the generator's round-robin seed, the same shape as
/// ``GivenNameCycle``. Only the generated pool conforms.
public protocol BirthYearCycle: BirthYear {
    associatedtype Next: BirthYearCycle
}

/// This names a person composed from the directories. Every field is a required, typed atom: the
/// compiler will not let a person exist without a given name, a family name, a gender, a
/// birth year, and a work arrangement. The composition is the record, there is no stored copy.
/// `Site` is the first claim a policy makes about the person directly (return-to-office), and
/// it sits on ``Person`` rather than ``Employee`` so a role representative (an ``Employee``
/// that is no one in particular) needs none.
public protocol Person {
    associatedtype Given: GivenName
    associatedtype Family: FamilyName
    associatedtype Sex: Gender
    associatedtype Born: BirthYear
    associatedtype Site: Workplace
}
