import Record.Admission

namespace Record

def IsASCII (bs : Bytes) : Prop := ∀ b ∈ bs, b < 128

@[simp] theorem ascii_nil : IsASCII [] := by simp [IsASCII]
@[simp] theorem ascii_cons : IsASCII (a :: bs) ↔ a < 128 ∧ IsASCII bs := by simp [IsASCII]
@[simp] theorem ascii_append : IsASCII (a ++ b) ↔ IsASCII a ∧ IsASCII b := by simp [IsASCII, or_imp, forall_and]

@[simp] theorem digits_ascii (n : Nat) : IsASCII (digits n) := by
  intro b hb
  have h := digits_all n b hb
  simp only [digit, Bool.and_eq_true_iff, decide_eq_true_eq] at h
  omega

theorem items_ascii (emit : α → Bytes) (xs : List α)
    (ha : ∀ a ∈ xs, IsASCII (emit a)) : IsASCII (items emit xs) := by
  induction xs with
  | nil => simp [items]
  | cons a xs ih =>
    have hh := ha a (by simp)
    have ht := ih (fun b hb => ha b (by simp [hb]))
    cases xs <;> simp_all [items]

@[simp] theorem path_ascii (p : U5.Path) : IsASCII (pathCodec.emit p) := by
  have h := items_ascii sideCodec.emit p (fun b _ => by cases b <;> simp [IsASCII, sideCodec])
  simpa [pathCodec, arrayCodec] using h

@[simp] theorem node_ascii (n : Node) : IsASCII (nodeEmit n) := by
  cases n <;> simp [nodeEmit, ascii]

@[simp] theorem edge_ascii (e : U5.Edge) : IsASCII (edgeEmit e) := by
  simp [edgeEmit, ascii]

@[simp] theorem view_ascii (v : U5.Term U5.Path) : IsASCII (viewEmit v) := by
  induction v <;> simp_all [viewEmit, ascii]

@[simp] theorem raw_ascii (w : Raw) : IsASCII (rawEmit w) := by
  have hs := items_ascii nodeCodec.emit w.source (fun n _ => node_ascii n)
  have he := items_ascii edgeCodec.emit w.edges (fun e _ => edge_ascii e)
  simp_all [rawEmit, prefixEmit, schemaHeader, arrayCodec, ascii, viewCodec]

/-- This conversion is the only IO boundary for world bytes. It does not use
String/Unicode decoding, so BOM and non-ASCII bytes cannot disappear. -/
def byteValues (b : ByteArray) : Bytes := b.data.toList.map UInt8.toNat

def byteArray (bs : Bytes) : ByteArray := ⟨(bs.map UInt8.ofNat).toArray⟩

theorem byte_values_array {bs : Bytes} (h : ∀ b ∈ bs, b < 256) :
    byteValues (byteArray bs) = bs := by
  simp only [byteValues, byteArray, List.toList_toArray, List.map_map]
  calc
    _ = bs.map id := List.map_congr_left (fun b hb => by
      simp [Nat.mod_eq_of_lt (h b hb)])
    _ = bs := by simp

theorem byte_array_values (b : ByteArray) : byteArray (byteValues b) = b := by
  cases b
  simp [byteArray, byteValues, List.map_map, Function.comp_def]

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

end Record
