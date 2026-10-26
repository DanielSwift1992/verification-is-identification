import U11.Model
import U7.Refusal

namespace U11
open U5 U6 U7

structure ReturnCycle where
  member : Path
  block : Nat
  vertices : List Nat
  length : Nat
  deriving Repr

structure Arithmetic where
  gcd : Nat
  multiplier : Nat
  value : Nat
  deriving Repr

structure ReturnBlock where
  cycles : List ReturnCycle
  arithmetic : List Arithmetic
  calls : Nat
  additionalCalls : Nat
  deriving Repr

structure ReturnTail where
  member : Path
  block : Nat
  vertices : List Nat
  repeatedIndex : Nat
  deriving Repr

inductive Conclusion where
  | returned : ReturnBlock → Conclusion
  | obstructed : ReturnTail → Conclusion
  deriving Repr

structure Certificate where
  classes : List PartitionClass
  connections : List (List Step)
  required : List Nat
  hiddenActions : List ActionEvidence
  conclusion : Option Conclusion
  deriving Repr

/-- The same first-occurrence order as Question; repeated class occurrences
share one requirement. Hidden member addresses are never deduplicated by image. -/
def required (m : Model) (cs : List PartitionClass) : List Nat :=
  (m.question.values.map (classAt cs)).eraseDups

def pairs (hs : List Action) (rs : List Nat) : List (Action × Nat) :=
  hs.flatMap (fun a => rs.map (a, ·))

def checkWalkShape (cs : List PartitionClass) (vertices : List Nat) : Bool :=
  decide (2 ≤ vertices.length) && decide (vertices.length - 1 ≤ cs.length) &&
  vertices.all (fun b => decide (b < cs.length)) && decide vertices.dropLast.Nodup

def checkCycle (cs : List PartitionClass) (pair : Action × Nat) (c : ReturnCycle) : Bool :=
  c.member == pair.1.member && c.block == pair.2 &&
  checkWalkShape cs c.vertices && c.length == c.vertices.length - 1 &&
  c.vertices.getLast? == some pair.2 &&
  checkWalk (gamma cs pair.1) pair.2 c.vertices.dropLast pair.2

/-- Certificate values are Nat after decoding canonical decimal strings.
The checker performs Euclidean gcd and exact multiplication at each step. -/
def checkArithmetic : Nat → List Nat → List Arithmetic → Nat → Bool
  | previous, [], [], calls => calls == previous
  | previous, n :: ns, s :: ss, calls =>
      s.gcd == Nat.gcd previous n && s.multiplier == n / s.gcd &&
      s.value == previous * s.multiplier && checkArithmetic s.value ns ss calls
  | _, _, _, _ => false

def checkReturn (m : Model) (hs : List Action) (cs : List PartitionClass) (b : ReturnBlock) : Bool :=
  checkPairs (checkCycle cs) (pairs hs (required m cs)) b.cycles &&
  checkArithmetic 1 (b.cycles.map ReturnCycle.length) b.arithmetic b.calls &&
  decide (0 < b.calls) && b.additionalCalls + 1 == b.calls

def checkTail (m : Model) (hs : List Action) (cs : List PartitionClass) (t : ReturnTail) : Bool :=
  match hs.find? (fun a => a.member == t.member), t.vertices.getLast? with
  | some a, some last =>
      (required m cs).contains t.block && checkWalkShape cs t.vertices &&
      checkWalk (gamma cs a) t.block t.vertices.dropLast last &&
      t.vertices.dropLast[t.repeatedIndex]? == some last && last != t.block
  | _, _ => false

def checkBase (m : Model) (hs : List Action) (c : Certificate) : Bool :=
  m.valid && !hs.isEmpty && decide (hs.map Action.member).Nodup && hs.all (checkAction m) &&
  checkPartition m c.classes && checkForests m c.classes c.connections &&
  c.required == required m c.classes &&
  checkPairs (checkEvidence m c.classes) hs c.hiddenActions

def check (m : Model) (hs : List Action) (c : Certificate) : Bool :=
  checkBase m hs c && match c.conclusion with
  | none => !evidenceHolds c.hiddenActions
  | some (.returned b) => evidenceHolds c.hiddenActions && checkReturn m hs c.classes b
  | some (.obstructed t) => evidenceHolds c.hiddenActions && checkTail m hs c.classes t

theorem cycle_first {cs : List PartitionClass} {pair : Action × Nat} {c : ReturnCycle}
    (h : checkCycle cs pair c = true) : FirstReturn (gamma cs pair.1) pair.2 c.length := by
  simp only [checkCycle, Bool.and_eq_true_iff, beq_iff_eq] at h
  have hw := h.2
  have sh := h.1.1.1.2
  simp only [checkWalkShape, Bool.and_eq_true_iff, decide_eq_true_eq] at sh
  have hl : c.vertices.dropLast.length = c.length := by simp [List.length_dropLast, h.1.1.2]
  rw [← hl]
  exact walk_first hw (by simp [List.length_dropLast]; omega) sh.2

theorem arithmetic_exact {previous calls : Nat} {ns : List Nat} {ss : List Arithmetic}
    (h : checkArithmetic previous ns ss calls = true) : calls = ns.foldl Nat.lcm previous := by
  induction ns generalizing previous ss with
  | nil => cases ss with
    | nil => simpa [checkArithmetic] using h
    | cons s ss => simp [checkArithmetic] at h
  | cons n ns ih =>
    cases ss with
    | nil => simp [checkArithmetic] at h
    | cons s ss =>
      simp only [checkArithmetic, Bool.and_eq_true_iff, beq_iff_eq] at h
      have hv : s.value = Nat.lcm previous n := by
        rw [h.1.2, h.1.1.2, h.1.1.1, lcm_update]
      simpa [List.foldl_cons, hv] using ih h.2

theorem fold_lcm (ns : List Nat) (a : Nat) : ns.foldl Nat.lcm a = Nat.lcm a (lcmAll ns) := by
  induction ns generalizing a with
  | nil => simp [lcmAll]
  | cons n ns ih => simp only [List.foldl_cons, ih, lcmAll, Nat.lcm_assoc]

theorem arithmetic_lcm {calls : Nat} {ns : List Nat} {ss : List Arithmetic}
    (h : checkArithmetic 1 ns ss calls = true) : calls = lcmAll ns := by
  simpa [fold_lcm] using arithmetic_exact h

end U11
