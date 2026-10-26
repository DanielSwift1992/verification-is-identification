import Record.Actions.Payload
import Record.Actions.Wire
import U7.Words
import U8.Soundness

namespace Record.Actions
open U5

/-- The declared family and the actual proof of check=true travel together. -/
inductive Judgment (w : World) where
  | u7 (certificate : U7.Certificate) (noHidden : w.environment.hiddenActions = none)
      (checked : U7.check w.environment.model w.environment.actions certificate = true)
  | u8 (hs : List U7.Action) (declared : w.environment.hiddenActions = some hs)
      (certificate : U8.Certificate)
      (checked : U8.check w.environment.model w.environment.actions hs certificate = true)

def Judgment.code {w : World} : Judgment w → Nat
  | .u7 c _ _ => if c.stable.isSome then 0 else 1
  | .u8 _ _ c _ =>
    if c.visible.stable.isSome then
      match c.hidden with
      | some h => match h.conclusion with | .common .. => 0 | _ => 1
      | none => 1
    else 1

def Judgment.Sound {w : World} : Judgment w → Prop
  | .u7 c _ _ => ∀ (α : Type) (i : Interpretation α) (x : Path → α),
      Gamma w.environment.model i x → U7.Claim w.environment.model w.environment.actions c i x
  | .u8 hs _ c _ => ∀ (α : Type) (i : Interpretation α) (x : Path → α),
      Gamma w.environment.model i x →
      U7.Claim w.environment.model w.environment.actions c.visible i x ∧
      U8.Claim w.environment.model hs c i x

theorem judgment_sound {w : World} (j : Judgment w) : j.Sound := by
  cases j with
  | u7 c hn hc => exact U7.check_sound hc
  | u8 hs hd c hc =>
    intro α i x hx
    exact ⟨U7.check_sound (U8.visible_checked hc) α i x hx, U8.check_sound hc α i x hx⟩

/-- U5 is still a checked auxiliary conclusion in the format-8 envelope;
its truth value never selects the U7/U8 exit code. -/
def auxiliary (m : Model) (p : Payload) : Except String Unit := do
  need (U5.check m p.conclusion) "certificate.conclusion" "U5.check refused selections or partition"
  if let .obstructed o := p.conclusion then
    if let some r := p.residue then
      need (U6.checkResidue m o.classes r) "certificate.residue" "invalid exact classes or missing classes"

def checkPayload (w : World) (p : Payload) : Except String (Judgment w) := do
  need (p.record == write w) "certificate.record" "source record substituted"
  auxiliary w.environment.model p
  match hd : w.environment.hiddenActions with
  | none =>
    need (p.dynamics.hiddenActions.isNone && p.dynamics.hidden.isNone)
      "certificate.dynamics.hiddenActions" "no hidden family was declared"
    if hc : U7.check w.environment.model w.environment.actions p.dynamics.visible = true then
      pure (.u7 p.dynamics.visible hd hc)
    else .error "certificate.dynamics: U7.check refused the certificate"
  | some hs =>
    match p.dynamics.hiddenActions with
    | none => .error "certificate.dynamics.hiddenActions: missing evidence for the declared family"
    | some evidence =>
      let c : U8.Certificate := ⟨p.dynamics.visible, evidence, p.dynamics.hidden⟩
      if hc : U8.check w.environment.model w.environment.actions hs c = true then
        pure (.u8 hs hd c hc)
      else .error "certificate.dynamics: U8.check refused the certificate"

def finish (w : World) (proof : ByteArray) : Except String (Judgment w) := do
  let p ← decodePayload proof
  checkPayload w p

def replay (proof : ByteArray) (b : Bytes) : Except String (Sigma Judgment) :=
  match read b with
  | .error e => .error e
  | .ok w => match finish w proof with
    | .error e => .error e
    | .ok j => .ok ⟨w, j⟩

def exitCode (proof : ByteArray) (b : Bytes) : Nat :=
  match replay proof b with
  | .error _ => 2
  | .ok ⟨_, j⟩ => j.code

theorem replay_sound {proof : ByteArray} {b : Bytes} {result : Sigma Judgment}
    (h : replay proof b = .ok result) :
    read b = .ok result.1 ∧ write result.1 = b ∧ result.2.Sound := by
  cases hr : read b with
  | error e => simp [replay, hr] at h
  | ok w =>
    cases hj : finish w proof with
    | error e => simp [replay, hr, hj] at h
    | ok j =>
      simp [replay, hr, hj] at h
      subst result
      exact ⟨rfl, write_read hr, judgment_sound j⟩

theorem exit_sound {proof : ByteArray} {b : Bytes}
    (h : exitCode proof b = 0 ∨ exitCode proof b = 1) :
    ∃ result, replay proof b = .ok result ∧ read b = .ok result.1 ∧
      write result.1 = b ∧ result.2.Sound := by
  cases hr : replay proof b with
  | error e => simp [exitCode, hr] at h
  | ok result => exact ⟨result, rfl, replay_sound hr⟩

/-- One chain: actual IO bytes, a proved canonical reading and the same declared
Source, G and H, followed by the proved U7/U8 judgment. The payload decoder is
an explicit implementation premise; a refusal supplies no judgment. -/
theorem exit_bytes_sound {proof b : ByteArray}
    (h : exitCode proof (Record.byteValues b) = 0 ∨
      exitCode proof (Record.byteValues b) = 1) :
    ∃ result, replay proof (Record.byteValues b) = .ok result ∧
      readBytes b = .ok result.1 ∧ writeBytes result.1 = b ∧
      Denotes result.1.val result.1.environment ∧ result.2.Sound := by
  obtain ⟨result, hr, hw, _, hs⟩ := exit_sound h
  exact ⟨result, hr, hw, write_read_bytes hw, result.1.denotes, hs⟩

end Record.Actions
