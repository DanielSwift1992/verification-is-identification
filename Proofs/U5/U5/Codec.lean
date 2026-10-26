import U5.Model

namespace U5.Codec

/-- Canonical bit serialization. Sort identities use unary coding here:
leaf s = 0 1^s 0; pair l r = 1 encode(l) encode(r).
This deliberately simple codec proves uniqueness, not compactness. -/
def encode : Term SortId → List Bool
  | .leaf s => false :: (List.replicate s true ++ [false])
  | .pair l r => true :: (encode l ++ encode r)

def readNat : List Bool → Option (Nat × List Bool)
  | [] => none
  | false :: rest => some (0, rest)
  | true :: rest => do
    let (n, tail) ← readNat rest
    pure (n + 1, tail)

def parse : Nat → List Bool → Option (Term SortId × List Bool)
  | 0, _ => none
  | _ + 1, [] => none
  | _ + 1, false :: rest => do
    let (s, tail) ← readNat rest
    pure (.leaf s, tail)
  | fuel + 1, true :: rest => do
    let (l, tail) ← parse fuel rest
    let (r, tail') ← parse fuel tail
    pure (.pair l r, tail')

def decode (bits : List Bool) : Option (Term SortId) := do
  let (term, tail) ← parse bits.length bits
  if tail.isEmpty then some term else none

def height : Term α → Nat
  | .leaf _ => 1
  | .pair l r => max (height l) (height r) + 1

@[simp] theorem readNat_encode (s : Nat) (tail : List Bool) :
    readNat (List.replicate s true ++ false :: tail) = some (s, tail) := by
  induction s with
  | zero => rfl
  | succ n ih => simp [List.replicate_succ, readNat, ih]

theorem parse_encode (t : Term SortId) (tail : List Bool) (fuel : Nat)
    (hf : height t ≤ fuel) : parse fuel (encode t ++ tail) = some (t, tail) := by
  induction t generalizing fuel tail with
  | leaf s =>
    cases fuel with
    | zero => simp [height] at hf
    | succ n => simp [encode, parse, List.append_assoc]
  | pair l r ihl ihr =>
    cases fuel with
    | zero => simp [height] at hf
    | succ n =>
      have hl : height l ≤ n := by simp [height] at hf; omega
      have hr : height r ≤ n := by simp [height] at hf; omega
      simp [encode, parse, List.append_assoc, ihl _ n hl, ihr _ n hr]

theorem height_le_length (t : Term SortId) : height t ≤ (encode t).length := by
  induction t with
  | leaf s => simp [height, encode]
  | pair l r ihl ihr => simp only [height, encode, List.length_cons, List.length_append]; omega

/-- The left inverse, for every finite term, proved by induction, not examples. -/
theorem decode_encode (t : Term SortId) : decode (encode t) = some t := by
  have h := parse_encode t [] (encode t).length (height_le_length t)
  simpa [decode, List.append_nil, h] using congrArg (fun v =>
    v.bind (fun (term, tail) => if tail.isEmpty then some term else none)) h

theorem readNat_consumes {bits tail : List Bool} {n : Nat}
    (h : readNat bits = some (n, tail)) :
    bits = List.replicate n true ++ false :: tail := by
  induction bits generalizing n with
  | nil => simp [readNat] at h
  | cons b rest ih =>
    cases b with
    | false => simp [readNat] at h; obtain ⟨rfl, rfl⟩ := h; rfl
    | true =>
      cases hn : readNat rest with
      | none => simp [readNat, hn] at h
      | some v =>
        obtain ⟨k, suffix⟩ := v
        simp [readNat, hn] at h
        obtain ⟨rfl, rfl⟩ := h
        simp [List.replicate_succ, ih hn]

/-- No alternate encodings and no unaccounted prefix bytes (here: bits). -/
theorem parse_consumes {fuel : Nat} {bits tail : List Bool} {t : Term SortId}
    (h : parse fuel bits = some (t, tail)) : bits = encode t ++ tail := by
  induction fuel generalizing bits tail t with
  | zero => simp [parse] at h
  | succ n ih =>
    cases bits with
    | nil => simp [parse] at h
    | cons b rest =>
      cases b with
      | false =>
        cases hn : readNat rest with
        | none => simp [parse, hn] at h
        | some v =>
          obtain ⟨k, suffix⟩ := v
          simp [parse, hn] at h
          obtain ⟨rfl, rfl⟩ := h
          simp [encode, readNat_consumes hn, List.append_assoc]
      | true =>
        cases hl : parse n rest with
        | none => simp [parse, hl] at h
        | some v =>
          obtain ⟨l, middle⟩ := v
          cases hr : parse n middle with
          | none => simp [parse, hl, hr] at h
          | some v =>
            obtain ⟨r, suffix⟩ := v
            simp [parse, hl, hr] at h
            obtain ⟨rfl, rfl⟩ := h
            simp [encode, ih hl, ih hr, List.append_assoc]

/-- Full consumption: decoding succeeds exactly on the canonical encoding. -/
theorem decode_iff (bits : List Bool) (t : Term SortId) :
    decode bits = some t ↔ bits = encode t := by
  constructor
  · intro h
    cases hp : parse bits.length bits with
    | none => simp [decode, hp] at h
    | some v =>
      obtain ⟨a, tail⟩ := v
      simp [decode, hp] at h
      obtain ⟨ht, rfl⟩ := h
      simpa [ht] using parse_consumes hp
  · rintro rfl; exact decode_encode t

theorem encode_injective : Function.Injective encode := by
  intro a b h
  have := congrArg decode h
  simpa only [decode_encode, Option.some.injEq] using this

theorem decoding_unique {bits : List Bool} {a b : Term SortId}
    (ha : decode bits = some a) (hb : decode bits = some b) : a = b :=
  Option.some.inj (ha.symm.trans hb)

end U5.Codec
