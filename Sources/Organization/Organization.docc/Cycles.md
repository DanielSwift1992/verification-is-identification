# Review Cycles

@Metadata {
    @PageImage(purpose: card, source: "card-cycles", alt: "Review Cycles")
}

Some companies run forced distribution: rank everyone each year and let the bottom share go, here enforced by the People manager who owns the policy. Microsoft did it until 2013, and Amazon ran a version of it. This demo does not rank or score anyone — a real system would, from its performance data. It takes the decision as given and shows the part that holds by construction: the year cannot close until the cut is recorded.

![Review cycles](cycles-hero)

## The timeline

| Year | Batch (5% of 200) | Enforced by | Committed cut | 
| --- | --- | --- | --- | 
| 2026 | 10 | ``Emp0011`` | ``Cut2026`` | 
| 2027 | 10 | ``Emp0011`` | ``Cut2027`` | 
| 2028 | 10 | ``Emp0011`` | ``Cut2028`` | 
| 2029 | 10 | ``Emp0011`` | ``Cut2029`` | 



The last column is the confirming fact, not a tick: each links to the ``CommittedCut`` type that closed the year. Open it for the cycle, the enforcer, and the interlock.

## The batch, year by year

- 2026: ``Emp0002``, ``Emp0100``, ``Emp0101``, ``Emp0102``, ``Emp0103``, ``Emp0104``, ``Emp0105``, ``Emp0106``, ``Emp0107``, ``Emp0108``
- 2027: ``Emp0004``, ``Emp0110``, ``Emp0111``, ``Emp0112``, ``Emp0113``, ``Emp0114``, ``Emp0115``, ``Emp0116``, ``Emp0117``, ``Emp0118``
- 2028: ``Emp0006``, ``Emp0120``, ``Emp0121``, ``Emp0122``, ``Emp0123``, ``Emp0124``, ``Emp0125``, ``Emp0126``, ``Emp0127``, ``Emp0128``
- 2029: ``Emp0008``, ``Emp0130``, ``Emp0131``, ``Emp0132``, ``Emp0133``, ``Emp0134``, ``Emp0135``, ``Emp0136``, ``Emp0137``, ``Emp0138``


A batch each year, not one name: the 5% band, 10 of the founding 200. The committed cut names its whole cohort in the types, and the policy pins that cohort to exactly the band (`Cohort.Length == Ten`), so a cut of a different size will not compile and the 5% is enforced, not just claimed. A departed person's type stays in the roster, since the system is static, and their card marks the year-close that ended their tenure.

## Year-close headcount requirements

| Department | People | Cap (30%) | Within | 
| --- | --- | --- | --- | 
| ``Finance`` | 45 | 60 | within | 
| ``Engineering`` | 71 | 60 | over cap | 
| ``Sales`` | 56 | 60 | within | 
| ``People`` | 28 | 60 | within | 



Headcount is the first ORDERED quantity here: a cap asks how many are ≤ X, a comparison, where the atoms (names, ranks) compare only by identity. The framework's marker for such a value is `IntegerValued`. The cap is a policy, and its satisfaction is read off the roster at the close. Every department is within cap, so the requirements hold.

## The interlock: closing the year requires a cut

> Important: The next year is `Closed<Prev, Cut>`: a type you cannot write without a cut committed for that year. The cut must name the whole band the policy lets go — 10 people, 5% of the founding 200 — and its enforcer must be a manager. A cut that names a different number will not compile, so the size is proved, not just stated. The chain compiles through 2030, so every year closed with its cut.

## What the demo leaves out

> Note: No ranking runs here, and no score is stored. A real system would hold performance data and compute the cut from it. The demo keeps the decision as data and enforces the one thing that holds by construction: the year does not close until the cut is recorded. This is the move for a policy like this one — rather than trust a process to run, make the next state unreachable until the decision is on record.

[Company Dashboard](doc:CompanyDashboard) › [Reports](doc:Reports) › Review Cycles