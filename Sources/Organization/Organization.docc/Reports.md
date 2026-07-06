# Reports

@Metadata {
    @PageImage(purpose: card, source: "card-reports", alt: "Reports")
}

The company's audit, re-proved on every build. A policy that contradicted itself would not compile, so every figure below is true as of this build.

@TabNavigator {
@Tab("Access matrix") {
``FinanceVault``

| Person | View | Administer | Delete | 
| --- | --- | --- | --- | 
| ``Alice`` | granted | granted | granted | 
| ``Bob`` | different department | manager only | manager only | 
| ``Carol`` | granted | manager only | manager only | 
| ``Dave`` | different department | different department | owner only | 

``EngineeringRepo``

| Person | View | Administer | Delete | 
| --- | --- | --- | --- | 
| ``Alice`` | different department | different department | owner only | 
| ``Bob`` | granted | manager only | manager only | 
| ``Carol`` | different department | manager only | manager only | 
| ``Dave`` | granted | granted | granted | 

}
@Tab("Standing invariants") {
Every owned document has an owner inside its own department, so data stays where it belongs.

Every owned document is led by a manager.

Finance vault owner: ``Alice`` in ``Finance``. Engineering repository owner: ``Dave`` in ``Engineering``.

4 invariants proved, counted off the type.

}
@Tab("Scale") {
Access follows the role, not the person, so the whole company resolves from a few certified rules.

| Measure | This build | 
| --- | --- | 
| Certified role-rules | 4 | 
| Accesses they certify | 200 | 
| Proofs saved per person | ×50 | 

}
}


[Company Dashboard](doc:CompanyDashboard) › Reports