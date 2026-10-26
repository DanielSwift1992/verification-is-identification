import U10.Negative

namespace U10
open U5

theorem fixed_empty {r : Request} (h : r.bindings = []) (sc oc : List PartitionClass) :
    fixedValues (oc.map (slot r sc)) = [] := by
  induction oc with
  | nil => rfl
  | cons c cs ih => simp [fixedValues,slot,boundFor,h]

theorem free_unbound {r : Request} (h : r.bindings = []) (sc oc : List PartitionClass) (s : SortId) :
    freeSlots (oc.map (slot r sc)) s = (oc.filter (fun c => c.sort == s)).length := by
  induction oc with
  | nil => rfl
  | cons c cs ih =>
    by_cases hs : c.sort = s <;> simp [freeSlots,slot,boundFor,h,hs] at * <;> omega

theorem supplied_empty (xs : List Nat) : supplied xs [] = [] := by
  induction xs with
  | nil => rfl
  | cons c cs ih => simp [supplied]

/-- The bound with no prescribed sources is exactly Σ max(n_s-m_s,0). -/
theorem unbound_capacity {r : Request} (h : r.bindings = []) (sc oc : List PartitionClass) (s : SortId) :
    (capacity r sc oc s).fixedRequiredClasses = 0 ∧
    (capacity r sc oc s).freeOutputClasses = (capacity r sc oc s).outputClasses ∧
    (capacity r sc oc s).minimumResidualLeaves =
      (capacity r sc oc s).requiredClasses - (capacity r sc oc s).outputClasses := by
  simp [capacity,fixed_empty h,free_unbound h,bucket,supplied_empty]
end U10
