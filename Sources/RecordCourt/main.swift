import ContinuationRecord

var arguments = Array(CommandLine.arguments.dropFirst())
let replay = arguments.first == "replay"
if replay { arguments.removeFirst() }
RecordContinuation.run(arguments, replay: replay)
