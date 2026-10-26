import U8.Soundness

namespace U8
open U5 U7

theorem mapped_lookup {t u : Term Path} (f : Path → β) (he : t.map f = u.map f)
    {address p : Path} (hp : u.lookup address = some p) :
    ∃ q, t.lookup address = some q ∧ f q = f p := by
  have hl := congrArg (fun v => v.lookup address) he
  simp only [Term.lookup_map, hp, Option.map_some] at hl
  cases ht : t.lookup address with
  | none => simp [ht] at hl
  | some q => exact ⟨q, rfl, by simpa [ht] using hl⟩

/-- The metadata comparison of corresponding classes really identifies the two
held sets, even when Observation repeats an E-class in several places. -/
theorem same_class_views {m : Model} {cs : List PartitionClass} {steps : List (List Step)}
    {s : StableView} (hf : U6.checkForests m cs steps = true)
    (hb : ∀ p ∈ m.observation.values, ∃ b, blockOf cs p = some b)
    (he : s.view.map (blockOf cs) = m.observation.map (blockOf cs)) (p : Path) :
    U7.Retained m s p ↔ Held m m.observation p := by
  constructor
  · rintro ⟨q, hq, hqp⟩
    obtain ⟨address, haddress⟩ := U6.lookup_of_mem_values hq
    obtain ⟨r, hr, hblocks⟩ := mapped_lookup _ he.symm haddress
    have hrm := Term.mem_values_of_lookup hr
    obtain ⟨b, hbr⟩ := hb r hrm
    have hbq : blockOf cs q = some b := hblocks.symm.trans hbr
    exact ⟨r, hrm, .trans (U6.same_block_closure hf hbr hbq) hqp⟩
  · rintro ⟨r, hr, hrp⟩
    obtain ⟨address, haddress⟩ := U6.lookup_of_mem_values hr
    obtain ⟨q, hq, hblocks⟩ := mapped_lookup _ he haddress
    obtain ⟨b, hbr⟩ := hb r hr
    exact ⟨q, Term.mem_values_of_lookup hq,
      .trans (U6.same_block_closure hf (hblocks.trans hbr) hbr) hrp⟩

/-- True inheritance really supplies closure via the checked U7 view. Agreement
is still an independent U8 obligation. False inheritance is not an obstruction. -/
theorem inherited_closed {m : Model} {gs hs : List Action} {visible : U7.Certificate}
    (hv : U7.check m gs visible = true) (hi : inherited m gs hs visible = true) :
    Closed m hs m.observation := by
  cases hsview : visible.stable with
  | none => simp [inherited, hsview] at hi
  | some s =>
    obtain ⟨hm, _, hg, hstable⟩ := U7.positive_parts hv hsview
    have checked := hv
    simp only [U7.check, Bool.and_eq_true_iff] at checked
    have hp := checked.1.1.1.2
    have hf := checked.1.1.2
    have hb : ∀ p ∈ m.observation.values, ∃ b, blockOf visible.classes p = some b := by
      intro p hpm
      exact U6.admitted_cuts_have_blocks hm hp p (List.mem_append_left _ hpm)
    simp only [inherited, hsview, Bool.and_eq_true_iff, beq_iff_eq, List.all_eq_true,
      List.any_eq_true] at hi
    have heq := same_class_views hf hb hi.1
    intro a ha p hpm
    obtain ⟨g, hgm, himage⟩ := hi.2 a ha
    have him : a.image = g.image := by simpa using himage
    have hheld : U7.Retained m s p := (heq p).mpr ⟨p, hpm, .refl p⟩
    have result := (heq (pull g p)).mp ((U7.stable_closed hstable hg).2.2 g hgm p hheld)
    simpa only [pull, him] using result

end U8
