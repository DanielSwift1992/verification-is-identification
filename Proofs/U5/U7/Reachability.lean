import U7.Certificate

namespace U7
open U5

/-- The least E-saturated set of question occurrences closed under all actions.
Saturation makes this precisely a set of E-classes, represented by occurrences. -/
inductive Reach (m : Model) (gs : List Action) : Path → Prop where
  | question {p} : p ∈ m.question.values → Reach m gs p
  | equiv {p q} : Reach m gs p → Closure m.edges p q → Reach m gs q
  | step {p a} : a ∈ gs → Reach m gs p → Reach m gs (pull a p)

def Retained (m : Model) (s : StableView) (p : Path) : Prop :=
  ∃ representative ∈ s.view.values, Closure m.edges representative p

theorem word_reachable {m : Model} {gs : List Action} {word : List Path}
    {p q : Path} (hp : Reach m gs p) (hw : pullWord gs word p = some q) :
    Reach m gs q := by
  induction word generalizing p with
  | nil => simp [pullWord] at hw; subst q; exact hp
  | cons n ns ih =>
    cases ha : gs.find? (fun a => a.member == n) with
    | none => simp [pullWord, ha] at hw
    | some a =>
      exact ih (.step (List.mem_of_find?_eq_some ha) hp) (by simpa [pullWord, ha] using hw)

theorem reach_witness {m : Model} {gs : List Action} {cs : List PartitionClass}
    {p : Path} {w : ReachableClass} (h : checkReach m gs cs p w = true) :
    Reach m gs p := by
  have hh := (Bool.and_eq_true_iff.mp h).2
  cases hq : m.question.lookup w.question with
  | none => simp [hq] at hh
  | some origin =>
    cases hw : pullWord gs w.word origin with
    | none => simp [hq, hw] at hh
    | some dest =>
      simp [hq, hw] at hh
      exact .equiv (word_reachable (.question (Term.mem_values_of_lookup hq)) hw) (basis_sound hh.2)

theorem retained_reachable {m : Model} {gs : List Action} {cs : List PartitionClass}
    {s : StableView} (h : checkStable m gs cs s = true) {p : Path}
    (hp : Retained m s p) : Reach m gs p := by
  obtain ⟨r, hr, hc⟩ := hp
  rw [stable_view_values h] at hr
  obtain ⟨w, _, hw⟩ := pairs_left (stable_reaches h) hr
  exact .equiv (reach_witness hw) hc

theorem reachable_retained {m : Model} {gs : List Action} {cs : List PartitionClass}
    {s : StableView} (h : checkStable m gs cs s = true)
    (hg : ∀ a ∈ gs, Preserves m a) {p : Path} (hp : Reach m gs p) :
    Retained m s p := by
  induction hp with
  | question hq =>
    obtain ⟨addr, origin, hl, he⟩ := U6.construction_covers (stable_decoder h) _ hq
    exact ⟨origin, Term.mem_values_of_lookup hl, he⟩
  | equiv _ he ih =>
    obtain ⟨r, hr, hc⟩ := ih
    exact ⟨r, hr, .trans hc he⟩
  | @step p a ha _ ih =>
    obtain ⟨r, hr, hc⟩ := ih
    obtain ⟨image, _, hi⟩ := pairs_left (stable_images h) ha
    have him : pull a r ∈ (s.view.map (pull a)).values := by
      rw [U6.values_map]
      exact List.mem_map.mpr ⟨r, hr, rfl⟩
    obtain ⟨addr, origin, hl, he⟩ := U6.construction_covers (image_construction hi) _ him
    exact ⟨origin, Term.mem_values_of_lookup hl, .trans he (preserves_closure (hg _ ha) hc)⟩

/-- Both directions are essential: witnesses prevent an over-large view;
decoder and closure prevent an under-large view. -/
theorem closure_exact {m : Model} {gs : List Action} {cs : List PartitionClass}
    {s : StableView} (h : checkStable m gs cs s = true)
    (hg : ∀ a ∈ gs, Preserves m a) (p : Path) :
    Retained m s p ↔ Reach m gs p :=
  ⟨retained_reachable h, reachable_retained h hg⟩

theorem reach_least {m : Model} {gs : List Action} (C : Path → Prop)
    (hq : ∀ p ∈ m.question.values, C p)
    (he : ∀ p q, C p → Closure m.edges p q → C q)
    (hg : ∀ a ∈ gs, ∀ p, C p → C (pull a p))
    {p : Path} (hp : Reach m gs p) : C p := by
  induction hp with
  | question h => exact hq _ h
  | equiv _ h ih => exact he _ _ ih h
  | step h _ ih => exact hg _ h _ ih

/-- Leastness is among ALL E-saturated, action-closed sets containing Q,
not merely among lists produced by one fixed-point search. -/
theorem stable_least {m : Model} {gs : List Action} {cs : List PartitionClass}
    {s : StableView} (h : checkStable m gs cs s = true) (C : Path → Prop)
    (hq : ∀ p ∈ m.question.values, C p)
    (he : ∀ p q, C p → Closure m.edges p q → C q)
    (hg : ∀ a ∈ gs, ∀ p, C p → C (pull a p))
    {p : Path} (hp : Retained m s p) : C p :=
  reach_least C hq he hg (retained_reachable h hp)

/-- Containment and closedness, together with stable_least, specify the least
fixed point. An arbitrary over-approximation would not satisfy the witness half. -/
theorem stable_closed {m : Model} {gs : List Action} {cs : List PartitionClass}
    {s : StableView} (h : checkStable m gs cs s = true)
    (hg : ∀ a ∈ gs, Preserves m a) :
    (∀ p ∈ m.question.values, Retained m s p) ∧
    (∀ p q, Retained m s p → Closure m.edges p q → Retained m s q) ∧
    (∀ a ∈ gs, ∀ p, Retained m s p → Retained m s (pull a p)) := by
  refine ⟨fun _ hp => reachable_retained h hg (.question hp), ?_, ?_⟩
  · intro p q hp he
    exact reachable_retained h hg (.equiv (retained_reachable h hp) he)
  · intro a ha p hp
    exact reachable_retained h hg (.step ha (retained_reachable h hp))

theorem stable_size_bound {m : Model} {gs : List Action} {cs : List PartitionClass}
    {s : StableView} (h : checkStable m gs cs s = true) :
    s.view.values.length ≤ cs.length := by
  rw [stable_view_values h]
  simp only [checkStable, Bool.and_eq_true_iff, decide_eq_true_eq] at h
  exact h.1.1.1.1.1.1.1

end U7
