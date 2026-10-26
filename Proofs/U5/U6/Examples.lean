import U6.ContractCases

namespace U6.Examples
open U5 U6.ContractCases

-- The same coarser partition is a valid U5 obstruction, but is not an exact
-- residue certificate: the contract observation rejects it under U6.
theorem coarse_partition_valid_for_U5 :
    match MultiClassResidueCoarseWithoutForestCert with
    | .retained p => U5.check MultiClassResidue (.obstructed p.obstruction) = true
    | .zero _ => False := by
  unfold MultiClassResidueCoarseWithoutForestCert
  decide

-- The no-smaller-view conclusion below instantiates the general theorem;
-- it does not exhaust possible decoders by running a test suite.
theorem one_leaf_cannot_replace_two :
    ¬ UniversalContinuation (joint MultiClassResidue (.leaf [true, false])) := by
  have h := MultiClassResidue_observed
  change checkPlan MultiClassResidue _ = true at h
  exact fewer_leaves_impossible h _ (by decide)

end U6.Examples
