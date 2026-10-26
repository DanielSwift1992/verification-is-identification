import U8.Separation

namespace U8
open U5 U7

theorem common_necessary {m : Model} {hs : List Action} {view : Term Path}
    (h : CommonAt m hs view bits) : Conditions m hs view := by
  classical
  constructor
  · intro a ha p hp
    apply Classical.byContradiction
    intro hout
    exact outside_no_common ha hp hout h
  · intro a ha b hb p hp
    apply Classical.byContradiction
    intro hdiff
    exact disagreement_no_common ha hb hp hdiff h

theorem common_sufficient {m : Model} {hs : List Action} {view : Term Path}
    (hn : hs ≠ []) (h : Conditions m hs view) : StructuralCommon m hs view := by
  obtain ⟨first, hfirst⟩ := List.exists_mem_of_ne_nil hs hn
  have cover : U6.Covers m view (view.map (pull first)) := by
    intro q hq
    rw [U6.values_map] at hq
    obtain ⟨p, hp, rfl⟩ := List.mem_map.mp hq
    obtain ⟨r, hr, he⟩ := h.1 first hfirst p hp
    obtain ⟨address, haddr⟩ := U6.lookup_of_mem_values hr
    exact ⟨address, r, haddr, he⟩
  obtain ⟨program, hprogram⟩ := U6.covers_factor cover
  refine ⟨program, ?_⟩
  intro α i x hx a ha
  have hi := hprogram α i x hx
  have heq : (view.map (pull first)).map x = view.map (act a x) := by
    rw [U7.map_map]
    apply Term.map_eq_of_values
    intro p hp
    exact closure_sound hx.2 (h.2 first hfirst a ha p hp)
  exact hi.trans (congrArg some heq)

theorem structural_to_arbitrary {m : Model} {hs : List Action} {view : Term Path}
    (h : StructuralCommon m hs view) : UniversalCommon m hs view := by
  obtain ⟨program, hp⟩ := h
  intro α i
  refine ⟨fun z => (run program z).getD z, ?_⟩
  intro x hx a ha
  simp only [hp α i x hx a ha, Option.getD_some]

/-- U8 in both directions. The middle notion permits arbitrary deterministic k;
the left provides one structural program independent of interpretation and g. -/
theorem structural_iff_conditions {m : Model} {hs : List Action} {view : Term Path}
    (hn : hs ≠ []) : StructuralCommon m hs view ↔ Conditions m hs view :=
  ⟨fun h => common_necessary (structural_to_arbitrary h Bool bits), common_sufficient hn⟩

theorem universal_iff_conditions {m : Model} {hs : List Action} {view : Term Path}
    (hn : hs ≠ []) : UniversalCommon m hs view ↔ Conditions m hs view :=
  ⟨fun h => common_necessary (h Bool bits), fun h => structural_to_arbitrary (common_sufficient hn h)⟩

/-- Two-valued opaque sorts suffice for necessity; no payload sampling is used. -/
theorem boolean_iff_conditions {m : Model} {hs : List Action} {view : Term Path}
    (hn : hs ≠ []) : CommonAt m hs view bits ↔ Conditions m hs view :=
  ⟨common_necessary, fun h => structural_to_arbitrary (common_sufficient hn h) Bool bits⟩

theorem no_common_not_universal {m : Model} {hs : List Action} {view : Term Path}
    (h : ¬ CommonAt m hs view bits) : ¬ UniversalCommon m hs view :=
  fun hall => h (hall Bool bits)

/-- The paper's class-level formulation, under its E-preservation premise. -/
theorem universal_iff_class_conditions {m : Model} {hs : List Action} {view : Term Path}
    (hn : hs ≠ []) (he : ∀ a ∈ hs, Preserves m a) :
    UniversalCommon m hs view ↔ ClassConditions m hs view :=
  (universal_iff_conditions hn).trans (representatives_iff_classes he)

end U8
