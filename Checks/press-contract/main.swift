import Foundation

// Transport only. The substitution and every refusal belong to Press.apply.
struct Request: Decodable {
    let arguments: [String]
    let state: String
    let dictionary: String
    let statePath: String
    let dictionaryPath: String
}
struct Refusal: Encodable { let address: String; let reason: String }
struct Response: Encodable {
    let state: String
    let changed: Bool
    let refusal: Refusal?
}
if CommandLine.arguments.dropFirst().first == "--native" {
    Press.run(Array(CommandLine.arguments.dropFirst(2)))
} else {
    do {
        let input = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        let response: Response
        do {
            let result = try Press.apply(input.arguments, state: input.state, dictionary: input.dictionary,
                statePath: input.statePath, dictionaryPath: input.dictionaryPath)
            response = Response(state: result.state, changed: result.changed, refusal: nil)
        } catch let failure as Press.Failure {
            response = Response(state: input.state, changed: false,
                refusal: Refusal(address: failure.address, reason: failure.description))
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        FileHandle.standardOutput.write(try encoder.encode(response))
        FileHandle.standardOutput.write(Data([10]))
    } catch {
        FileHandle.standardError.write(Data(("press contract transport: \(error)\n").utf8))
        exit(2)
    }
}
