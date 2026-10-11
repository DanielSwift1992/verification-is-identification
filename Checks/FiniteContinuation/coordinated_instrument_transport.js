"use strict";
// Exact transport of a declared logical algebra through a declared instrument.
// This checks conditional mathematics; it does not issue laboratory access.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const E=C.exact,{c,z,one,nz,add,sub,mul,div,mat,eye,plus,minus,adj,mm,comm,tr,eq,isZero,kron,rref}=E;
const key=C.json,counters={constructions:0,pseudoinverses:0,recordPartitions:0};
function touchRoot(model){C.verifyPlan(model,{targetScore:[],inputProjector:model.Pi,requiredInteriorCuts:[]},C.accessModel([]),
  {rule:'retain-source-score',source:model.source,score:[]});}
function matrix(A,rows,cols){assert(Array.isArray(A)&&A.length===rows&&A.every(row=>Array.isArray(row)&&row.length===cols));
  for(const row of A)for(const x of row){assert(Array.isArray(x)&&x.length===3&&x.every(v=>typeof v==='bigint'));assert(x[2]>0n);assert.deepEqual(x,c(...x));}}
function validateFrame(frame){assert.equal(frame.kind,'declared-generated-star-algebra');const P=frame.support,n=P.length;assert(n>0);matrix(P,n,n);eq(adj(P),P);eq(mm(P,P),P);assert(!isZero(P));
  assert(Array.isArray(frame.readings)&&frame.readings.length>0);const names=new Set();
  for(const {name,operator:O}of frame.readings){assert(typeof name==='string'&&name.length&&!names.has(name));names.add(name);
    matrix(O,n,n);eq(adj(O),O);eq(mm(mm(P,O),P),O,'reading must be supported on the declared input boundary');}
  return n;
}
function validateInstrument(frame,instrument){const n=validateFrame(frame);assert.equal(instrument.kind,'declared-recorded-instrument');
  assert.equal(instrument.inputDimension,n);assert(instrument.outcomes.length>0);const labels=new Set();let complete=mat(n);
  const outcomes=instrument.outcomes.map(({label,kraus})=>{assert(typeof label==='string'&&!labels.has(label));labels.add(label);assert(kraus.length>0);
    const d=kraus[0].length;assert(d>0);const operators=kraus.map(K=>{matrix(K,d,n);const A=mm(K,frame.support);complete=plus(complete,mm(adj(A),A));return A;});
    return {label,operators};});
  eq(complete,frame.support,'instrument is not complete on the admitted input');return outcomes;
}
function inverse(A){const n=A.length,rr=rref(A.map((row,i)=>[...row,...eye(n)[i]]));
  assert.deepEqual(rr.pivots.slice(0,n),Array.from({length:n},(_,i)=>i));return rr.A.map(row=>row.slice(n));}
function pseudoinverse(A){counters.pseudoinverses++;const pivots=rref(A).pivots;
  if(!pivots.length)return mat(A[0].length,A.length);
  const W=A.map(row=>pivots.map(j=>row[j])),left=mm(inverse(mm(adj(W),W)),adj(W)),F=mm(left,A);
  const right=mm(adj(F),inverse(mm(F,adj(F))));const result=mm(right,left);
  // The compiler verifies its own exact linear construction before issuing it.
  eq(mm(mm(A,result),A),A);eq(mm(mm(result,A),result),result);
  eq(adj(mm(A,result)),mm(A,result));eq(adj(mm(result,A)),mm(result,A));return result;
}
const horizontal=operators=>operators[0].map((_,i)=>operators.flatMap(A=>A[i]));
function blockDiagonal(A,count){const n=A.length,M=mat(n*count);for(let k=0;k<count;k++)for(let i=0;i<n;i++)for(let j=0;j<n;j++)M[k*n+i][k*n+j]=A[i][j];return M;}
function obstruction(frame,outcomes){for(let a=0;a<outcomes.length;a++){
  const ops=outcomes[a].operators;
  for(let i=0;i<ops.length;i++)for(let j=0;j<ops.length;j++)for(let q=0;q<frame.readings.length;q++){
    const cross=mm(adj(ops[i]),ops[j]),D=comm(cross,frame.readings[q].operator);
    if(!isZero(D))return {outcome:a,left:i,right:j,reading:q,commutator:D};}}
  return null;
}
function construct(model,frame,instrument){touchRoot(model);counters.constructions++;
  const outcomes=validateInstrument(frame,instrument),witness=obstruction(frame,outcomes);
  const base={source:model.source,input:structuredClone(frame),instrument:structuredClone(instrument),physicalAdmission:null};
  if(witness){const certificate={...base,kind:'instrument-transport-obstruction',witness};verify(model,frame,instrument,certificate);return certificate;}
  const outputs=outcomes.map(({label,operators})=>{const B=horizontal(operators);if(isZero(B))return {label,frame:null,rangeWitness:null};
    const right=pseudoinverse(B),support=mm(B,right);
    const readings=frame.readings.map(({name,operator})=>({name,operator:mm(mm(B,blockDiagonal(operator,operators.length)),right)}));
    return {label,frame:{kind:'declared-generated-star-algebra',support,readings},rangeWitness:right};});
  const certificate={...base,kind:'instrument-algebra-transport',outputs};verify(model,frame,instrument,certificate);return certificate;
}
function verify(model,frame,instrument,certificate){touchRoot(model);const outcomes=validateInstrument(frame,instrument);
  assert.equal(key(certificate.source),key(model.source));assert.equal(key(certificate.input),key(frame));
  assert.equal(key(certificate.instrument),key(instrument),'certificate belongs to a different full instrument');assert.equal(certificate.physicalAdmission,null);
  if(certificate.kind==='instrument-transport-obstruction'){
    const w=certificate.witness;assert([w.outcome,w.left,w.right,w.reading].every(Number.isSafeInteger));
    assert(w.outcome>=0&&w.outcome<outcomes.length&&w.reading>=0&&w.reading<frame.readings.length);
    const ops=outcomes[w.outcome].operators;assert(w.left>=0&&w.left<ops.length&&w.right>=0&&w.right<ops.length);
    const D=comm(mm(adj(ops[w.left]),ops[w.right]),frame.readings[w.reading].operator);
    assert(!isZero(D),'zero commutator does not exclude continuation');eq(D,w.commutator);
    return {admitted:false,witness:w,physicalAdmission:null};
  }
  assert.equal(certificate.kind,'instrument-algebra-transport');assert.equal(certificate.outputs.length,outcomes.length);
  for(let a=0;a<outcomes.length;a++){
    const {label,operators}=outcomes[a],output=certificate.outputs[a],B=horizontal(operators);assert.equal(output.label,label);
    if(isZero(B)){assert.equal(output.frame,null);assert.equal(output.rangeWitness,null);continue;}
    validateFrame(output.frame);const Q=output.frame.support;matrix(Q,B.length,B.length);
    matrix(output.rangeWitness,B[0].length,B.length);eq(mm(Q,B),B);eq(mm(B,output.rangeWitness),Q,'declared output includes an unsupported subspace');
    assert.deepEqual(output.frame.readings.map(q=>q.name),frame.readings.map(q=>q.name));
    for(let q=0;q<frame.readings.length;q++)for(const A of operators)
      eq(mm(output.frame.readings[q].operator,A),mm(A,frame.readings[q].operator),'hidden alternative does not carry this reading');
  }
  return {admitted:true,outputs:certificate.outputs.map(o=>({label:o.label,frame:o.frame})),physicalAdmission:null};
}
function deriveStage(model,frames,instrument){
  const unique=[...new Map(frames.map(f=>[key(f),f])).values()];
  return {kind:'instrument-stage',instrument:structuredClone(instrument),cases:unique.map(frame=>construct(model,frame,instrument)),physicalAdmission:null};
}
function coarsen(instrument,classes){assert.equal(classes.length,instrument.outcomes.length);assert(classes.every(x=>Number.isSafeInteger(x)&&x>=0));
  const count=Math.max(...classes)+1;assert(count>0&&count<=classes.length);
  const outcomes=Array.from({length:count},(_,j)=>({label:String(j),kraus:instrument.outcomes.flatMap((o,i)=>classes[i]===j?o.kraus:[])}));
  assert(outcomes.every(o=>o.kraus.length));return {kind:'declared-recorded-instrument',inputDimension:instrument.inputDimension,outcomes};
}
function deriveRecordPartition(model,frame,instrument){
  counters.recordPartitions++;const fine=construct(model,frame,instrument);
  if(fine.kind==='instrument-transport-obstruction')return {kind:'unavailable-record-refinement',obstruction:fine,physicalAdmission:null};
  const outcomes=validateInstrument(frame,instrument),n=outcomes.length,edges=Array.from({length:n},()=>[]);let separatingPair=null;
  for(let a=0;a<n;a++)for(let b=a+1;b<n;b++){
    let witness=null;
    for(let i=0;i<outcomes[a].operators.length&&!witness;i++)for(let j=0;j<outcomes[b].operators.length&&!witness;j++)
      for(let q=0;q<frame.readings.length&&!witness;q++){
        const D=comm(mm(adj(outcomes[a].operators[i]),outcomes[b].operators[j]),frame.readings[q].operator);
        if(!isZero(D))witness={outcomes:[a,b],left:i,right:j,reading:q,commutator:D};}
    if(witness){edges[a].push(b);edges[b].push(a);separatingPair??=witness;}}
  const classes=Array(n).fill(-1);
  for(let root=0;root<n;root++)if(classes[root]<0){classes[root]=0;const queue=[root];
    for(let k=0;k<queue.length;k++)for(const b of edges[queue[k]]){
      const want=1-classes[queue[k]];
      if(classes[b]<0){classes[b]=want;queue.push(b);}else if(classes[b]!==want)
        return {kind:'outside-two-record-class-rule',physicalAdmission:null};}}
  const grouped=coarsen(instrument,classes),transport=construct(model,frame,grouped);
  const result={kind:'minimal-one-or-two-record-classes',input:structuredClone(frame),instrument:structuredClone(instrument),
    classes,minimumClasses:separatingPair?2:1,separatingPair,transport,physicalAdmission:null};
  verifyRecordPartition(model,frame,instrument,result);return result;
}
function verifyRecordPartition(model,frame,instrument,certificate){
  assert.equal(certificate.kind,'minimal-one-or-two-record-classes');assert.equal(certificate.physicalAdmission,null);
  assert.equal(key(certificate.input),key(frame));assert.equal(key(certificate.instrument),key(instrument));
  const grouped=coarsen(instrument,certificate.classes),checked=verify(model,frame,grouped,certificate.transport);assert(checked.admitted);
  assert.equal(grouped.outcomes.length,certificate.minimumClasses);assert([1,2].includes(certificate.minimumClasses));
  if(certificate.minimumClasses===1){assert.equal(certificate.separatingPair,null);return checked;}
  const w=certificate.separatingPair,ops=validateInstrument(frame,instrument);assert(w&&w.outcomes.length===2);
  const [a,b]=w.outcomes;assert([a,b,w.left,w.right,w.reading].every(Number.isSafeInteger));
  assert(a>=0&&a<ops.length&&b>=0&&b<ops.length&&a!==b);assert(w.reading>=0&&w.reading<frame.readings.length);
  assert(w.left>=0&&w.left<ops[a].operators.length&&w.right>=0&&w.right<ops[b].operators.length);
  const D=comm(mm(adj(ops[a].operators[w.left]),ops[b].operators[w.right]),frame.readings[w.reading].operator);
  assert(!isZero(D));eq(D,w.commutator);return checked;
}
function stageCase(model,frame,instrument,stage){assert.equal(stage.kind,'instrument-stage');assert.equal(stage.physicalAdmission,null);
  assert.equal(key(stage.instrument),key(instrument));const found=stage.cases.filter(c=>key(c.input)===key(frame));assert.equal(found.length,1,'current boundary has no unique matching certificate');
  const result=verify(model,frame,instrument,found[0]);assert(result.admitted,'actual input boundary has a proved obstruction');return result;
}
function positive(A){eq(adj(A),A);const B=A.map(row=>row.slice());
  for(let k=0;k<B.length;k++){const p=B[k][k];assert.equal(p[1],0n);assert(p[0]>=0n);
    if(!nz(p)){for(let j=k+1;j<B.length;j++)assert(!nz(B[k][j]));continue;}
    for(let i=k+1;i<B.length;i++)for(let j=k+1;j<B.length;j++)B[i][j]=sub(B[i][j],div(mul(B[i][k],B[k][j]),p));}}
const live=new WeakMap();
class InstrumentBoundary {
  constructor(model,frame,rho,referenceDimension=1){touchRoot(model);const n=validateFrame(frame);
    assert(Number.isSafeInteger(referenceDimension)&&referenceDimension>0);matrix(rho,n*referenceDimension,n*referenceDimension);positive(rho);assert.deepEqual(tr(rho),one);
    const P=kron(frame.support,eye(referenceDimension));eq(mm(mm(P,rho),P),rho);
    live.set(this,{model,referenceDimension,blocks:[{record:[],frame:structuredClone(frame),rho:structuredClone(rho)}],steps:0});}
  frontier(){return [...new Map(live.get(this).blocks.map(b=>[key(b.frame),structuredClone(b.frame)])).values()];}
  continue(instrument,stage){const s=live.get(this),next=[];
    // Validate every branch before changing any retained state.
    const cases=s.blocks.map(b=>stageCase(s.model,b.frame,instrument,stage));
    for(let k=0;k<s.blocks.length;k++){const b=s.blocks[k],certificate=cases[k];
      for(let a=0;a<instrument.outcomes.length;a++){const output=certificate.outputs[a];if(!output.frame)continue;
        const out=instrument.outcomes[a];let rho=mat(out.kraus[0].length*s.referenceDimension);
        for(const K0 of out.kraus){const K=kron(K0,eye(s.referenceDimension));rho=plus(rho,mm(mm(K,b.rho),adj(K)));}
        next.push({record:[...b.record,out.label],frame:structuredClone(output.frame),rho});}}
    assert.deepEqual(next.reduce((total,b)=>add(total,tr(b.rho)),z),one);s.blocks=next;s.steps++;return this;
  }
  read(name,reference){const s=live.get(this);if(reference===undefined)reference=eye(s.referenceDimension);
    matrix(reference,s.referenceDimension,s.referenceDimension);eq(adj(reference),reference);
    return s.blocks.reduce((total,b)=>{const q=b.frame.readings.find(q=>q.name===name);assert(q,'reading outside declared future');
      return add(total,tr(mm(b.rho,kron(q.operator,reference))));},z);
  }
  snapshot(){const s=live.get(this);return {blocks:structuredClone(s.blocks),steps:s.steps,referenceDimension:s.referenceDimension,physicalAdmission:null};}
}
if(require.main===module){const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),model=C.currentModel();
  const results=bundle.map(({frame,instrument,certificate})=>(certificate.kind==='minimal-one-or-two-record-classes'?
    verifyRecordPartition(model,frame,instrument,certificate):verify(model,frame,instrument,certificate)).admitted);
  console.log(JSON.stringify({verified:results,constructionCalls:counters,physicalAdmission:null}));}
module.exports={construct,verify,deriveStage,coarsen,deriveRecordPartition,verifyRecordPartition,InstrumentBoundary,validateFrame,validateInstrument,counters,exact:E};
