import U10.Model

namespace U10
open U5

structure Slot where
  sort : SortId
  fixed : Option Nat
  deriving DecidableEq, Repr

def fixedValues (slots : List Slot) : List Nat := slots.filterMap Slot.fixed

def freeValues : List Slot → List Nat → List Nat
  | slot :: slots, a :: rest =>
    (if slot.fixed.isNone then [a] else []) ++ freeValues slots rest
  | _, _ => []

def checkAssignments (sort : Nat → SortId) : List Slot → List Nat → Bool :=
  U7.checkPairs (fun slot a => sort a == slot.sort &&
    match slot.fixed with | none => true | some b => a == b)

def bucket (sort : Nat → SortId) (s : SortId) (cs : List Nat) : List Nat :=
  cs.filter (fun c => sort c == s)
def freeSlots (slots : List Slot) (s : SortId) : Nat :=
  (slots.filter (fun slot => slot.sort == s && slot.fixed.isNone)).length

theorem assignment_cover {sort : Nat → SortId} {slots : List Slot} {as : List Nat}
    (h : checkAssignments sort slots as = true) {a : Nat} (ha : a ∈ as) :
    a ∈ fixedValues slots ∨ a ∈ freeValues slots as := by
  induction slots generalizing as with
  | nil => cases as <;> simp [checkAssignments, U7.checkPairs] at h ha
  | cons slot slots ih =>
    cases as with
    | nil => simp at ha
    | cons b bs =>
      have hh := Bool.and_eq_true_iff.mp h
      rcases List.mem_cons.mp ha with rfl | ha
      · cases hs : slot.fixed with
        | none => exact Or.inr (by simp [freeValues, hs])
        | some c =>
          have he : a = c := by simpa [hs] using (Bool.and_eq_true_iff.mp hh.1).2
          exact Or.inl (List.mem_filterMap.mpr ⟨slot, by simp, he ▸ hs⟩)
      · rcases ih hh.2 ha with hf | hf
        · obtain ⟨w, hw, he⟩ := List.mem_filterMap.mp hf
          exact Or.inl (List.mem_filterMap.mpr ⟨w, List.mem_cons_of_mem _ hw, he⟩)
        · exact Or.inr (List.mem_append_right _ hf)

theorem free_bucket_length {sort : Nat → SortId} {slots : List Slot} {as : List Nat}
    (h : checkAssignments sort slots as = true) (s : SortId) :
    (bucket sort s (freeValues slots as)).length = freeSlots slots s := by
  induction slots generalizing as with
  | nil => cases as <;> simp_all [checkAssignments, U7.checkPairs, freeValues, bucket, freeSlots]
  | cons slot slots ih =>
    cases as with
    | nil => simp [checkAssignments, U7.checkPairs] at h
    | cons a rest =>
      have hh := Bool.and_eq_true_iff.mp h
      have hs : sort a = slot.sort := by simpa using (Bool.and_eq_true_iff.mp hh.1).1
      have hi := ih hh.2
      cases hf : slot.fixed <;> by_cases he : slot.sort = s <;>
        simp [freeValues, hf, bucket, freeSlots, hs, he] at * <;> omega

/-- A normalized plan can use any assignment, including repetitions and extra
output equalities. Binding slots constrain its source class; free slots do not. -/
theorem class_plan_bucket_bound {sort : Nat → SortId} {slots : List Slot}
    {required assignments residual : List Nat}
    (hn : required.Nodup) (hp : checkAssignments sort slots assignments = true)
    (hc : required ⊆ assignments ++ residual) (s : SortId) :
    (bucket sort s required).length -
      (supplied (bucket sort s required) (bucket sort s (fixedValues slots))).length -
      freeSlots slots s ≤ (bucket sort s residual).length := by
  have hcov : ∀ c ∈ bucket sort s required,
      c ∈ bucket sort s (fixedValues slots) ∨
      c ∈ bucket sort s (freeValues slots assignments) ∨ c ∈ bucket sort s residual := by
    intro c hc'
    obtain ⟨hcr,hcs⟩ := List.mem_filter.mp hc'
    rcases List.mem_append.mp (hc hcr) with ha | hd
    · rcases assignment_cover hp ha with hf | hf
      · exact Or.inl (List.mem_filter.mpr ⟨hf,hcs⟩)
      · exact Or.inr (Or.inl (List.mem_filter.mpr ⟨hf,hcs⟩))
    · exact Or.inr (Or.inr (List.mem_filter.mpr ⟨hd,hcs⟩))
  have h := bucket_lower_bound (hn.filter _) hcov
  rw [free_bucket_length hp s] at h
  exact h

theorem sum_add (sorts : List SortId) (f g : SortId → Nat) :
    sumOn sorts (fun s => f s + g s) = sumOn sorts f + sumOn sorts g := by
  induction sorts with
  | nil => rfl
  | cons s ss ih => simp only [sumOn, List.map_cons, List.sum_cons] at *; omega

theorem indicator_sum (sorts : List SortId) (hn : sorts.Nodup) (s : SortId) :
    sumOn sorts (fun t => if s == t then 1 else 0) = if s ∈ sorts then 1 else 0 := by
  induction sorts with
  | nil => rfl
  | cons t ts ih =>
    have hh := List.nodup_cons.mp hn
    have hi := ih hh.2
    by_cases he : s = t
    · subst t
      simp [sumOn, hh.1] at *
      exact hi
    · simp [sumOn, he] at *
      exact hi

theorem bucket_sum_le (sorts : List SortId) (hn : sorts.Nodup)
    (sort : Nat → SortId) (cs : List Nat) :
    sumOn sorts (fun s => (bucket sort s cs).length) ≤ cs.length := by
  induction cs with
  | nil =>
    have hz : ∀ xs : List SortId, sumOn xs (fun s => (bucket sort s []).length) = 0 := by
      intro xs; induction xs <;> simp_all [sumOn,bucket]
    simp [hz]
  | cons c cs ih =>
    have hs : (fun s => (bucket sort s (c :: cs)).length) =
        (fun s => (if sort c == s then 1 else 0) + (bucket sort s cs).length) := by
      funext s; by_cases h : sort c = s <;> simp [bucket, h, Nat.add_comm]
    rw [hs, sum_add, indicator_sum sorts hn]
    split <;> simp only [List.length_cons] <;> omega

/-- Global lower bound against every normalized structural step and every
adequate residual. The residual list need not have distinct classes. -/
theorem class_plan_lower_bound (sorts : List SortId) (hs : sorts.Nodup)
    {sort : Nat → SortId} {slots : List Slot} {required assignments residual : List Nat}
    (hn : required.Nodup) (hp : checkAssignments sort slots assignments = true)
    (hc : required ⊆ assignments ++ residual) :
    sumOn sorts (fun s => (bucket sort s required).length -
      (supplied (bucket sort s required) (bucket sort s (fixedValues slots))).length -
      freeSlots slots s) ≤ residual.length :=
  Nat.le_trans (sum_mono sorts _ _ (fun s _ => class_plan_bucket_bound hn hp hc s))
    (bucket_sum_le sorts hs sort residual)
end U10
