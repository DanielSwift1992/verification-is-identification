import Record.Extended.Schema
import Record.Actions.Admission
import U9.Certificate

namespace Record.Extended
open U5
attribute [local simp] Bind.bind Pure.pure Functor.map Except.bind Except.pure Except.map

def sourceRaw (w : ImageRaw) : Record.Raw := ⟨w.base.source,w.base.edges,w.image,w.image⟩

def validateEdges (shape : Term Nat) (es : List Edge) (key : String) : Except String Unit := do
  need (orderedEdges es) ("record." ++ key) "noncanonical or repeated edge address"
  for (e,n) in es.zipIdx do
    let location := "record." ++ key ++ "[" ++ toString n ++ "]"
    need (e.address.length < depthLimit) (location ++ ".at") "address depth limit"
    leaf shape e.left (location ++ ".left")
    leaf shape e.right (location ++ ".right")
    need (shape.lookup e.left == shape.lookup e.right) location "equality endpoints have different sorts"

/-- A member's boundary is the complete declared codomain, not Source's shape. -/
def validateTarget (source target : Term Nat) (a : Actions.Member) (location : String) : Except String Unit := do
  need (a.address.length < depthLimit) (location ++ ".at") "address depth limit"
  need (a.image.length == target.entries.length) (location ++ ".image") "expected one image for every output leaf"
  for ((p,(_,sort)),n) in (a.image.zip target.entries).zipIdx do
    let loc := location ++ ".image[" ++ toString n ++ "]"
    leaf source p loc
    need (source.lookup p == some sort) loc "image has a different output sort"

def convertTarget (source target : Term Nat) (a : Actions.Member) (location : String) : Except String U9.Member :=
  match validateTarget source target a location with
  | .error e => .error e
  | .ok _ => match Actions.pack target a.image with
    | none => .error (location ++ ".image: incomplete output")
    | some (image,rest) =>
      if rest.isEmpty then .ok ⟨a.address,image⟩ else .error (location ++ ".image: extra images")

def TargetDenotes (target : Term Nat) (a : Actions.Member) (g : U9.Member) : Prop :=
  a.address = g.address ∧ Actions.pack target a.image = some (g.image,[])

theorem target_flat {target : Term Nat} {a : Actions.Member} {g : U9.Member}
    (h : TargetDenotes target a g) :
    a.address = g.address ∧ a.image = g.image.values ∧
      g.image.map (fun _ => 0) = target.map (fun _ => 0) := by
  obtain ⟨hp,hs⟩ := Actions.pack_sound h.2
  exact ⟨h.1,by simpa using hp,hs⟩

theorem convert_target_denotes {source target : Term Nat} {a : Actions.Member} {location : String} {g : U9.Member}
    (h : convertTarget source target a location = .ok g) : TargetDenotes target a g := by
  cases hv : validateTarget source target a location with
  | error e => simp [convertTarget,hv] at h
  | ok u =>
    cases hp : Actions.pack target a.image with
    | none => simp [convertTarget,hv,hp] at h
    | some pair =>
      rcases pair with ⟨image,rest⟩
      by_cases hr : rest.isEmpty = true
      · have he : rest = [] := List.isEmpty_iff.mp hr
        subst rest
        simp [convertTarget,hv,hp] at h
        subst g
        exact ⟨rfl,hp⟩
      · simp [convertTarget,hv,hp,hr] at h

def targetMembers (source target : Term Nat) : List Actions.Member → Nat → Except String (List U9.Member)
  | [],_ => .ok []
  | a::as,n => do
    let g ← convertTarget source target a (Actions.memberAddress "hiddenActions" n)
    let gs ← targetMembers source target as (n+1)
    pure (g::gs)

theorem target_members_denote {source target : Term Nat} {as : List Actions.Member} {n : Nat} {gs : List U9.Member}
    (h : targetMembers source target as n = .ok gs) : Actions.Corresponds (TargetDenotes target) as gs := by
  induction as generalizing n gs with
  | nil => simp [targetMembers] at h; subst gs; exact .nil
  | cons a as ih =>
    cases ha : convertTarget source target a (Actions.memberAddress "hiddenActions" n) with
    | error e => simp [targetMembers,ha] at h
    | ok g =>
      cases ht : targetMembers source target as (n+1) with
      | error e => simp [targetMembers,ha,ht] at h
      | ok rest =>
        simp [targetMembers,ha,ht] at h
        subst gs
        exact .cons (convert_target_denotes ha) (ih ht)

def imageMembers (w : ImageRaw) (m : Model) : Except String (List U9.Member) := do
  match w.hidden with
  | none => pure [⟨[],w.image⟩]
  | some hs => do
    need (!hs.isEmpty && Actions.ordered hs) "record.hiddenActions" "expected a nonempty ordered family"
    let gs ← targetMembers m.source (U9.output m w.image) hs 0
    need (gs.any (fun g => g.image == w.image)) "record.image" "image is not a hiddenActions member"
    pure gs

structure ImageEnvironment where
  model : Model
  members : List U9.Member
  promise : List Edge

def admitImage (w : ImageRaw) : Except String ImageEnvironment :=
  match Record.admit (sourceRaw w) with
  | .error e => .error ((e.replace "record.observation" "record.image").replace "record.question" "record.image")
  | .ok m => match validateEdges (U9.output m w.image) (w.promise.getD []) "promise" with
    | .error e => .error e
    | .ok _ => match imageMembers w m with
      | .error e => .error e
      | .ok members => .ok ⟨m,members,w.promise.getD []⟩

def ImageDenotes (w : ImageRaw) (e : ImageEnvironment) : Prop :=
  Record.Denotes (sourceRaw w) e.model ∧ e.promise = w.promise.getD [] ∧
  match w.hidden with
  | none => e.members = [⟨[],w.image⟩]
  | some hs => Actions.Corresponds (TargetDenotes (U9.output e.model w.image)) hs e.members ∧
      ∃ g ∈ e.members, g.image = w.image

theorem image_members_denote {w : ImageRaw} {m : Model} {gs : List U9.Member}
    (h : imageMembers w m = .ok gs) :
    match w.hidden with
    | none => gs = [⟨[],w.image⟩]
    | some hs => Actions.Corresponds (TargetDenotes (U9.output m w.image)) hs gs := by
  unfold imageMembers at h
  cases hh : w.hidden with
  | none => simpa [hh] using h.symm
  | some hs =>
    cases hn : need (!hs.isEmpty && Actions.ordered hs) "record.hiddenActions" "expected a nonempty ordered family" with
    | error e => simp [hh,hn] at h
    | ok u =>
      cases hg : targetMembers m.source (U9.output m w.image) hs 0 with
      | error e => simp [hh,hn,hg] at h
      | ok members =>
        cases hm : need (members.any (fun g => g.image == w.image)) "record.image" "image is not a hiddenActions member" with
        | error e => simp [hh,hn,hg,hm] at h
        | ok u =>
          simp [hh,hn,hg,hm] at h
          subst gs
          exact target_members_denote hg

/-- Successful admission retains the declared Image as a member, not only
the shape and origins of the other hidden choices. -/
theorem image_members_include_image {w : ImageRaw} {m : Model} {gs : List U9.Member}
    (h : imageMembers w m = .ok gs) : ∃ g ∈ gs, g.image = w.image := by
  unfold imageMembers at h
  cases hh : w.hidden with
  | none =>
    simp [hh] at h
    subst gs
    exact ⟨⟨[],w.image⟩,by simp,rfl⟩
  | some hs =>
    cases hn : need (!hs.isEmpty && Actions.ordered hs) "record.hiddenActions" "expected a nonempty ordered family" with
    | error e => simp [hh,hn] at h
    | ok u =>
      cases hg : targetMembers m.source (U9.output m w.image) hs 0 with
      | error e => simp [hh,hn,hg] at h
      | ok members =>
        cases hm : need (members.any (fun g => g.image == w.image)) "record.image" "image is not a hiddenActions member" with
        | error e => simp [hh,hn,hg,hm] at h
        | ok u =>
          simp [hh,hn,hg,hm] at h
          subst gs
          have ha : members.any (fun g => g.image == w.image) = true := by
            cases hb : members.any (fun g => g.image == w.image) with
            | false => simp [need,hb] at hm
            | true => rfl
          simpa only [List.any_eq_true,beq_iff_eq] using ha

theorem admit_image_denotes {w : ImageRaw} {e : ImageEnvironment}
    (h : admitImage w = .ok e) : ImageDenotes w e := by
  cases hm : Record.admit (sourceRaw w) with
  | error err => simp [admitImage,hm] at h
  | ok m =>
    cases hv : validateEdges (U9.output m w.image) (w.promise.getD []) "promise" with
    | error err => simp [admitImage,hm,hv] at h
    | ok u =>
      cases hg : imageMembers w m with
      | error err => simp [admitImage,hm,hv,hg] at h
      | ok gs =>
        simp [admitImage,hm,hv,hg] at h
        subst e
        refine ⟨Record.admit_denotes hm,rfl,?_⟩
        cases hh : w.hidden with
        | none => simpa [hh] using image_members_denote hg
        | some hs =>
          exact ⟨by simpa [hh] using image_members_denote hg,image_members_include_image hg⟩
end Record.Extended
