import Foundation

// U7/U8 on source-addressed total structural actions. This extends the same
// Context/RouteProof interpretation; it does not read another record language.
extension ContinuationCourt {
    struct ActionMember {
        let address: Path
        let image: Places
        func imageOf(_ path: Path) throws -> Path {
            guard case let .leaf(result) = try image.at(path) else {
                throw Failure("action: expected a source leaf")
            }
            return result
        }
    }
    enum Preservation: Codable {
        case preserved([EqualityBasis])
        case notPreserved(edge: Path)
    }
    struct ActionEvidence: Codable {
        var member: Path
        var preservation: Preservation
    }
    struct ReachableClass: Codable {
        var block: Int
        var question: Path
        // [g,h] denotes g composed with h, outermost to innermost.
        // Pullback folds left to right: gamma_h(gamma_g(c)).
        var word: [Path]
        var basis: EqualityBasis
    }
    struct ImageAction: Codable {
        var member: Path
        // For each retained class, an index in the retained class list.
        var targets: [Int]
        var selections: [Selection]
        var program: Program
    }
    struct StableView: Codable {
        var classes: [ReachableClass]
        var representatives: [Path]
        var view: Program
        // These are also the closure edges, including their E-paths.
        var actions: [ImageAction]
        var selections: [Selection]
        var decoder: Program
    }
    enum HiddenConclusion: Codable {
        case common(actions: [ImageAction], program: Program)
        case outside(member: Path, observation: Path, image: Path)
        case disagreement(left: Path, right: Path, observation: Path,
                          leftImage: Path, rightImage: Path)
    }
    struct HiddenJudgment: Codable {
        var classes: [Int]
        var conclusion: HiddenConclusion
        var closureInheritedFromStableView: Bool
    }
    struct Dynamics: Codable {
        var classes: [PartitionClass]
        var connections: [[EqualityStep]]
        var actions: [ActionEvidence]
        var hiddenActions: [ActionEvidence]?
        // Nil exactly when that family's E-preservation was refused.
        var stable: StableView?
        var hidden: HiddenJudgment?
    }
    struct ActionBudget {
        static let limit = 100_000
        var remaining = ActionBudget.limit
        mutating func spend(_ count: Int = 1, at: String) throws {
            guard count >= 0, count <= remaining else {
                throw Failure(at + ": action proof work limit; no impossibility inferred")
            }
            remaining -= count
        }
    }

    // Split an already interpreted product, never source text.
    static func actionMembers(_ places: Places, source: Shape, address: String,
                              output: Shape? = nil) throws -> [ActionMember] {
        var members: [ActionMember] = []
        var budget = ActionBudget()
        func split(_ p: Places, _ s: Shape, _ path: Path) throws {
            try budget.spend(at: address)
            if s == (output ?? source) {
                members.append(ActionMember(address: path, image: p))
                return
            }
            guard case let .pair(l, r) = p, case let .pair(a, b) = s else {
                let expected = output == nil ? "Source-shaped action" : "Image-shaped step"
                throw Failure(pathText(address, path) + ": expected a complete " + expected)
            }
            try split(l, a, path + [.left])
            try split(r, b, path + [.right])
        }
        try split(places, shapeOfPlaces(places, source: source, address: address), [])
        return members
    }
    static func equalityGraph(_ r: RelatedReading) -> [Path: [(Path, EqualityStep)]] {
        equalityGraph(r.whole)
    }
    static func equalityGraph(_ whole: WholeReading) -> [Path: [(Path, EqualityStep)]] {
        var graph: [Path: [(Path, EqualityStep)]] = [:]
        for edge in whole.edges {
            graph[edge.left, default: []].append((edge.right, .init(edge: edge.address, reversed: false)))
            graph[edge.right, default: []].append((edge.left, .init(edge: edge.address, reversed: true)))
        }
        return graph
    }
    // Construction only. Replay checks the closed partition and these forests.
    static func constructPartition(_ r: RelatedReading) ->
        (classes: [PartitionClass], connections: [[EqualityStep]], blocks: [Path: Int]) {
        constructPartition(r.whole)
    }
    static func constructPartition(_ whole: WholeReading) ->
        (classes: [PartitionClass], connections: [[EqualityStep]], blocks: [Path: Int]) {
        let adjacent = equalityGraph(whole)
        var seen: Set<Path> = [], classes: [PartitionClass] = [], connections: [[EqualityStep]] = []
        var blocks: [Path: Int] = [:]
        for (path, sort) in whole.source.leaves
        where seen.insert(path).inserted {
            var component = [path], forest: [EqualityStep] = []
            var cursor = 0
            while cursor < component.count {
                for (next, step) in adjacent[component[cursor]] ?? []
                where seen.insert(next).inserted {
                    component.append(next)
                    forest.append(step)
                }
                cursor += 1
            }
            for member in component { blocks[member] = classes.count }
            classes.append(.init(sort: sort, leaves: component))
            connections.append(forest)
        }
        return (classes, connections, blocks)
    }
    static func constructionBasis(_ from: Path, _ to: Path, reading r: RelatedReading,
                                  budget: inout ActionBudget) throws -> EqualityBasis {
        if from == to { return .address }
        let graph = equalityGraph(r)
        var queue = [from], cursor = 0
        var seen: Set<Path> = [from]
        var prior: [Path: (Path, EqualityStep)] = [:]
        while cursor < queue.count, !seen.contains(to) {
            let here = queue[cursor]
            cursor += 1
            for (next, step) in graph[here] ?? [] {
                try budget.spend(at: "construction.E-path")
                if seen.insert(next).inserted {
                    prior[next] = (here, step)
                    queue.append(next)
                }
            }
        }
        guard seen.contains(to) else { throw Failure("construction.E-path: endpoints have different classes") }
        var path: [EqualityStep] = [], here = to
        while here != from {
            let (previous, step) = prior[here]!
            path.append(step)
            here = previous
        }
        return .sourceRelation(Array(path.reversed()))
    }
    // Reuse U5's equality-ground checker. No path search during replay.
    static func checkActionBasis(_ basis: EqualityBasis, from: Path, to: Path,
                                 reading r: RelatedReading, edges: [Path: SourceEdge], at: String,
                                 budget: inout ActionBudget) throws {
        let count: Int
        if case let .sourceRelation(path) = basis { count = path.count } else { count = 1 }
        try budget.spend(count, at: at)
        guard try r.sort(from) == r.sort(to) else { throw Failure(at + ": selected sort differs") }
        var remainingSteps = 100_000
        try verifyEqualityBasis(basis, from: from, to: to, edges: edges, at: at,
                                stepField: "sourceRelation._0", remainingSteps: &remainingSteps)
    }
    static func distinctClasses(_ places: Places, blocks: [Path: Int]) -> [Int] {
        var seen: Set<Int> = []
        return places.leaves.compactMap { leaf in
            guard let block = blocks[leaf.source], seen.insert(block).inserted else { return nil }
            return block
        }
    }
    static func actionImage(_ action: ActionMember, of view: Places) throws -> Places {
        switch view {
        case let .leaf(path): return try .leaf(action.imageOf(path))
        case let .pair(l, r): return try .pair(actionImage(action, of: l), actionImage(action, of: r))
        }
    }
    static func classImage(_ action: ActionMember, block: Int, classes: [PartitionClass],
                           blocks: [Path: Int]) throws -> Int {
        guard classes.indices.contains(block), let representative = classes[block].leaves.first,
              let image = try blocks[action.imageOf(representative)] else { throw Failure("action: unknown class") }
        return image
    }
    static func constructEvidence(_ members: [ActionMember], reading r: RelatedReading,
                                  blocks: [Path: Int], budget: inout ActionBudget) throws -> [ActionEvidence] {
        try members.map { action in
            var paths: [EqualityBasis] = []
            for edge in r.edges {
                try budget.spend(at: "construction.preservation")
                let a = try action.imageOf(edge.left), b = try action.imageOf(edge.right)
                if blocks[a] != blocks[b] { return .init(member: action.address, preservation: .notPreserved(edge: edge.address)) }
                paths.append(try constructionBasis(a, b, reading: r, budget: &budget))
            }
            return .init(member: action.address, preservation: .preserved(paths))
        }
    }
    static func evidenceHolds(_ evidence: [ActionEvidence]) -> Bool {
        evidence.allSatisfy {
            if case .preserved = $0.preservation { return true }
            return false
        }
    }
    static func imageAction(_ action: ActionMember, view: Places, classList: [Int],
                            classes: [PartitionClass], blocks: [Path: Int], reading r: RelatedReading) throws -> ImageAction {
        let targets = try classList.map { block -> Int in
            let image = try classImage(action, block: block, classes: classes, blocks: blocks)
            guard let index = classList.firstIndex(of: image) else { throw Failure("construction: view is not closed") }
            return index
        }
        let image = try actionImage(action, of: view)
        let cut = RelatedReading(whole: r.whole, observation: view, question: image)
        guard case let .constructed(selections, program) = try constructRelated(cut) else {
            throw Failure("construction: closed view did not yield an image action")
        }
        return .init(member: action.address, targets: targets, selections: selections, program: program)
    }
    static func constructDynamics(_ r: RelatedReading) throws -> Dynamics {
        var budget = ActionBudget()
        let (classes, connections, blocks) = constructPartition(r)
        let actions = try constructEvidence(r.actions, reading: r, blocks: blocks, budget: &budget)
        let hidden = try r.hiddenActions.map { try constructEvidence($0, reading: r, blocks: blocks, budget: &budget) }
        var stable: StableView?
        if evidenceHolds(actions) {
            var reached: [ReachableClass] = [], seen: Set<Int> = []
            for leaf in r.question.leaves {
                let block = blocks[leaf.source]!
                if seen.insert(block).inserted {
                    reached.append(.init(block: block, question: leaf.output, word: [], basis: .address))
                }
            }
            var cursor = 0
            while cursor < reached.count {
                let current = reached[cursor]
                cursor += 1
                for action in r.actions {
                    try budget.spend(at: "construction.closure")
                    let image = try classImage(action, block: current.block, classes: classes, blocks: blocks)
                    if seen.insert(image).inserted {
                        reached.append(.init(block: image, question: current.question,
                                             word: current.word + [action.address], basis: .address))
                    }
                }
            }
            let representatives = reached.map { classes[$0.block].leaves[0] }
            for i in reached.indices {
                guard case let .leaf(initialOrigin) = try r.question.at(reached[i].question) else { throw Failure("construction: Question leaf") }
                var origin = initialOrigin
                for address in reached[i].word {
                    let member = r.actions.first { $0.address == address }!
                    origin = try member.imageOf(origin)
                }
                reached[i].basis = try constructionBasis(origin, representatives[i], reading: r, budget: &budget)
            }
            let view = retainedPlaces(representatives)!
            let classList = reached.map(\.block)
            let images = try r.actions.map { try imageAction($0, view: view, classList: classList, classes: classes, blocks: blocks, reading: r) }
            let cut = RelatedReading(whole: r.whole, observation: view, question: r.question)
            guard case let .constructed(selections, program) = try constructRelated(cut) else { throw Failure("construction: Question decoder") }
            stable = try .init(classes: reached, representatives: representatives,
                               view: assembledProgram(view, inputs: representatives), actions: images,
                               selections: selections, decoder: program)
        }
        var hiddenJudgment: HiddenJudgment?
        if let members = r.hiddenActions, let hidden, evidenceHolds(hidden) {
            let classList = distinctClasses(r.observation, blocks: blocks)
            let conclusion = try constructHidden(members, view: r.observation, classList: classList,
                                                 classes: classes, blocks: blocks, reading: r, budget: &budget)
            hiddenJudgment = .init(classes: classList, conclusion: conclusion,
                closureInheritedFromStableView: inheritedClosure(stable, reading: r, blocks: blocks))
        }
        return .init(classes: classes, connections: connections, actions: actions, hiddenActions: hidden,
                     stable: stable, hidden: hiddenJudgment)
    }
    static func inheritedClosure(_ stable: StableView?, reading r: RelatedReading, blocks: [Path: Int]) -> Bool {
        func sameClasses(_ a: Places, _ b: Places) -> Bool {
            switch (a, b) {
            case let (.leaf(x), .leaf(y)): return blocks[x] == blocks[y]
            case let (.pair(l, r), .pair(x, y)): return sameClasses(l, x) && sameClasses(r, y)
            default: return false
            }
        }
        guard let stable, let view = retainedPlaces(stable.representatives), sameClasses(view, r.observation),
              let hidden = r.hiddenActions else { return false }
        return hidden.allSatisfy { member in r.actions.contains { $0.image == member.image } }
    }
    static func constructHidden(_ members: [ActionMember], view: Places, classList: [Int],
                                classes: [PartitionClass], blocks: [Path: Int], reading r: RelatedReading,
                                budget: inout ActionBudget) throws -> HiddenConclusion {
        for action in members {
            for leaf in view.leaves {
                try budget.spend(at: "construction.hidden.closure")
                let image = try action.imageOf(leaf.source)
                if !classList.contains(blocks[image]!) {
                    return .outside(member: action.address, observation: leaf.output, image: image)
                }
            }
        }
        let first = members[0]
        for other in members.dropFirst() {
            for leaf in view.leaves {
                try budget.spend(at: "construction.hidden.agreement")
                let a = try first.imageOf(leaf.source), b = try other.imageOf(leaf.source)
                if blocks[a] != blocks[b] {
                    return .disagreement(left: first.address, right: other.address, observation: leaf.output,
                                         leftImage: a, rightImage: b)
                }
            }
        }
        let initial = try imageAction(first, view: view, classList: classList, classes: classes, blocks: blocks, reading: r)
        // The same written program must work for every member. Independent U5
        // constructions can choose different E-equivalent observation leaves.
        let images = try members.map { member -> ImageAction in
            let image = try actionImage(member, of: view)
            let selections = try zip(initial.selections, image.leaves).map { selection, target -> Selection in
                guard case let .leaf(from) = try view.at(selection.input) else { throw Failure("construction.hidden: input leaf") }
                return try .init(output: target.output, input: selection.input,
                                 basis: constructionBasis(from, target.source, reading: r, budget: &budget))
            }
            return .init(member: member.address, targets: initial.targets, selections: selections, program: initial.program)
        }
        return .common(actions: images, program: initial.program)
    }

    // Replay below checks finite presented data, without calling derive,
    // graph search, equivalence closure, or any construction function.
    static func verifyEvidence(_ evidence: [ActionEvidence], members: [ActionMember],
                               reading r: RelatedReading, blocks: [Path: Int], edges: [Path: SourceEdge], at: String,
                               budget: inout ActionBudget) throws -> Bool {
        guard evidence.count == members.count else { throw Failure(at + ": incomplete member coverage") }
        var holds = true
        for (index, pair) in zip(evidence, members).enumerated() {
            let (proof, member) = pair
            let here = at + "[\(index)]"
            guard proof.member == member.address else { throw Failure(here + ".member: different address or order") }
            switch proof.preservation {
            case let .preserved(paths):
                guard paths.count == r.edges.count else { throw Failure(here + ".preservation: incomplete E-edge coverage") }
                for (offset, pair) in zip(paths, r.edges).enumerated() {
                    let (path, edge) = pair
                    try checkActionBasis(path, from: member.imageOf(edge.left), to: member.imageOf(edge.right),
                                         reading: r, edges: edges, at: here + ".preservation[\(offset)]", budget: &budget)
                }
            case let .notPreserved(address):
                try budget.spend(at: here)
                guard let edge = edges[address], try blocks[member.imageOf(edge.left)] != blocks[member.imageOf(edge.right)] else {
                    throw Failure(here + ".preservation.edge: partition does not separate images of this E-edge")
                }
                holds = false
            }
        }
        return holds
    }
    static func verifyImageAction(_ proof: ImageAction, member: ActionMember, view: Places,
                                  classList: [Int], classes: [PartitionClass], blocks: [Path: Int],
                                  reading r: RelatedReading, edges: [Path: SourceEdge], at: String, budget: inout ActionBudget) throws {
        guard proof.member == member.address, proof.targets.count == classList.count else {
            throw Failure(at + ": member or closure-edge coverage differs")
        }
        try budget.spend(view.leaves.count, at: at)
        for (index, pair) in zip(classList, proof.targets).enumerated() {
            try budget.spend(at: at)
            let (block, target) = pair
            guard classList.indices.contains(target),
                  try classList[target] == classImage(member, block: block, classes: classes, blocks: blocks) else {
                throw Failure(at + ".targets[\(index)]: closure edge has another image class")
            }
        }
        let image = try actionImage(member, of: view)
        let cut = RelatedReading(whole: r.whole, observation: view, question: image)
        for selection in proof.selections {
            let count: Int
            if case let .sourceRelation(path) = selection.basis { count = path.count } else { count = 1 }
            try budget.spend(count, at: at)
        }
        try verifyRelatedProgram(proof.selections, program: proof.program, reading: cut, address: at, edgeIndex: edges)
    }
    static func verifyDynamics(_ proof: Dynamics, reading r: RelatedReading) throws {
        let at = "certificate.dynamics"
        var budget = ActionBudget()
        try budget.spend(r.source.leaves.count + r.edges.count, at: at)
        let blocks = try verifyPartition(proof.classes, whole: r.whole, at: at + ".classes")
        let edges = Dictionary(uniqueKeysWithValues: r.edges.map { ($0.address, $0) })
        try verifyEForests(proof.connections, classes: proof.classes, edges: edges, at: at + ".connections")
        let g = try verifyEvidence(proof.actions, members: r.actions, reading: r, blocks: blocks,
                                   edges: edges, at: at + ".actions", budget: &budget)
        guard g == (proof.stable != nil) else { throw Failure(at + ".stable: wrong preservation premise") }
        if let stable = proof.stable {
            try verifyStable(stable, reading: r, classes: proof.classes, blocks: blocks, edges: edges, budget: &budget)
        }
        guard (r.hiddenActions != nil) == (proof.hiddenActions != nil) else {
            throw Failure(at + ".hiddenActions: changed family coverage")
        }
        if let members = r.hiddenActions, let evidence = proof.hiddenActions {
            let h = try verifyEvidence(evidence, members: members, reading: r, blocks: blocks,
                                       edges: edges, at: at + ".hiddenActions", budget: &budget)
            guard h == (proof.hidden != nil) else { throw Failure(at + ".hidden: wrong preservation premise") }
            if let hidden = proof.hidden {
                try verifyHidden(hidden, members: members, stable: proof.stable, reading: r,
                                 classes: proof.classes, blocks: blocks, edges: edges, budget: &budget)
            }
        } else if proof.hidden != nil { throw Failure(at + ".hidden: no HiddenActions question was declared") }
    }
    static func verifyStable(_ proof: StableView, reading r: RelatedReading, classes: [PartitionClass],
                             blocks: [Path: Int], edges: [Path: SourceEdge], budget: inout ActionBudget) throws {
        let at = "certificate.dynamics.stable"
        guard !proof.classes.isEmpty, proof.classes.count == proof.representatives.count,
              proof.classes.count <= classes.count else { throw Failure(at + ".classes: incomplete view") }
        let list = proof.classes.map(\.block)
        guard Set(list).count == list.count else { throw Failure(at + ".classes: repeated class") }
        let members = Dictionary(uniqueKeysWithValues: r.actions.map { ($0.address, $0) })
        for (index, witness) in proof.classes.enumerated() {
            let here = at + ".classes[\(index)]"
            guard classes.indices.contains(witness.block), blocks[proof.representatives[index]] == witness.block else {
                throw Failure(at + ".representatives[\(index)]: expected a leaf in the selected class")
            }
            let question: Places
            do { question = try r.question.at(witness.question) }
            catch { throw Failure(here + ".question: " + String(describing: error)) }
            guard case let .leaf(initialOrigin) = question else { throw Failure(here + ".question: not a Question leaf") }
            var origin = initialOrigin
            for (offset, address) in witness.word.enumerated() {
                try budget.spend(at: here + ".word")
                guard let action = members[address] else { throw Failure(here + ".word[\(offset)]: no member at this address") }
                origin = try action.imageOf(origin)
            }
            guard blocks[origin] == witness.block else { throw Failure(here + ".word: pullback reaches another class") }
            try checkActionBasis(witness.basis, from: origin, to: proof.representatives[index], reading: r, edges: edges,
                                 at: here + ".basis", budget: &budget)
        }
        for block in distinctClasses(r.question, blocks: blocks) {
            let hasEmptyWord = proof.classes.contains { $0.block == block && $0.word.isEmpty }
            guard hasEmptyWord else {
                throw Failure(at + ".classes: the empty word must cover every Question class")
            }
        }
        let view = retainedPlaces(proof.representatives)!
        guard proof.view == (try assembledProgram(view, inputs: proof.representatives)) else {
            throw Failure(at + ".view: term differs from the representatives")
        }
        guard proof.actions.count == r.actions.count else { throw Failure(at + ".actions: incomplete closure coverage") }
        for (index, pair) in zip(proof.actions, r.actions).enumerated() {
            try verifyImageAction(pair.0, member: pair.1, view: view, classList: list, classes: classes,
                                  blocks: blocks, reading: r, edges: edges, at: at + ".actions[\(index)]", budget: &budget)
        }
        let cut = RelatedReading(whole: r.whole, observation: view, question: r.question)
        for selection in proof.selections {
            let count: Int
            if case let .sourceRelation(path) = selection.basis { count = path.count } else { count = 1 }
            try budget.spend(count, at: at + ".decoder")
        }
        try verifyRelatedProgram(proof.selections, program: proof.decoder, reading: cut,
                                 address: at + ".decoder", edgeIndex: edges)
    }
    static func verifyHidden(_ proof: HiddenJudgment, members: [ActionMember], stable: StableView?,
                             reading r: RelatedReading, classes: [PartitionClass], blocks: [Path: Int],
                             edges: [Path: SourceEdge], budget: inout ActionBudget) throws {
        let at = "certificate.dynamics.hidden"
        let list = distinctClasses(r.observation, blocks: blocks)
        guard proof.classes == list else { throw Failure(at + ".classes: expected Observation classes in occurrence order") }
        guard proof.closureInheritedFromStableView == inheritedClosure(stable, reading: r, blocks: blocks) else {
            throw Failure(at + ".closureInheritedFromStableView: conditional premise differs")
        }
        let actions = Dictionary(uniqueKeysWithValues: members.map { ($0.address, $0) })
        func observation(_ path: Path) throws -> Path {
            do {
                guard case let .leaf(origin) = try r.observation.at(path) else { throw Failure("not an Observation leaf") }
                return origin
            } catch { throw Failure(at + ".observation: " + String(describing: error)) }
        }
        switch proof.conclusion {
        case let .common(images, program):
            guard images.count == members.count else { throw Failure(at + ".common: incomplete member coverage") }
            var restriction: [Int]?
            for (index, pair) in zip(images, members).enumerated() {
                let here = at + ".common[\(index)]"
                try verifyImageAction(pair.0, member: pair.1, view: r.observation, classList: list,
                                      classes: classes, blocks: blocks, reading: r, edges: edges, at: here, budget: &budget)
                if let restriction, restriction != pair.0.targets { throw Failure(here + ".targets: hidden restrictions disagree") }
                restriction = pair.0.targets
                guard pair.0.program == program else { throw Failure(here + ".program: not the common k") }
            }
        case let .outside(member, path, image):
            let origin = try observation(path)
            guard let action = actions[member], try action.imageOf(origin) == image,
                  let block = blocks[image], !list.contains(block), !proof.closureInheritedFromStableView else {
                throw Failure(at + ".outside: image is not outside the held classes")
            }
        case let .disagreement(left, right, path, a, b):
            let origin = try observation(path)
            guard let g = actions[left], let h = actions[right],
                  try g.imageOf(origin) == a, try h.imageOf(origin) == b,
                  blocks[a] != blocks[b], try r.sort(a) == r.sort(b) else {
                throw Failure(at + ".disagreement: images are not different same-sort classes")
            }
        }
    }
    static func verifyRelatedActions(_ request: String, certificate: RelatedCertificate,
                                     source: StructuralSource, constructor: String = "Paired") throws -> Bool {
        _ = try verifyRelated(request, certificate: certificate, source: source, constructor: constructor)
        guard let proof = certificate.dynamics else { throw Failure("certificate.dynamics: no U7/U8 judgment was presented") }
        guard proof.stable != nil else { return false }
        if let evidence = proof.hiddenActions {
            guard evidenceHolds(evidence), let hidden = proof.hidden else { return false }
            if case .common = hidden.conclusion { return true }
            return false
        }
        return true
    }
}
