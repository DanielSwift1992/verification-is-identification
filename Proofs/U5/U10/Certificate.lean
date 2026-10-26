import U10.Normalization

namespace U10
open U5

structure Capacity where
  sort : SortId
  requiredClasses : Nat
  outputClasses : Nat
  fixedRequiredClasses : Nat
  freeOutputClasses : Nat
  minimumResidualLeaves : Nat
  deriving DecidableEq, Repr
structure Plan where
  assignments : List Path
  step : Term Path
  bindingBases : List Basis
  needed : List U6.RequiredClass
  residualLeaves : List Path
  residual : Option (Term Path)
  decoder : Construction
  capacities : List Capacity
  deriving Repr
inductive Conclusion where
  | constructed : Plan → Conclusion
  | unavailable : Path → Conclusion
  | wrongSort : Path → Conclusion
  | incompatible : Path → Path → Conclusion
  deriving Repr
structure Certificate where
  classes : List PartitionClass
  connections : List (List Step)
  outputClasses : List PartitionClass
  outputConnections : List (List Step)
  conclusion : Conclusion
  deriving Repr

/-- Structural recursion keeps finite replay reducible by the Lean kernel. -/
def insertSortId (s : SortId) : List SortId → List SortId
  | [] => [s]
  | t :: ts => if s ≤ t then s :: t :: ts else t :: insertSortId s ts

def orderSorts : List SortId → List SortId
  | [] => []
  | s :: ss => insertSortId s (orderSorts ss)

def sorts (r : Request) (sc oc : List PartitionClass) : List SortId :=
  orderSorts ((oc.map PartitionClass.sort ++ (required r.source sc).map (classSort sc)).eraseDups)
def capacity (r : Request) (sc oc : List PartitionClass) (s : SortId) : Capacity :=
  let n := (bucket (classSort sc) s (required r.source sc)).length
  let m := (oc.filter (fun c => c.sort == s)).length
  let fixed := bucket (classSort sc) s (fixedValues (oc.map (slot r sc)))
  let bound := (supplied (bucket (classSort sc) s (required r.source sc)) fixed).length
  let free := freeSlots (oc.map (slot r sc)) s
  ⟨s,n,m,bound,free,n-bound-free⟩
def lower (r : Request) (sc oc : List PartitionClass) : Nat :=
  sumOn (sorts r sc oc) (fun s => (capacity r sc oc s).minimumResidualLeaves)
def residualCount (d : Option (Term Path)) : Nat := (d.map (fun t => t.values.length)).getD 0

def checkShape (r : Request) (p : Term Path) : Bool :=
  U9.checkCut r.source p && U9.output r.source p == r.target.source

def checkBindings (r : Request) (p : Term Path) (bs : List Basis) : Bool :=
  U7.checkPairs (fun b basis => checkBasis r.source.edges (U9.origin p b.output) b.source basis) r.bindings bs

def checkResidual (leaves : List Path) : Option (Term Path) → Bool
  | none => leaves.isEmpty
  | some d => U6.balanced d && d.values == leaves

def checkPlan (r : Request) (sc oc : List PartitionClass) (p : Plan) : Bool :=
  checkShape r p.step &&
  U7.checkPairs (fun block a => r.source.source.lookup a == some block.sort &&
    block.leaves.all (fun u => p.step.lookup u == some a)) oc p.assignments &&
  r.target.edges.all (fun e => U9.origin p.step e.left == U9.origin p.step e.right) &&
  checkBindings r p.step p.bindingBases &&
  p.capacities == (sorts r sc oc).map (capacity r sc oc) &&
  p.needed == U6.requiredClasses {r.source with observation := p.step} sc &&
  decide ((p.residualLeaves.map (blockOf sc)).Perm (p.needed.map (fun c => some c.block))) &&
  checkResidual p.residualLeaves p.residual &&
  p.residualLeaves.length == lower r sc oc &&
  checkConstruction {r.source with observation := jointView p.step p.residual} p.decoder

def checkNegative (r : Request) (sc oc : List PartitionClass) : Conclusion → Bool
  | .constructed _ => false
  | .unavailable u => match r.target.source.lookup u with
    | none => false
    | some s => r.source.source.entries.all (fun (_,t) => t != s)
  | .wrongSort address => match r.bindings.find? (fun b => b.address == address) with
    | none => false
    | some b => (r.target.source.lookup b.output).isSome &&
      (r.source.source.lookup b.source).isSome &&
      r.target.source.lookup b.output != r.source.source.lookup b.source
  | .incompatible left right =>
    match r.bindings.find? (fun b => b.address == left), r.bindings.find? (fun b => b.address == right) with
    | some a, some b =>
      (r.target.source.lookup a.output).isSome && (r.target.source.lookup b.output).isSome &&
      r.target.source.lookup a.output == r.source.source.lookup a.source &&
      r.target.source.lookup b.output == r.source.source.lookup b.source &&
      blockOf oc a.output == blockOf oc b.output && blockOf sc a.source != blockOf sc b.source
    | _,_ => false

def checkBindingPlaces (r : Request) : Bool :=
  r.bindings.all (fun b => (r.target.source.lookup b.output).isSome &&
    (r.source.source.lookup b.source).isSome) && decide (r.bindings.map Binding.address).Nodup

def check (r : Request) (c : Certificate) : Bool :=
  r.source.valid && r.target.valid && checkBindingPlaces r &&
  checkPartition r.source c.classes && U6.checkForests r.source c.classes c.connections &&
  checkPartition r.target c.outputClasses && U6.checkForests r.target c.outputClasses c.outputConnections &&
  decide (required r.source c.classes).Nodup && decide (sorts r c.classes c.outputClasses).Nodup &&
  match c.conclusion with
  | .constructed p => checkPlan r c.classes c.outputClasses p
  | negative => checkNegative r c.classes c.outputClasses negative

theorem shape_checked {r : Request} {p : Term Path} (h : checkShape r p = true) : HasShape r p :=
  ⟨U9.cut_admitted (Bool.and_eq_true_iff.mp h).1, beq_iff_eq.mp (Bool.and_eq_true_iff.mp h).2⟩

theorem plan_legal {r : Request} {sc oc : List PartitionClass} {p : Plan}
    (h : checkPlan r sc oc p = true) : Legal r p.step := by
  simp only [checkPlan, Bool.and_eq_true_iff] at h
  refine ⟨shape_checked h.1.1.1.1.1.1.1.1.1, ?_, ?_⟩
  · intro e he
    have hi := List.all_eq_true.mp h.1.1.1.1.1.1.1.2 e he
    have heq := beq_iff_eq.mp hi
    rw [heq]; exact .refl _
  · intro b hb
    obtain ⟨basis, _, hi⟩ := U7.pairs_left h.1.1.1.1.1.1.2 hb
    exact basis_sound hi

theorem plan_count {r : Request} {sc oc : List PartitionClass} {p : Plan}
    (h : checkPlan r sc oc p = true) : residualCount p.residual = lower r sc oc := by
  simp only [checkPlan, Bool.and_eq_true_iff, beq_iff_eq] at h
  have hr := h.1.1.2
  have hn := h.1.2
  cases hd : p.residual with
  | none =>
    have he : p.residualLeaves = [] := by simpa [checkResidual,hd] using hr
    simpa [residualCount,hd,he] using hn
  | some d =>
    have hr' : U6.balanced d = true ∧ (d.values == p.residualLeaves) = true := by
      simpa [checkResidual,hd,Bool.and_eq_true_iff] using hr
    have hv : d.values = p.residualLeaves := beq_iff_eq.mp hr'.2
    simpa [residualCount,hd,hv] using hn

/-- Accepted positive plans satisfy C and bindings, decode Q, attain the sum,
and cannot be beaten by ANY legal U3 step with an adequate decoder. -/
theorem constructed_sound {r : Request} {c : Certificate} {p : Plan}
    (h : check r c = true) (hc : c.conclusion = .constructed p) :
    Legal r p.step ∧ residualCount p.residual = lower r c.classes c.outputClasses ∧
    (∀ (α : Type) (i : Interpretation α) x, Gamma r.source i x →
      run p.decoder.program ((jointView p.step p.residual).map x) = some (r.source.question.map x)) ∧
    (∀ alternative d, Legal r alternative →
      (∃ f : Term Bool → Term Bool, ∀ x, Gamma r.source bits x →
        f ((jointView alternative d).map x) = r.source.question.map x) →
      residualCount p.residual ≤ residualCount d) := by
  simp only [check,hc,Bool.and_eq_true_iff,decide_eq_true_eq] at h
  have hp := h.2
  refine ⟨plan_legal hp, plan_count hp, ?_, ?_⟩
  · exact fun α i x hx => decoder_sound (Bool.and_eq_true_iff.mp hp).2 i x hx
  · intro alternative d hl ha
    rw [plan_count hp]
    exact u3_global_lower_bound h.1.1.1.1.1.1.2 h.1.1.1.1.2 h.1.1.1.2 hl ha
      (sorts r c.classes c.outputClasses) h.1.2 h.1.1.2
end U10
