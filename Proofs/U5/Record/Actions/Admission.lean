import Record.Actions.Schema
import Record.Admission
import Record.Semantics
import U7.Actions

namespace Record.Actions
attribute [local simp] Bind.bind Pure.pure Functor.map Except.bind Except.pure Except.map
open U5

/-- The flat list is consumed in Source preorder; no names or search occur. -/
def pack : Term Nat → List Path → Option (Term Path × List Path)
  | .leaf _, [] => none
  | .leaf _, p :: ps => some (.leaf p, ps)
  | .pair l r, ps => do
      let (a, rest) ← pack l ps
      let (b, tail) ← pack r rest
      pure (.pair a b, tail)

theorem pack_sound {s : Term Nat} {ps : List Path} {image : Term Path} {rest : List Path}
    (h : pack s ps = some (image, rest)) :
    ps = image.values ++ rest ∧ image.map (fun _ => 0) = s.map (fun _ => 0) := by
  induction s generalizing ps image rest with
  | leaf sort =>
    cases ps with
    | nil => simp [pack] at h
    | cons p ps =>
      simp [pack] at h
      rcases h with ⟨rfl, rfl⟩
      simp [Term.values, Term.map]
  | pair l r ihl ihr =>
    cases hl : pack l ps with
    | none => simp [pack, hl] at h
    | some left =>
      rcases left with ⟨a, tail⟩
      cases hr : pack r tail with
      | none => simp [pack, hl, hr] at h
      | some right =>
        rcases right with ⟨b, more⟩
        simp [pack, hl, hr] at h
        rcases h with ⟨rfl, rfl⟩
        obtain ⟨hp, ha⟩ := ihl hl
        obtain ⟨ht, hb⟩ := ihr hr
        exact ⟨by simp [hp, ht, Term.values, List.append_assoc], by simp [Term.map, ha, hb]⟩

def validateMember (m : Model) (a : Member) (address : String) : Except String Unit := do
  need (a.address.length < depthLimit) (address ++ ".at") "address depth limit"
  need (a.image.length == m.source.entries.length) (address ++ ".image") "expected one image for every Source leaf"
  for ((p, (_, sort)), n) in (a.image.zip m.source.entries).zipIdx do
    let loc := address ++ ".image[" ++ toString n ++ "]"
    leaf m.source p loc
    need (m.source.lookup p == some sort) loc "image has a different source sort"

def convert (m : Model) (a : Member) (address : String) : Except String U7.Action :=
  match validateMember m a address with
  | .error e => .error e
  | .ok _ => match pack m.source a.image with
    | none => .error (address ++ ".image: incomplete Source image")
    | some (image, rest) =>
      if rest.isEmpty then .ok ⟨a.address, image⟩
      else .error (address ++ ".image: extra images")

def MemberDenotes (s : Term Nat) (a : Member) (g : U7.Action) : Prop :=
  a.address = g.member ∧ pack s a.image = some (g.image, [])

theorem MemberDenotes.flat {s : Term Nat} {a : Member} {g : U7.Action}
    (h : MemberDenotes s a g) : a.address = g.member ∧
    a.image = g.image.values ∧ g.image.map (fun _ => 0) = s.map (fun _ => 0) := by
  obtain ⟨hp, hs⟩ := pack_sound h.2
  exact ⟨h.1, by simpa using hp, hs⟩

theorem convert_denotes {m : Model} {a : Member} {address : String} {g : U7.Action}
    (h : convert m a address = .ok g) : MemberDenotes m.source a g := by
  cases hv : validateMember m a address with
  | error e => simp [convert, hv] at h
  | ok u =>
    cases hp : pack m.source a.image with
    | none => simp [convert, hv, hp] at h
    | some pair =>
      rcases pair with ⟨image, rest⟩
      by_cases hr : rest.isEmpty = true
      · have he : rest = [] := List.isEmpty_iff.mp hr
        subst rest
        simp [convert, hv, hp] at h
        subst g
        exact ⟨rfl, hp⟩
      · simp [convert, hv, hp, hr] at h

inductive Corresponds (r : α → β → Prop) : List α → List β → Prop
  | nil : Corresponds r [] []
  | cons {a b as bs} : r a b → Corresponds r as bs → Corresponds r (a :: as) (b :: bs)


def ordered : List Member → Bool
  | [] => true
  | [_] => true
  | a :: b :: rest => lexLess a.address b.address && ordered (b :: rest)

def memberAddress (key : String) (n : Nat) : String :=
  "record." ++ key ++ "[" ++ toString n ++ "]"

def members (m : Model) (key : String) : List Member → Nat → Except String (List U7.Action)
  | [], _ => .ok []
  | a :: rest, n => do
      let g ← convert m a (memberAddress key n)
      let gs ← members m key rest (n + 1)
      pure (g :: gs)

theorem members_denote {m : Model} {key : String} {as : List Member} {n : Nat}
    {gs : List U7.Action} (h : members m key as n = .ok gs) :
    Corresponds (MemberDenotes m.source) as gs := by
  induction as generalizing n gs with
  | nil =>
    simp [members] at h
    subst gs
    exact .nil
  | cons a as ih =>
    cases ha : convert m a (memberAddress key n) with
    | error e => simp [members, ha] at h
    | ok g =>
      cases ht : members m key as (n + 1) with
      | error e => simp [members, ha, ht] at h
      | ok rest =>
        simp [members, ha, ht] at h
        subst gs
        exact .cons (convert_denotes ha) (ih ht)

structure Environment where
  model : Model
  actions : List U7.Action
  hiddenActions : Option (List U7.Action)

def family (m : Model) (key : String) (as : List Member) : Except String (List U7.Action) := do
  need (ordered as) ("record." ++ key) "noncanonical or repeated member address"
  members m key as 0

def admit (w : Raw) : Except String Environment := do
  let m ← Record.admit w.base
  let gs ← family m "actions" (w.actions.getD [])
  let hs ← match w.hiddenActions with
    | none => pure none
    | some hs => do
        need (!hs.isEmpty) "record.hiddenActions" "hiddenActions must be nonempty"
        let hs ← family m "hiddenActions" hs
        pure (some hs)
  pure ⟨m, gs, hs⟩

def Denotes (w : Raw) (e : Environment) : Prop :=
  Record.Denotes w.base e.model ∧
  Corresponds (MemberDenotes e.model.source) (w.actions.getD []) e.actions ∧
  match w.hiddenActions, e.hiddenActions with
  | none, none => True
  | some as, some gs => Corresponds (MemberDenotes e.model.source) as gs
  | _, _ => False

theorem family_denotes {m : Model} {key : String} {as : List Member} {gs : List U7.Action}
    (h : family m key as = .ok gs) : Corresponds (MemberDenotes m.source) as gs := by
  unfold family at h
  cases hn : need (ordered as) ("record." ++ key) "noncanonical or repeated member address" with
  | error e => simp [hn] at h
  | ok u => exact members_denote (by simpa [hn] using h)

theorem admit_denotes {w : Raw} {e : Environment} (h : admit w = .ok e) : Denotes w e := by
  unfold admit at h
  cases hm : Record.admit w.base with
  | error err => simp [hm] at h
  | ok m =>
    cases hg : family m "actions" (w.actions.getD []) with
    | error err => simp [hm, hg] at h
    | ok gs =>
      cases hh : w.hiddenActions with
      | none =>
        simp [hm, hg, hh] at h
        subst e
        exact ⟨Record.admit_denotes hm, family_denotes hg, by simp [hh]⟩
      | some hs =>
        cases hn : need (!hs.isEmpty) "record.hiddenActions" "hiddenActions must be nonempty" with
        | error err => simp [hm, hg, hh, hn] at h
        | ok u =>
          cases hf : family m "hiddenActions" hs with
          | error err => simp [hm, hg, hh, hn, hf] at h
          | ok ts =>
            simp [hm, hg, hh, hn, hf] at h
            subst e
            exact ⟨Record.admit_denotes hm, family_denotes hg, by simpa [hh] using family_denotes hf⟩

def admissible (w : Raw) : Bool :=
  (rawEmit w).length ≤ byteLimit && preflight (rawEmit w) && (admit w).isOk

abbrev World := { w : Raw // admissible w = true }

def World.environment (w : World) : Environment :=
  match h : admit w.val with
  | .ok e => e
  | .error _ => False.elim (by
      have hw := w.property
      simp [admissible, h, Except.isOk, Except.toBool] at hw)

theorem World.admit_environment (w : World) : admit w.val = .ok w.environment := by
  unfold World.environment
  split
  · assumption
  · have hw := w.property
    simp_all [admissible, Except.isOk, Except.toBool]

theorem World.denotes (w : World) : Denotes w.val w.environment :=
  admit_denotes w.admit_environment

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
  have ha : ∃ e, admit w.val = .ok e := by
    cases he : admit w.val with
    | error e => simp [he, Except.isOk, Except.toBool] at h
    | ok e => exact ⟨e, rfl⟩
  obtain ⟨e, he⟩ := ha
  simp [read, write, Nat.not_lt_of_ge h.1.1, h.1.2, hr, he, w.property]

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

end Record.Actions
