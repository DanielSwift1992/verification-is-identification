# VI acquisition loop: exact finite comparison

Fixed adequate noiseless Boolean family, uniform actual source, static source across two identical requests; all sensors cost one call. Optimal means minimum expected calls to full completion, not maximum success probability at each truncated budget. Random means exact uniform permutation, represented by an internal prepared tape.

Each row below gives two requests at the full sensor budget. Lower-budget rows and traces are in the JSON report.

| Model | Strategy | Source calls | New records | Completed requests | Certificate issue / reuse checks | Compiler supports / partition entries |
|---|---|---:|---:|---:|---:|---:|
| two_independent_bits | random_order | 4 | 4 | 2 | 12 / 0 | 7 / 16 |
| two_independent_bits | greedy_entropy | 4 | 4 | 2 | 12 / 0 | 7 / 28 |
| two_independent_bits | optimal_mean | 4 | 4 | 2 | 12 / 0 | 9 / 48 |
| two_independent_bits | optimal_with_evidence | 2 | 2 | 2 | 8 / 0 | 9 / 48 |
| two_independent_bits | optimal_with_certificates | 2 | 2 | 2 | 5 / 3 | 9 / 48 |
| declared_constant_family | random_order | 2 | 2 | 2 | 4 / 0 | 3 / 4 |
| declared_constant_family | greedy_entropy | 2 | 2 | 2 | 4 / 0 | 3 / 8 |
| declared_constant_family | optimal_mean | 2 | 2 | 2 | 4 / 0 | 3 / 8 |
| declared_constant_family | optimal_with_evidence | 1 | 1 | 2 | 3 / 0 | 3 / 8 |
| declared_constant_family | optimal_with_certificates | 1 | 1 | 2 | 2 / 1 | 3 / 8 |
| xor_from_components | random_order | 4 | 4 | 2 | 6 / 0 | 7 / 16 |
| xor_from_components | greedy_entropy | 4 | 4 | 2 | 6 / 0 | 7 / 28 |
| xor_from_components | optimal_mean | 4 | 4 | 2 | 6 / 0 | 9 / 48 |
| xor_from_components | optimal_with_evidence | 2 | 2 | 2 | 4 / 0 | 9 / 48 |
| xor_from_components | optimal_with_certificates | 2 | 2 | 2 | 3 / 1 | 9 / 48 |
| nine_source_counterexample | random_order | 62/9 | 62/9 | 2 | 400/9 / 0 | 183/10 / 339/5 |
| nine_source_counterexample | greedy_entropy | 62/9 | 62/9 | 2 | 400/9 / 0 | 17 / 175 |
| nine_source_counterexample | optimal_mean | 20/3 | 20/3 | 2 | 130/3 / 0 | 50 / 1410 |
| nine_source_counterexample | optimal_with_evidence | 10/3 | 10/3 | 2 | 80/3 / 0 | 50 / 1410 |
| nine_source_counterexample | optimal_with_certificates | 10/3 | 10/3 | 2 | 49/3 / 31/3 | 50 / 1410 |

Metrics sum two requests. completed_requests and settled_answer_events count successful request events, not novel semantic facts. new_records counts writes including reacquisition; retained_records counts final distinct sensor records. checker_table_cells counts input table volume per semantic pass, not CPU instructions. Compilation is charged once per prepared policy; supports and partition_entries describe only that algorithm, not total runtime or energy. JSON, hashing, allocation, target scans, prior arithmetic and setup costs are not included.

Closed cycle checks establish a finite abstract joint permutation on trajectory histories. Preparation, program, family and enough history are premises. Recovery removes accessible progress. No permanent learning, locality or thermodynamic cost theorem follows.

Retaining evidence already eliminates the second acquisition. Cached certificates do not reduce source calls further here, and their scope checks can increase computational work. These runs demonstrate conditional answer reuse, not a general speed advantage for a gate architecture.
