import U7.Reachability

namespace U7
open U5

theorem map_map (t : Term α) (f : α → β) (g : β → γ) :
    (t.map f).map g = t.map (fun a => g (f a)) := by
  induction t with
  | leaf a => rfl
  | pair l r ihl ihr => simp [Term.map, ihl, ihr]

theorem image_commutes {m : Model} {cs : List PartitionClass} {s : StableView}
    {a : Action} {proof : ImageAction} (h : checkImage m cs s a proof = true)
    (i : Interpretation α) (x : Path → α) (hx : Gamma m i x) :
    run proof.construction.program (s.view.map x) = some (s.view.map (act a x)) := by
  have hh := construction_sound (image_construction h) hx.2
  change run proof.construction.program (s.view.map x) = some (s.view.map (fun p => x (pull a p)))
  simpa only [cut, map_map] using hh

theorem question_decodes {m : Model} {gs : List Action} {cs : List PartitionClass}
    {s : StableView} (h : checkStable m gs cs s = true)
    (i : Interpretation α) (x : Path → α) (hx : Gamma m i x) :
    run s.decoder.program (s.view.map x) = some (m.question.map x) :=
  construction_sound (stable_decoder h) hx.2

theorem positive_parts {m : Model} {gs : List Action} {c : Certificate}
    {s : StableView} (h : check m gs c = true) (hs : c.stable = some s) :
    m.valid = true ∧ (∀ a ∈ gs, checkAction m a = true) ∧
    (∀ a ∈ gs, Preserves m a) ∧ checkStable m gs c.classes s = true := by
  simp only [check, hs, Bool.and_eq_true_iff, List.all_eq_true] at h
  exact ⟨h.1.1.1.1.1.1, h.1.1.1.1.1.2,
    evidence_preserves h.1.2 h.2.1, h.2.2⟩

/-- The positive theorem quantifies over arbitrary nonempty sort carriers and
all E-compatible fillings. g_V is the certificate's checked U5 program. -/
theorem check_stable_sound {m : Model} {gs : List Action} {c : Certificate}
    {s : StableView} (h : check m gs c = true) (hs : c.stable = some s) :
    (∀ p, Retained m s p ↔ Reach m gs p) ∧
    ∀ (α : Type) (i : Interpretation α) (x : Path → α), Gamma m i x →
      run s.decoder.program (s.view.map x) = some (m.question.map x) ∧
      ∀ a ∈ gs, Gamma m i (act a x) ∧
        ∃ image ∈ s.actions, image.member = a.member ∧
          run image.construction.program (s.view.map x) = some (s.view.map (act a x)) := by
  obtain ⟨_, hva, hga, hstable⟩ := positive_parts h hs
  refine ⟨closure_exact hstable hga, ?_⟩
  intro α i x hx
  refine ⟨question_decodes hstable i x hx, ?_⟩
  intro a ha
  obtain ⟨image, him, hi⟩ := pairs_left (stable_images hstable) ha
  refine ⟨action_gamma (hva a ha) (hga a ha) hx, image, him, ?_, image_commutes hi i x hx⟩
  simp only [checkImage, Bool.and_eq_true_iff, beq_iff_eq] at hi
  exact hi.1.1

theorem accepted_nonempty {m : Model} {gs : List Action} {c : Certificate}
    (h : check m gs c = true) (i : Interpretation α) : ∃ x, Gamma m i x := by
  have hm : m.valid = true := by
    simp only [check, Bool.and_eq_true_iff] at h
    exact h.1.1.1.1.1.1
  exact compatible_nonempty m hm i

end U7
