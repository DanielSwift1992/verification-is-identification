"use strict";
// Conditional operator-algebra certificate. The environment may retain arbitrary
// memory; neither its dimension nor a trajectory is an input to compilation.
// The explicit joint-state runner below is a mathematical test interface only.
const assert=require("node:assert/strict");
const C=require("./coordinated_continuation.js"),R=require("./coordinated_relation_resolve.js");
const {c,z,one,nz,sub,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=C.exact;
const key=C.json;
function touchRoot(model) {
  C.verifyPlan(model,{targetScore:[],inputProjector:model.Pi,requiredInteriorCuts:[]},C.accessModel([]),
    {rule:"retain-source-score",source:model.source,score:[]});
}
function logicalBasis(model) {
  return [model.Pi,mm(model.Pi,model.P),mm(model.Pi,model.Q),scale(comm(model.P,model.Q),c(0,1))];
}
function square(A,n) {assert(Array.isArray(A)&&A.length===n&&A.every(row=>Array.isArray(row)&&row.length===n));}
function validateGenerators(model,generators) {
  assert(Array.isArray(generators),"source interaction terms must be explicit; an empty list permits only environment-local drift");
  for(const S of generators){
    square(S,model.I.length);eq(adj(S),S,"source interaction generator must be Hermitian");
    assert(isZero(comm(S,model.Pi)),"interaction may leave the admitted sector");
    for(const O of logicalBasis(model))assert(isZero(comm(S,O)),"interaction changes a required logical reading");
  }
}
function quadratic(v,A){return mm(mm(adj(v),A),v)[0][0];}
function normalizedValue(v,A){return div(quadratic(v,A),quadratic(v,eye(v.length)));}
function generatorObstruction(model,S) {
  touchRoot(model);square(S,model.I.length);eq(adj(S),S);
  const leakage=mm(mm(mm(mm(model.Pi,S),model.E),S),model.Pi);
  let readingIndex=null,D=null;
  if(!isZero(leakage))D=scale(leakage,c(-2));
  else {
    const basis=logicalBasis(model);
    readingIndex=basis.findIndex(O=>!isZero(comm(S,O)));
    if(readingIndex<0)return null;
    D=mm(mm(model.Pi,scale(comm(S,basis[readingIndex]),c(0,1))),model.Pi);
  }
  // Every nonzero Hermitian form is distinguished by a coordinate vector,
  // a sum, or a sum with coefficient i. Projection supplies an admitted input.
  const n=model.I.length,candidates=[];
  for(let i=0;i<n;i++){const v=mat(n,1);v[i][0]=one;candidates.push(v);}
  for(let i=0;i<n;i++)for(let j=i+1;j<n;j++)for(const a of [one,c(0,1)]){
    const v=mat(n,1);v[i][0]=one;v[j][0]=a;candidates.push(v);
  }
  for(const raw of candidates){const v=mm(model.Pi,raw);
    if(nz(quadratic(v,D))){const result={source:model.source,
      kind:readingIndex===null?"sector-survival-second-derivative":"logical-reading-first-derivative",
      readingIndex,vector:v,derivative:normalizedValue(v,D)};
      verifyGeneratorObstruction(model,S,result);return result;}
  }
  assert.fail("nonzero Hermitian form lacked a separating input");
}
function verifyGeneratorObstruction(model,S,witness) {
  touchRoot(model);square(S,model.I.length);eq(adj(S),S);
  assert.equal(key(witness.source),key(model.source));
  const v=witness.vector;assert(v.length===model.I.length&&v.every(row=>row.length===1));
  eq(mm(model.Pi,v),v);assert(nz(quadratic(v,model.I)));
  let D;
  if(witness.kind==="sector-survival-second-derivative"){
    assert.equal(witness.readingIndex,null);
    D=scale(mm(mm(mm(mm(model.Pi,S),model.E),S),model.Pi),c(-2));
    assert(normalizedValue(v,D)[0]<0n,"sector survival must decrease to second order");
  }else{
    assert.equal(witness.kind,"logical-reading-first-derivative");
    const i=witness.readingIndex;assert(Number.isInteger(i)&&i>=0&&i<4);
    D=scale(comm(S,logicalBasis(model)[i]),c(0,1));
  }
  const d=normalizedValue(v,D);assert(nz(d),"claimed reading does not change");
  assert.deepEqual(witness.derivative,d);return true;
}
function deriveFamily(model,generators) {
  touchRoot(model);validateGenerators(model,generators);
  return {kind:"uniform-retained-environment",source:structuredClone(model.source),
    sourceGenerators:structuredClone(generators),
    claim:"sector and logical algebra fixed for arbitrary finite joint environment and integrable Hermitian coefficient history",
    physicalAdmission:null};
}
function verifyFamily(model,generators,certificate) {
  touchRoot(model);assert.equal(certificate.kind,"uniform-retained-environment");
  assert.equal(key(certificate.source),key(model.source));
  assert.equal(key(certificate.sourceGenerators),key(generators),"certificate is for other interaction terms");
  validateGenerators(model,generators);
  // For H_noise(t)=sum S_a tensor B_a(t)+I tensor H_E(t), these exact
  // commutators imply commutation of the time-ordered propagator. The B_a,
  // their commutators and all retained correlations are unrestricted.
  return {sector:model.Pi,logicalBasis:logicalBasis(model),physicalAdmission:null};
}
function compile(model,goal,access,resolution,generators) {
  const control=R.verify(model,goal,access,resolution);assert(control.score,"no control witness");
  const family=deriveFamily(model,generators);
  const out={kind:"uniform-relational-continuation",goal:structuredClone(goal),
    access:structuredClone(access),resolution:structuredClone(resolution),family,
    physicalAdmission:null};
  verify(model,goal,access,generators,out);return out;
}
function verify(model,goal,access,generators,certificate) {
  assert.equal(certificate.kind,"uniform-relational-continuation");
  assert.equal(key(certificate.goal),key(goal),"independent goal changed");
  assert.equal(key(certificate.access),key(access),"supplied control interface changed");
  const control=R.verify(model,goal,access,certificate.resolution);assert(control.score,"no control witness");
  const family=verifyFamily(model,generators,certificate.family);
  // Each permitted control is in the logical algebra, hence commutes on the
  // sector with the entire unknown joint history, including during a pulse.
  for(const section of control.score)for(const S of generators)
    assert(isZero(mm(comm(C.generator(model,section.coeff),S),model.Pi)));
  return {...control,...family};
}
function verifyJointEpisode(model,environmentDimension,W) {
  assert(Number.isSafeInteger(environmentDimension)&&environmentDimension>0);
  const I=eye(model.I.length*environmentDimension),E=eye(environmentDimension);
  square(W,I.length);eq(mm(adj(W),W),I,"joint history must be unitary in this model");
  for(const O of logicalBasis(model))
    assert(isZero(comm(W,kron(O,E))),"joint history is outside the protected commutant");
  // This is a wider sufficient family than a particular generator list. It
  // does not claim to recover that list or certify a laboratory's history.
}
function density(rho) {
  square(rho,rho.length);eq(adj(rho),rho);assert.deepEqual(tr(rho),one);
  const A=rho.map(row=>row.slice());
  for(let k=0;k<A.length;k++){
    const p=A[k][k];assert.equal(p[1],0n);assert(p[0]>=0n,"negative joint input");
    if(!nz(p)){for(let j=k+1;j<A.length;j++)assert(!nz(A[k][j]),"nonpositive joint input");continue;}
    for(let i=k+1;i<A.length;i++)for(let j=k+1;j<A.length;j++)
      A[i][j]=sub(A[i][j],div(mul(A[i][k],A[k][j]),p));
  }
}
const states=new WeakMap();
class RetainedJointBoundary {
  constructor(model,rho,environmentDimension,referenceDimension=1) {
    touchRoot(model);
    assert(Number.isSafeInteger(environmentDimension)&&environmentDimension>0);
    assert(Number.isSafeInteger(referenceDimension)&&referenceDimension>0);
    square(rho,model.I.length*environmentDimension*referenceDimension);density(rho);
    const support=kron(model.Pi,eye(environmentDimension*referenceDimension));
    eq(mm(mm(support,rho),support),rho,"actual joint input is not in the admitted sector");
    states.set(this,{model,rho:structuredClone(rho),environmentDimension,referenceDimension,history:[]});
  }
  continue(goal,access,generators,certificate,jointEpisodes) {
    const s=states.get(this);assert(s);
    const checked=verify(s.model,goal,access,generators,certificate);
    assert(Array.isArray(jointEpisodes));
    // Each mathematical section carries arbitrary joint noise. An empty
    // control word still has a boundary episode: absence of a command does
    // not make physical waiting an identity.
    assert.equal(jointEpisodes.length,Math.max(1,checked.score.length));
    jointEpisodes.forEach(W=>verifyJointEpisode(s.model,s.environmentDimension,W));
    let U=eye(s.model.I.length*s.environmentDimension);
    for(let k=0;k<jointEpisodes.length;k++){
      const control=checked.score[k]?C.sectionOperator(s.model,checked.score[k]):s.model.I;
      U=mm(mm(jointEpisodes[k],kron(control,eye(s.environmentDimension))),U);
    }
    // Environment and untouched reference are different declared roles.
    // The former is acted on and retained, the latter receives identity.
    const full=kron(U,eye(s.referenceDimension));
    const next=mm(mm(full,s.rho),adj(full));
    s.rho=next;s.history.push({goal:structuredClone(goal),sections:checked.score.length,
      retainedEnvironmentDimension:s.environmentDimension,physicalAdmission:null});
    return this;
  }
  snapshot(){const s=states.get(this);return {rho:structuredClone(s.rho),history:structuredClone(s.history),
    environmentDimension:s.environmentDimension,referenceDimension:s.referenceDimension};}
}
if(require.main===module){
  const bundle=R.deserialize(require('node:fs').readFileSync(process.argv[2],'utf8'));
  const checked=verify(C.currentModel(),bundle.goal,bundle.access,bundle.generators,bundle.certificate);
  console.log(JSON.stringify({verified:true,logicalAlgebraDimension:checked.logicalBasis.length,
    controlSections:checked.minimalSections,constructionCalls:R.counters,
    environmentHistorySupplied:false,environmentDimensionSupplied:false,physicalAdmission:null}));
}
module.exports={logicalBasis,deriveFamily,verifyFamily,generatorObstruction,verifyGeneratorObstruction,
  compile,verify,verifyJointEpisode,RetainedJointBoundary};
