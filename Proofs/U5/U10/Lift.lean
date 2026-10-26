import U10.Fill

namespace U10
open U5

theorem pairs_at {test : α → β → Bool} {xs : List α} {ys : List β}
    (h : U7.checkPairs test xs ys = true) {n : Nat} {x : α}
    (hx : xs[n]? = some x) : ∃ y, ys[n]? = some y ∧ test x y = true := by
  induction xs generalizing ys n with
  | nil => simp at hx
  | cons a xs ih =>
    cases ys with
    | nil => simp [U7.checkPairs] at h
    | cons b ys =>
      have hh := Bool.and_eq_true_iff.mp h
      cases n with
      | zero => simp at hx; subst x; exact ⟨b,rfl,hh.1⟩
      | succ n => exact ih hh.2 hx

theorem pairs_length {test : α → β → Bool} {xs : List α} {ys : List β}
    (h : U7.checkPairs test xs ys = true) : xs.length = ys.length := by
  induction xs generalizing ys with
  | nil => cases ys <;> simp_all [U7.checkPairs]
  | cons a xs ih =>
    cases ys with
    | nil => simp [U7.checkPairs] at h
    | cons b ys => exact congrArg Nat.succ (ih (Bool.and_eq_true_iff.mp h).2)

theorem block_at {cs : List PartitionClass}
    (hn : (cs.flatMap PartitionClass.leaves).Nodup) {n : Nat} {c : PartitionClass}
    (hc : cs[n]? = some c) {p : Path} (hp : p ∈ c.leaves) : blockOf cs p = some n := by
  induction cs generalizing n with
  | nil => simp at hc
  | cons d cs ih =>
    have hh : d.leaves.Nodup ∧ (cs.flatMap PartitionClass.leaves).Nodup ∧
        ∀ a ∈ d.leaves, ∀ b ∈ cs.flatMap PartitionClass.leaves, a ≠ b :=
      List.nodup_append.mp hn
    cases n with
    | zero =>
      simp at hc; subst c
      simp [blockOf,List.findIdx?_cons,hp]
    | succ n =>
      have hnot : p ∉ d.leaves := by
        intro hd
        exact hh.2.2 p hd p (List.mem_flatMap.mpr ⟨c,List.mem_of_getElem? hc,hp⟩) rfl
      have hi := ih hh.2.1 hc
      simpa [blockOf,List.findIdx?_cons,hnot] using congrArg (Option.map Nat.succ) hi

def LiveClass (cs : List PartitionClass) (b : Nat) : Prop :=
  ∃ p, blockOf cs p = some b

noncomputable def representative (cs : List PartitionClass) (b : Nat) : Path := by
  classical
  exact if h : LiveClass cs b then Classical.choose h else []

theorem representative_block {cs : List PartitionClass} {b : Nat} (h : LiveClass cs b) :
    blockOf cs (representative cs b) = some b := by
  simpa [representative,h] using Classical.choose_spec h

theorem representative_sort {m : Model} {cs : List PartitionClass}
    (hp : checkPartition m cs = true) {b : Nat} (h : LiveClass cs b) :
    m.source.lookup (representative cs b) = some (classSort cs b) := by
  obtain ⟨c,hc,hm⟩ := U6.block_member (representative_block h)
  have hg : ∀ c ∈ cs, ∀ p ∈ c.leaves, m.source.lookup p = some c.sort := by
    intro c hc p hm
    have hh := hp
    simp only [checkPartition,Bool.and_eq_true_iff,List.all_eq_true,beq_iff_eq] at hh
    exact (hh.1.2 c hc).2 p hm
  simpa [classSort,hc] using hg c (List.mem_of_getElem? hc) _ hm

/-- Rebuild a requested product shape, labelling each leaf by its own address. -/
def selectShape : Term SortId → (Path → Path) → Term Path
  | .leaf _, f => .leaf (f [])
  | .pair l r, f => .pair (selectShape l (fun p => f (false :: p)))
      (selectShape r (fun p => f (true :: p)))

theorem select_lookup (s : Term SortId) (f : Path → Path) (p : Path) :
    (selectShape s f).lookup p = (s.lookup p).map (fun _ => f p) := by
  induction s generalizing f p with
  | leaf s => cases p <;> rfl
  | pair l r ihl ihr =>
    cases p with
    | nil => rfl
    | cons b p => cases b <;> simp [selectShape,Term.lookup,ihl,ihr]

theorem term_ext (s t : Term α) (h : ∀ p, s.lookup p = t.lookup p) : s = t := by
  induction s generalizing t with
  | leaf a =>
    cases t with
    | leaf b => have := h []; simpa [Term.lookup] using this
    | pair l r => have := h []; simp [Term.lookup] at this
  | pair l r ihl ihr =>
    cases t with
    | leaf b => have := h []; simp [Term.lookup] at this
    | pair a b =>
      have hl := ihl a (fun p => h (false :: p))
      have hr := ihr b (fun p => h (true :: p))
      rw [hl,hr]

theorem select_shape {r : Request} {f : Path → Path}
    (hf : ∀ p s, r.target.source.lookup p = some s → r.source.source.lookup (f p) = some s) :
    HasShape r (selectShape r.target.source f) := by
  constructor
  · intro q hq
    obtain ⟨u,hu⟩ := U6.lookup_of_mem_values hq
    rw [select_lookup] at hu
    cases hs : r.target.source.lookup u with
    | none => simp [hs] at hu
    | some s =>
      have he : f u = q := by simpa [hs] using hu
      exact ⟨s,he ▸ hf u s hs⟩
  · apply term_ext
    intro p
    simp only [U9.output,Term.lookup_map,select_lookup]
    cases hs : r.target.source.lookup p with
    | none => rfl
    | some s => simp [hf p s hs]

theorem select_origin {s : Term SortId} {f : Path → Path} {p : Path} {a : SortId}
    (h : s.lookup p = some a) : U9.origin (selectShape s f) p = f p := by
  simp [U9.origin,select_lookup,h]

/-- A list of actual source places gives a structural residual, with no
invented leaf for the empty case. Balance is a certificate normal form only. -/
def residualTree : List Path → Option (Term Path)
  | [] => none
  | a :: rest => some (rest.foldl (fun t b => .pair t (.leaf b)) (.leaf a))

theorem residual_values (ps : List Path) :
    ((residualTree ps).map Term.values).getD [] = ps := by
  have fold : ∀ (ps : List Path) (t : Term Path),
      (ps.foldl (fun t b => .pair t (.leaf b)) t).values = t.values ++ ps := by
    intro ps
    induction ps with
    | nil => intro t; simp
    | cons a ps ih => intro t; simpa [Term.values,List.append_assoc] using ih (.pair t (.leaf a))
  cases ps with
  | nil => rfl
  | cons a ps => simpa [residualTree,Term.values] using fold ps (.leaf a)

theorem residual_length (ps : List Path) : residualCount (residualTree ps) = ps.length := by
  have h := congrArg List.length (residual_values ps)
  cases he : residualTree ps <;> simpa [he,residualCount] using h

end U10
