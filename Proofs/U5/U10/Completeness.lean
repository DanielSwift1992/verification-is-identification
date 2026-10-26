import U10.Existence

namespace U10
open U5

/-- Feasibility independently of any supplied partition or forest. This also
separates normalization of E/C from the existence of a requested U3 step. -/
def OriginCandidate (r : Request) (u p : Path) : Prop :=
  (∃ s, r.target.source.lookup u = some s ∧ r.source.source.lookup p = some s) ∧
  ∀ b ∈ r.bindings, Closure r.target.edges u b.output → Closure r.source.edges p b.source

theorem origin_candidate_exists {r : Request} (hr : Admissible r) {u : Path} {s : SortId}
    (hu : r.target.source.lookup u = some s) : ∃ p, OriginCandidate r u p := by
  classical
  by_cases hb : ∃ b ∈ r.bindings, Closure r.target.edges u b.output
  · obtain ⟨b,hb,hrel⟩ := hb
    have htype := (hr.typed b hb).trans ((U9.closure_sort hr.targetValid hrel).symm.trans hu)
    exact ⟨b.source,⟨s,hu,htype⟩,fun a ha h => hr.consistent b hb a ha (.trans (.symm hrel) h)⟩
  · obtain ⟨p,hp⟩ := hr.available u s hu
    exact ⟨p,⟨s,hu,hp⟩,fun b hbm hrel => False.elim (hb ⟨b,hbm,hrel⟩)⟩

theorem candidate_congr {r : Request} (hr : Admissible r) {u v : Path}
    (huv : Closure r.target.edges u v) (p : Path) :
    OriginCandidate r u p ↔ OriginCandidate r v p := by
  have he := U9.closure_sort hr.targetValid huv
  constructor
  · rintro ⟨⟨s,hs,hp⟩,hb⟩
    exact ⟨⟨s,he ▸ hs,hp⟩,fun b hbm hvb => hb b hbm (.trans huv hvb)⟩
  · rintro ⟨⟨s,hs,hp⟩,hb⟩
    exact ⟨⟨s,he.symm ▸ hs,hp⟩,fun b hbm hub => hb b hbm (.trans (.symm huv) hub)⟩

noncomputable def chosenOrigin (r : Request) (u : Path) : Path :=
  Classical.epsilon (OriginCandidate r u)

theorem chosen_origin_spec {r : Request} (hr : Admissible r) {u : Path} {s : SortId}
    (hu : r.target.source.lookup u = some s) : OriginCandidate r u (chosenOrigin r u) :=
  Classical.epsilon_spec (origin_candidate_exists hr hu)

theorem chosen_origin_congr {r : Request} (hr : Admissible r) {u v : Path}
    (huv : Closure r.target.edges u v) : chosenOrigin r u = chosenOrigin r v := by
  have he : OriginCandidate r u = OriginCandidate r v :=
    funext (fun p => propext (candidate_congr hr huv p))
  simp only [chosenOrigin,he]

theorem legal_exists {r : Request} (hr : Admissible r) : ∃ p, Legal r p := by
  refine ⟨selectShape r.target.source (chosenOrigin r),?_,?_,?_⟩
  · apply select_shape
    intro u s hu
    obtain ⟨t,ht,hp⟩ := (chosen_origin_spec hr hu).1
    have he : t = s := Option.some.inj (ht.symm.trans hu)
    exact he ▸ hp
  · intro e he
    have hv := hr.targetValid
    simp only [Model.valid,Bool.and_eq_true_iff,List.all_eq_true,beq_iff_eq] at hv
    obtain ⟨s,hl⟩ := Option.isSome_iff_exists.mp (hv.1.2 e he).1
    have hright := ((hv.1.2 e he).2).symm.trans hl
    rw [select_origin hl,select_origin hright,chosen_origin_congr hr (.edge he)]
    exact .refl _
  · intro b hb
    obtain ⟨s,hs⟩ := Option.isSome_iff_exists.mp (binding_live hr hb).1
    rw [select_origin hs]
    exact (chosen_origin_spec hr hs).2 b hb (.refl _)

theorem admissible_iff_legal {r : Request}
    (hm : r.source.valid = true) (ht : r.target.valid = true) (hb : checkBindingPlaces r = true) :
    Admissible r ↔ ∃ p, Legal r p :=
  ⟨legal_exists,fun ⟨_,hp⟩ => legal_admissible hm ht hb hp⟩

theorem insert_sort_nodup {s : SortId} {ss : List SortId}
    (hn : ss.Nodup) (hs : s ∉ ss) : (insertSortId s ss).Nodup := by
  induction ss with
  | nil => simp [insertSortId]
  | cons t ts ih =>
    have hh := List.nodup_cons.mp hn
    have hst : s ≠ t := fun he => hs (by simp [he])
    have hrest : s ∉ ts := fun h => hs (List.mem_cons_of_mem _ h)
    by_cases he : s ≤ t
    · simpa [insertSortId,he] using List.nodup_cons.mpr ⟨hs,hn⟩
    · simp only [insertSortId,he,ite_false,List.nodup_cons]
      exact ⟨fun hm => ((insert_mem s t ts).mp hm).elim (fun h => hst h.symm) hh.1, ih hh.2 hrest⟩

theorem order_sorts_nodup {ss : List SortId} (hn : ss.Nodup) : (orderSorts ss).Nodup := by
  induction ss with
  | nil => simp [orderSorts]
  | cons s ss ih =>
    have hh := List.nodup_cons.mp hn
    exact insert_sort_nodup (ih hh.2) (fun h => hh.1 ((order_mem s ss).mp h))

theorem erased_nodup (xs : List Nat) : xs.eraseDups.Nodup := by
  cases xs with
  | nil => simp
  | cons a xs =>
    rw [List.eraseDups_cons]
    apply List.nodup_cons.mpr
    constructor
    · simp
    · exact erased_nodup (xs.filter (fun b => !b == a))
termination_by xs.length
decreasing_by
  have h := List.length_filter_le (fun b => !b == a) xs
  simp only [List.length_cons]
  omega

theorem sorts_nodup (r : Request) (sc oc : List PartitionClass) : (sorts r sc oc).Nodup :=
  order_sorts_nodup (erased_nodup _)

/-- Both attainment and the comparison against every legal step are in one
statement. Competitors may use an arbitrary decoder on the Boolean carrier. -/
theorem optimal_plan_minimal {r : Request} (hr : Admissible r)
    {sc oc : List PartitionClass} {sf of : List (List Step)}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hfs : U6.checkForests r.source sc sf = true) (hfo : U6.checkForests r.target oc of = true) :
    ∃ p d decoder,
      Legal r p ∧ (∀ t, d = some t → U9.Admitted r.source t) ∧
      (∀ (α : Type) (i : Interpretation α) x, Gamma r.source i x →
        run decoder ((jointView p d).map x) = some (r.source.question.map x)) ∧
      residualCount d = lower r sc oc ∧
      ∀ alternative other, Legal r alternative →
        (∃ f : Term Bool → Term Bool, ∀ x, Gamma r.source bits x →
          f ((jointView alternative other).map x) = r.source.question.map x) →
        residualCount d ≤ residualCount other := by
  obtain ⟨p,d,decoder,hp,hd,hrun,hn⟩ := optimal_plan_exists hr hs ho hfs hfo
  refine ⟨p,d,decoder,hp,hd,hrun,hn,?_⟩
  intro alternative other hl ha
  rw [hn]
  exact u3_global_lower_bound hs ho hfo hl ha (sorts r sc oc) (sorts_nodup r sc oc)
    (erased_nodup _)

end U10
