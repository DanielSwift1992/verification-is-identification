"use strict";
// Explicit model access for acquiring a projective question. No measurement is
// inserted unless independently requested; its complete instrument is checked.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const E=C.exact,{c,z,one,ii,nz,add,sub,mul,div,conj,mat,eye,scale,plus,minus,adj,mm,comm,tr,eq,isZero,kron}=E;
const key=C.json,counters={constructions:0};
const conjugate=A=>A.map(row=>row.map(conj));
function touch(model){C.verifyPlan(model,{targetScore:[],inputProjector:model.Pi,requiredInteriorCuts:[]},C.accessModel([]),{rule:'retain-source-score',source:model.source,score:[]});}
function validateRequest(model,request){assert.equal(request.kind,'projective-acquisition');assert(['input','transported'].includes(request.returnFrame));
  const O=request.question,S=model.Pi;eq(adj(O),O);eq(mm(mm(S,O),S),O);eq(mm(O,O),S);
  return [scale(plus(S,O),c(1,0,2)),scale(minus(S,O),c(1,0,2))];}
function instantiate(model,access){touch(model);assert.equal(access.kind,'declared-source-acquisition-access');
  const controls=[];for(const coeff of access.quarterDirections){assert([[1,0],[0,1],[1,1]].some(x=>key(x)===key(coeff)));
    controls.push({name:`quarter:${coeff.join(',')}`,operator:C.sectionOperator(model,{coeff,quarters:1})});}
  for(const [a,b,d]of access.partialP){assert([a,b,d].every(Number.isSafeInteger)&&d>0&&a*a+b*b===d*d);
    controls.push({name:`partialP:${a},${b},${d}`,operator:plus(scale(model.I,c(a,0,d)),scale(model.P,c(0,-b,d)))});}
  assert.equal(new Set(controls.map(x=>x.name)).size,controls.length);assert.equal(new Set(access.readouts).size,access.readouts.length);
  const readouts=access.readouts.map(name=>{assert(['P','Q'].includes(name));return {name,operators:[0,1].map(a=>scale(plus(model.I,scale(model[name],c(a?-1:1))),c(1,0,2)))};});
  for(const {operator:U}of controls){eq(mm(adj(U),U),model.I);eq(comm(U,model.Pi),mat(model.I.length));}
  return {controls,readouts};
}
function operations(model,access,program){const available=instantiate(model,access),get=name=>{
  if(name===null)return model.I;const p=available.controls.find(p=>p.name===name);assert(p,'undeclared coherent contact');return p.operator;};
  if(program.readout===null){assert(program.pre===null&&program.post===null);assert([0,1].includes(program.constant));
    return {operators:[0,1].map(a=>a===program.constant?model.Pi:mat(model.I.length)),frame:model.I,readings:0,controls:0};}
  assert.deepEqual([...program.decoder].sort(),[0,1]);const read=available.readouts.find(p=>p.name===program.readout);assert(read,'undeclared readout');
  const pre=get(program.pre),post=get(program.post),operators=[null,null];
  read.operators.forEach((K,a)=>operators[program.decoder[a]]=mm(mm(mm(post,K),pre),model.Pi));
  return {operators,frame:pre,readings:1,controls:Number(program.pre!==null)+Number(program.post!==null)};
}
function proportional(A,B){const index=B.flat().findIndex(nz);if(index<0){eq(A,mat(B.length,B[0].length));return z;}
  const i=Math.floor(index/B[0].length),j=index%B[0].length,lambda=div(A[i][j],B[i][j]);eq(A,scale(B,lambda));return lambda;}
function sameBranch(A,B){if(isZero(B)){eq(A,mat(B.length));return;}
  const lambda=proportional(A,B);assert.deepEqual(mul(lambda,conj(lambda)),one,'branch has the wrong quantum operation');}
function realWitness(A){const i=A.flat().findIndex(nz);if(i<0)return {pivot:null};const pivot=[Math.floor(i/A[0].length),i%A[0].length],a=A[pivot[0]][pivot[1]];
  if(A.some(row=>row.some(x=>div(x,a)[1]!==0n)))return null;return {pivot};}
function realPrimitives(model,access){const parts=instantiate(model,access);return [
  ...parts.controls.map(p=>({name:p.name,operator:mm(p.operator,model.Pi)})),
  ...parts.readouts.flatMap(p=>p.operators.map((K,a)=>({name:`read:${p.name}:${a}`,operator:mm(K,model.Pi)})))];}
function verifyRealPrimitive(A,w){if(w.pivot===null){assert(isZero(A));return;}
  const [i,j]=w.pivot;assert(Number.isSafeInteger(i)&&Number.isSafeInteger(j)&&i>=0&&i<A.length&&j>=0&&j<A[0].length);const pivot=A[i][j];assert(nz(pivot));
  for(const row of A)for(const x of row)assert.equal(div(x,pivot)[1],0n,'primitive breaks the claimed antiunitary symmetry');}
function impossibility(model,request,access){const primitives=realPrimitives(model,access),witnesses=primitives.map(p=>realWitness(p.operator));
  if(witnesses.some(w=>w===null)||isZero(minus(request.question,conjugate(request.question))))return null;
  eq(conjugate(model.Pi),model.Pi);const O=request.question;let indices=null;
  for(let i=0;i<O.length&&!indices;i++)for(let j=0;j<O.length&&!indices;j++)if(O[i][j][1]!==0n)indices=[i,j];
  assert(indices);return {kind:'antiunitary-access-obstruction',source:model.source,request:structuredClone(request),access:structuredClone(access),
    primitiveWitnesses:witnesses,indices,physicalAdmission:null};
}
function verifyImpossibility(model,request,access,certificate){touch(model);validateRequest(model,request);assert.equal(certificate.kind,'antiunitary-access-obstruction');
  assert.equal(key(certificate.source),key(model.source));assert.equal(key(certificate.request),key(request));assert.equal(key(certificate.access),key(access));assert.equal(certificate.physicalAdmission,null);
  eq(conjugate(model.Pi),model.Pi);const primitives=realPrimitives(model,access);assert.equal(primitives.length,certificate.primitiveWitnesses.length);
  primitives.forEach((p,i)=>{eq(mm(model.Pi,p.operator),p.operator);verifyRealPrimitive(p.operator,certificate.primitiveWitnesses[i]);});
  const [i,j]=certificate.indices;assert(Number.isSafeInteger(i)&&Number.isSafeInteger(j)&&i>=0&&j>=0&&i<model.I.length&&j<model.I.length&&i!==j);
  const v=mat(model.I.length,1);for(let k=0;k<v.length;k++)v[k][0]=add(model.Pi[k][i],mul(ii,model.Pi[k][j]));
  const norm=mm(adj(v),v)[0][0];assert.equal(norm[1],0n);assert(norm[0]>0n);
  const rho=scale(mm(v,adj(v)),div(one,norm)),other=conjugate(rho);eq(mm(mm(model.Pi,rho),model.Pi),rho);eq(mm(rho,rho),rho);assert.deepEqual(tr(rho),one);
  const answers=[tr(mm(rho,request.question)),tr(mm(other,request.question))];assert.notDeepEqual(answers[0],answers[1]);
  return {admitted:false,scope:'all finite adaptive protocols from these conjugation-compatible primitives',rho,other,answers,physicalAdmission:null};
}
function verify(model,request,access,certificate){if(certificate.kind==='antiunitary-access-obstruction')return verifyImpossibility(model,request,access,certificate);
  touch(model);const projectors=validateRequest(model,request);assert.equal(certificate.kind,'constructed-projective-acquisition');assert.equal(certificate.physicalAdmission,null);
  assert.equal(key(certificate.source),key(model.source));assert.equal(key(certificate.request),key(request));assert.equal(key(certificate.access),key(access));
  const actual=operations(model,access,certificate.program),frame=request.returnFrame==='input'?model.I:actual.frame;
  if(request.returnFrame==='transported')assert(certificate.program.post===null,'transported mode has its declared forward frame, not another post-operation');
  eq(frame,certificate.outputFrame);
  for(let a=0;a<2;a++)sameBranch(actual.operators[a],mm(frame,projectors[a]));
  let complete=mat(model.I.length);for(const A of actual.operators)complete=plus(complete,mm(adj(A),A));eq(complete,model.Pi);
  return {admitted:true,...actual,frame,projectors,physicalAdmission:null};
}
function construct(model,request,access){touch(model);counters.constructions++;const projectors=validateRequest(model,request),parts=instantiate(model,access);
  const base={source:model.source,request:structuredClone(request),access:structuredClone(access),physicalAdmission:null};
  for(let a=0;a<2;a++)if(isZero(projectors[1-a])){const out={...base,kind:'constructed-projective-acquisition',program:{pre:null,readout:null,post:null,constant:a},outputFrame:model.I};verify(model,request,access,out);return out;}
  const choices=[{name:null,operator:model.I},...parts.controls];let matchingRead=null;
  for(const pre of choices)for(const read of parts.readouts)for(const decoder of [[0,1],[1,0]]){
    const raw=[null,null];read.operators.forEach((K,a)=>raw[decoder[a]]=mm(mm(K,pre.operator),model.Pi));
    if(raw.some((A,a)=>!isZero(minus(mm(adj(A),A),projectors[a]))))continue;
    matchingRead??={pre:pre.name,readout:read.name,decoder};
    for(const post of request.returnFrame==='input'?choices:[{name:null,operator:model.I}]){
      const out={...base,kind:'constructed-projective-acquisition',program:{pre:pre.name,readout:read.name,post:post.name,decoder},
        outputFrame:request.returnFrame==='input'?model.I:pre.operator};
      try{verify(model,request,access,out);return out;}catch(error){if(!(error instanceof assert.AssertionError))throw error;}
    }
  }
  const obstruction=impossibility(model,request,access);if(obstruction){verifyImpossibility(model,request,access,obstruction);return obstruction;}
  return {...base,kind:'outside-single-conjugation-template',matchingRead};
}
function instrumentFrom(model,request,access,certificate){const checked=verify(model,request,access,certificate);assert(checked.admitted);
  return {kind:'declared-recorded-instrument',inputDimension:model.I.length,outcomes:checked.operators.map((K,a)=>({label:String(a),kraus:[K]}))};}
if(require.main===module){const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),model=C.currentModel();const results=bundle.map(b=>{
  const checked=verify(model,b.request,b.access,b.certificate);return checked.admitted?{admitted:true,controls:checked.controls,readings:checked.readings}:{admitted:false,answers:checked.answers.map(E.scalarText)};});
  console.log(JSON.stringify({verified:results,constructionCalls:counters,physicalAdmission:null}));}
module.exports={construct,verify,verifyImpossibility,instantiate,instrumentFrom,counters,exact:E};
