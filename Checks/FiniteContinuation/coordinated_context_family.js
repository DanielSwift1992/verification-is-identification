"use strict";
// Derive all constant source-only coupling generators satisfying the current
// full-cq, whole-arc condition. This is not identification of actual hardware.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const P=require('./coordinated_pulse_relation.js'),F=require('./coordinated_cq_context.js');
const E=C.exact,{c,z,one,ii,nz,add,sub,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,eq,isZero,rref,rank,kernel}=E;
const key=C.json,counters={kernelConstructions:0,membershipConstructions:0};
const transpose=M=>M[0].map((_,j)=>M.map(row=>row[j]));
const reshape=(v,n)=>Array.from({length:n},(_,i)=>v.slice(i*n,(i+1)*n));
function templateData(m,template){
  F.verify(m,template.plan,template.context,template.certificate);
  const p=template.certificate,data=F.obligation(m,template.plan,template.context,p.program,p.paths,p.ranges);
  return {arcs:P.pulseData(m,data.pulseSpec).arcs,dimension:m.I.length};}
function constraintData(m,template){const data=templateData(m,template),n=data.dimension,blocks=new Map();
  // For I_probe tensor S, the joint commutator vanishes iff all four source
  // blocks commute with S. The proposed context's old generator list is not
  // used to restrict the unknown S: all n*n complex entries are variables.
  for(const arc of data.arcs)for(const q of arc)for(const coefficient of ['A','B','Cscaled'])
    for(let a=0;a<2;a++)for(let b=0;b<2;b++){
      const B=q[coefficient].slice(a*n,(a+1)*n).map(row=>row.slice(b*n,(b+1)*n)),first=B.flat().find(nz);
      if(first){const normal=scale(B,div(one,first));blocks.set(key(normal),normal);}}
  const rows=new Map();
  for(const B of blocks.values())for(let i=0;i<n;i++)for(let j=0;j<n;j++){
    const row=[];for(let u=0;u<n;u++)for(let v=0;v<n;v++)row.push(sub(i===u?B[v][j]:z,v===j?B[i][u]:z));
    const first=row.find(nz);if(first){const normal=row.map(x=>div(x,first));rows.set(key(normal),normal);}}
  return {...data,width:n*n,blocks:[...blocks.values()],rows:rows.size?[...rows.values()]:[Array(n*n).fill(z)]};}
function inverse(M){const n=M.length,rr=rref(M.map((row,i)=>[...row,...eye(n)[i]]));
  assert.deepEqual(rr.pivots.slice(0,n),Array.from({length:n},(_,i)=>i));return rr.A.map(row=>row.slice(n));}
function minor(M){const rows=rref(transpose(M)).pivots;if(!rows.length)return {rows:[],columns:[],inverse:[]};
  const columns=rref(rows.map(i=>M[i])).pivots;return {rows,columns,inverse:inverse(rows.map(i=>columns.map(j=>M[i][j])))};}
function verifyMinor(M,w){const k=w.rows.length;assert.equal(w.columns.length,k);assert.equal(new Set(w.rows).size,k);assert.equal(new Set(w.columns).size,k);
  w.rows.forEach(i=>assert(Number.isSafeInteger(i)&&i>=0&&i<M.length));w.columns.forEach(j=>assert(Number.isSafeInteger(j)&&j>=0&&j<M[0].length));
  if(!k){assert.deepEqual(w.inverse,[]);return 0;}assert(w.inverse.length===k&&w.inverse.every(row=>row.length===k));
  eq(mm(w.inverse,w.rows.map(i=>w.columns.map(j=>M[i][j]))),eye(k));return k;}
function derive(m,template){counters.kernelConstructions++;const d=constraintData(m,template),vectors=[];
  for(const v of kernel(d.rows)){const M=reshape(v,d.dimension);
    for(const H of [scale(plus(M,adj(M)),c(1,0,2)),scale(minus(M,adj(M)),c(0,-1,2))])
      if(rank([...vectors,H.flat()])>vectors.length)vectors.push(H.flat());}
  const certificate={kind:'maximal-source-pulse-generator-space',source:m.source,template:structuredClone(template),
    dimension:vectors.length,vectors,constraintMinor:minor(d.rows),basisMinor:minor(transpose(vectors)),physicalAdmission:null};
  verify(m,template,certificate);return certificate;}
function verify(m,template,certificate){assert.equal(certificate.kind,'maximal-source-pulse-generator-space');assert.equal(key(certificate.source),key(m.source));
  assert.equal(key(certificate.template),key(template));assert.equal(certificate.physicalAdmission,null);const d=constraintData(m,template),k=certificate.vectors.length;
  assert(k>0&&k<=d.width);assert.equal(certificate.dimension,k);certificate.vectors.forEach(v=>assert.equal(v.length,d.width));
  eq(mm(d.rows,transpose(certificate.vectors)),mat(d.rows.length,k));
  assert.equal(verifyMinor(transpose(certificate.vectors),certificate.basisMinor),k);
  assert.equal(verifyMinor(d.rows,certificate.constraintMinor),d.width-k);
  const basis=certificate.vectors.map(v=>reshape(v,d.dimension));basis.forEach(S=>eq(adj(S),S));
  return {basis,dimension:k,constraintCount:d.rows.length,sourceBlockCount:d.blocks.length,arcs:d.arcs,
    scope:'all fixed Hermitian source-only generators satisfying this full-output whole-arc condition; not all dynamically compensated physical realizations',physicalAdmission:null};}
function combine(basis,coefficients){assert.equal(coefficients.length,basis.length);return basis.reduce((A,S,j)=>plus(A,scale(S,coefficients[j])),mat(basis[0].length));}
function membership(m,template,family,S){counters.membershipConstructions++;const d=verify(m,template,family);eq(adj(S),S);
  assert(S.length===m.I.length&&S.every(row=>row.length===m.I.length));
  const w=family.basisMinor,ordered=mm(w.inverse,w.rows.map(i=>[S.flat()[i]])),coefficients=Array(d.dimension).fill(z);
  w.columns.forEach((j,i)=>coefficients[j]=ordered[i][0]);
  let proof;
  if(isZero(minus(combine(d.basis,coefficients),S)))proof={kind:'inside-derived-generator-space',coefficients,physicalAdmission:null};
  else{let obstruction=null;const joint=kron(eye(2),S);
    for(let segment=0;segment<d.arcs.length&&!obstruction;segment++)for(let question=0;question<d.arcs[segment].length&&!obstruction;question++)
      for(const coefficient of ['A','B','Cscaled']){const D=scale(comm(joint,d.arcs[segment][question][coefficient]),ii);
        if(!isZero(D)){obstruction={segment,question,coefficient,commutator:D};break;}}
    assert(obstruction);proof={kind:'outside-derived-generator-space',obstruction,physicalAdmission:null};}
  verifyMembership(m,template,family,S,proof);return proof;}
function verifyMembership(m,template,family,S,proof){const d=verify(m,template,family);eq(adj(S),S);
  assert(S.length===m.I.length&&S.every(row=>row.length===m.I.length));assert.equal(proof.physicalAdmission,null);
  if(proof.kind==='inside-derived-generator-space'){
    proof.coefficients.forEach(x=>assert.equal(x[1],0n));eq(combine(d.basis,proof.coefficients),S);return true;}
  assert.equal(proof.kind,'outside-derived-generator-space');const w=proof.obstruction;
  assert(Number.isSafeInteger(w.segment)&&Number.isSafeInteger(w.question));assert(['A','B','Cscaled'].includes(w.coefficient));
  const O=d.arcs[w.segment]?.[w.question]?.[w.coefficient];assert(O);
  const D=scale(comm(kron(eye(2),S),O),ii);assert(!isZero(D));eq(D,w.commutator);return false;
}
if(require.main===module){const m=C.currentModel(),bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8'));
  const results=bundle.map(b=>{const r=verify(m,b.template,b.certificate);return {dimension:r.dimension,constraints:r.constraintCount,
    memberships:b.queries.map(q=>verifyMembership(m,b.template,b.certificate,q.generator,q.proof))};});
  console.log(R.serialize({results,constructionCalls:counters,cqConstructionCalls:F.counters,pulseConstructionCalls:P.counters,physicalAdmission:null}));}
module.exports={derive,verify,membership,verifyMembership,combine,constraintData,counters,exact:E};
