"use strict";
// Branchwise transport of a logical algebra. The Pauli Lüders instruments are
// explicit conditional model inputs, not consequences of the Swift role law.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const {c,z,one,ii,nz,mat,eye,scale,plus,minus,adj,mm,comm,tr,eq,isZero,kron,rref,rank}=C.exact;
const key=C.json,counters={frameSearches:0,decoderSolves:0};
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]];
const single={I:I2,X,Y,Z};
function pauli(label){assert(/^[IXYZ]{2}$/.test(label));return kron(single[label[0]],single[label[1]]);}
const I=eye(4),allPaulis=Object.keys(single).flatMap(a=>Object.keys(single).flatMap(b=>[1,-1].map(sign=>({label:a+b,sign,operator:scale(pauli(a+b),c(sign))}))));
function instrument(label){const M=pauli(label);assert(label!=='II');
  return {kind:'declared-ideal-Pauli-Luders',label,branches:[0,1].map(bit=>({bit,K:scale(plus(I,scale(M,c(bit?-1:1))),c(1,0,2))}))};
}
function touchRoot(model){C.verifyPlan(model,{targetScore:[],inputProjector:model.Pi,requiredInteriorCuts:[]},C.accessModel([]),
  {rule:'retain-source-score',source:model.source,score:[]});}
function sourceFlip(model){touchRoot(model);
  const forms=[[0,1,2],model.ports.P],apply=order=>model.ports.P.map(i=>order[i]);
  const flip=forms.map(order=>forms.findIndex(f=>key(f)===key(apply(order))));
  assert.deepEqual(flip,[1,0]);return flip;
}
function inverse(A){const n=A.length;const rr=rref(A.map((row,i)=>[...row,...eye(n)[i]]));
  assert.deepEqual(rr.pivots.slice(0,n),Array.from({length:n},(_,i)=>i));return rr.A.map(row=>row.slice(n));}
function rangeProjector(A){const columns=rref(A).pivots;if(!columns.length)return mat(A.length);
  const W=A.map(row=>columns.map(j=>row[j]));return mm(mm(W,inverse(mm(adj(W),W))),adj(W));}
function validateFrame(frame){const {support,x,z:ZL}=frame;
  eq(adj(support),support);eq(mm(support,support),support);assert(!isZero(support));
  for(const O of [x,ZL]){eq(adj(O),O);eq(comm(O,support),mat(4));eq(mm(mm(O,O),support),support);}
  eq(mm(plus(mm(x,ZL),mm(ZL,x)),support),mat(4));
}
function initialFrame(){return {support:I,x:pauli('XI'),z:pauli('ZZ')};}
function candidates(A,O){return allPaulis.filter(p=>isZero(minus(mm(p.operator,A),mm(A,O)))).sort((a,b)=>{
  const sameA=key(a.operator)===key(O)?0:1,sameB=key(b.operator)===key(O)?0:1;
  return sameA-sameB+[...a.label].filter(x=>x!=='I').length/10-[...b.label].filter(x=>x!=='I').length/10;
});}
function constructStep(frame,label){
  counters.frameSearches++;validateFrame(frame);const it=instrument(label),outputs=[];
  for(const {bit,K}of it.branches){const A=mm(K,frame.support);
    if(isZero(A)){outputs.push(null);continue;}
    const support=rangeProjector(A),cx=candidates(A,frame.x),cz=candidates(A,frame.z);
    let found=null;
    for(const x of cx){for(const z of cz){
      if(isZero(mm(plus(mm(x.operator,z.operator),mm(z.operator,x.operator)),support))){
        found={support,x:x.operator,z:z.operator,xLabel:x.label,xSign:x.sign,zLabel:z.label,zSign:z.sign};break;}
    }if(found)break;}
    if(!found){
      const E=mm(adj(A),A);const question=['x','z'].find(name=>!isZero(comm(E,mm(frame.support,frame[name]))));
      const out={kind:question?'logical-disturbance':'outside-Pauli-frame-catalog',label,bit,
        question:question??null,obstruction:question?comm(E,mm(frame.support,frame[question])):null};
      if(question)verifyRefusal(frame,out);return out;
    }
    outputs.push(found);
  }
  const out={kind:'branchwise-algebra-transport',label,outputs};verifyStep(frame,out);return out;
}
function verifyStep(frame,certificate){
  validateFrame(frame);assert.equal(certificate.kind,'branchwise-algebra-transport');assert.equal(certificate.outputs.length,2);
  let complete=mat(4);
  for(const {bit,K}of instrument(certificate.label).branches){
    const A=mm(K,frame.support),next=certificate.outputs[bit];complete=plus(complete,mm(adj(A),A));
    if(isZero(A)){assert.equal(next,null);continue;}
    assert(next);validateFrame(next);eq(mm(next.support,A),A);assert.equal(rank(next.support),rank(A));
    for(const name of ['x','z'])eq(mm(next[name],A),mm(A,frame[name]),'instrument branch does not carry the required logical relation');
    if(next.xLabel)eq(next.x,scale(pauli(next.xLabel),c(next.xSign)));
    if(next.zLabel)eq(next.z,scale(pauli(next.zLabel),c(next.zSign)));
  }
  eq(complete,frame.support);return true;
}
function verifyRefusal(frame,certificate){
  validateFrame(frame);assert.equal(certificate.kind,'logical-disturbance');
  assert(certificate.bit===0||certificate.bit===1);assert(['x','z'].includes(certificate.question));
  const A=mm(instrument(certificate.label).branches[certificate.bit].K,frame.support),E=mm(adj(A),A);
  const D=comm(E,mm(frame.support,frame[certificate.question]));assert(!isZero(D));eq(D,certificate.obstruction);return true;
}
function compileWord(model,word,initial=initialFrame()){
  touchRoot(model);assert(word.length>0);word.forEach(instrument);validateFrame(initial);
  let current=[{frame:initial,outcomes:[],K:initial.support}],nodes=[];
  for(let i=0;i<word.length;i++){
    const next=[];
    for(const b of current){const step=constructStep(b.frame,word[i]);
      nodes.push({outcomes:b.outcomes,step});
      if(step.kind!=='branchwise-algebra-transport'){
        assert.equal(step.kind,'logical-disturbance','no theorem of impossibility outside the finite representative catalog');
        const out={kind:'refused-word',word,initial,nodes,source:model.source};verifyWord(model,out);return out;
      }
      for(const {bit,K}of instrument(word[i]).branches)if(step.outputs[bit])
        next.push({frame:step.outputs[bit],outcomes:[...b.outcomes,bit],K:mm(K,b.K)});
    }
    current=next;
  }
  const out={kind:'verified-word',word,initial,nodes,source:model.source};verifyWord(model,out);return out;
}
function verifyWord(model,certificate){
  touchRoot(model);assert.equal(key(certificate.source),key(model.source));validateFrame(certificate.initial);
  let current=[{frame:certificate.initial,outcomes:[],K:certificate.initial.support}],index=0;
  for(const label of certificate.word){const next=[];
    for(const b of current){const node=certificate.nodes[index++];assert(node);assert.equal(key(node.outcomes),key(b.outcomes));assert.equal(node.step.label,label);
      if(node.step.kind==='logical-disturbance'){
        assert.equal(certificate.kind,'refused-word');verifyRefusal(b.frame,node.step);assert(!isZero(b.K));
        assert.equal(index,certificate.nodes.length);return {admitted:false,refusedAfter:b.outcomes.length,refusedPrefix:b.outcomes};
      }
      verifyStep(b.frame,node.step);
      for(const {bit,K}of instrument(label).branches)if(node.step.outputs[bit])
        next.push({frame:node.step.outputs[bit],outcomes:[...b.outcomes,bit],K:mm(K,b.K)});
    }
    current=next;
  }
  assert.equal(certificate.kind,'verified-word');assert.equal(index,certificate.nodes.length);
  let complete=mat(4);for(const b of current)complete=plus(complete,mm(adj(b.K),b.K));eq(complete,certificate.initial.support);
  return {admitted:true,leaves:current};
}
function solveParity(rows,values){
  counters.decoderSolves++;const n=rows[0].length;
  const A=rows.map((row,i)=>[1,...row,values[i]]),pivots=[];let k=0;
  for(let j=0;j<=n;j++){const r=A.findIndex((row,i)=>i>=k&&row[j]);if(r<0)continue;
    [A[r],A[k]]=[A[k],A[r]];
    for(let i=0;i<A.length;i++)if(i!==k&&A[i][j])A[i]=A[i].map((x,l)=>x^A[k][l]);
    pivots.push(j);k++;
  }
  assert(!A.some(row=>row.slice(0,n+1).every(x=>!x)&&row[n+1]),'memory relation outside affine decoder grammar');
  const coefficients=Array(n+1).fill(0);pivots.forEach((j,i)=>coefficients[j]=A[i][n+1]);return {offset:coefficients[0],selected:coefficients.slice(1)};
}
function decode(record,rule){assert(record.length===rule.selected.length);assert([0,1].includes(rule.offset));
  assert(rule.selected.every(x=>x===0||x===1));assert(record.every(x=>x===0||x===1));
  return record.reduce((v,b,i)=>v^(b&rule.selected[i]),rule.offset);
}
function compileCycle(model,word){
  const program=compileWord(model,word);const checked=verifyWord(model,program);assert(checked.admitted,'cycle contains destructive acquisition');
  const X0=program.initial.x,Z0=program.initial.z;
  const signs=checked.leaves.map(b=>{eq(b.frame.z,Z0);if(key(b.frame.x)===key(X0))return 0;
    eq(b.frame.x,scale(X0,c(-1)),'cycle did not return the requested logical frame up to one sign');return 1;});
  const out={kind:'recorded-dynamic-cycle',program,decoder:solveParity(checked.leaves.map(b=>b.outcomes),signs),sourceFlip:sourceFlip(model),physicalAdmission:null};
  verifyCycle(model,out);return out;
}
function verifyCycle(model,certificate){
  assert.equal(certificate.kind,'recorded-dynamic-cycle');assert.equal(certificate.physicalAdmission,null);
  const checked=verifyWord(model,certificate.program);assert(checked.admitted);
  assert.equal(key(certificate.program.initial),key(initialFrame()),'different initial algebra requires a different runtime contract');
  assert.deepEqual(certificate.sourceFlip,sourceFlip(model));
  for(const b of checked.leaves){const bit=decode(b.outcomes,certificate.decoder);
    eq(b.frame.x,scale(certificate.program.initial.x,c(bit?-1:1)));eq(b.frame.z,certificate.program.initial.z);}
  return checked;
}
function validateRoute(request,available){
  assert.equal(request.kind,'logical-boundary-route');assert.deepEqual(request.preserve,['XI','ZZ']);
  assert.equal(request.input,'complete-two-participant-carrier');assert(request.targets.length>0);
  assert.equal(new Set(available).size,available.length);available.forEach(instrument);
  request.targets.forEach(label=>assert(available.includes(label),'required acquisition is unavailable'));
}
function extendFrames(frames,label){const next=[];
  for(const frame of frames){const step=constructStep(frame,label);if(step.kind!=='branchwise-algebra-transport')return null;
    next.push(...step.outputs.filter(Boolean));}
  return next;
}
function resolveRoute(model,request,available){
  touchRoot(model);validateRoute(request,available);let frames=[initialFrame()],word=[],cuts=[];
  for(const target of request.targets){
    let next=extendFrames(frames,target);
    if(!next){let bridge=null;
      for(const label of available){if(label===target)continue;const mid=extendFrames(frames,label);if(!mid)continue;
        const end=extendFrames(mid,target);if(end){bridge=label;next=end;break;}}
      if(bridge===null)return {kind:'outside-one-bridge-rule',target,completedTargets:cuts.length,physicalAdmission:null};
      word.push(bridge);
    }
    word.push(target);cuts.push(word.length-1);frames=next;
  }
  const plan={kind:'constructed-dynamic-route',request:structuredClone(request),available:[...available],cuts,
    cycle:compileCycle(model,word),physicalAdmission:null};verifyRoute(model,request,available,plan);return plan;
}
function verifyRoute(model,request,available,plan){
  validateRoute(request,available);assert.equal(plan.kind,'constructed-dynamic-route');assert.equal(plan.physicalAdmission,null);
  assert.equal(key(plan.request),key(request),'independent boundary route changed');assert.deepEqual(plan.available,available);
  const word=plan.cycle.program.word;word.forEach(label=>assert(available.includes(label),'undeclared acquisition'));
  assert.equal(plan.cuts.length,request.targets.length);let previous=-1;
  plan.cuts.forEach((cut,i)=>{assert(Number.isInteger(cut)&&cut>previous&&cut<word.length);assert.equal(word[cut],request.targets[i]);previous=cut;});
  assert.equal(previous,word.length-1,'last requested boundary must be the actual output');
  return verifyCycle(model,plan.cycle);
}
function density(rho,n){assert(rho.length===n&&rho.every(row=>row.length===n));eq(adj(rho),rho);assert.deepEqual(tr(rho),one);
  // Exact positivity from the existing finite arithmetic, without rounding.
  const A=rho.map(row=>row.slice());
  for(let k=0;k<n;k++){const p=A[k][k];assert.equal(p[1],0n);assert(p[0]>=0n);
    if(!nz(p)){for(let j=k+1;j<n;j++)assert(!nz(A[k][j]));continue;}
    for(let i=k+1;i<n;i++)for(let j=k+1;j<n;j++)A[i][j]=C.exact.sub(A[i][j],C.exact.div(C.exact.mul(A[i][k],A[k][j]),p));}
}
const live=new WeakMap();
class RecordedBoundary {
  constructor(model,rho,referenceDimension=1){touchRoot(model);assert(Number.isSafeInteger(referenceDimension)&&referenceDimension>0);density(rho,4*referenceDimension);
    live.set(this,{model,referenceDimension,blocks:[structuredClone(rho),mat(rho.length)],cycles:0});}
  continue(request,available,plan){const s=live.get(this),checked=verifyRoute(s.model,request,available,plan),certificate=plan.cycle,
      next=[mat(s.blocks[0].length),mat(s.blocks[0].length)];
    for(let m=0;m<2;m++)for(const b of checked.leaves){
      // The record is attached to this very Kraus branch. There is no public
      // replacement bit or expected-answer input to this execution path.
      const bit=decode(b.outcomes,certificate.decoder),destination=bit?certificate.sourceFlip[m]:m;
      const K=kron(b.K,eye(s.referenceDimension));next[destination]=plus(next[destination],mm(mm(K,s.blocks[m]),adj(K)));
    }
    assert.deepEqual(tr(plus(next[0],next[1])),one);s.blocks=next;s.cycles++;return this;
  }
  readLogical(question,reference){const s=live.get(this);assert(['x','y','z'].includes(question));
    if(reference===undefined)reference=eye(s.referenceDimension);
    assert(reference.length===s.referenceDimension&&reference.every(row=>row.length===s.referenceDimension));eq(adj(reference),reference);
    const O={x:pauli('XI'),y:pauli('YZ'),z:pauli('ZZ')}[question];
    return s.blocks.reduce((sum,rho,m)=>C.exact.add(sum,C.exact.mul(c(m&&question!=='z'?-1:1),tr(mm(rho,kron(O,reference))))),z);
  }
  snapshot(){const s=live.get(this);return {blocks:structuredClone(s.blocks),cycles:s.cycles,referenceDimension:s.referenceDimension,physicalAdmission:null};}
}
if(require.main===module){const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8'));
  const checked=verifyRoute(C.currentModel(),bundle.request,bundle.available,bundle);
  console.log(JSON.stringify({verified:true,branches:checked.leaves.length,decoder:bundle.cycle.decoder,constructionCalls:counters,physicalAdmission:null}));}
module.exports={pauli,instrument,initialFrame,constructStep,verifyStep,verifyRefusal,compileWord,verifyWord,compileCycle,verifyCycle,
  resolveRoute,verifyRoute,decode,sourceFlip,RecordedBoundary,counters,exact:C.exact};
