import Std

namespace Record

/-- Byte values, not decoded Unicode scalars. IO maps UInt8.toNat into this list.
The grammar below only emits ASCII and rejects every other byte. -/
abbrev Bytes := List Nat

def ascii (s : String) : Bytes := s.toList.map Char.toNat

def literal : Bytes → Bytes → Option Bytes
  | [], input => some input
  | a :: word, b :: input => if a == b then literal word input else none
  | _, _ => none

@[simp] theorem literal_write (word tail : Bytes) :
    literal word (word ++ tail) = some tail := by
  induction word <;> simp_all [literal]

def digit (b : Nat) : Bool := 48 ≤ b && b ≤ 57

def digits (n : Nat) : Bytes := (Nat.toDigits 10 n).map Char.toNat

def splitDigits : Bytes → Bytes × Bytes
  | [] => ([], [])
  | b :: rest => if digit b then
      let (ds, tail) := splitDigits rest
      (b :: ds, tail)
    else ([], b :: rest)

def undigits (bs : Bytes) : Nat := bs.foldl (fun n b => 10 * n + (b - 48)) 0

def natural (input : Bytes) : Option (Nat × Bytes) :=
  let (ds, tail) := splitDigits input
  if ds.isEmpty then none else some (undigits ds, tail)

def NonDigitHead : Bytes → Prop
  | [] => True
  | b :: _ => digit b = false

theorem split_digits_append (ds tail : Bytes)
    (hd : ∀ b ∈ ds, digit b = true) (ht : NonDigitHead tail) :
    splitDigits (ds ++ tail) = (ds, tail) := by
  induction ds with
  | nil =>
    cases tail with
    | nil => rfl
    | cons b rest => simp [splitDigits, NonDigitHead] at ht ⊢; exact ht
  | cons b rest ih =>
    have hb := hd b (by simp)
    have hr := ih (fun a ha => hd a (by simp [ha]))
    simp [splitDigits, hb, hr]

theorem digits_all (n : Nat) : ∀ b ∈ digits n, digit b = true := by
  intro b hb
  obtain ⟨c, hc, rfl⟩ := List.mem_map.mp hb
  have h := Char.isDigit_iff_toNat.mp (Nat.isDigit_of_mem_toDigits (by decide) (by decide) hc)
  simpa [digit] using h

@[simp] theorem undigits_digits (n : Nat) : undigits (digits n) = n := by
  simpa [undigits, digits, Nat.ofDigitChars, List.foldl_map] using
    (Nat.ofDigitChars_ten_toDigits (n := n))

theorem natural_write (n : Nat) (tail : Bytes) (ht : NonDigitHead tail) :
    natural (digits n ++ tail) = some (n, tail) := by
  have hn : (digits n).isEmpty = false := by
    simp [digits, Nat.toDigits_ne_nil]
  simp [natural, split_digits_append _ _ (digits_all n) ht, hn]

/-- A delimited nonnegative integer. Its terminator makes the numeric
prefix unambiguous, including when the following field starts with a digit. -/
def number (stop : Nat) (input : Bytes) : Option (Nat × Bytes) := do
  let (n, rest) ← natural input
  let tail ← literal [stop] rest
  pure (n, tail)

theorem number_write (n stop : Nat) (tail : Bytes) (hs : digit stop = false) :
    number stop (digits n ++ stop :: tail) = some (n, tail) := by
  simp [number, natural_write n (stop :: tail) hs, literal]

structure Codec (α : Type) where
  emit : α → Bytes
  parse : Bytes → Option (α × Bytes)
  first : α → Nat
  starts : ∀ a, (emit a).head? = some (first a)
  notClose : ∀ a, first a ≠ 93
  inverse : ∀ a tail, parse (emit a ++ tail) = some (a, tail)

theorem codec_head (c : Codec α) (a : α) (tail : Bytes) :
    (c.emit a ++ tail).head? = some (c.first a) := by
  have h := c.starts a
  cases he : c.emit a <;> simp_all

def items (emit : α → Bytes) : List α → Bytes
  | [] => [93]
  | a :: [] => emit a ++ [93]
  | a :: b :: rest => emit a ++ 44 :: items emit (b :: rest)

def parseItems (parse : Bytes → Option (α × Bytes)) : Nat → Bytes → Option (List α × Bytes)
  | 0, _ => none
  | fuel + 1, input =>
    if input.head? == some 93 then some ([], input.drop 1) else do
      let (a, rest) ← parse input
      match rest with
      | 93 :: tail => pure ([a], tail)
      | 44 :: tail => do
        let (as, suffix) ← parseItems parse fuel tail
        if as.isEmpty then none else pure (a :: as, suffix)
      | _ => none

theorem parse_items_write (c : Codec α) (xs : List α) (tail : Bytes) (fuel : Nat)
    (hf : xs.length + 1 ≤ fuel) :
    parseItems c.parse fuel (items c.emit xs ++ tail) = some (xs, tail) := by
  induction xs generalizing fuel with
  | nil => cases fuel <;> simp_all [items, parseItems]
  | cons a xs ih =>
    cases fuel with
    | zero => simp at hf
    | succ n =>
      cases xs with
      | nil =>
        simp only [items, List.append_assoc]
        simp [parseItems, c.starts, c.notClose, c.inverse]
      | cons b bs =>
        have hrec := ih n (by simp_all)
        simp only [items, List.append_assoc]
        simp [parseItems, c.starts, c.notClose, c.inverse, hrec]

theorem items_length (emit : α → Bytes) (xs : List α) :
    xs.length ≤ (items emit xs).length := by
  induction xs with
  | nil => simp [items]
  | cons a xs ih => cases xs <;> simp_all [items]; omega

def arrayParse (p : Bytes → Option (α × Bytes)) (input : Bytes) : Option (List α × Bytes) := do
  let rest ← literal [91] input
  parseItems p (input.length + 1) rest

def arrayCodec (c : Codec α) : Codec (List α) where
  emit xs := 91 :: items c.emit xs
  parse := arrayParse c.parse
  first := fun _ => 91
  starts _ := rfl
  notClose _ := by decide
  inverse xs tail := by
    have hf : xs.length + 1 ≤ (91 :: items c.emit xs ++ tail).length + 1 := by
      have := items_length c.emit xs
      simp only [List.length_cons, List.length_append]; omega
    simpa [arrayParse, literal] using parse_items_write c xs tail _ hf

end Record
