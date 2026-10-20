// One file the tools' scope grants: an enum with a static function. Carried under
// `Sources/Court/` it holds; under `Sources/CourtRoom/` it has no scope.
import Foundation

enum Neighbour {
    static func read(_ path: String) -> Int {
        path.count
    }
}
