import Foundation

@main enum StructuralContinuationChecks {
    typealias C = ContinuationCourt
    typealias R = DefinitionReduction
    static var checks = 0
    static func expect(_ condition: Bool, _ message: String) {
        guard condition else { fatalError(message) }
        checks += 1
    }
    static func rejects(_ message: String, _ body: () throws -> Void) {
        do { try body(); fatalError("admitted: " + message) }
        catch is R.Failure { checks += 1 }
        catch { fatalError("unexpected error: \(error)") }
    }
    static func main() throws {
        if CommandLine.arguments.dropFirst().first == "--judge" {
            Judge.run(Array(CommandLine.arguments.dropFirst(2)))
            return
        }
        let paths = ["Sources/VerificationIsIdentification/Primitive.swift",
                     "Sources/Examples/TargetFrameTransport.swift",
                     "Sources/Examples/ContinuationRequests.swift"]
        let files = try paths.map { ($0,try String(contentsOfFile:$0,encoding:.utf8)) }
        let source = try StructuralSource(files:files)
        let frame = "ContinuationFrameRequest", lost = "ContinuationLostRequest"
        let p = try C.derive(frame,source:source)
        expect(p.missing.isEmpty,"reversed pair is sufficient")
        expect(p.program.swift("M",constructor:"Paired") == "Paired<M.Right, M.Left>","actual decoder reverses the view")
        _ = try C.verify(frame,certificate:p,source:source)
        let l = try C.derive(lost,source:source)
        expect(l.missing.count == 2,"two distinct absent source classes; repeated query B counted once")
        expect(l.missing.map(\.source) == [[.right,.left],[.right,.right]],"retention reads actual source paths")
        expect(l.program.swift("M",constructor:"Paired") == "Paired<M.Right.Left, Paired<M.Right.Right, M.Right.Left>>","decoder consumes the joined residual")
        let related = try C.derive("ContinuationRelatedRequest",source:source)
        expect(related.missing.isEmpty,"repeated source type field needs no residual")
        expect(related.program.swift("M",constructor:"Paired") == "M","zero residual introduces no Never or unit")
        let alias = try C.derive("ContinuationAliasRequest",source:source)
        expect(alias.missing.isEmpty,"guarded source projection alias")
        let reloaded = try C.decode(C.encode(l))
        _ = try C.verify(lost,certificate:reloaded,source:source); checks += 1

        func changed(_ path: String, _ before: String, _ after: String) throws -> StructuralSource {
            var replacements = 0
            let result = files.map { (p,t) -> (String,String) in
                guard p == path else { return (p,t) }
                guard t.contains(before) else { fatalError("missing mutation anchor: " + before) }
                replacements += 1
                return (p,t.replacingOccurrences(of:before,with:after))
            }
            expect(replacements == 1,"one source mutation")
            return try StructuralSource(files:result)
        }
        let requests = paths[2], primitives = paths[0]
        let changedQuestion = try changed(requests,
            "public typealias Question = Paired<Source.Left, Source.Right.Left>",
            "public typealias Question = Paired<Source.Right.Left, Source.Left>")
        rejects("old proof cannot retarget question") { _ = try C.verify(frame,certificate:p,source:changedQuestion) }
        let reloadedFrame = try C.decode(C.encode(p))
        rejects("serialized certificate cannot retarget question") { _ = try C.verify(frame,certificate:reloadedFrame,source:changedQuestion) }
        let changedObservation = try changed(requests,
            "public typealias Observation = Paired<Source.Right.Left, Source.Left>",
            "public typealias Observation = Paired<Source.Left, Source.Right.Left>")
        rejects("old proof cannot replace observation") { _ = try C.verify(frame,certificate:p,source:changedObservation) }
        let changedSource = try changed(paths[1],
            "Paired<A, Paired<B, R>>", "Paired<B, Paired<A, R>>")
        rejects("source-defined frame changed") { _ = try C.verify(frame,certificate:p,source:changedSource) }
        let changedPair = try changed(primitives,"public typealias Left = L","public typealias Left = R")
        rejects("pair interpretation cannot be changed by retaining its name") { _ = try C.verify(frame,certificate:p,source:changedPair) }
        let strengthened = try changed(primitives,"public protocol Pair: Open {","public protocol Pair: Open where Left == Right {")
        rejects("inherited application condition not silently ignored") { _ = try C.verify(frame,certificate:p,source:strengthened) }
        let strengthenedLeaf = try changed(primitives,"public protocol Structure {","public protocol Structure: Pair {")
        rejects("opaque sort cannot acquire pair axes silently") { _ = try C.verify(frame,certificate:p,source:strengthenedLeaf) }
        let changedGuard = try changed(requests,"ContinuationSecond<S: Pair> = S.Right",
            "ContinuationSecond<S: Pair> = S.Right where S.Left == S.Right")
        rejects("same expansion with a strengthened guard") { _ = try C.verify("ContinuationAliasRequest",certificate:alias,source:changedGuard) }
        let extra = try StructuralSource(files:files + [("unrelated","enum Unused { typealias Value = Never }")])
        _ = try C.verify(frame,certificate:p,source:extra); checks += 1
        let renamedFiles = files.map { ($0.0,$0.1.replacingOccurrences(of:frame,with:"RenamedRequest")) }
        let renamed = try C.derive("RenamedRequest",source:StructuralSource(files:renamedFiles))
        expect(renamed.missing.isEmpty,"request names have no built-in answer")
        let renamedPairFiles = files.map { ($0.0,$0.1.replacingOccurrences(of:"Paired",with:"JoinedShape")) }
        let renamedPairSource = try StructuralSource(files:renamedPairFiles)
        let renamedPair = try C.derive(frame,source:renamedPairSource,constructor:"JoinedShape")
        expect(renamedPair.program.swift("M",constructor:"JoinedShape") == "JoinedShape<M.Right, M.Left>","constructor equations, not its name")
        let reorderedParams = try changed(requests,
            "ContinuationFrameRequest<A: Structure, B: Structure, R: Structure>",
            "ContinuationFrameRequest<B: Structure, A: Structure, R: Structure>")
        rejects("changed generic binding") { _ = try C.verify(frame,certificate:p,source:reorderedParams) }

        var forged = p
        forged.program = .pair(.pick([.left]),.pick([.right]))
        rejects("wrong program cannot use a successful read certificate") { _ = try C.verify(frame,certificate:forged,source:source) }
        forged = p; forged.question = p.observation
        rejects("matching endpoint shapes do not replace the question endpoint") { _ = try C.verify(frame,certificate:forged,source:source) }
        forged = p; forged.program = .pick([.left,.left])
        rejects("route cannot inspect an opaque field") { _ = try C.verify(frame,certificate:forged,source:source) }
        forged = l; forged.missing.removeLast()
        rejects("omitted necessary residual") { _ = try C.verify(lost,certificate:forged,source:source) }
        forged = l; forged.missing.append(l.missing[0])
        rejects("repeated residual not minimal") { _ = try C.verify(lost,certificate:forged,source:source) }
        forged = l; forged.missing[0] = .init(source:[.left],question:[.left])
        rejects("residual from a different source field") { _ = try C.verify(lost,certificate:forged,source:source) }
        rejects("different request identity") { _ = try C.verify(lost,certificate:p,source:source) }
        forged = p; forged.question = .leaf("$foreign")
        rejects("foreign rigid leaf") { _ = try C.verify(frame,certificate:forged,source:source) }
        if case let .definition(input,args,body) = p.question {
            forged = p
            forged.question = .definition(input,Array(args.reversed()),body)
            rejects("wrong argument proofs with the original body") { _ = try C.verify(frame,certificate:forged,source:source) }
        } else { fatalError("expected source field step") }

        func added(_ text: String) throws -> StructuralSource {
            try StructuralSource(files:files + [("adversary",text)])
        }
        let invalids = [
            """
            enum Bad<A: Structure, B: Structure> {
                typealias Source = A
                typealias Observation = A
                typealias Question = B
            }
            """,
            """
            enum Bad<A: Structure> {
                typealias Source = A
                typealias Observation = A.Left
                typealias Question = A
            }
            """,
            """
            typealias Erase<X: Structure, Y: Structure> = X
            enum Bad<A: Structure> {
                typealias Source = A
                typealias Observation = Erase<A, UnknownHead>
                typealias Question = A
            }
            """,
            """
            typealias Erase<X: Structure, Y: Structure> = X
            enum Bad<A: Structure> {
                typealias Source = A
                typealias Observation = Erase<A, ContinuationSecond<A>>
                typealias Question = A
            }
            """,
            """
            typealias Loop<X: Structure> = Loop<X>
            enum Bad<A: Structure> {
                typealias Source = A
                typealias Observation = Loop<A>
                typealias Question = A
            }
            """,
            """
            enum Bad<A: Structure, B: Structure> where A == B {
                typealias Source = Paired<A, B>
                typealias Observation = A
                typealias Question = B
            }
            """
        ]
        for (index,text) in invalids.enumerated() {
            rejects("unsupported input \(index) cannot be called absence") { _ = try C.derive("Bad",source:added(text)) }
        }
        let conditional = try added("""
        #if SOMETHING
        extension ContinuationFrameRequest { typealias Question = A }
        #endif
        """)
        rejects("conditional override not silently omitted") { _ = try C.verify(frame,certificate:p,source:conditional) }
        let privateSource = try changed(requests,"public enum ContinuationFrameRequest", "private\nenum ContinuationFrameRequest")
        rejects("file private request unavailable to emitted separate file") { _ = try C.derive(frame,source:privateSource) }
        for field in ["Source","Observation","Question"] {
            let inaccessibleField = try changed(requests,"public typealias " + field,"private typealias " + field)
            rejects("private member \(field) unavailable to emitted separate file") { _ = try C.derive(frame,source:inaccessibleField) }
        }
        let prefixed = try StructuralSource(files:files.map { (path,text) in
            (path,path == requests ? "private class UnusedClass {}\n" + text.replacingOccurrences(of:"public enum",with:"enum") : text)
        })
        _ = try C.verify(frame,certificate:p,source:prefixed); checks += 1
        let shadowed = try added("typealias A = Never\ntypealias B = Never\ntypealias R = Never")
        _ = try C.verify(frame,certificate:p,source:shadowed); checks += 1

        // A whole-subtree route is another valid program with the same effect.
        // Replay checks the effect, not a canonical spelling chosen by derive.
        let identitySource = try added("""
        enum IdentityRequest<A: Structure, B: Structure> {
            typealias Source = Paired<A, B>
            typealias Observation = Source
            typealias Question = Source
        }
        """)
        var identity = try C.derive("IdentityRequest",source:identitySource)
        identity.program = .pick([])
        _ = try C.verify("IdentityRequest",certificate:identity,source:identitySource); checks += 1

        let erasedGuardSource = try added("""
        typealias FirstOnly<X: Structure, Y: Pair> = X
        enum ErasedGuardRequest<A: Structure, B: Structure> {
            typealias Source = Paired<A, B>
            typealias Observation = FirstOnly<A, Source>
            typealias Question = A
        }
        """)
        let erasedGuard = try C.derive("ErasedGuardRequest",source:erasedGuardSource)
        let stricterErased = try added("""
        typealias FirstOnly<X: Structure, Y: Pair> = X where Y.Left == Y.Right
        enum ErasedGuardRequest<A: Structure, B: Structure> {
            typealias Source = Paired<A, B>
            typealias Observation = FirstOnly<A, Source>
            typealias Question = A
        }
        """)
        rejects("guard strengthened on erased argument") { _ = try C.verify("ErasedGuardRequest",certificate:erasedGuard,source:stricterErased) }

        let output = CommandLine.arguments[1]
        var generated = try [(frame,p),(lost,l),("ContinuationRelatedRequest",related),("ContinuationAliasRequest",alias)]
            .map { try C.swift($0.0,certificate:$0.1,source:source) }.joined(separator:"\n")
        generated += """

        enum IdentityRequest<A: Structure, B: Structure> {
            typealias Source = Paired<A, B>
            typealias Observation = Source
            typealias Question = Source
        }

        """
        generated += try C.swift("IdentityRequest",certificate:identity,source:identitySource)
        generated += """

        // The generated answer is consumed by an existing VI action. The
        // resulting equality is derived, not required as a generic premise.
        enum GeneratedContinuationNextUse<A: Structure, B: Structure, R: Structure>: Null {
            typealias Source = ContinuationFrameRequest<A, B, R>.Source
            typealias Observed = ContinuationFrameRequest<A, B, R>.Observation
            typealias Restored = ContinuationFrameRequestContinuation<Observed>.Answer
            typealias Left = ReadFrameTargetPair<ExchangeFrameTargets<Source>.Answer>.Answer
            typealias Right = ExchangeRetainedTargets<Restored>.Answer
        }

        """
        try generated.write(toFile:output + "/Generated.swift",atomically:true,encoding:.utf8)
        print("structural continuation: \(checks) source, construction, replay and adversarial checks passed")
    }
}
