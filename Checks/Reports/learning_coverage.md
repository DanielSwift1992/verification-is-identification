# A full cache is not a certificate of generalization

## Entries versus covered rule classes

Four tasks have required rules (0,0,0,1). Three distinct successful tasks can
produce entries (task₀,rule₀), (task₁,rule₀), (task₂,rule₀): three entries,
but only one of two rule classes covered. Repeating those tasks need never
visit the other class. Count newly represented classes, not successful events.

Complete libraries {(task₀,rule₀),(task₃,rule₁)} and
{(task₁,rule₀),(task₃,rule₁)} have the same rule projection and different raw entries.

## Coverage versus dispatch

Both required rules may be stored. If two new tasks expose the same feature
and need different rules, no deterministic feature-only decoder can choose
correctly for both. A new discriminating measurement or a sufficient feature
map is required. Reverification may supply such information and incurs its own work.

Even with all four rules covered and the same allowed name/coordinate tests,
a sequential-name dispatcher takes 3 questions worst and 9/4 mean. An optimal
dispatcher takes 2 worst and 2 mean. Cache completeness does not certify optimality.

## Coverage needs an arrival model

For independent uniform draws from K classes, expected cover time is K·H_K.
For arbitrary positive IID class probabilities, the probability of an incomplete
library after n draws is at most the sum over classes of (1−p_class)^n.
Choose one fair hidden bit once and repeat its class forever: each time has
uniform marginal probabilities, yet one class is never visited. Marginals alone
do not justify a coupon-collector argument. IID arrivals are a separate model,
not a consequence of whole-system closure or retaining memory.

## Uniqueness within a family versus truth of the family

Two-input binary tables encode possible fixed laws. Observe only the first input, with answer 0.

| Assumed family | Surviving tables | Certified second answer within family |
|---|---|---|
| {(0,0),(1,1)}: constant laws | {(0,0)} | 0 |
| All four binary tables | {(0,0),(0,1)} | Undetermined |

The actual fixed law (0,1) agrees with the observation, but lies outside the
constant family and gives second answer 1. A checker of that restricted
family correctly proves its conditional claim and cannot certify the missing
family-adequacy premise from the same observation.

For all binary laws on n inputs, m distinct observed cells leave exactly
2^(n−m) laws. Every unobserved cell has both possible labels. A valid restriction
such as constancy supplies generalization, but the observations alone do not
establish that restriction. Expanding the family may retract predictions while
every empirical observation remains recorded and true.

The hidden table, queried input, controller and memory belong to the same whole.
The models compare possible internal tables; they do not change the actual law
between queries. No physical memory, time or heat bound follows from this audit.
