import U9.Image
import U7.Certificate

namespace U9
open U5 U7

structure Member where
  address : Path
  image : Term Path
  deriving Repr
inductive Promise where
  | holds : List Basis → Promise
  | violated : Path → Promise
  deriving Repr
structure ImageProof where
  member : Path
  classes : List PartitionClass
  sourceClassIndices : List Nat
  connections : List (List Basis)
  promise : Promise
  deriving Repr
structure Certificate where
  classes : List PartitionClass
  connections : List (List Step)
  images : List ImageProof
  deriving Repr

def shapeModel (m : Model) (p : Term Path) (es : List Edge := []) : Model :=
  ⟨output m p, .leaf [], .leaf [], es⟩
def checkCut (m : Model) (p : Term Path) : Bool :=
  p.values.all (fun q => (m.source.lookup q).isSome)

def checkStars (m : Model) (p : Term Path) (c : PartitionClass) (bs : List Basis) : Bool :=
  match c.leaves with
  | [] => false
  | u :: rest => checkPairs (fun v b => checkBasis m.edges (origin p u) (origin p v) b) rest bs

def checkPromise (m : Model) (p : Term Path) (cs : List Edge)
    (classes : List PartitionClass) : Promise → Bool
  | .holds bs => checkPairs (fun e b => checkBasis m.edges
      (origin p e.left) (origin p e.right) b) cs bs
  | .violated address => match cs.find? (fun e => e.address == address) with
      | none => false
      | some e => blockOf classes (origin p e.left) != blockOf classes (origin p e.right)

def verdict : Promise → Bool | .holds _ => true | .violated _ => false

/-- Finite extensional replay of the same induced partition. The pair table is
not a search or a payload test; it states the two inclusions explicitly. Swift
uses injective class indices and stars instead, whose outputs are observed below. -/
def checkRelation (_m : Model) (p : Term Path) (sourceClasses outputClasses : List PartitionClass) : Bool :=
  p.entries.all (fun (u,q) => p.entries.all (fun (v,r) =>
    (blockOf outputClasses u == blockOf outputClasses v) ==
      (blockOf sourceClasses q == blockOf sourceClasses r)))

def checkPromiseShape (m : Model) (p : Term Path) (cs : List Edge) : Bool :=
  cs.all (fun e => ((output m p).lookup e.left).isSome &&
    (output m p).lookup e.left == (output m p).lookup e.right) &&
  decide (cs.map Edge.address).Nodup

def checkImage (m : Model) (cs : List Edge) (sourceClasses : List PartitionClass)
    (a : Member) (c : ImageProof) : Bool :=
  c.member == a.address && checkCut m a.image && checkPromiseShape m a.image cs &&
  checkPartition (shapeModel m a.image) c.classes &&
  decide c.sourceClassIndices.Nodup &&
  checkPairs (fun block index => block.leaves.all (fun u =>
    blockOf sourceClasses (origin a.image u) == some index)) c.classes c.sourceClassIndices &&
  checkPairs (checkStars m a.image) c.classes c.connections &&
  checkRelation m a.image sourceClasses c.classes &&
  checkPromise m a.image cs sourceClasses c.promise

def check (m : Model) (members : List Member) (cs : List Edge) (c : Certificate) : Bool :=
  m.valid && checkPartition m c.classes && U6.checkForests m c.classes c.connections &&
  checkPairs (checkImage m cs c.classes) members c.images

theorem cut_admitted {m : Model} {p : Term Path} (h : checkCut m p = true) : Admitted m p := by
  intro q hq
  have hi := List.all_eq_true.mp h q hq
  cases hs : m.source.lookup q with
  | none => simp [hs] at hi
  | some s => exact ⟨s, rfl⟩

theorem checked_relation {m : Model} {p : Term Path}
    {sc oc : List PartitionClass} {forests : List (List Step)}
    (hp : checkPartition m sc = true) (hf : U6.checkForests m sc forests = true)
    (hc : checkCut m p = true) (hr : checkRelation m p sc oc = true)
    {u q v r : Path} (hu : p.lookup u = some q) (hv : p.lookup v = some r) :
    blockOf oc u = blockOf oc v ↔ Closure m.edges q r := by
  have hi := List.all_eq_true.mp (List.all_eq_true.mp hr (u,q) (Term.mem_entries.mpr hu))
    (v,r) (Term.mem_entries.mpr hv)
  have he : (blockOf oc u = blockOf oc v) ↔ (blockOf sc q = blockOf sc r) := by
    have hi := beq_iff_eq.mp hi
    constructor
    · intro he
      have hb : (blockOf oc u == blockOf oc v) = true := beq_iff_eq.mpr he
      rw [hi] at hb
      exact beq_iff_eq.mp hb
    · intro he
      have hb : (blockOf sc q == blockOf sc r) = true := beq_iff_eq.mpr he
      rw [← hi] at hb
      exact beq_iff_eq.mp hb
  obtain ⟨s, hs⟩ := cut_admitted hc q (Term.mem_values_of_lookup hu)
  obtain ⟨b, hb⟩ := U6.partition_covers hp hs
  rw [he]
  constructor
  · intro h; exact U6.same_block_closure hf hb (h ▸ hb)
  · exact U6.closure_same_block hp

theorem promise_checked {m : Model} {p : Term Path} {cs : List Edge}
    {sc : List PartitionClass} {fs : List (List Step)} {c : Promise}
    (hp : checkPartition m sc = true) (_hf : U6.checkForests m sc fs = true)
    (h : checkPromise m p cs sc c = true) :
    verdict c = true ↔ PromiseHolds m p cs := by
  cases c with
  | holds bs =>
    simp only [verdict, true_iff]
    apply (promise_iff m p cs).mpr
    intro e he
    obtain ⟨b, _, hb⟩ := pairs_left (show checkPairs _ cs bs = true from h) he
    exact basis_sound hb
  | violated address =>
    simp only [verdict, Bool.false_eq_true, false_iff]
    cases he : cs.find? (fun e => e.address == address) with
    | none => simp [checkPromise, he] at h
    | some e =>
      have hn : blockOf sc (origin p e.left) ≠ blockOf sc (origin p e.right) := by
        simpa [checkPromise, he] using h
      intro hh
      exact hn (U6.closure_same_block hp ((promise_iff m p cs).mp hh e (List.mem_of_find?_eq_some he)))

/-- Certificate soundness includes exact images even for a false promise.
No relation is silently passed as the Equalities of a subsequent question. -/
theorem check_sound {m : Model} {members : List Member} {cs : List Edge} {c : Certificate}
    (h : check m members cs c = true) {a : Member} (ha : a ∈ members) :
    ∃ proof ∈ c.images,
      (verdict proof.promise = true ↔ PromiseHolds m a.image cs) ∧
      (∀ (α : Type) (i : Interpretation α) (y : Path → α),
        IsImage m a.image i y ↔ OutputTyped m a.image i y ∧
          ∀ u q v r, a.image.lookup u = some q → a.image.lookup v = some r →
            blockOf proof.classes u = blockOf proof.classes v → y u = y v) := by
  simp only [check, Bool.and_eq_true_iff] at h
  obtain ⟨proof, hm, hi⟩ := pairs_left h.2 ha
  simp only [checkImage, Bool.and_eq_true_iff] at hi
  have hcut := hi.1.1.1.1.1.1.1.2
  have hrel := hi.1.2
  have rel := @checked_relation m a.image c.classes proof.classes c.connections
    h.1.1.2 h.1.2 hcut hrel
  refine ⟨proof, hm, promise_checked h.1.1.2 h.1.2 hi.2, ?_⟩
  intro α i y
  rw [exact_image h.1.1.1 (cut_admitted hcut)]
  constructor
  · rintro ⟨ht, hc⟩
    exact ⟨ht, fun u q v r hu hv he => hc u q v r hu hv ((rel hu hv).mp he)⟩
  · rintro ⟨ht, hc⟩
    exact ⟨ht, fun u q v r hu hv he => hc u q v r hu hv ((rel hu hv).mpr he)⟩
/-- A false member cannot be hidden by a positive one; every member is checked
on the same full X_E domain, including after a negative member. -/
theorem family_verdict {m : Model} {members : List Member} {cs : List Edge} {c : Certificate}
    (h : check m members cs c = true) :
    c.images.all (fun proof => verdict proof.promise) = true ↔
      ∀ a ∈ members, PromiseHolds m a.image cs := by
  simp only [check,Bool.and_eq_true_iff] at h
  constructor
  · intro hh a ha
    obtain ⟨proof,hp,hi⟩ := pairs_left h.2 ha
    exact (promise_checked h.1.1.2 h.1.2 (Bool.and_eq_true_iff.mp hi).2).mp
      (List.all_eq_true.mp hh proof hp)
  · intro hh
    apply List.all_eq_true.mpr
    intro proof hp
    obtain ⟨a,ha,hi⟩ := pairs_right h.2 hp
    exact (promise_checked h.1.1.2 h.1.2 (Bool.and_eq_true_iff.mp hi).2).mpr (hh a ha)
end U9
