import U11.ContractCases

namespace U11.Examples
open U5 U7 U11.ContractCases

/-- H = {(a,c,b), (b,c,a)}, Q = a: return count 3, universally and minimally. -/
theorem first_three : UniversalReturn ReturnFirst ReturnFirstHidden 3 ∧
    ∀ k, 0 < k → UniversalReturn ReturnFirst ReturnFirstHidden k → 3 ≤ k := by
  have h := U11.check_sound ReturnFirst_observed
  exact ⟨h.2.2.1, fun k hk hu => Nat.le_of_dvd hk (h.2.2.2 k hu)⟩

/-- The SAME two members and the stronger Question = (a,b,c) require 6. -/
theorem whole_six : UniversalReturn ReturnWhole ReturnWholeHidden 6 ∧
    ∀ k, 0 < k → UniversalReturn ReturnWhole ReturnWholeHidden k → 6 ≤ k := by
  have h := U11.check_sound ReturnWhole_observed
  exact ⟨h.2.2.1, fun k hk hu => Nat.le_of_dvd hk (h.2.2.2 k hu)⟩

def pairModel : Model := ⟨.pair (.leaf 0) (.leaf 0),
  .pair (.leaf [false]) (.leaf [true]), .pair (.leaf [false]) (.leaf [true]), []⟩
def identitySwap : List Action := [⟨[false], .pair (.leaf [false]) (.leaf [true])⟩,
  ⟨[true], .pair (.leaf [true]) (.leaf [false])⟩]
def pairCert : U11.Certificate := ⟨[⟨0, [[false]]⟩, ⟨0, [[true]]⟩], [[], []], [0,1],
  [⟨[false], .preserved []⟩, ⟨[true], .preserved []⟩], some (.returned ⟨
    [⟨[false],0,[0,0],1⟩, ⟨[false],1,[1,1],1⟩,
     ⟨[true],0,[0,1,0],2⟩, ⟨[true],1,[1,0,1],2⟩],
    [⟨1,1,1⟩, ⟨1,1,1⟩, ⟨1,2,2⟩, ⟨2,1,2⟩], 2, 1⟩)⟩
theorem pair_checked : U11.check pairModel identitySwap pairCert = true := by decide

theorem identity_swap_two : UniversalReturn pairModel identitySwap 2 ∧
    ∀ k, 0 < k → UniversalReturn pairModel identitySwap k → 2 ≤ k := by
  have h := U11.check_sound pair_checked
  exact ⟨h.2.2.1, fun k hk hu => Nat.le_of_dvd hk (h.2.2.2 k hu)⟩

/-- h(a,b) = (a,a): the original a returns at the obligatory first call. -/
theorem duplicate_a_one : UniversalReturn FixedQuestion FixedQuestionHidden 1 :=
  (U11.check_sound FixedQuestion_observed).2.2.1

/-- h(a,b) = (a,a): one Boolean filling witnesses nonreturn of original b at
ALL positive counts, not merely failure of a proposed count. -/
theorem duplicate_b_never : ∃ a ∈ TailQuestionHidden, ∃ x : Path → Bool,
    Gamma TailQuestion bits x ∧ ∀ k, 0 < k →
      TailQuestion.question.map (repeatAct a k x) ≠ TailQuestion.question.map x :=
  U11.check_sound TailQuestion_observed

theorem duplicate_b_no_common : ¬ ∃ k, 0 < k ∧ UniversalReturn TailQuestion TailQuestionHidden k :=
  checked_tail_no_common TailQuestion_observed rfl

/-- The preservation refusal cannot be converted to a nonreturn claim. -/
theorem preservation_refusal_can_return :
    UniversalReturn ReturnBadPreservation ReturnBadPreservationHidden 1 := by
  intro α i x _ a ha
  have heq : a = ⟨[], .pair (.leaf [false]) (.pair (.leaf [true,true]) (.leaf [true,true]))⟩ := by
    simpa [ReturnBadPreservationHidden] using ha
  subst a
  rfl

end U11.Examples
