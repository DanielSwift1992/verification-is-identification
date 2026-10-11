import VerificationIsIdentification

typealias CohOnePre0 = CoherentS<CoherentS<CoherentS<CoherentSource0>>>
typealias CohOnePre1 = CoherentS<CoherentS<CoherentS<CoherentSource1>>>
typealias CohOne0 = CoherentPublicX0<CoherentS<CoherentCX<CohOnePre0>>>
typealias CohOne1 = CoherentPublicX1<CoherentS<CoherentCX<CohOnePre1>>>
typealias CohTwo0 = CoherentPublicX0<CoherentCX<CoherentCZ<CoherentSource0>>>
typealias CohTwo1 = CoherentPublicX1<CoherentCX<CoherentCZ<CoherentSource1>>>
// A common phase within a public-r branch must remain admissible. For r=1
// the following actual Pauli word contributes -I on data; r=0 is unchanged.
typealias CohCommon0 = CoherentPublicZ0<CoherentPublicX0<CoherentPublicZ0<CoherentPublicX0<CohTwo0>>>>
typealias CohCommon1 = CoherentPublicZ1<CoherentPublicX1<CoherentPublicZ1<CoherentPublicX1<CohTwo1>>>>

func coherentCases() throws -> [CoherentCase] {
    let s0=try coherentModel(CoherentSource0.self,name:"CoherentSource0")
    let s1=try coherentModel(CoherentSource1.self,name:"CoherentSource1")
    return try [
        CoherentCase(source:s0,candidates:[s0,coherentModel(CohOne0.self,name:"CohOne0"),coherentModel(CohTwo0.self,name:"CohTwo0"),coherentModel(CohCommon0.self,name:"CohCommon0")]),
        CoherentCase(source:s1,candidates:[s1,coherentModel(CohOne1.self,name:"CohOne1"),coherentModel(CohTwo1.self,name:"CohTwo1"),coherentModel(CohCommon1.self,name:"CohCommon1")])]
}
