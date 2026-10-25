import U5.Model

namespace U5

structure Step where
  edge : Path
  reversed : Bool
  deriving DecidableEq, Repr

inductive Basis where
  | address
  | sourceRelation : List Step → Basis
  | observedValues
  deriving DecidableEq, Repr

/-- Replay the supplied path; no equivalence-closure search. -/
def walk (edges : List Edge) (origin : Path) : List Step → Option Path
  | [] => some origin
  | s :: rest => do
    let e ← edges.find? (fun e => e.address == s.edge)
    let a := if s.reversed then e.right else e.left
    let b := if s.reversed then e.left else e.right
    if origin == a then walk edges b rest else none

def checkBasis (edges : List Edge) (origin dest : Path) : Basis → Bool
  | .address => origin == dest
  | .sourceRelation steps => !steps.isEmpty && walk edges origin steps == some dest
  | .observedValues => false

theorem walk_sound {edges : List Edge} {steps : List Step} {p q : Path}
    (h : walk edges p steps = some q) : Closure edges p q := by
  induction steps generalizing p with
  | nil => simp [walk] at h; subst q; exact .refl _
  | cons s rest ih =>
    simp only [walk] at h
    cases he : edges.find? (fun e => e.address == s.edge) with
    | none => simp [he] at h
    | some e =>
      have hem : e ∈ edges := List.mem_of_find?_eq_some he
      cases hb : s.reversed
      · simp [he, hb] at h
        rcases h with ⟨hp, hrest⟩
        subst p
        exact .trans (.edge hem) (ih hrest)
      · simp [he, hb] at h
        rcases h with ⟨hp, hrest⟩
        subst p
        exact .trans (.symm (.edge hem)) (ih hrest)

theorem basis_sound {edges : List Edge} {p q : Path} {b : Basis}
    (h : checkBasis edges p q b = true) : Closure edges p q := by
  cases b with
  | address => simp [checkBasis] at h; subst q; exact .refl _
  | sourceRelation steps =>
    simp only [checkBasis, Bool.and_eq_true_iff, beq_iff_eq] at h
    exact walk_sound h.2
  | observedValues => simp [checkBasis] at h

structure Selection where
  output : Path
  input : Path
  basis : Basis
  deriving DecidableEq, Repr

/-- Selections are a tree, in the independently specified Question shape.
The redundant output field is checked, not used dest choose the question. -/
def checkSelections (m : Model) (addr : Path) : Term Path → Term Selection → Bool
  | .leaf target, .leaf sel =>
    match m.observation.lookup sel.input with
    | none => false
    | some origin =>
      sel.output == addr && (m.source.lookup origin).isSome &&
      m.source.lookup origin == m.source.lookup target &&
      checkBasis m.edges origin target sel.basis
  | .pair ql qr, .pair sl sr =>
    checkSelections m (addr ++ [false]) ql sl && checkSelections m (addr ++ [true]) qr sr
  | _, _ => false

/-- U3 normal form: select input occurrences and assemble pairs. -/
def run (program : Term Path) (input : Term α) : Option (Term α) :=
  match program with
  | .leaf p => (input.lookup p).map Term.leaf
  | .pair l r => do
    let a ← run l input
    let b ← run r input
    pure (.pair a b)

/-- Rebuild the ordered selection list in the fixed Question shape; keep the
remainder so both missing and extra selections are rejected. -/
def packSelections : Term Path → List Selection → Option (Term Selection × List Selection)
  | .leaf _, [] => none
  | .leaf _, s :: rest => some (.leaf s, rest)
  | .pair l r, input => do
    let (sl, rest) ← packSelections l input
    let (sr, tail) ← packSelections r rest
    pure (.pair sl sr, tail)

theorem pack_consumes {q : Term Path} {input tail : List Selection} {sels : Term Selection}
    (h : packSelections q input = some (sels, tail)) : input = sels.values ++ tail := by
  induction q generalizing input tail sels with
  | leaf p =>
    cases input with
    | nil => simp [packSelections] at h
    | cons a rest =>
      simp [packSelections] at h
      obtain ⟨rfl, rfl⟩ := h
      rfl
  | pair l r ihl ihr =>
    cases hl : packSelections l input with
    | none => simp [packSelections, hl] at h
    | some v =>
      obtain ⟨sl, middle⟩ := v
      cases hr : packSelections r middle with
      | none => simp [packSelections, hl, hr] at h
      | some v =>
        obtain ⟨sr, suffix⟩ := v
        simp [packSelections, hl, hr] at h
        obtain ⟨rfl, rfl⟩ := h
        simp [Term.values, ihl hl, ihr hr, List.append_assoc]

structure Construction where
  selections : List Selection
  program : Term Path
  deriving DecidableEq, Repr

def checkConstruction (m : Model) (c : Construction) : Bool :=
  match packSelections m.question c.selections with
  | none => false
  | some (sels, rest) => rest.isEmpty && checkSelections m [] m.question sels &&
      c.program == sels.map Selection.input

theorem selections_sound (m : Model) {x : Path → α} (hx : Compatible m x)
    (q : Term Path) (sels : Term Selection) (addr : Path)
    (h : checkSelections m addr q sels = true) :
    run (sels.map Selection.input) (m.observation.map x) = some (q.map x) := by
  induction q generalizing sels addr with
  | leaf target =>
    cases sels with
    | pair l r => simp [checkSelections] at h
    | leaf sel =>
      cases hp : m.observation.lookup sel.input with
      | none => simp [checkSelections, hp] at h
      | some origin =>
        simp only [checkSelections, hp, Bool.and_eq_true_iff] at h
        have he := closure_sound hx (basis_sound h.2)
        simp [Term.map, run, hp, he]
  | pair ql qr ihl ihr =>
    cases sels with
    | leaf sel => simp [checkSelections] at h
    | pair sl sr =>
      simp only [checkSelections, Bool.and_eq_true_iff] at h
      simp [Term.map, run, ihl sl _ h.1, ihr sr _ h.2]

/-- U5 sufficiency, stronger than needed: typing is not used by equality replay. -/
theorem construction_sound {m : Model} {c : Construction}
    (hc : checkConstruction m c = true) {x : Path → α} (hx : Compatible m x) :
    run c.program (m.observation.map x) = some (m.question.map x) := by
  cases hp : packSelections m.question c.selections with
  | none => simp [checkConstruction, hp] at hc
  | some v =>
    obtain ⟨sels, rest⟩ := v
    simp only [checkConstruction, hp, Bool.and_eq_true_iff, beq_iff_eq] at hc
    rw [hc.2]
    exact selections_sound m hx _ _ _ hc.1.2

/-- Every selection in the accepted list is consumed, with no trailing entries. -/
theorem construction_full_input {m : Model} {c : Construction}
    (hc : checkConstruction m c = true) :
    ∃ sels, packSelections m.question c.selections = some (sels, []) ∧
      sels.values = c.selections := by
  cases hp : packSelections m.question c.selections with
  | none => simp [checkConstruction, hp] at hc
  | some v =>
    obtain ⟨sels, rest⟩ := v
    simp only [checkConstruction, hp, Bool.and_eq_true_iff] at hc
    have hr : rest = [] := List.isEmpty_iff.mp hc.1.1
    subst rest
    exact ⟨sels, rfl, by simpa using (pack_consumes hp).symm⟩

/-- The requested universal interpretation/filling form for a continuation. -/
theorem construction_interpretation_sound {m : Model} {c : Construction}
    (hc : checkConstruction m c = true) (i : Interpretation α) (x : Path → α)
    (hx : Gamma m i x) :
    run c.program (m.observation.map x) = some (m.question.map x) :=
  construction_sound hc hx.2

end U5
