import U7.Refusal

namespace U7
open U5

/-- Physical application is right to left, agreeing with pullWord's left-to-right
pullback. These are words of already selected members, not an extra input reader. -/
def applyWord : List Action → (Path → α) → Path → α
  | [], x => x
  | a :: word, x => act a (applyWord word x)

def runImages : List ImageAction → Term α → Option (Term α)
  | [], z => some z
  | image :: rest, z => do
    let next ← runImages rest z
    run image.construction.program next

def resolveWord (gs : List Action) : List Path → Option (List Action)
  | [] => some []
  | name :: names => do
    let a ← gs.find? (fun a => a.member == name)
    let rest ← resolveWord gs names
    pure (a :: rest)

/-- The certificate's addressed word denotes exactly the physical composite,
not the opposite order. This connects the reachability witness to semantics. -/
theorem addressed_word_semantics {gs : List Action} {names : List Path}
    {word : List Action} {p q : Path}
    (hr : resolveWord gs names = some word) (hp : pullWord gs names p = some q)
    (x : Path → α) : applyWord word x p = x q := by
  induction names generalizing word p with
  | nil =>
    simp [resolveWord] at hr
    simp [pullWord] at hp
    subst word; subst q; rfl
  | cons name names ih =>
    cases ha : gs.find? (fun a => a.member == name) with
    | none => simp [resolveWord, ha] at hr
    | some a =>
      cases hw : resolveWord gs names with
      | none => simp [resolveWord, ha, hw] at hr
      | some rest =>
        have heq : a :: rest = word := by simpa [resolveWord, ha, hw] using hr
        subst word
        have hi := ih hw (p := pull a p) (by simpa [pullWord, ha] using hp)
        exact hi

theorem word_gamma {m : Model} {word : List Action}
    (hv : ∀ a ∈ word, checkAction m a = true)
    (hp : ∀ a ∈ word, Preserves m a)
    {i : Interpretation α} {x : Path → α} (hx : Gamma m i x) :
    Gamma m i (applyWord word x) := by
  induction word with
  | nil => exact hx
  | cons a word ih =>
    exact action_gamma (hv a (by simp)) (hp a (by simp))
      (ih (fun a ha => hv a (List.mem_cons_of_mem _ ha))
        (fun a ha => hp a (List.mem_cons_of_mem _ ha)))

theorem words_commute {m : Model} {cs : List PartitionClass} {s : StableView}
    {word : List Action} {images : List ImageAction}
    (hv : ∀ a ∈ word, checkAction m a = true)
    (hp : ∀ a ∈ word, Preserves m a)
    (hc : checkPairs (checkImage m cs s) word images = true)
    (i : Interpretation α) (x : Path → α) (hx : Gamma m i x) :
    runImages images (s.view.map x) = some (s.view.map (applyWord word x)) := by
  induction word generalizing images with
  | nil => cases images <;> simp_all [checkPairs, runImages, applyWord]
  | cons a word ih =>
    cases images with
    | nil => simp [checkPairs] at hc
    | cons image images =>
      have hh := Bool.and_eq_true_iff.mp hc
      have hvw := fun b hb => hv b (List.mem_cons_of_mem a hb)
      have hpw := fun b hb => hp b (List.mem_cons_of_mem a hb)
      have hw := ih hvw hpw hh.2
      simp only [runImages, hw, applyWord]
      exact image_commutes hh.1 i _ (word_gamma hvw hpw hx)

/-- All observations after a word can be decoded from the same initial V. -/
theorem word_question {m : Model} {gs : List Action} {cs : List PartitionClass}
    {s : StableView} (hs : checkStable m gs cs s = true)
    {word : List Action} {images : List ImageAction}
    (hv : ∀ a ∈ word, checkAction m a = true)
    (hp : ∀ a ∈ word, Preserves m a)
    (hc : checkPairs (checkImage m cs s) word images = true)
    (i : Interpretation α) (x : Path → α) (hx : Gamma m i x) :
    (runImages images (s.view.map x)).bind (run s.decoder.program) =
      some (m.question.map (applyWord word x)) := by
  rw [words_commute hv hp hc i x hx]
  exact question_decodes hs i _ (word_gamma hv hp hx)

def Claim (m : Model) (gs : List Action) (c : Certificate)
    (i : Interpretation α) (x : Path → α) : Prop :=
  match c.stable with
  | none => ¬ ∀ (β : Type) (j : Interpretation β) (y : Path → β), Gamma m j y →
      ∀ a ∈ gs, Gamma m j (act a y)
  | some s => (∀ p, Retained m s p ↔ Reach m gs p) ∧
      run s.decoder.program (s.view.map x) = some (m.question.map x) ∧
      ∀ a ∈ gs, Gamma m i (act a x) ∧
        ∃ image ∈ s.actions, image.member = a.member ∧
          run image.construction.program (s.view.map x) = some (s.view.map (act a x))

theorem check_sound {m : Model} {gs : List Action} {c : Certificate}
    (h : check m gs c = true) :
    ∀ (α : Type) (i : Interpretation α) (x : Path → α), Gamma m i x → Claim m gs c i x := by
  intro α i x hx
  cases hs : c.stable with
  | none => simpa only [Claim, hs] using refusal_not_universal h hs
  | some s =>
    have hh := check_stable_sound h hs
    simp only [Claim, hs]
    exact ⟨hh.1, hh.2 α i x hx⟩

end U7
