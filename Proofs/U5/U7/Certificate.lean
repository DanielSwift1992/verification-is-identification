import U7.Actions
import U6.Retention

namespace U7
open U5

def checkPairs (test : α → β → Bool) : List α → List β → Bool
  | [], [] => true
  | a :: as, b :: bs => test a b && checkPairs test as bs
  | _, _ => false

theorem pairs_left {test : α → β → Bool} {as : List α} {bs : List β}
    (h : checkPairs test as bs = true) {a : α} (ha : a ∈ as) :
    ∃ b ∈ bs, test a b = true := by
  induction as generalizing bs with
  | nil => simp at ha
  | cons x xs ih =>
    cases bs with
    | nil => simp [checkPairs] at h
    | cons y ys =>
      have hh := Bool.and_eq_true_iff.mp h
      rcases List.mem_cons.mp ha with rfl | ha
      · exact ⟨y, by simp, hh.1⟩
      · obtain ⟨b, hb, ht⟩ := ih hh.2 ha
        exact ⟨b, List.mem_cons_of_mem _ hb, ht⟩

theorem pairs_right {test : α → β → Bool} {as : List α} {bs : List β}
    (h : checkPairs test as bs = true) {b : β} (hb : b ∈ bs) :
    ∃ a ∈ as, test a b = true := by
  induction bs generalizing as with
  | nil => simp at hb
  | cons y ys ih =>
    cases as with
    | nil => simp [checkPairs] at h
    | cons x xs =>
      have hh := Bool.and_eq_true_iff.mp h
      rcases List.mem_cons.mp hb with rfl | hb
      · exact ⟨x, by simp, hh.1⟩
      · obtain ⟨a, ha, ht⟩ := ih hh.2 hb
        exact ⟨a, List.mem_cons_of_mem _ ha, ht⟩

structure ReachableClass where
  block : Nat
  question : Path
  word : List Path
  basis : Basis
  deriving Repr

structure ImageAction where
  member : Path
  targets : List Nat
  construction : Construction
  deriving Repr

structure StableView where
  classes : List ReachableClass
  representatives : List Path
  view : Term Path
  actions : List ImageAction
  decoder : Construction
  deriving Repr

inductive Preservation where
  | preserved : List Basis → Preservation
  | notPreserved : Path → Preservation
  deriving Repr

structure ActionEvidence where
  member : Path
  preservation : Preservation
  deriving Repr

structure Certificate where
  classes : List PartitionClass
  connections : List (List Step)
  actions : List ActionEvidence
  stable : Option StableView
  deriving Repr

def cut (m : Model) (observation question : Term Path) : Model :=
  { m with observation := observation, question := question }

def checkReach (m : Model) (gs : List Action) (classes : List PartitionClass)
    (representative : Path) (w : ReachableClass) : Bool :=
  blockOf classes representative == some w.block &&
  match m.question.lookup w.question with
  | none => false
  | some origin => match pullWord gs w.word origin with
    | none => false
    | some dest => blockOf classes dest == some w.block &&
        checkBasis m.edges dest representative w.basis

def checkImage (m : Model) (classes : List PartitionClass) (s : StableView)
    (a : Action) (proof : ImageAction) : Bool :=
  proof.member == a.member &&
  checkPairs (fun representative target =>
    match s.representatives[target]? with
    | none => false
    | some dest => (blockOf classes dest).isSome &&
        blockOf classes dest == blockOf classes (pull a representative))
    s.representatives proof.targets &&
  checkConstruction (cut m s.view (s.view.map (pull a))) proof.construction

def checkStable (m : Model) (gs : List Action) (classes : List PartitionClass)
    (s : StableView) : Bool :=
  decide (s.representatives.length ≤ classes.length) &&
  decide (s.classes.map ReachableClass.block).Nodup &&
  checkPairs (checkReach m gs classes) s.representatives s.classes &&
  m.question.values.all (fun p => s.classes.any (fun c =>
    blockOf classes p == some c.block && c.word.isEmpty)) &&
  U6.balanced s.view && s.view.values == s.representatives &&
  checkPairs (checkImage m classes s) gs s.actions &&
  checkConstruction (cut m s.view m.question) s.decoder

/-- A negative edge is checked by exactly U5's partition-separation criterion.
Its synthetic P and Q are the two pulled-back endpoints. -/
def checkRefusal (m : Model) (classes : List PartitionClass) (a : Action)
    (address : Path) : Bool :=
  match m.edges.find? (fun e => e.address == address) with
  | none => false
  | some e => checkObstruction
      (cut m (.leaf (pull a e.left)) (.leaf (pull a e.right))) ⟨[], classes⟩

def checkEvidence (m : Model) (classes : List PartitionClass)
    (a : Action) (e : ActionEvidence) : Bool :=
  e.member == a.member && match e.preservation with
  | .preserved bases => checkEdges m a m.edges bases
  | .notPreserved edge => checkRefusal m classes a edge

def evidenceHolds (es : List ActionEvidence) : Bool :=
  es.all (fun e => match e.preservation with | .preserved _ => true | _ => false)

def check (m : Model) (gs : List Action) (c : Certificate) : Bool :=
  m.valid && gs.all (checkAction m) && decide (gs.map Action.member).Nodup &&
  checkPartition m c.classes && U6.checkForests m c.classes c.connections &&
  checkPairs (checkEvidence m c.classes) gs c.actions &&
  match c.stable with
  | some s => evidenceHolds c.actions && checkStable m gs c.classes s
  | none => !evidenceHolds c.actions

theorem evidence_preserves {m : Model} {classes : List PartitionClass}
    {gs : List Action} {es : List ActionEvidence}
    (hc : checkPairs (checkEvidence m classes) gs es = true)
    (hh : evidenceHolds es = true) : ∀ a ∈ gs, Preserves m a := by
  intro a ha
  obtain ⟨e, he, ht⟩ := pairs_left hc ha
  have hp := (List.all_eq_true.mp hh) e he
  cases hr : e.preservation with
  | notPreserved p => simp [hr] at hp
  | preserved bases =>
    simp [checkEvidence, hr] at ht
    exact edges_sound ht.2

theorem stable_view_values {m : Model} {gs : List Action}
    {cs : List PartitionClass} {s : StableView} (h : checkStable m gs cs s = true) :
    s.view.values = s.representatives := by
  simp only [checkStable, Bool.and_eq_true_iff, beq_iff_eq] at h
  exact h.1.1.2

theorem stable_reaches {m : Model} {gs : List Action}
    {cs : List PartitionClass} {s : StableView} (h : checkStable m gs cs s = true) :
    checkPairs (checkReach m gs cs) s.representatives s.classes = true := by
  simp only [checkStable, Bool.and_eq_true_iff] at h
  exact h.1.1.1.1.1.2

theorem stable_images {m : Model} {gs : List Action}
    {cs : List PartitionClass} {s : StableView} (h : checkStable m gs cs s = true) :
    checkPairs (checkImage m cs s) gs s.actions = true := by
  exact (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp h).1).2

theorem stable_decoder {m : Model} {gs : List Action}
    {cs : List PartitionClass} {s : StableView} (h : checkStable m gs cs s = true) :
    checkConstruction (cut m s.view m.question) s.decoder = true :=
  (Bool.and_eq_true_iff.mp h).2

theorem image_construction {m : Model} {cs : List PartitionClass} {s : StableView}
    {a : Action} {proof : ImageAction} (h : checkImage m cs s a proof = true) :
    checkConstruction (cut m s.view (s.view.map (pull a))) proof.construction = true :=
  (Bool.and_eq_true_iff.mp h).2

end U7
