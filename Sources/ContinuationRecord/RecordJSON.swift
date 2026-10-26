import Foundation

// Finite JSON transport, independent of every source-language scanner.
// Each byte is classified; keys are checked before a dictionary can overwrite one.
enum RecordJSON {
    indirect enum Value {
        case object([String: Value]), array([Value]), string(String), number(Int), bool(Bool), null
        func object(_ at: String, keys: Set<String>, optional: Set<String> = []) throws -> [String: Value] {
            guard case let .object(fields) = self else { throw ContinuationCore.Failure(at + ": expected object") }
            if let missing = keys.subtracting(fields.keys).sorted().first {
                throw ContinuationCore.Failure(at + "." + missing + ": missing field")
            }
            if let extra = Set(fields.keys).subtracting(keys.union(optional)).sorted().first {
                throw ContinuationCore.Failure(at + "." + extra + ": unknown field")
            }
            return fields
        }
        func array(_ at: String) throws -> [Value] {
            guard case let .array(values) = self else { throw ContinuationCore.Failure(at + ": expected array") }
            return values
        }
        func integer(_ at: String) throws -> Int {
            guard case let .number(value) = self, value >= 0 else { throw ContinuationCore.Failure(at + ": expected nonnegative integer") }
            return value
        }
    }
    struct Reader {
        let bytes: [UInt8]
        let depthLimit: Int
        var offset = 0
        var remaining = 100_000
        mutating func spaces() { while offset < bytes.count, [9, 10, 13, 32].contains(bytes[offset]) { offset += 1 } }
        mutating func fail(_ at: String, _ reason: String) throws -> Never {
            throw ContinuationCore.Failure(at + ": " + reason + " (byte \(offset))")
        }
        mutating func token(_ expected: UInt8, _ at: String) throws {
            spaces()
            guard offset < bytes.count, bytes[offset] == expected else { try fail(at, "expected JSON delimiter") }
            offset += 1
        }
        mutating func string(_ at: String) throws -> String {
            spaces()
            let start = offset
            try token(34, at)
            while offset < bytes.count {
                let b = bytes[offset]
                offset += 1
                if b == 34 {
                    do { return try JSONDecoder().decode(String.self, from: Data(bytes[start..<offset])) }
                    catch { try fail(at, "invalid UTF-8 JSON string") }
                }
                if b == 92 {
                    guard offset < bytes.count else { try fail(at, "unfinished escape") }
                    offset += 1
                } else if b < 32 { try fail(at, "control byte in string") }
            }
            try fail(at, "unfinished string")
        }
        mutating func value(_ at: String, _ depth: Int = 0) throws -> Value {
            spaces()
            guard remaining > 0, depth < depthLimit else { try fail(at, "JSON work limit; no impossibility inferred") }
            remaining -= 1
            guard offset < bytes.count else { try fail(at, "missing value") }
            switch bytes[offset] {
            case 123:
                offset += 1
                spaces()
                var fields: [String: Value] = [:]
                if offset < bytes.count, bytes[offset] == 125 {
                    offset += 1
                    return .object(fields)
                }
                while true {
                    let key = try string(at)
                    let here = at + "." + key
                    guard fields[key] == nil else { try fail(here, "repeated key") }
                    try token(58, here)
                    fields[key] = try value(here, depth + 1)
                    spaces()
                    if offset < bytes.count, bytes[offset] == 125 {
                        offset += 1
                        return .object(fields)
                    }
                    try token(44, at)
                }
            case 91:
                offset += 1
                spaces()
                var values: [Value] = []
                if offset < bytes.count, bytes[offset] == 93 {
                    offset += 1
                    return .array(values)
                }
                while true {
                    values.append(try value(at + "[\(values.count)]", depth + 1))
                    spaces()
                    if offset < bytes.count, bytes[offset] == 93 {
                        offset += 1
                        return .array(values)
                    }
                    try token(44, at)
                }
            case 34: return .string(try string(at))
            case 45, 48...57:
                let start = offset
                if bytes[offset] == 45 { offset += 1 }
                let digits = offset
                while offset < bytes.count, (48...57).contains(bytes[offset]) { offset += 1 }
                guard digits < offset, offset - digits == 1 || bytes[digits] != 48,
                    let number = Int(String(decoding: bytes[start..<offset], as: UTF8.self)) else { try fail(at, "expected bounded decimal integer") }
                return .number(number)
            default:
                for (text, result) in [("true", Value.bool(true)), ("false", .bool(false)), ("null", .null)] {
                    let word = Array(text.utf8)
                    if bytes[offset...].starts(with: word) {
                        offset += word.count
                        return result
                    }
                }
                try fail(at, "token outside JSON fragment")
            }
        }
    }
    static func read(_ data: Data, at: String, depthLimit: Int = 128, workLimit: Int = 100_000) throws -> Value {
        guard data.count <= 8_000_000 else { throw ContinuationCore.Failure(at + ": input limit") }
        var reader = Reader(bytes: Array(data), depthLimit: depthLimit, remaining: workLimit)
        let value = try reader.value(at)
        reader.spaces()
        guard reader.offset == reader.bytes.count else { try reader.fail(at, "extra bytes") }
        return value
    }
}
