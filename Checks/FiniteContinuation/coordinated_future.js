"use strict";
// Joint control/background episodes are compared against all finite futures
// of an explicitly supplied mathematical interface. No hardware inference.
const assert=require("node:assert/strict");
const C=require("./coordinated_continuation.js");
const {eye,adj,mm,minus,eq,isZero,rank}=C.exact;
const pull=(U,O)=>mm(mm(adj(U),O),U);
const agrees=(R,A,B,O)=>isZero(mm(mm(R,minus(pull(A,O),pull(B,O))),R));
const remainingContracts=new WeakMap();
class FutureBoundary extends C.MathematicalBoundary {
  continue(request,access,context,solution){return continueBoundary(this,request,access,context,solution);}
}
function inSpan(basis,O){return rank([...basis,O].map(x=>x.flat()))===basis.length;}
function validateInterface(model,context) {
  assert.equal(context.kind,"specified-per-section-evolution");
  eq(mm(adj(context.background),context.background),model.I);
  assert(context.questions.length>0);
  context.questions.forEach(O=>{eq(adj(O),O);assert.equal(O.length,model.I.length);});
  const names=new Set();
  for(const action of context.futureActions){assert(!names.has(action.name));names.add(action.name);eq(mm(adj(action.operator),action.operator),model.I);}
}
function episode(model,score,context) {
  validateInterface(model,context);
  // Each control section is followed by the specified environment episode.
  // This is an actual model definition, not equality of wall-clock durations.
  return score.reduce((U,s)=>mm(mm(context.background,C.sectionOperator(model,s)),U),model.I);
}
function compare(model,R,A,B,context) {
  validateInterface(model,context);
  if(isZero(mm(minus(A,B),R)))return {kind:"same-operator-on-input"};
  const basis=[],origins=[];let witness=null;
  const add=(O,origin)=>{
    if(!agrees(R,A,B,O)){witness={...origin,operator:O};return;}
    if(!inSpan(basis,O)){basis.push(O);origins.push(origin);}
  };
  context.questions.forEach((O,i)=>{if(!witness)add(O,{question:i,word:[]});});
  for(let i=0;i<basis.length&&!witness;i++)for(const action of context.futureActions){
    add(pull(action.operator,basis[i]),{question:origins[i].question,word:[action.name,...origins[i].word]});
    if(witness)break;
  }
  return witness?{kind:"distinguishing-future",witness}:{kind:"closed-future-space",basis};
}
function verifyComparison(model,R,A,B,context,certificate) {
  validateInterface(model,context);
  if(certificate.kind==="same-operator-on-input") {
    eq(mm(A,R),mm(B,R));return true;
  }
  if(certificate.kind==="closed-future-space") {
    const {basis}=certificate;assert.equal(rank(basis.map(x=>x.flat())),basis.length);
    for(const O of basis){eq(adj(O),O);assert(agrees(R,A,B,O),"future effect distinguishes actual episodes");}
    for(const O of context.questions)assert(inSpan(basis,O),"certificate omitted a required question");
    for(const action of context.futureActions)for(const O of basis)
      assert(inSpan(basis,pull(action.operator,O)),"certificate omitted a permitted continuation");
    return true;
  }
  assert.equal(certificate.kind,"distinguishing-future");
  const {question,word,operator}=certificate.witness;
  assert(Number.isInteger(question)&&question>=0&&question<context.questions.length);
  let U=model.I;
  for(const name of word){const action=context.futureActions.find(a=>a.name===name);assert(action);U=mm(action.operator,U);}
  const O=pull(U,context.questions[question]);eq(O,operator);
  assert(!agrees(R,A,B,O),"proposed future does not distinguish");return false;
}
function compile(model,request,access,context) {
  const candidate=C.compile(model,request,access);
  const A=episode(model,candidate.plan.score,context),B=episode(model,request.targetScore,context);
  const certificate=compare(model,request.inputProjector,A,B,context);
  const accepted=verifyComparison(model,request.inputProjector,A,B,context,certificate);
  if(accepted)return {plan:candidate.plan,certificate,physicalAdmission:null};
  const retained={rule:"retain-source-score",source:model.source,score:structuredClone(request.targetScore)};
  C.verifyPlan(model,request,access,retained);
  return {plan:retained,rejectedCandidate:candidate.plan,obstruction:certificate,
    certificate:compare(model,request.inputProjector,B,B,context),physicalAdmission:null};
}
function continueBoundary(boundary,request,access,context,solution) {
  assert(boundary instanceof FutureBoundary,"use the boundary carrying the remaining continuation contract");
  const model=boundary.model;
  C.verifyPlan(model,request,access,solution.plan);
  const A=episode(model,solution.plan.score,context),B=episode(model,request.targetScore,context);
  assert(verifyComparison(model,request.inputProjector,A,B,context,solution.certificate));
  const previous=remainingContracts.get(boundary);
  if(previous) {
    // A sufficient inherited contract, checked before mutating the actual input.
    // It can conservatively reject an extension; that is not an impossibility theorem.
    for(const O of context.questions)assert(inSpan(previous,O),"new question exceeds the inherited future");
    for(const action of context.futureActions)for(const O of previous)
      assert(inSpan(previous,pull(action.operator,O)),"new contact exceeds the inherited future");
    for(const U of [A,B])for(const O of previous)
      assert(inSpan(previous,pull(U,O)),"next episode exceeds the inherited future");
  }
  const R=C.exact.kron(request.inputProjector,eye(boundary.referenceDimension));
  eq(mm(mm(R,boundary.rho),R),boundary.rho);
  const U=C.exact.kron(A,eye(boundary.referenceDimension));
  boundary.rho=mm(mm(U,boundary.rho),adj(U));
  if(!previous&&solution.certificate.kind==="closed-future-space")
    remainingContracts.set(boundary,structuredClone(solution.certificate.basis));
  boundary.history.push({rule:solution.plan.rule,sections:solution.plan.score.length,
    continuationScope:solution.certificate.kind,context:"specified-per-section-evolution"});
  return boundary;
}
module.exports={episode,compare,verifyComparison,compile,continueBoundary,FutureBoundary,pull};
