"use strict";
// Derive the whole correctable algebra from a full declared instrument and
// its available records. No logical qubit or Pauli catalog is presupposed.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),T=require('./coordinated_instrument_transport.js');
const E=C.exact,{c,z,one,nz,add,sub,mul,div,conj,mat,eye,scale,plus,minus,adj,mm,comm,eq,isZero,rref,rank,kernel}=E;
const key=C.json,counters={algebraSolves:0,centerSolves:0,querySubstitutions:0};
const transpose=A=>A[0].map((_,j)=>A.map(row=>row[j]));
const reshape=(v,n)=>Array.from({length:n},(_,i)=>v.slice(i*n,(i+1)*n));
function trivialFrame(P){return {kind:'declared-generated-star-algebra',support:P,readings:[{name:'unit',operator:P}]};}
function source(model){C.verifyPlan(model,{targetScore:[],inputProjector:model.Pi,requiredInteriorCuts:[]},C.accessModel([]),
  {rule:'retain-source-score',source:model.source,score:[]});return model.source;}
function constraints(P,instrument){const outcomes=T.validateInstrument(trivialFrame(P),instrument),n=P.length,width=n*n,rows=new Map();
  const push=row=>{const first=row.find(nz);if(!first)return;const normal=row.map(x=>div(x,first));rows.set(key(normal),normal);};
  // O=P O P, with O represented by its n*n independent complex entries.
  for(let i=0;i<n;i++)for(let j=0;j<n;j++){
    const row=[];for(let u=0;u<n;u++)for(let v=0;v<n;v++)row.push(sub(i===u&&j===v?one:z,mul(P[i][u],P[v][j])));push(row);}
  const crosses=new Map();
  for(const out of outcomes)for(const A of out.operators)for(const B of out.operators){
    const Q=mm(adj(A),B),first=Q.flat().find(nz);if(!first)continue;const normal=scale(Q,div(one,first));crosses.set(key(normal),normal);}
  for(const Q of crosses.values())for(let i=0;i<n;i++)for(let j=0;j<n;j++){
    const row=[];for(let u=0;u<n;u++)for(let v=0;v<n;v++)row.push(sub(v===j?Q[i][u]:z,i===u?Q[v][j]:z));push(row);}
  return {rows:rows.size?[...rows.values()]:[Array(width).fill(z)],width};
}
function inverse(A){const n=A.length,{A:B,pivots}=rref(A.map((row,i)=>[...row,...eye(n)[i]]));
  assert.deepEqual(pivots.slice(0,n),Array.from({length:n},(_,i)=>i));return B.map(row=>row.slice(n));}
function rankWitness(M){const rows=rref(transpose(M)).pivots;if(!rows.length)return {rows:[],columns:[],inverse:[]};
  const columns=rref(rows.map(i=>M[i])).pivots,minor=rows.map(i=>columns.map(j=>M[i][j]));return {rows,columns,inverse:inverse(minor)};}
function verifyRank(M,w){const n=w.rows.length;assert.equal(w.columns.length,n);assert.equal(new Set(w.rows).size,n);assert.equal(new Set(w.columns).size,n);
  w.rows.forEach(i=>assert(Number.isSafeInteger(i)&&i>=0&&i<M.length));w.columns.forEach(j=>assert(Number.isSafeInteger(j)&&j>=0&&j<M[0].length));
  if(!n){assert.deepEqual(w.inverse,[]);return 0;}
  assert(w.inverse.length===n&&w.inverse.every(row=>row.length===n));eq(mm(w.inverse,w.rows.map(i=>w.columns.map(j=>M[i][j]))),eye(n));return n;}
function proof(M,vectors){assert(vectors.length>0);return {vectors,constraintMinor:rankWitness(M),basisMinor:rankWitness(transpose(vectors))};}
function verifyProof(M,width,p){const k=p.vectors.length;assert(k>0&&k<=width);p.vectors.forEach(v=>assert.equal(v.length,width));
  eq(mm(M,transpose(p.vectors)),mat(M.length,k));assert.equal(verifyRank(transpose(p.vectors),p.basisMinor),k);
  assert.equal(verifyRank(M,p.constraintMinor),width-k);return k;}
function independent(candidates){const selected=[];for(const v of candidates)if(rank([...selected,v])>selected.length)selected.push(v);return selected;}
function hermitianBasis(M,n){const candidates=kernel(M).flatMap(v=>{const A=reshape(v,n);return [scale(plus(A,adj(A)),c(1,0,2)).flat(),scale(minus(A,adj(A)),c(0,-1,2)).flat()];});
  return independent(candidates);}
function centerConstraints(basis){const k=basis.length,rows=[];for(const B of basis){const columns=basis.map(A=>comm(A,B).flat());rows.push(...transpose(columns));}
  return rows.length?rows:[Array(k).fill(z)];}
function derive(model,P,instrument){source(model);const M=constraints(P,instrument),n=P.length;counters.algebraSolves++;
  const vectors=hermitianBasis(M.rows,n),basis=vectors.map(v=>reshape(v,n)),linear=proof(M.rows,vectors);
  counters.centerSolves++;const centerRows=centerConstraints(basis),centerCandidates=kernel(centerRows).flatMap(v=>[
    v.map(x=>c(x[0],0,x[2])),v.map(x=>c(x[1],0,x[2]))]);
  const center=proof(centerRows,independent(centerCandidates));
  const frame={kind:'declared-generated-star-algebra',support:P,readings:basis.map((operator,i)=>({name:`O${i}`,operator}))};
  const certificate={kind:'maximal-correctable-future-algebra',source:model.source,inputSupport:structuredClone(P),instrument:structuredClone(instrument),
    dimension:basis.length,centerDimension:center.vectors.length,linear,center,transport:T.construct(model,frame,instrument),physicalAdmission:null};
  verify(model,P,instrument,certificate);return certificate;
}
function verify(model,P,instrument,certificate){source(model);assert.equal(certificate.kind,'maximal-correctable-future-algebra');assert.equal(certificate.physicalAdmission,null);
  assert.equal(key(certificate.source),key(model.source));assert.equal(key(certificate.inputSupport),key(P));assert.equal(key(certificate.instrument),key(instrument));
  const M=constraints(P,instrument),n=P.length,k=verifyProof(M.rows,M.width,certificate.linear);assert.equal(k,certificate.dimension);
  const basis=certificate.linear.vectors.map(v=>reshape(v,n));basis.forEach(A=>{eq(adj(A),A);eq(mm(mm(P,A),P),A);});
  const centerRows=centerConstraints(basis),d=verifyProof(centerRows,k,certificate.center);assert.equal(d,certificate.centerDimension);
  certificate.center.vectors.forEach(v=>v.forEach(x=>assert.equal(x[1],0n)));
  const frame={kind:'declared-generated-star-algebra',support:P,readings:basis.map((operator,i)=>({name:`O${i}`,operator}))};
  assert(T.verify(model,frame,instrument,certificate.transport).admitted);return {frame,basis,dimension:k,centerDimension:d,physicalAdmission:null};
}
function coordinates(algebra,O){counters.querySubstitutions++;const w=algebra.linear.basisMinor,rhs=O.flat(),k=algebra.dimension;
  const selected=w.rows.map(i=>[rhs[i]]),ordered=mm(w.inverse,selected),coeff=Array(k).fill(z);
  w.columns.forEach((j,i)=>coeff[j]=ordered[i][0]);return coeff;
}
function combine(basis,coeff){assert.equal(basis.length,coeff.length);return basis.reduce((A,B,i)=>plus(A,scale(B,coeff[i])),mat(basis[0].length));}
function query(model,P,instrument,algebra,O){const checked=verify(model,P,instrument,algebra);eq(adj(O),O);eq(mm(mm(P,O),P),O);
  const coefficients=coordinates(algebra,O);
  if(!isZero(minus(combine(checked.basis,coefficients),O))){
    const frame={kind:'declared-generated-star-algebra',support:P,readings:[{name:'requested',operator:O}]},test=T.construct(model,frame,instrument);
    assert.equal(test.kind,'instrument-transport-obstruction');return {kind:'outside-maximal-algebra',obstruction:test,physicalAdmission:null};}
  const output={kind:'inside-maximal-algebra',coefficients,
    outputReadings:algebra.transport.outputs.map(out=>({label:out.label,operator:out.frame?combine(out.frame.readings.map(q=>q.operator),coefficients):null})),physicalAdmission:null};
  verifyQuery(model,P,instrument,algebra,O,output);return output;
}
function verifyQuery(model,P,instrument,algebra,O,witness){const checked=verify(model,P,instrument,algebra);eq(adj(O),O);eq(mm(mm(P,O),P),O);assert.equal(witness.physicalAdmission,null);
  if(witness.kind==='outside-maximal-algebra'){
    const frame={kind:'declared-generated-star-algebra',support:P,readings:[{name:'requested',operator:O}]};
    assert(!T.verify(model,frame,instrument,witness.obstruction).admitted);return false;
  }
  assert.equal(witness.kind,'inside-maximal-algebra');witness.coefficients.forEach(x=>assert.equal(x[1],0n));eq(combine(checked.basis,witness.coefficients),O);
  assert.equal(witness.outputReadings.length,algebra.transport.outputs.length);
  algebra.transport.outputs.forEach((out,i)=>{const value=witness.outputReadings[i];assert.equal(value.label,out.label);
    if(out.frame)eq(value.operator,combine(out.frame.readings.map(q=>q.operator),witness.coefficients));else assert.equal(value.operator,null);});return true;
}
if(require.main===module){const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),model=C.currentModel();
  const results=bundle.map(({support,instrument,certificate,queries=[]})=>{const result=verify(model,support,instrument,certificate);
    return {dimension:result.dimension,centerDimension:result.centerDimension,queries:queries.map(q=>verifyQuery(model,support,instrument,certificate,q.operator,q.witness))};});
  console.log(JSON.stringify({verified:results,constructionCalls:counters,instrumentConstructionCalls:T.counters,physicalAdmission:null}));}
module.exports={derive,verify,query,verifyQuery,counters,exact:E};
