import Record.Actions.Admission
import Record.Wire

namespace Record.Actions

@[simp] theorem member_ascii (a : Member) : IsASCII (memberEmit a) := by
  have h := items_ascii pathCodec.emit a.image (fun p _ => path_ascii p)
  simp_all [memberEmit, arrayCodec, ascii]

@[simp] theorem optional_ascii (key : String) (ms : Option (List Member))
    (hkey : IsASCII (ascii (",\"" ++ key ++ "\":"))) : IsASCII (optionalEmit key ms) := by
  cases ms with
  | none => simp [optionalEmit]
  | some ms =>
    have h := items_ascii memberCodec.emit ms (fun a _ => member_ascii a)
    simp only [optionalEmit, ascii_append, arrayCodec, ascii_cons]
    exact ⟨hkey, by decide, h⟩

@[simp] theorem raw_ascii (w : Raw) : IsASCII (rawEmit w) := by
  have hs := items_ascii nodeCodec.emit w.base.source (fun n _ => node_ascii n)
  have he := items_ascii edgeCodec.emit w.base.edges (fun e _ => edge_ascii e)
  have ha := optional_ascii "actions" w.actions (by simp [ascii])
  have hh := optional_ascii "hiddenActions" w.hiddenActions (by simp [ascii])
  simp_all [rawEmit, prefixEmit, schemaHeader, arrayCodec, ascii, viewCodec]

/-- This conversion is the only IO boundary for world bytes. It does not use
String/Unicode decoding, so BOM and non-ASCII bytes cannot disappear. -/
abbrev byteValues := Record.byteValues

abbrev byteArray := Record.byteArray

def writeBytes (w : World) : ByteArray := byteArray (write w)
def readBytes (b : ByteArray) : Except String World := read (byteValues b)

theorem read_write_bytes (w : World) : readBytes (writeBytes w) = .ok w := by
  have ha := raw_ascii w.val
  have h : ∀ b ∈ write w, b < 256 := by
    intro b hb
    have h := ha b hb
    omega
  simp [readBytes, writeBytes, byte_values_array h, read_write]

theorem write_read_bytes {b : ByteArray} {w : World} (h : readBytes b = .ok w) :
    writeBytes w = b := by
  have hw := write_read h
  simp [writeBytes, hw, byte_array_values]

theorem write_bytes_injective : Function.Injective writeBytes := by
  intro a b h
  have := congrArg readBytes h
  simpa only [read_write_bytes, Except.ok.injEq] using this

end Record.Actions
