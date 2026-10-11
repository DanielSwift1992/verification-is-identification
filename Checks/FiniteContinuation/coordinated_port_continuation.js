"use strict";
// One compiled relation program, all admitted representations of its contacts.
// Realization matrices below are explicit model premises, never hardware claims.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const E=C.exact,{c,z,one,ii,nz,add,sub,mul,div,conj,mat,eye,scale,plus,minus,adj,mm,comm,tr,eq,isZero,kron}=E;
const key=C.json,counters={constructions:0};
// Basis 1,p,q,pq. These products follow from p²=q²=1 and qp=-1-pq.
const v=(a=0,b=0,d=0,e=0)=>[c(a),c(b),c(d),c(e)];
const B=[v(1),v(0,1),v(0,0,1),v(0,0,0,1)];
const table=[B,[B[1],B[0],B[3],B[2]],
  [B[2],v(-1,0,0,-1),B[0],v(0,-1,-1)],
  [B[3],v(0,-1,-1),B[1],v(-1,0,0,-1)]];
const sum=(a,b)=>a.map((x,i)=>add(x,b[i])),times=(a,s)=>a.map(x=>mul(x,s));
function product(a,b){let out=v();for(let i=0;i<4;i++)for(let j=0;j<4;j++)out=sum(out,times(table[i][j],mul(a[i],b[j])));return out;}
function star(a){const bars=a.map(conj);return [sub(bars[0],bars[3]),bars[1],bars[2],E.neg(bars[3])];}
function reading(terms){let out=v();for(const t of terms){let W=B[0];for(const label of t.word){assert(['P','Q'].includes(label));W=product(W,B[label==='P'?1:2]);}
  out=sum(out,times(W,c(...t.coefficient)));}assert.deepEqual(star(out),out);return out;}
function section(s){assert(Number.isSafeInteger(s.quarters));assert([[1,0],[0,1],[1,1]].some(x=>key(x)===key(s.coeff)));
  const k=((s.quarters%4)+4)%4,cos=[one,z,c(-1),z][k],sin=[z,one,z,c(-1)][k];
  const H=sum(times(B[1],c(s.coeff[0])),times(B[2],c(s.coeff[1])));eq(product(H,H),B[0]);
  return sum(times(B[0],cos),times(H,mul(c(0,-1),sin)));}
function formalWord(score){return score.reduce((U,s)=>product(section(s),U),B[0]);}
function construct(model,goal,access){counters.constructions++;const resolution=R.resolve(model,goal,access),checked=R.verify(model,goal,access,resolution);
  assert(checked.score,'this rule needs an executable source resolution');const U=formalWord(checked.score);
  const certificate={kind:'representation-uniform-continuation',goal:structuredClone(goal),access:structuredClone(access),resolution,
    unitary:U,source:model.source,physicalAdmission:null};verify(model,goal,access,certificate);return certificate;}
function verify(model,goal,access,certificate){assert.equal(certificate.kind,'representation-uniform-continuation');assert.equal(certificate.physicalAdmission,null);
  assert.equal(key(certificate.goal),key(goal));assert.equal(key(certificate.access),key(access));assert.equal(key(certificate.source),key(model.source));
  const checked=R.verify(model,goal,access,certificate.resolution);assert(checked.score);const U=formalWord(checked.score);assert.deepEqual(U,certificate.unitary);
  eq(product(star(U),U),B[0]);
  for(const relation of goal.relations)eq(product(product(star(U),reading(relation.after)),U),reading(relation.before));
  return {...checked,unitary:U,physicalAdmission:null};
}
function evaluate(ports,coefficients){const basis=[ports.support,mm(ports.support,ports.P),mm(ports.support,ports.Q),mm(mm(ports.support,ports.P),ports.Q)];
  return basis.reduce((A,b,i)=>plus(A,scale(b,coefficients[i])),mat(ports.support.length));}
function validatePorts(ports){const S=ports.support,n=S.length;assert(n>0);eq(adj(S),S);eq(mm(S,S),S);assert(!isZero(S));
  for(const O of [ports.P,ports.Q]){assert(O.length===n&&O.every(row=>row.length===n));eq(adj(O),O);eq(comm(O,S),mat(n));eq(mm(mm(O,O),S),S);}
  eq(mm(plus(mm(ports.P,ports.Q),mm(ports.Q,ports.P)),S),scale(S,c(-1)),'individual contacts do not establish their required joint relation');
  assert(Array.isArray(ports.controls));const seen=new Set();
  for(const contact of ports.controls){const address=key(contact.section);assert(!seen.has(address));seen.add(address);const U=contact.operator;
    assert(U.length===n&&U.every(row=>row.length===n));eq(mm(adj(U),U),eye(n));eq(comm(U,S),mat(n));
    const formal=section(contact.section);
    for(const O of [B[1],B[2]])eq(mm(mm(adj(U),evaluate(ports,O)),U),evaluate(ports,product(product(star(formal),O),formal)),
      'actual contact does not implement the declared logical action');}
  return n;
}
function actualWord(ports,score){validatePorts(ports);return score.reduce((U,s)=>{
  const contact=ports.controls.find(x=>key(x.section)===key(s));assert(contact,'compiled contact is absent from actual declared access');return mm(contact.operator,U);
},eye(ports.support.length));}
function verifyHandover(before,after,V){const n=validatePorts(before);assert.equal(validatePorts(after),n);eq(mm(adj(V),V),eye(n));
  eq(mm(after.support,V),mm(V,before.support),'the current and next admitted carriers are not joined');
  for(const label of ['P','Q'])eq(mm(mm(after.support,after[label]),V),mm(V,mm(before.support,before[label])),
    'same sector is not enough: receiver contact is not matched to the source');return true;}
function positive(A){eq(adj(A),A);const M=A.map(row=>row.slice());for(let k=0;k<M.length;k++){const p=M[k][k];assert.equal(p[1],0n);assert(p[0]>=0n);
  if(!nz(p)){for(let j=k+1;j<M.length;j++)assert(!nz(M[k][j]));continue;}
  for(let i=k+1;i<M.length;i++)for(let j=k+1;j<M.length;j++)M[i][j]=sub(M[i][j],div(mul(M[i][k],M[k][j]),p));}}
const live=new WeakMap();
class PortBoundary {
  constructor(model,ports,rho,referenceDimension=1){const n=validatePorts(ports);assert(Number.isSafeInteger(referenceDimension)&&referenceDimension>0);
    assert(rho.length===n*referenceDimension&&rho.every(row=>row.length===n*referenceDimension));positive(rho);assert.deepEqual(tr(rho),one);
    const S=kron(ports.support,eye(referenceDimension));eq(mm(mm(S,rho),S),rho);
    live.set(this,{model,ports:structuredClone(ports),rho:structuredClone(rho),referenceDimension,history:[]});}
  continue(goal,access,certificate,handover){const s=live.get(this),checked=verify(s.model,goal,access,certificate);
    let U=actualWord(s.ports,checked.score),next=s.ports;
    if(handover){verifyHandover(s.ports,handover.ports,handover.operator);U=mm(handover.operator,U);next=handover.ports;}
    // Check the actual linked endpoint promise, not just the abstract program.
    for(const rel of goal.relations)eq(mm(mm(adj(U),evaluate(next,reading(rel.after))),U),evaluate(s.ports,reading(rel.before)));
    const extended=kron(U,eye(s.referenceDimension));const rho=mm(mm(extended,s.rho),adj(extended));
    s.rho=rho;s.ports=structuredClone(next);s.history.push({sections:checked.score.length,hasHandover:!!handover});return this;
  }
  inspectReading(terms,reference){const s=live.get(this);if(reference===undefined)reference=eye(s.referenceDimension);
    assert(reference.length===s.referenceDimension&&reference.every(row=>row.length===s.referenceDimension));eq(adj(reference),reference);
    // Mathematical inspection only. An arbitrary polynomial is not thereby
    // declared to be an available physical readout.
    return tr(mm(s.rho,kron(evaluate(s.ports,reading(terms)),reference)));}
  snapshot(){const s=live.get(this);return {ports:structuredClone(s.ports),rho:structuredClone(s.rho),history:structuredClone(s.history),physicalAdmission:null};}
}
if(require.main===module){const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),model=C.currentModel();
  const results=bundle.map(({goal,access,certificate})=>{const checked=verify(model,goal,access,certificate);return {sections:checked.score.length,formalIdentities:true};});
  console.log(JSON.stringify({verified:results,constructionCalls:counters,sourceConstructionCalls:R.counters,physicalAdmission:null}));}
module.exports={construct,verify,validatePorts,actualWord,verifyHandover,PortBoundary,evaluate,reading,product,star,section,counters,exact:E};
