# A locally best question can force a worse search

Fixed known table, static source, exact binary readings, unit query cost and uniform prior.

## Nine-state witness

| State | A | B | C | D | E |
|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | 1 | 1 | 0 | 1 | 0 |
| 2 | 1 | 0 | 1 | 0 | 1 |
| 3 | 1 | 0 | 0 | 0 | 1 |
| 4 | 1 | 0 | 1 | 1 | 0 |
| 5 | 0 | 1 | 0 | 0 | 0 |
| 6 | 0 | 0 | 1 | 0 | 0 |
| 7 | 0 | 0 | 0 | 1 | 0 |
| 8 | 0 | 0 | 0 | 0 | 1 |

Every row is distinct. The task is to identify the row.

| First query | Split | Answer entropy, bits | Best possible worst cost | Best possible mean cost |
|---|---|---|---|---|
| A | 5 / 4 | 0.991076 | 5 | 31/9 |
| B | 7 / 2 | 0.764205 | 4 | 31/9 |
| C | 6 / 3 | 0.918296 | 4 | 10/3 |
| D | 6 / 3 | 0.918296 | 4 | 10/3 |
| E | 6 / 3 | 0.918296 | 4 | 10/3 |

A is uniquely most balanced. Even an optimal continuation after A costs 5 in the worst case and 31/9 on average.
Starting with C, D or E permits worst cost 4 and mean 10/3. The objectives are optimized separately.
After A=0, the five remaining rows can only be tested one at a time by the other four queries.
This is a property of the remaining partitions, not merely their cardinality.

The JSON stores executable optimal policies and a policy for each forced first query and objective.
Every policy is replayed against every row. Exhaustive reduced-tree depth-vector enumeration independently verifies the minima.

## Three-state quantifier gap

Each of three identity tests certifies its own target in one query. Certificate vector: (1,1,1).
Every optimal full policy has a permutation of depths (1,2,2), so no single policy attains every instance certificate.

## Target information can arrive only after preparation

For q=a XOR b on two uniform bits, observing either input alone gives zero mutual information about q.
Observing both settles it. Rejecting all zero-immediate-target-information questions would block every solution.

## Scope

This demonstrates known decision-tree distinctions inside VI. It is not an empirical claim that greedy heuristics are always poor.
A known query table is a synthesis premise. The runtime policy sees only its stored node and actual query outcomes.
Both worst-optimal and forced-A policies also run inside finite closed permutation windows: 45 and 54 whole configurations.
Source, controller history and clock phase are internal. The next recovery step resets the accessible history.
This is an abstract finite completion, not a physical implementation cost or unlimited retention theorem.
State-changing source actions, learned tables, physical memory costs and thermodynamic conclusions are outside this model.
