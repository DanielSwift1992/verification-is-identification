# Documents

@Metadata {
    @PageImage(purpose: card, source: "card-documents", alt: "Documents")
}

Every document in the company, read off the types — two owned vaults and four shared spaces. Access to each owned vault is listed principal by principal, read from the compiler's verdict.

![The six documents](documents-hero)

## All documents

| Document | Kind | Department | Owner | 
| --- | --- | --- | --- | 
| ``FinanceVault`` | Owned | ``Finance`` | ``Alice`` | 
| ``EngineeringRepo`` | Owned | ``Engineering`` | ``Dave`` | 
| ``FinanceShare`` | Shared | ``Finance`` | — | 
| ``EngineeringShare`` | Shared | ``Engineering`` | — | 
| ``SalesShare`` | Shared | ``Sales`` | — | 
| ``PeopleShare`` | Shared | ``People`` | — | 



@TabNavigator {
@Tab("Finance vault") {
| Person | View | Administer | Delete | 
| --- | --- | --- | --- | 
| ``Alice`` | granted | granted | granted | 
| ``Bob`` | different department | manager only | manager only | 
| ``Carol`` | granted | manager only | manager only | 
| ``Dave`` | different department | different department | owner only | 

}
@Tab("Engineering repository") {
| Person | View | Administer | Delete | 
| --- | --- | --- | --- | 
| ``Alice`` | different department | different department | owner only | 
| ``Bob`` | granted | manager only | manager only | 
| ``Carol`` | different department | manager only | manager only | 
| ``Dave`` | granted | granted | granted | 

}
}


[Company Dashboard](doc:CompanyDashboard) › Documents