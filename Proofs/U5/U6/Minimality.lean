import U6.Retention

namespace U6
open U5

/-- Adequacy on the Boolean interpretation allows any deterministic decoder,
not necessarily one written in the structural grammar. -/
def BitAdequate (m : Model) (d : Term Path) : Prop :=
  ∃ f : Term Bool → Term Bool, ∀ x, Gamma m bits x →
    f ((joint m d).observation.map x) = m.question.map x

theorem universal_has_bit_decoder {m : Model} {d : Term Path}
    (h : UniversalContinuation (joint m d)) : BitAdequate m d := by
  obtain ⟨program, hp⟩ := h
  refine ⟨fun input => (run program input).getD (.leaf false), ?_⟩
  intro x hx
  dsimp only
  rw [hp Bool bits x hx]
  rfl

/-- Every adequate structural D must contain every missing class. Already
one Boolean interpretation forces this; no structural decoder is assumed. -/
theorem decoder_covers_missing {m : Model} {classes : List PartitionClass}
    (hp : checkPartition m classes = true) (d : Term Path)
    (adequate : BitAdequate m d) {b : Nat}
    (hb : b ∈ neededBlocks m classes) :
    some b ∈ d.values.map (blockOf classes) := by
  classical
  apply Classical.byContradiction
  intro missing
  obtain ⟨⟨q, hqm, hqb⟩, unobserved⟩ := needed_spec.mp hb
  obtain ⟨addr, haddr⟩ := lookup_of_mem_values hqm
  have hd : ∀ p ∈ d.values, blockOf classes p ≠ some b := by
    intro p hpm he
    exact missing (List.mem_map.mpr ⟨p, hpm, he⟩)
  have hjoint : ∀ p ∈ (joint m d).observation.values, blockOf classes p ≠ some b := by
    intro p hm
    rcases List.mem_append.mp hm with hobs | hret
    · exact unobserved p hobs
    · exact hd p hret
  have bad : checkObstruction (joint m d) ⟨addr, classes⟩ = true := by
    change checkPartition m classes &&
      (match m.question.lookup addr with
       | none => false
       | some target => match blockOf classes target with
         | none => false
         | some block => (joint m d).observation.values.all (fun p => blockOf classes p != some block)) = true
    simpa [hp, haddr, hqb, List.all_eq_true] using hjoint
  exact obstruction_no_decoder bad adequate

theorem adequate_covers_missing {m : Model} {classes : List PartitionClass}
    (hp : checkPartition m classes = true) (d : Term Path)
    (adequate : UniversalContinuation (joint m d)) {b : Nat}
    (hb : b ∈ neededBlocks m classes) : some b ∈ d.values.map (blockOf classes) :=
  decoder_covers_missing hp d (universal_has_bit_decoder adequate) hb

/-- Number of missing classes ≤ number of D's leaves, even if D repeats classes
or carries irrelevant classes. The bound is not a count of bits or bytes. -/
theorem semantic_lower_bound {m : Model} {classes : List PartitionClass} {r : Residue}
    (hr : checkResidue m classes r = true) (d : Term Path)
    (adequate : BitAdequate m d) :
    (neededBlocks m classes).length ≤ d.values.length := by
  simp only [checkResidue, Bool.and_eq_true_iff, decide_eq_true_eq] at hr
  have hn : ((neededBlocks m classes).map some).Nodup := by
    simpa only [List.Nodup, List.pairwise_map, ne_eq, Option.some.injEq] using hr.2
  have sub : (neededBlocks m classes).map some ⊆ d.values.map (blockOf classes) := by
    intro b hb
    obtain ⟨n, hn, rfl⟩ := List.mem_map.mp hb
    exact decoder_covers_missing hr.1.1.1 d adequate hn
  have bound := hn.length_le_of_subset sub
  simpa using bound

theorem structural_lower_bound {m : Model} {classes : List PartitionClass} {r : Residue}
    (hr : checkResidue m classes r = true) (d : Term Path)
    (adequate : UniversalContinuation (joint m d)) :
    (neededBlocks m classes).length ≤ d.values.length :=
  semantic_lower_bound hr d (universal_has_bit_decoder adequate)

/-- The checked retention attains the lower bound among ALL universally
adequate structural residual views, not only those supplied to this checker. -/
theorem retention_minimum {m : Model} {p : Plan}
    (h : checkPlan m p = true) (d : Term Path)
    (adequate : UniversalContinuation (joint m d)) :
    p.retention.view.values.length ≤ d.values.length := by
  rw [leaf_count_exact h]
  have parts := h
  simp only [checkPlan, Bool.and_eq_true_iff] at parts
  exact structural_lower_bound parts.1.1.2 d adequate

/-- Stronger leaf bound: arbitrary decoders on the Boolean interpretation. -/
theorem retention_semantic_minimum {m : Model} {p : Plan}
    (h : checkPlan m p = true) (d : Term Path) (adequate : BitAdequate m d) :
    p.retention.view.values.length ≤ d.values.length := by
  rw [leaf_count_exact h]
  have parts := h
  simp only [checkPlan, Bool.and_eq_true_iff] at parts
  exact semantic_lower_bound parts.1.1.2 d adequate

theorem fewer_leaves_impossible {m : Model} {p : Plan}
    (h : checkPlan m p = true) (d : Term Path)
    (smaller : d.values.length < p.retention.view.values.length) :
    ¬ UniversalContinuation (joint m d) := by
  intro adequate
  have bound := retention_minimum h d adequate
  omega

/-- For structural D the retained view even factors through D alone. The
relative theorem covers the larger class of nonstructural residuals. -/
theorem retained_covered_by_adequate {m : Model} {p : Plan}
    (h : checkPlan m p = true) (d : Term Path)
    (adequate : UniversalContinuation (joint m d)) : Covers m d p.retention.view := by
  simp only [checkPlan, Bool.and_eq_true_iff] at h
  have hr := h.1.2
  simp only [checkRetention, Bool.and_eq_true_iff, decide_eq_true_eq, beq_iff_eq] at hr
  have hs := h.1.1.2
  simp only [checkResidue, Bool.and_eq_true_iff] at hs
  intro a ha
  have ha' : a ∈ p.retention.leaves := hr.1.2 ▸ ha
  have hm := hr.1.1.mem_iff.mp (List.mem_map.mpr ⟨a, ha', rfl⟩)
  obtain ⟨b, hb, hba⟩ := List.mem_map.mp hm
  have existsD := adequate_covers_missing hs.1.1.1 d adequate hb
  obtain ⟨q, hq, hqb⟩ := List.mem_map.mp existsD
  obtain ⟨addr, had⟩ := lookup_of_mem_values hq
  exact ⟨addr, q, had, same_block_closure hs.1.1.2 hqb hba.symm⟩

theorem structural_factor_through_adequate {m : Model} {p : Plan}
    (h : checkPlan m p = true) (d : Term Path)
    (adequate : UniversalContinuation (joint m d)) :
    ∃ program : Term Path, ∀ (α : Type) (i : Interpretation α) (x : Path → α),
      Gamma m i x → run program (d.map x) = some (p.retention.view.map x) :=
  covers_factor (retained_covered_by_adequate h d adequate)

/-- Format 2's zero case counts zero missing classes; there is no residual term. -/
theorem zero_count_exact {m : Model} {c : Construction} {classes : List PartitionClass}
    (h : U6.check m (.zero c) = true) (hp : checkPartition m classes = true) :
    leafCount (.zero c) = (neededBlocks m classes).length := by
  have hc : checkConstruction m c = true := (Bool.and_eq_true_iff.mp h).2
  rw [zero_missing hc hp]
  rfl

end U6
