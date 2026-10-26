import Record.Actions.Schema

namespace Record.Extended
open U5

structure Base where
  source : List Node
  edges : List Edge
  deriving DecidableEq, Repr

def baseEmit (version : Nat) (w : Base) : Bytes :=
  schemaHeader version ++ (arrayCodec nodeCodec).emit w.source ++
    ascii ",\"equalities\":" ++ (arrayCodec edgeCodec).emit w.edges

def baseParse (version : Nat) (input : Bytes) : Except String (Base × Bytes) := do
  let rest ← expect (literal (schemaHeader version) input) "record.schema/source" version
  let (s, rest) ← expect ((arrayCodec nodeCodec).parse rest) "record.source" version
  let rest ← expect (literal (ascii ",\"equalities\":" ) rest) "record.equalities" version
  let (e, rest) ← expect ((arrayCodec edgeCodec).parse rest) "record.equalities" version
  pure (⟨s,e⟩,rest)

theorem base_inverse (v : Nat) (w : Base) (tail : Bytes) :
    baseParse v (baseEmit v w ++ tail) = .ok (w,tail) := by
  simp [baseEmit,baseParse,List.append_assoc,(arrayCodec nodeCodec).inverse,
    (arrayCodec edgeCodec).inverse,expect,Bind.bind,Pure.pure,Except.pure,Except.bind]

def optionalEmit (key : String) (c : Codec α) : Option α → Bytes
  | none => []
  | some value => ascii (",\"" ++ key ++ "\":") ++ c.emit value

def optionalParse (v : Nat) (key : String) (c : Codec α) (b : Bytes) : Except String (Option α × Bytes) :=
  match literal (ascii (",\"" ++ key ++ "\":")) b with
  | none => .ok (none,b)
  | some rest => do
    let (a,tail) ← expect (c.parse rest) ("record." ++ key) v
    pure (some a,tail)

structure ImageRaw where
  base : Base
  image : Term Path
  promise : Option (List Edge)
  hidden : Option (List Actions.Member)
  deriving DecidableEq, Repr

def imageEmit (w : ImageRaw) : Bytes :=
  baseEmit 3 w.base ++ ascii ",\"image\":" ++ viewCodec.emit w.image ++
    optionalEmit "promise" (arrayCodec edgeCodec) w.promise ++
    optionalEmit "hiddenActions" (arrayCodec Actions.memberCodec) w.hidden ++ [125]

def imageParse (b : Bytes) : Except String (ImageRaw × Bytes) := do
  let (base,rest) ← baseParse 3 b
  let rest ← expect (literal (ascii ",\"image\":") rest) "record.image" 3
  let (image,rest) ← expect (viewCodec.parse rest) "record.image" 3
  let (promise,rest) ← optionalParse 3 "promise" (arrayCodec edgeCodec) rest
  let (hidden,rest) ← optionalParse 3 "hiddenActions" (arrayCodec Actions.memberCodec) rest
  let tail ← expect (literal [125] rest) "record" 3
  pure (⟨base,image,promise,hidden⟩,tail)

theorem image_inverse (w : ImageRaw) (tail : Bytes) :
    imageParse (imageEmit w ++ tail) = .ok (w,tail) := by
  rcases w with ⟨base,image,p,h⟩
  cases p <;> cases h <;>
    simp [imageEmit,imageParse,base_inverse,optionalEmit,optionalParse,
      List.append_assoc,viewCodec.inverse,(arrayCodec edgeCodec).inverse,
      (arrayCodec Actions.memberCodec).inverse,ascii,literal,expect,
      Bind.bind,Pure.pure,Except.pure,Except.bind]

structure AgreementRaw where
  base : Base
  output : List Node
  question : Term Path
  promise : Option (List Edge)
  boundOutputs : Option (Term Path)
  boundSources : Option (Term Path)
  deriving DecidableEq, Repr

def agreementEmit (w : AgreementRaw) : Bytes :=
  baseEmit 4 w.base ++ ascii ",\"output\":" ++ (arrayCodec nodeCodec).emit w.output ++
    ascii ",\"question\":" ++ viewCodec.emit w.question ++
    optionalEmit "promise" (arrayCodec edgeCodec) w.promise ++
    optionalEmit "boundOutputs" viewCodec w.boundOutputs ++
    optionalEmit "boundSources" viewCodec w.boundSources ++ [125]

def agreementParse (b : Bytes) : Except String (AgreementRaw × Bytes) := do
  let (base,rest) ← baseParse 4 b
  let rest ← expect (literal (ascii ",\"output\":") rest) "record.output" 4
  let (output,rest) ← expect ((arrayCodec nodeCodec).parse rest) "record.output" 4
  let rest ← expect (literal (ascii ",\"question\":") rest) "record.question" 4
  let (question,rest) ← expect (viewCodec.parse rest) "record.question" 4
  let (promise,rest) ← optionalParse 4 "promise" (arrayCodec edgeCodec) rest
  let (bo,rest) ← optionalParse 4 "boundOutputs" viewCodec rest
  let (bs,rest) ← optionalParse 4 "boundSources" viewCodec rest
  let tail ← expect (literal [125] rest) "record" 4
  pure (⟨base,output,question,promise,bo,bs⟩,tail)

theorem agreement_inverse (w : AgreementRaw) (tail : Bytes) :
    agreementParse (agreementEmit w ++ tail) = .ok (w,tail) := by
  rcases w with ⟨base,output,question,p,o,s⟩
  cases p <;> cases o <;> cases s <;>
    simp [agreementEmit,agreementParse,base_inverse,optionalEmit,optionalParse,
      List.append_assoc,viewCodec.inverse,(arrayCodec nodeCodec).inverse,
      (arrayCodec edgeCodec).inverse,ascii,literal,expect,
      Bind.bind,Pure.pure,Except.pure,Except.bind]
end Record.Extended
