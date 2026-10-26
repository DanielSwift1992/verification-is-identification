import Record.Payload
import Record.Wire
import Record.Semantics

namespace Record
open U5

/-- Successful checking carries the actual proof of the checker predicate.
No transport-decoder success, diagnostic or test can create this witness. -/
inductive Judgment (w : World) where
  | u5 (certificate : U5.Certificate) (checked : U5.check w.model certificate = true)
  | u6 (certificate : U6.Certificate) (checked : U6.check w.model certificate = true)

def Judgment.code {w : World} : Judgment w → Nat
  | .u5 (.constructed _) _ => 0
  | .u5 (.obstructed _) _ => 1
  | .u6 _ _ => 0

def Judgment.Sound {w : World} : Judgment w → Prop
  | .u5 c _ => ∀ (α : Type) (i : Interpretation α) (x : Path → α),
      Gamma w.model i x → U5.Claim w.model c i x
  | .u6 c _ => ∀ (α : Type) (i : Interpretation α) (x : Path → α),
      Gamma w.model i x →
      run (U6.program c) ((U6.observation w.model c).map x) = some (w.model.question.map x)

theorem judgment_sound {w : World} (j : Judgment w) : j.Sound := by
  cases j with
  | u5 c h => exact U5.check_sound h
  | u6 c h => exact U6.check_sound h

def checkedCore (w : World) (retain : Bool) (c : U5.Certificate)
    (residue : Option U6.Residue) (retention : Option U6.Retention) : Except String (Judgment w) :=
  if h5 : U5.check w.model c = true then
    match c with
    | .constructed construction => do
      need retention.isNone "certificate.retention" "constructed continuation needs no residual"
      if retain then
        .ok (.u6 (.zero construction) h5)
      else .ok (.u5 (.constructed construction) h5)
    | .obstructed obstruction => do
      if let some r := residue then
        need (U6.checkResidue w.model obstruction.classes r) "certificate.residue" "invalid exact classes or missing classes"
      match retention with
      | none =>
        if retain then .error "certificate.retention: no retained view and decoder were presented"
        else .ok (.u5 (.obstructed obstruction) h5)
      | some retention =>
        match residue with
        | none => .error "certificate.residue: retention requires exact E-classes"
        | some residue =>
          let cert := U6.Certificate.retained ⟨obstruction, residue, retention⟩
          if h6 : U6.check w.model cert = true then
            if retain then .ok (.u6 cert h6)
            else .ok (.u5 (.obstructed obstruction) h5)
          else .error "certificate.retention: U6.check refused the retained view or decoder"
  else .error "certificate.conclusion: U5.check refused selections or partition"

def checkPayload (w : World) (retain : Bool) (p : Payload) : Except String (Judgment w) :=
  if p.record == write w then checkedCore w retain p.conclusion p.residue p.retention
  else .error "certificate.record: source record substituted"

def finish (w : World) (retain : Bool) (proof : ByteArray) : Except String (Judgment w) := do
  let p ← decodePayload proof
  checkPayload w retain p

/-- The dependent pair remembers which proved byte reading was checked. -/
def replay (retain : Bool) (proof : ByteArray) (b : Bytes) : Except String (Sigma Judgment) :=
  match read b with
  | .error e => .error e
  | .ok w => match finish w retain proof with
    | .error e => .error e
    | .ok j => .ok ⟨w, j⟩

def exitCode (retain : Bool) (proof : ByteArray) (b : Bytes) : Nat :=
  match replay retain proof b with
  | .error _ => 2
  | .ok ⟨_, j⟩ => j.code

/-- One chain: these input bytes were admitted, yield this exact Model, and
the certificate's actual U5/U6 checker witness entails the universal claim.
The JSON payload decoder is not a proof premise for world reading. -/
theorem replay_sound {retain : Bool} {proof : ByteArray} {b : Bytes}
    {result : Sigma Judgment} (h : replay retain proof b = .ok result) :
    read b = .ok result.1 ∧ write result.1 = b ∧ result.2.Sound := by
  cases hr : read b with
  | error e => simp [replay, hr] at h
  | ok w =>
    cases hj : finish w retain proof with
    | error e => simp [replay, hr, hj] at h
    | ok j =>
      simp [replay, hr, hj] at h
      subst result
      exact ⟨rfl, write_read hr, judgment_sound j⟩

/-- This is the pure decision function called by Main after IO has supplied
the bytes. Exit 2 makes no semantic assertion. -/
theorem exit_sound {retain : Bool} {proof : ByteArray} {b : Bytes}
    (h : exitCode retain proof b = 0 ∨ exitCode retain proof b = 1) :
    ∃ result, replay retain proof b = .ok result ∧
      read b = .ok result.1 ∧ write result.1 = b ∧ result.2.Sound := by
  cases hr : replay retain proof b with
  | error e => simp [exitCode, hr] at h
  | ok result => exact ⟨result, rfl, replay_sound hr⟩

/-- The same chain on the ByteArray actually supplied by IO, with both byte
round trips. No text reader or unproved world-to-Model table intervenes. -/
theorem exit_bytes_sound {retain : Bool} {proof b : ByteArray}
    (h : exitCode retain proof (byteValues b) = 0 ∨
      exitCode retain proof (byteValues b) = 1) :
    ∃ result, replay retain proof (byteValues b) = .ok result ∧
      readBytes b = .ok result.1 ∧ writeBytes result.1 = b ∧
      Denotes result.1.val result.1.model ∧ result.2.Sound := by
  obtain ⟨result, hr, hw, _, hs⟩ := exit_sound h
  exact ⟨result, hr, hw, write_read_bytes hw, result.1.denotes, hs⟩

end Record
