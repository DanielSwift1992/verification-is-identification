import U5.ContractCases
import U5.Codec

namespace U5.Examples
open ContractCases

-- Model admission is checked before a certificate's finite proof.
def crossSort : Model :=
  ⟨.pair (.leaf 0) (.leaf 1), .leaf [false], .leaf [true], [⟨[], [false], [true]⟩]⟩
theorem cross_sort_refused : check crossSort OneEqualityCert = false := by decide

def nonleafOrigin : Model := { AddressIdentity with observation := .leaf [] }
theorem nonleaf_origin_refused : check nonleafOrigin AddressIdentityCert = false := by decide

def duplicateEdge : Model := { OneEquality with edges := OneEquality.edges ++ OneEquality.edges }
theorem duplicate_edge_address_refused : check duplicateEdge OneEqualityCert = false := by decide

-- A valid counterexample partition need not name the exact E-classes.
def coarse : Certificate := .obstructed ⟨[],
  [⟨0, [[false, false], [false, true]]⟩, ⟨0, [[true, false], [true, true]]⟩]⟩
theorem coarser_partition_accepted : check DisconnectedClass coarse = true := by decide

-- The negative result is universal, not a refusal on every particular carrier.
theorem singleton_still_has_continuation (x : Path → Unit) :
    run (.leaf []) (SameSortDifferentPlaces.observation.map x) =
      some (SameSortDifferentPlaces.question.map x) := by
  simp [SameSortDifferentPlaces, run, Term.map, Term.lookup]

-- These codec observations are supplementary; decode_iff covers every bit list.
theorem codec_empty_refused : Codec.decode [] = none := by decide
theorem codec_truncated_pair_refused : Codec.decode [true, false, false] = none := by decide
theorem codec_trailing_bit_refused : Codec.decode [false, false, false] = none := by decide
theorem codec_unfinished_sort_refused : Codec.decode [false, true, true] = none := by decide
theorem codec_nested_read : Codec.decode (Codec.encode (.pair (.leaf 2) (.pair (.leaf 0) (.leaf 2)))) =
    some (.pair (.leaf 2) (.pair (.leaf 0) (.leaf 2))) := Codec.decode_encode _

end U5.Examples
