"use strict";
// A directly constructed protected reflection. A single common envelope is
// extra physical access, not inferred from the fixed-quarter exchange API.
// Phase is quotiented ONLY on the admitted code; no controlled lift is offered.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js'),D=require('./coordinated_native_exit.js');
const E=C.exact,{c,z,one,add,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,kernel}=E,key=C.json;
const counters={constructions:0,linearSolves:0};
function access(){return {kind:'declared-synchronous-protected-exchange-control',
  generators:'a Q + b(P+T), signed real a,b',
  synchronization:'Q has weight a; P and T each have weight b in the same real envelope',
  area:'integral of common envelope = pi/(2 sqrt(a*a+b*b))',
  path:'coherent addressed Hamiltonian throughout the episode, not only equal integrated areas',
  phase:'channel on the admitted code with arbitrary reference; no coherently controlled use',physicalAdmission:null};}
function validateAccess(a){assert.equal(key(a),key(access()),'synchronous control needs its own explicit premise');}
function goalData(m,g){const d=F.exchangeCode(m);assert.equal(g.kind,'protected-reading-relations');eq(g.input,d.support);
  assert.deepEqual(g.requiredInteriorCuts,[],'one joint episode does not reproduce a demanded interior port');
  assert(g.relations.length>0);for(const {before,after}of g.relations)for(const O of [before,after]){
    assert(O.length===16&&O.every(row=>row.length===16));eq(adj(O),O);eq(mm(d.support,O),O);eq(mm(O,d.support),O);}
  return d;}
function forms(m,g){const d=goalData(m,g),basis=[d.readings[0].operator,d.readings[2].operator],rows=[];
  for(const {before,after}of g.relations){const cols=basis.map(B=>minus(mm(after,B),mm(B,before)).flat());
    for(let i=0;i<256;i++){rows.push(cols.map(v=>c(v[i][0],0,v[i][2])));rows.push(cols.map(v=>c(v[i][1],0,v[i][2])));}}
  return {d,basis,rows};}
function construct(m,available,g){validateAccess(available);counters.constructions++;const {rows}=forms(m,g);counters.linearSolves++;
  const solutions=kernel(rows);if(!solutions.length)return null; // Only this one-reflection grammar is exhausted.
  const certificate={kind:'protected-plane-reflection',source:m.source,available:structuredClone(available),goal:structuredClone(g),
    coefficients:solutions[0],physicalAdmission:null};verify(m,available,g,certificate);return certificate;}
function verify(m,available,g,p){validateAccess(available);const d=goalData(m,g);assert.equal(p.kind,'protected-plane-reflection');
  assert.equal(key(p.source),key(m.source));assert.equal(key(p.available),key(available));assert.equal(key(p.goal),key(g));assert.equal(p.physicalAdmission,null);
  assert(p.coefficients.length===2);const [a,b]=p.coefficients;p.coefficients.forEach(x=>{assert(x.length===3);assert.deepEqual(x,c(...x));assert.equal(x[1],0n);});
  const norm=add(mul(a,a),mul(b,b));assert(norm[0]>0n);
  const {P,Q,T}=m.operators,N=plus(scale(d.readings[0].operator,a),scale(d.readings[2].operator,b));
  const H0=plus(scale(Q,a),scale(plus(P,T),b));eq(adj(H0),H0);eq(comm(H0,d.support),mat(16));
  eq(mm(plus(P,T),d.support),plus(d.support,d.readings[2].operator));
  eq(mm(H0,d.support),plus(scale(d.support,b),N));eq(mm(N,N),scale(d.support,norm));eq(adj(N),N);
  for(const {before,after}of g.relations)eq(mm(after,N),mm(N,before),'reflection must satisfy the independently requested relations');
  return {...d,N,norm,H0,coefficients:[a,b],sections:1,
    restrictedPhase:'-i exp(-i b pi/(2 sqrt(a*a+b*b)))',physicalAdmission:null};}
function protection(m,available,g,p,generators){const v=verify(m,available,g,p);
  for(const S of generators){assert(S.length===16&&S.every(row=>row.length===16));eq(adj(S),S);
    for(const O of [v.support,...v.readings.map(q=>q.operator),v.H0])assert(isZero(comm(S,O)),'background does not preserve the entire joint path');}
  return {source:m.source,generators:structuredClone(generators),
    claim:'arbitrary time-dependent retained-environment coefficients multiplying these generators preserve all logical/reference readings throughout this joint control',physicalAdmission:null};}
function verifyProtection(m,available,g,p,gens,cert){assert.equal(key(cert),key(protection(m,available,g,p,gens)));return true;}
function jointEpisode(v,W,e){assert(W.length===16*e&&W.every(row=>row.length===16*e));eq(mm(adj(W),W),eye(16*e));
  for(const O of [v.support,...v.readings.map(q=>q.operator),v.H0])assert(isZero(comm(W,kron(O,eye(e)))),'episode lacks joint control and logical-content relations');}
function supported(v,rho,e,r){const P=D.lift(kron(v.support,eye(e*r)));D.qeq(D.qmul(D.qmul(P,rho),P),rho);}
const owned=new WeakMap();
class ProtectedControlBoundary {
  constructor(model,rho,e=1,r=1){owned.set(this,{model,source:new F.EncodedBoundary(model,rho,e,r),rho:null,e,r,phase:'initial',steps:0,exits:0});}
  enter(available,certificate){const s=owned.get(this);assert.equal(s.phase,'initial');s.source.encode(available,certificate);
    s.rho=D.lift(s.source.snapshot().rho);s.source=null;s.phase='protected';return this;}
  apply(available,g,p,episodes){const s=owned.get(this);assert.equal(s.phase,'protected');const v=verify(s.model,available,g,p);supported(v,s.rho,s.e,s.r);
    assert(Array.isArray(episodes)&&episodes.length>0);episodes.forEach(W=>jointEpisode(v,W,s.e));
    // W is an exact witness used for this finite execution. The protection
    // theorem also covers unknown histories in an explicitly admitted family.
    let W=eye(16*s.e);for(const w of episodes)W=mm(w,W);
    const U=kron(mm(W,kron(v.N,eye(s.e))),eye(s.r)),next=D.act(D.lift(U),s.rho);
    const rho={A:scale(next.A,div(one,v.norm)),B:scale(next.B,div(one,v.norm))};supported(v,rho,s.e,s.r);
    s.rho=rho;s.steps++;return this;}
  exit(available,certificate){const s=owned.get(this);assert.equal(s.phase,'protected');const v=D.verify(s.model,available,certificate);supported(v,s.rho,s.e,s.r);
    const rho=D.act(D.tensor(v.U,eye(s.e*s.r)),s.rho),P=D.lift(kron(v.output,eye(s.e*s.r)));D.qeq(D.qmul(D.qmul(P,rho),P),rho);
    s.rho=rho;s.phase='native';s.exits++;return this;}
  read(name,reference){const s=owned.get(this);if(s.phase==='initial')return {a:s.source.read(name,reference),b:z};
    const d=F.exchangeCode(s.model),q=(s.phase==='native'?d.native:d.readings).find(q=>q.name===name);assert(q);reference??=eye(s.r);
    assert(reference.length===s.r&&reference.every(row=>row.length===s.r));eq(adj(reference),reference);
    const O=kron(q.operator,kron(eye(s.e),reference));return {a:tr(mm(s.rho.A,O)),b:tr(mm(s.rho.B,O))};}
  nativeState(){const s=owned.get(this);assert.equal(s.phase,'native');return {A:D.reduceNative(s.rho.A,s.e,s.r),B:D.reduceNative(s.rho.B,s.e,s.r)};}
  snapshot(){const s=owned.get(this);return {rho:s.rho?structuredClone(s.rho):D.lift(s.source.snapshot().rho),phase:s.phase,steps:s.steps,exits:s.exits,physicalAdmission:null};}
}
if(require.main===module){const b=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=M.currentModel();
  F.verify(m,b.entryAvailable,b.entry);D.verify(m,b.exitAvailable,b.exit);const v=b.plans.map(p=>verify(m,b.available,p.goal,p.certificate));
  b.plans.forEach(p=>verifyProtection(m,b.available,p.goal,p.certificate,b.generators,p.protection));
  console.log(R.serialize({plans:v.length,coefficients:v.map(p=>p.coefficients),constructionCalls:counters,entryConstructionCalls:F.counters,
    exitConstructionCalls:D.counters,exchangeConstructionCalls:M.counters,physicalAdmission:null}));}
module.exports={access,construct,verify,protection,verifyProtection,jointEpisode,ProtectedControlBoundary,counters,exact:E};
