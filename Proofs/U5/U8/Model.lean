import U7.Words

namespace U8
open U5 U7

/-- S is represented by the E-saturation of the leaves of this view. Repeated
occurrences are allowed, matching the actual Observation shape in the contract. -/
def Held (m : Model) (view : Term Path) (p : Path) : Prop :=
  ∃ r ∈ view.values, Closure m.edges r p

def Closed (m : Model) (hs : List Action) (view : Term Path) : Prop :=
  ∀ a ∈ hs, ∀ p ∈ view.values, Held m view (pull a p)

def Agrees (m : Model) (hs : List Action) (view : Term Path) : Prop :=
  ∀ a ∈ hs, ∀ b ∈ hs, ∀ p ∈ view.values,
    Closure m.edges (pull a p) (pull b p)

def Conditions (m : Model) (hs : List Action) (view : Term Path) : Prop :=
  Closed m hs view ∧ Agrees m hs view

/-- γ_h(S) ⊆ S and equal restrictions on ALL classes represented by S. -/
def ClassConditions (m : Model) (hs : List Action) (view : Term Path) : Prop :=
  (∀ a ∈ hs, ∀ p, Held m view p → Held m view (pull a p)) ∧
  (∀ a ∈ hs, ∀ b ∈ hs, ∀ p, Held m view p →
    Closure m.edges (pull a p) (pull b p))

/-- k may be ANY deterministic function, chosen for the interpretation, but
chosen once for every hidden member and every compatible source filling. -/
def CommonAt (m : Model) (hs : List Action) (view : Term Path) (i : Interpretation α) : Prop :=
  ∃ k : Term α → Term α, ∀ x, Gamma m i x → ∀ a ∈ hs,
    k (view.map x) = view.map (act a x)

def UniversalCommon (m : Model) (hs : List Action) (view : Term Path) : Prop :=
  ∀ (α : Type) (i : Interpretation α), CommonAt m hs view i

/-- This stronger constructive conclusion has ONE structural program, selected
before the interpretation, filling, and private member. -/
def StructuralCommon (m : Model) (hs : List Action) (view : Term Path) : Prop :=
  ∃ program : Term Path, ∀ (α : Type) (i : Interpretation α) (x : Path → α),
    Gamma m i x → ∀ a ∈ hs,
      run program (view.map x) = some (view.map (act a x))

/-- Given E-preservation, checking representatives is checking their classes. -/
theorem closed_saturation {m : Model} {hs : List Action} {view : Term Path}
    (hc : Closed m hs view) (he : ∀ a ∈ hs, Preserves m a)
    {a : Action} (ha : a ∈ hs) {p : Path} (hp : Held m view p) :
    Held m view (pull a p) := by
  obtain ⟨r, hr, hpr⟩ := hp
  obtain ⟨s, hsm, hsr⟩ := hc a ha r hr
  exact ⟨s, hsm, .trans hsr (preserves_closure (he a ha) hpr)⟩

theorem agreement_saturation {m : Model} {hs : List Action} {view : Term Path}
    (hc : Agrees m hs view) (he : ∀ a ∈ hs, Preserves m a)
    {a b : Action} (ha : a ∈ hs) (hb : b ∈ hs) {p : Path} (hp : Held m view p) :
    Closure m.edges (pull a p) (pull b p) := by
  obtain ⟨r, hr, hpr⟩ := hp
  exact .trans (.symm (preserves_closure (he a ha) hpr))
    (.trans (hc a ha b hb r hr) (preserves_closure (he b hb) hpr))

theorem representatives_iff_classes {m : Model} {hs : List Action} {view : Term Path}
    (he : ∀ a ∈ hs, Preserves m a) :
    Conditions m hs view ↔ ClassConditions m hs view := by
  constructor
  · intro h
    exact ⟨fun _ ha _ hp => closed_saturation h.1 he ha hp,
      fun _ ha _ hb _ hp => agreement_saturation h.2 he ha hb hp⟩
  · intro h
    exact ⟨fun _ ha p hp => h.1 _ ha p ⟨p, hp, .refl p⟩,
      fun _ ha _ hb p hp => h.2 _ ha _ hb p ⟨p, hp, .refl p⟩⟩

end U8
