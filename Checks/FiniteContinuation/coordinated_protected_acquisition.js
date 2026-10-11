"use strict";
// Protected input capacity and a four-role acquisition retaining the same
// unknown logical data. Coherent interpretation and readout remain premises.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const M=require('./coordinated_moving_boundary.js'),T=require('./coordinated_instrument_transport.js');
const B=require('./coordinated_probe_continuation.js'),Q=require('./coordinated_question_bounds.js');
const E=C.exact,{c,z,one,ii,nz,add,sub,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,kernel,rref}=E;
const key=C.json,counters={decompositions:0,constructions:0};
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],P0=[[one,z],[z,z]],P1=[[z,z],[z,one]];
function touch(model){M.proveMovingProtection(model,[]);}
function collective(model,n){touch(model);assert(Number.isSafeInteger(n)&&n>=1&&n<=4);
  const I=eye(2**n),J=[X,Y,Z].map(axis=>Array.from({length:n},(_,i)=>Array.from({length:n},(_,j)=>i===j?axis:I2).reduce(kron)).reduce(plus));
  return {I,J,raising:scale(plus(J[0],scale(J[1],ii)),c(1,0,2)),lowering:scale(minus(J[0],scale(J[1],ii)),c(1,0,2))};}
function inverse(A){const n=A.length,rr=rref(A.map((row,i)=>[...row,...eye(n)[i]]));assert.deepEqual(rr.pivots.slice(0,n),Array.from({length:n},(_,i)=>i));return rr.A.map(row=>row.slice(n));}
function decomposition(model,n){counters.decompositions++;const d=collective(model,n),columns=[],blocks=[];
  for(let h=n;h>=0;h-=2){const indices=Array.from({length:2**n},(_,i)=>i).filter(i=>d.J[2][i][i][0]===BigInt(h));
    const highest=kernel(d.raising.map(row=>indices.map(i=>row[i])));blocks.push({highestWeight:h,multiplicity:highest.length});
    for(const raw of highest){let v=mat(2**n,1);indices.forEach((i,j)=>v[i][0]=raw[j]);
      for(let k=0;k<=h;k++){columns.push(v);v=mm(d.lowering,v);}assert(isZero(v));}}
  const V=Array.from({length:2**n},(_,i)=>columns.map(v=>v[i][0]));
  const certificate={kind:'collective-spin-decomposition',source:model.source,n,blocks,basis:V,inverse:inverse(V),physicalAdmission:null};
  verifyDecomposition(model,n,certificate);return certificate;}
function verifyDecomposition(model,n,p){const d=collective(model,n),N=2**n;assert.equal(p.kind,'collective-spin-decomposition');assert.equal(key(p.source),key(model.source));
  assert.equal(p.n,n);assert.equal(p.physicalAdmission,null);assert(p.basis.length===N&&p.basis.every(r=>r.length===N));
  assert(p.inverse.length===N&&p.inverse.every(r=>r.length===N));eq(mm(p.inverse,p.basis),d.I);eq(mm(p.basis,p.inverse),d.I);
  const Jz=mat(N),Jp=mat(N),Jm=mat(N);let offset=0;
  assert.equal(new Set(p.blocks.map(b=>b.highestWeight)).size,p.blocks.length);
  for(const {highestWeight:h,multiplicity:m}of p.blocks){assert(Number.isSafeInteger(h)&&h>=0&&h<=n&&h%2===n%2);assert(Number.isSafeInteger(m)&&m>0);
    for(let a=0;a<m;a++){for(let k=0;k<=h;k++){Jz[offset+k][offset+k]=c(h-2*k);
      if(k>0)Jp[offset+k-1][offset+k]=c(k*(h-k+1));if(k<h)Jm[offset+k+1][offset+k]=one;}offset+=h+1;}}
  assert.equal(offset,N);eq(mm(d.J[2],p.basis),mm(p.basis,Jz));eq(mm(d.raising,p.basis),mm(p.basis,Jp));eq(mm(d.lowering,p.basis),mm(p.basis,Jm));
  return {blocks:p.blocks,multiplicities:p.blocks.map(b=>b.multiplicity),protectedAlgebraDimension:p.blocks.reduce((s,b)=>s+b.multiplicity**2,0),physicalAdmission:null};}
function capacity(model,decompositionCertificate,quantumDimension,outcomes){const d=verifyDecomposition(model,decompositionCertificate.n,decompositionCertificate);
  assert(Number.isSafeInteger(quantumDimension)&&quantumDimension>0&&Number.isSafeInteger(outcomes)&&outcomes>0);
  const slots=d.blocks.flatMap((b,j)=>Array.from({length:Math.floor(b.multiplicity/quantumDimension)},(_,k)=>({block:j,firstCopy:k*quantumDimension,copies:quantumDimension})));
  return {kind:outcomes<=slots.length?'protected-source-question-capacity':'protected-source-question-obstruction',source:model.source,
    quantumDimension,outcomes,maximumOutcomes:slots.length,allocation:outcomes<=slots.length?slots.slice(0,outcomes):null,
    scope:'corner embedding of C^r tensor M_d in the fixed protected source algebra; no external preexisting record, no unprotected gauge question, no claim about all dynamic protocols',physicalAdmission:null};}
function verifyCapacity(model,p,d,r,certificate){const expected=capacity(model,p,d,r);assert.equal(key(certificate),key(expected));return certificate.kind==='protected-source-question-capacity';}
function sourceData(model){touch(model);const d=collective(model,4),{P,Q:Qsource,T:Tsource}=model.operators;
  const pairWords=[['P'],['Q'],['T'],['P','Q','P'],['Q','T','Q'],['P','Q','T','Q','P']];
  const pairs=pairWords.map(word=>word.reduce((U,name)=>mm(model.operators[name],U),model.I)),K=pairs.reduce(plus);
  const J2=d.J.map(J=>mm(J,J)).reduce(plus);eq(J2,scale(K,c(4)));
  const singlet=scale(mm(minus(J2,scale(model.I,c(8))),minus(J2,scale(model.I,c(24)))),c(1,0,192));
  const spin1=scale(mm(J2,minus(scale(model.I,c(24)),J2)),c(1,0,128));
  const spin2=scale(mm(J2,minus(J2,scale(model.I,c(8)))),c(1,0,384));
  [singlet,spin1,spin2].forEach(p=>{eq(adj(p),p);eq(mm(p,p),p);});eq(plus(plus(singlet,spin1),spin2),model.I);
  assert.deepEqual([singlet,spin1,spin2].map(tr),[c(2),c(9),c(5)]);
  const support=model.initial,branches=[singlet,minus(support,singlet)],question=minus(scale(singlet,c(2)),model.I);
  eq(mm(support,singlet),singlet);eq(mm(support,spin1),branches[1]);eq(mm(support,spin2),mat(16));
  branches.forEach(p=>eq(mm(p,p),p));assert.deepEqual(branches.map(tr),[c(2),c(6)]);
  const readings=[{name:'P',operator:mm(support,P)},{name:'Q',operator:mm(support,Qsource)},
    {name:'C',operator:mm(support,scale(comm(P,Qsource),ii))}];
  for(const p of branches){const a=mm(p,P),b=mm(p,Qsource);eq(mm(a,a),p);eq(mm(b,b),p);
    eq(plus(mm(a,b),mm(b,a)),scale(p,c(-1)));eq(mm(scale(comm(a,b),ii),scale(comm(a,b),ii)),scale(p,c(3)));}
  for(const J of d.J)for(const O of [support,question,...branches,P,Qsource,Tsource,...readings.map(r=>r.operator)])assert(isZero(comm(J,O)));
  return {...d,pairs,K,J2,singlet,spin1,spin2,support,branches,question,readings};}
function access(){return {kind:'declared-protected-boundary-access',controls:M.access(['P','Q']),conditionalFirst:'quarter-P-after-actual-raw-one',
  sectorProbe:{coherent:'controlled(2*spin0-projector-I)',path:'phase-fixed-involution',probePreparation:0,probeRotations:'ideal-H-before-and-after',
    readout:'ideal-projective-Z',reset:'same-raw-bit'},physicalAdmission:null};}
function validateAccess(a){const {controls,...rest}=a,{controls:unused,...expected}=access();
  assert.equal(key(rest),key(expected),'this construction requires the separately declared sector readout');
  assert(Array.isArray(controls.names)&&controls.names.includes('P'),'the conditional P must be available');
  assert.equal(new Set(controls.names).size,controls.names.length);controls.names.forEach(n=>assert(['P','Q','T','ReceiverQ'].includes(n)));
  assert.equal(key(controls),key(M.access(controls.names)),'the exchange path must be declared separately from its endpoint');}
function construct(model,goal,available=access()){touch(model);validateAccess(available);counters.constructions++;const d=sourceData(model),frames=[model.I,model.operators.P];
  const next=frames.map(frame=>M.construct(model,available.controls,M.constraints(model,frame,goal)));
  const instrument={kind:'declared-recorded-instrument',inputDimension:16,outcomes:d.branches.map((p,a)=>({label:String(a),kraus:[mm(frames[a],p)]}))};
  const frame={kind:'declared-generated-star-algebra',support:d.support,readings:d.readings};
  const transport=T.construct(model.base,frame,instrument);
  const out={kind:'protected-sector-acquisition-and-continuation',source:model.source,goal:structuredClone(goal),available:structuredClone(available),
    support:d.support,question:d.question,branches:d.branches,frames,next,transport,physicalAdmission:null};verify(model,goal,available,out);return out;}
function verify(model,goal,available,p){touch(model);validateAccess(available);assert.equal(p.kind,'protected-sector-acquisition-and-continuation');
  assert.equal(key(p.source),key(model.source));assert.equal(key(p.goal),key(goal));assert.equal(key(p.available),key(available));assert.equal(p.physicalAdmission,null);
  const d=sourceData(model);eq(p.support,d.support);eq(p.question,d.question);assert.equal(key(p.branches),key(d.branches));assert.equal(key(p.frames),key([model.I,model.operators.P]));
  assert.equal(p.next.length,2);const next=p.frames.map((f,a)=>M.verify(model,available.controls,M.constraints(model,f,goal),p.next[a]));assert(next.every(Boolean));
  const instrument={kind:'declared-recorded-instrument',inputDimension:16,outcomes:d.branches.map((q,a)=>({label:String(a),kraus:[mm(p.frames[a],q)]}))};
  const frame={kind:'declared-generated-star-algebra',support:d.support,readings:d.readings};assert(T.verify(model.base,frame,instrument,p.transport).admitted);
  // Full phase-fixed probe identity: the source channel alone is not used
  // to infer this controlled extension. Reset uses the measured raw bit.
  const W=B.probeSandwich(B.controlled(d.question)),prepared=mat(32,16);for(let i=0;i<16;i++)prepared[i][i]=one;
  [P0,P1].forEach((selector,a)=>{const full=mm(mm(kron(a?X:I2,model.I),kron(selector,model.I)),W);
    eq(mm(full,mm(prepared,d.support)),mm(prepared,d.branches[a]));});
  return {...d,next,transport:p.transport,probeOperator:W,scope:'protected source record and a common arbitrary logical qubit; gauge states may change',physicalAdmission:null};}
function validateBackground(model,W,dimension){touch(model);const I=eye(16*dimension);assert(W.length===I.length&&W.every(r=>r.length===I.length));eq(mm(adj(W),W),I);
  for(const O of [model.initial,...Object.values(model.operators)])assert(isZero(comm(W,kron(O,eye(dimension)))),'background violates the declared preserved relations');}
const live=new WeakMap();
class ProtectedBoundary {
  constructor(model,rho,environmentDimension=1,referenceDimension=1){touch(model);const d=sourceData(model);
    assert(Number.isSafeInteger(environmentDimension)&&environmentDimension>0&&Number.isSafeInteger(referenceDimension)&&referenceDimension>0);
    assert(rho.length===16*environmentDimension*referenceDimension&&rho.every(row=>row.length===rho.length));
    Q.verifyFactor(rho,Q.factorOrWitness(rho));assert.deepEqual(tr(rho),one);
    const support=kron(d.support,eye(environmentDimension*referenceDimension));eq(mm(mm(support,rho),support),rho);
    live.set(this,{model,environmentDimension,referenceDimension,blocks:[{raw:null,frame:model.I,rho:structuredClone(rho)}],acquired:false,continuations:0});}
  acquire(goal,available,plan,backgrounds){const s=live.get(this);assert(!s.acquired,'this occurrence has already acquired its source question');
    const d=verify(s.model,goal,available,plan);assert.equal(backgrounds.length,2);backgrounds.forEach(W=>validateBackground(s.model,W,s.environmentDimension));
    const blocks=d.branches.map((p,a)=>{const joint=mm(backgrounds[1],mm(kron(mm(plan.frames[a],p),eye(s.environmentDimension)),backgrounds[0]));
      const K=kron(joint,eye(s.referenceDimension));return {raw:a,frame:structuredClone(plan.frames[a]),rho:mm(mm(K,s.blocks[0].rho),adj(K))};});
    assert.deepEqual(blocks.reduce((n,b)=>add(n,tr(b.rho)),z),one);s.blocks=blocks;s.acquired=true;return this;}
  continue(goal,available,plan,backgroundsByRaw){const s=live.get(this);assert(s.acquired);const d=verify(s.model,goal,available,plan);
    assert.equal(backgroundsByRaw.length,2);const operators=s.blocks.map(b=>{eq(b.frame,plan.frames[b.raw]);const next=d.next[b.raw],backgrounds=backgroundsByRaw[b.raw];
      assert.equal(backgrounds.length,Math.max(1,next.word.length));backgrounds.forEach(W=>validateBackground(s.model,W,s.environmentDimension));
      let U=eye(16*s.environmentDimension);for(let j=0;j<backgrounds.length;j++){const control=next.word[j]?scale(s.model.operators[next.word[j]],c(0,-1)):s.model.I;
        U=mm(mm(backgrounds[j],kron(control,eye(s.environmentDimension))),U);}return kron(U,eye(s.referenceDimension));});
    const blocks=s.blocks.map((b,i)=>({...b,rho:mm(mm(operators[i],b.rho),adj(operators[i]))}));s.blocks=blocks;s.continuations++;return this;}
  read(name,reference){const s=live.get(this),q=sourceData(s.model).readings.find(q=>q.name===name);assert(q);reference??=eye(s.referenceDimension);eq(adj(reference),reference);
    assert(reference.length===s.referenceDimension);return s.blocks.reduce((v,b)=>add(v,tr(mm(b.rho,kron(mm(mm(b.frame,q.operator),adj(b.frame)),kron(eye(s.environmentDimension),reference))))),z);}
  snapshot(){const s=live.get(this);return {blocks:structuredClone(s.blocks),acquired:s.acquired,continuations:s.continuations,physicalAdmission:null};}
}
if(require.main===module){const b=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=M.currentModel();
  const decompositions=b.decompositions.map(p=>verifyDecomposition(m,p.n,p));const v=verify(m,b.goal,b.available,b.plan);
  const following=verify(m,b.following,b.available,b.secondPlan);
  console.log(R.serialize({decompositions:decompositions.map(d=>({multiplicities:d.multiplicities,dimension:d.protectedAlgebraDimension})),
    capacityClaims:b.capacities.map(x=>verifyCapacity(m,b.decompositions[x.n-1],x.d,x.r,x.certificate)),nextSections:v.next.map(p=>p.minimumSections),
    followingSections:following.next.map(p=>p.minimumSections),
    constructionCalls:counters,movingConstructionCalls:M.counters,instrumentConstructionCalls:T.counters,physicalAdmission:null}));}
module.exports={collective,decomposition,verifyDecomposition,capacity,verifyCapacity,sourceData,access,construct,verify,ProtectedBoundary,counters,exact:E};
