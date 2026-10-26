import Record.Extended.Wire
import Record.Extended.Payload
import U10.Soundness
import U11.Soundness

namespace Record.Extended
open U5

namespace Image
structure Judgment (w : World) where
  certificate : U9.Certificate
  checked : U9.check (environment w).model (environment w).members (environment w).promise certificate = true

def Judgment.code {w : World} (j : Judgment w) : Nat :=
  if j.certificate.images.all (fun p => U9.verdict p.promise) then 0 else 1

def Judgment.Sound {w : World} (j : Judgment w) : Prop :=
  (∀ a ∈ (environment w).members, ∃ proof ∈ j.certificate.images,
    (U9.verdict proof.promise = true ↔ U9.PromiseHolds (environment w).model a.image (environment w).promise) ∧
    (∀ (α : Type) (i : Interpretation α) (y : Path → α),
      U9.IsImage (environment w).model a.image i y ↔
        U9.OutputTyped (environment w).model a.image i y ∧
        ∀ u q v r, a.image.lookup u = some q → a.image.lookup v = some r →
          blockOf proof.classes u = blockOf proof.classes v → y u = y v)) ∧
  (j.certificate.images.all (fun p => U9.verdict p.promise) = true ↔
    ∀ a ∈ (environment w).members, U9.PromiseHolds (environment w).model a.image (environment w).promise)

theorem judgment_sound {w : World} (j : Judgment w) : j.Sound :=
  ⟨fun _ ha => U9.check_sound j.checked ha, U9.family_verdict j.checked⟩

def finish (w : World) (proof : ByteArray) : Except String (Judgment w) := do
  let (record,body) ← envelope proof "image"
  need (record == write w) "certificate.record" "source record substituted"
  let c ← imageCertificate body "certificate.image"
  if h : U9.check (environment w).model (environment w).members (environment w).promise c = true then
    pure ⟨c,h⟩
  else .error "certificate.image: U9.check refused the certificate"
end Image

namespace Agreement
structure Judgment (w : World) where
  certificate : U10.Certificate
  checked : U10.check (environment w).request certificate = true

def Judgment.code {w : World} (j : Judgment w) : Nat :=
  match j.certificate.conclusion with | .constructed _ => 0 | _ => 1

def Judgment.Sound {w : World} (j : Judgment w) : Prop := U10.Claim (environment w).request j.certificate

theorem judgment_sound {w : World} (j : Judgment w) : j.Sound := U10.check_sound j.checked

def finish (w : World) (proof : ByteArray) : Except String (Judgment w) := do
  let (record,body) ← envelope proof "agreement"
  need (record == write w) "certificate.record" "source record substituted"
  let c ← agreementCertificate body "certificate.agreement"
  if h : U10.check (environment w).request c = true then pure ⟨c,h⟩
  else .error "certificate.agreement: U10.check refused the certificate"
end Agreement

namespace Returns
abbrev World := Actions.World
abbrev read := Actions.read
abbrev write := Actions.write
abbrev readBytes := Actions.readBytes
abbrev writeBytes := Actions.writeBytes
abbrev environment := Actions.World.environment

structure Judgment (w : World) where
  hidden : List U7.Action
  declared : (environment w).hiddenActions = some hidden
  certificate : U11.Certificate
  checked : U11.check (environment w).model hidden certificate = true

def Judgment.code {w : World} (j : Judgment w) : Nat :=
  match j.certificate.conclusion with | some (.returned _) => 0 | _ => 1

def Judgment.Sound {w : World} (j : Judgment w) : Prop :=
  U11.Claim (environment w).model j.hidden j.certificate

theorem judgment_sound {w : World} (j : Judgment w) : j.Sound := U11.check_sound j.checked

def finish (w : World) (proof : ByteArray) : Except String (Judgment w) := do
  let (record,body) ← envelope proof "repetition"
  need (record == write w) "certificate.record" "source record substituted"
  let c ← repetitionCertificate body "certificate.repetition"
  match hd : (environment w).hiddenActions with
  | none => .error "record.hiddenActions: U11 requires a nonempty hidden family"
  | some hs =>
    if h : U11.check (environment w).model hs c = true then pure ⟨hs,hd,c,h⟩
    else .error "certificate.repetition: U11.check refused the certificate"
end Returns
end Record.Extended

namespace Record.Extended.Image

def replay (proof : ByteArray) (b : Record.Bytes) : Except String (Sigma Judgment) :=
  match read b with
  | .error e => .error e
  | .ok w => match finish w proof with
    | .error e => .error e
    | .ok j => .ok ⟨w,j⟩

def exitCode (proof : ByteArray) (b : Record.Bytes) : Nat :=
  match replay proof b with | .error _ => 2 | .ok ⟨_,j⟩ => j.code

theorem replay_sound {proof : ByteArray} {b : Record.Bytes} {result : Sigma Judgment}
    (h : replay proof b = .ok result) :
    read b = .ok result.1 ∧ write result.1 = b ∧ result.2.Sound := by
  cases hr : read b with
  | error e => simp [replay,hr] at h
  | ok w =>
    cases hj : finish w proof with
    | error e => simp [replay,hr,hj] at h
    | ok j =>
      simp [replay,hr,hj] at h
      subst result
      exact ⟨rfl,write_read hr,judgment_sound j⟩

theorem exit_sound {proof : ByteArray} {b : Record.Bytes}
    (h : exitCode proof b = 0 ∨ exitCode proof b = 1) :
    ∃ result, replay proof b = .ok result ∧ read b = .ok result.1 ∧
      write result.1 = b ∧ result.2.Sound := by
  cases hr : replay proof b with
  | error e => simp [exitCode,hr] at h
  | ok result => exact ⟨result,rfl,replay_sound hr⟩

/-- IO bytes → canonical declared object → the proved checker judgment.
The payload decoder is a named premise; no accepted result bypasses check=true. -/
theorem exit_bytes_sound {proof b : ByteArray}
    (h : exitCode proof (Record.byteValues b) = 0 ∨ exitCode proof (Record.byteValues b) = 1) :
    ∃ result, replay proof (Record.byteValues b) = .ok result ∧
      readBytes b = .ok result.1 ∧ writeBytes result.1 = b ∧
      ImageDenotes result.1.val (environment result.1) ∧ result.2.Sound := by
  obtain ⟨result,hr,hw,_,hs⟩ := exit_sound h
  exact ⟨result,hr,hw,write_read_bytes hw,denotes result.1,hs⟩
end Record.Extended.Image

namespace Record.Extended.Agreement

def replay (proof : ByteArray) (b : Record.Bytes) : Except String (Sigma Judgment) :=
  match read b with
  | .error e => .error e
  | .ok w => match finish w proof with
    | .error e => .error e
    | .ok j => .ok ⟨w,j⟩

def exitCode (proof : ByteArray) (b : Record.Bytes) : Nat :=
  match replay proof b with | .error _ => 2 | .ok ⟨_,j⟩ => j.code

theorem replay_sound {proof : ByteArray} {b : Record.Bytes} {result : Sigma Judgment}
    (h : replay proof b = .ok result) :
    read b = .ok result.1 ∧ write result.1 = b ∧ result.2.Sound := by
  cases hr : read b with
  | error e => simp [replay,hr] at h
  | ok w =>
    cases hj : finish w proof with
    | error e => simp [replay,hr,hj] at h
    | ok j =>
      simp [replay,hr,hj] at h
      subst result
      exact ⟨rfl,write_read hr,judgment_sound j⟩

theorem exit_sound {proof : ByteArray} {b : Record.Bytes}
    (h : exitCode proof b = 0 ∨ exitCode proof b = 1) :
    ∃ result, replay proof b = .ok result ∧ read b = .ok result.1 ∧
      write result.1 = b ∧ result.2.Sound := by
  cases hr : replay proof b with
  | error e => simp [exitCode,hr] at h
  | ok result => exact ⟨result,rfl,replay_sound hr⟩

/-- IO bytes → canonical declared object → the proved checker judgment.
The payload decoder is a named premise; no accepted result bypasses check=true. -/
theorem exit_bytes_sound {proof b : ByteArray}
    (h : exitCode proof (Record.byteValues b) = 0 ∨ exitCode proof (Record.byteValues b) = 1) :
    ∃ result, replay proof (Record.byteValues b) = .ok result ∧
      readBytes b = .ok result.1 ∧ writeBytes result.1 = b ∧
      AgreementDenotes result.1.val (environment result.1) ∧ result.2.Sound := by
  obtain ⟨result,hr,hw,_,hs⟩ := exit_sound h
  exact ⟨result,hr,hw,write_read_bytes hw,denotes result.1,hs⟩
end Record.Extended.Agreement

namespace Record.Extended.Returns

def replay (proof : ByteArray) (b : Record.Bytes) : Except String (Sigma Judgment) :=
  match read b with
  | .error e => .error e
  | .ok w => match finish w proof with
    | .error e => .error e
    | .ok j => .ok ⟨w,j⟩

def exitCode (proof : ByteArray) (b : Record.Bytes) : Nat :=
  match replay proof b with | .error _ => 2 | .ok ⟨_,j⟩ => j.code

theorem replay_sound {proof : ByteArray} {b : Record.Bytes} {result : Sigma Judgment}
    (h : replay proof b = .ok result) :
    read b = .ok result.1 ∧ write result.1 = b ∧ result.2.Sound := by
  cases hr : read b with
  | error e => simp [replay,hr] at h
  | ok w =>
    cases hj : finish w proof with
    | error e => simp [replay,hr,hj] at h
    | ok j =>
      simp [replay,hr,hj] at h
      subst result
      exact ⟨rfl,Actions.write_read hr,judgment_sound j⟩

theorem exit_sound {proof : ByteArray} {b : Record.Bytes}
    (h : exitCode proof b = 0 ∨ exitCode proof b = 1) :
    ∃ result, replay proof b = .ok result ∧ read b = .ok result.1 ∧
      write result.1 = b ∧ result.2.Sound := by
  cases hr : replay proof b with
  | error e => simp [exitCode,hr] at h
  | ok result => exact ⟨result,rfl,replay_sound hr⟩

/-- IO bytes → canonical declared object → the proved checker judgment.
The payload decoder is a named premise; no accepted result bypasses check=true. -/
theorem exit_bytes_sound {proof b : ByteArray}
    (h : exitCode proof (Record.byteValues b) = 0 ∨ exitCode proof (Record.byteValues b) = 1) :
    ∃ result, replay proof (Record.byteValues b) = .ok result ∧
      readBytes b = .ok result.1 ∧ writeBytes result.1 = b ∧
      Actions.Denotes result.1.val (environment result.1) ∧ result.2.Sound := by
  obtain ⟨result,hr,hw,_,hs⟩ := exit_sound h
  exact ⟨result,hr,hw,Actions.write_read_bytes hw,Actions.World.denotes result.1,hs⟩
end Record.Extended.Returns
