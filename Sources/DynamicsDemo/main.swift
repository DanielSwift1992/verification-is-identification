import Examples

// The reading: the world's three slots off the compiled types, or the drawn
// face (`draw`), whose buttons are rule keys the build already admitted.

if CommandLine.arguments.dropFirst().first == "draw" {
    print(WorldArt.typeName)
} else {
    let mode = String(describing: LampMode.self)
    let chain = String(reflecting: Count.self)
    var depth = 0
    var window = ""
    for ch in chain {
        window.append(ch)
        if window.count > 5 {
            window.removeFirst()
        }
        if window == "Tick<" {
            depth += 1
        }
    }
    print("lamp: \(mode)")
    print("count: \(depth)")
    print("pin: \(String(describing: PinProgress.self))")
}
