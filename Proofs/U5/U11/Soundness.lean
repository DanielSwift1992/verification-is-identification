import U11.Certificate

namespace U11
open U5 U6 U7

structure Admission (m : Model) (hs : List Action) (c : Certificate) : Prop where
  valid : m.valid = true
  nonempty : hs ≠ []
  actions : ∀ a ∈ hs, checkAction m a = true
  partition : checkPartition m c.classes = true
  forests : checkForests m c.classes c.connections = true
  evidence : checkPairs (checkEvidence m c.classes) hs c.hiddenActions = true

theorem base_sound {m : Model} {hs : List Action} {c : Certificate}
    (h : checkBase m hs c = true) : Admission m hs c := by
  simp only [checkBase, Bool.and_eq_true_iff, Bool.not_eq_true',
    List.isEmpty_eq_false_iff, List.all_eq_true] at h
  exact ⟨h.1.1.1.1.1.1.1, h.1.1.1.1.1.1.2, h.1.1.1.1.2, h.1.1.1.2, h.1.1.2, h.2⟩

theorem required_iff {m : Model} {cs : List PartitionClass} {b : Nat} :
    b ∈ required m cs ↔ ∃ p ∈ m.question.values, classAt cs p = b := by
  simp [required, List.mem_map]

theorem pairs_iff {hs : List Action} {rs : List Nat} {a : Action} {b : Nat} :
    (a, b) ∈ pairs hs rs ↔ a ∈ hs ∧ b ∈ rs := by
  simp [pairs, List.mem_flatMap]

theorem cycles_cover {m : Model} {hs : List Action} {cs : List PartitionClass} {b : ReturnBlock}
    (h : checkReturn m hs cs b = true) {a : Action} (ha : a ∈ hs)
    {p : Path} (hp : p ∈ m.question.values) :
    ∃ c ∈ b.cycles, FirstReturn (gamma cs a) (classAt cs p) c.length := by
  simp only [checkReturn, Bool.and_eq_true_iff] at h
  obtain ⟨c, hc, hh⟩ := pairs_left h.1.1.1 (pairs_iff.mpr ⟨ha, required_iff.mpr ⟨p, hp, rfl⟩⟩)
  exact ⟨c, hc, cycle_first hh⟩

theorem cycle_origin {m : Model} {hs : List Action} {cs : List PartitionClass} {b : ReturnBlock}
    (h : checkReturn m hs cs b = true) {c : ReturnCycle} (hc : c ∈ b.cycles) :
    ∃ a ∈ hs, ∃ p ∈ m.question.values, FirstReturn (gamma cs a) (classAt cs p) c.length := by
  simp only [checkReturn, Bool.and_eq_true_iff] at h
  obtain ⟨⟨a, d⟩, hm, hh⟩ := pairs_right h.1.1.1 hc
  obtain ⟨ha, hd⟩ := pairs_iff.mp hm
  obtain ⟨p, hp, heq⟩ := required_iff.mp hd
  exact ⟨a, ha, p, hp, heq ▸ cycle_first hh⟩

theorem return_count {m : Model} {hs : List Action} {cs : List PartitionClass} {b : ReturnBlock}
    (h : checkReturn m hs cs b = true) :
    0 < b.calls ∧ b.calls = lcmAll (b.cycles.map ReturnCycle.length) ∧
      b.additionalCalls + 1 = b.calls := by
  simp only [checkReturn, Bool.and_eq_true_iff, decide_eq_true_eq, beq_iff_eq] at h
  exact ⟨h.1.2, arithmetic_lcm h.1.1.2, h.2⟩

/-- Accepted positive walks establish both universal return and divisibility of
EVERY universal return count by the certified least common count. -/
theorem return_sound {m : Model} {hs : List Action} {c : Certificate} {b : ReturnBlock}
    (ad : Admission m hs c) (he : evidenceHolds c.hiddenActions = true)
    (h : checkReturn m hs c.classes b = true) :
    UniversalReturn m hs b.calls ∧
      ∀ k, UniversalReturn m hs k → b.calls ∣ k := by
  have hpres := evidence_preserves ad.evidence he
  have eqv := return_iff_classes ad.valid ad.partition ad.forests ad.actions hpres
  have cnt := return_count h
  constructor
  · apply (eqv b.calls).mpr
    intro a ha p hp
    obtain ⟨cy, hcy, hfirst⟩ := cycles_cover h ha hp
    apply (return_iff_dvd hfirst b.calls).mpr
    have hd := (lcmAll_dvd (b.cycles.map ReturnCycle.length) b.calls).mp
      (cnt.2.1 ▸ Nat.dvd_refl b.calls)
    exact hd cy.length (List.mem_map.mpr ⟨cy, hcy, rfl⟩)
  · intro k hk
    rw [cnt.2.1]
    apply (lcmAll_dvd _ k).mpr
    intro n hn
    obtain ⟨cy, hcy, rfl⟩ := List.mem_map.mp hn
    obtain ⟨a, ha, p, hp, hfirst⟩ := cycle_origin h hcy
    exact (return_iff_dvd hfirst k).mp ((eqv k).mp hk a ha p hp)

/-- Each first-return length, not just the accumulated LCM, divides any
universal return count. -/
theorem first_length_divides {m : Model} {hs : List Action} {c : Certificate}
    (ad : Admission m hs c) (he : evidenceHolds c.hiddenActions = true)
    {a : Action} (ha : a ∈ hs) {p : Path} (hp : p ∈ m.question.values) {n k : Nat}
    (hf : FirstReturn (gamma c.classes a) (classAt c.classes p) n)
    (hu : UniversalReturn m hs k) : n ∣ k :=
  (return_iff_dvd hf k).mp
    ((return_iff_classes ad.valid ad.partition ad.forests ad.actions
      (evidence_preserves ad.evidence he) k).mp hu a ha p hp)

theorem checked_return_counts_iff {m : Model} {hs : List Action} {c : Certificate} {b : ReturnBlock}
    (ad : Admission m hs c) (he : evidenceHolds c.hiddenActions = true)
    (h : checkReturn m hs c.classes b = true) (k : Nat) :
    UniversalReturn m hs k ↔ b.calls ∣ k := by
  constructor
  · exact (return_sound ad he h).2 k
  · intro hd
    apply (return_iff_classes ad.valid ad.partition ad.forests ad.actions
      (evidence_preserves ad.evidence he) k).mpr
    intro a ha p hp
    obtain ⟨cy, hcy, hf⟩ := cycles_cover h ha hp
    apply (return_iff_dvd hf k).mpr
    have hdiv := first_length_divides ad he ha hp hf (return_sound ad he h).1
    exact Nat.dvd_trans hdiv hd

theorem least_positive {m : Model} {hs : List Action} {c : Certificate} {b : ReturnBlock}
    (ad : Admission m hs c) (he : evidenceHolds c.hiddenActions = true)
    (h : checkReturn m hs c.classes b = true) {k : Nat}
    (hk : 0 < k) (hu : UniversalReturn m hs k) : b.calls ≤ k :=
  Nat.le_of_dvd hk ((return_sound ad he h).2 k hu)

/-- One Boolean filling separates the original class from ALL positive images. -/
theorem tail_witness {m : Model} {hs : List Action} {c : Certificate}
    (ad : Admission m hs c) (he : evidenceHolds c.hiddenActions = true)
    {a : Action} (ha : a ∈ hs) {p : Path} (hp : p ∈ m.question.values)
    (hn : ∀ k, 0 < k → iterate (gamma c.classes a) k (classAt c.classes p) ≠ classAt c.classes p) :
    ∃ x : Path → Bool, Gamma m bits x ∧
      ∀ k, 0 < k → m.question.map (repeatAct a k x) ≠ m.question.map x := by
  obtain ⟨s, hs⟩ := question_source ad.valid hp
  obtain ⟨q, hq⟩ := U6.lookup_of_mem_values hp
  refine ⟨U8.classBit m p, U8.classBit_gamma m p, ?_⟩
  intro k hk heq
  have hpull := iter_commutes ad.partition ad.forests (ad.actions a ha)
    (evidence_preserves ad.evidence he a ha) hs k
  have hneq : ¬ Closure m.edges p (iterate (pull a) k p) := by
    intro hh
    have same := (classAt_closure ad.partition ad.forests hs (iter_sort (ad.actions a ha) hs k)).mpr hh
    exact hn k hk (hpull.trans same.symm)
  have v := congrArg (fun t => t.lookup q) heq
  simp only [Term.lookup_map, hq, Option.map_some, Option.some.injEq, repeatAct] at v
  exact U8.classBit_distinguishes hneq v.symm

theorem tail_sound {m : Model} {hs : List Action} {c : Certificate} {t : ReturnTail}
    (ad : Admission m hs c) (he : evidenceHolds c.hiddenActions = true)
    (h : checkTail m hs c.classes t = true) :
    ∃ a ∈ hs, ∃ x : Path → Bool, Gamma m bits x ∧
      ∀ k, 0 < k → m.question.map (repeatAct a k x) ≠ m.question.map x := by
  cases ha : hs.find? (fun a => a.member == t.member) with
  | none => simp [checkTail, ha] at h
  | some a =>
    cases hl : t.vertices.getLast? with
    | none => simp [checkTail, ha, hl] at h
    | some last =>
      simp only [checkTail, ha, hl, Bool.and_eq_true_iff, beq_iff_eq, bne_iff_ne] at h
      have hreq : t.block ∈ required m c.classes := by simpa using h.1.1.1.1
      obtain ⟨p, hp, hpb⟩ := required_iff.mp hreq
      have shape := h.1.1.1.2
      simp only [checkWalkShape, Bool.and_eq_true_iff, decide_eq_true_eq] at shape
      have hn := tail_never_returns h.1.1.2 shape.2
        (List.mem_of_getElem? h.1.2) h.2
      have ham := List.mem_of_find?_eq_some ha
      obtain ⟨x, hx, hxk⟩ := tail_witness ad he ham hp (hpb ▸ hn)
      exact ⟨a, ham, x, hx, hxk⟩

/-- Three different conclusions. Refusal of preservation makes no U11 claim. -/
def Claim (m : Model) (hs : List Action) (c : Certificate) : Prop :=
  match c.conclusion with
  | none => ∃ a ∈ hs, ∃ x : Path → Bool, Gamma m bits x ∧ ¬ Compatible m (act a x)
  | some (.returned b) => 0 < b.calls ∧ b.additionalCalls + 1 = b.calls ∧
      UniversalReturn m hs b.calls ∧ ∀ k, UniversalReturn m hs k → b.calls ∣ k
  | some (.obstructed _) => ∃ a ∈ hs, ∃ x : Path → Bool, Gamma m bits x ∧
      ∀ k, 0 < k → m.question.map (repeatAct a k x) ≠ m.question.map x

theorem check_sound {m : Model} {hs : List Action} {c : Certificate}
    (h : check m hs c = true) : Claim m hs c := by
  have hh := Bool.and_eq_true_iff.mp h
  have ad := base_sound hh.1
  cases hc : c.conclusion with
  | none =>
    have hn : evidenceHolds c.hiddenActions = false := by simpa [hc] using hh.2
    simpa [Claim, hc] using evidence_refusal ad.evidence hn
  | some conclusion =>
    cases conclusion with
    | returned b =>
      have hr : evidenceHolds c.hiddenActions = true ∧ checkReturn m hs c.classes b = true := by
        simpa [hc] using hh.2
      have cnt := return_count hr.2
      simpa [Claim, hc] using And.intro cnt.1 (And.intro cnt.2.2 (return_sound ad hr.1 hr.2))
    | obstructed t =>
      have ht : evidenceHolds c.hiddenActions = true ∧ checkTail m hs c.classes t = true := by
        simpa [hc] using hh.2
      simpa [Claim, hc] using tail_sound ad ht.1 ht.2

theorem checked_tail_no_common {m : Model} {hs : List Action} {c : Certificate} {t : ReturnTail}
    (h : check m hs c = true) (hc : c.conclusion = some (.obstructed t)) :
    ¬ ∃ k, 0 < k ∧ UniversalReturn m hs k := by
  have hh := check_sound h
  simp only [Claim, hc] at hh
  obtain ⟨a, ha, x, hx, hn⟩ := hh
  rintro ⟨k, hk, hu⟩
  exact hn k hk (hu Bool bits x hx a ha)

theorem accepted_nonempty {m : Model} {hs : List Action} {c : Certificate}
    (h : check m hs c = true) (i : Interpretation α) : ∃ x, Gamma m i x :=
  compatible_nonempty m (base_sound (Bool.and_eq_true_iff.mp h).1).valid i

/-- The two sides of U11 on the admitted U3 model, independently of a submitted
certificate: one positive repeat block iff every required class is cyclic. -/
theorem universal_return_iff_cycles {m : Model} {hs : List Action} {cs : List PartitionClass}
    {forests : List (List Step)} (hm : m.valid = true)
    (hp : checkPartition m cs = true) (hf : checkForests m cs forests = true)
    (ha : ∀ a ∈ hs, checkAction m a = true) (he : ∀ a ∈ hs, Preserves m a) :
    (∃ k, 0 < k ∧ UniversalReturn m hs k) ↔
      ∀ a ∈ hs, ∀ p ∈ m.question.values,
        ∃ n, FirstReturn (gamma cs a) (classAt cs p) n := by
  have eqv := return_iff_classes hm hp hf ha he
  have finite := finite_common_return_iff (pairs hs (required m cs))
    (fun ab => gamma cs ab.1) Prod.snd
  constructor
  · rintro ⟨k, hk, hu⟩ a ha p hp
    exact first_of_return hk ((eqv k).mp hu a ha p hp)
  · intro h
    have all : ∀ ab ∈ pairs hs (required m cs),
        ∃ n, FirstReturn (gamma cs ab.1) ab.2 n := by
      rintro ⟨a, b⟩ hab
      obtain ⟨ha, hb⟩ := pairs_iff.mp hab
      obtain ⟨p, hp, heq⟩ := required_iff.mp hb
      exact heq ▸ h a ha p hp
    obtain ⟨k, hk, hret⟩ := finite.mpr all
    refine ⟨k, hk, (eqv k).mpr ?_⟩
    intro a ha p hp
    exact hret (a, classAt cs p) (pairs_iff.mpr ⟨ha, required_iff.mpr ⟨p, hp, rfl⟩⟩)

end U11
