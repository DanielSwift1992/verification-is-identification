import U10.Support

namespace U10
open U5

/-- A slot receives a fixed class, the next required class of its sort, or a
live fallback. The fallback premise concerns source classes, never payloads. -/
theorem fill_exists (sort : Nat → SortId) (good : Nat → Prop)
    (fallback : SortId → Nat) (slots : List Slot) (pending : SortId → List Nat)
    (hp : ∀ s a, a ∈ pending s → good a ∧ sort a = s)
    (hb : ∀ slot ∈ slots, good (fallback slot.sort) ∧ sort (fallback slot.sort) = slot.sort)
    (hf : ∀ slot ∈ slots, ∀ a, slot.fixed = some a → good a ∧ sort a = slot.sort) :
    ∃ assignments : List Nat,
      checkAssignments sort slots assignments = true ∧
      (∀ a ∈ assignments, good a) ∧
      ∀ s a, a ∈ pending s →
        a ∈ assignments ∨ a ∈ (pending s).drop (freeSlots slots s) := by
  classical
  induction slots generalizing pending with
  | nil =>
    exact ⟨[], rfl, by simp, by intro s a ha; simpa [freeSlots] using ha⟩
  | cons slot slots ih =>
    cases hfix : slot.fixed with
    | some a =>
      obtain ⟨as, hcheck, hgood, hcover⟩ := ih pending hp
        (fun s hs => hb s (by simp [hs])) (fun s hs => hf s (by simp [hs]))
      have hg := hf slot (by simp) a hfix
      refine ⟨a :: as, ?_, ?_, ?_⟩
      · exact Bool.and_eq_true_iff.mpr ⟨by simp [hfix,hg.2], hcheck⟩
      · intro b hmem
        rcases List.mem_cons.mp hmem with rfl | hm
        · exact hg.1
        · exact hgood b hm
      · intro s b hm
        rcases hcover s b hm with ha | hr
        · exact Or.inl (List.mem_cons_of_mem _ ha)
        · exact Or.inr (by simpa [freeSlots,hfix] using hr)
    | none =>
      let next := fun s => if s = slot.sort then (pending s).drop 1 else pending s
      have hn : ∀ s a, a ∈ next s → good a ∧ sort a = s := by
        intro s a ha
        apply hp s a
        by_cases he : s = slot.sort
        · have ht : a ∈ (pending s).drop 1 := by simpa only [next,ite_eq_left he] using ha
          exact List.mem_of_mem_drop ht
        · simpa [next,he] using ha
      obtain ⟨as, hcheck, hgood, hcover⟩ := ih next hn
        (fun s hs => hb s (by simp [hs])) (fun s hs => hf s (by simp [hs]))
      let a := (pending slot.sort).headD (fallback slot.sort)
      have hg : good a ∧ sort a = slot.sort := by
        cases he : pending slot.sort with
        | nil => simpa [a,he] using hb slot (by simp)
        | cons b bs => simpa [a,he] using hp slot.sort b (by simp [he])
      refine ⟨a :: as, ?_, ?_, ?_⟩
      · exact Bool.and_eq_true_iff.mpr ⟨by simp [hfix,hg.2], hcheck⟩
      · intro b hm
        rcases List.mem_cons.mp hm with rfl | hm
        · exact hg.1
        · exact hgood b hm
      · intro s b hm
        by_cases he : s = slot.sort
        · subst s
          cases hl : pending slot.sort with
          | nil => simp [hl] at hm
          | cons c cs =>
            rcases (show b = c ∨ b ∈ cs by simpa [hl] using hm) with rfl | ht
            · exact Or.inl (by simp [a,hl])
            · have hh := hcover slot.sort b (by simpa [next,hl] using ht)
              rcases hh with ha | hr
              · exact Or.inl (List.mem_cons_of_mem _ ha)
              · exact Or.inr (by simpa [next,hl,freeSlots,hfix] using hr)
        · have hh := hcover s b (by simpa [next,he] using hm)
          rcases hh with ha | hr
          · exact Or.inl (List.mem_cons_of_mem _ ha)
          · exact Or.inr (by simpa [next,he,freeSlots,hfix,Ne.symm he] using hr)

theorem fixed_supplied {sort : Nat → SortId} {slots : List Slot} {as : List Nat}
    (h : checkAssignments sort slots as = true) {b : Nat}
    (hb : b ∈ fixedValues slots) : b ∈ as := by
  obtain ⟨slot,hs,hf⟩ := List.mem_filterMap.mp hb
  obtain ⟨a,ha,hcheck⟩ := U7.pairs_left h hs
  have he : a = b := by simpa [hf] using (Bool.and_eq_true_iff.mp hcheck).2
  exact he ▸ ha

/-- Lift per-sort retain/count to actual slot assignments. Every selected
class, including a surplus-slot fallback, is live. -/
theorem allocation_exists (sort : Nat → SortId) (good : Nat → Prop)
    (fallback : SortId → Nat) (slots : List Slot) (required sorts : List Nat)
    (hr : ∀ b ∈ required, good b)
    (hs : ∀ b ∈ required, sort b ∈ sorts)
    (hb : ∀ slot ∈ slots, good (fallback slot.sort) ∧ sort (fallback slot.sort) = slot.sort)
    (hf : ∀ slot ∈ slots, ∀ b, slot.fixed = some b → good b ∧ sort b = slot.sort) :
    ∃ assignments residual : List Nat,
      checkAssignments sort slots assignments = true ∧
      (∀ b ∈ assignments, good b) ∧ (∀ b ∈ residual, good b) ∧
      required ⊆ assignments ++ residual ∧
      residual.length = sumOn sorts (fun s => (bucket sort s required).length -
        (supplied (bucket sort s required) (bucket sort s (fixedValues slots))).length -
        freeSlots slots s) := by
  classical
  let pending := fun s => missing (bucket sort s required) (bucket sort s (fixedValues slots))
  have hp : ∀ s b, b ∈ pending s → good b ∧ sort b = s := by
    intro s b hm
    have hh := List.mem_filter.mp (List.mem_filter.mp hm).1
    exact ⟨hr b hh.1, by simpa using hh.2⟩
  obtain ⟨as,hcheck,hgood,hcover⟩ := fill_exists sort good fallback slots pending hp hb hf
  let residual := sorts.flatMap (fun s => (pending s).drop (freeSlots slots s))
  refine ⟨as,residual,hcheck,hgood,?_,?_,?_⟩
  · intro b hm
    obtain ⟨s,_,hm⟩ := List.mem_flatMap.mp hm
    exact (hp s b (List.mem_of_mem_drop hm)).1
  · intro b hm
    by_cases hfixed : b ∈ fixedValues slots
    · exact List.mem_append_left _ (fixed_supplied hcheck hfixed)
    · have hpend : b ∈ pending (sort b) := by simp [pending,missing,bucket,hm,hfixed]
      rcases hcover (sort b) b hpend with ha | hd
      · exact List.mem_append_left _ ha
      · exact List.mem_append_right _ (List.mem_flatMap.mpr ⟨sort b,hs b hm,hd⟩)
  · change (sorts.flatMap (fun s => retain (bucket sort s required)
        (bucket sort s (fixedValues slots)) (freeSlots slots s))).length = _
    simp only [List.length_flatMap,allocation_attains,sumOn]

end U10
