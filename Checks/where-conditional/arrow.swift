// A where clause that spells a function type is named at its gate. The gate
// asks the second argument to be a function from Int to Int and the first
// to carry the required setting; an arrow's `>` read as a closing bracket
// would fold the second conjunct into the first equality and drop it. The
// function type is a term this court does not read, so it gives no verdict
// and names the conjunct. The compiler refuses the bad application.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting, F> {}
extension Use: Admitted
where F == (Int) -> Int, T: Required {}
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad, Int>.self) }
