// String is a carrier. These collections index names by the common lexer's
// scalar identity, including when a name came from an untrusted certificate.
struct ScalarName: Hashable, Comparable, Codable, ExpressibleByStringLiteral, CustomStringConvertible {
    let text: String
    init(_ text: String) { self.text = text }
    init(_ name: ScalarName) { self = name }
    init(stringLiteral value: String) { self.init(value) }
    var description: String { text }
    var isEmpty: Bool { text.isEmpty }
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.text.unicodeScalars.lexicographicallyPrecedes(rhs.text.unicodeScalars)
    }
    init(from decoder: Decoder) throws {
        self.init(try decoder.singleValueContainer().decode(String.self))
    }
    func encode(to encoder: Encoder) throws {
        var value = encoder.singleValueContainer()
        try value.encode(text)
    }
    static func == (lhs: Self, rhs: Self) -> Bool { WhereJudge.sameName(lhs.text, rhs.text) }
    func hash(into hasher: inout Hasher) {
        hasher.combine(text.unicodeScalars.count)
        for scalar in text.unicodeScalars { hasher.combine(scalar.value) }
    }
}

extension Sequence
where Element == String {
    func containsName(_ name: String) -> Bool { contains { WhereJudge.sameName($0, name) } }
    func containsName(_ name: ScalarName) -> Bool { contains { ScalarName($0) == name } }
}

struct NameSet: Sequence, ExpressibleByArrayLiteral, Equatable {
    private
    var storage: Set<ScalarName>
    init() { storage = [] }
    init<S: Sequence>(_ words: S)
    where S.Element == String { storage = Set(words.map { ScalarName($0) }) }
    init<S: Sequence>(_ words: S)
    where S.Element == ScalarName { storage = Set(words) }
    init(arrayLiteral elements: String...) { self.init(elements) }
    var count: Int { storage.count }
    var isEmpty: Bool { storage.isEmpty }
    func sorted() -> [String] {
        storage.map(\.text).sorted { $0.unicodeScalars.lexicographicallyPrecedes($1.unicodeScalars) }
    }
    func makeIterator() -> IndexingIterator<[String]> { storage.map(\.text).makeIterator() }
    func contains(_ name: String) -> Bool { storage.contains(ScalarName(name)) }
    func contains(_ name: ScalarName) -> Bool { storage.contains(name) }
    @discardableResult mutating func insert(_ name: ScalarName) -> (inserted: Bool, memberAfterInsert: String) {
        let result = storage.insert(name)
        return (result.inserted, result.memberAfterInsert.text)
    }
    @discardableResult mutating func insert(_ name: String) -> (inserted: Bool, memberAfterInsert: String) {
        let result = storage.insert(ScalarName(name))
        return (result.inserted, result.memberAfterInsert.text)
    }
    @discardableResult mutating func remove(_ name: String) -> String? { storage.remove(ScalarName(name))?.text }
    mutating func formUnion<S: Sequence>(_ names: S)
    where S.Element == String { storage.formUnion(names.map { ScalarName($0) }) }
    func union<S: Sequence>(_ names: S) -> Self
    where S.Element == String {
        var result = self
        result.formUnion(names)
        return result
    }
    func intersection<S: Sequence>(_ names: S) -> Self
    where S.Element == String { Self(storage.intersection(names.map { ScalarName($0) }).map(\.text)) }
    func subtracting<S: Sequence>(_ names: S) -> Self
    where S.Element == String { Self(storage.subtracting(names.map { ScalarName($0) }).map(\.text)) }
    func isSubset<S: Sequence>(of names: S) -> Bool
    where S.Element == String { storage.isSubset(of: names.map { ScalarName($0) }) }
    func isDisjoint<S: Sequence>(with names: S) -> Bool
    where S.Element == String { storage.isDisjoint(with: names.map { ScalarName($0) }) }
}

struct NameMap<Value>: Sequence, ExpressibleByDictionaryLiteral {
    typealias Element = (key: String, value: Value)
    private
    var storage: [ScalarName: Value]
    init() { storage = [:] }
    init<S: Sequence>(uniqueKeysWithValues values: S)
    where S.Element == (String, Value) {
        storage = Dictionary(uniqueKeysWithValues: values.map { (ScalarName($0.0), $0.1) })
    }
    init(dictionaryLiteral elements: (String, Value)...) { self.init(uniqueKeysWithValues: elements) }
    var count: Int { storage.count }
    var isEmpty: Bool { storage.isEmpty }
    var keys: NameSet { NameSet(storage.keys.map(\.text)) }
    var values: Dictionary<ScalarName, Value>.Values { storage.values }
    func sorted() -> [Element] { storage.sorted { $0.key < $1.key }.map { ($0.key.text, $0.value) } }
    subscript(_ key: ScalarName) -> Value? {
        get { storage[key] }
        set { storage[key] = newValue }
        _modify { yield &storage[key] }
    }
    subscript(_ key: ScalarName, default fallback: @autoclosure () -> Value) -> Value {
        get { storage[key, default: fallback()] }
        _modify { yield &storage[key, default: fallback()] }
    }
    func makeIterator() -> IndexingIterator<[Element]> { storage.map { ($0.key.text, $0.value) }.makeIterator() }
    subscript(_ key: String) -> Value? {
        get { storage[ScalarName(key)] }
        set { storage[ScalarName(key)] = newValue }
        _modify { yield &storage[ScalarName(key)] }
    }
    subscript(_ key: String, default fallback: @autoclosure () -> Value) -> Value {
        get { storage[ScalarName(key), default: fallback()] }
        _modify { yield &storage[ScalarName(key), default: fallback()] }
    }
    @discardableResult mutating func removeValue(forKey key: String) -> Value? { storage.removeValue(forKey: ScalarName(key)) }
    mutating func merge(_ other: Self, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows {
        try storage.merge(other.storage, uniquingKeysWith: combine)
    }
    func mapValues<T>(_ transform: (Value) throws -> T) rethrows -> NameMap<T> {
        try NameMap<T>(uniqueKeysWithValues: storage.map { ($0.key.text, try transform($0.value)) })
    }
    func filter(_ include: (Element) throws -> Bool) rethrows -> Self {
        try Self(uniqueKeysWithValues: storage.filter { try include(($0.key.text, $0.value)) }.map { ($0.key.text, $0.value) })
    }
}
extension NameMap: Equatable
where Value: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        return lhs.allSatisfy { key, value in
            guard let other = rhs[key] else { return false }
            if let a = value as? String, let b = other as? String { return WhereJudge.sameName(a, b) }
            if let a = value as? [String], let b = other as? [String] { return WhereJudge.sameNames(a, b) }
            if let a = value as? [[String]], let b = other as? [[String]] {
                return a.count == b.count && zip(a, b).allSatisfy { WhereJudge.sameNames($0, $1) }
            }
            return value == other
        }
    }
}
private struct NameCodingKey: CodingKey {
    let stringValue: String
    var intValue: Int? { nil }
    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { return nil }
}
extension NameMap: Encodable
where Value: Encodable {
    func encode(to encoder: Encoder) throws {
        // Foundation's encoder also keys an object by canonical String. The
        // source guard excludes such pairs; an independently supplied map must
        // refuse here rather than lose an entry during serialization.
        var diagnostic = WhereJudge.WordGuard()
        for (index, name) in keys.enumerated() {
            try diagnostic.insert(.init(spelling: name, line: 1, byte: 0),
                origin: "certificate " + encoder.codingPath.map(\.stringValue).joined(separator: ".") + ".key[\(index)] (name value)")
        }
        var container = encoder.container(keyedBy: NameCodingKey.self)
        for (name, value) in self { try container.encode(value, forKey: NameCodingKey(stringValue: name)!) }
    }
}
extension NameMap: Decodable
where Value: Decodable {
    init(from decoder: Decoder) throws {
        self.init()
        guard decoder.userInfo[CourtJSON.scalarKeys] as? Bool == true else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                debugDescription: "name maps require CourtJSON.decoder() to preserve scalar keys"))
        }
        let container = try decoder.container(keyedBy: NameCodingKey.self)
        for key in container.allKeys { self[try CourtJSON.name(key.stringValue)] = try container.decode(Value.self, forKey: key) }
    }
}
