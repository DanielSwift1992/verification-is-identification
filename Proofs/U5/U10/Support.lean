import U10.Soundness

namespace U10
open U5

theorem insert_mem (s t : SortId) (xs : List SortId) :
    t ∈ insertSortId s xs ↔ t = s ∨ t ∈ xs := by
  induction xs with
  | nil => simp [insertSortId,eq_comm]
  | cons x xs ih =>
    by_cases h : s ≤ x
    · simp [insertSortId,h,eq_comm]
    · simp [insertSortId,h,ih,or_left_comm]

theorem order_mem (s : SortId) (xs : List SortId) : s ∈ orderSorts xs ↔ s ∈ xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [orderSorts,insert_mem,ih]

/-- The finite sum contains every sort that can have a nonzero n or m.
No required or output sort is dropped by the numeric presentation order. -/
theorem sorts_spec (r : Request) (sc oc : List PartitionClass) (s : SortId) :
    s ∈ sorts r sc oc ↔
      s ∈ oc.map PartitionClass.sort ∨ s ∈ (required r.source sc).map (classSort sc) := by
  simp [sorts,order_mem]

theorem refused_semantic {r : Request} {c : Certificate}
    (h : check r c = true) (hn : ∀ p, c.conclusion ≠ .constructed p) :
    ¬ ∃ p, HasShape r p ∧ UniversalObligations r p := by
  rintro ⟨p,hp,ho⟩
  exact refused_sound h hn ⟨p,hp,(obligations_iff r p).mpr ho⟩
end U10
