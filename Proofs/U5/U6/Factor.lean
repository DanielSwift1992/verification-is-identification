import U6.Partition

namespace U6
open U5

@[simp] theorem values_map (t : Term α) (f : α → β) : (t.map f).values = t.values.map f := by
  induction t with
  | leaf a => rfl
  | pair l r ihl ihr => simp [Term.map, Term.values, ihl, ihr]

theorem lookup_of_mem_values {t : Term α} {a : α} (h : a ∈ t.values) :
    ∃ p, t.lookup p = some a := by
  induction t with
  | leaf b => simp [Term.values] at h; subst a; exact ⟨[], rfl⟩
  | pair l r ihl ihr =>
    rcases List.mem_append.mp h with hl | hr
    · obtain ⟨p, hp⟩ := ihl hl; exact ⟨false :: p, hp⟩
    · obtain ⟨p, hp⟩ := ihr hr; exact ⟨true :: p, hp⟩

def Covers (m : Model) (observation target : Term Path) : Prop :=
  ∀ p ∈ target.values, ∃ addr origin,
    observation.lookup addr = some origin ∧ Closure m.edges origin p

theorem selections_cover {m : Model} {q : Term Path} {sels : Term Selection} {addr : Path}
    (h : checkSelections m addr q sels = true) : Covers m m.observation q := by
  induction q generalizing sels addr with
  | leaf target =>
    cases sels with
    | pair l r => simp [checkSelections] at h
    | leaf sel =>
      cases hp : m.observation.lookup sel.input with
      | none => simp [checkSelections, hp] at h
      | some origin =>
        simp only [checkSelections, hp, Bool.and_eq_true_iff] at h
        intro p hm
        have heq : p = target := by simpa [Term.values] using hm
        subst p
        exact ⟨sel.input, origin, hp, basis_sound h.2⟩
  | pair l r ihl ihr =>
    cases sels with
    | leaf s => simp [checkSelections] at h
    | pair sl sr =>
      simp only [checkSelections, Bool.and_eq_true_iff] at h
      intro p hp
      rcases List.mem_append.mp hp with hl | hr
      · exact ihl h.1 p hl
      · exact ihr h.2 p hr

theorem construction_covers {m : Model} {c : Construction}
    (h : checkConstruction m c = true) : Covers m m.observation m.question := by
  cases hp : packSelections m.question c.selections with
  | none => simp [checkConstruction, hp] at h
  | some v =>
    obtain ⟨sels, rest⟩ := v
    simp only [checkConstruction, hp, Bool.and_eq_true_iff] at h
    exact selections_cover h.1.2

theorem run_map_sound (target : Term Path) (pick : Path → Path) (input : Term α) (x : Path → α)
    (h : ∀ p ∈ target.values, input.lookup (pick p) = some (x p)) :
    run (target.map pick) input = some (target.map x) := by
  induction target with
  | leaf p => simp [Term.map, run, h p (by simp [Term.values])]
  | pair l r ihl ihr =>
    have hl := ihl (fun p hp => h p (List.mem_append_left _ hp))
    have hr := ihr (fun p hp => h p (List.mem_append_right _ hp))
    simp [Term.map, run, hl, hr]

/-- A uniform U3 factor, derived from source-class coverage, not tested payloads. -/
theorem covers_factor {m : Model} {observation target : Term Path}
    (h : Covers m observation target) :
    ∃ program : Term Path, ∀ (α : Type) (i : Interpretation α) (x : Path → α),
      Gamma m i x → run program (observation.map x) = some (target.map x) := by
  classical
  let pick := fun p => if hp : p ∈ target.values then (h p hp).choose else []
  refine ⟨target.map pick, ?_⟩
  intro α i x hx
  apply run_map_sound
  intro p hp
  obtain ⟨origin, ho, he⟩ := (h p hp).choose_spec
  simp only [pick, dite_eq_left hp, Term.lookup_map, ho, Option.map_some]
  exact congrArg some (closure_sound hx.2 he)

end U6
