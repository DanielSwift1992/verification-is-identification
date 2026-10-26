import Record.Extended.Agreement
import Record.Actions.Wire
import Record.Canonical

namespace Record.Extended
open U5

@[simp] theorem base_ascii (v : Nat) (w : Base) : IsASCII (baseEmit v w) := by
  have hs := items_ascii nodeCodec.emit w.source (fun n _ => node_ascii n)
  have he := items_ascii edgeCodec.emit w.edges (fun e _ => edge_ascii e)
  simp_all [baseEmit,schemaHeader,arrayCodec,ascii]

theorem optional_ascii (key : String) (c : Codec α) (value : Option α)
    (hk : IsASCII (ascii (",\"" ++ key ++ "\":")))
    (hc : ∀ a, IsASCII (c.emit a)) : IsASCII (optionalEmit key c value) := by
  cases value with
  | none => simp [optionalEmit]
  | some a => exact (ascii_append).mpr ⟨hk,hc a⟩

theorem edges_ascii (es : List Edge) : IsASCII ((arrayCodec edgeCodec).emit es) := by
  have h := items_ascii edgeCodec.emit es (fun e _ => edge_ascii e)
  simpa [arrayCodec] using h

theorem members_ascii (as : List Actions.Member) : IsASCII ((arrayCodec Actions.memberCodec).emit as) := by
  have h := items_ascii Actions.memberCodec.emit as (fun a _ => Actions.member_ascii a)
  simpa [arrayCodec] using h

@[simp] theorem image_ascii (w : ImageRaw) : IsASCII (imageEmit w) := by
  have hp := optional_ascii "promise" (arrayCodec edgeCodec) w.promise (by simp [ascii]) edges_ascii
  have hh := optional_ascii "hiddenActions" (arrayCodec Actions.memberCodec) w.hidden (by simp [ascii]) members_ascii
  simp_all [imageEmit,ascii,viewCodec]

@[simp] theorem agreement_ascii (w : AgreementRaw) : IsASCII (agreementEmit w) := by
  have hp := optional_ascii "promise" (arrayCodec edgeCodec) w.promise (by simp [ascii]) edges_ascii
  have ho := optional_ascii "boundOutputs" viewCodec w.boundOutputs (by simp [ascii]) view_ascii
  have hs := optional_ascii "boundSources" viewCodec w.boundSources (by simp [ascii]) view_ascii
  have hn := items_ascii nodeCodec.emit w.output (fun n _ => node_ascii n)
  simp_all [agreementEmit,ascii,viewCodec,arrayCodec]

def imageGrammar : Canonical.Grammar ImageRaw ImageEnvironment :=
  ⟨imageEmit,imageParse,image_inverse,image_ascii,admitImage⟩
def agreementGrammar : Canonical.Grammar AgreementRaw AgreementEnvironment :=
  ⟨agreementEmit,agreementParse,agreement_inverse,agreement_ascii,admitAgreement⟩

namespace Image
abbrev World := Canonical.World imageGrammar
abbrev read := Canonical.read imageGrammar
abbrev write := Canonical.write imageGrammar
abbrev readBytes := Canonical.readBytes imageGrammar
abbrev writeBytes := Canonical.writeBytes imageGrammar
abbrev environment := Canonical.environment imageGrammar

theorem read_write (w : World) : read (write w) = .ok w := Canonical.read_write imageGrammar w
theorem write_read {b : Bytes} {w : World} (h : read b = .ok w) : write w = b := Canonical.write_read imageGrammar h
theorem read_write_bytes (w : World) : readBytes (writeBytes w) = .ok w := Canonical.read_write_bytes imageGrammar w
theorem write_read_bytes {b : ByteArray} {w : World} (h : readBytes b = .ok w) : writeBytes w = b := Canonical.write_read_bytes imageGrammar h

theorem denotes (w : World) : ImageDenotes w.val (environment w) :=
  admit_image_denotes (Canonical.admit_environment imageGrammar w)
end Image

namespace Agreement
abbrev World := Canonical.World agreementGrammar
abbrev read := Canonical.read agreementGrammar
abbrev write := Canonical.write agreementGrammar
abbrev readBytes := Canonical.readBytes agreementGrammar
abbrev writeBytes := Canonical.writeBytes agreementGrammar
abbrev environment := Canonical.environment agreementGrammar

theorem read_write (w : World) : read (write w) = .ok w := Canonical.read_write agreementGrammar w
theorem write_read {b : Bytes} {w : World} (h : read b = .ok w) : write w = b := Canonical.write_read agreementGrammar h
theorem read_write_bytes (w : World) : readBytes (writeBytes w) = .ok w := Canonical.read_write_bytes agreementGrammar w
theorem write_read_bytes {b : ByteArray} {w : World} (h : readBytes b = .ok w) : writeBytes w = b := Canonical.write_read_bytes agreementGrammar h

theorem denotes (w : World) : AgreementDenotes w.val (environment w) :=
  admit_agreement_denotes (Canonical.admit_environment agreementGrammar w)
end Agreement
end Record.Extended
