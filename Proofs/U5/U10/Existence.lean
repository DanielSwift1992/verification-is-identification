import U10.Lift

namespace U10
open U5

/-- Admission asks only availability, typing and consistency of prescribed
sources. It does not assume a step, residual, decoder or successful search. -/
structure Admissible (r : Request) : Prop where
  sourceValid : r.source.valid = true
  targetValid : r.target.valid = true
  bindingPlaces : checkBindingPlaces r = true
  available : ∀ u s, r.target.source.lookup u = some s →
    ∃ p, r.source.source.lookup p = some s
  typed : ∀ b ∈ r.bindings, r.source.source.lookup b.source = r.target.source.lookup b.output
  consistent : ∀ a ∈ r.bindings, ∀ b ∈ r.bindings,
    Closure r.target.edges a.output b.output → Closure r.source.edges a.source b.source

theorem partition_nodup {m : Model} {cs : List PartitionClass}
    (h : checkPartition m cs = true) : (cs.flatMap PartitionClass.leaves).Nodup := by
  simp only [checkPartition,Bool.and_eq_true_iff,decide_eq_true_eq] at h
  exact h.1.1.1

theorem partition_leaf {m : Model} {cs : List PartitionClass}
    (h : checkPartition m cs = true) {c : PartitionClass} (hc : c ∈ cs)
    {p : Path} (hp : p ∈ c.leaves) : m.source.lookup p = some c.sort := by
  simp only [checkPartition,Bool.and_eq_true_iff,List.all_eq_true,beq_iff_eq] at h
  exact (h.1.2 c hc).2 p hp

theorem required_live (m : Model) (sc : List PartitionClass) {b : Nat}
    (h : b ∈ required m sc) : LiveClass sc b := by
  have hh : b ∈ m.question.values.filterMap (blockOf sc) := by simpa [required] using h
  obtain ⟨p,_,hp⟩ := List.mem_filterMap.mp hh
  exact ⟨p,hp⟩

theorem binding_live {r : Request} (hr : Admissible r) {b : Binding} (hb : b ∈ r.bindings) :
    (r.target.source.lookup b.output).isSome = true ∧
    (r.source.source.lookup b.source).isSome = true :=
  Bool.and_eq_true_iff.mp (List.all_eq_true.mp (Bool.and_eq_true_iff.mp hr.bindingPlaces).1 b hb)

theorem fixed_live {r : Request} (hr : Admissible r) {sc oc : List PartitionClass}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    {c : PartitionClass} (hc : c ∈ oc) {b : Nat} (hb : (slot r sc c).fixed = some b) :
    LiveClass sc b ∧ classSort sc b = c.sort := by
  cases hf : boundFor r c with
  | none => simp [slot,hf] at hb
  | some binding =>
    have hm := List.mem_of_find?_eq_some hf
    have hout : binding.output ∈ c.leaves := by simpa using List.find?_some hf
    have ht := (hr.typed binding hm).trans (partition_leaf ho hc hout)
    obtain ⟨k,hk⟩ := U6.partition_covers hs ht
    have he : k = b := by simpa [slot,hf,hk] using hb
    subst b
    exact ⟨⟨binding.source,hk⟩,block_sort hs ht hk⟩

theorem fallback_exists {r : Request} (hr : Admissible r) {sc oc : List PartitionClass}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    {c : PartitionClass} (hc : c ∈ oc) : ∃ b, LiveClass sc b ∧ classSort sc b = c.sort := by
  obtain ⟨p,hp⟩ := hr.available _ _ (class_root ho hc).2
  obtain ⟨b,hb⟩ := U6.partition_covers hs hp
  exact ⟨b,⟨p,hb⟩,block_sort hs hp hb⟩

noncomputable def fallback (sc : List PartitionClass) (s : SortId) : Nat := by
  classical
  exact if h : ∃ b, LiveClass sc b ∧ classSort sc b = s then Classical.choose h else 0

theorem fallback_spec {sc : List PartitionClass} {s : SortId}
    (h : ∃ b, LiveClass sc b ∧ classSort sc b = s) :
    LiveClass sc (fallback sc s) ∧ classSort sc (fallback sc s) = s := by
  simpa [fallback,h] using Classical.choose_spec h

theorem live_allocation {r : Request} (hr : Admissible r) {sc oc : List PartitionClass}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true) :
    ∃ as ds : List Nat,
      checkAssignments (classSort sc) (oc.map (slot r sc)) as = true ∧
      (∀ b ∈ as, LiveClass sc b) ∧ (∀ b ∈ ds, LiveClass sc b) ∧
      required r.source sc ⊆ as ++ ds ∧ ds.length = lower r sc oc := by
  apply allocation_exists (classSort sc) (LiveClass sc) (fallback sc)
    (oc.map (slot r sc)) (required r.source sc) (sorts r sc oc)
  · intro b hb; exact required_live _ _ hb
  · intro b hb; exact (sorts_spec r sc oc _).mpr (Or.inr (List.mem_map.mpr ⟨b,hb,rfl⟩))
  · intro sl hm
    obtain ⟨c,hc,rfl⟩ := List.mem_map.mp hm
    exact fallback_spec (fallback_exists hr hs ho hc)
  · intro sl hm b hb
    obtain ⟨c,hc,rfl⟩ := List.mem_map.mp hm
    exact fixed_live hr hs ho hc hb

def assigned (oc : List PartitionClass) (as : List Nat) (u : Path) : Nat :=
  (as[(blockOf oc u).getD 0]?).getD 0

noncomputable def sourceAt (sc oc : List PartitionClass) (as : List Nat) (u : Path) : Path :=
  representative sc (assigned oc as u)

theorem assignment_at {r : Request} {sc oc : List PartitionClass} {as : List Nat}
    (ha : checkAssignments (classSort sc) (oc.map (slot r sc)) as = true)
    {c : PartitionClass} {n : Nat} (hc : oc[n]? = some c) :
    ∃ b, as[n]? = some b ∧ classSort sc b = c.sort ∧
      ∀ k, (slot r sc c).fixed = some k → b = k := by
  obtain ⟨b,hb,hh⟩ := pairs_at ha (show (oc.map (slot r sc))[n]? = some (slot r sc c) by simp [hc])
  refine ⟨b,hb,by simpa [slot] using (Bool.and_eq_true_iff.mp hh).1,?_⟩
  intro k hk
  simpa [hk] using (Bool.and_eq_true_iff.mp hh).2

theorem sourceAt_typed {r : Request} {sc oc : List PartitionClass} {as : List Nat}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (ha : checkAssignments (classSort sc) (oc.map (slot r sc)) as = true)
    (hg : ∀ b ∈ as, LiveClass sc b) {u : Path} {s : SortId}
    (hu : r.target.source.lookup u = some s) :
    r.source.source.lookup (sourceAt sc oc as u) = some s := by
  obtain ⟨n,hn⟩ := U6.partition_covers ho hu
  obtain ⟨c,hc,huc⟩ := U6.block_member hn
  obtain ⟨b,hb,ht,_⟩ := assignment_at ha hc
  have he : c.sort = s := Option.some.inj ((partition_leaf ho (List.mem_of_getElem? hc) huc).symm.trans hu)
  have hp := representative_sort hs (hg b (List.mem_of_getElem? hb))
  simpa [sourceAt,assigned,hn,hb,ht,he] using hp

theorem sourceAt_binding {r : Request} (hr : Admissible r) {sc oc : List PartitionClass}
    {sf of : List (List Step)} {as : List Nat}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hfs : U6.checkForests r.source sc sf = true) (hfo : U6.checkForests r.target oc of = true)
    (ha : checkAssignments (classSort sc) (oc.map (slot r sc)) as = true)
    (hg : ∀ b ∈ as, LiveClass sc b) {b : Binding} (hb : b ∈ r.bindings) :
    Closure r.source.edges (sourceAt sc oc as b.output) b.source := by
  obtain ⟨s,hsort⟩ := Option.isSome_iff_exists.mp (binding_live hr hb).1
  obtain ⟨n,hn⟩ := U6.partition_covers ho hsort
  obtain ⟨c,hc,hbc⟩ := U6.block_member hn
  obtain ⟨a,haindex,_,hfixed⟩ := assignment_at ha hc
  have hsome : ∃ d, boundFor r c = some d := by
    cases hd : boundFor r c with
    | some d => exact ⟨d,rfl⟩
    | none =>
      have hh : ∀ d ∈ r.bindings, d.output ∉ c.leaves := by simpa [boundFor,List.find?_eq_none] using hd
      exact False.elim (hh b hb hbc)
  obtain ⟨d,hd⟩ := hsome
  have hdm := List.mem_of_find?_eq_some hd
  have hdc : d.output ∈ c.leaves := by simpa using List.find?_some hd
  have hrel := hr.consistent d hdm b hb (class_connected hfo (List.mem_of_getElem? hc) hdc hbc)
  obtain ⟨t,ht⟩ := Option.isSome_iff_exists.mp (binding_live hr hdm).2
  obtain ⟨k,hk⟩ := U6.partition_covers hs ht
  have hak : a = k := hfixed k (by simp [slot,hd,hk])
  have hrep := representative_block (hg a (List.mem_of_getElem? haindex))
  apply U6.same_block_closure hfs (b := k)
  · simpa [sourceAt,assigned,hn,haindex,hak] using hrep
  · rw [← U6.closure_same_block hs hrel]; exact hk

theorem assembled_legal {r : Request} (hr : Admissible r) {sc oc : List PartitionClass}
    {sf of : List (List Step)} {as : List Nat}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hfs : U6.checkForests r.source sc sf = true) (hfo : U6.checkForests r.target oc of = true)
    (ha : checkAssignments (classSort sc) (oc.map (slot r sc)) as = true)
    (hg : ∀ b ∈ as, LiveClass sc b) :
    Legal r (selectShape r.target.source (sourceAt sc oc as)) := by
  refine ⟨select_shape (fun _ _ hu => sourceAt_typed hs ho ha hg hu),?_,?_⟩
  · intro e he
    have hv := hr.targetValid
    simp only [Model.valid,Bool.and_eq_true_iff,List.all_eq_true,beq_iff_eq] at hv
    obtain ⟨s,hsl⟩ := Option.isSome_iff_exists.mp (hv.1.2 e he).1
    have hsr := ((hv.1.2 e he).2).symm.trans hsl
    rw [select_origin hsl,select_origin hsr]
    have heq := U6.partition_closed ho e he
    simp only [sourceAt,assigned,heq]
    exact .refl _
  · intro b hb
    obtain ⟨s,hsort⟩ := Option.isSome_iff_exists.mp (binding_live hr hb).1
    rw [select_origin hsort]
    exact sourceAt_binding hr hs ho hfs hfo ha hg hb

theorem assembled_covers {r : Request} {sc oc : List PartitionClass} {as : List Nat}
    (ho : checkPartition r.target oc = true)
    (ha : checkAssignments (classSort sc) (oc.map (slot r sc)) as = true)
    (hg : ∀ b ∈ as, LiveClass sc b) {b : Nat} (hb : b ∈ as) :
    ∃ p ∈ (selectShape r.target.source (sourceAt sc oc as)).values, blockOf sc p = some b := by
  obtain ⟨n,hn⟩ := List.mem_iff_getElem?.mp hb
  have hl : oc.length = as.length := by simpa using pairs_length ha
  have hbnd : n < oc.length := hl ▸ (List.getElem?_eq_some_iff.mp hn).choose
  let c := oc[n]
  have hc : oc[n]? = some c := List.getElem?_eq_getElem hbnd
  have hcm := List.mem_of_getElem? hc
  have hroot := class_root ho hcm
  have hblock := block_at (partition_nodup ho) hc hroot.1
  have hlookup : (selectShape r.target.source (sourceAt sc oc as)).lookup (root c) =
      some (representative sc b) := by
    simp [select_lookup,hroot.2,sourceAt,assigned,hblock,hn]
  exact ⟨representative sc b,Term.mem_values_of_lookup hlookup,representative_block (hg b hb)⟩

theorem joint_values (p : Term Path) (d : Option (Term Path)) :
    (jointView p d).values = p.values ++ (d.map Term.values).getD [] := by
  cases d <;> simp [jointView,Term.values]

/-- Existence, not completeness of a certificate synthesizer. Exact class
presentations are checked presentations of E and C, not assumptions of success.
No plan or decoder is among the hypotheses. -/
theorem optimal_plan_exists {r : Request} (hr : Admissible r)
    {sc oc : List PartitionClass} {sf of : List (List Step)}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hfs : U6.checkForests r.source sc sf = true) (hfo : U6.checkForests r.target oc of = true) :
    ∃ p d decoder,
      Legal r p ∧ (∀ t, d = some t → U9.Admitted r.source t) ∧
      (∀ (α : Type) (i : Interpretation α) x, Gamma r.source i x →
        run decoder ((jointView p d).map x) = some (r.source.question.map x)) ∧
      residualCount d = lower r sc oc := by
  classical
  obtain ⟨as,ds,ha,hga,hgd,hcover,hcount⟩ := live_allocation hr hs ho
  let p := selectShape r.target.source (sourceAt sc oc as)
  let d := residualTree (ds.map (representative sc))
  have hlegal : Legal r p := assembled_legal hr hs ho hfs hfo ha hga
  have hvalues : (d.map Term.values).getD [] = ds.map (representative sc) := residual_values _
  have htyped : ∀ t, d = some t → U9.Admitted r.source t := by
    intro t ht a ham
    have hv : t.values = ds.map (representative sc) := by simpa [ht] using hvalues
    obtain ⟨b,hb,rfl⟩ := List.mem_map.mp (hv ▸ ham)
    exact ⟨classSort sc b,representative_sort hs (hgd b hb)⟩
  have hc : U6.Covers r.source (jointView p d) r.source.question := by
    intro q hq
    have hv := hr.sourceValid
    simp only [Model.valid,Bool.and_eq_true_iff,List.all_eq_true] at hv
    obtain ⟨s,hqs⟩ := Option.isSome_iff_exists.mp (hv.1.1 q (List.mem_append_right _ hq))
    obtain ⟨b,hqb⟩ := U6.partition_covers hs hqs
    have hrequired : b ∈ required r.source sc := by
      simpa [required] using (List.mem_filterMap.mpr ⟨q,hq,hqb⟩ : b ∈ r.source.question.values.filterMap (blockOf sc))
    have hw : ∃ a ∈ (jointView p d).values, blockOf sc a = some b := by
      rcases List.mem_append.mp (hcover hrequired) with hba | hbd
      · obtain ⟨a,ham,hab⟩ := assembled_covers ho ha hga hba
        exact ⟨a,by rw [joint_values]; exact List.mem_append_left _ ham,hab⟩
      · refine ⟨representative sc b,?_,representative_block (hgd b hbd)⟩
        rw [joint_values,hvalues]
        exact List.mem_append_right _ (List.mem_map.mpr ⟨b,hbd,rfl⟩)
    obtain ⟨a,ham,hab⟩ := hw
    obtain ⟨address,haddress⟩ := U6.lookup_of_mem_values ham
    exact ⟨address,a,haddress,U6.same_block_closure hfs hab hqb⟩
  obtain ⟨decoder,hdecode⟩ := U6.covers_factor hc
  refine ⟨p,d,decoder,hlegal,htyped,hdecode,?_⟩
  exact (residual_length _).trans ((List.length_map ..).trans hcount)

/-- The converse uses arbitrary Legal terms, not our allocation normal form. -/
theorem legal_admissible {r : Request}
    (hm : r.source.valid = true) (ht : r.target.valid = true)
    (hb : checkBindingPlaces r = true) {p : Term Path} (hp : Legal r p) : Admissible r := by
  refine ⟨hm,ht,hb,?_,?_,?_⟩
  · intro u s hu; exact ⟨U9.origin p u,shape_origin hp.1 hu⟩
  · intro b hbm
    have hl := Bool.and_eq_true_iff.mp (List.all_eq_true.mp (Bool.and_eq_true_iff.mp hb).1 b hbm)
    obtain ⟨s,hs⟩ := Option.isSome_iff_exists.mp hl.1
    have he := U9.closure_sort hm (hp.2.2 b hbm)
    rw [← he,shape_origin hp.1 hs,hs]
  · intro a ha b hb hab
    exact .trans (.symm (hp.2.2 a ha)) (.trans (normalize_legal hp hab) (hp.2.2 b hb))

theorem admissible_iff_optimal_plan {r : Request}
    (hm : r.source.valid = true) (ht : r.target.valid = true) (hb : checkBindingPlaces r = true)
    {sc oc : List PartitionClass} {sf of : List (List Step)}
    (hs : checkPartition r.source sc = true) (ho : checkPartition r.target oc = true)
    (hfs : U6.checkForests r.source sc sf = true) (hfo : U6.checkForests r.target oc of = true) :
    Admissible r ↔ ∃ p d decoder,
      Legal r p ∧ (∀ t, d = some t → U9.Admitted r.source t) ∧
      (∀ (α : Type) (i : Interpretation α) x, Gamma r.source i x →
        run decoder ((jointView p d).map x) = some (r.source.question.map x)) ∧
      residualCount d = lower r sc oc := by
  constructor
  · exact fun hr => optimal_plan_exists hr hs ho hfs hfo
  · rintro ⟨p,d,decoder,hlegal,_⟩
    exact legal_admissible hm ht hb hlegal

end U10
