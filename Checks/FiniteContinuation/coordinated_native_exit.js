"use strict";
// Full-code coherent exit and re-entry. Exact Q(i,sqrt(2)) coefficients.
// The additional controlled-H and the native windows remain declared access.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js');
const E=C.exact,{c,z,one,ii,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=E,key=C.json,counters={constructions:0};
const lift=A=>({A,B:mat(A.length,A[0].length)});
const qmul=(U,V)=>({A:plus(mm(U.A,V.A),scale(mm(U.B,V.B),c(2))),B:plus(mm(U.A,V.B),mm(U.B,V.A))});
const qadj=U=>({A:adj(U.A),B:adj(U.B)});
const qeq=(U,V,message)=>{eq(U.A,V.A,message);eq(U.B,V.B,message);};
const tensor=(U,I)=>({A:kron(U.A,I),B:kron(U.B,I)});
const act=(U,rho)=>qmul(qmul(U,rho),qadj(U));
function unitary(U){qeq(qmul(qadj(U),U),lift(eye(U.A.length)));qeq(qmul(U,qadj(U)),lift(eye(U.A.length)));}
function access(){return {kind:'declared-full-exchange-code-exit-access',native:F.access(),controlledH:'phase-fixed I on control-zero and H on control-one',
  windows:'exact native exit, optional native data control and inverse re-entry; no unknown-background guarantee inside these windows',physicalAdmission:null};}
function validateAccess(a){assert.equal(key(a),key(access()),'full-code exit requires its declared coherent native access');}
function gate(g,available){validateAccess(available);
  if(g.kind!=='phase-fixed-controlled-H'){const p=F.gate(g,available.native);return p.denominatorSquared===1?lift(p.N):{A:mat(16),B:scale(p.N,c(1,0,2))};}
  assert.deepEqual(Object.keys(g).sort(),['control','kind','target']);assert(Number.isSafeInteger(g.target)&&g.target>=0&&g.target<4);
  assert(Number.isSafeInteger(g.control)&&g.control>=0&&g.control<4&&g.target!==g.control);
  const A=mat(16),B=mat(16),mask=1<<(3-g.target);for(let x=0;x<16;x++){
    if(!((x>>(3-g.control))&1)){A[x][x]=one;continue;}
    B[x&~mask][x]=c(1,0,2);B[x|mask][x]=(x&mask)?c(-1,0,2):c(1,0,2);}
  const U={A,B};unitary(U);return U;
}
function program(gates,available){let U=lift(eye(16));for(const g of gates)U=qmul(gate(g,available),U);unitary(U);return U;}
function permutation(){const p=Array(16).fill(null);[8,10,14,4,5,13].forEach((s,i)=>p[s]=[0,1,4,2,3,6][i]);
  const missing=Array.from({length:16},(_,i)=>i).filter(i=>!p.includes(i));for(let i=0;i<16;i++)if(p[i]===null)p[i]=missing.shift();return p;}
function outputSupport(){const P=mat(16);[0,1,2,3,4,6].forEach(i=>P[i][i]=one);return P;}
function construct(model,available=access()){F.exchangeCode(model);validateAccess(available);counters.constructions++;
  const pair=(a,b)=>[{kind:'phase-fixed-bit-flip',target:b,controls:[{bit:a,value:1}]},{kind:'phase-fixed-controlled-H',target:a,control:b},{kind:'phase-fixed-bit-flip',target:b,controls:[{bit:a,value:1}]}];
  const p=permutation(),gates=[...pair(0,3),...pair(1,2),...F.lowerPermutation(p),{kind:'phase-fixed-H',target:2}];
  const certificate={kind:'full-protected-code-native-exit',source:model.source,available:structuredClone(available),gates,permutation:p,
    operator:program(gates,available),input:F.exchangeCode(model).support,output:outputSupport(),physicalAdmission:null};verify(model,available,certificate);return certificate;}
function verify(model,available,p){const d=F.exchangeCode(model);validateAccess(available);assert.equal(p.kind,'full-protected-code-native-exit');
  assert.equal(key(p.source),key(model.source));assert.equal(key(p.available),key(available));assert.equal(p.physicalAdmission,null);assert.equal(key(p.permutation),key(permutation()));
  const U=program(p.gates,available);qeq(U,p.operator);eq(p.input,d.support);eq(p.output,outputSupport());
  const A=qmul(U,lift(d.support));qeq(qmul(lift(p.output),A),A);qeq(act(U,lift(d.support)),lift(p.output));
  d.readings.forEach((L,i)=>qeq(qmul(lift(d.native[i].operator),A),qmul(A,lift(L.operator)),'exit must cover the entire code, including its third gauge level'));
  return {...d,U,output:p.output,scope:'unitary exit and inverse re-entry for all code/reference/gauge inputs',physicalAdmission:null};}
function protectedState(model,rho,e,r){const d=F.exchangeCode(model),P=lift(kron(d.support,eye(e*r)));qeq(qmul(qmul(P,rho),P),rho);}
function background(model,W,e){const d=F.exchangeCode(model);assert(W.length===16*e&&W.every(row=>row.length===16*e));eq(mm(adj(W),W),eye(16*e));
  [d.support,...d.readings.map(q=>q.operator),...Object.values(model.operators)].forEach(O=>assert(isZero(comm(W,kron(O,eye(e))))));}
function reduceNative(A,e,r){const tail=e*r,out=mat(2*tail);for(let a=0;a<16;a++)for(let b=0;b<16;b++)if((a&13)===(b&13)){
    const qa=(a>>1)&1,qb=(b>>1)&1;for(let i=0;i<tail;i++)for(let j=0;j<tail;j++)out[qa*tail+i][qb*tail+j]=E.add(out[qa*tail+i][qb*tail+j],A[a*tail+i][b*tail+j]);}return out;}
const owned=new WeakMap();
class ContinuingBoundary {
  constructor(model,rho,environmentDimension=1,referenceDimension=1){const source=new F.EncodedBoundary(model,rho,environmentDimension,referenceDimension);
    owned.set(this,{model,source,rho:null,e:environmentDimension,r:referenceDimension,phase:'initial',steps:0,exits:0,reentries:0});}
  enter(available,certificate){const s=owned.get(this);assert.equal(s.phase,'initial');s.source.encode(available,certificate);s.rho=lift(s.source.snapshot().rho);s.source=null;s.phase='protected';return this;}
  continue(signs,certificate,episodes){const s=owned.get(this);assert.equal(s.phase,'protected');protectedState(s.model,s.rho,s.e,s.r);
    const v=F.verifyNext(s.model,signs,certificate);assert.equal(episodes.length,Math.max(1,v.word.length));episodes.forEach(W=>background(s.model,W,s.e));
    let U=eye(16*s.e);for(let i=0;i<episodes.length;i++){const control=v.word[i]?scale(s.model.operators[v.word[i]],c(0,-1)):s.model.I;U=mm(mm(episodes[i],kron(control,eye(s.e))),U);}
    const rho=act(lift(kron(U,eye(s.r))),s.rho);protectedState(s.model,rho,s.e,s.r);s.rho=rho;s.steps++;return this;}
  exit(available,certificate){const s=owned.get(this);assert.equal(s.phase,'protected');protectedState(s.model,s.rho,s.e,s.r);const v=verify(s.model,available,certificate);
    const rho=act(tensor(v.U,eye(s.e*s.r)),s.rho);const P=lift(kron(v.output,eye(s.e*s.r)));qeq(qmul(qmul(P,rho),P),rho);
    s.rho=rho;s.phase='native';s.exitCertificate=structuredClone(certificate);s.exits++;return this;}
  nativeControl(g,available){const s=owned.get(this);assert.equal(s.phase,'native');validateAccess(available);assert.equal(g.target,2,'only the declared native data interface is addressed');
    assert(g.kind==='phase-fixed-H'||(g.kind==='phase-fixed-bit-flip'&&g.controls.length===0));
    const U=tensor(gate(g,available),eye(s.e*s.r)),P=lift(kron(outputSupport(),eye(s.e*s.r)));qeq(qmul(U,P),qmul(P,U));s.rho=act(U,s.rho);return this;}
  reenter(available,certificate){const s=owned.get(this);assert.equal(s.phase,'native');assert.equal(key(certificate),key(s.exitCertificate),'re-entry must address the actual exit frame');
    const v=verify(s.model,available,certificate),P=lift(kron(v.output,eye(s.e*s.r)));qeq(qmul(qmul(P,s.rho),P),s.rho);
    const rho=act(tensor(qadj(v.U),eye(s.e*s.r)),s.rho);protectedState(s.model,rho,s.e,s.r);s.rho=rho;s.phase='protected';s.reentries++;return this;}
  read(name,reference){const s=owned.get(this);if(s.phase==='initial')return {a:s.source.read(name,reference),b:z};
    const d=F.exchangeCode(s.model),q=(s.phase==='native'?d.native:d.readings).find(q=>q.name===name);assert(q);reference??=eye(s.r);
    assert(reference.length===s.r&&reference.every(row=>row.length===s.r));eq(adj(reference),reference);const O=kron(q.operator,kron(eye(s.e),reference));return {a:tr(mm(s.rho.A,O)),b:tr(mm(s.rho.B,O))};}
  nativeState(){const s=owned.get(this);assert.equal(s.phase,'native');return {A:reduceNative(s.rho.A,s.e,s.r),B:reduceNative(s.rho.B,s.e,s.r)};}
  snapshot(){const s=owned.get(this);return {rho:s.rho?structuredClone(s.rho):lift(s.source.snapshot().rho),phase:s.phase,steps:s.steps,exits:s.exits,reentries:s.reentries,physicalAdmission:null};}
}
if(require.main===module){const b=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=M.currentModel();const v=verify(m,b.available,b.exit);
  const entry=F.verify(m,b.entryAvailable,b.entry);b.next.forEach(x=>F.verifyNext(m,x.signs,x.certificate));
  const fixedExchangeH=M.verify(m,b.entryAvailable.exchange,b.hRequirement,b.hObstruction);assert.equal(fixedExchangeH,null);
  console.log(R.serialize({exitContacts:b.exit.gates.length,fullCodeRank:tr(v.support),nativeBoundaryRank:tr(v.output),entryRank:tr(entry.input),constructionCalls:counters,
    entryConstructionCalls:F.counters,exchangeConstructionCalls:M.counters,fixedExchangeHadamard:false,physicalAdmission:null}));}
module.exports={access,gate,program,permutation,construct,verify,ContinuingBoundary,reduceNative,lift,qmul,qadj,qeq,tensor,act,unitary,counters,exact:E};
