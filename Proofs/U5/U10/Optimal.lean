import U10.Completeness

namespace U10
open U5

/-- One structural solution, chosen before the interpretation and filling. -/
def Solution (r : Request) (p : Term Path) (d : Option (Term Path)) (decoder : Term Path) : Prop :=
  Legal r p ∧ (∀ t, d = some t → U9.Admitted r.source t) ∧
  ∀ (α : Type) (i : Interpretation α) x, Gamma r.source i x →
    run decoder ((jointView p d).map x) = some (r.source.question.map x)

theorem solution_exists {r : Request} (hr : Admissible r) :
    ∃ p d decoder, Solution r p d decoder := by
  obtain ⟨p,hp⟩ := legal_exists hr
  have covers : U6.Covers r.source (jointView p (some r.source.question)) r.source.question := by
    intro q hq
    obtain ⟨address,ha⟩ := U6.lookup_of_mem_values hq
    exact ⟨true :: address,q,ha,.refl _⟩
  obtain ⟨decoder,hd⟩ := U6.covers_factor covers
  refine ⟨p,some r.source.question,decoder,hp,?_,hd⟩
  intro t ht a ha
  have he : r.source.question = t := Option.some.inj ht
  subst t
  have hv := hr.sourceValid
  simp only [Model.valid,Bool.and_eq_true_iff,List.all_eq_true] at hv
  exact Option.isSome_iff_exists.mp (hv.1.1 a (List.mem_append_right _ ha))

theorem solution_boolean_decoder {r : Request} {p d decoder}
    (h : Solution r p d decoder) :
    ∃ f : Term Bool → Term Bool, ∀ x, Gamma r.source bits x →
      f ((jointView p d).map x) = r.source.question.map x := by
  refine ⟨fun y => (run decoder y).getD (.leaf false),?_⟩
  intro x hx
  simp only [h.2.2 Bool bits x hx,Option.getD_some]

theorem least_natural {P : Nat → Prop} (h : ∃ n, P n) :
    ∃ n, P n ∧ ∀ m, P m → n ≤ m := by
  classical
  obtain ⟨n,hn⟩ := h
  induction n using Nat.strongRecOn with
  | ind n ih =>
    by_cases smaller : ∃ m, m < n ∧ P m
    · obtain ⟨m,hm,hp⟩ := smaller
      exact ih m hm hp
    · refine ⟨n,hn,?_⟩
      intro m hm
      have hnot : ¬ m < n := fun hmn => smaller ⟨m,hmn,hm⟩
      omega

/-- No class table or forest is assumed for existence. The same solution
attains the formula in EVERY checked exact presentation of the two relations.
The formula proof uses the explicit allocation, not well-ordering alone. -/
theorem admissible_optimum {r : Request} (hr : Admissible r) :
    ∃ p d decoder, Solution r p d decoder ∧
      (∀ alternative other program, Solution r alternative other program →
        residualCount d ≤ residualCount other) ∧
      ∀ (sc oc : List PartitionClass) (sf of : List (List Step)),
        checkPartition r.source sc = true → checkPartition r.target oc = true →
        U6.checkForests r.source sc sf = true → U6.checkForests r.target oc of = true →
        residualCount d = lower r sc oc := by
  obtain ⟨p₀,d₀,f₀,h₀⟩ := solution_exists hr
  obtain ⟨n,⟨p,d,f,h,hn⟩,hmin⟩ := least_natural
    (P := fun n => ∃ p d f, Solution r p d f ∧ residualCount d = n)
    ⟨residualCount d₀,p₀,d₀,f₀,h₀,rfl⟩
  refine ⟨p,d,f,h,?_,?_⟩
  · intro a b f hf
    rw [hn]
    exact hmin _ ⟨a,b,f,hf,rfl⟩
  · intro sc oc sf of hs ho hfs hfo
    obtain ⟨a,b,f,hlegal,hadm,hdecode,hcount⟩ := optimal_plan_exists hr hs ho hfs hfo
    have hlo := u3_global_lower_bound hs ho hfo h.1 (solution_boolean_decoder h)
      (sorts r sc oc) (sorts_nodup r sc oc) (erased_nodup _)
    have hhi := hmin _ ⟨a,b,f,⟨hlegal,hadm,hdecode⟩,rfl⟩
    change lower r sc oc ≤ residualCount d at hlo
    rw [← hn,hcount] at hhi
    exact Nat.le_antisymm hhi hlo

theorem admissible_iff_solution {r : Request}
    (hm : r.source.valid = true) (ht : r.target.valid = true) (hb : checkBindingPlaces r = true) :
    Admissible r ↔ ∃ p d decoder, Solution r p d decoder := by
  refine ⟨solution_exists,?_⟩
  rintro ⟨p,d,decoder,h⟩
  exact legal_admissible hm ht hb h.1

end U10
