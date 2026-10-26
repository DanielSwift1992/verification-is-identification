import Record.Schema

namespace Record.Actions
open U5

/-- Member identity is its address, independently of equal images. -/
structure Member where
  address : Path
  image : List Path
  deriving DecidableEq, Repr

def memberEmit (a : Member) : Bytes :=
  ascii "{\"at\":" ++ pathCodec.emit a.address ++ ascii ",\"image\":" ++
    (arrayCodec pathCodec).emit a.image ++ [125]

def memberParse (input : Bytes) : Option (Member × Bytes) := do
  let rest ← literal (ascii "{\"at\":") input
  let (p, rest) ← pathCodec.parse rest
  let rest ← literal (ascii ",\"image\":") rest
  let (image, rest) ← (arrayCodec pathCodec).parse rest
  let tail ← literal [125] rest
  pure (⟨p, image⟩, tail)

def memberCodec : Codec Member where
  emit := memberEmit
  parse := memberParse
  first _ := 123
  starts _ := rfl
  notClose _ := by decide
  inverse a tail := by
    simp [memberEmit, memberParse, List.append_assoc, pathCodec.inverse,
      (arrayCodec pathCodec).inverse, literal]

structure Raw where
  base : Record.Raw
  actions : Option (List Member)
  hiddenActions : Option (List Member)
  deriving DecidableEq, Repr

def optionalEmit (key : String) (ms : Option (List Member)) : Bytes :=
  match ms with
  | none => []
  | some ms => ascii (",\"" ++ key ++ "\":") ++ (arrayCodec memberCodec).emit ms

def rawEmit (w : Raw) : Bytes :=
  prefixEmit 2 w.base ++ optionalEmit "actions" w.actions ++
    optionalEmit "hiddenActions" w.hiddenActions ++ [125]

def optionalParse (key : String) (input : Bytes) : Except String (Option (List Member) × Bytes) :=
  match literal (ascii (",\"" ++ key ++ "\":")) input with
  | none => .ok (none, input)
  | some rest => do
      let (ms, tail) ← expect ((arrayCodec memberCodec).parse rest) ("record." ++ key) 2
      pure (some ms, tail)

def rawParse (input : Bytes) : Except String (Raw × Bytes) := do
  let (base, rest) ← prefixParse 2 input
  let (actions, rest) ← optionalParse "actions" rest
  let (hidden, rest) ← optionalParse "hiddenActions" rest
  let tail ← expect (literal [125] rest) "record" 2
  pure (⟨base, actions, hidden⟩, tail)

theorem raw_parse_write (w : Raw) (tail : Bytes) :
    rawParse (rawEmit w ++ tail) = .ok (w, tail) := by
  rcases w with ⟨base, a, h⟩
  cases a <;> cases h <;>
    simp [rawEmit, optionalEmit, rawParse, optionalParse, List.append_assoc,
      prefix_parse_write, (arrayCodec memberCodec).inverse, ascii, literal, expect,
      Bind.bind, Pure.pure, Except.pure, Except.bind]

end Record.Actions
