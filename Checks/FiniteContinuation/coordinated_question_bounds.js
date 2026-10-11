"use strict";
// Exact question-specific bounds for complete instruments and retained context.
// No independence, hardware calibration, or diamond-norm guarantee is inferred.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),T=require('./coordinated_instrument_transport.js');
const E=C.exact,{c,z,one,nz,add,sub,mul,div,conj,mat,eye,scale,plus,minus,adj,mm,tr,eq,isZero}=E;
const key=C.json,counters={factorizations:0,constructions:0,chainConstructions:0};
function touch(m){C.verifyPlan(m,{targetScore:[],inputProjector:m.Pi,requiredInteriorCuts:[]},C.accessModel([]),
  {rule:'retain-source-score',source:m.source,score:[]});}
function real(x){assert(Array.isArray(x)&&x.length===3&&x.every(v=>typeof v==='bigint'));assert.deepEqual(x,c(...x));assert.equal(x[1],0n);return x;}
const compare=(a,b)=>{real(a);real(b);return a[0]*b[2]-b[0]*a[2];};
function epsilon(x){real(x);assert(x[0]>=0n);}
function square(A,n){assert(Array.isArray(A)&&A.length===n&&A.every(row=>Array.isArray(row)&&row.length===n));
  for(const row of A)for(const x of row){assert(Array.isArray(x)&&x.length===3&&x.every(v=>typeof v==='bigint'));assert.deepEqual(x,c(...x));}}
function hermitian(A,n=A.length){square(A,n);eq(adj(A),A);}
function support(P,n=P.length){hermitian(P,n);eq(mm(P,P),P);assert(!isZero(P));}
function quadratic(v,A){return mm(mm(adj(v),A),v)[0][0];}
function backSubstitute(L,v){const U=adj(L),x=mat(L.length,1);for(let i=L.length-1;i>=0;i--){
  let b=v[i][0];for(let j=i+1;j<L.length;j++)b=sub(b,mul(U[i][j],x[j][0]));x[i][0]=div(b,U[i][i]);}return x;}
function factorOrWitness(M){counters.factorizations++;hermitian(M);const n=M.length,B=M.map(row=>row.slice()),L=eye(n),weights=Array(n).fill(z);
  for(let k=0;k<n;k++){
    const p=B[k][k];real(p);
    if(p[0]<0n){const v=mat(n,1);v[k][0]=one;return {kind:'negative-vector',vector:backSubstitute(L,v)};}
    if(!nz(p)){
      const j=B[k].findIndex((x,j)=>j>k&&nz(x));if(j>=0){
        const q=B[j][j];real(q);const norm=mul(B[k][j],conj(B[k][j]));
        const amount=div(add(c(q[0]<0n?-q[0]:q[0],0,q[2]),one),mul(c(2),norm));
        const v=mat(n,1);v[j][0]=one;v[k][0]=mul(c(-1),mul(amount,B[k][j]));
        return {kind:'negative-vector',vector:backSubstitute(L,v)};
      }continue;
    }
    weights[k]=p;for(let i=k+1;i<n;i++)L[i][k]=div(B[i][k],p);
    for(let i=k+1;i<n;i++)for(let j=k+1;j<n;j++)B[i][j]=sub(B[i][j],div(mul(B[i][k],B[k][j]),p));
  }
  const result={kind:'positive-weighted-factor',vectors:L,weights};verifyFactor(M,result);return result;
}
function verifyFactor(M,certificate){assert.equal(certificate.kind,'positive-weighted-factor');const n=M.length;
  square(certificate.vectors,n);assert.equal(certificate.weights.length,n);const D=mat(n);
  certificate.weights.forEach((w,i)=>{epsilon(w);D[i][i]=w;});eq(mm(mm(certificate.vectors,D),adj(certificate.vectors)),M,'positive factor does not equal the required bound matrix');}
function envelope(P,D,eps){support(P);hermitian(D,P.length);eq(mm(mm(P,D),P),D);epsilon(eps);
  const matrices=[plus(scale(P,eps),D),minus(scale(P,eps),D)],factors=[];
  for(let i=0;i<2;i++){
    const factor=factorOrWitness(matrices[i]);if(factor.kind==='negative-vector'){
      const v=mm(P,factor.vector),norm=quadratic(v,eye(P.length));assert(compare(norm,z)>0n);
      assert(compare(quadratic(v,matrices[i]),z)<0n);
      return {kind:'question-bound-obstruction',side:i,vector:v};}
    factors.push(factor);
  }
  return {kind:'question-bound-envelope',factors};
}
function verifyEnvelope(P,D,eps,certificate){support(P);hermitian(D,P.length);eq(mm(mm(P,D),P),D);epsilon(eps);
  const matrices=[plus(scale(P,eps),D),minus(scale(P,eps),D)];
  if(certificate.kind==='question-bound-obstruction'){
    assert([0,1].includes(certificate.side));const v=certificate.vector;assert(v.length===P.length&&v.every(row=>row.length===1));
    eq(mm(P,v),v);const norm=quadratic(v,eye(P.length));assert(compare(norm,z)>0n);
    assert(compare(quadratic(v,matrices[certificate.side]),z)<0n,'purported input does not refute the bound');
    const value=div(quadratic(v,D),norm);assert(compare(c(value[0]<0n?-value[0]:value[0],0,value[2]),eps)>0n);
    return {admitted:false,defect:value,rho:scale(mm(v,adj(v)),div(one,norm))};
  }
  assert.equal(certificate.kind,'question-bound-envelope');assert.equal(certificate.factors.length,2);
  certificate.factors.forEach((f,i)=>verifyFactor(matrices[i],f));return {admitted:true,error:eps};
}
function instrumentDefect(spec){assert.equal(spec.kind,'recorded-question-bound');const {support:P,before,instrument,after}=spec;
  support(P);hermitian(before,P.length);eq(mm(mm(P,before),P),before);
  const frame={kind:'declared-generated-star-algebra',support:P,readings:[{name:'before',operator:before}]};T.validateInstrument(frame,instrument);
  assert.equal(after.length,instrument.outcomes.length);assert.equal(new Set(after.map(x=>x.label)).size,after.length);
  let pulled=mat(P.length);
  for(const {label,kraus}of instrument.outcomes){const found=after.find(q=>q.label===label);assert(found,'a real outcome lacks its following question');hermitian(found.operator,kraus[0].length);
    for(const K of kraus)pulled=plus(pulled,mm(mm(adj(K),found.operator),K));}
  return minus(mm(mm(P,pulled),P),before);
}
function construct(m,spec,eps){touch(m);counters.constructions++;const D=instrumentDefect(spec);
  const out={kind:'recorded-question-certificate',source:m.source,spec:structuredClone(spec),epsilon:eps,envelope:envelope(spec.support,D,eps),physicalAdmission:null};
  verify(m,spec,eps,out);return out;
}
function verify(m,spec,eps,certificate){touch(m);assert.equal(certificate.kind,'recorded-question-certificate');assert.equal(key(certificate.source),key(m.source));
  assert.equal(key(certificate.spec),key(spec));assert.deepEqual(certificate.epsilon,eps);assert.equal(certificate.physicalAdmission,null);
  return {...verifyEnvelope(spec.support,instrumentDefect(spec),eps,certificate.envelope),physicalAdmission:null};
}
function channel(kraus){assert(Array.isArray(kraus)&&kraus.length>0);const n=kraus[0][0].length,d=kraus[0].length;
  return {inputDimension:n,outputDimension:d,kraus};}
function validateChannel(ch){assert(Number.isSafeInteger(ch.inputDimension)&&ch.inputDimension>0&&Number.isSafeInteger(ch.outputDimension)&&ch.outputDimension>0);
  const frame={kind:'declared-generated-star-algebra',support:eye(ch.inputDimension),readings:[{name:'unit',operator:eye(ch.inputDimension)}]};
  T.validateInstrument(frame,{kind:'declared-recorded-instrument',inputDimension:ch.inputDimension,outcomes:[{label:'full',kraus:ch.kraus}]});
  ch.kraus.forEach(K=>assert.equal(K.length,ch.outputDimension));}
function pull(ch,O){hermitian(O,ch.outputDimension);return ch.kraus.reduce((sum,K)=>plus(sum,mm(mm(adj(K),O),K)),mat(ch.inputDimension));}
function recordedChannel(instrument,after){
  const n=instrument.inputDimension,offsets=[];let d=0;for(const out of instrument.outcomes){offsets.push(d);d+=out.kraus[0].length;}
  const kraus=[];const question=mat(d);assert.equal(after.length,instrument.outcomes.length);
  assert.equal(new Set(after.map(x=>x.label)).size,after.length);
  instrument.outcomes.forEach((out,a)=>{const row=offsets[a],size=out.kraus[0].length,O=after.find(x=>x.label===out.label)?.operator;hermitian(O,size);
    for(let i=0;i<size;i++)for(let j=0;j<size;j++)question[row+i][row+j]=O[i][j];
    out.kraus.forEach(K=>{const embedded=mat(d,n);for(let i=0;i<size;i++)for(let j=0;j<n;j++)embedded[row+i][j]=K[i][j];kraus.push(embedded);});});
  return {channel:channel(kraus),question};
}
function chainData(spec){assert.equal(spec.kind,'retained-process-question-bound');assert(spec.stages.length>0);assert.equal(spec.supports.length,spec.stages.length+1);
  spec.supports.forEach(P=>support(P));
  spec.stages.forEach(({actual,ideal},i)=>{validateChannel(actual);validateChannel(ideal);
    assert.equal(actual.inputDimension,spec.supports[i].length);assert.equal(actual.outputDimension,spec.supports[i+1].length);
    assert.equal(actual.inputDimension,ideal.inputDimension);assert.equal(actual.outputDimension,ideal.outputDimension);
    for(const K of actual.kraus)eq(mm(mm(minus(eye(actual.outputDimension),spec.supports[i+1]),K),spec.supports[i]),mat(actual.outputDimension,actual.inputDimension),
      'the ACTUAL episode can leave the claimed next support');});
  const count=spec.stages.length;hermitian(spec.finalQuestion,spec.supports[count].length);
  const questions=Array(count+1);questions[count]=spec.finalQuestion;
  for(let i=count-1;i>=0;i--)questions[i]=pull(spec.stages[i].ideal,questions[i+1]);
  const defects=spec.stages.map(({actual},i)=>mm(mm(spec.supports[i],minus(pull(actual,questions[i+1]),questions[i])),spec.supports[i]));
  let actualQuestion=spec.finalQuestion;for(let i=count-1;i>=0;i--)actualQuestion=pull(spec.stages[i].actual,actualQuestion);
  const whole=mm(mm(spec.supports[0],minus(actualQuestion,questions[0])),spec.supports[0]);
  return {questions,defects,whole};
}
function constructChain(m,spec,epsilons,wholeEpsilon=null){touch(m);counters.chainConstructions++;const data=chainData(spec);
  assert.equal(epsilons.length,spec.stages.length);epsilons.forEach(epsilon);if(wholeEpsilon!==null)epsilon(wholeEpsilon);
  const out={kind:'retained-process-question-certificate',source:m.source,spec:structuredClone(spec),epsilons:structuredClone(epsilons),
    envelopes:data.defects.map((D,i)=>envelope(spec.supports[i],D,epsilons[i])),wholeEpsilon,
    wholeEnvelope:wholeEpsilon===null?null:envelope(spec.supports[0],data.whole,wholeEpsilon),physicalAdmission:null};
  verifyChain(m,spec,epsilons,wholeEpsilon,out);return out;
}
function verifyChain(m,spec,epsilons,wholeEpsilon,certificate){touch(m);assert.equal(certificate.kind,'retained-process-question-certificate');
  assert.equal(key(certificate.source),key(m.source));assert.equal(key(certificate.spec),key(spec));assert.deepEqual(certificate.epsilons,epsilons);
  assert.deepEqual(certificate.wholeEpsilon,wholeEpsilon);assert.equal(certificate.physicalAdmission,null);const data=chainData(spec);
  assert.equal(epsilons.length,data.defects.length);assert.equal(certificate.envelopes.length,epsilons.length);epsilons.forEach(epsilon);
  const steps=data.defects.map((D,i)=>verifyEnvelope(spec.supports[i],D,epsilons[i],certificate.envelopes[i]));
  const bad=steps.findIndex(s=>!s.admitted);if(bad>=0)return {admitted:false,scope:'the proposed uniform local bound on this declared actual support',step:bad,...steps[bad],physicalAdmission:null};
  const sum=epsilons.reduce(add,z);let whole=null;
  if(wholeEpsilon!==null){whole=verifyEnvelope(spec.supports[0],data.whole,wholeEpsilon,certificate.wholeEnvelope);
    if(!whole.admitted)return {admitted:false,scope:'the complete declared process on its admitted initial input',step:'whole',...whole,physicalAdmission:null};
  }else assert.equal(certificate.wholeEnvelope,null);
  return {admitted:true,telescopingError:sum,directError:whole?.error??null,
    error:whole&&compare(whole.error,sum)<0n?whole.error:sum,physicalAdmission:null};
}
if(require.main===module){const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=C.currentModel();const results=bundle.map(b=>b.spec.kind==='recorded-question-bound'?
  verify(m,b.spec,b.epsilon,b.certificate):verifyChain(m,b.spec,b.epsilons,b.wholeEpsilon,b.certificate));
  console.log(R.serialize({results:results.map(r=>({admitted:r.admitted,error:r.error??null,scope:r.scope??null})),constructionCalls:counters,physicalAdmission:null}));}
module.exports={construct,verify,constructChain,verifyChain,instrumentDefect,chainData,channel,pull,recordedChannel,factorOrWitness,verifyFactor,compare,counters,exact:E};
