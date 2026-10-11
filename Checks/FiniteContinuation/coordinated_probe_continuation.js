"use strict";
// A phase-fixed coherent probe realization and an owned continuing boundary.
// All gates below are declared ideal operations, not acquired hardware facts.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const A=require('./coordinated_acquired_question.js'),T=require('./coordinated_instrument_transport.js');
const E=C.exact,{c,z,one,nz,add,sub,mul,div,mat,eye,scale,plus,minus,adj,mm,kron,tr,eq,isZero}=E;
const key=C.json,counters={lowerings:0,compilations:0};
const I2=eye(2),P0=[[one,z],[z,z]],P1=[[z,z],[z,one]],X=[[z,one],[one,z]],H0=[[one,one],[one,c(-1)]];
function touch(m){C.verifyPlan(m,{targetScore:[],inputProjector:m.Pi,requiredInteriorCuts:[]},C.accessModel([]),
  {rule:'retain-source-score',source:m.source,score:[]});}
function primitiveAccess(){return {kind:'declared-phase-fixed-probe-primitives',gates:['H','X','CX','CCX','Sdg'],
  probePreparation:0,measurement:'projective-Z',reset:'X-from-same-raw-record',
  permutationEntries:'positive-unit',physicalAdmission:null};}
function validateAccess(access){assert.equal(access.kind,'declared-phase-fixed-probe-primitives');
  assert.equal(access.probePreparation,0,'unknown probe is not the declared prepared probe');
  assert.equal(access.measurement,'projective-Z');assert.equal(access.reset,'X-from-same-raw-record');
  assert.equal(access.permutationEntries,'positive-unit','classical truth tables alone do not fix coherent phases');assert.equal(access.physicalAdmission,null);
  assert(Array.isArray(access.gates));assert.equal(new Set(access.gates).size,access.gates.length);
  access.gates.forEach(g=>assert(['H','X','CX','CCX','Sdg'].includes(g)));}
function flipGate(wires,controls,target){assert(Number.isSafeInteger(wires)&&wires>0&&wires<=10);
  assert(Number.isSafeInteger(target)&&target>=0&&target<wires);assert.equal(new Set(controls).size,controls.length);
  controls.forEach(j=>assert(Number.isSafeInteger(j)&&j>=0&&j<wires&&j!==target));
  const M=mat(2**wires);for(let x=0;x<M.length;x++){
    const active=controls.every(j=>(x>>(wires-1-j))&1),y=active?x^(1<<(wires-1-target)):x;M[y][x]=one;}return M;}
function gateOperator(gate,wires,access){validateAccess(access);assert(access.gates.includes(gate.kind),'primitive gate is not declared');
  if(['X','CX','CCX'].includes(gate.kind)){assert.equal(gate.controls.length,{X:0,CX:1,CCX:2}[gate.kind]);return flipGate(wires,gate.controls,gate.target);}
  assert.equal(gate.kind,'Sdg','H is represented only by the two-H normalized sandwich');
  assert(Number.isSafeInteger(gate.target)&&gate.target>=0&&gate.target<wires);
  const M=eye(2**wires);for(let x=0;x<M.length;x++)if((x>>(wires-1-gate.target))&1)M[x][x]=c(0,-1);return M;
}
function controlled(U){const n=U.length,M=mat(2*n);for(let i=0;i<n;i++)for(let j=0;j<n;j++){
  M[i][j]=i===j?one:z;M[n+i][n+j]=U[i][j];}return M;}
function probeSandwich(U){const n=U.length/2,H=kron(H0,eye(n));const W=scale(mm(mm(H,U),H),c(1,0,2));
  eq(mm(adj(W),W),eye(2*n));return W;}
function sourcePair(m,name){touch(m);assert(['P','Q'].includes(name));const p=m.ports[name],different=p.map((x,i)=>x!==i?i:-1).filter(i=>i>=0);
  assert.equal(different.length,2);const [a,b]=different;assert.equal(p[a],b);assert.equal(p[b],a);return [a+1,b+1];}
function lowerReadout(m,name,access){validateAccess(access);counters.lowerings++;const [a,b]=sourcePair(m,name);
  const certificate={kind:'source-swap-probe-lowering',source:m.source,name,access:structuredClone(access),
    word:[{kind:'CX',controls:[b],target:a},{kind:'CCX',controls:[0,a],target:b},{kind:'CX',controls:[b],target:a}],
    preparation:0,readWire:0,reset:'same-raw-record',physicalAdmission:null};verifyReadout(m,name,access,certificate);return certificate;}
function verifyReadout(m,name,access,certificate){touch(m);validateAccess(access);sourcePair(m,name);
  assert.equal(certificate.kind,'source-swap-probe-lowering');assert.equal(key(certificate.source),key(m.source));assert.equal(certificate.name,name);
  assert.equal(key(certificate.access),key(access));assert.equal(certificate.physicalAdmission,null);
  assert.equal(certificate.preparation,0);assert.equal(certificate.readWire,0);assert.equal(certificate.reset,'same-raw-record');
  assert(access.gates.includes('H')&&access.gates.includes('X'),'probe rotation and actual-record reset must be available');
  const n=m.I.length,wires=1+Math.log2(n);assert(Number.isInteger(wires));
  const V=certificate.word.reduce((V,g)=>mm(gateOperator(g,wires,access),V),eye(2*n));
  // A channel-equivalence witness would be insufficient for this equality.
  eq(V,controlled(m[name]),'controlled embedding changed the relative phase or addressed source action');
  const W=probeSandwich(V),prepared=mat(2*n,n);for(let i=0;i<n;i++)prepared[i][i]=one;
  const operators=[0,1].map(a=>mm(mm(kron(a?X:I2,m.I),kron(a?P1:P0,m.I)),W));
  const sourceOperators=[0,1].map(a=>scale(plus(m.I,scale(m[name],c(a?-1:1))),c(1,0,2)));
  operators.forEach((K,a)=>eq(mm(K,prepared),mm(prepared,sourceOperators[a]),'probe did not return to zero with the promised source branch'));
  eq(plus(mm(adj(operators[0]),operators[0]),mm(adj(operators[1]),operators[1])),eye(2*n));
  return {controlled:V,sandwich:W,operators,sourceOperators,prepared,physicalAdmission:null};
}
function planArguments(request,acquisitionAccess,probeAccess,next){return {request:structuredClone(request),acquisitionAccess:structuredClone(acquisitionAccess),
  probeAccess:structuredClone(probeAccess),next:structuredClone(next)};}
function planInstrument(m,checked){return {kind:'declared-recorded-instrument',inputDimension:m.I.length,
  outcomes:checked.branches.map(b=>({label:String(b.answer),kraus:[b.sourceOperator]}))};}
function compile(m,request,acquisitionAccess,probeAccess,next,frames){counters.compilations++;touch(m);assert.equal(next.length,2);
  const acquisition=A.construct(m,request,acquisitionAccess);assert.equal(acquisition.kind,'constructed-projective-acquisition','no construction within the declared acquisition rule');
  const lowering=acquisition.program.readout===null?null:lowerReadout(m,acquisition.program.readout,probeAccess);
  const nextCertificates=next.map(({goal,access})=>R.resolve(m,goal,access));
  const certificate={kind:'owned-probe-continuation',source:m.source,...planArguments(request,acquisitionAccess,probeAccess,next),
    acquisition,lowering,nextCertificates,physicalAdmission:null};
  const checked=verifyCore(m,request,acquisitionAccess,probeAccess,next,certificate),inst=planInstrument(m,checked);
  certificate.stage=T.deriveStage(m,frames,inst);verify(m,request,acquisitionAccess,probeAccess,next,certificate);return certificate;
}
function verifyCore(m,request,acquisitionAccess,probeAccess,next,certificate){touch(m);assert.equal(certificate.kind,'owned-probe-continuation');
  assert.equal(key(certificate.source),key(m.source));assert.equal(certificate.physicalAdmission,null);assert.equal(next.length,2);
  const args=planArguments(request,acquisitionAccess,probeAccess,next);for(const k of Object.keys(args))assert.equal(key(args[k]),key(certificate[k]),'certificate does not belong to the requested continuation');
  const acquisition=A.verify(m,request,acquisitionAccess,certificate.acquisition);assert(acquisition.admitted);
  assert.equal(certificate.nextCertificates.length,2);
  const nextChecked=next.map(({goal,access},a)=>{assert.equal(certificate.nextCertificates[a].physicalAdmission,null);
    const p=R.verify(m,goal,access,certificate.nextCertificates[a]);assert(p.operator,'no following program admitted');return p;});
  const program=certificate.acquisition.program,n=m.I.length;
  let branches;
  if(program.readout===null){assert.equal(certificate.lowering,null);const answer=program.constant;
    const V=nextChecked[answer].operator;branches=[{raw:null,answer,operator:kron(I2,V),sourceOperator:mm(V,m.Pi)}];
  }else{
    const read=verifyReadout(m,program.readout,probeAccess,certificate.lowering),parts=A.instantiate(m,acquisitionAccess);
    const control=name=>{if(name===null)return m.I;const p=parts.controls.find(p=>p.name===name);assert(p);return p.operator;};
    const pre=control(program.pre),post=control(program.post);
    branches=[0,1].map(raw=>{const answer=program.decoder[raw],V=nextChecked[answer].operator;
      const K=mm(kron(I2,mm(V,post)),mm(read.operators[raw],kron(I2,pre)));
      const expected=mm(V,acquisition.operators[answer]);
      eq(mm(K,mm(read.prepared,m.Pi)),mm(read.prepared,expected),'lowered acquisition and actual-record continuation disagree');
      return {raw,answer,operator:K,sourceOperator:expected};});
  }
  return {branches,nextChecked,acquisition,physicalAdmission:null};
}
function verify(m,request,acquisitionAccess,probeAccess,next,certificate){const result=verifyCore(m,request,acquisitionAccess,probeAccess,next,certificate);
  const inst=planInstrument(m,result),stage=certificate.stage;assert.equal(stage.kind,'instrument-stage');assert.equal(stage.physicalAdmission,null);
  assert.equal(key(stage.instrument),key(inst));assert(stage.cases.length>0);assert.equal(new Set(stage.cases.map(c=>key(c.input))).size,stage.cases.length);
  for(const c of stage.cases)assert(T.verify(m,c.input,inst,c).admitted,'a declared future cannot survive this complete episode');
  return {...result,instrument:inst,stage};}
function positive(M){eq(adj(M),M);const A=M.map(r=>r.slice());for(let k=0;k<A.length;k++){const p=A[k][k];assert.equal(p[1],0n);assert(p[0]>=0n);
  if(!nz(p)){for(let j=k+1;j<A.length;j++)assert(!nz(A[k][j]));continue;}
  for(let i=k+1;i<A.length;i++)for(let j=k+1;j<A.length;j++)A[i][j]=sub(A[i][j],div(mul(A[i][k],A[k][j]),p));}}
const live=new WeakMap();
class ProbeBoundary {
  constructor(m,frame,rho,referenceDimension=1){touch(m);T.validateFrame(frame);assert.equal(frame.support.length,m.I.length);
    assert(Number.isSafeInteger(referenceDimension)&&referenceDimension>0);assert.equal(rho.length,m.I.length*referenceDimension);
    assert(rho.every(row=>row.length===rho.length));positive(rho);assert.deepEqual(tr(rho),one);
    const P=kron(frame.support,eye(referenceDimension));eq(mm(mm(P,rho),P),rho);eq(mm(m.Pi,frame.support),frame.support);
    // This is an explicitly prepared independent probe. The supplied source
    // and reference are retained; later calls accept no replacement state.
    live.set(this,{m,referenceDimension,blocks:[{record:[],frame:structuredClone(frame),rho:kron(P0,rho)}],steps:0});}
  frontier(){return [...new Map(live.get(this).blocks.map(b=>[key(b.frame),structuredClone(b.frame)])).values()];}
  execute(request,acquisitionAccess,probeAccess,next,certificate){const s=live.get(this);
    const checked=verify(s.m,request,acquisitionAccess,probeAccess,next,certificate);
    const cases=s.blocks.map(b=>{const found=checked.stage.cases.filter(c=>key(c.input)===key(b.frame));assert.equal(found.length,1,'actual boundary has no matching future certificate');return found[0];});
    const blocks=[];for(let j=0;j<s.blocks.length;j++)for(let a=0;a<checked.branches.length;a++){
      const b=s.blocks[j],branch=checked.branches[a],out=cases[j].outputs[a];if(!out.frame)continue;
      const K=kron(branch.operator,eye(s.referenceDimension)),rho=mm(mm(K,b.rho),adj(K));
      const support=kron(P0,kron(out.frame.support,eye(s.referenceDimension)));eq(mm(mm(support,rho),support),rho,'probe reset or output support failed');
      blocks.push({record:[...b.record,{raw:branch.raw,answer:branch.answer}],frame:structuredClone(out.frame),rho});
    }
    assert.deepEqual(blocks.reduce((sum,b)=>add(sum,tr(b.rho)),z),one);
    // All certificates and all branches have been checked before mutation.
    s.blocks=blocks;s.steps++;return this;
  }
  inspect(name,reference){const s=live.get(this);reference??=eye(s.referenceDimension);assert.equal(reference.length,s.referenceDimension);
    assert(reference.every(row=>row.length===s.referenceDimension));eq(adj(reference),reference);
    return s.blocks.reduce((sum,b)=>{const q=b.frame.readings.find(q=>q.name===name);assert(q,'question outside the declared future');
      return add(sum,tr(mm(b.rho,kron(P0,kron(q.operator,reference)))));},z);}
  snapshot(){const s=live.get(this);return {blocks:structuredClone(s.blocks),steps:s.steps,referenceDimension:s.referenceDimension,physicalAdmission:null};}
}
if(require.main===module){const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=C.currentModel();
  const verified=bundle.map(b=>verify(m,b.request,b.acquisitionAccess,b.probeAccess,b.next,b.certificate).branches.length);
  console.log(JSON.stringify({verified,constructionCalls:counters,acquisitionConstructionCalls:A.counters,relationConstructionCalls:R.counters,
    transportConstructionCalls:T.counters,physicalAdmission:null}));}
module.exports={primitiveAccess,flipGate,gateOperator,controlled,probeSandwich,lowerReadout,verifyReadout,compile,verify,ProbeBoundary,counters,exact:E};
