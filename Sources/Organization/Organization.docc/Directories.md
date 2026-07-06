# Directories

@Metadata {
    @PageImage(purpose: card, source: "card-directories", alt: "Directories")
}

Every attribute is a directory: a protocol whose conforming types are its atoms. Open a directory to see its values, and open a value to see what it conforms to and every sibling beside it. Each link lands on the type's own DocC page, so the web you walk is the type lattice itself.

## The directories

- ``Gender``
- ``Department``
- ``BirthYear``
- ``GivenName``
- ``FamilyName``
- ``TaskState``
- ``Workplace``


## The capability refinement (rank)

- ``CanView``
- ``CanEdit``
- ``CanAdmin``


``CanView`` -> ``CanEdit`` -> ``CanAdmin``

## The office-minimum refinement (return to office)

- ``Workplace``
- ``ComesToOffice``


``Remote``  ‖ *office minimum* ‖  ``Hybrid`` -> ``OnSite``

[Company Dashboard](doc:CompanyDashboard) › Directories