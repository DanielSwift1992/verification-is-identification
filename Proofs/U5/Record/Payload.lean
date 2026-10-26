import Record.Admission
import U6.Retention
import Lean.Data.Json.Parser

namespace Record
open U5 Lean
open Std.Internal.Parsec Std.Internal.Parsec.String

/- The format-8 payload decoder is a named implementation premise. No
correctness theorem for this JSON envelope or its field translation is claimed.
It cannot decide a judgment: it only supplies typed certificates to U5/U6. -/

mutual
  def proofValue : Nat → Nat → Parser Json
    | 0, _ => fail "certificate: JSON value limit"
    | fuel + 1, depth => do
      if depth ≥ 256 then fail "certificate: JSON depth limit"
      let c ← peek!
      if c == '{' then
        skip; ws
        if (← peek!) == '}' then skip; ws; return Json.mkObj []
        proofObject fuel (depth + 1) ∅
      else if c == '[' then
        skip; ws
        if (← peek!) == ']' then skip; ws; return .arr #[]
        proofArray fuel (depth + 1) #[]
      else if c == '"' then
        skip
        let s ← Json.Parser.str
        ws
        return .str s
      else if c == 't' then skipString "true"; ws; return .bool true
      else if c == 'f' then skipString "false"; ws; return .bool false
      else if c == 'n' then skipString "null"; ws; return .null
      else
        let n ← Json.Parser.nat
        ws
        return .num (JsonNumber.fromNat n)

  def proofArray : Nat → Nat → Array Json → Parser Json
    | 0, _, _ => fail "certificate: JSON value limit"
    | fuel + 1, depth, acc => do
      let v ← proofValue fuel depth
      let c ← any
      if c == ']' then ws; return .arr (acc.push v)
      if c != ',' then fail "certificate: expected array delimiter"
      ws
      proofArray fuel depth (acc.push v)

  def proofObject : Nat → Nat → Std.TreeMap.Raw String Json compare → Parser Json
    | 0, _, _ => fail "certificate: JSON value limit"
    | fuel + 1, depth, acc => do
      let c ← any
      if c != '"' then fail "certificate: expected object key"
      let key ← Json.Parser.str
      if (acc.get? key).isSome then fail ("certificate." ++ key ++ ": repeated key")
      ws
      if (← any) != ':' then fail "certificate: expected field delimiter"
      ws
      let v ← proofValue fuel depth
      let c ← any
      if c == '}' then ws; return .obj (acc.insert key v)
      if c != ',' then fail "certificate: expected object delimiter"
      ws
      proofObject fuel depth (acc.insert key v)
end

def located (address : String) (value : Except String α) : Except String α :=
  value.mapError (fun e => address ++ ": " ++ e)

def fields (j : Json) (required : List String) (optional : List String := [])
    (address : String) : Except String Unit := do
  let obj ← located address j.getObj?
  for k in required do
    need (obj.get? k).isSome (address ++ "." ++ k) "missing field"
  for (k, _) in obj.toList do
    need ((required ++ optional).contains k) (address ++ "." ++ k) "unread field"

def field (j : Json) (k address : String) : Except String Json :=
  located (address ++ "." ++ k) (j.getObjVal? k)

def array (f : Json → String → Except String α) (j : Json) (address : String) : Except String (List α) := do
  let xs ← located address j.getArr?
  xs.toList.zipIdx.mapM (fun (x, n) => f x (address ++ "[" ++ toString n ++ "]"))

def payloadPath (j : Json) (address : String) : Except String Path :=
  array (fun x addr => do
    match ← located addr x.getStr? with
    | "Left" => pure false
    | "Right" => pure true
    | _ => .error (addr ++ ": expected Left or Right")) j address

def payloadStep (j : Json) (address : String) : Except String Step := do
  fields j ["edge", "reversed"] [] address
  let edge ← payloadPath (← field j "edge" address) (address ++ ".edge")
  let rev ← located (address ++ ".reversed") (← field j "reversed" address).getBool?
  pure ⟨edge, rev⟩

def payloadBasis (j : Json) (address : String) : Except String Basis := do
  let obj ← located address j.getObj?
  need (obj.size == 1) address "expected one equality ground"
  if let some value := obj.get? "address" then
    fields value [] [] (address ++ ".address")
    pure .address
  else if let some value := obj.get? "observedValues" then
    fields value [] [] (address ++ ".observedValues")
    pure .observedValues
  else
    fields j ["sourceRelation"] [] address
    let value ← field j "sourceRelation" address
    fields value ["_0"] [] (address ++ ".sourceRelation")
    pure (.sourceRelation (← array payloadStep (← field value "_0" address) address))

def payloadSelection (j : Json) (address : String) : Except String Selection := do
  fields j ["output", "input", "basis"] [] address
  pure ⟨← payloadPath (← field j "output" address) (address ++ ".output"),
    ← payloadPath (← field j "input" address) (address ++ ".input"),
    ← payloadBasis (← field j "basis" address) (address ++ ".basis")⟩

def selectionWork (ss : List Selection) : Nat :=
  ss.foldl (fun n s => n + match s.basis with
    | .sourceRelation steps => steps.length
    | _ => 0) 0

def payloadSelections (j : Json) (address : String) : Except String (List Selection) := do
  let ss ← array payloadSelection j address
  need (selectionWork ss ≤ equalityWorkLimit) address "equality-path replay resource limit"
  pure ss

def payloadProgram : Nat → Json → String → Except String (Term Path)
  | 0, _, address => .error (address ++ ": program depth limit")
  | fuel + 1, j, address => do
    let obj ← located address j.getObj?
    need (obj.size == 1) address "expected one program constructor"
    if let some value := obj.get? "pick" then
      fields value ["_0"] [] (address ++ ".pick")
      pure (.leaf (← payloadPath (← field value "_0" address) address))
    else
      fields j ["pair"] [] address
      let value ← field j "pair" address
      fields value ["_0", "_1"] [] (address ++ ".pair")
      pure (.pair (← payloadProgram fuel (← field value "_0" address) (address ++ ".pair._0"))
        (← payloadProgram fuel (← field value "_1" address) (address ++ ".pair._1")))

def payloadClass (j : Json) (address : String) : Except String PartitionClass := do
  fields j ["sort", "leaves"] [] address
  let text ← located (address ++ ".sort") (← field j "sort" address).getStr?
  let s ← fromOption text.toNat? (address ++ ".sort: expected source sort number")
  need (toString s == text) (address ++ ".sort") "noncanonical source sort number"
  pure ⟨s, ← array payloadPath (← field j "leaves" address) (address ++ ".leaves")⟩

def payloadRequired (j : Json) (address : String) : Except String U6.RequiredClass := do
  fields j ["block", "questions"] [] address
  pure ⟨← located (address ++ ".block") (← field j "block" address).getNat?,
    ← array payloadPath (← field j "questions" address) (address ++ ".questions")⟩

def payloadResidue (j : Json) (address : String) : Except String U6.Residue := do
  fields j ["connections", "needed"] [] address
  pure ⟨← array (array payloadStep) (← field j "connections" address) (address ++ ".connections"),
    ← array payloadRequired (← field j "needed" address) (address ++ ".needed")⟩

def payloadRetention (j : Json) (address : String) : Except String U6.Retention := do
  fields j ["leaves", "view", "selections", "program"] [] address
  pure ⟨← array payloadPath (← field j "leaves" address) (address ++ ".leaves"),
    ← payloadProgram 256 (← field j "view" address) (address ++ ".view"),
    ⟨← payloadSelections (← field j "selections" address) (address ++ ".selections"),
      ← payloadProgram 256 (← field j "program" address) (address ++ ".program")⟩⟩

structure Payload where
  record : Bytes
  conclusion : U5.Certificate
  residue : Option U6.Residue
  retention : Option U6.Retention

def payloadConclusion (j : Json) : Except String (U5.Certificate × Option U6.Residue) := do
  let address := "certificate.conclusion"
  let obj ← located address j.getObj?
  need (obj.size == 1) address "expected one conclusion"
  if let some value := obj.get? "constructed" then
    fields value ["_0", "_1"] [] (address ++ ".constructed")
    pure (.constructed ⟨← payloadSelections (← field value "_0" address) "certificate.selections",
      ← payloadProgram 256 (← field value "_1" address) "certificate.program"⟩, none)
  else
    fields j ["obstructed"] [] address
    let box ← field j "obstructed" address
    fields box ["_0"] [] (address ++ ".obstructed")
    let o ← field box "_0" address
    fields o ["question", "classes"] ["residue"] "certificate.obstruction"
    let question ← payloadPath (← field o "question" address) "certificate.obstruction.question"
    let classes ← array payloadClass (← field o "classes" address) "certificate.classes"
    let residue ← match o.getObjVal? "residue" with
      | .ok j => some <$> payloadResidue j "certificate.residue"
      | .error _ => pure none
    pure (.obstructed ⟨question, classes⟩, residue)

/-- Named premise: JSON transport and payload-to-certificate translation.
No fallback certificate is supplied after any decoding failure. -/
def decodePayload (b : ByteArray) : Except String Payload := do
  need (b.size ≤ byteLimit) "certificate" "input byte limit"
  let text ← fromOption (String.fromUTF8? b) "certificate: invalid UTF-8"
  let j ← located "certificate" (Parser.run (do
    ws
    let value ← proofValue (b.size + 1) 0
    eof
    pure value) text)
  fields j ["format", "record", "conclusion"] ["retention"] "certificate"
  let format ← located "certificate.format" (← field j "format" "certificate").getNat?
  need (format == 8) "certificate.format" "expected format 8"
  let record ← located "certificate.record" (← field j "record" "certificate").getStr?
  let (conclusion, residue) ← payloadConclusion (← field j "conclusion" "certificate")
  let retention ← match j.getObjVal? "retention" with
    | .ok j => some <$> payloadRetention j "certificate.retention"
    | .error _ => pure none
  pure ⟨record.toUTF8.data.toList.map UInt8.toNat, conclusion, residue, retention⟩

end Record
