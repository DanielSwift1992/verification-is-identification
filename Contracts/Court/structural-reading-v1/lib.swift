protocol Counting {}
extension Never: Counting {}
enum Tick<Previous: Counting>: Counting {}
enum LampOff {}
