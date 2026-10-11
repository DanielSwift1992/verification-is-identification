"use strict";
const assert=require("node:assert/strict"),fs=require("node:fs"),path=require("node:path");
const C=require("./coordinated_continuation.js"),F=require("./coordinated_future.js");
const {c,z,one,eye,mat,scale,plus,minus,adj,mm,kron,tr,scalarText,isZero,eq}=C.exact;
function check(){
  const model=C.currentModel(),{P,Q,Pi,E,I}=model;
  const X=[[z,one],[one,z]],Z=[[one,z],[z,c(-1)]];
  const at=(A,i)=>[0,1,2].reduce((o,j)=>kron(o,i===j?A:eye(2)),[[one]]);
  const Jz=plus(plus(at(Z,0),at(Z,1)),at(Z,2));
  const G=plus(E,mm(Pi,plus(scale(I,c(3,0,5)),scale(Jz,c(0,-4,5)))));
  eq(mm(adj(G),G),I);eq(mm(G,P),mm(P,G));eq(mm(G,Q),mm(Q,G));
  const context={kind:"specified-per-section-evolution",background:G,
    questions:[Pi,mm(Pi,P),mm(Pi,Q),scale(minus(mm(P,Q),mm(Q,P)),c(0,1))],
    futureActions:[{name:"P",operator:P},{name:"Q",operator:Q},{name:"retained-background",operator:G}]};
  const access=C.accessModel([[1,0],[0,1],[1,1]]);
  const request={targetScore:C.sequentialScore(),inputProjector:Pi,requiredInteriorCuts:[]};
  const result=F.compile(model,request,access,context);assert.equal(result.plan.rule,"coordinated-involution");
  assert.equal(result.certificate.kind,"closed-future-space");assert.equal(result.certificate.basis.length,4);
  const A=F.episode(model,result.plan.score,context),B=F.episode(model,request.targetScore,context);
  assert(!isZero(mm(minus(A,B),Pi)),"complete retained state is allowed to differ here");
  assert(F.verifyComparison(model,Pi,A,B,context,result.certificate));
  const incomplete={kind:"closed-future-space",basis:result.certificate.basis.slice(0,1)};
  assert.throws(()=>F.verifyComparison(model,Pi,A,B,context,incomplete));

  // Additional local partial rotation is deliberately added as a new access.
  // It was not available from the old exchange grammar or granted by a hash.
  const K=plus(scale(I,c(3,0,5)),scale(at(X,0),c(0,-4,5)));
  const expanded={...context,futureActions:[...context.futureActions,{name:"local-X-rotation",operator:K}]};
  assert.throws(()=>F.verifyComparison(model,Pi,A,B,expanded,result.certificate));
  const rejected=F.compare(model,Pi,A,B,expanded);
  assert.equal(rejected.kind,"distinguishing-future");assert.equal(F.verifyComparison(model,Pi,A,B,expanded,rejected),false);
  const revised=F.compile(model,request,access,expanded);
  assert.equal(revised.plan.rule,"retain-source-score");
  assert.equal(revised.certificate.kind,"same-operator-on-input");
  assert.equal(revised.obstruction.kind,"distinguishing-future");
  const w=mat(8,1);
  for(const [i,x]of [[1,c(2)],[2,c(-1,1)],[4,c(-1,-1)],[3,c(1,1)],[5,c(1,-1)],[6,c(-2)]])w[i][0]=x;
  const rho=scale(mm(w,adj(w)),c(1,0,16));eq(mm(Pi,w),w);
  const O=F.pull(K,P),expect=(U)=>scalarText(tr(mm(mm(mm(U,rho),adj(U)),O)));
  assert.equal(expect(A),"639/2500");assert.equal(expect(B),"1173519/1562500");
  // Continue the same actual mathematical boundary, with the background left in.
  const live=new F.FutureBoundary(model,rho);
  assert.equal(F.continueBoundary(live,request,access,context,result),live);
  const second={targetScore:[{coeff:[0,1],quarters:1}],inputProjector:Pi,requiredInteriorCuts:[]};
  const next=F.compile(model,second,access,context);
  assert.equal(F.continueBoundary(live,second,access,context,next),live);
  const futureU=F.episode(model,second.targetScore,context);
  const expectedJoint=mm(futureU,A),expectedSerial=mm(futureU,B);
  eq(live.rho,mm(mm(expectedJoint,rho),adj(expectedJoint)));
  const serialState=mm(mm(expectedSerial,rho),adj(expectedSerial));
  assert(!isZero(minus(live.rho,serialState)));
  for(const O of context.questions)assert.deepEqual(tr(mm(live.rho,O)),tr(mm(serialState,O)));
  const forbiddenReuse=new F.FutureBoundary(model,rho);
  assert.throws(()=>F.continueBoundary(forbiddenReuse,request,access,expanded,result));
  // The later request has its own valid unmodified score. It is still refused
  // because its expanded future violates the promise carried by the first result.
  const newContinuation=F.compile(model,second,access,expanded);
  const before=live.rho,historySize=live.history.length;
  assert.throws(()=>live.continue(second,access,expanded,newContinuation),/inherited future/);
  assert.equal(live.rho,before);assert.equal(live.history.length,historySize);
  return {scope:"Exact conditional joint episode and all finite declared futures; no apparatus claim",
    logical_future_dimension:4,logical_future_rewrite:result.plan.rule,complete_outputs_differ:true,
    added_access:"local-X-rotation",distinguishing_word:rejected.witness.word,
    extended_future_rewrite:revised.plan.rule,continued_same_boundary:live.history,
    comparison_question:"P after the added local X rotation",
    joint_value:expect(A),sequential_value:expect(B),
    previous_certificate_rejected_after_interface_extension:true,incomplete_certificate_rejected:true,
    independently_valid_later_request_rejected_by_inherited_future:true,
    physical_admission:null};
}
if(require.main===module){const out=JSON.stringify(check(),null,2)+"\n";if(process.argv[2]){fs.mkdirSync(process.argv[2],{recursive:true});fs.writeFileSync(path.join(process.argv[2],"wave-1-future-checks.json"),out);}console.log(out);}
module.exports={check};
