-- The single declared roster of principal claims, read by Checks/proofs.py.
-- Only imports and #print axioms commands belong in this carrier.
import U5
import U6
import U7
import U8
import U11
import Record
import U9
import U10

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

-- Record, schema 2 with actions
#print axioms Record.Actions.raw_parse_write
#print axioms Record.Actions.convert_denotes
#print axioms Record.Actions.members_denote
#print axioms Record.Actions.family_denotes
#print axioms Record.Actions.admit_denotes
#print axioms Record.Actions.World.admit_environment
#print axioms Record.Actions.World.denotes
#print axioms Record.Actions.read_write
#print axioms Record.Actions.write_read
#print axioms Record.Actions.write_injective
#print axioms Record.Actions.raw_ascii
#print axioms Record.Actions.read_write_bytes
#print axioms Record.Actions.write_read_bytes
#print axioms Record.Actions.write_bytes_injective
#print axioms Record.Actions.judgment_sound
#print axioms Record.Actions.replay_sound
#print axioms Record.Actions.exit_sound
#print axioms Record.Actions.exit_bytes_sound
#print axioms Record.Actions.pack_sound
#print axioms Record.Actions.MemberDenotes.flat

-- U11, fixed-member repeat episode
#print axioms U11.return_iff_dvd
#print axioms U11.walk_first
#print axioms U11.tail_never_returns
#print axioms U11.lcmAll_dvd
#print axioms U11.lcmAll_positive
#print axioms U11.lcm_update
#print axioms U11.first_of_return
#print axioms U11.finite_common_return_iff
#print axioms U11.gamma_commutes
#print axioms U11.iter_commutes
#print axioms U11.repeatAct_step
#print axioms U11.repeat_gamma
#print axioms U11.return_iff_classes
#print axioms U11.cycle_first
#print axioms U11.arithmetic_exact
#print axioms U11.arithmetic_lcm
#print axioms U11.base_sound
#print axioms U11.cycles_cover
#print axioms U11.cycle_origin
#print axioms U11.return_count
#print axioms U11.return_sound
#print axioms U11.first_length_divides
#print axioms U11.checked_return_counts_iff
#print axioms U11.least_positive
#print axioms U11.tail_witness
#print axioms U11.tail_sound
#print axioms U11.check_sound
#print axioms U11.checked_tail_no_common
#print axioms U11.accepted_nonempty
#print axioms U11.universal_return_iff_cycles
#print axioms U11.Examples.first_three
#print axioms U11.Examples.whole_six
#print axioms U11.Examples.identity_swap_two
#print axioms U11.Examples.duplicate_a_one
#print axioms U11.Examples.duplicate_b_never
#print axioms U11.Examples.duplicate_b_no_common
#print axioms U11.Examples.preservation_refusal_can_return

-- U9
#print axioms U9.closure_sort
#print axioms U9.image_forward
#print axioms U9.image_reverse
#print axioms U9.exact_image
#print axioms U9.promise_iff
#print axioms U9.promise_counterexample
#print axioms U9.hidden_promise_iff
#print axioms U9.checked_relation
#print axioms U9.promise_checked
#print axioms U9.family_verdict
#print axioms U9.check_sound

-- U10
#print axioms U10.split_length
#print axioms U10.bucket_lower_bound
#print axioms U10.allocate_length
#print axioms U10.allocation_covers
#print axioms U10.allocation_attains
#print axioms U10.unbound_attains
#print axioms U10.allocation_minimal
#print axioms U10.total_lower_bound
#print axioms U10.total_attains
#print axioms U10.residual_two
#print axioms U10.assignment_cover
#print axioms U10.free_bucket_length
#print axioms U10.class_plan_bucket_bound
#print axioms U10.bucket_sum_le
#print axioms U10.class_plan_lower_bound
#print axioms U10.obligations_iff
#print axioms U10.normalize_legal
#print axioms U10.shape_origin
#print axioms U10.unavailable_impossible
#print axioms U10.wrong_sort_impossible
#print axioms U10.incompatible_impossible
#print axioms U10.decoder_sound
#print axioms U10.adequate_class_coverage
#print axioms U10.normalize_assignments
#print axioms U10.normalized_covers_step
#print axioms U10.normalized_coverage
#print axioms U10.u3_global_lower_bound
#print axioms U10.plan_legal
#print axioms U10.plan_count
#print axioms U10.constructed_sound
#print axioms U10.negative_sound
#print axioms U10.refused_sound
#print axioms U10.unbound_capacity
#print axioms U10.check_sound

#print axioms U10.Examples.two_necessary_sufficient

#print axioms U10.sorts_spec
#print axioms U10.refused_semantic

-- T0121: the remaining record questions, with one canonical byte reader.
#print axioms Record.Canonical.read_write
#print axioms Record.Canonical.write_read
#print axioms Record.Canonical.write_injective
#print axioms Record.Canonical.read_write_bytes
#print axioms Record.Canonical.write_read_bytes
#print axioms Record.Extended.base_inverse
#print axioms Record.Extended.image_inverse
#print axioms Record.Extended.agreement_inverse
#print axioms Record.Extended.target_flat
#print axioms Record.Extended.convert_target_denotes
#print axioms Record.Extended.target_members_denote
#print axioms Record.Extended.admit_image_denotes
#print axioms Record.Extended.bind_cuts_flat
#print axioms Record.Extended.bindings_denote
#print axioms Record.Extended.admit_agreement_denotes
#print axioms Record.Extended.image_ascii
#print axioms Record.Extended.agreement_ascii
#print axioms Record.Extended.Image.read_write
#print axioms Record.Extended.Image.write_read
#print axioms Record.Extended.Image.read_write_bytes
#print axioms Record.Extended.Image.write_read_bytes
#print axioms Record.Extended.Image.denotes
#print axioms Record.Extended.Image.judgment_sound
#print axioms Record.Extended.Image.replay_sound
#print axioms Record.Extended.Image.exit_sound
#print axioms Record.Extended.Image.exit_bytes_sound
#print axioms Record.Extended.Agreement.read_write
#print axioms Record.Extended.Agreement.write_read
#print axioms Record.Extended.Agreement.read_write_bytes
#print axioms Record.Extended.Agreement.write_read_bytes
#print axioms Record.Extended.Agreement.denotes
#print axioms Record.Extended.Agreement.judgment_sound
#print axioms Record.Extended.Agreement.replay_sound
#print axioms Record.Extended.Agreement.exit_sound
#print axioms Record.Extended.Agreement.exit_bytes_sound
#print axioms Record.Extended.Returns.judgment_sound
#print axioms Record.Extended.Returns.replay_sound
#print axioms Record.Extended.Returns.exit_sound
#print axioms Record.Extended.Returns.exit_bytes_sound
