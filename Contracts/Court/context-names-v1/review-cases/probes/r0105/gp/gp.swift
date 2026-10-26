public enum UntilY<Prev, Line> {}
typealias Probe = UntilY<Int, String>.Line
let x: Probe = "ok"
