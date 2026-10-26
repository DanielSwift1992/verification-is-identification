import U6.Minimality

namespace U10
open U5

/-- Class labels, never payloads. One bucket contains exactly one opaque sort. -/
def missing (required fixed : List Nat) : List Nat :=
  required.filter (fun c => !fixed.contains c)
def supplied (required fixed : List Nat) : List Nat :=
  required.filter (fun c => fixed.contains c)

theorem split_length (required fixed : List Nat) :
    (supplied required fixed).length + (missing required fixed).length = required.length := by
  induction required with
  | nil => rfl
  | cons c rest ih =>
    by_cases h : c ∈ fixed
    · simp [supplied, missing, h] at *; omega
    · simp [supplied, missing, h] at *; omega

/-- Fixed required classes count once, irrespective of repeated fixed slots.
Each free slot or residual leaf supplies at most one further class. -/
theorem bucket_lower_bound {required fixed free residual : List Nat}
    (hn : required.Nodup)
    (hc : ∀ c ∈ required, c ∈ fixed ∨ c ∈ free ∨ c ∈ residual) :
    required.length - (supplied required fixed).length - free.length ≤ residual.length := by
  have hnodup : (missing required fixed).Nodup := hn.filter _
  have sub : missing required fixed ⊆ free ++ residual := by
    intro c h
    have hh := List.mem_filter.mp h
    have hn : c ∉ fixed := by simpa using hh.2
    rcases hc c hh.1 with hf | hf | hd
    · exact False.elim (hn hf)
    · exact List.mem_append_left _ hf
    · exact List.mem_append_right _ hd
  have bound := hnodup.length_le_of_subset sub
  have split := split_length required fixed
  simp only [List.length_append] at bound
  omega

/-- Greedy allocation: cover all already fixed classes, then use free slots in
Question order. The remaining classes are precisely the drop, not a search. -/
def allocate (required fixed : List Nat) (freeSlots fallback : Nat) : List Nat :=
  (missing required fixed).take freeSlots ++
    List.replicate (freeSlots - (missing required fixed).length) fallback

def retain (required fixed : List Nat) (freeSlots : Nat) : List Nat :=
  (missing required fixed).drop freeSlots

theorem allocate_length (required fixed : List Nat) (freeSlots fallback : Nat) :
    (allocate required fixed freeSlots fallback).length = freeSlots := by
  simp [allocate]
  omega

theorem allocation_covers (required fixed : List Nat) (freeSlots fallback : Nat) :
    ∀ c ∈ required, c ∈ fixed ∨ c ∈ allocate required fixed freeSlots fallback ∨
      c ∈ retain required fixed freeSlots := by
  intro c hc
  by_cases hf : c ∈ fixed
  · exact Or.inl hf
  · have hm : c ∈ missing required fixed := by simp [missing, hc, hf]
    have hsplit := List.mem_append.mp (show c ∈
        (missing required fixed).take freeSlots ++ (missing required fixed).drop freeSlots by
      simpa using hm)
    rcases hsplit with ht | hd
    · exact Or.inr (Or.inl (List.mem_append_left _ ht))
    · exact Or.inr (Or.inr hd)

theorem allocation_attains (required fixed : List Nat) (freeSlots : Nat) :
    (retain required fixed freeSlots).length =
      required.length - (supplied required fixed).length - freeSlots := by
  have hs := split_length required fixed
  simp only [retain, List.length_drop]
  omega

/-- U10 is the no-bindings specialization of U10a. -/
theorem unbound_attains (required : List Nat) (outputSlots : Nat) :
    (retain required [] outputSlots).length = required.length - outputSlots := by
  have he : supplied required [] = [] := by
    induction required with
    | nil => rfl
    | cons c rest ih => simp [supplied]
  simpa [he] using allocation_attains required [] outputSlots

/-- Minimality is universal over all class assignments and all residual lists,
including repeated/irrelevant classes; it is not just minimality for one P. -/
theorem allocation_minimal {required fixed : List Nat} (hn : required.Nodup)
    (freeSlots _fallback : Nat) {free residual : List Nat}
    (hl : free.length ≤ freeSlots)
    (hc : ∀ c ∈ required, c ∈ fixed ∨ c ∈ free ∨ c ∈ residual) :
    (retain required fixed freeSlots).length ≤ residual.length := by
  rw [allocation_attains]
  have h := bucket_lower_bound hn hc
  omega

/-- Finite sum, keeping the sort index visible in the statement. -/
def sumOn (sorts : List SortId) (f : SortId → Nat) : Nat := (sorts.map f).sum

theorem sum_mono (sorts : List SortId) (f g : SortId → Nat)
    (h : ∀ s ∈ sorts, f s ≤ g s) : sumOn sorts f ≤ sumOn sorts g := by
  induction sorts with
  | nil => exact Nat.le_refl _
  | cons s ss ih =>
    simp only [sumOn, List.map_cons, List.sum_cons]
    exact Nat.add_le_add (h s (by simp)) (ih (fun s hs => h s (by simp [hs])))

/-- The stated sum of max(n_s-r_s-u_s,0); Nat subtraction is truncated. -/
theorem total_lower_bound (sorts : List SortId)
    (required fixed free residual : SortId → List Nat)
    (hn : ∀ s ∈ sorts, (required s).Nodup)
    (hc : ∀ s ∈ sorts, ∀ c ∈ required s,
      c ∈ fixed s ∨ c ∈ free s ∨ c ∈ residual s) :
    sumOn sorts (fun s => (required s).length - (supplied (required s) (fixed s)).length -
      (free s).length) ≤ sumOn sorts (fun s => (residual s).length) :=
  sum_mono sorts _ _ (fun s hs => bucket_lower_bound (hn s hs) (hc s hs))

theorem total_attains (sorts : List SortId) (required fixed : SortId → List Nat)
    (freeSlots : SortId → Nat) :
    sumOn sorts (fun s => (retain (required s) (fixed s) (freeSlots s)).length) =
      sumOn sorts (fun s => (required s).length - (supplied (required s) (fixed s)).length - freeSlots s) := by
  simp only [allocation_attains]

/-- Three independent required classes, one equal output class: two residual
leaves are both sufficient and necessary, with no tested payload values. -/
theorem residual_two :
    allocate [0,1,2] [] 1 0 = [0] ∧ retain [0,1,2] [] 1 = [1,2] ∧
    (∀ free residual : List Nat, free.length ≤ 1 →
      (∀ c ∈ [0,1,2], c ∈ free ∨ c ∈ residual) → 2 ≤ residual.length) := by
  refine ⟨by decide, by decide, ?_⟩
  intro free residual hl hc
  have h := allocation_minimal (required := [0,1,2]) (fixed := []) (by decide) 1 0 hl
    (fun c hm => Or.inr (hc c hm))
  exact h
end U10
