import U10.Certificate

namespace U10
open U5

theorem negative_sound {r : Request} {sc oc : List PartitionClass}
    {forests : List (List Step)} {c : Conclusion}
    (hm : r.source.valid = true)
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hf : U6.checkForests r.target oc forests = true)
    (h : checkNegative r sc oc c = true) : ¬ ∃ p, Legal r p := by
  cases c with
  | constructed _ => simp [checkNegative] at h
  | unavailable u =>
    cases hu : r.target.source.lookup u with
    | none => simp [checkNegative,hu] at h
    | some s =>
      apply unavailable_impossible hu
      intro q hq
      have hh := List.all_eq_true.mp (show r.source.source.entries.all (fun (_,t) => t != s) = true from by
        simpa [checkNegative,hu] using h) (q,s) (Term.mem_entries.mpr hq)
      simp at hh
  | wrongSort address =>
    cases hb : r.bindings.find? (fun b => b.address == address) with
    | none => simp [checkNegative,hb] at h
    | some b =>
      cases hu : r.target.source.lookup b.output with
      | none => simp [checkNegative,hb,hu] at h
      | some s =>
        cases hv : r.source.source.lookup b.source with
        | none => simp [checkNegative,hb,hu,hv] at h
        | some t =>
          have hn : s ≠ t := by simpa [checkNegative,hb,hu,hv] using h
          exact wrong_sort_impossible hm (List.mem_of_find?_eq_some hb) hu hv hn
  | incompatible left right =>
    cases ha : r.bindings.find? (fun b => b.address == left) with
    | none => simp [checkNegative,ha] at h
    | some a =>
      cases hb : r.bindings.find? (fun b => b.address == right) with
      | none => simp [checkNegative,ha,hb] at h
      | some b =>
        simp only [checkNegative,ha,hb,Bool.and_eq_true_iff,beq_iff_eq,bne_iff_ne] at h
        have hneq := h.2
        have heq := h.1.2
        cases hu : r.target.source.lookup a.output with
        | none => simp [hu] at h
        | some s =>
          obtain ⟨index,hi⟩ := U6.partition_covers ho hu
          have hj : blockOf oc b.output = some index := heq ▸ hi
          exact incompatible_impossible (List.mem_of_find?_eq_some ha) (List.mem_of_find?_eq_some hb)
            (U6.same_block_closure hf hi hj) (fun hc => hneq (U6.closure_same_block hs hc))

/-- Exit 1 is an impossibility in U3 over all nonempty sorts, not a failed search. -/
theorem refused_sound {r : Request} {c : Certificate}
    (h : check r c = true) (hn : ∀ p, c.conclusion ≠ .constructed p) :
    ¬ ∃ p, Legal r p := by
  have hh := h
  simp only [check,Bool.and_eq_true_iff,decide_eq_true_eq] at hh
  cases hc : c.conclusion with
  | constructed p => exact False.elim (hn p hc)
  | unavailable u =>
    exact negative_sound hh.1.1.1.1.1.1.1.1.1 hh.1.1.1.1.1.1.2 hh.1.1.1.1.2 hh.1.1.1.2
      (by simpa [hc] using hh.2)
  | wrongSort a =>
    exact negative_sound hh.1.1.1.1.1.1.1.1.1 hh.1.1.1.1.1.1.2 hh.1.1.1.1.2 hh.1.1.1.2
      (by simpa [hc] using hh.2)
  | incompatible a b =>
    exact negative_sound hh.1.1.1.1.1.1.1.1.1 hh.1.1.1.1.1.1.2 hh.1.1.1.1.2 hh.1.1.1.2
      (by simpa [hc] using hh.2)
end U10
