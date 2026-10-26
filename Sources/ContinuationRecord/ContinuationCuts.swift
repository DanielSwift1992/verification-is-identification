import Foundation

// Operations on already addressed cuts, independent of a source language.
extension ContinuationCore {
    public static func shapeOfPlaces(_ places: Places, source: Shape, address: String) throws -> Shape {
        switch places {
        case let .leaf(path):
            guard case let .leaf(sort) = try source.at(path) else { throw Failure(address + ": nonleaf origin") }
            return .leaf(sort)
        case let .pair(l, r):
            return try .pair(shapeOfPlaces(l, source: source, address: address),
                             shapeOfPlaces(r, source: source, address: address))
        }
    }
    // Endpoint trees have already been interpreted by RouteProof. This only
    // addresses their paired leaves; it does not parse another record syntax.
    public static func pairedPlaces(_ left: Places, _ right: Places, address: String,
                              accept: ((Path, Path, Path) throws -> Void)? = nil) throws -> [SourceEdge] {
        var edges: [SourceEdge] = []
        func walk(_ l: Places, _ r: Places, _ path: Path) throws {
            switch (l, r) {
            case let (.leaf(a), .leaf(b)):
                try accept?(a, b, path)
                edges.append(SourceEdge(address: path, left: a, right: b))
            case let (.pair(a, b), .pair(x, y)):
                try walk(a, x, path + [.left])
                try walk(b, y, path + [.right])
            default: throw Failure(pathText(address, path) + ": endpoint shapes differ")
            }
        }
        try walk(left, right, [])
        return edges
    }
}
