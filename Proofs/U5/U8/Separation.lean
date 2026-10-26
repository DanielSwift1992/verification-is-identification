import U8.Model

namespace U8
open U5 U7

/-- A mathematical separating interpretation, not a computation in the reader. -/
noncomputable def classBit (m : Model) (root p : Path) : Bool := by
  classical
  exact decide (Closure m.edges root p)

theorem classBit_gamma (m : Model) (root : Path) : Gamma m bits (classBit m root) := by
  classical
  refine ⟨fun _ _ _ => trivial, ?_⟩
  intro e he
  have hi : Closure m.edges root e.left ↔ Closure m.edges root e.right :=
    ⟨fun h => .trans h (.edge he), fun h => .trans h (.symm (.edge he))⟩
  simp only [classBit]
  exact congrArg (fun p : Prop => decide p) (propext hi)

theorem classBit_distinguishes {m : Model} {p q : Path}
    (h : ¬ Closure m.edges p q) : classBit m p p ≠ classBit m p q := by
  classical
  simp [classBit, Closure.refl, h]

theorem missing_witness {m : Model} {view : Term Path} {target : Path}
    (h : ¬ Held m view target) :
    ∃ x y : Path → Bool, Gamma m bits x ∧ Gamma m bits y ∧
      view.map x = view.map y ∧ x target ≠ y target := by
  classical
  let x : Path → Bool := fun _ => false
  refine ⟨x, classBit m target, ⟨fun _ _ _ => trivial, fun _ _ => rfl⟩,
    classBit_gamma m target, ?_, ?_⟩
  · apply Term.map_eq_of_values
    intro p hp
    have hn : ¬ Closure m.edges target p := fun he => h ⟨p, hp, .symm he⟩
    simp [x, classBit, hn]
  · simp [x, classBit, Closure.refl]

theorem outside_no_common {m : Model} {hs : List Action} {view : Term Path}
    {a : Action} {p : Path} (ha : a ∈ hs) (hp : p ∈ view.values)
    (hout : ¬ Held m view (pull a p)) : ¬ CommonAt m hs view bits := by
  obtain ⟨x, y, hx, hy, heq, hdiff⟩ := missing_witness hout
  obtain ⟨address, haddr⟩ := U6.lookup_of_mem_values hp
  rintro ⟨k, hk⟩
  have hv := (hk x hx a ha).symm.trans ((congrArg k heq).trans (hk y hy a ha))
  have leaf := congrArg (fun t => t.lookup address) hv
  simp only [Term.lookup_map, haddr, Option.map_some, Option.some.injEq] at leaf
  exact hdiff leaf

theorem disagreement_witness {m : Model} {a b : Action} {view : Term Path} {p : Path}
    (hp : p ∈ view.values) (hd : ¬ Closure m.edges (pull a p) (pull b p)) :
    ∃ x : Path → Bool, Gamma m bits x ∧ view.map (act a x) ≠ view.map (act b x) := by
  obtain ⟨address, haddr⟩ := U6.lookup_of_mem_values hp
  refine ⟨classBit m (pull a p), classBit_gamma m _, ?_⟩
  intro hsame
  have leaf := congrArg (fun t => t.lookup address) hsame
  simp only [Term.lookup_map, haddr, Option.map_some, Option.some.injEq] at leaf
  exact classBit_distinguishes hd leaf

theorem disagreement_no_common {m : Model} {hs : List Action} {view : Term Path}
    {a b : Action} {p : Path} (ha : a ∈ hs) (hb : b ∈ hs) (hp : p ∈ view.values)
    (hd : ¬ Closure m.edges (pull a p) (pull b p)) : ¬ CommonAt m hs view bits := by
  obtain ⟨x, hx, hdiff⟩ := disagreement_witness hp hd
  rintro ⟨k, hk⟩
  exact hdiff ((hk x hx a ha).symm.trans (hk x hx b hb))

/-- The disagreement already fixes the WHOLE source, not only a held cut. -/
theorem disagreement_no_source_decoder {m : Model} {hs : List Action} {view : Term Path}
    {a b : Action} {p : Path} (ha : a ∈ hs) (hb : b ∈ hs) (hp : p ∈ view.values)
    (hd : ¬ Closure m.edges (pull a p) (pull b p)) :
    ¬ ∃ k : (Path → Bool) → Term Bool, ∀ x, Gamma m bits x →
      ∀ a ∈ hs, k x = view.map (act a x) := by
  obtain ⟨x, hx, hdiff⟩ := disagreement_witness hp hd
  rintro ⟨k, hk⟩
  exact hdiff ((hk x hx a ha).symm.trans (hk x hx b hb))

end U8
