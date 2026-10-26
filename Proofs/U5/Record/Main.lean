import Record.Checker

def main (args : List String) : IO UInt32 := do
  let retain := args.head? == some "--retain"
  let args := if retain then args.drop 1 else args
  let stderr ← IO.getStderr
  match args with
  | [proofPath, worldPath] =>
    try
      let proof ← IO.FS.readBinFile proofPath
      let world ← IO.FS.readBinFile worldPath
      let bytes := Record.byteValues world
      -- replay is the proved decision path; IO only transports bytes and code.
      match Record.replay retain proof bytes with
      | .error e =>
        stderr.putStrLn ("Continuation record unresolved: " ++ e)
        return 2
      | .ok ⟨_, j⟩ =>
        let stdout ← IO.getStdout
        stdout.write proof
        if proof.data.back? != some 10 then stdout.putStr "\n"
        return UInt32.ofNat j.code
    catch e =>
      stderr.putStrLn ("Continuation record unresolved: input: " ++ toString e)
      return 2
  | _ =>
    stderr.putStrLn "usage: record-check [--retain] proof.json world.json"
    return 2
