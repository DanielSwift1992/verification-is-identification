// ═══════════════════════════════════════════════════════════════
// Level (Order O10).
//
// One order has two readings. Inside its game it is the strategy: it picks
// which comparison runs next. One level up the same order can be the target
// that a higher game identifies. Strategy.swift joins the interfaces this
// needs at each level (PhaseBecomesAmplitude). This file states the identity
// between the levels: the strategy coordinate of a game and the solution
// coordinate of a supplied higher game are one type.
//
// Pure types (§0′). The higher game is an axis the conformer supplies, with
// its own premises (O19). A level without a higher game is an ordinary
// conformer of HasStrategy, so this file asks for no tower. A tower of games
// needs its own height argument (Law §4).
// ═══════════════════════════════════════════════════════════════

/// The strategy a game runs, as its own coordinate.
///
/// A strategy chooses the next comparison from its observed history. O1 restricts its
/// depth and observation alphabet. O2 encodes that restricted strategy as a finite Pair
/// tree. Here `Strategy` denotes the supplied Pair code. The inline bound states that
/// representation (Law §2). Its conformance does not establish the depth bound or the
/// source encoding. The axis opens here and closes in ``StrategyBecomesTarget``.
/// [Order O1–O3]
public protocol HasStrategy: HasSigma {
    associatedtype Strategy: Pair
}

/// A supplied higher game has this game's strategy as its solution coordinate.
///
/// `Higher` is a second game with its own ``HasSolutions`` axis. The `where` clause
/// equates that axis with `Strategy`, so the checker accepts a conformer only when the
/// two coordinates are one type. The strategy code can occupy the solution coordinate of
/// a supplied higher description. This equality does not identify the strategy. Its
/// identification requires that higher game's actual candidate interpretation,
/// membership, verification and uniqueness premises. When the higher game itself
/// conforms, the next join starts from that same type, so a chain of joins shares each
/// intermediate game (Law §0′).
///
/// The identity places the strategy in the higher game's solution coordinate. That game
/// brings its own grammar, candidates, verification, encoding, query semantics, history,
/// availability and costs. Joining it with ``PassIsIdentification`` is a further premise
/// of that game. Encoding the strategy supplies none of these. [Order O10, O19]
public protocol StrategyBecomesTarget: HasStrategy
where Higher.SolutionSet == Strategy {
    associatedtype Higher: HasSolutions
}
