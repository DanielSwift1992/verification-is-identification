import Record.Payload
import U8.Certificate

namespace Record.Actions
open U5 Lean

/- The same named envelope-decoder premise as schema 1. Its output is never
accepted as a judgment until the proved U7/U8 checker has returned true. -/
def payloadEvidence (j : Json) (address : String) : Except String U7.ActionEvidence := do
  fields j ["member", "preservation"] [] address
  let member ← payloadPath (← field j "member" address) (address ++ ".member")
  let p ← field j "preservation" address
  let loc := address ++ ".preservation"
  let obj ← located loc p.getObj?
  need (obj.size == 1) loc "expected one preservation judgment"
  if let some box := obj.get? "preserved" then
    fields box ["_0"] [] (loc ++ ".preserved")
    pure ⟨member, .preserved (← array payloadBasis (← field box "_0" loc) (loc ++ ".preserved._0"))⟩
  else
    fields p ["notPreserved"] [] loc
    let box ← field p "notPreserved" loc
    fields box ["edge"] [] (loc ++ ".notPreserved")
    pure ⟨member, .notPreserved (← payloadPath (← field box "edge" loc) (loc ++ ".notPreserved.edge"))⟩

def payloadReach (j : Json) (address : String) : Except String U7.ReachableClass := do
  fields j ["block", "question", "word", "basis"] [] address
  pure ⟨← located (address ++ ".block") (← field j "block" address).getNat?,
    ← payloadPath (← field j "question" address) (address ++ ".question"),
    ← array payloadPath (← field j "word" address) (address ++ ".word"),
    ← payloadBasis (← field j "basis" address) (address ++ ".basis")⟩

def payloadImage (j : Json) (address : String) : Except String U7.ImageAction := do
  fields j ["member", "targets", "selections", "program"] [] address
  pure ⟨← payloadPath (← field j "member" address) (address ++ ".member"),
    ← array (fun x loc => located loc x.getNat?) (← field j "targets" address) (address ++ ".targets"),
    ⟨← payloadSelections (← field j "selections" address) (address ++ ".selections"),
      ← payloadProgram 256 (← field j "program" address) (address ++ ".program")⟩⟩

def payloadStable (j : Json) (address : String) : Except String U7.StableView := do
  fields j ["classes", "representatives", "view", "actions", "selections", "decoder"] [] address
  pure ⟨← array payloadReach (← field j "classes" address) (address ++ ".classes"),
    ← array payloadPath (← field j "representatives" address) (address ++ ".representatives"),
    ← payloadProgram 256 (← field j "view" address) (address ++ ".view"),
    ← array payloadImage (← field j "actions" address) (address ++ ".actions"),
    ⟨← payloadSelections (← field j "selections" address) (address ++ ".selections"),
      ← payloadProgram 256 (← field j "decoder" address) (address ++ ".decoder")⟩⟩

def payloadHiddenConclusion (j : Json) (address : String) : Except String U8.HiddenConclusion := do
  let obj ← located address j.getObj?
  need (obj.size == 1) address "expected one hidden-action conclusion"
  if let some box := obj.get? "common" then
    fields box ["actions", "program"] [] (address ++ ".common")
    pure (.common (← array payloadImage (← field box "actions" address) (address ++ ".common.actions"))
      (← payloadProgram 256 (← field box "program" address) (address ++ ".common.program")))
  else if let some box := obj.get? "outside" then
    fields box ["member", "observation", "image"] [] (address ++ ".outside")
    pure (.outside (← payloadPath (← field box "member" address) (address ++ ".outside.member"))
      (← payloadPath (← field box "observation" address) (address ++ ".outside.observation"))
      (← payloadPath (← field box "image" address) (address ++ ".outside.image")))
  else
    fields j ["disagreement"] [] address
    let box ← field j "disagreement" address
    fields box ["left", "right", "observation", "leftImage", "rightImage"] [] (address ++ ".disagreement")
    pure (.disagreement (← payloadPath (← field box "left" address) (address ++ ".disagreement.left"))
      (← payloadPath (← field box "right" address) (address ++ ".disagreement.right"))
      (← payloadPath (← field box "observation" address) (address ++ ".disagreement.observation"))
      (← payloadPath (← field box "leftImage" address) (address ++ ".disagreement.leftImage"))
      (← payloadPath (← field box "rightImage" address) (address ++ ".disagreement.rightImage")))

def payloadHidden (j : Json) (address : String) : Except String U8.HiddenJudgment := do
  fields j ["classes", "conclusion", "closureInheritedFromStableView"] [] address
  pure ⟨← array (fun x loc => located loc x.getNat?) (← field j "classes" address) (address ++ ".classes"),
    ← payloadHiddenConclusion (← field j "conclusion" address) (address ++ ".conclusion"),
    ← located (address ++ ".closureInheritedFromStableView") (← field j "closureInheritedFromStableView" address).getBool?⟩

structure Dynamics where
  visible : U7.Certificate
  hiddenActions : Option (List U7.ActionEvidence)
  hidden : Option U8.HiddenJudgment

def payloadDynamics (j : Json) : Except String Dynamics := do
  let loc := "certificate.dynamics"
  fields j ["classes", "connections", "actions"] ["stable", "hiddenActions", "hidden"] loc
  let classes ← array payloadClass (← field j "classes" loc) (loc ++ ".classes")
  let connections ← array (array payloadStep) (← field j "connections" loc) (loc ++ ".connections")
  let actions ← array payloadEvidence (← field j "actions" loc) (loc ++ ".actions")
  let stable ← match j.getObjVal? "stable" with
    | .error _ => pure none
    | .ok v => some <$> payloadStable v (loc ++ ".stable")
  let hs ← match j.getObjVal? "hiddenActions" with
    | .error _ => pure none
    | .ok v => some <$> array payloadEvidence v (loc ++ ".hiddenActions")
  let hidden ← match j.getObjVal? "hidden" with
    | .error _ => pure none
    | .ok v => some <$> payloadHidden v (loc ++ ".hidden")
  pure ⟨⟨classes, connections, actions, stable⟩, hs, hidden⟩

structure Payload where
  record : Bytes
  conclusion : U5.Certificate
  residue : Option U6.Residue
  dynamics : Dynamics

def decodePayload (b : ByteArray) : Except String Payload := do
  let j ← decodeJSON b
  fields j ["format", "record", "conclusion", "dynamics"] [] "certificate"
  let format ← located "certificate.format" (← field j "format" "certificate").getNat?
  need (format == 8) "certificate.format" "expected format 8"
  let record ← located "certificate.record" (← field j "record" "certificate").getStr?
  let (conclusion, residue) ← payloadConclusion (← field j "conclusion" "certificate")
  let dynamics ← payloadDynamics (← field j "dynamics" "certificate")
  pure ⟨record.toUTF8.data.toList.map UInt8.toNat, conclusion, residue, dynamics⟩

end Record.Actions
