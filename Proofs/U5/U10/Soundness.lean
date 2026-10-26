import U10.Unbound

namespace U10
open U5

def Claim (r : Request) (c : Certificate) : Prop :=
  match c.conclusion with
  | .constructed p =>
    Legal r p.step ∧ residualCount p.residual = lower r c.classes c.outputClasses ∧
    (∀ (α : Type) (i : Interpretation α) x, Gamma r.source i x →
      run p.decoder.program ((jointView p.step p.residual).map x) = some (r.source.question.map x)) ∧
    (∀ alternative d, Legal r alternative →
      (∃ f : Term Bool → Term Bool, ∀ x, Gamma r.source bits x →
        f ((jointView alternative d).map x) = r.source.question.map x) →
      residualCount p.residual ≤ residualCount d)
  | _ => ¬ ∃ p, Legal r p

theorem check_sound {r : Request} {c : Certificate} (h : check r c = true) : Claim r c := by
  cases hc : c.conclusion with
  | constructed p => simpa only [Claim,hc] using constructed_sound h hc
  | unavailable u => simpa only [Claim,hc] using refused_sound h (by intro p; simp [hc])
  | wrongSort b => simpa only [Claim,hc] using refused_sound h (by intro p; simp [hc])
  | incompatible a b => simpa only [Claim,hc] using refused_sound h (by intro p; simp [hc])
end U10
