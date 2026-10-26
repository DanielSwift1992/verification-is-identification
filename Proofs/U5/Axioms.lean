-- The single declared roster of principal claims, read by Checks/proofs.py.
-- Only imports and #print axioms commands belong in this carrier.
import U5
import U6
import U7
import U8
import Record

-- U5
#print axioms U5.closure_minimal
#print axioms U5.construction_sound
#print axioms U5.construction_full_input
#print axioms U5.obstruction_witnesses
#print axioms U5.obstruction_no_decoder
#print axioms U5.obstruction_not_universal
#print axioms U5.conclusions_disjoint
#print axioms U5.check_sound
#print axioms U5.compatible_nonempty
#print axioms U5.accepted_nonempty
#print axioms U5.Codec.decode_encode
#print axioms U5.Codec.decode_iff
#print axioms U5.Codec.encode_injective
#print axioms U5.Codec.decoding_unique

-- U6
#print axioms U6.forestFrom_sound
#print axioms U6.exact_classes
#print axioms U6.partition_covers
#print axioms U6.admitted_cuts_have_blocks
#print axioms U6.missing_class_iff
#print axioms U6.missing_classes_complete
#print axioms U6.check_sound
#print axioms U6.accepted_nonempty
#print axioms U6.leaf_count_exact
#print axioms U6.relative_least
#print axioms U6.relative_least_all
#print axioms U6.decoder_covers_missing
#print axioms U6.semantic_lower_bound
#print axioms U6.retention_minimum
#print axioms U6.retention_semantic_minimum
#print axioms U6.fewer_leaves_impossible
#print axioms U6.structural_factor_through_adequate
#print axioms U6.zero_count_exact

-- U7
#print axioms U7.action_sort
#print axioms U7.preserves_closure
#print axioms U7.generators_iff
#print axioms U7.action_gamma
#print axioms U7.edges_sound
#print axioms U7.word_preserves
#print axioms U7.evidence_preserves
#print axioms U7.word_reachable
#print axioms U7.closure_exact
#print axioms U7.stable_least
#print axioms U7.stable_closed
#print axioms U7.stable_size_bound
#print axioms U7.image_commutes
#print axioms U7.question_decodes
#print axioms U7.check_stable_sound
#print axioms U7.accepted_nonempty
#print axioms U7.refusal_witness
#print axioms U7.check_refusal_sound
#print axioms U7.refusal_not_universal
#print axioms U7.word_gamma
#print axioms U7.addressed_word_semantics
#print axioms U7.words_commute
#print axioms U7.word_question
#print axioms U7.check_sound

-- U8
#print axioms U8.closed_saturation
#print axioms U8.agreement_saturation
#print axioms U8.representatives_iff_classes
#print axioms U8.classBit_gamma
#print axioms U8.missing_witness
#print axioms U8.outside_no_common
#print axioms U8.disagreement_witness
#print axioms U8.disagreement_no_common
#print axioms U8.disagreement_no_source_decoder
#print axioms U8.common_necessary
#print axioms U8.common_sufficient
#print axioms U8.structural_to_arbitrary
#print axioms U8.structural_iff_conditions
#print axioms U8.universal_iff_conditions
#print axioms U8.universal_iff_class_conditions
#print axioms U8.boolean_iff_conditions
#print axioms U8.no_common_not_universal
#print axioms U8.image_sound
#print axioms U8.common_sound
#print axioms U8.checked_missing
#print axioms U8.outside_sound
#print axioms U8.disagreement_sound
#print axioms U8.hidden_gamma
#print axioms U8.check_sound
#print axioms U8.accepted_nonempty
#print axioms U8.same_class_views
#print axioms U8.inherited_closed

-- Record
#print axioms Record.natural_write
#print axioms Record.parse_items_write
#print axioms Record.node_inverse
#print axioms Record.view_parse_write
#print axioms Record.raw_parse_write
#print axioms Record.World.admit_model
#print axioms Record.shape_sound
#print axioms Record.admit_denotes
#print axioms Record.World.denotes
#print axioms Record.read_write
#print axioms Record.write_read
#print axioms Record.write_injective
#print axioms Record.raw_ascii
#print axioms Record.byte_values_array
#print axioms Record.byte_array_values
#print axioms Record.read_write_bytes
#print axioms Record.write_read_bytes
#print axioms Record.write_bytes_injective
#print axioms Record.judgment_sound
#print axioms Record.replay_sound
#print axioms Record.exit_sound
#print axioms Record.exit_bytes_sound
