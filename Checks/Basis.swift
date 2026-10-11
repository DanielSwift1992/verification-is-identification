import VerificationIsIdentification
import Examples

enum ExpansionKeepsFirst<T: Pair>: Null
where T.Left: Pair, T.Right: Pair,
      T.Left.Left: Structure, T.Left.Right: Structure,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = TwoMacroExpansion<T>.Left
    typealias Right = T.Left.Left
}

enum ExpansionKeepsSecond<T: Pair>: Null
where T.Left: Pair, T.Right: Pair,
      T.Left.Left: Structure, T.Left.Right: Structure,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = TwoMacroExpansion<T>.Right.Left
    typealias Right = T.Left.Right
}

enum ExpansionKeepsThird<T: Pair>: Null
where T.Left: Pair, T.Right: Pair,
      T.Left.Left: Structure, T.Left.Right: Structure,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = TwoMacroExpansion<T>.Right.Right.Left
    typealias Right = T.Right.Left
}

enum ExpansionKeepsFourth<T: Pair>: Null
where T.Left: Pair, T.Right: Pair,
      T.Left.Left: Structure, T.Left.Right: Structure,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = TwoMacroExpansion<T>.Right.Right.Right.Left
    typealias Right = T.Right.Right
}

enum ExpansionEndsAfterFour<T: Pair>: Null
where T.Left: Pair, T.Right: Pair,
      T.Left.Left: Structure, T.Left.Right: Structure,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = TwoMacroExpansion<T>.Right.Right.Right.Right
    typealias Right = Never
}

enum ExpansionRetainsDefinitions<T: Pair>: Null
where T.Left: Pair, T.Right: Pair,
      T.Left.Left: Structure, T.Left.Right: Structure,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = RetainedWhole<T, TwoMacroExpansion<T>>.Right.Left
    typealias Right = T
}

typealias ResidentMacroPair = Paired<Paired<Never, ExperimentSignal>, Paired<ExperimentSignal, Never>>
typealias MacroDefinitionsSurvive = ExpansionRetainsDefinitions<ResidentMacroPair>

#if MACRO_EXPANSION_ENDS_AFTER_TWO
enum RejectedUnchangedPrimitiveBudget: Null {
    typealias Left = TwoMacroExpansion<ResidentMacroPair>.Right.Right
    typealias Right = Never
}
#endif

#if MACRO_EXPANSION_REORDERS_OPERATIONS
enum RejectedReorderedExpansion: Null {
    typealias Left = TwoMacroExpansion<ResidentMacroPair>.Left
    typealias Right = ResidentMacroPair.Right.Left
}
#endif
