# ``GrammarLexicon``

The style linter's vocabulary: the words, scopes, and grants every source file is judged against.

## Overview

The style check (`swift run Tools grammar`) re-states each source file as one typed
object over this vocabulary, and the compiler judges the object: an atom used where its
scope grants no token fails on its own line, with the token named. Nothing here is
universal by design — every grant names its context and its scope explicitly, so a
violation is always a specific refusal, never a general warning. The linter that carries
files into this vocabulary lives in Tools; this module supplies the types the carried
objects are judged against.

## Topics

### The contexts

Where an atom stands: plain code, a builder body, a line head — and the sensitivities that decide it.

- ``PlainToken``
- ``BuilderToken``
- ``OpensBuilder``
- ``Midline``
- ``DeclarationHead``
- ``LineModifier``
- ``LineSensitive``
- ``PairSensitive``
- ``Declares``
- ``StructureBuilderMark``

### The scopes and their grants

One scope per region of the repository, each granting exactly the tokens its files may spell.

- ``BuilderToken``
- ``DemoToken``
- ``EngineToken``
- ``LatticeToken``
- ``PlainToken``
- ``SurfaceToken``
- ``SystemToken``
- ``ToolsToken``
- ``DemoScope``
- ``EngineScope``
- ``LatticeScope``
- ``SurfaceScope``
- ``SystemScope``
- ``ToolsScope``
- ``DemoScopeBuilderTokens``
- ``DemoScopeExemptTokens``
- ``DemoScopePlainTokens``
- ``EngineScopeBuilderTokens``
- ``EngineScopeExemptTokens``
- ``EngineScopePlainTokens``
- ``LatticeScopeBuilderTokens``
- ``LatticeScopeExemptTokens``
- ``LatticeScopePlainTokens``
- ``SurfaceScopeBuilderTokens``
- ``SurfaceScopeExemptTokens``
- ``SurfaceScopePlainTokens``
- ``SystemScopeBuilderTokens``
- ``SystemScopeExemptTokens``
- ``SystemScopePlainTokens``
- ``ToolsScopeBuilderTokens``
- ``ToolsScopeExemptTokens``
- ``ToolsScopePlainTokens``

### The carried keywords

Swift's own words, carried as atoms.

- ``ActorWord``
- ``CatchWord``
- ``ClassWord``
- ``DeferWord``
- ``DeinitWord``
- ``DoWord``
- ``ElseWord``
- ``EnumWord``
- ``ExtensionWord``
- ``ForWord``
- ``FuncWord``
- ``GuardWord``
- ``IfWord``
- ``InitWord``
- ``LetWord``
- ``OperatorWord``
- ``ProtocolWord``
- ``PublicWord``
- ``RepeatWord``
- ``SomeWord``
- ``StaticWord``
- ``StructWord``
- ``SubscriptWord``
- ``SwitchWord``
- ``TypealiasWord``
- ``VarWord``
- ``WhereWord``
- ``WhileWord``

### The witness names

The five readings a Structure may declare, and the category that marks them.

- ``TypeNameWord``
- ``CountWord``
- ``LabelsWord``
- ``BodyWord``
- ``SpelledWord``
- ``WitnessName``

### The magnitude words

The rung vocabulary: granted to the dictionary and the engine room, refused to canvases.

- ``U1Word``
- ``U2Word``
- ``U4Word``
- ``U8Word``
- ``U16Word``
- ``U32Word``
- ``U64Word``
- ``U128Word``
- ``U256Word``
- ``U512Word``
- ``TimesWord``

### The exemption door

Prose and comments pass as data; the door that admits them is itself typed.

- ``GrammarExempt``
- ``ExemptionReason``
- ``OpensExempt``
- ``GrammarExemptMark``
- ``TripleQuote``
- ``LineCommentOpen``
- ``BlockCommentOpen``
- ``BlockCommentClose``

### The schema and the mirror

The registries the linter reads at runtime, and the carrier the check compiles.

- ``Schema``
- ``Formation``
- ``Spelling``
- ``SpellingCensus``
- ``SpellingGate``
- ``ScopeCensus``
- ``GrantCheck``
- ``MirrorGrows``
- ``UngatedWalk``
- ``Linter``

