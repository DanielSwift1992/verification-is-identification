import Examples

// THE WORLD: one file, two slots, and that is the whole state of the system.
// Its dynamics is three triples in the dictionary (Examples/Dynamics.swift), and
// pressing is `swift run Tools press PowerOn` (or PowerOff, or BumpUp). The rules
// are generic declarations, so every state this file can ever reach is already
// well-typed: the judge sat on the edges before the first press.
// A press either rewrites its one slot or leaves the file byte-identical: no
// third outcome exists.

typealias LampMode = LampOff
typealias Count = Never
typealias PinProgress = PinStage0
