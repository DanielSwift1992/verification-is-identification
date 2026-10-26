import U8.Certificate

namespace U8
open U5 U7

theorem checked_missing {m : Model} {view : Term Path} {target : Path}
    {cs : List PartitionClass}
    (h : checkObstruction (cut m view (.leaf target)) ⟨[], cs⟩ = true) :
    ¬ Held m view target := by
  have hh := Bool.and_eq_true_iff.mp h
  cases ht : blockOf cs target with
  | none => simp [cut, Term.lookup, ht] at hh
  | some block =>
    have hn : ∀ p ∈ view.values, blockOf cs p ≠ some block := by
      simpa [cut, Term.lookup, ht, List.all_eq_true] using hh.2
    rintro ⟨p, hp, he⟩
    exact hn p hp ((U6.closure_same_block hh.1 he).trans ht)

theorem outside_sound {m : Model} {hs : List Action} {cs : List PartitionClass}
    {member observation image : Path}
    (h : checkOutside m hs cs member observation image = true) :
    ¬ CommonAt m hs m.observation bits := by
  cases ha : hs.find? (fun a => a.member == member) with
  | none => simp [checkOutside, ha] at h
  | some a =>
    cases hp : m.observation.lookup observation with
    | none => simp [checkOutside, ha, hp] at h
    | some p =>
      simp only [checkOutside, ha, hp, Bool.and_eq_true_iff, beq_iff_eq] at h
      have hn := checked_missing h.2
      rw [← h.1] at hn
      exact outside_no_common (List.mem_of_find?_eq_some ha) (Term.mem_values_of_lookup hp) hn

theorem disagreement_sound {m : Model} {hs : List Action} {cs : List PartitionClass}
    (hc : checkPartition m cs = true) {left right observation leftImage rightImage : Path}
    (h : checkDisagreement m hs cs left right observation leftImage rightImage = true) :
    ¬ CommonAt m hs m.observation bits := by
  cases ha : hs.find? (fun a => a.member == left) with
  | none => simp [checkDisagreement, ha] at h
  | some a =>
    cases hb : hs.find? (fun a => a.member == right) with
    | none => simp [checkDisagreement, ha, hb] at h
    | some b =>
      cases hp : m.observation.lookup observation with
      | none => simp [checkDisagreement, ha, hb, hp] at h
      | some p =>
        simp only [checkDisagreement, ha, hb, hp, Bool.and_eq_true_iff, beq_iff_eq,
          bne_iff_ne] at h
        have hne : ¬ Closure m.edges (pull a p) (pull b p) := by
          intro he
          have same := U6.closure_same_block hc he
          rw [h.1.1.1.1, h.1.1.1.2] at same
          exact h.1.1.2 same
        exact disagreement_no_common (List.mem_of_find?_eq_some ha) (List.mem_of_find?_eq_some hb)
          (Term.mem_values_of_lookup hp) hne

theorem visible_checked {m : Model} {gs hs : List Action} {c : Certificate}
    (h : check m gs hs c = true) : U7.check m gs c.visible = true := by
  simp only [check, Bool.and_eq_true_iff] at h
  exact h.1.1.1.1.1

theorem partition_checked {m : Model} {gs hs : List Action} {c : Certificate}
    (h : check m gs hs c = true) : checkPartition m c.visible.classes = true := by
  have hv := visible_checked h
  simp only [U7.check, Bool.and_eq_true_iff] at hv
  exact hv.1.1.1.2

theorem hidden_parts {m : Model} {gs hs : List Action} {c : Certificate}
    {hidden : HiddenJudgment} (h : check m gs hs c = true) (hh : c.hidden = some hidden) :
    (∀ a ∈ hs, checkAction m a = true) ∧ (∀ a ∈ hs, Preserves m a) ∧
      checkHidden m gs hs c.visible hidden = true := by
  simp only [check, hh, Bool.and_eq_true_iff, List.all_eq_true] at h
  exact ⟨h.1.1.1.2, evidence_preserves h.1.2 h.2.1, h.2.2⟩

theorem hidden_gamma {m : Model} {gs hs : List Action} {c : Certificate}
    {hidden : HiddenJudgment} (h : check m gs hs c = true) (hh : c.hidden = some hidden)
    (i : Interpretation α) (x : Path → α) (hx : Gamma m i x) :
    ∀ a ∈ hs, Gamma m i (act a x) := by
  obtain ⟨hv, hp, _⟩ := hidden_parts h hh
  exact fun a ha => action_gamma (hv a ha) (hp a ha) hx

def HiddenClaim (m : Model) (hs : List Action) (h : HiddenJudgment)
    (_i : Interpretation α) (x : Path → α) : Prop :=
  match h.conclusion with
  | .common _ program => Conditions m hs m.observation ∧
      ∀ a ∈ hs, run program (m.observation.map x) = some (m.observation.map (act a x))
  | .outside .. | .disagreement .. => ¬ CommonAt m hs m.observation bits

def Claim (m : Model) (hs : List Action) (c : Certificate)
    (i : Interpretation α) (x : Path → α) : Prop :=
  match c.hidden with
  | none => ¬ ∀ (β : Type) (j : Interpretation β) (y : Path → β), Gamma m j y →
      ∀ a ∈ hs, Gamma m j (act a y)
  | some hidden => (∀ a ∈ hs, Gamma m i (act a x)) ∧ HiddenClaim m hs hidden i x

theorem check_sound {m : Model} {gs hs : List Action} {c : Certificate}
    (h : check m gs hs c = true) :
    ∀ (α : Type) (i : Interpretation α) (x : Path → α), Gamma m i x → Claim m hs c i x := by
  intro α i x hx
  cases hh : c.hidden with
  | none =>
    have hc := h
    simp only [check, hh, Bool.and_eq_true_iff, Bool.not_eq_true'] at hc
    obtain ⟨a, ha, y, hy, hn⟩ := evidence_refusal hc.1.2 hc.2
    simp only [Claim, hh]
    intro hall
    exact hn (hall Bool bits y hy a ha).2
  | some hidden =>
    obtain ⟨_, _, hc⟩ := hidden_parts h hh
    simp only [Claim, hh]
    refine ⟨hidden_gamma h hh i x hx, ?_⟩
    have conclusion := (Bool.and_eq_true_iff.mp hc).2
    cases he : hidden.conclusion with
    | common images program =>
      have hp : checkCommon m hs c.visible.classes hidden.classes images program = true := by
        simpa only [he] using conclusion
      have hstruct : StructuralCommon m hs m.observation := ⟨program, common_sound hp⟩
      simp only [HiddenClaim, he]
      exact ⟨common_necessary (structural_to_arbitrary hstruct Bool bits), common_sound hp α i x hx⟩
    | outside member observation image =>
      have hp : checkOutside m hs c.visible.classes member observation image = true := by
        simpa only [he] using (Bool.and_eq_true_iff.mp (show
          (!hidden.closureInheritedFromStableView && checkOutside m hs c.visible.classes member observation image) = true
          from by simpa only [he] using conclusion)).2
      simpa only [HiddenClaim, he] using outside_sound hp
    | disagreement left right observation leftImage rightImage =>
      have hp : checkDisagreement m hs c.visible.classes left right observation leftImage rightImage = true := by
        simpa only [he] using conclusion
      simpa only [HiddenClaim, he] using disagreement_sound (partition_checked h) hp

theorem accepted_nonempty {m : Model} {gs hs : List Action} {c : Certificate}
    (h : check m gs hs c = true) (i : Interpretation α) : ∃ x, Gamma m i x :=
  U7.accepted_nonempty (visible_checked h) i

end U8
