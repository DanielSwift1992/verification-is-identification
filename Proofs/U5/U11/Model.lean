import U11.Orbit
import U8.Separation

namespace U11
open U5 U6 U7

def classAt (cs : List PartitionClass) (p : Path) : Nat := (blockOf cs p).getD cs.length

def representative (cs : List PartitionClass) (b : Nat) : Path :=
  (((cs[b]?).map PartitionClass.leaves).getD []).headD []

/-- Read directly from the live source map at the declared class representative.
Invalid indices have an arbitrary total extension, never used by accepted walks. -/
def gamma (cs : List PartitionClass) (a : Action) (b : Nat) : Nat :=
  classAt cs (pull a (representative cs b))

theorem member_block_index {cs : List PartitionClass} (hn : (cs.flatMap PartitionClass.leaves).Nodup)
    {b : Nat} (hb : b < cs.length) {p : Path} (hp : p ∈ cs[b].leaves) :
    blockOf cs p = some b := by
  induction cs generalizing b with
  | nil => simp at hb
  | cons c cs ih =>
    cases b with
    | zero => simp [blockOf, List.findIdx?_cons, show p ∈ c.leaves from hp]
    | succ b =>
      have hblt : b < cs.length := by simpa using hb
      have htail : (cs.flatMap PartitionClass.leaves).Nodup :=
        (List.nodup_append.mp hn).2.1
      have hi := ih htail (by simpa using hb) hp
      have hnmem : p ∉ c.leaves := by
        intro hm
        have hpflat : p ∈ cs.flatMap PartitionClass.leaves :=
          List.mem_flatMap.mpr ⟨cs[b], List.getElem_mem (by simpa using hb), hp⟩
        exact (List.nodup_append.mp hn).2.2 p hm p hpflat rfl
      simpa [blockOf, List.findIdx?_cons, hnmem] using congrArg (Option.map Nat.succ) hi

theorem valid_block {m : Model} {cs : List PartitionClass}
    (hp : checkPartition m cs = true) {b : Nat} (hb : b < cs.length) :
    ∃ s, m.source.lookup (representative cs b) = some s ∧
      blockOf cs (representative cs b) = some b := by
  have hall : ∀ c ∈ cs, c.leaves ≠ [] ∧ ∀ p ∈ c.leaves, m.source.lookup p = some c.sort := by
    simp only [checkPartition, Bool.and_eq_true_iff, List.all_eq_true, beq_iff_eq,
      Bool.not_eq_true', List.isEmpty_eq_false_iff] at hp
    exact hp.1.2
  let c := cs[b]
  have hcm : c ∈ cs := List.getElem_mem hb
  have hc := hall c hcm
  have hr : representative cs b ∈ c.leaves := by
    have he : cs[b]? = some c := List.getElem?_eq_getElem hb
    simp only [representative, he, Option.map_some, Option.getD_some]
    cases heq : c.leaves with
    | nil => exact False.elim (hc.1 heq)
    | cons p ps => simp
  refine ⟨c.sort, hc.2 _ hr, ?_⟩
  -- Uniqueness follows from the partition's disjoint leaf occurrences.
  have hn : (cs.flatMap PartitionClass.leaves).Nodup := by
    simp only [checkPartition, Bool.and_eq_true_iff, decide_eq_true_eq] at hp
    exact hp.1.1.1
  exact member_block_index hn hb hr

theorem classAt_eq {cs : List PartitionClass} {p : Path} {b : Nat}
    (h : blockOf cs p = some b) : classAt cs p = b := by simp [classAt, h]

theorem classAt_lt {m : Model} {cs : List PartitionClass} (hp : checkPartition m cs = true)
    {p : Path} {s : SortId} (hs : m.source.lookup p = some s) : classAt cs p < cs.length := by
  obtain ⟨b, hb⟩ := partition_covers hp hs
  obtain ⟨c, hc, _⟩ := block_member hb
  rw [classAt_eq hb]
  exact (List.getElem?_eq_some_iff.mp hc).choose

theorem classAt_closure {m : Model} {cs : List PartitionClass} {forests : List (List Step)}
    (hp : checkPartition m cs = true) (hf : checkForests m cs forests = true)
    {p q : Path} {s t : SortId} (hs : m.source.lookup p = some s)
    (ht : m.source.lookup q = some t) :
    classAt cs p = classAt cs q ↔ Closure m.edges p q := by
  obtain ⟨b, hb⟩ := partition_covers hp hs
  obtain ⟨d, hd⟩ := partition_covers hp ht
  rw [classAt_eq hb, classAt_eq hd]
  constructor
  · intro he; subst d; exact same_block_closure hf hb hd
  · intro he
    have := closure_same_block hp he
    simpa [hb, hd] using this

theorem gamma_commutes {m : Model} {cs : List PartitionClass} {forests : List (List Step)}
    (hp : checkPartition m cs = true) (hf : checkForests m cs forests = true)
    {a : Action} (ha : checkAction m a = true) (he : Preserves m a)
    {p : Path} {s : SortId} (hs : m.source.lookup p = some s) :
    gamma cs a (classAt cs p) = classAt cs (pull a p) := by
  obtain ⟨t, ht, hb⟩ := valid_block hp (classAt_lt hp hs)
  have hc : Closure m.edges (representative cs (classAt cs p)) p :=
    (classAt_closure hp hf ht hs).mp (classAt_eq hb)
  exact (classAt_closure hp hf (action_sort ha ht) (action_sort ha hs)).mpr
    (preserves_closure he hc)

theorem iter_sort {m : Model} {a : Action} (ha : checkAction m a = true)
    {p : Path} {s : SortId} (hs : m.source.lookup p = some s) (k : Nat) :
    m.source.lookup (iterate (pull a) k p) = some s := by
  induction k generalizing p with
  | zero => exact hs
  | succ k ih => exact ih (action_sort ha hs)

theorem iter_commutes {m : Model} {cs : List PartitionClass} {forests : List (List Step)}
    (hp : checkPartition m cs = true) (hf : checkForests m cs forests = true)
    {a : Action} (ha : checkAction m a = true) (he : Preserves m a)
    {p : Path} {s : SortId} (hs : m.source.lookup p = some s) (k : Nat) :
    iterate (gamma cs a) k (classAt cs p) = classAt cs (iterate (pull a) k p) := by
  induction k with
  | zero => rfl
  | succ k ih => rw [iterate_succ, iterate_succ, ih]; exact gamma_commutes hp hf ha he (iter_sort ha hs k)

/-- Actual k-fold act on the same filling, with the same Action parameter. -/
def repeatAct (a : Action) (k : Nat) (x : Path → α) : Path → α :=
  fun p => x (iterate (pull a) k p)

theorem repeatAct_step (a : Action) (k : Nat) (x : Path → α) :
    repeatAct a (k+1) x = act a (repeatAct a k x) := rfl

theorem repeat_gamma {m : Model} {a : Action} (ha : checkAction m a = true)
    (he : Preserves m a) {i : Interpretation α} {x : Path → α} (hx : Gamma m i x)
    (k : Nat) : Gamma m i (repeatAct a k x) := by
  induction k with
  | zero => exact hx
  | succ k ih => rw [repeatAct_step]; exact action_gamma ha he ih

def UniversalReturn (m : Model) (hs : List Action) (k : Nat) : Prop :=
  ∀ (α : Type) (i : Interpretation α) (x : Path → α), Gamma m i x →
    ∀ a ∈ hs, m.question.map (repeatAct a k x) = m.question.map x

def ClassReturn (m : Model) (hs : List Action) (cs : List PartitionClass) (k : Nat) : Prop :=
  ∀ a ∈ hs, ∀ p ∈ m.question.values,
    iterate (gamma cs a) k (classAt cs p) = classAt cs p

theorem question_source {m : Model} (hm : m.valid = true) {p : Path}
    (hp : p ∈ m.question.values) : ∃ s, m.source.lookup p = some s := by
  have hv : (m.source.lookup p).isSome = true := by
    simp only [Model.valid, Bool.and_eq_true_iff, List.all_eq_true] at hm
    exact hm.1.1 p (List.mem_append_right _ hp)
  exact Option.isSome_iff_exists.mp hv

theorem return_iff_classes {m : Model} {hs : List Action} {cs : List PartitionClass}
    {forests : List (List Step)} (hm : m.valid = true)
    (hp : checkPartition m cs = true) (hf : checkForests m cs forests = true)
    (ha : ∀ a ∈ hs, checkAction m a = true) (he : ∀ a ∈ hs, Preserves m a) (k : Nat) :
    UniversalReturn m hs k ↔ ClassReturn m hs cs k := by
  constructor
  · intro hu a ham p hpm
    obtain ⟨s, hps⟩ := question_source hm hpm
    rw [iter_commutes hp hf (ha a ham) (he a ham) hps]
    apply (classAt_closure hp hf (iter_sort (ha a ham) hps k) hps).mpr
    apply Classical.byContradiction
    intro hn
    have sep := U8.classBit_distinguishes (fun hc => hn (.symm hc))
    obtain ⟨q, hq⟩ := U6.lookup_of_mem_values hpm
    have eqv := congrArg (fun t => t.lookup q)
      (hu Bool bits (U8.classBit m p) (U8.classBit_gamma m p) a ham)
    simp only [Term.lookup_map, hq, Option.map_some, Option.some.injEq, repeatAct] at eqv
    exact sep eqv.symm
  · intro hc α i x hx a ham
    apply Term.map_eq_of_values
    intro p hpm
    obtain ⟨s, hps⟩ := question_source hm hpm
    have heq := hc a ham p hpm
    rw [iter_commutes hp hf (ha a ham) (he a ham) hps] at heq
    exact closure_sound hx.2 ((classAt_closure hp hf (iter_sort (ha a ham) hps k) hps).mp heq)

end U11
