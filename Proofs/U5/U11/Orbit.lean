import Std

namespace U11

/-- One fixed function, repeated; no resampling of a member between calls. -/
def iterate (f : α → α) : Nat → α → α
  | 0, x => x
  | n + 1, x => iterate f n (f x)

@[simp] theorem iterate_zero (f : α → α) (x : α) : iterate f 0 x = x := rfl
@[simp] theorem iterate_succ (f : α → α) (n : Nat) (x : α) :
    iterate f (n + 1) x = f (iterate f n x) := by
  induction n generalizing x with
  | zero => rfl
  | succ n ih => simpa only [iterate] using ih (f x)

theorem iterate_add (f : α → α) (n k : Nat) (x : α) :
    iterate f (n + k) x = iterate f k (iterate f n x) := by
  induction n generalizing x with
  | zero => simp [iterate]
  | succ n ih => simpa only [Nat.succ_add, iterate] using ih (f x)

/-- Positivity and the FIRST return, not merely a period. -/
def FirstReturn (f : α → α) (c : α) (n : Nat) : Prop :=
  0 < n ∧ iterate f n c = c ∧ ∀ j, 0 < j → j < n → iterate f j c ≠ c

theorem return_multiple {f : α → α} {c : α} {n : Nat}
    (hn : iterate f n c = c) (q : Nat) : iterate f (n * q) c = c := by
  induction q with
  | zero => rfl
  | succ q ih => rw [Nat.mul_succ, iterate_add, ih, hn]

theorem return_iff_dvd {f : α → α} {c : α} {n : Nat}
    (hn : FirstReturn f c n) (k : Nat) : iterate f k c = c ↔ n ∣ k := by
  constructor
  · induction k using Nat.strongRecOn with
    | ind k ih =>
      intro hk
      by_cases hz : k = 0
      · subst k; exact Nat.dvd_zero n
      by_cases hlt : k < n
      · exact False.elim (hn.2.2 k (by omega) hlt hk)
      have hle : n ≤ k := by omega
      have hsub : iterate f (k - n) c = c := by
        have := iterate_add f n (k - n) c
        rw [Nat.add_sub_of_le hle, hn.2.1] at this
        exact this.symm.trans hk
      have hnpos := hn.1
      have hd := ih (k-n) (by omega) hsub
      have := Nat.dvd_add (Nat.dvd_refl n) hd
      simpa [Nat.add_sub_of_le hle] using this
  · rintro ⟨q, rfl⟩; exact return_multiple hn.2.1 q

/-- The supplied prefix excludes the terminal repeated vertex. Each step is
checked against f; no orbit discovery or least-return search occurs here. -/
def checkWalk (f : Nat → Nat) : Nat → List Nat → Nat → Bool
  | c, [], last => c == last
  | c, p :: ps, last => c == p && checkWalk f (f c) ps last

theorem walk_end {f : Nat → Nat} {c last : Nat} {ps : List Nat}
    (h : checkWalk f c ps last = true) : iterate f ps.length c = last := by
  induction ps generalizing c with
  | nil => simpa [checkWalk, iterate] using h
  | cons p ps ih =>
    have hh := Bool.and_eq_true_iff.mp h
    exact ih hh.2

theorem walk_at {f : Nat → Nat} {c last : Nat} {ps : List Nat}
    (h : checkWalk f c ps last = true) (j : Nat) (hj : j < ps.length) :
    ps[j] = iterate f j c := by
  induction ps generalizing c j with
  | nil => simp at hj
  | cons p ps ih =>
    have hh := Bool.and_eq_true_iff.mp h
    have hc : c = p := by simpa using hh.1
    cases j with
    | zero => simpa [iterate] using hc.symm
    | succ j => exact ih hh.2 j (by simpa using hj)

theorem walk_first {f : Nat → Nat} {c : Nat} {ps : List Nat}
    (h : checkWalk f c ps c = true) (hp : 0 < ps.length) (hd : ps.Nodup) :
    FirstReturn f c ps.length := by
  refine ⟨hp, walk_end h, ?_⟩
  intro j hj hjn heq
  have eqv : ps[j] = ps[0] := (walk_at h j hjn).trans (heq.trans (walk_at h 0 hp).symm)
  have := hd.eq_of_getElem_eq hjn hp eqv
  omega

/-- An edge of the supplied walk lands later in the prefix or at its terminal. -/
theorem walk_edges {f : Nat → Nat} {c last : Nat} {ps : List Nat}
    (h : checkWalk f c ps last = true) :
    ∀ p ∈ ps, f p ∈ ps.tail ∨ f p = last := by
  induction ps generalizing c with
  | nil => simp
  | cons p ps ih =>
    have hh := Bool.and_eq_true_iff.mp h
    have hc : c = p := by simpa using hh.1
    subst c
    intro q hq
    rcases List.mem_cons.mp hq with rfl | hq
    · cases ps with
      | nil => exact Or.inr (by simpa [checkWalk] using hh.2)
      | cons r rs =>
        exact Or.inl (by have hr : f q = r := by simpa using (Bool.and_eq_true_iff.mp hh.2).1
                         simp [hr])
    · rcases ih hh.2 q hq with hi | hi
      · exact Or.inl (List.mem_of_mem_tail hi)
      · exact Or.inr hi

/-- A distinct prefix, terminal repeated away from the start: no positive
iterate can return. This is a finite invariant, not bounded experimentation. -/
theorem tail_never_returns {f : Nat → Nat} {c last : Nat} {ps : List Nat}
    (h : checkWalk f c ps last = true) (hd : ps.Nodup)
    (hl : last ∈ ps) (hne : last ≠ c) :
    ∀ k, 0 < k → iterate f k c ≠ c := by
  cases ps with
  | nil => simp at hl
  | cons p ps =>
    have hh := Bool.and_eq_true_iff.mp h
    have hc : c = p := by simpa using hh.1
    subst p
    have hn : c ∉ ps := (List.nodup_cons.mp hd).1
    have hlast : last ∈ ps := (List.mem_cons.mp hl).resolve_left hne
    have hedge : ∀ q ∈ c :: ps, f q ∈ ps := by
      intro q hq
      rcases walk_edges h q hq with hi | hi
      · exact hi
      · simpa [hi] using hlast
    have hall : ∀ n, iterate f (n+1) c ∈ ps := by
      intro n
      induction n with
      | zero => exact hedge c (by simp)
      | succ n ih => rw [iterate_succ]; exact hedge _ (List.mem_cons_of_mem _ ih)
    intro k hk he
    cases k with
    | zero => omega
    | succ n => exact hn (he ▸ hall n)

def lcmAll : List Nat → Nat
  | [] => 1
  | n :: ns => Nat.lcm n (lcmAll ns)

theorem lcmAll_dvd (ns : List Nat) (k : Nat) : lcmAll ns ∣ k ↔ ∀ n ∈ ns, n ∣ k := by
  induction ns with
  | nil => simp [lcmAll]
  | cons n ns ih => simp [lcmAll, Nat.lcm_dvd_iff, ih]

theorem lcmAll_positive {ns : List Nat} (h : ∀ n ∈ ns, 0 < n) : 0 < lcmAll ns := by
  induction ns with
  | nil => decide
  | cons n ns ih => exact Nat.lcm_pos (h n (by simp)) (ih (fun j hj => h j (by simp [hj])))

/-- Arithmetic stated in the archive's multiplication/division order. -/
theorem lcm_update (a b : Nat) : a * (b / Nat.gcd a b) = Nat.lcm a b := by
  exact (Nat.mul_div_assoc a (Nat.gcd_dvd_right a b)).symm

/-- Every positive return has a first positive return, even without assuming a
finite carrier. Finiteness is needed for a finite family's common bound. -/
theorem first_of_return {f : α → α} {c : α} {n : Nat}
    (hp : 0 < n) (hr : iterate f n c = c) : ∃ j, FirstReturn f c j := by
  classical
  induction n using Nat.strongRecOn with
  | ind n ih =>
    by_cases hsmall : ∃ j, 0 < j ∧ j < n ∧ iterate f j c = c
    · obtain ⟨j, hj, hjn, hret⟩ := hsmall
      exact ih j hjn hj hret
    · exact ⟨n, hp, hr, fun j hj hjn hret => hsmall ⟨j, hj, hjn, hret⟩⟩

/-- For a finite family of requirements, one positive count exists exactly
when each requirement lies on its member's cycle. Neither direction samples
payload values or assumes that the whole graph is invertible. -/
theorem finite_common_return_iff (xs : List ι) (f : ι → α → α) (c : ι → α) :
    (∃ k, 0 < k ∧ ∀ i ∈ xs, iterate (f i) k (c i) = c i) ↔
      (∀ i ∈ xs, ∃ n, FirstReturn (f i) (c i) n) := by
  classical
  constructor
  · rintro ⟨k, hk, h⟩ i hi
    exact first_of_return hk (h i hi)
  · intro h
    let period := fun i => if hi : i ∈ xs then Classical.choose (h i hi) else 1
    have hf : ∀ i ∈ xs, FirstReturn (f i) (c i) (period i) := by
      intro i hi; simpa [period, hi] using Classical.choose_spec (h i hi)
    let lengths := xs.map period
    refine ⟨lcmAll lengths, lcmAll_positive ?_, ?_⟩
    · intro n hn
      obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hn
      exact (hf i hi).1
    · intro i hi
      apply (return_iff_dvd (hf i hi) _).mpr
      exact (lcmAll_dvd lengths _).mp (Nat.dvd_refl _) _ (List.mem_map.mpr ⟨i, hi, rfl⟩)

end U11
