import DocumentKit
import Examples

// The reading: the world's three slots off the compiled types, or the drawn
// face (`draw`), whose buttons are rule keys the build already admitted.

if CommandLine.arguments.dropFirst().first == "draw" {
    print(WorldArt.typeName)
} else {
    let mode = String(describing: LampMode.self)
    print("lamp: \(mode)")
    print("count: \(Count.count)")
    print("pin: \(String(describing: PinProgress.self))")
    print("note: \(Note.typeName)")
}
