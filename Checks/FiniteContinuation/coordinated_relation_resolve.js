"use strict";
// Independent Heisenberg relations -> exact witnesses in the declared fixed-
// pulse grammar. Linear construction and finite normal-form closure are separate
// from verification. The latter repeats neither solve nor reachability search.
const assert=require("node:assert/strict");
const C=require("./coordinated_continuation.js");
const F=require("./coordinated_future.js");
const {c,z,one,nz,div,mat,eye,scale,plus,minus,adj,mm,eq,isZero,rref,kernel}=C.exact;
const counters={linearSolves:0,normalFormClosures:0};
const key=x=>C.json(x);
const transpose=A=>A[0].map((_,j)=>A.map(row=>row[j]));
const reading=(word,coefficient=[1,0,1])=>[{word,coefficient}];
function touchRoot(model) {
  C.verifyPlan(model,{targetScore:[],inputProjector:model.Pi,requiredInteriorCuts:[]},C.accessModel([]),
    {rule:"retain-source-score",source:model.source,score:[]});
}
function expression(model,terms) {
  assert(Array.isArray(terms)&&terms.length>0,"reading must be an explicit polynomial");
  let out=mat(model.I.length);
  for(const term of terms){
    assert(Array.isArray(term.word));assert(Array.isArray(term.coefficient)&&term.coefficient.length===3);
    let W=model.I;
    for(const name of term.word){assert(name==="P"||name==="Q","unknown source contact");W=mm(W,model[name]);}
    out=plus(out,scale(mm(model.Pi,W),c(...term.coefficient)));
  }
  eq(adj(out),out,"requested reading must be Hermitian");return out;
}
function logicalBasis(model){return [model.Pi,mm(model.Pi,model.P),mm(model.Pi,model.Q),
  scale(minus(mm(model.P,model.Q),mm(model.Q,model.P)),c(0,1))];}
function system(model,goal) {
  assert.equal(goal.kind,"source-reading-relations");assert(goal.relations.length>0);
  assert.equal(goal.input,"derived-noncommuting-sector");
  const relations=goal.relations.map(r=>({after:expression(model,r.after),before:expression(model,r.before)}));
  const basis=logicalBasis(model),rows=[];
  for(const {after:A,before:B}of relations){
    const columns=basis.map(T=>minus(mm(A,T),mm(T,B)).flat());
    rows.push(...transpose(columns));
  }
  return {relations,basis,rows};
}
function squareInverse(M) {
  const n=M.length;const reduced=rref(M.map((row,i)=>[...row,...eye(n)[i]]));
  assert.deepEqual(reduced.pivots.slice(0,n),Array.from({length:n},(_,i)=>i));
  return reduced.A.map(row=>row.slice(n));
}
function rankWitness(M) {
  const rows=rref(transpose(M)).pivots;
  if(!rows.length)return {rows:[],columns:[],inverse:[]};
  const columns=rref(rows.map(i=>M[i])).pivots;
  const minor=rows.map(i=>columns.map(j=>M[i][j]));
  return {rows,columns,inverse:squareInverse(minor)};
}
function verifyRankWitness(M,witness) {
  const {rows,columns,inverse}=witness,n=rows.length;
  assert.equal(columns.length,n);assert.equal(new Set(rows).size,n);assert.equal(new Set(columns).size,n);
  rows.forEach(i=>assert(Number.isInteger(i)&&i>=0&&i<M.length));
  columns.forEach(j=>assert(Number.isInteger(j)&&j>=0&&j<M[0].length));
  if(n===0){assert.deepEqual(inverse,[]);return 0;}
  const minor=rows.map(i=>columns.map(j=>M[i][j]));
  eq(mm(inverse,minor),eye(n));return n;
}
function constructLinearCertificate(M) {
  counters.linearSolves++;
  const nullspace=kernel(M),k=nullspace.length;
  return {nullspace,constraintMinor:rankWitness(M),
    kernelMinor:k?rankWitness(transpose(nullspace)):null};
}
function verifyLinearCertificate(M,certificate) {
  const vectors=certificate.nullspace,k=vectors.length;
  vectors.forEach(v=>assert.equal(v.length,4));assert(k<=4);
  const lowerRank=verifyRankWitness(M,certificate.constraintMinor);
  assert.equal(lowerRank,4-k);
  if(k){const K=transpose(vectors);eq(mm(M,K),mat(M.length,k));
    assert.equal(verifyRankWitness(K,certificate.kernelMinor),k);
  }else assert.equal(certificate.kernelMinor,null);
  // rank>=4-k and k independent kernel vectors force equality on both sides.
  return k;
}
function directions(access) {
  assert.equal(access.kind,"declared-generator-grammar");
  const allowed=new Set(["[1,0]","[0,1]","[1,1]"]);
  assert(access.generators.every(x=>allowed.has(JSON.stringify(x))),"access outside the proved fixed-pulse grammar");
  assert.equal(new Set(access.generators.map(x=>JSON.stringify(x))).size,access.generators.length);
  return access.generators.map(coeff=>({coeff,quarters:1}));
}
function signature(model,U) {
  const supported=mm(U,model.Pi),first=supported.flat().find(nz);assert(first);
  return key(supported.map(row=>row.map(x=>div(x,first))));
}
function satisfies(model,relations,U) {
  if(!isZero(mm(minus(mm(model.I,U),mm(model.Pi,U)),model.Pi)))return false;
  return relations.every(({after,before})=>isZero(mm(mm(model.Pi,
    minus(mm(mm(adj(U),after),U),before)),model.Pi)));
}
function constructNormalForms(model,access) {
  counters.normalFormClosures++;
  const generators=directions(access),states=[{score:[],distance:0,transitions:[]}],operators=[model.I];
  const indices=new Map([[signature(model,model.I),0]]);
  for(let i=0;i<states.length;i++)for(const section of generators){
    const U=mm(C.sectionOperator(model,section),operators[i]),sig=signature(model,U);
    let j=indices.get(sig);
    if(j===undefined){j=states.length;indices.set(sig,j);operators.push(U);
      states.push({score:[...states[i].score,section],distance:states[i].distance+1,transitions:[]});
      // S3 normal forms, not an arbitrary search-depth budget: the joint
      // reflection is projectively P Q P on this sector.
      assert(states.length<=6,"declared algebra did not close as established");
    }
    states[i].transitions.push(j);
  }
  return {states};
}
function verifyNormalForms(model,access,certificate) {
  const generators=directions(access),states=certificate.states;assert(states.length>0);
  const operators=states.map(state=>{
    assert(Number.isSafeInteger(state.distance)&&state.distance>=0);
    assert.equal(state.score.length,state.distance);
    for(const section of state.score)assert(generators.some(g=>key(g)===key(section)),"word uses undeclared access");
    return C.scoreOperator(model,state.score);
  });
  assert.equal(states[0].distance,0);assert.equal(signature(model,operators[0]),signature(model,model.I));
  const signatures=operators.map(U=>signature(model,U));assert.equal(new Set(signatures).size,states.length);
  states.forEach((state,i)=>{
    assert.equal(state.transitions.length,generators.length);
    generators.forEach((g,a)=>{const j=state.transitions[a];assert(Number.isInteger(j)&&j>=0&&j<states.length);
      assert.equal(signature(model,mm(C.sectionOperator(model,g),operators[i])),signatures[j]);
      assert(states[j].distance<=state.distance+1,"distance labels do not certify the lower bound");
    });
  });
  // Each listed node is reachable by its witness; closure from the identity
  // covers every finite word. The distance inequality certifies minimality.
  return operators;
}
function resolve(model,goal,access) {
  touchRoot(model);directions(access);
  const equations=system(model,goal),linear=constructLinearCertificate(equations.rows);
  if(linear.nullspace.length===0){const out={kind:"inconsistent-unitary-relations",source:model.source,linear,physicalAdmission:null};
    verify(model,goal,access,out);return out;}
  const normalForms=constructNormalForms(model,access);
  const matches=normalForms.states.map((s,i)=>({i,s,U:C.scoreOperator(model,s.score)}))
    .filter(x=>satisfies(model,equations.relations,x.U));
  matches.sort((a,b)=>a.s.distance-b.s.distance);
  const out={kind:matches.length?"realization":"fixed-access-obstruction",source:model.source,linear,normalForms,
    chosen:matches.length?matches[0].i:null,physicalAdmission:null};
  verify(model,goal,access,out);return out;
}
function verify(model,goal,access,result) {
  touchRoot(model);directions(access);assert.equal(key(result.source),key(model.source));
  const equations=system(model,goal),dimension=verifyLinearCertificate(equations.rows,result.linear);
  if(!dimension){assert.equal(result.kind,"inconsistent-unitary-relations");return {dimension,score:null};}
  const operators=verifyNormalForms(model,access,result.normalForms);
  const matches=operators.map((U,i)=>i).filter(i=>satisfies(model,equations.relations,operators[i]));
  if(!matches.length){assert.equal(result.kind,"fixed-access-obstruction");assert.equal(result.chosen,null);return {dimension,score:null};}
  assert.equal(result.kind,"realization");assert(matches.includes(result.chosen));
  const state=result.normalForms.states[result.chosen];
  assert(matches.every(i=>state.distance<=result.normalForms.states[i].distance),"selected realization is not minimal in the supplied grammar");
  return {dimension,score:state.score,operator:operators[result.chosen],minimalSections:state.distance};
}
function asContinuation(model,goal,access,result) {
  const checked=verify(model,goal,access,result);assert(checked.score,"no executable witness");
  const request={targetScore:checked.score,inputProjector:model.Pi,requiredInteriorCuts:[]};
  // The program is produced by resolve and checked against the independent
  // relations first; it was not supplied in the user's mathematical question.
  const plan={rule:"retain-source-score",source:model.source,score:checked.score};
  C.verifyPlan(model,request,access,plan);return {request,plan};
}
class RelationalBoundary extends F.FutureBoundary {
  continue(goal,access,result,context) {
    // Admission rechecks the independent relations. The intermediate raw
    // request/plan adapter is not itself an authorization to execute the goal.
    const {request}=asContinuation(this.model,goal,access,result);
    const selected=F.compile(this.model,request,access,context);
    const actual=F.episode(this.model,selected.plan.score,context);
    assert(satisfies(this.model,system(this.model,goal).relations,actual),
      "actual joint episode does not realize the independent source relations");
    F.continueBoundary(this,request,access,context,selected);
    this.history[this.history.length-1].independentGoal=structuredClone(goal);
    return this;
  }
}
function deserialize(text) {
  return JSON.parse(text,(_,v)=>Array.isArray(v)&&v.length===3&&v.every(x=>typeof x==="string"&&/^-?\d+$/.test(x))?c(...v):v);
}
if(require.main===module) {
  const bundle=deserialize(require("node:fs").readFileSync(process.argv[2],"utf8"));
  const checked=verify(C.currentModel(),bundle.goal,bundle.access,bundle.resolution);
  console.log(JSON.stringify({verified:true,kind:bundle.resolution.kind,intertwinerDimension:checked.dimension,
    minimalSections:checked.minimalSections??null,constructionCalls:counters,physicalAdmission:null}));
}
module.exports={reading,expression,system,resolve,verify,asContinuation,RelationalBoundary,counters,serialize:key,deserialize};
