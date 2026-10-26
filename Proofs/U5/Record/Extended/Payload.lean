import Record.Actions.Payload
import U9.Certificate
import U10.Certificate
import U11.Certificate

namespace Record.Extended
open U5 Lean

def natField (j : Json) (key loc : String) : Except String Nat := do
  located (loc ++ "." ++ key) (← field j key loc).getNat?

def naturalString (j : Json) (loc : String) : Except String Nat := do
  let text ← located loc j.getStr?
  let n ← fromOption text.toNat? (loc ++ ": expected a decimal natural")
  need (toString n == text) loc "noncanonical decimal natural"
  pure n

def imagePromise (j : Json) (loc : String) : Except String U9.Promise := do
  let obj ← located loc j.getObj?
  need (obj.size == 1) loc "expected one promise judgment"
  if let some box := obj.get? "holds" then
    fields box ["_0"] [] (loc ++ ".holds")
    pure (.holds (← array payloadBasis (← field box "_0" loc) (loc ++ ".holds._0")))
  else
    fields j ["violated"] [] loc
    let box ← field j "violated" loc
    fields box ["edge"] [] (loc ++ ".violated")
    pure (.violated (← payloadPath (← field box "edge" loc) (loc ++ ".violated.edge")))

def inducedImage (j : Json) (loc : String) : Except String U9.ImageProof := do
  fields j ["member","classes","sourceClassIndices","connections","promise"] [] loc
  pure ⟨← payloadPath (← field j "member" loc) (loc ++ ".member"),
    ← array payloadClass (← field j "classes" loc) (loc ++ ".classes"),
    ← array (fun v a => located a v.getNat?) (← field j "sourceClassIndices" loc) (loc ++ ".sourceClassIndices"),
    ← array (array payloadBasis) (← field j "connections" loc) (loc ++ ".connections"),
    ← imagePromise (← field j "promise" loc) (loc ++ ".promise")⟩

def imageCertificate (j : Json) (loc : String) : Except String U9.Certificate := do
  fields j ["classes","connections","images"] [] loc
  pure ⟨← array payloadClass (← field j "classes" loc) (loc ++ ".classes"),
    ← array (array payloadStep) (← field j "connections" loc) (loc ++ ".connections"),
    ← array inducedImage (← field j "images" loc) (loc ++ ".images")⟩

def capacity (j : Json) (loc : String) : Except String U10.Capacity := do
  fields j ["sort","requiredClasses","outputClasses","fixedRequiredClasses","freeOutputClasses","minimumResidualLeaves"] [] loc
  pure ⟨← naturalString (← field j "sort" loc) (loc ++ ".sort"),
    ← natField j "requiredClasses" loc, ← natField j "outputClasses" loc,
    ← natField j "fixedRequiredClasses" loc, ← natField j "freeOutputClasses" loc,
    ← natField j "minimumResidualLeaves" loc⟩

/-- Native capacities use scalar string order; preserve its canonicality, then
rename/reorder the numeric sort presentation expected by the proved checker. -/
def orderedCapacities : List U10.Capacity → Bool
  | [] => true
  | [_] => true
  | a::b::rest => decide (toString a.sort < toString b.sort) && orderedCapacities (b::rest)

def agreementPlan (j : Json) (loc : String) : Except String U10.Plan := do
  fields j ["assignments","step","bindingBases","needed","residualLeaves","selections","decoder","capacities"] ["residual"] loc
  let residual ← match j.getObjVal? "residual" with
    | .error _ => pure none
    | .ok v => some <$> payloadProgram 256 v (loc ++ ".residual")
  let cs ← array capacity (← field j "capacities" loc) (loc ++ ".capacities")
  need (orderedCapacities cs) (loc ++ ".capacities") "noncanonical sort order"
  pure ⟨← array payloadPath (← field j "assignments" loc) (loc ++ ".assignments"),
    ← payloadProgram 256 (← field j "step" loc) (loc ++ ".step"),
    ← array payloadBasis (← field j "bindingBases" loc) (loc ++ ".bindingBases"),
    ← array payloadRequired (← field j "needed" loc) (loc ++ ".needed"),
    ← array payloadPath (← field j "residualLeaves" loc) (loc ++ ".residualLeaves"),residual,
    ⟨← payloadSelections (← field j "selections" loc) (loc ++ ".selections"),
      ← payloadProgram 256 (← field j "decoder" loc) (loc ++ ".decoder")⟩,
    cs.mergeSort (fun a b => a.sort ≤ b.sort)⟩

def agreementConclusion (j : Json) (loc : String) : Except String U10.Conclusion := do
  let obj ← located loc j.getObj?
  need (obj.size == 1) loc "expected one agreement conclusion"
  if let some box := obj.get? "constructed" then
    fields box ["_0"] [] (loc ++ ".constructed")
    pure (.constructed (← agreementPlan (← field box "_0" loc) (loc ++ ".constructed._0")))
  else if let some box := obj.get? "unavailable" then
    fields box ["output"] [] (loc ++ ".unavailable")
    pure (.unavailable (← payloadPath (← field box "output" loc) (loc ++ ".unavailable.output")))
  else if let some box := obj.get? "wrongSort" then
    fields box ["binding"] [] (loc ++ ".wrongSort")
    pure (.wrongSort (← payloadPath (← field box "binding" loc) (loc ++ ".wrongSort.binding")))
  else
    fields j ["incompatible"] [] loc
    let box ← field j "incompatible" loc
    fields box ["left","right"] [] (loc ++ ".incompatible")
    pure (.incompatible (← payloadPath (← field box "left" loc) (loc ++ ".incompatible.left"))
      (← payloadPath (← field box "right" loc) (loc ++ ".incompatible.right")))

def agreementCertificate (j : Json) (loc : String) : Except String U10.Certificate := do
  fields j ["classes","connections","outputClasses","outputConnections","conclusion"] [] loc
  pure ⟨← array payloadClass (← field j "classes" loc) (loc ++ ".classes"),
    ← array (array payloadStep) (← field j "connections" loc) (loc ++ ".connections"),
    ← array payloadClass (← field j "outputClasses" loc) (loc ++ ".outputClasses"),
    ← array (array payloadStep) (← field j "outputConnections" loc) (loc ++ ".outputConnections"),
    ← agreementConclusion (← field j "conclusion" loc) (loc ++ ".conclusion")⟩

def returnCycle (j : Json) (loc : String) : Except String U11.ReturnCycle := do
  fields j ["member","block","vertices","length"] [] loc
  pure ⟨← payloadPath (← field j "member" loc) (loc ++ ".member"),← natField j "block" loc,
    ← array (fun v a => located a v.getNat?) (← field j "vertices" loc) (loc ++ ".vertices"),← natField j "length" loc⟩
def arithmetic (j : Json) (loc : String) : Except String U11.Arithmetic := do
  fields j ["gcd","multiplier","value"] [] loc
  pure ⟨← natField j "gcd" loc,← natField j "multiplier" loc,
    ← naturalString (← field j "value" loc) (loc ++ ".value")⟩
def returned (j : Json) (loc : String) : Except String U11.ReturnBlock := do
  fields j ["cycles","arithmetic","calls","additionalCalls"] [] loc
  pure ⟨← array returnCycle (← field j "cycles" loc) (loc ++ ".cycles"),
    ← array arithmetic (← field j "arithmetic" loc) (loc ++ ".arithmetic"),
    ← naturalString (← field j "calls" loc) (loc ++ ".calls"),
    ← naturalString (← field j "additionalCalls" loc) (loc ++ ".additionalCalls")⟩
def tail (j : Json) (loc : String) : Except String U11.ReturnTail := do
  fields j ["member","block","vertices","repeatedIndex"] [] loc
  pure ⟨← payloadPath (← field j "member" loc) (loc ++ ".member"),← natField j "block" loc,
    ← array (fun v a => located a v.getNat?) (← field j "vertices" loc) (loc ++ ".vertices"),← natField j "repeatedIndex" loc⟩
def returnConclusion (j : Json) (loc : String) : Except String U11.Conclusion := do
  let obj ← located loc j.getObj?
  need (obj.size == 1) loc "expected one return conclusion"
  if let some box := obj.get? "returned" then
    fields box ["_0"] [] (loc ++ ".returned")
    pure (.returned (← returned (← field box "_0" loc) (loc ++ ".returned._0")))
  else
    fields j ["obstructed"] [] loc
    let box ← field j "obstructed" loc
    fields box ["_0"] [] (loc ++ ".obstructed")
    pure (.obstructed (← tail (← field box "_0" loc) (loc ++ ".obstructed._0")))
def repetitionCertificate (j : Json) (loc : String) : Except String U11.Certificate := do
  fields j ["classes","connections","required","hiddenActions"] ["conclusion"] loc
  let conclusion ← match j.getObjVal? "conclusion" with
    | .error _ => pure none
    | .ok v => some <$> returnConclusion v (loc ++ ".conclusion")
  pure ⟨← array payloadClass (← field j "classes" loc) (loc ++ ".classes"),
    ← array (array payloadStep) (← field j "connections" loc) (loc ++ ".connections"),
    ← array (fun v a => located a v.getNat?) (← field j "required" loc) (loc ++ ".required"),
    ← array Actions.payloadEvidence (← field j "hiddenActions" loc) (loc ++ ".hiddenActions"),conclusion⟩

/-- Decoder of the certificate payload remains a named implementation premise.
No payload verdict is trusted: each typed result must pass its proved checker. -/
def envelope (b : ByteArray) (key : String) : Except String (Bytes × Json) := do
  let j ← decodeJSON b
  fields j ["format","record",key] [] "certificate"
  need ((← natField j "format" "certificate") == 9) "certificate.format" "expected format 9"
  let record ← located "certificate.record" (← field j "record" "certificate").getStr?
  pure (record.toUTF8.data.toList.map UInt8.toNat,← field j key "certificate")
end Record.Extended
