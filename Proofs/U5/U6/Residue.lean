import U6.Factor

namespace U6
open U5

structure RequiredClass where
  block : Nat
  questions : List Path
  deriving DecidableEq, Repr

structure Residue where
  connections : List (List Step)
  needed : List RequiredClass
  deriving DecidableEq, Repr

def observedBlocks (m : Model) (classes : List PartitionClass) : List Nat :=
  m.observation.values.filterMap (blockOf classes)

/-- Encounter order is Question order, with first occurrences retained. -/
def neededBlocks (m : Model) (classes : List PartitionClass) : List Nat :=
  ((m.question.values.filterMap (blockOf classes)).filter
    (fun b => !(observedBlocks m classes).contains b)).eraseDups

def requiredClasses (m : Model) (classes : List PartitionClass) : List RequiredClass :=
  (neededBlocks m classes).map fun b => ⟨b,
    m.question.entries.filterMap (fun (out, origin) =>
      if blockOf classes origin == some b then some out else none)⟩

def checkResidue (m : Model) (classes : List PartitionClass) (r : Residue) : Bool :=
  checkPartition m classes && checkForests m classes r.connections &&
  r.needed == requiredClasses m classes && decide (neededBlocks m classes).Nodup

@[simp] theorem needed_spec {m : Model} {classes : List PartitionClass} {b : Nat} :
    b ∈ neededBlocks m classes ↔
      (∃ p ∈ m.question.values, blockOf classes p = some b) ∧
      (∀ p ∈ m.observation.values, blockOf classes p ≠ some b) := by
  simp [neededBlocks, observedBlocks, List.mem_filterMap]

/-- filterMap in the finite list calculation drops no admitted cut occurrence. -/
theorem admitted_cuts_have_blocks {m : Model} {classes : List PartitionClass}
    (hm : m.valid = true) (hp : checkPartition m classes = true) :
    ∀ p ∈ m.observation.values ++ m.question.values, ∃ b, blockOf classes p = some b := by
  simp only [Model.valid, Bool.and_eq_true_iff, List.all_eq_true] at hm
  intro p hpm
  have hs := hm.1.1 p hpm
  cases hl : m.source.lookup p with
  | none => simp [hl] at hs
  | some s => exact partition_covers hp hl

/-- Distinct declared blocks really enumerate the absent E-classes of Question. -/
theorem missing_class_iff {m : Model} {classes : List PartitionClass} {r : Residue}
    (h : checkResidue m classes r = true) {p : Path} {b : Nat}
    (hp : p ∈ m.question.values) (hb : blockOf classes p = some b) :
    b ∈ neededBlocks m classes ↔
      ∀ a ∈ m.observation.values, ¬ Closure m.edges a p := by
  simp only [checkResidue, Bool.and_eq_true_iff] at h
  rw [needed_spec]
  constructor
  · intro hs a ha hc
    have he := closure_same_block h.1.1.1 hc
    exact hs.2 a ha (he.trans hb)
  · intro hs
    refine ⟨⟨p, hp, hb⟩, ?_⟩
    intro a ha hab
    exact hs a ha (same_block_closure h.1.1.2 hab hb)

/-- Every missing Question class has one declared block label; no class is
silently lost by finite normalization. Exactness above identifies its meaning. -/
theorem missing_classes_complete {m : Model} {classes : List PartitionClass} {r : Residue}
    (hm : m.valid = true) (hr : checkResidue m classes r = true) {q : Path}
    (hq : q ∈ m.question.values) :
    (∀ a ∈ m.observation.values, ¬ Closure m.edges a q) ↔
      ∃ b ∈ neededBlocks m classes, blockOf classes q = some b := by
  have hp := hr
  simp only [checkResidue, Bool.and_eq_true_iff] at hp
  obtain ⟨b, hb⟩ := admitted_cuts_have_blocks hm hp.1.1.1 q (List.mem_append_right _ hq)
  constructor
  · intro missing
    exact ⟨b, (missing_class_iff hr hq hb).mpr missing, hb⟩
  · rintro ⟨c, hc, hqc⟩
    exact (missing_class_iff hr hq hqc).mp hc

/-- The format-2 zero case has no missing class for any sound closed partition. -/
theorem zero_missing {m : Model} {c : Construction} {classes : List PartitionClass}
    (hc : checkConstruction m c = true) (hp : checkPartition m classes = true) :
    neededBlocks m classes = [] := by
  apply List.eq_nil_iff_forall_not_mem.mpr
  intro b hb
  obtain ⟨⟨p, hpm, hpb⟩, missing⟩ := needed_spec.mp hb
  obtain ⟨addr, origin, ho, he⟩ := construction_covers hc p hpm
  have hm := Term.mem_values_of_lookup ho
  exact missing origin hm ((closure_same_block hp he).trans hpb)

end U6
