import Record.Bytes
import U5.Model

namespace Record
open U5

def sideCodec : Codec Bool where
  emit b := [if b then 49 else 48]
  parse input := match input with
    | 48 :: tail => some (false, tail)
    | 49 :: tail => some (true, tail)
    | _ => none
  first b := if b then 49 else 48
  starts _ := rfl
  notClose b := by cases b <;> decide
  inverse b tail := by cases b <;> rfl

def pathCodec : Codec Path := arrayCodec sideCodec

inductive Node where
  | sort : Nat → Node
  | pair : Nat → Nat → Node
  deriving DecidableEq, Repr

def nodeEmit : Node → Bytes
  | .sort n => ascii "{\"sort\":" ++ digits n ++ [125]
  | .pair l r => ascii "{\"pair\":[" ++ digits l ++ 44 :: digits r ++ [93, 125]

def nodeParse : Bytes → Option (Node × Bytes)
  | 123 :: 34 :: 115 :: rest => do
      let rest ← literal (ascii "ort\":") rest
      let (n, tail) ← number 125 rest
      pure (.sort n, tail)
  | 123 :: 34 :: 112 :: rest => do
      let rest ← literal (ascii "air\":[") rest
      let (l, rest) ← number 44 rest
      let (r, rest) ← number 93 rest
      let tail ← literal [125] rest
      pure (.pair l r, tail)
  | _ => none

theorem node_inverse (n : Node) (tail : Bytes) :
    nodeParse (nodeEmit n ++ tail) = some (n, tail) := by
  cases n <;> simp [nodeEmit, nodeParse, ascii, List.append_assoc, literal,
    number_write _ 125 _ (by decide), number_write _ 44 _ (by decide), number_write _ 93 _ (by decide)]

def nodeCodec : Codec Node where
  emit := nodeEmit
  parse := nodeParse
  first _ := 123
  starts n := by cases n <;> rfl
  notClose _ := by decide
  inverse := node_inverse

def edgeEmit (e : Edge) : Bytes :=
  ascii "{\"at\":" ++ pathCodec.emit e.address ++ ascii ",\"left\":" ++
    pathCodec.emit e.left ++ ascii ",\"right\":" ++ pathCodec.emit e.right ++
    ascii ",\"basis\":\"declared\"}"

def edgeParse (input : Bytes) : Option (Edge × Bytes) := do
  let rest ← literal (ascii "{\"at\":") input
  let (addr, rest) ← pathCodec.parse rest
  let rest ← literal (ascii ",\"left\":") rest
  let (l, rest) ← pathCodec.parse rest
  let rest ← literal (ascii ",\"right\":") rest
  let (r, rest) ← pathCodec.parse rest
  let tail ← literal (ascii ",\"basis\":\"declared\"}") rest
  pure (⟨addr, l, r⟩, tail)

def edgeCodec : Codec Edge where
  emit := edgeEmit
  parse := edgeParse
  first _ := 123
  starts _ := rfl
  notClose _ := by decide
  inverse e tail := by
    simp [edgeEmit, edgeParse, List.append_assoc, pathCodec.inverse]

def viewEmit : Term Path → Bytes
  | .leaf p => ascii "{\"place\":" ++ pathCodec.emit p ++ [125]
  | .pair l r => ascii "{\"pair\":[" ++ viewEmit l ++ 44 :: viewEmit r ++ [93, 125]

def viewHeight : Term α → Nat
  | .leaf _ => 1
  | .pair l r => max (viewHeight l) (viewHeight r) + 1

def viewParse : Nat → Bytes → Option (Term Path × Bytes)
  | 0, _ => none
  | _ + 1, 123 :: 34 :: 112 :: 108 :: rest => do
      let rest ← literal (ascii "ace\":") rest
      let (p, rest) ← pathCodec.parse rest
      let tail ← literal [125] rest
      pure (.leaf p, tail)
  | n + 1, 123 :: 34 :: 112 :: 97 :: rest => do
      let rest ← literal (ascii "ir\":[") rest
      let (l, rest) ← viewParse n rest
      let rest ← literal [44] rest
      let (r, rest) ← viewParse n rest
      let tail ← literal [93, 125] rest
      pure (.pair l r, tail)
  | _, _ => none

theorem view_parse_write (v : Term Path) (tail : Bytes) (fuel : Nat)
    (hf : viewHeight v ≤ fuel) :
    viewParse fuel (viewEmit v ++ tail) = some (v, tail) := by
  induction v generalizing fuel tail with
  | leaf p => cases fuel <;> simp_all [viewHeight, viewEmit, viewParse, ascii, literal,
      List.append_assoc, literal, pathCodec.inverse]
  | pair l r ihl ihr =>
    cases fuel with
    | zero => simp [viewHeight] at hf
    | succ n =>
      have hl : viewHeight l ≤ n := by simp [viewHeight] at hf; omega
      have hr : viewHeight r ≤ n := by simp [viewHeight] at hf; omega
      simp [viewEmit, viewParse, ascii, literal, List.append_assoc, ihl _ n hl, ihr _ n hr]

theorem view_height_length (v : Term Path) : viewHeight v ≤ (viewEmit v).length := by
  induction v with
  | leaf p => simp [viewHeight, viewEmit, ascii]
  | pair l r ihl ihr => simp [viewHeight, viewEmit, ascii] at *; omega

def viewCodec : Codec (Term Path) where
  emit := viewEmit
  parse input := viewParse (input.length + 1) input
  first _ := 123
  starts v := by cases v <;> rfl
  notClose _ := by decide
  inverse v tail := by
    apply view_parse_write
    have := view_height_length v
    simp only [List.length_append]; omega

/-- Schema syntax, with no stored input bytes or name identities. Decimal
numbers are Nats; the writer, not a retained input slice, spells them. -/
structure Raw where
  source : List Node
  edges : List Edge
  observation : Term Path
  question : Term Path
  deriving DecidableEq, Repr

def rawEmit (w : Raw) : Bytes :=
  ascii "{\"schema\":1,\"source\":" ++ (arrayCodec nodeCodec).emit w.source ++
    ascii ",\"equalities\":" ++ (arrayCodec edgeCodec).emit w.edges ++
    ascii ",\"observation\":" ++ viewCodec.emit w.observation ++
    ascii ",\"question\":" ++ viewCodec.emit w.question ++ [125]

def expect (value : Option α) (address : String) : Except String α :=
  match value with
  | none => .error (address ++ ": unread schema 1 syntax")
  | some a => .ok a

def rawParse (input : Bytes) : Except String (Raw × Bytes) := do
  let rest ← expect (literal (ascii "{\"schema\":1,\"source\":") input) "record.schema/source"
  let (s, rest) ← expect ((arrayCodec nodeCodec).parse rest) "record.source"
  let rest ← expect (literal (ascii ",\"equalities\":") rest) "record.equalities"
  let (e, rest) ← expect ((arrayCodec edgeCodec).parse rest) "record.equalities"
  let rest ← expect (literal (ascii ",\"observation\":") rest) "record.observation"
  let (p, rest) ← expect (viewCodec.parse rest) "record.observation"
  let rest ← expect (literal (ascii ",\"question\":") rest) "record.question"
  let (q, rest) ← expect (viewCodec.parse rest) "record.question"
  let tail ← expect (literal [125] rest) "record"
  pure (⟨s, e, p, q⟩, tail)

theorem raw_parse_write (w : Raw) (tail : Bytes) :
    rawParse (rawEmit w ++ tail) = .ok (w, tail) := by
  simp [rawEmit, rawParse, List.append_assoc, (arrayCodec nodeCodec).inverse,
    (arrayCodec edgeCodec).inverse, viewCodec.inverse, literal, expect, Bind.bind, Pure.pure, Except.pure, Except.bind]

end Record
