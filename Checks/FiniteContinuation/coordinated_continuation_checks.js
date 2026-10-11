"use strict";
const assert=require("node:assert/strict"),fs=require("node:fs"),path=require("node:path");
const C=require("./coordinated_continuation.js");
const {c,z,one,ii,mat,eye,scale,plus,minus,adj,mm,eq,isZero,tr,kron,scalarText}=C.exact;
function check() {
  const model=C.currentModel(),{P,Q,Pi,I,E}=model;
  const access=C.accessModel([[1,0],[0,1],[1,1]]),serial=C.accessModel([[1,0],[0,1]]);
  const request={targetScore:C.sequentialScore(),inputProjector:Pi,requiredInteriorCuts:[]};
  const solved=C.compile(model,request,access);assert.equal(solved.plan.rule,"coordinated-involution");
  assert.equal(solved.plan.score.length,1);assert.equal(solved.physicalAdmission,null);
  const U=C.scoreOperator(model,solved.plan.score),V=C.scoreOperator(model,request.targetScore);
  eq(mm(U,Pi),mm(V,Pi));assert(!isZero(minus(U,V)));
  // Also check the polynomial/exponential identity in the regular S3 action,
  // derived from the current ports, which faithfully represents its group algebra.
  const permutations=[[0,1,2],[1,0,2],[0,2,1],[1,2,0],[2,0,1],[2,1,0]];
  const regular=order=>{const A=mat(6);permutations.forEach((p,i)=>{
    const output=order.map(j=>p[j]);const j=permutations.findIndex(q=>JSON.stringify(q)===JSON.stringify(output));A[j][i]=one;
  });return A;};
  const rp=regular(model.ports.P),rq=regular(model.ports.Q),ri=eye(6);
  const rPi=scale(minus(scale(ri,c(2)),plus(mm(rp,rq),mm(rq,rp))),c(1,0,3));
  const rm={P:rp,Q:rq,I:ri,Pi:rPi,E:minus(ri,rPi)};
  assert.equal(C.exact.rank([ri,rp,rq,mm(rp,rq),mm(rq,rp),mm(mm(rp,rq),rp)].map(x=>x.flat())),6);
  eq(mm(C.scoreOperator(rm,solved.plan.score),rPi),mm(C.scoreOperator(rm,request.targetScore),rPi));
  const p=mm(Pi,P),q=mm(Pi,Q),H=plus(P,Q);
  eq(mm(mm(H,H),Pi),Pi);eq(mm(mm(minus(P,Q),minus(P,Q)),Pi),scale(Pi,c(3)));
  eq(mm(mm(mm(P,Q),P),Pi),scale(mm(H,Pi),c(-1)));

  const refused=[];
  const noJoint=C.compile(model,request,serial);assert.equal(noJoint.plan.rule,"retain-source-score");refused.push("no simultaneous generator");
  const full={...request,inputProjector:I};assert.equal(C.compile(model,full,access).plan.rule,"retain-source-score");refused.push("input outside sector");
  const cut={...request,requiredInteriorCuts:[1]};assert.equal(C.compile(model,cut,access).plan.rule,"retain-source-score");refused.push("required interior access");
  assert.throws(()=>C.verifyPlan(model,cut,access,solved.plan));
  const forged=structuredClone(solved.plan);forged.score=[{coeff:[1,0],quarters:1},{coeff:[0,1],quarters:1}];forged.status="approved";
  assert.throws(()=>C.verifyPlan(model,request,access,forged));refused.push("forged approval and independent areas");
  const hashForgery=structuredClone(solved.plan);Object.keys(hashForgery.source).forEach(k=>hashForgery.source[k]="0".repeat(64));
  assert.throws(()=>C.verifyPlan(model,request,access,hashForgery));refused.push("forged source hashes");
  const forgedModel={...model,P:I};
  assert.throws(()=>C.verifyPlan(forgedModel,request,access,solved.plan));refused.push("forged model with genuine source hashes");
  assert.throws(()=>C.compile(model,{...request,inputProjector:mat(8)},access));refused.push("empty admission domain");

  // P+ input with an unspecified gauge. Same individual areas, different overlap.
  const rho=scale(mm(Pi,plus(I,P)),c(1,0,4));
  const two=C.scoreOperator(model,[{coeff:[1,0],quarters:1},{coeff:[0,1],quarters:1}]);
  const expect=(state,O)=>scalarText(tr(mm(state,O)));
  const after=(W,state)=>mm(mm(W,state),adj(W));
  assert.equal(expect(after(U,rho),Q),"1/1");assert.equal(expect(after(two,rho),Q),"-1/2");

  // A positive rank-one mixed-sector input witnesses the missing full-space law.
  const w=mat(8,1);w[0][0]=one;w[2][0]=one;w[4][0]=c(-1);
  const mixedSector=scale(mm(w,adj(w)),c(1,0,3));
  assert(!isZero(minus(after(U,mixedSector),after(V,mixedSector))));

  // An independently supplied reference-correlated input; no step prepares it again.
  // Two orthogonal logical vectors with the same gauge are tied to distinct
  // reference states. Unequal Schmidt weights avoid introducing square roots.
  const v=mat(16,1);v[1*2][0]=c(2);v[2*2][0]=c(-1);v[4*2][0]=c(-1);
  v[2*2+1][0]=one;v[4*2+1][0]=c(-1);
  const supplied=scale(mm(v,adj(v)),c(1,0,8));
  eq(mm(kron(Pi,eye(2)),v),v);
  const live=new C.MathematicalBoundary(model,supplied,2),same=live.continue(request,access,solved.plan);assert.equal(same,live);
  const second={targetScore:[{coeff:[0,1],quarters:1}],inputProjector:Pi,requiredInteriorCuts:[]};
  const next=C.compile(model,second,access);assert.equal(live.continue(second,access,next.plan),live);
  const expected=mm(C.scoreOperator(model,second.targetScore),V),extended=kron(expected,eye(2));
  eq(live.rho,after(extended,supplied));assert.equal(live.history.length,2);
  eq(mm(expected,Pi),mm(mm(C.scoreOperator(model,second.targetScore),U),Pi));
  // This operator identity, not the sampled input, covers arbitrary reference.
  const badLive=new C.MathematicalBoundary(model,mixedSector);
  assert.throws(()=>badLive.continue(request,access,solved.plan));refused.push("actual supplied input violates support");
  const nonpositive=mat(8);nonpositive[0][0]=c(2);nonpositive[1][1]=c(-1);
  assert.throws(()=>new C.MathematicalBoundary(model,nonpositive));refused.push("nonpositive mathematical input");
  // Renaming/swapping generators yields the other braid word; no example-name dispatch.
  const alternate={...request,targetScore:[{coeff:[0,1],quarters:1},{coeff:[1,0],quarters:1},{coeff:[0,1],quarters:1}]};
  assert.equal(C.compile(model,alternate,access).plan.rule,"coordinated-involution");

  return {scope:"Exact conditional model and local continuation; no QPU or physical admission",source:model.source,
    arithmetic:"exact Gaussian rationals",rewritten_sections:[3,1],
    distinction_with_equal_individual_areas:{joint_Q:"1/1",sequential_Q:"-1/2"},
    negative_cases:refused,live_requests:live.history,reference_dimension:2,
    arbitrary_reference_operator_equality:true,faithful_group_algebra_dimension:6,physical_admission:null,
    cost_scope:"section count only; no physical speed or energy claim",plan:solved.plan};
}
if(require.main===module){const result=check();const text=JSON.stringify(result,null,2)+"\n";
  if(process.argv[2]){fs.mkdirSync(process.argv[2],{recursive:true});fs.writeFileSync(path.join(process.argv[2],"wave-1-checks.json"),text);}
  console.log(text);
}
module.exports={check};
