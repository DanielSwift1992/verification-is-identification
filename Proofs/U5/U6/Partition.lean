import U5.Obstruction

namespace U6
open U5

/-- Check one incoming edge for each next block member, from an already reached
member. The order is exactly the contract's ordered forest, not graph search. -/
def forestFrom (edges : List Edge) (seen : List Path) : List Path → List Step → Bool
  | [], [] => true
  | next :: rest, step :: steps =>
    match edges.find? (fun e => e.address == step.edge) with
    | none => false
    | some e =>
      let a := if step.reversed then e.right else e.left
      let b := if step.reversed then e.left else e.right
      seen.contains a && b == next && forestFrom edges (next :: seen) rest steps
  | _, _ => false

def checkForest (edges : List Edge) (leaves : List Path) (steps : List Step) : Bool :=
  match leaves with
  | [] => false
  | root :: rest => forestFrom edges [root] rest steps

def checkForests (m : Model) (classes : List PartitionClass) (connections : List (List Step)) : Bool :=
  connections.length == classes.length &&
  (List.range classes.length).all (fun n =>
    match classes[n]?, connections[n]? with
    | some c, some steps => checkForest m.edges c.leaves steps
    | _, _ => false)

theorem forestFrom_sound {edges : List Edge} {root : Path}
    {seen rest : List Path} {steps : List Step}
    (hs : ∀ p ∈ seen, Closure edges root p)
    (h : forestFrom edges seen rest steps = true) :
    ∀ p ∈ rest, Closure edges root p := by
  induction rest generalizing seen steps with
  | nil => simp
  | cons next rest ih =>
    cases steps with
    | nil => simp [forestFrom] at h
    | cons step steps =>
      cases he : edges.find? (fun e => e.address == step.edge) with
      | none => simp [forestFrom, he] at h
      | some e =>
        have hem : e ∈ edges := List.mem_of_find?_eq_some he
        have hn : Closure edges root next ∧ forestFrom edges (next :: seen) rest steps = true := by
          cases hr : step.reversed
          · simp [forestFrom, he, hr] at h
            obtain ⟨⟨ha, hb⟩, ht⟩ := h
            exact ⟨hb ▸ Closure.trans (hs _ ha) (.edge hem), ht⟩
          · simp [forestFrom, he, hr] at h
            obtain ⟨⟨ha, hb⟩, ht⟩ := h
            exact ⟨hb ▸ Closure.trans (hs _ ha) (.symm (.edge hem)), ht⟩
        intro p hp
        simp only [List.mem_cons] at hp
        rcases hp with rfl | hp
        · exact hn.1
        · exact ih (fun a ha => by rcases List.mem_cons.mp ha with rfl | ha; exact hn.1; exact hs _ ha) hn.2 p hp

theorem forest_sound {edges : List Edge} {leaves : List Path} {steps : List Step}
    (h : checkForest edges leaves steps = true) {p q : Path}
    (hp : p ∈ leaves) (hq : q ∈ leaves) : Closure edges p q := by
  cases leaves with
  | nil => simp at hp
  | cons root rest =>
    have all : ∀ a ∈ root :: rest, Closure edges root a := by
      intro a ha
      rcases List.mem_cons.mp ha with rfl | ha
      · exact .refl _
      · apply forestFrom_sound (root := root) (seen := [root]) (rest := rest) (steps := steps) _ h a ha
        intro b hb
        have heq : b = root := by simpa using hb
        subst b
        exact .refl _
    exact .trans (.symm (all p hp)) (all q hq)

/-- A successful block lookup names an actual class and a member of it. -/
theorem block_member {classes : List PartitionClass} {p : Path} {b : Nat}
    (h : blockOf classes p = some b) :
    ∃ c, classes[b]? = some c ∧ p ∈ c.leaves := by
  obtain ⟨hb, hp, _⟩ := List.findIdx?_eq_some_iff_getElem.mp h
  exact ⟨classes[b], List.getElem?_eq_getElem hb, by simpa using hp⟩

theorem forests_at {m : Model} {classes : List PartitionClass} {connections : List (List Step)}
    (h : checkForests m classes connections = true) {b : Nat} {c : PartitionClass}
    (hc : classes[b]? = some c) : ∃ steps, checkForest m.edges c.leaves steps = true := by
  simp only [checkForests, Bool.and_eq_true_iff, beq_iff_eq, List.all_eq_true] at h
  have hb : b < classes.length := (List.getElem?_eq_some_iff.mp hc).choose
  have hi := h.2 b (List.mem_range.mpr hb)
  cases hs : connections[b]? with
  | none => simp [hc, hs] at hi
  | some steps => exact ⟨steps, by simpa [hc, hs] using hi⟩

theorem same_block_closure {m : Model} {classes : List PartitionClass} {connections : List (List Step)}
    (hf : checkForests m classes connections = true) {p q : Path} {b : Nat}
    (hp : blockOf classes p = some b) (hq : blockOf classes q = some b) :
    Closure m.edges p q := by
  obtain ⟨c, hc, hpc⟩ := block_member hp
  obtain ⟨d, hd, hqd⟩ := block_member hq
  have : c = d := Option.some.inj (hc.symm.trans hd)
  subst d
  obtain ⟨steps, hs⟩ := forests_at hf hc
  exact forest_sound hs hpc hqd

theorem partition_closed {m : Model} {classes : List PartitionClass}
    (hp : checkPartition m classes = true) :
    ∀ e ∈ m.edges, blockOf classes e.left = blockOf classes e.right := by
  simp only [checkPartition, Bool.and_eq_true_iff, List.all_eq_true, beq_iff_eq] at hp
  exact hp.2

theorem closure_same_block {m : Model} {classes : List PartitionClass}
    (hp : checkPartition m classes = true) {p q : Path}
    (h : Closure m.edges p q) : blockOf classes p = blockOf classes q := by
  exact closure_minimal (fun p q => blockOf classes p = blockOf classes q) (fun _ => rfl) Eq.symm Eq.trans (partition_closed hp) h

/-- The forest gives the reverse implication; a coarse U5 partition is not enough. -/
theorem exact_classes {m : Model} {classes : List PartitionClass} {connections : List (List Step)}
    (hp : checkPartition m classes = true) (hf : checkForests m classes connections = true)
    {p q : Path} {b : Nat} (hb : blockOf classes p = some b) :
    blockOf classes q = some b ↔ Closure m.edges p q := by
  constructor
  · exact same_block_closure hf hb
  · intro h; rw [← closure_same_block hp h]; exact hb

theorem partition_covers {m : Model} {classes : List PartitionClass}
    (hp : checkPartition m classes = true) {p : Path} {s : SortId}
    (hs : m.source.lookup p = some s) : ∃ b, blockOf classes p = some b := by
  have mem : p ∈ m.source.entries.map Prod.fst := List.mem_map.mpr ⟨(p,s), Term.mem_entries.mpr hs, rfl⟩
  have perm : (classes.flatMap PartitionClass.leaves).Perm (m.source.entries.map Prod.fst) := by
    simp only [checkPartition, Bool.and_eq_true_iff, decide_eq_true_eq] at hp
    exact hp.1.1.2
  have hmem := perm.mem_iff.mpr mem
  obtain ⟨c, hc, hpc⟩ := List.mem_flatMap.mp hmem
  exact ⟨_, List.findIdx?_eq_some_of_exists ⟨c, hc, by simpa using hpc⟩⟩

end U6
