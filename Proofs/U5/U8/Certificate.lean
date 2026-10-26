import U8.Characterization

namespace U8
open U5 U7

inductive HiddenConclusion where
  | common (images : List ImageAction) (program : Term Path)
  | outside (member observation image : Path)
  | disagreement (left right observation leftImage rightImage : Path)
  deriving Repr

structure HiddenJudgment where
  classes : List Nat
  conclusion : HiddenConclusion
  closureInheritedFromStableView : Bool
  deriving Repr

/-- The existing U7 certificate carries the shared exact partition and forests.
The hidden family's preservation is independent of the visible family's. -/
structure Certificate where
  visible : U7.Certificate
  hiddenActions : List ActionEvidence
  hidden : Option HiddenJudgment
  deriving Repr

inductive Verdict where
  | preservation | common | outside | disagreement
  deriving DecidableEq, Repr

def verdict (c : Certificate) : Verdict :=
  match c.hidden with
  | none => .preservation
  | some h => match h.conclusion with
    | .common .. => .common
    | .outside .. => .outside
    | .disagreement .. => .disagreement

def observedClasses (m : Model) (cs : List PartitionClass) : List Nat :=
  (m.observation.values.filterMap (blockOf cs)).eraseDups

def inherited (m : Model) (gs hs : List Action) (visible : U7.Certificate) : Bool :=
  match visible.stable with
  | none => false
  | some stable =>
    stable.view.map (blockOf visible.classes) == m.observation.map (blockOf visible.classes) &&
    hs.all (fun h => gs.any (fun g => h.image == g.image))

def checkImage (m : Model) (cs : List PartitionClass) (classes : List Nat)
    (a : Action) (image : ImageAction) : Bool :=
  image.member == a.member &&
  checkPairs (fun block target =>
    match cs[block]?, classes[target]? with
    | some c, some dest => match c.leaves with
      | [] => false
      | root :: _ => blockOf cs (pull a root) == some dest
    | _, _ => false) classes image.targets &&
  checkConstruction (cut m m.observation (m.observation.map (pull a))) image.construction

def checkCommon (m : Model) (hs : List Action) (cs : List PartitionClass)
    (classes : List Nat) (images : List ImageAction) (program : Term Path) : Bool :=
  checkPairs (fun a image => checkImage m cs classes a image &&
    image.construction.program == program) hs images &&
  match images with
  | [] => false
  | first :: rest => rest.all (fun image => image.targets == first.targets)

def checkOutside (m : Model) (hs : List Action) (cs : List PartitionClass)
    (member observation image : Path) : Bool :=
  match hs.find? (fun a => a.member == member), m.observation.lookup observation with
  | some a, some origin => pull a origin == image &&
      checkObstruction (cut m m.observation (.leaf image)) ⟨[], cs⟩
  | _, _ => false

def checkDisagreement (m : Model) (hs : List Action) (cs : List PartitionClass)
    (left right observation leftImage rightImage : Path) : Bool :=
  match hs.find? (fun a => a.member == left), hs.find? (fun a => a.member == right),
      m.observation.lookup observation with
  | some a, some b, some origin =>
      pull a origin == leftImage && pull b origin == rightImage &&
      blockOf cs leftImage != blockOf cs rightImage &&
      (m.source.lookup leftImage).isSome && m.source.lookup leftImage == m.source.lookup rightImage
  | _, _, _ => false

def checkHidden (m : Model) (gs hs : List Action) (visible : U7.Certificate)
    (h : HiddenJudgment) : Bool :=
  h.classes == observedClasses m visible.classes &&
  h.closureInheritedFromStableView == inherited m gs hs visible &&
  match h.conclusion with
  | .common images program => checkCommon m hs visible.classes h.classes images program
  | .outside member observation image => !h.closureInheritedFromStableView &&
      checkOutside m hs visible.classes member observation image
  | .disagreement left right observation leftImage rightImage =>
      checkDisagreement m hs visible.classes left right observation leftImage rightImage

def check (m : Model) (gs hs : List Action) (c : Certificate) : Bool :=
  U7.check m gs c.visible && !hs.isEmpty && hs.all (checkAction m) &&
  decide (hs.map Action.member).Nodup &&
  checkPairs (checkEvidence m c.visible.classes) hs c.hiddenActions &&
  match c.hidden with
  | none => !evidenceHolds c.hiddenActions
  | some h => evidenceHolds c.hiddenActions && checkHidden m gs hs c.visible h

theorem image_sound {m : Model} {cs : List PartitionClass} {classes : List Nat}
    {a : Action} {image : ImageAction} (h : checkImage m cs classes a image = true)
    (i : Interpretation α) (x : Path → α) (hx : Gamma m i x) :
    run image.construction.program (m.observation.map x) = some (m.observation.map (act a x)) := by
  have hc := (Bool.and_eq_true_iff.mp h).2
  have hi := construction_sound hc hx.2
  change run image.construction.program (m.observation.map x) = some (m.observation.map (fun p => x (pull a p)))
  simpa only [cut, U7.map_map] using hi

theorem common_sound {m : Model} {hs : List Action} {cs : List PartitionClass}
    {classes : List Nat} {images : List ImageAction} {program : Term Path}
    (h : checkCommon m hs cs classes images program = true) :
    ∀ (α : Type) (i : Interpretation α) (x : Path → α), Gamma m i x → ∀ a ∈ hs,
      run program (m.observation.map x) = some (m.observation.map (act a x)) := by
  intro α i x hx a ha
  obtain ⟨image, _, hi⟩ := pairs_left (Bool.and_eq_true_iff.mp h).1 ha
  have hh := Bool.and_eq_true_iff.mp hi
  have heq : image.construction.program = program := by simpa using hh.2
  rw [← heq]
  exact image_sound hh.1 i x hx

end U8
