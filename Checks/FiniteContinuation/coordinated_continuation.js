"use strict";
// A conditional mathematical compiler, not a physical capability issuer.
// Current Swift roles are read through the existing court. Coherent generators,
// their quarter-turn controls and any simultaneous access are model premises.
const assert=require("node:assert/strict");
const fs=require("node:fs"),path=require("node:path"),crypto=require("node:crypto");
const exact=require("./coordinated_exact.js");
const {c,z,one,ii,nz,eye,mat,scale,plus,minus,adj,mm,comm,eq,isZero,tr,kron}=exact;
const sourceCheck=require("./derived_contact_boundary_checks.js");
const root=path.resolve(__dirname,"../..");
const digest=x=>crypto.createHash("sha256").update(x).digest("hex");
const json=x=>JSON.stringify(x,(_,v)=>typeof v==="bigint"?v.toString():v);
const key=coeff=>JSON.stringify(coeff);
const issuedModels=new WeakSet();
function freezeTree(x){if(x&&typeof x==="object"){Object.values(x).forEach(freezeTree);Object.freeze(x);}return x;}
function spinPermutation(order) {
  const n=2**order.length,A=mat(n);
  for(let x=0;x<n;x++) {
    const b=order.map((_,j)=>(x>>(order.length-1-j))&1);
    const y=order.reduce((a,j)=>2*a+b[j],0);A[y][x]=one;
  }
  return A;
}
function currentModel() {
  const evidence=sourceCheck.run();
  const P=spinPermutation(evidence.interpreted_source_ports.P);
  const Q=spinPermutation(evidence.interpreted_source_ports.Q),I=eye(P.length);
  const Pi=scale(minus(scale(I,c(2)),plus(mm(P,Q),mm(Q,P))),c(1,0,3));
  const model=freezeTree({P,Q,I,Pi,E:minus(I,Pi),source:evidence.source.sha256,
    ports:evidence.interpreted_source_ports,
    scope:"Declared coherent phase-free exchange model; no hardware availability inferred"});
  issuedModels.add(model);return model;
}
function generator(model,coeff) {
  assert(Array.isArray(coeff)&&coeff.length===2&&coeff.every(Number.isSafeInteger),"integer control coefficients required");
  return plus(scale(model.P,c(coeff[0])),scale(model.Q,c(coeff[1])));
}
function period4(n){return ((n%4)+4)%4;}
function cosQuarter(n){return [one,z,c(-1),z][period4(n)];}
function sinQuarter(n){return [z,one,z,c(-1)][period4(n)];}
function sectionOperator(model,section) {
  assert(Number.isSafeInteger(section.quarters),"integer quarter-turn area required");
  const H=generator(model,section.coeff),H2=mm(H,H);
  let U=mat(H.length);
  // Exact spectral evaluation. No floating trigonometry or guessed tolerance.
  for(const R of [model.Pi,model.E]) {
    const HR=mm(H,R);assert(isZero(comm(H,R)));
    const frequency=[0,1,2].find(k=>isZero(minus(mm(H2,R),scale(R,c(k*k)))));
    assert(frequency!==undefined,"unsupported spectrum; this is not a nonexistence claim");
    const block=frequency===0?R:plus(scale(R,cosQuarter(frequency*section.quarters)),
      scale(HR,exact.mul(c(0,-1,frequency),sinQuarter(frequency*section.quarters))));
    U=plus(U,block);
  }
  eq(mm(adj(U),U),model.I);return U;
}
function scoreOperator(model,score) {
  assert(Array.isArray(score));
  return score.reduce((U,s)=>mm(sectionOperator(model,s),U),model.I);
}
const single=(index)=>({coeff:index===0?[1,0]:[0,1],quarters:1});
const sequentialScore=()=>[single(0),single(1),single(0)];
function accessModel(coefficients) {
  // This is an explicit mathematical grammar supplied as an independent input.
  // It is intentionally NOT a flag certifying physical access.
  return {kind:"declared-generator-grammar",generators:coefficients.map(x=>x.slice())};
}
function assertAccess(access,score) {
  assert.equal(access.kind,"declared-generator-grammar");
  for(const s of score)assert(access.generators.some(x=>key(x)===key(s.coeff)),"generator not in the supplied access grammar");
}
function rootIsCurrent(model) {
  assert(issuedModels.has(model),"model must come from the current source reader, not a supplied hash and table");
  for(const [p,hash] of Object.entries(model.source))
    assert.equal(digest(fs.readFileSync(path.isAbsolute(p)?p:path.join(root,p))),hash,"current-root content changed");
}
function assertPositive(A) {
  eq(adj(A),A);const B=A.map(row=>row.slice());
  for(let k=0;k<B.length;k++) {
    const pivot=B[k][k];assert.equal(pivot[1],0n);assert(pivot[0]>=0n,"negative input matrix");
    if(!nz(pivot)){for(let j=k+1;j<B.length;j++)assert(!nz(B[k][j]),"zero diagonal with nonzero row is not positive");continue;}
    for(let i=k+1;i<B.length;i++)for(let j=k+1;j<B.length;j++)
      B[i][j]=exact.sub(B[i][j],exact.div(exact.mul(B[i][k],B[k][j]),pivot));
  }
}
function validateRequest(model,request) {
  eq(adj(request.inputProjector),request.inputProjector);
  eq(mm(request.inputProjector,request.inputProjector),request.inputProjector);
  assert(!isZero(request.inputProjector),"empty input cannot supply a vacuous success");
  assert(Array.isArray(request.requiredInteriorCuts));
  for(const k of request.requiredInteriorCuts)assert(Number.isInteger(k)&&k>0&&k<request.targetScore.length);
  scoreOperator(model,request.targetScore);
}
function checkRewriteLaw(model,a,b) {
  const A=generator(model,a),B=generator(model,b),R=model.Pi;
  eq(mm(mm(A,A),R),R);eq(mm(mm(B,B),R),R);
  eq(mm(plus(mm(A,B),mm(B,A)),R),scale(R,c(-1)));
  eq(mm(mm(plus(A,B),plus(A,B)),R),R);
  eq(mm(plus(mm(mm(A,B),A),plus(A,B)),R),mat(R.length));
}
function verifyPlan(model,request,access,plan) {
  rootIsCurrent(model);validateRequest(model,request);
  assert.equal(json(plan.source),json(model.source),"source evidence differs from live root");
  assertAccess(access,plan.score);
  if(request.requiredInteriorCuts.length)
    assert.equal(json(plan.score),json(request.targetScore),"interior access cannot be erased by endpoint equality");
  if(plan.rule==="coordinated-involution") {
    assert.equal(request.targetScore.length,3);
    const [a,b,last]=request.targetScore;
    assert.equal(json(a),json(last));assert.equal(a.quarters,1);assert.equal(b.quarters,1);
    checkRewriteLaw(model,a.coeff,b.coeff);
    const joint={coeff:a.coeff.map((x,i)=>x+b.coeff[i]),quarters:1};
    assert.equal(json(plan.score),json([joint]),"rule application must be its actual constructed score");
    eq(mm(model.Pi,request.inputProjector),request.inputProjector,"sector premise missing");
  } else assert.equal(plan.rule,"retain-source-score");
  const U=scoreOperator(model,plan.score),V=scoreOperator(model,request.targetScore);
  eq(mm(U,request.inputProjector),mm(V,request.inputProjector),"complete operator on admitted input differs");
  return {operator:U,verified:"conditional-full-operator",physicalAdmission:null};
}
function compile(model,request,access) {
  rootIsCurrent(model);validateRequest(model,request);
  const attempts=[],scores=request.targetScore;
  if(scores.length===3&&json(scores[0])===json(scores[2])&&scores[0].quarters===1&&scores[1].quarters===1) {
    const plan={rule:"coordinated-involution",source:model.source,
      score:[{coeff:scores[0].coeff.map((x,i)=>x+scores[1].coeff[i]),quarters:1}]};
    try {verifyPlan(model,request,access,plan);return {plan,attempts,physicalAdmission:null};}
    catch(error){attempts.push({candidate:plan.rule,refused:error.message});}
  }
  const plan={rule:"retain-source-score",source:model.source,score:structuredClone(scores)};
  verifyPlan(model,request,access,plan);
  return {plan,attempts,physicalAdmission:null};
}
class MathematicalBoundary {
  constructor(model,rho,referenceDimension=1) {
    this.model=model;this.rho=rho;this.referenceDimension=referenceDimension;this.history=[];
    assert.equal(rho.length,model.I.length*referenceDimension);
    // The input is supplied, never synthesized from an expected answer.
    assertPositive(rho);assert.deepEqual(tr(rho),one);
  }
  continue(request,access,plan) {
    const checked=verifyPlan(this.model,request,access,plan),R=kron(request.inputProjector,eye(this.referenceDimension));
    eq(mm(mm(R,this.rho),R),this.rho,"actual mathematical input does not meet the promised support");
    const U=kron(checked.operator,eye(this.referenceDimension));
    this.rho=mm(mm(U,this.rho),adj(U));
    this.history.push({rule:plan.rule,sections:plan.score.length});
    return this;
  }
}
module.exports={currentModel,generator,sectionOperator,scoreOperator,sequentialScore,accessModel,compile,verifyPlan,MathematicalBoundary,json,exact};
