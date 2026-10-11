"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),T=require('./coordinated_instrument_transport.js'),A=require('./coordinated_acquired_question.js');
const {c,z,one,ii,add,mul,conj,mat,eye,scale,plus,minus,adj,mm,kron,tr,eq,isZero}=A.exact;
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]];
const bar=M=>M.map(row=>row.map(conj));
const apply=(K,rho)=>mm(mm(K,rho),adj(K));
function check(directory){const start=performance.now(),m=C.currentModel();
  const U=plus(scale(m.I,c(3,0,5)),scale(m.P,c(0,-4,5))),O=mm(mm(adj(U),mm(m.Pi,m.Q)),U);
  const request={kind:'projective-acquisition',question:O,returnFrame:'input'};
  const base={kind:'declared-source-acquisition-access',quarterDirections:[[1,0],[0,1],[1,1]],partialP:[],readouts:['P','Q']};
  const forward={...base,partialP:[[3,4,5]]},complete={...base,partialP:[[3,4,5],[3,-4,5]]};
  const blocked=A.construct(m,request,base);assert.equal(blocked.kind,'antiunitary-access-obstruction');
  const separator=A.verify(m,request,base,blocked);assert.deepEqual(separator.answers,[c(-37,0,50),c(7,0,10)]);
  eq(bar(separator.rho),separator.other);eq(mm(separator.rho,separator.rho),separator.rho);
  const probabilities=separator.answers.map(x=>mul(add(one,x),c(1,0,2)));assert.deepEqual(probabilities,[c(13,0,100),c(17,0,20)]);
  // An actual adaptive family of histories checks the implementation of the
  // generator-level symmetry lemma; the all-depth claim uses its induction.
  const available=A.instantiate(m,base);let branches=[{bits:[],K:m.Pi}];
  for(let depth=0;depth<4;depth++){
    const next=[];for(const b of branches){const last=b.bits.at(-1)??0,read=available.readouts[(depth+last)%2];
      const control=available.controls[(depth+last)%3].operator;
      read.operators.forEach((K,a)=>next.push({bits:[...b.bits,a],K:mm(mm(K,control),b.K)}));}branches=next;
  }
  let total=mat(8);for(const b of branches){const effect=mm(adj(b.K),b.K);eq(bar(effect),effect);
    assert.deepEqual(tr(mm(separator.rho,effect)),tr(mm(separator.other,effect)));total=plus(total,effect);}
  eq(total,m.Pi);assert.equal(branches.length,16);
  const forwardOnly=A.construct(m,request,forward);assert.equal(forwardOnly.kind,'outside-single-conjugation-template');assert(forwardOnly.matchingRead);
  const returned=A.construct(m,request,complete);assert.equal(returned.kind,'constructed-projective-acquisition');
  assert.deepEqual(returned.program,{pre:'partialP:3,4,5',readout:'Q',post:'partialP:3,-4,5',decoder:[0,1]});
  const carriedRequest={...request,returnFrame:'transported'},carried=A.construct(m,carriedRequest,forward);
  assert.deepEqual(carried.program,{pre:'partialP:3,4,5',readout:'Q',post:null,decoder:[0,1]});
  const p=A.verify(m,request,complete,returned),q=A.verify(m,carriedRequest,forward,carried);
  assert.equal(p.controls,2);assert.equal(q.controls,1);assert.equal(p.readings,1);assert.equal(q.readings,1);
  const v=mat(16,1);for(const [i,a]of [[2,2],[4,-1],[8,-1],[5,1],[9,-1]])v[i][0]=c(a);
  const entangled=scale(mm(v,adj(v)),c(1,0,8));let differing=0;
  for(let a=0;a<2;a++){
    const P=p.projectors[a];eq(p.operators[a],P);eq(q.operators[a],mm(U,P));
    const actual=apply(kron(p.operators[a],I2),entangled),raw=apply(kron(q.operators[a],I2),entangled);
    eq(actual,apply(kron(P,I2),entangled));eq(raw,apply(kron(U,I2),actual));
    if(!isZero(minus(actual,raw)))differing++;
  }
  assert(differing>0);
  // The returned actual instrument is admitted against the future algebra
  // promised by this acquisition; the same state then continues coherently.
  const frame={kind:'declared-generated-star-algebra',support:m.Pi,readings:[{name:'question',operator:O},{name:'unit',operator:m.Pi}]};
  const inst=A.instrumentFrom(m,request,complete,returned),boundary=new T.InstrumentBoundary(m,frame,entangled,2);
  boundary.continue(inst,T.deriveStage(m,boundary.frontier(),inst));
  for(const B of [I2,X,Y,Z])assert.deepEqual(boundary.read('question',B),tr(mm(entangled,kron(O,B))));
  const next={kind:'declared-recorded-instrument',inputDimension:8,outcomes:[{label:'next-coherent-contact',kraus:[m.P]}]};
  boundary.continue(next,T.deriveStage(m,boundary.frontier(),next));
  boundary.snapshot().blocks.forEach(b=>{const a=Number(b.record[0]);eq(b.rho,apply(kron(mm(m.P,p.projectors[a]),I2),entangled));});
  // A constant question does not justify inserting a measurement.
  const constantRequest={...request,question:m.Pi},empty={...base,quarterDirections:[],readouts:[]};
  const constant=A.construct(m,constantRequest,empty),constantCheck=A.verify(m,constantRequest,empty,constant);
  assert.equal(constantCheck.readings,0);assert.equal(constantCheck.controls,0);eq(constantCheck.operators[0],m.Pi);assert(isZero(constantCheck.operators[1]));
  // Negating the question changes the inferred interpretation of the actual
  // result, while the physical coherent contacts stay the same.
  const oppositeRequest={...request,question:scale(O,c(-1))},opposite=A.construct(m,oppositeRequest,complete);
  assert.deepEqual(opposite.program.decoder,[1,0]);assert.equal(opposite.program.pre,returned.program.pre);assert.equal(opposite.program.post,returned.program.post);

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  const noReturn=structuredClone(returned);noReturn.program.post=null;rejects(()=>A.verify(m,request,complete,noReturn));
  const missingContact=structuredClone(returned);missingContact.access=forward;rejects(()=>A.verify(m,request,forward,missingContact));
  const falseObstruction=structuredClone(blocked);falseObstruction.access=complete;rejects(()=>A.verify(m,request,complete,falseObstruction));
  const falsePhase=structuredClone(blocked);falsePhase.primitiveWitnesses[0].pivot=null;rejects(()=>A.verify(m,request,base,falsePhase));
  const wrongRecord=structuredClone(returned);wrongRecord.program.decoder=[1,0];rejects(()=>A.verify(m,request,complete,wrongRecord));
  const wrongFrame=structuredClone(carried);wrongFrame.outputFrame=m.I;rejects(()=>A.verify(m,carriedRequest,forward,wrongFrame));
  rejects(()=>A.verify(m,oppositeRequest,complete,returned));rejects(()=>A.verify({...m},request,complete,returned));
  const falsePhysical=structuredClone(returned);falsePhysical.physicalAdmission={backend:'unverified'};rejects(()=>A.verify(m,request,complete,falsePhysical));
  rejects(()=>A.construct(m,request,{...base,partialP:[[1,1,1]]}));
  const before={...A.counters};for(const [r,a,p]of [[request,base,blocked],[request,complete,returned],[carriedRequest,forward,carried],[constantRequest,empty,constant]])A.verify(m,r,a,p);
  assert.deepEqual(A.counters,before);
  const out={scope:'Explicit ideal source acquisition access, exact full instrument and declared output frame; no hardware admission',
    old_interface_obstruction:'all finite adaptive protocols preserve conjugation-invariant transcript effects',
    pure_conjugate_input_new_question_means:separator.answers.map(E=>`${E[0]}/${E[2]}`),
    new_positive_outcome_values:probabilities.map(E=>`${E[0]}/${E[2]}`),
    adaptive_control_histories_checked:16,returned_program:returned.program,carried_program:carried.program,
    return_modes_have_equal_answer_effects_but_different_outputs:true,arbitrary_reference_full_branch_identity:true,
    same_actual_output_continues_after_acquisition:true,constant_question_uses_no_measurement:true,
    negative_question_uses_actual_record_relabeling:true,only_forward_control_not_proved_globally_impossible:true,
    negative_checks:negatives,verification_does_not_construct_again:true,physical_admission:null,milliseconds:Math.round(performance.now()-start)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-9-acquisition-certificates.json');
    const bundle=[{request,access:base,certificate:blocked},{request,access:complete,certificate:returned},
      {request:carriedRequest,access:forward,certificate:carried},{request:constantRequest,access:empty,certificate:constant},
      {request:oppositeRequest,access:complete,certificate:opposite}];fs.writeFileSync(file,R.serialize(bundle)+'\n');
    fs.writeFileSync(path.join(directory,'wave-9-acquisition-separator.json'),R.serialize({rho:separator.rho,conjugate:separator.other,answers:separator.answers})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_acquired_question.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    out.persistedVerifier=JSON.parse(cp.stdout);assert.deepEqual(out.persistedVerifier.constructionCalls,{constructions:0});out.milliseconds=Math.round(performance.now()-start);
    fs.writeFileSync(path.join(directory,'wave-9-acquisition-checks.json'),JSON.stringify(out,null,2)+'\n');}
  return out;
}
if(require.main===module)console.log(JSON.stringify(check(process.argv[2]),null,2));
module.exports={check};
