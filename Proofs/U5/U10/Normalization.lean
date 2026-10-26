import U10.Classes

namespace U10
open U5

def classSort (cs : List PartitionClass) (b : Nat) : SortId :=
  ((cs[b]?).map PartitionClass.sort).getD 0

def root (c : PartitionClass) : Path := c.leaves.headD []
def boundFor (r : Request) (c : PartitionClass) : Option Binding :=
  r.bindings.find? (fun b => c.leaves.contains b.output)
def slot (r : Request) (sc : List PartitionClass) (c : PartitionClass) : Slot :=
  ⟨c.sort, (boundFor r c).map (fun b => (blockOf sc b.source).getD 0)⟩
def normalized (sc oc : List PartitionClass) (p : Term Path) : List Nat :=
  oc.map (fun c => (blockOf sc (U9.origin p (root c))).getD 0)
def required (m : Model) (sc : List PartitionClass) : List Nat :=
  (m.question.values.filterMap (blockOf sc)).eraseDups

theorem block_sort {m : Model} {sc : List PartitionClass} {q : Path} {s b : Nat}
    (hp : checkPartition m sc = true) (hq : m.source.lookup q = some s)
    (hb : blockOf sc q = some b) : classSort sc b = s := by
  obtain ⟨c, hc, hm⟩ := U6.block_member hb
  have hp' := hp
  simp only [checkPartition, Bool.and_eq_true_iff] at hp'
  have ha : ∀ c ∈ sc, ( !c.leaves.isEmpty) = true ∧
      ∀ p ∈ c.leaves, m.source.lookup p = some c.sort := by
    simpa only [List.all_eq_true, Bool.and_eq_true_iff, beq_iff_eq] using hp'.1.2
  have hs := (ha c (List.mem_of_getElem? hc)).2 q hm
  have he : c.sort = s := Option.some.inj (hs.symm.trans hq)
  simp [classSort, hc, he]

theorem class_root {m : Model} {cs : List PartitionClass}
    (hp : checkPartition m cs = true) {c : PartitionClass} (hc : c ∈ cs) :
    root c ∈ c.leaves ∧ m.source.lookup (root c) = some c.sort := by
  have hh : ( !c.leaves.isEmpty) = true ∧ c.leaves.all (fun p => m.source.lookup p == some c.sort) = true := by
    exact Bool.and_eq_true_iff.mp (List.all_eq_true.mp (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp hp).1).2 c hc)
  cases hl : c.leaves with
  | nil => simp [hl] at hh
  | cons p ps =>
    exact ⟨by simp [root,hl], by simpa [root,hl] using List.all_eq_true.mp hh.2 p (by simp [hl])⟩

theorem class_connected {m : Model} {cs : List PartitionClass} {fs : List (List Step)}
    (hf : U6.checkForests m cs fs = true) {c : PartitionClass} (hc : c ∈ cs)
    {u v : Path} (hu : u ∈ c.leaves) (hv : v ∈ c.leaves) : Closure m.edges u v := by
  obtain ⟨index, hi⟩ := List.mem_iff_getElem?.mp hc
  obtain ⟨steps, hs⟩ := U6.forests_at hf hi
  exact U6.forest_sound hs hu hv

theorem pairs_map (xs : List α) (f : α → β) (g : α → γ) (test : β → γ → Bool)
    (h : ∀ x ∈ xs, test (f x) (g x) = true) :
    U7.checkPairs test (xs.map f) (xs.map g) = true := by
  induction xs with
  | nil => rfl
  | cons a rest ih =>
    exact Bool.and_eq_true_iff.mpr ⟨h a (by simp), ih (fun x hx => h x (by simp [hx]))⟩

/-- Every legal U3 step, not merely the constructor's preferred plan, yields
one sort-correct, binding-correct class assignment per output C-class. -/
theorem normalize_assignments {r : Request} {sc oc : List PartitionClass}
    {fs : List (List Step)} {p : Term Path}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hf : U6.checkForests r.target oc fs = true) (hp : Legal r p) :
    checkAssignments (classSort sc) (oc.map (slot r sc)) (normalized sc oc p) = true := by
  apply pairs_map
  intro c hc
  obtain ⟨hroot,ht⟩ := class_root ho hc
  have hsroot := shape_origin hp.1 ht
  obtain ⟨index, hi⟩ := U6.partition_covers hs hsroot
  have hsort := block_sort hs hsroot hi
  change (classSort sc ((blockOf sc (U9.origin p (root c))).getD 0) == c.sort &&
    match (slot r sc c).fixed with
    | none => true | some b => (blockOf sc (U9.origin p (root c))).getD 0 == b) = true
  rw [Bool.and_eq_true_iff]
  constructor
  · simpa [hi] using hsort
  · cases hb : boundFor r c with
    | none => simp [slot,hb]
    | some b =>
      have hmem := List.mem_of_find?_eq_some hb
      have bout : b.output ∈ c.leaves := by
        simpa using List.find?_some hb
      have he := normalize_legal hp (class_connected hf hc hroot bout)
      have he' := Closure.trans he (hp.2.2 b hmem)
      have blocks := U6.closure_same_block hs he'
      simp [slot,hb,blocks]

/-- Every source occurrence selected by P is represented by its output
C-class's normalized assignment. Forests, rather than graph search, witness it. -/
theorem normalized_covers_step {r : Request} {sc oc : List PartitionClass}
    {fs : List (List Step)} {p : Term Path}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hf : U6.checkForests r.target oc fs = true) (hp : Legal r p)
    {a : Path} (ha : a ∈ p.values) {b : Nat} (hb : blockOf sc a = some b) :
    b ∈ normalized sc oc p := by
  obtain ⟨u, hu⟩ := U6.lookup_of_mem_values ha
  obtain ⟨s, hsa⟩ := hp.1.1 a ha
  have hout : r.target.source.lookup u = some s := by
    rw [← hp.1.2]
    simp [U9.output, Term.lookup_map, hu, hsa]
  have covered : ∃ c ∈ oc, u ∈ c.leaves := by
    have hperm : (oc.flatMap PartitionClass.leaves).Perm (r.target.source.entries.map Prod.fst) := by
      exact of_decide_eq_true (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp ho).1).1).2
    have hm := hperm.mem_iff.mpr (List.mem_map.mpr ⟨(u,s), Term.mem_entries.mpr hout, rfl⟩)
    exact List.mem_flatMap.mp hm
  obtain ⟨c,hc,huc⟩ := covered
  have he := normalize_legal hp (class_connected hf hc (class_root ho hc).1 huc)
  have heq : blockOf sc (U9.origin p (root c)) = some b := by
    simpa [U9.origin, hu, hb] using U6.closure_same_block hs he
  exact List.mem_map.mpr ⟨c,hc,by simp [heq]⟩

/-- U5 necessity turns semantic adequacy into the class coverage used in the
allocation bound. No structural restriction on the decoder is assumed here. -/
theorem normalized_coverage {r : Request} {sc oc : List PartitionClass}
    {fs : List (List Step)} {p : Term Path} {d : Option (Term Path)}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hf : U6.checkForests r.target oc fs = true) (hp : Legal r p)
    (ha : ∃ f : Term Bool → Term Bool, ∀ x, Gamma r.source bits x →
      f ((jointView p d).map x) = r.source.question.map x) :
    required r.source sc ⊆ normalized sc oc p ++
      (d.map (fun t => t.values.filterMap (blockOf sc))).getD [] := by
  intro b hb
  have hb' : b ∈ r.source.question.values.filterMap (blockOf sc) := by simpa [required] using hb
  obtain ⟨q,hq,hqb⟩ := List.mem_filterMap.mp hb'
  obtain ⟨a,ham,hab⟩ := adequate_class_coverage hs ha hq hqb
  cases d with
  | none => exact List.mem_append_left _ (normalized_covers_step hs ho hf hp ham hab)
  | some d =>
    rcases List.mem_append.mp ham with hpa | hda
    · exact List.mem_append_left _ (normalized_covers_step hs ho hf hp hpa hab)
    · exact List.mem_append_right _ (List.mem_filterMap.mpr ⟨a,hda,hab⟩)

/-- This is the global U10/U10a bound for EVERY legal U3 step and EVERY adequate
residual, not a premise that the proposed step already attains the minimum. -/
theorem u3_global_lower_bound {r : Request} {sc oc : List PartitionClass}
    {fs : List (List Step)} {p : Term Path} {d : Option (Term Path)}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hf : U6.checkForests r.target oc fs = true) (hp : Legal r p)
    (ha : ∃ f : Term Bool → Term Bool, ∀ x, Gamma r.source bits x →
      f ((jointView p d).map x) = r.source.question.map x)
    (sorts : List SortId) (hn : sorts.Nodup) (hr : (required r.source sc).Nodup) :
    sumOn sorts (fun s => (bucket (classSort sc) s (required r.source sc)).length -
      (supplied (bucket (classSort sc) s (required r.source sc))
        (bucket (classSort sc) s (fixedValues (oc.map (slot r sc))))).length -
      freeSlots (oc.map (slot r sc)) s) ≤ (d.map (fun t => t.values.length)).getD 0 := by
  have h := class_plan_lower_bound sorts hn (sort := classSort sc)
    (slots := oc.map (slot r sc)) (required := required r.source sc)
    hr (normalize_assignments hs ho hf hp) (normalized_coverage hs ho hf hp ha)
  apply Nat.le_trans h
  cases d with
  | none => exact Nat.le_refl _
  | some d => exact List.length_filterMap_le _ _
end U10
