# Return to Office

@Metadata {
    @PageImage(purpose: card, source: "card-returntooffice", alt: "Return to Office")
}

The office-arrangement policy, read off the types: which arrangements clear the office minimum, and which do not.

![Return to office arrangements](rto-hero)

``Remote``  ‖ *office minimum* ‖  ``Hybrid`` -> ``OnSite``

| Arrangement | Meets office minimum | 
| --- | --- | 
| ``OnSite`` | yes | 
| ``Hybrid`` | yes | 
| ``Remote`` | no | 



## Who clears it

| Person | Works | Meets office minimum | 
| --- | --- | --- | 
| ``Alice`` | ``OnSite`` | yes | 
| ``Bob`` | ``Hybrid`` | yes | 
| ``Carol`` | ``Remote`` | no | 
| ``Dave`` | ``OnSite`` | yes | 



## Across the company

| Category | People | 
| --- | --- | 
| ``OnSite`` | 68 | 
| ``Hybrid`` | 66 | 
| ``Remote`` | 66 | 



## Why the arrangement, not the hours

The policy asks two different questions, and this page proves the cheap one. Which arrangement a person holds is a marker: one conformance, checked by name. How many hours they actually logged would be an ordered quantity — a typed count compared against a threshold, Peano `>=` — a strictly heavier move (Distance Is Cost: the price of a claim is the structure it must carry). The demo proves the marker half and names the ordered half as the next, dearer step. The boundary between the two is exactly where the type gets more expensive.

> Warning: The third arrangement is not merely listed as "no". Compile ``Carol`` as office-compliant and the build refuses: her `Site` is ``Remote``, and the office-minimum conformance has no instance over `Remote` to satisfy. The refusal names the rule, not just the person.

Read the types: ``OfficeArrangement``, ``Workplace``, ``ComesToOffice``, ``MeetsOfficeMinimum``

[Company Dashboard](doc:CompanyDashboard) › Return to Office