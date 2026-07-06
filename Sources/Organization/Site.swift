import VerificationIsIdentification


// THE SITE ORDER names the navigation as types (Order Is Object).
//
// The app's page structure, written as types, not authored as a value in the View. Each place
// names the place above it (`Up`); the dashboard is the root, its own `Up`. This is the OBJECT.
// The breadcrumb and the children that render it are the READING (View/Navigation.swift), the way
// `companyRoster` reads `Company`. It is the app's structure, not the company (Σ), so it sits with
// the architecture, not under System/. State lives in types; the View only reads it.
// ═══════════════════════════════════════════════════════════════

/// This is a place in the site: a page, knowing the place above it. `Up` is the parent. The root
/// is its `Up`. The order is this relation, a type. `Open`, not `Close` (Law §0″: `Close` must be
/// a concrete enum, not a protocol): `Up` is a real axis (EXPAND), the shape `Open` is for.
public protocol Place: Open {
    associatedtype Up: Place
}

/// The places, nested in `Nav` so their names do not collide with the Screens that render them.
/// Each place's name IS its DocC page id (read by `label`), and `Up` is the place above it.
public enum Nav {
    public enum CompanyDashboard: Place {
    public typealias Up = CompanyDashboard }
    public enum Employees: Place {
    public typealias Up = CompanyDashboard }
    public enum Departments: Place {
    public typealias Up = CompanyDashboard }
    public enum Documents: Place {
    public typealias Up = CompanyDashboard }
    public enum Tasks: Place {
    public typealias Up = CompanyDashboard }
    public enum Board: Place {
    public typealias Up = Tasks }
    public enum Directories: Place {
    public typealias Up = CompanyDashboard }
    public enum Reports: Place {
    public typealias Up = CompanyDashboard }
    public enum Cycles: Place {
    public typealias Up = Reports }
    public enum ReturnToOffice: Place {
    public typealias Up = CompanyDashboard }
}

/// This is the site order composed through `body`: the category ``AllPlaces`` conforms to,
/// rather than writing `: Open` directly (Law §0″: `Open` is a protocol).
public protocol SiteOrder: Open {}

/// This is the whole order as one type: every place, composed through the body. Order Is Object:
/// reading this one type yields the entire navigation (breadcrumbs up, children down).
public enum AllPlaces: SiteOrder {
    @StructureBuilder
    public static var body: some Structure {
        Nav.CompanyDashboard.self
        Nav.Employees.self
        Nav.Departments.self
        Nav.Documents.self
        Nav.Tasks.self
        Nav.Board.self
        Nav.Directories.self
        Nav.Reports.self
        Nav.Cycles.self
        Nav.ReturnToOffice.self
    }
}
