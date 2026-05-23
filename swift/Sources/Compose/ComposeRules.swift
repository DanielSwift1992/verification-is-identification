// §4.5 Conjunction — both rules must hold for the same atom pair.

import Engine

public enum And<R1: Rule, R2: Rule>: Rule
    where R1.Input == R2.Input, R1.Output == R2.Output {
    public typealias Input = R1.Input
    public typealias Output = R1.Output
}
