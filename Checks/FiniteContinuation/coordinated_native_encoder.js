"use strict";
// Explicit phase-bound native contacts enter a protected exchange boundary.
// No measurement/reset, no free encoder primitive, no assumed encoding-noise immunity.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_protected_acquisition.js'),Q=require('./coordinated_question_bounds.js');
const E=C.exact,{c,z,one,ii,add,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=E;
const key=C.json,counters={constructions:0};
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],Hn=[[one,one],[one,c(-1)]];
function touch(m){M.proveMovingProtection(m,[]);}
function site(A,i){assert(Number.isSafeInteger(i)&&i>=0&&i<4);return [0,1,2,3].map(j=>j===i?A:I2).reduce(kron);}
function flip(target,controls=[]){return {kind:'phase-fixed-bit-flip',target,controls};}
function hadamard(target){return {kind:'phase-fixed-H',target};}
function access(){return {kind:'declared-native-encoding-access',native:{H:'(X+Z)/sqrt(2)',bitFlip:'exact controlled-X with specified zero/one controls',maximumControls:3},
  encodingEpisode:'exact ordered native contacts on the admitted input; no unknown-background guarantee during encoding',
  exchange:M.access(['P','Q','T']),physicalAdmission:null};}
function gate(g,available){assert.equal(key(available),key(access()),'native contact access is a separate explicit premise');
  assert(Number.isSafeInteger(g.target)&&g.target>=0&&g.target<4);
  if(g.kind==='phase-fixed-H'){assert.deepEqual(Object.keys(g).sort(),['kind','target']);return {N:site(Hn,g.target),denominatorSquared:2};}
  assert.equal(g.kind,'phase-fixed-bit-flip');assert.deepEqual(Object.keys(g).sort(),['controls','kind','target']);
  assert(g.controls.length<=available.native.maximumControls);assert.equal(new Set(g.controls.map(k=>k.bit)).size,g.controls.length);
  g.controls.forEach(k=>{assert(Number.isSafeInteger(k.bit)&&k.bit>=0&&k.bit<4&&k.bit!==g.target);assert([0,1].includes(k.value));assert.deepEqual(Object.keys(k).sort(),['bit','value']);});
  const N=mat(16);for(let x=0;x<16;x++){const enabled=g.controls.every(k=>((x>>(3-k.bit))&1)===k.value);N[enabled?x^(1<<(3-g.target)):x][x]=one;}
  return {N,denominatorSquared:1};}
function program(gates,available){let N=eye(16),denominatorSquared=1;for(const g of gates){const p=gate(g,available);N=mm(p.N,N);denominatorSquared*=p.denominatorSquared;assert(Number.isSafeInteger(denominatorSquared));}
  eq(mm(adj(N),N),scale(eye(16),c(denominatorSquared)));return {N,denominatorSquared};}
function exchangeCode(model){touch(model);const {P,Q:XL,T}=model.operators,ZL=mm(P,T),half=mm(XL,ZL),K=mm(half,half);
  eq(mm(K,K),model.I);eq(adj(K),K);const support=scale(minus(model.I,K),c(1,0,2)),input=scale(minus(model.I,P),c(1,0,2));
  eq(mm(support,support),support);eq(mm(input,input),input);assert.deepEqual(tr(support),c(6));assert.deepEqual(tr(input),c(4));
  const readings=[{name:'X',operator:mm(support,XL)},{name:'Y',operator:scale(mm(support,half),ii)},{name:'Z',operator:mm(support,ZL)}];
  readings.forEach(q=>{eq(adj(q.operator),q.operator);eq(mm(q.operator,q.operator),support);});eq(plus(mm(readings[0].operator,readings[2].operator),mm(readings[2].operator,readings[0].operator)),mat(16));
  const collective=F.collective(model,4);for(const J of collective.J){assert(isZero(comm(J,support)));readings.forEach(q=>assert(isZero(comm(J,q.operator))));
    Object.values(model.operators).forEach(S=>assert(isZero(comm(J,S))));}
  const J2=collective.J.map(J=>mm(J,J)).reduce(plus);eq(mm(J2,support),scale(support,c(8)));
  return {support,input,K,readings,native:[X,Y,Z].map((O,i)=>({name:['X','Y','Z'][i],operator:site(O,2)})),J:collective.J};}
function basisPermutation(){const p=Array(16).fill(null);for(let j=0;j<4;j++)for(let b=0;b<2;b++)p[2*j+b]=b?15^(1<<j):1<<j;
  const remaining=Array.from({length:16},(_,i)=>i).filter(i=>!p.includes(i));for(let i=8;i<16;i++)p[i]=remaining.shift();return p;}
function adjacentSwap(a,b){const delta=a^b;assert(delta>0&&(delta&(delta-1))===0);const target=3-Math.log2(delta);
  return flip(target,[0,1,2,3].filter(i=>i!==target).map(bit=>({bit,value:(a>>(3-bit))&1})));}
function transposition(a,b){assert(a!==b);const vertices=[a];let x=a;for(let bit=0;bit<4;bit++)if(((x^b)>>(3-bit))&1){x^=1<<(3-bit);vertices.push(x);}assert.equal(x,b);
  const forward=vertices.slice(1).map((v,i)=>adjacentSwap(vertices[i],v));return [...forward,...forward.slice(0,-1).reverse()];}
function lowerPermutation(p){assert.deepEqual([...p].sort((a,b)=>a-b),Array.from({length:16},(_,i)=>i));
  let current=Array.from({length:16},(_,i)=>i),gates=[];for(let i=0;i<16;i++)if(current[i]!==p[i]){const a=current[i],b=p[i];gates.push(...transposition(a,b));current=current.map(x=>x===a?b:x===b?a:x);}assert.deepEqual(current,p);return gates;}
function construct(model,available=access()){touch(model);assert.equal(key(available),key(access()));counters.constructions++;
  const prefix=[flip(1,[{bit:0,value:1}]),hadamard(0),flip(0),flip(1),flip(1,[{bit:2,value:1}]),flip(1),hadamard(1),hadamard(2)];
  const permutation=basisPermutation(),gates=[...prefix,...lowerPermutation(permutation)],p=program(gates,available),d=exchangeCode(model);
  const certificate={kind:'native-spin-to-exchange-encoding',source:model.source,available:structuredClone(available),gates,permutation,
    numerator:p.N,denominatorSquared:p.denominatorSquared,input:d.input,output:d.support,readings:d.readings,physicalAdmission:null};
  verify(model,available,certificate);return certificate;}
function verify(model,available,p){touch(model);assert.equal(key(available),key(access()));assert.equal(p.kind,'native-spin-to-exchange-encoding');assert.equal(key(p.source),key(model.source));
  assert.equal(key(p.available),key(available));assert.equal(p.physicalAdmission,null);assert.equal(key(p.permutation),key(basisPermutation()));
  const q=program(p.gates,available),d=exchangeCode(model);eq(q.N,p.numerator);assert.equal(q.denominatorSquared,p.denominatorSquared);
  eq(p.input,d.input);eq(p.output,d.support);assert.equal(key(p.readings),key(d.readings));
  const A=mm(q.N,d.input);eq(mm(d.support,A),A);d.readings.forEach((O,i)=>eq(mm(O.operator,A),mm(A,d.native[i].operator),'the same unknown native input must enter the code'));
  return {...d,...q,scope:'unitary entry from singlet12 tensor arbitrary joint 3/4/reference; three native Pauli readings preserved',physicalAdmission:null};}
function requirement(model,signs){const d=exchangeCode(model);assert(signs.length===3&&signs.every(s=>s===1||s===-1));
  return {input:d.support,relations:[{after:d.support,before:d.support},...d.readings.map((q,i)=>({after:q.operator,before:scale(q.operator,c(signs[i]))}))]};}
function compileNext(model,signs){return M.construct(model,access().exchange,requirement(model,signs));}
function verifyNext(model,signs,certificate){const result=M.verify(model,access().exchange,requirement(model,signs),certificate);assert(result,'requested exchange continuation is unavailable');return result;}
function validateBackground(model,W,e){const d=exchangeCode(model);assert(W.length===16*e&&W.every(row=>row.length===16*e));eq(mm(adj(W),W),eye(16*e));
  for(const O of [d.support,...d.readings.map(q=>q.operator),...Object.values(model.operators)])assert(isZero(comm(W,kron(O,eye(e)))),'joint episode lacks the preserved exchange relations');}
const states=new WeakMap();
class EncodedBoundary {
  constructor(model,rho,environmentDimension=1,referenceDimension=1){const d=exchangeCode(model);assert(Number.isSafeInteger(environmentDimension)&&environmentDimension>0&&Number.isSafeInteger(referenceDimension)&&referenceDimension>0);
    const n=16*environmentDimension*referenceDimension;assert(rho.length===n&&rho.every(row=>row.length===n));Q.verifyFactor(rho,Q.factorOrWitness(rho));assert.deepEqual(tr(rho),one);
    const support=kron(d.input,eye(environmentDimension*referenceDimension));eq(mm(mm(support,rho),support),rho);
    states.set(this,{model,rho:structuredClone(rho),environmentDimension,referenceDimension,phase:'native',steps:0});}
  encode(available,certificate){const s=states.get(this);assert.equal(s.phase,'native');const p=verify(s.model,available,certificate),N=kron(p.N,eye(s.environmentDimension*s.referenceDimension));
    s.rho=scale(mm(mm(N,s.rho),adj(N)),c(1,0,p.denominatorSquared));s.phase='protected';return this;}
  continue(signs,certificate,backgrounds){const s=states.get(this);assert.equal(s.phase,'protected');const next=verifyNext(s.model,signs,certificate);
    assert.equal(backgrounds.length,Math.max(1,next.word.length));backgrounds.forEach(W=>validateBackground(s.model,W,s.environmentDimension));
    let U=eye(16*s.environmentDimension);for(let i=0;i<backgrounds.length;i++){const control=next.word[i]?scale(s.model.operators[next.word[i]],c(0,-1)):s.model.I;
      U=mm(mm(backgrounds[i],kron(control,eye(s.environmentDimension))),U);}const full=kron(U,eye(s.referenceDimension));s.rho=mm(mm(full,s.rho),adj(full));s.steps++;return this;}
  read(name,reference){const s=states.get(this),d=exchangeCode(s.model),q=(s.phase==='native'?d.native:d.readings).find(q=>q.name===name);assert(q);
    reference??=eye(s.referenceDimension);assert(reference.length===s.referenceDimension&&reference.every(row=>row.length===s.referenceDimension));eq(adj(reference),reference);
    return tr(mm(s.rho,kron(q.operator,kron(eye(s.environmentDimension),reference))));}
  snapshot(){const s=states.get(this);return {rho:structuredClone(s.rho),phase:s.phase,steps:s.steps,physicalAdmission:null};}
}
if(require.main===module){const b=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=M.currentModel(),v=verify(m,b.available,b.encoder);
  const continuations=b.next.map(n=>verifyNext(m,n.signs,n.certificate));console.log(R.serialize({encoderContacts:b.encoder.gates.length,denominatorSquared:v.denominatorSquared,
    inputRank:tr(v.input),codeRank:tr(v.support),nextSections:continuations.map(c=>c.minimumSections),constructionCalls:counters,movingConstructionCalls:M.counters,physicalAdmission:null}));}
module.exports={access,gate,program,exchangeCode,basisPermutation,lowerPermutation,construct,verify,requirement,compileNext,verifyNext,EncodedBoundary,counters,exact:E};
