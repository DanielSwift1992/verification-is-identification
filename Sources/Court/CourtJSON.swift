import Foundation

/// The existing JSON decoder with injective scalar keys before its String-key
/// table is built. The wire names are unchanged. NameMap unwraps these keys;
/// fixed ASCII schema fields retain the usual Codable spelling.
public enum CourtJSON {
    static let scalarKeys = CodingUserInfoKey(rawValue: "vi.court.scalar-json-keys/1")!
    private static let prefix = "\u{1}vi.name:"
    private struct Key: CodingKey {
        let stringValue: String
        var intValue: Int? { nil }
        init(_ value: String) { stringValue = value }
        init?(stringValue: String) { self.init(stringValue) }
        init?(intValue: Int) { return nil }
    }
    static func key(_ name: String) -> String {
        if name.unicodeScalars.allSatisfy({ $0.value < 128 }), !name.hasPrefix(prefix) { return name }
        return prefix + name.utf8.map { String(format: "%02x", $0) }.joined()
    }
    static func name(_ key: String) throws -> String {
        guard key.hasPrefix(prefix) else { return key }
        let digits = Array(key.dropFirst(prefix.count).utf8)
        guard digits.count % 2 == 0 else { throw DefinitionReduction.Failure("malformed scalar JSON key") }
        var bytes: [UInt8] = []
        for i in stride(from: 0, to: digits.count, by: 2) {
            guard let byte = UInt8(String(decoding: digits[i...i + 1], as: UTF8.self), radix: 16) else {
                throw DefinitionReduction.Failure("malformed scalar JSON key")
            }
            bytes.append(byte)
        }
        guard let result = String(bytes: bytes, encoding: .utf8) else {
            throw DefinitionReduction.Failure("malformed scalar JSON name")
        }
        return result
    }
    public static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .custom { path in Key(key(path.last!.stringValue)) }
        decoder.userInfo[scalarKeys] = true
        return decoder
    }
}
