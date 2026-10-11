"use strict";
// Derive a control subspace from the current boundary, then compile only
// inside it. Path preservation and the requested endpoint are separate proofs.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js'),D=require('./coordinated_native_exit.js'),G=require('./coordinated_protected_control.js');
const E=C.exact,{c,z,one,nz,add,sub,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,kernel}=E,key=C.json;
const counters={spaceConstructions:0,linearSolves:0,wordClosures:0};
function equations(m){const d=F.exchangeCode(m),names=['P','Q','T'],columns=names.map(n=>comm(m.operators[n],d.support).flat()),rows=[];
  for(let i=0;i<256;i++){rows.push(columns.map(v=>c(v[i][0],0,v[i][2])));rows.push(columns.map(v=>c(v[i][1],0,v[i][2])));}return {d,names,rows};}
function derive(m){const {rows}=equations(m);counters.spaceConstructions++;counters.linearSolves++;const basis=kernel(rows);
  assert.equal(basis.length,2);const row=rows.findIndex(r=>r.some(nz)),column=rows[row].findIndex(nz);
  const p={kind:'full-boundary-control-space',source:m.source,basis,nonzeroMinor:{row,column,value:rows[row][column]},physicalAdmission:null};verifySpace(m,p);return p;}
function verifySpace(m,p){const {d,rows}=equations(m);assert.equal(p.kind,'full-boundary-control-space');assert.equal(key(p.source),key(m.source));assert.equal(p.physicalAdmission,null);
  assert.equal(p.basis.length,2);for(const v of p.basis){assert.equal(v.length,3);v.forEach(x=>assert.equal(x[1],0n));for(const row of rows)
    assert.deepEqual(row.reduce((a,x,i)=>add(a,mul(x,v[i])),z),z);}
  const [u,v]=p.basis;assert([0,1,2].some(i=>[0,1,2].some(j=>nz(sub(mul(u[i],v[j]),mul(u[j],v[i]))))),'two independent null vectors required');
  const w=p.nonzeroMinor;assert(Number.isSafeInteger(w.row)&&Number.isSafeInteger(w.column));assert(w.row>=0&&w.row<rows.length&&w.column>=0&&w.column<3);
  assert.deepEqual(rows[w.row][w.column],w.value);assert(nz(w.value),'rank lower bound needs an actual nonzero minor');
  // Two null vectors and one nonzero constraint prove the exact dimension.
  eq(comm(m.operators.Q,d.support),mat(16));eq(comm(m.operators.T,d.support),scale(comm(m.operators.P,d.support),c(-1)));
  const difference=minus(m.operators.P,m.operators.T),PT=mm(m.operators.P,m.operators.T),minusPT=scale(minus(m.I,PT),c(1,0,2));
  eq(mm(difference,difference),scale(minusPT,c(4)));eq(mm(minusPT,minusPT),minusPT);assert(nz(tr(mm(minusPT,d.support))));
  eq(plus(mm(d.K,difference),mm(difference,d.K)),mat(16));
  return {...d,dimension:2,condition:'uP(t)=uT(t) almost everywhere; uQ(t) unrestricted',difference,differenceNorm:c(2),physicalAdmission:null};}
function access(){return {kind:'declared-protected-quarter-axis-access',letters:['Q+','Q-','PT+','PT-'],
  Q:'exp(-i sign*pi*Q/4)',PT:'exp(-i sign*pi*(P+T)/4)',
  pair:'P and T share their entire envelope; Q can be scheduled independently',
  phase:'channel on the admitted code with arbitrary reference; no coherent controlled use',physicalAdmission:null};}
function validate(a){assert.equal(key(a),key(access()));}
function gate(m,available,letter){validate(available);assert(available.letters.includes(letter));const sign=letter.endsWith('+')?1:-1;
  const f=S=>plus(m.I,scale(S,c(0,-sign)));return letter.startsWith('PT')?{N:mm(f(m.operators.P),f(m.operators.T)),den:4,axis:plus(m.operators.P,m.operators.T)}:{N:f(m.operators.Q),den:2,axis:m.operators.Q};}
function program(m,available,word){let N=m.I,den=1;for(const letter of word){const g=gate(m,available,letter);N=mm(g.N,N);den*=g.den;assert(Number.isSafeInteger(den));}eq(mm(adj(N),N),scale(m.I,c(den)));return {N,den};}
function goal(m,g){const d=F.exchangeCode(m);assert.equal(g.kind,'protected-reading-relations');eq(g.input,d.support);assert.deepEqual(g.requiredInteriorCuts,[]);assert(g.relations.length);
  for(const q of g.relations)for(const O of [q.before,q.after]){assert(O.length===16&&O.every(r=>r.length===16));eq(adj(O),O);eq(mm(d.support,O),O);eq(mm(O,d.support),O);}return d;}
function signature(N,Pi){const A=mm(N,Pi),first=A.flat().find(nz);assert(first);return key(A.map(row=>row.map(x=>div(x,first))));}
function satisfies(g,p){return g.relations.every(q=>isZero(mm(mm(g.input,minus(scale(mm(mm(adj(p.N),q.after),p.N),c(1,0,p.den)),q.before)),g.input)));}
function construct(m,available,g,space){validate(available);const d=goal(m,g);verifySpace(m,space);counters.wordClosures++;
  const states=[{word:[],distance:0,transitions:[]}],ops=[program(m,available,[])],seen=new Map([[signature(m.I,d.support),0]]);
  for(let i=0;i<states.length;i++)for(const letter of available.letters){const word=[...states[i].word,letter],p=program(m,available,word),sig=signature(p.N,d.support);let j=seen.get(sig);
    if(j===undefined){j=states.length;assert(j<24,'the declared logical quarter-axis grammar has 24 projective forms');seen.set(sig,j);states.push({word,distance:word.length,transitions:[]});ops.push(p);}states[i].transitions.push(j);}
  const matches=ops.map((p,i)=>i).filter(i=>satisfies(g,ops[i]));matches.sort((a,b)=>states[a].distance-states[b].distance);
  const p={kind:matches.length?'protected-axis-word':'protected-axis-obstruction',source:m.source,available:structuredClone(available),goal:structuredClone(g),space:structuredClone(space),states,chosen:matches[0]??null,physicalAdmission:null};verify(m,available,g,p);return p;}
function verify(m,available,g,p){validate(available);const d=goal(m,g);verifySpace(m,p.space);assert.equal(key(p.source),key(m.source));assert.equal(key(p.available),key(available));assert.equal(key(p.goal),key(g));assert.equal(p.physicalAdmission,null);
  const states=p.states;assert(states.length&&states.length<=24);const ops=states.map(s=>{assert.equal(s.distance,s.word.length);assert(Number.isSafeInteger(s.distance)&&s.distance>=0);return program(m,available,s.word);}),sigs=ops.map(o=>signature(o.N,d.support));
  assert.equal(new Set(sigs).size,states.length);assert.equal(states[0].distance,0);assert.equal(sigs[0],signature(m.I,d.support));
  states.forEach((s,i)=>{assert.equal(s.transitions.length,available.letters.length);available.letters.forEach((letter,k)=>{const j=s.transitions[k];assert(Number.isSafeInteger(j)&&j>=0&&j<states.length);
    assert.equal(signature(mm(gate(m,available,letter).N,ops[i].N),d.support),sigs[j]);assert(states[j].distance<=s.distance+1);});});
  const matches=ops.map((p,i)=>i).filter(i=>satisfies(g,ops[i]));if(!matches.length){assert.equal(p.kind,'protected-axis-obstruction');assert.equal(p.chosen,null);return null;}
  assert.equal(p.kind,'protected-axis-word');assert(matches.includes(p.chosen));assert(matches.every(i=>states[p.chosen].distance<=states[i].distance));
  return {...d,...ops[p.chosen],word:states[p.chosen].word,minimumSections:states[p.chosen].distance,physicalAdmission:null};}
function mismatchBound(pieces){let delta=z,signed=z;for(const x of pieces){for(const v of [x.duration,x.P,x.T]){assert.deepEqual(v,c(...v));assert.equal(v[1],0n);}assert(x.duration[0]>=0n);
    const diff=sub(x.P,x.T);signed=add(signed,mul(x.duration,diff));delta=add(delta,mul(x.duration,c(diff[0]<0n?-diff[0]:diff[0],0,diff[2])));}
  const min=(x,y)=>x[0]*y[2]<=y[0]*x[2]?x:y;
  return {delta,signedIntegral:signed,leakageUpper:min(one,mul(delta,delta)),questionErrorUpper:min(c(2),mul(c(2),delta)),
    relativeTo:'the symmetric Hamiltonian from these same coefficients and the same retained background, not an arbitrary target gate',
    scope:'Declared piecewise-constant Hamiltonian coefficients in inverse-time units with hbar absorbed; not a hardware calibration. The ideal symmetric path and retained background preserve Pi. Question bound is for Hermitian contractions, including arbitrary reference.',physicalAdmission:null};}
function resolve(m,interfaces,g,space){const attempted=[];
  for(const available of interfaces){if(available.kind===G.access().kind){const certificate=G.construct(m,available,g);attempted.push({interface:available.kind,found:certificate!==null});
      if(certificate)return {available:structuredClone(available),goal:structuredClone(g),certificate,sections:1,attempted};}
    else{const certificate=construct(m,available,g,space),v=verify(m,available,g,certificate);attempted.push({interface:available.kind,found:v!==null,certificate});
      if(v)return {available:structuredClone(available),goal:structuredClone(g),certificate,sections:v.minimumSections,attempted};}}
  return {unresolved:true,scope:'Only the supplied one-reflection and/or fixed quarter-axis grammars were considered',attempted};}
// One owned executor accepts either verified control implementation. Every
// word segment is admitted before any actual input is changed.
const owned=new WeakMap();
class BoundarySession {
  constructor(m,rho,e=1,r=1){owned.set(this,{m,source:new F.EncodedBoundary(m,rho,e,r),rho:null,e,r,phase:'initial',steps:0,exits:0});}
  enter(a,p){const s=owned.get(this);assert.equal(s.phase,'initial');s.source.encode(a,p);s.rho=D.lift(s.source.snapshot().rho);s.source=null;s.phase='protected';return this;}
  apply(a,g,p,episodes){const s=owned.get(this);assert.equal(s.phase,'protected');let steps,v;
    if(a.kind===G.access().kind){v=G.verify(s.m,a,g,p);steps=[{N:v.N,normalizer:v.norm,axis:v.H0}];}
    else {v=verify(s.m,a,g,p);assert(v,'no plan for the requested quarter-axis grammar');steps=v.word.map(letter=>{const x=gate(s.m,a,letter);return {...x,normalizer:c(x.den)};});if(!steps.length)steps=[{N:s.m.I,normalizer:one,axis:mat(16)}];}
    assert(episodes.length===steps.length);const Pi=D.lift(kron(v.support,eye(s.e*s.r)));D.qeq(D.qmul(D.qmul(Pi,s.rho),Pi),s.rho);
    episodes.forEach((W,i)=>G.jointEpisode({...v,H0:steps[i].axis},W,s.e));
    let rho=s.rho;for(let i=0;i<steps.length;i++){const U=kron(mm(episodes[i],kron(steps[i].N,eye(s.e))),eye(s.r)),q=D.act(D.lift(U),rho);
      rho={A:scale(q.A,div(one,steps[i].normalizer)),B:scale(q.B,div(one,steps[i].normalizer))};D.qeq(D.qmul(D.qmul(Pi,rho),Pi),rho);}
    s.rho=rho;s.steps++;return this;}
  exit(a,p){const s=owned.get(this);assert.equal(s.phase,'protected');const v=D.verify(s.m,a,p),Pi=D.lift(kron(v.support,eye(s.e*s.r)));D.qeq(D.qmul(D.qmul(Pi,s.rho),Pi),s.rho);
    s.rho=D.act(D.tensor(v.U,eye(s.e*s.r)),s.rho);s.phase='native';s.exits++;return this;}
  nativeState(){const s=owned.get(this);assert.equal(s.phase,'native');return {A:D.reduceNative(s.rho.A,s.e,s.r),B:D.reduceNative(s.rho.B,s.e,s.r)};}
  snapshot(){const s=owned.get(this);return {rho:s.rho?structuredClone(s.rho):D.lift(s.source.snapshot().rho),phase:s.phase,steps:s.steps,exits:s.exits,physicalAdmission:null};}
}
if(require.main===module){const b=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=M.currentModel();const v=verifySpace(m,b.space),plans=b.plans.map(p=>verify(m,b.available,p.goal,p.certificate));
  console.log(R.serialize({controlSpaceDimension:v.dimension,condition:v.condition,planLengths:plans.map(p=>p?.minimumSections??null),constructionCalls:counters,physicalAdmission:null}));}
module.exports={derive,verifySpace,access,gate,program,construct,verify,resolve,mismatchBound,BoundarySession,counters,exact:E};
