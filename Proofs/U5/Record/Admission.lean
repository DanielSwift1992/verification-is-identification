import Record.Schema

namespace Record
open U5

/-- Implementation resources, not impossibility statements. -/
def byteLimit : Nat := 8000000
def valueLimit : Nat := 100000
def depthLimit : Nat := 128
def sourceLimit : Nat := 10000
def equalityWorkLimit : Nat := 100000

structure Scan where
  quoted : Bool := false
  escaped : Bool := false
  stack : List Bool := [] -- true: array; false: object
  expecting : Bool := true
  values : Nat := 0

/-- Resource preflight on bytes, before recursive syntax reading. Keys do not
consume value fuel; strings and escaped quotation marks hide delimiters. This
does not admit syntax: all input must subsequently pass the proved codec. -/
def scanByte (s : Scan) (b : Nat) : Option Scan := do
  if s.quoted then
    if s.escaped then return { s with escaped := false }
    if b == 92 then return { s with escaped := true }
    if b == 34 then return { s with quoted := false }
    return s
  if [9, 10, 13, 32].contains b then return s
  let s ← if s.expecting && b != 93 && b != 125 then
      if s.stack.length < depthLimit && s.values < valueLimit then
        some { s with expecting := false, values := s.values + 1 }
      else none
    else some s
  if b == 34 then return { s with quoted := true }
  if b == 91 then return { s with stack := true :: s.stack, expecting := true }
  if b == 123 then return { s with stack := false :: s.stack, expecting := false }
  if b == 93 || b == 125 then return { s with stack := s.stack.drop 1, expecting := false }
  if b == 58 then return { s with expecting := true }
  if b == 44 then return { s with expecting := s.stack.head?.getD false }
  return s

def preflight (b : Bytes) : Bool := (b.foldlM scanByte {}).isSome

def need (p : Bool) (address reason : String) : Except String Unit :=
  if p then .ok () else .error (address ++ ": " ++ reason)

def fromOption (o : Option α) (e : String) : Except String α :=
  match o with
  | some a => .ok a
  | none => .error e

def shape (nodes : Array Node) : Nat → Nat → String → Except String (Term Nat × Nat)
  | 0, _, address => .error (address ++ ": source depth limit")
  | fuel + 1, index, address => do
    let node ← fromOption (nodes[index]?) (address ++ ": unknown source node")
    match node with
    | .sort s => pure (.leaf s, index + 1)
    | .pair l r =>
      let atNode := "record.source[" ++ toString index ++ "].pair"
      need (l == index + 1) (atNode ++ "[0]") "expected the next preorder place"
      let (left, next) ← shape nodes fuel l (atNode ++ "[0]")
      need (r == next) (atNode ++ "[1]") "expected the next preorder place"
      let (right, tail) ← shape nodes fuel r (atNode ++ "[1]")
      pure (.pair left right, tail)

def sorts (nodes : List Node) : Nat → Nat → Except String Unit
  | _, 0 => match nodes with
    | [] => .ok ()
    | _ => .error "record.source: sort resource limit"
  | next, fuel + 1 => match nodes with
    | [] => .ok ()
    | .pair _ _ :: rest => sorts rest next fuel
    | .sort s :: rest => do
      need (s ≤ next) "record.source.sort" "noncanonical first-occurrence sort number"
      sorts rest (if s == next then next + 1 else next) fuel

def lexLess : Path → Path → Bool
  | [], [] => false
  | [], _ :: _ => true
  | _ :: _, [] => false
  | a :: as, b :: bs => if a == b then lexLess as bs else !a && b

def orderedEdges : List Edge → Bool
  | [] => true
  | [_] => true
  | a :: b :: rest => lexLess a.address b.address && orderedEdges (b :: rest)

def leaf (s : Term Nat) (p : Path) (address : String) : Except String Unit := do
  need (p.length < depthLimit) address "address depth limit"
  need (s.lookup p).isSome address "unknown or nonleaf source address"

def view (s : Term Nat) : Term Path → String → Except String Unit
  | .leaf p, address => leaf s p (address ++ ".place")
  | .pair l r, address => do
      view s l (address ++ ".pair[0]")
      view s r (address ++ ".pair[1]")

def validate (w : Raw) (s : Term Nat) : Except String Unit := do
  sorts w.source 0 (w.source.length + 1)
  need (orderedEdges w.edges)
    "record.equalities" "noncanonical or repeated E-edge address"
  for (e, n) in w.edges.zipIdx do
    let address := "record.equalities[" ++ toString n ++ "]"
    need (e.address.length < depthLimit) (address ++ ".at") "address depth limit"
    leaf s e.left (address ++ ".left")
    leaf s e.right (address ++ ".right")
    need (s.lookup e.left == s.lookup e.right) address "equality endpoints have different sorts"
  view s w.observation "record.observation"
  view s w.question "record.question"

def admit (w : Raw) : Except String Model :=
  match need (!w.source.isEmpty && w.source.length ≤ sourceLimit)
      "record.source" "expected a nonempty bounded tree" with
  | .error e => .error e
  | .ok _ => match shape w.source.toArray depthLimit 0 "record.source[0]" with
    | .error e => .error e
    | .ok (s, next) =>
      if next != w.source.length then .error "record.source: unreachable source node"
      else match validate w s with
        | .error e => .error e
        | .ok _ => .ok ⟨s, w.observation, w.question, w.edges⟩

/-- Admitted canonical syntax, not an arbitrary Model or stored byte string.
The finite admission conditions and resource bounds are executable fields. -/
def admissible (w : Raw) : Bool :=
  (rawEmit w).length ≤ byteLimit && preflight (rawEmit w) && (admit w).isOk

abbrev World := { w : Raw // admissible w = true }

def World.model (w : World) : Model :=
  match h : admit w.val with
  | .ok m => m
  | .error _ => False.elim (by
      have hw := w.property
      simp [admissible, h, Except.isOk, Except.toBool] at hw)

theorem World.admit_model (w : World) : admit w.val = .ok w.model := by
  unfold World.model
  split
  · assumption
  · have hw := w.property
    simp_all [admissible, Except.isOk, Except.toBool]

def write (w : World) : Bytes := rawEmit w.val

def read (b : Bytes) : Except String World :=
  if b.length > byteLimit then .error "record: input byte limit"
  else if preflight b != true then .error "record: JSON depth or value limit; no impossibility inferred"
  else match rawParse b with
  | .error e => .error e
  | .ok (w, tail) =>
    if !tail.isEmpty then .error "record: trailing input"
    else match admit w with
    | .error e => .error e
    | .ok _ =>
      if h : admissible w = true then
        if rawEmit w == b then .ok ⟨w, h⟩
        else .error "record: noncanonical serialization"
      else .error "record: admission resource limit"

theorem read_write (w : World) : read (write w) = .ok w := by
  have h := w.property
  simp only [admissible, Bool.and_eq_true_iff, decide_eq_true_eq] at h
  have hr := raw_parse_write w.val []
  simp only [List.append_nil] at hr
  have ha : ∃ m, admit w.val = .ok m := by
    cases he : admit w.val with
    | error e => simp [he, Except.isOk, Except.toBool] at h
    | ok m => exact ⟨m, rfl⟩
  obtain ⟨m, hm⟩ := ha
  simp [read, write, Nat.not_lt_of_ge h.1.1, h.1.2, hr, hm, w.property]

theorem write_read {b : Bytes} {w : World} (h : read b = .ok w) : write w = b := by
  unfold read at h
  repeat' (split at h)
  all_goals simp_all [write, beq_iff_eq]
  subst w
  assumption

theorem write_injective : Function.Injective write := by
  intro a b h
  have := congrArg read h
  simpa only [read_write, Except.ok.injEq] using this

end Record
