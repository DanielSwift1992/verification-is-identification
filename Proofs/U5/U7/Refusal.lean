import U7.Soundness

namespace U7
open U5

theorem refusal_witness {m : Model} {cs : List PartitionClass} {a : Action}
    {address : Path} (h : checkRefusal m cs a address = true) :
    ∃ x : Path → Bool, Gamma m bits x ∧ ¬ Compatible m (act a x) := by
  classical
  cases he : m.edges.find? (fun e => e.address == address) with
  | none => simp [checkRefusal, he] at h
  | some e =>
    have hm : e ∈ m.edges := List.mem_of_find?_eq_some he
    have ho : checkObstruction
        (cut m (.leaf (pull a e.left)) (.leaf (pull a e.right))) ⟨[], cs⟩ = true := by
      simpa [checkRefusal, he] using h
    obtain ⟨x, y, hx, hy, hp, hq⟩ := obstruction_witnesses ho
    have hl : x (pull a e.left) = y (pull a e.left) := by
      simpa only [cut, Term.map, Term.leaf.injEq] using hp
    have hr : x (pull a e.right) ≠ y (pull a e.right) := by
      simpa only [cut, Term.map, ne_eq, Term.leaf.injEq] using hq
    by_cases hn : Compatible m (act a x)
    · refine ⟨y, hy, ?_⟩
      intro hny
      exact hr ((hn e hm).symm.trans (hl.trans (hny e hm)))
    · exact ⟨x, hx, hn⟩

theorem evidence_refusal {m : Model} {cs : List PartitionClass}
    {gs : List Action} {es : List ActionEvidence}
    (hc : checkPairs (checkEvidence m cs) gs es = true)
    (hh : evidenceHolds es = false) :
    ∃ a ∈ gs, ∃ x : Path → Bool, Gamma m bits x ∧ ¬ Compatible m (act a x) := by
  have hn : ¬ ∀ e ∈ es,
      (match e.preservation with | .preserved _ => true | _ => false) = true := by
    intro hall
    have ht : evidenceHolds es = true := List.all_eq_true.mpr hall
    rw [hh] at ht
    contradiction
  obtain ⟨e, he⟩ := Classical.not_forall.mp hn
  have hm : e ∈ es := by
    apply Classical.byContradiction
    intro hnm
    exact he (fun he => False.elim (hnm he))
  have hnp := fun ht => he (fun _ => ht)
  obtain ⟨a, ha, ht⟩ := pairs_right hc hm
  cases hr : e.preservation with
  | preserved bases => exact False.elim (hnp (by simp [hr]))
  | notPreserved address =>
    have href : checkRefusal m cs a address = true := by simpa [checkEvidence, hr] using (Bool.and_eq_true_iff.mp ht).2
    obtain ⟨x, hx, hnx⟩ := refusal_witness href
    exact ⟨a, ha, x, hx, hnx⟩

theorem check_refusal_sound {m : Model} {gs : List Action} {c : Certificate}
    (h : check m gs c = true) (hs : c.stable = none) :
    ∃ a ∈ gs, ∃ x : Path → Bool, Gamma m bits x ∧ ¬ Compatible m (act a x) := by
  simp only [check, hs, Bool.and_eq_true_iff, Bool.not_eq_true'] at h
  exact evidence_refusal h.1.2 h.2

/-- Negative certificates refute a universal reuse of X_E. They do not say
that the same action fails on every carrier (e.g. singleton sorts). -/
theorem refusal_not_universal {m : Model} {gs : List Action} {c : Certificate}
    (h : check m gs c = true) (hs : c.stable = none) :
    ¬ ∀ (α : Type) (i : Interpretation α) (x : Path → α), Gamma m i x →
      ∀ a ∈ gs, Gamma m i (act a x) := by
  obtain ⟨a, ha, x, hx, hn⟩ := check_refusal_sound h hs
  intro hall
  exact hn (hall Bool bits x hx a ha).2

end U7
