import Record.Wire

namespace Record.Canonical

/-- A version's syntax and admission plug into one canonical byte reader. -/
structure Grammar (Raw Environment : Type) where
  emit : Raw → Bytes
  parse : Bytes → Except String (Raw × Bytes)
  inverse : ∀ w tail, parse (emit w ++ tail) = .ok (w,tail)
  ascii : ∀ w, IsASCII (emit w)
  admit : Raw → Except String Environment

def admissible (g : Grammar R E) (w : R) : Bool :=
  (g.emit w).length ≤ byteLimit && preflight (g.emit w) && (g.admit w).isOk
abbrev World (g : Grammar R E) := {w : R // admissible g w = true}

def environment (g : Grammar R E) (w : World g) : E :=
  match h : g.admit w.val with
  | .ok e => e
  | .error _ => False.elim (by
      have hw := w.property
      simp [admissible,h,Except.isOk,Except.toBool] at hw)

theorem admit_environment (g : Grammar R E) (w : World g) :
    g.admit w.val = .ok (environment g w) := by
  unfold environment
  split
  · assumption
  · have hw := w.property; simp_all [admissible,Except.isOk,Except.toBool]

def write (g : Grammar R E) (w : World g) : Bytes := g.emit w.val

def read (g : Grammar R E) (b : Bytes) : Except String (World g) :=
  if b.length > byteLimit then .error "record: input byte limit"
  else if preflight b != true then .error "record: JSON depth or value limit; no impossibility inferred"
  else match g.parse b with
  | .error e => .error e
  | .ok (w,tail) =>
    if !tail.isEmpty then .error "record: trailing input"
    else match g.admit w with
    | .error e => .error e
    | .ok _ =>
      if h : admissible g w = true then
        if g.emit w == b then .ok ⟨w,h⟩ else .error "record: noncanonical serialization"
      else .error "record: admission resource limit"

theorem read_write (g : Grammar R E) (w : World g) : read g (write g w) = .ok w := by
  have h := w.property
  simp only [admissible,Bool.and_eq_true_iff,decide_eq_true_eq] at h
  have hr := g.inverse w.val []
  simp only [List.append_nil] at hr
  have ha : ∃ e, g.admit w.val = .ok e := by
    cases he : g.admit w.val with
    | error e => simp [he,Except.isOk,Except.toBool] at h
    | ok e => exact ⟨e,rfl⟩
  obtain ⟨e,he⟩ := ha
  simp [read,write,Nat.not_lt_of_ge h.1.1,h.1.2,hr,he,w.property]

theorem write_read (g : Grammar R E) {b : Bytes} {w : World g}
    (h : read g b = .ok w) : write g w = b := by
  unfold read at h
  repeat' (split at h)
  all_goals simp_all [write,beq_iff_eq]
  subst w
  assumption

theorem write_injective (g : Grammar R E) : Function.Injective (write g) := by
  intro a b h
  have := congrArg (read g) h
  simpa only [read_write,Except.ok.injEq] using this

def writeBytes (g : Grammar R E) (w : World g) : ByteArray := byteArray (write g w)
def readBytes (g : Grammar R E) (b : ByteArray) : Except String (World g) := read g (byteValues b)

theorem read_write_bytes (g : Grammar R E) (w : World g) : readBytes g (writeBytes g w) = .ok w := by
  have ha := g.ascii w.val
  have h : ∀ b ∈ write g w, b < 256 := fun b hb => Nat.lt_trans (ha b hb) (by decide)
  simp [readBytes,writeBytes,byte_values_array h,read_write]

theorem write_read_bytes (g : Grammar R E) {b : ByteArray} {w : World g}
    (h : readBytes g b = .ok w) : writeBytes g w = b := by
  have hw := write_read g h
  simp [writeBytes,hw,byte_array_values]
end Record.Canonical
