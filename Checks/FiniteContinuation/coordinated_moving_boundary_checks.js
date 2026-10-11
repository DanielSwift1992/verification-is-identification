"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const M=require('./coordinated_moving_boundary.js'),R=require('./coordinated_relation_resolve.js');
const {c,z,one,ii,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,scalarText}=M.exact;
const e=R.reading;
const goal=relations=>({kind:'source-reading-relations',input:'derived-noncommuting-sector',relations});
const expectation=(rho,O)=>tr(mm(rho,O));
const after=(V,rho)=>mm(mm(V,rho),adj(V));
function check(outputDirectory){
  const start=performance.now(),m=M.currentModel(),{I,initial:Pi0,receiver:Pi1}=m,{P,Q,T:K,ReceiverQ}=m.operators;
  const id=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]];
  const at=(A,j)=>[0,1,2,3].map(i=>i===j?A:id).reduce(kron);
  const collective=A=>[0,1,2,3].map(i=>at(A,i)).reduce(plus);
  const generators=[X,Y,Z].map(collective),protection=M.proveMovingProtection(m,generators);
  const available=M.access(['P','Q','T']),beforeAccess=M.access(['P','Q']);
  const transferReq=M.transferConstraints(m,I,K),transfer=M.construct(m,available,transferReq);
  const transferChecked=M.verify(m,available,transferReq,transfer);assert.deepEqual(transferChecked.word,['T']);
  const absent=M.construct(m,beforeAccess,transferReq);assert.equal(absent.kind,'fixed-access-obstruction');
  assert.equal(M.verify(m,beforeAccess,transferReq,absent),null);assert.equal(absent.states.length,6);
  const swap=goal([{after:e(['P']),before:e(['Q'])},{after:e(['Q']),before:e(['P'])}]);
  const receiverReq=M.constraints(m,K,swap),receiver=M.construct(m,available,receiverReq);
  const receiverChecked=M.verify(m,available,receiverReq,receiver);
  assert.equal(receiverChecked.minimumSections,5);assert.equal(receiver.states.length,24);
  // Independent lower bound: the unique matching permutation is (1 4), with
  // five inversions. Each adjacent exchange changes that count by exactly one.
  const swap14Order=[3,1,2,0],swap14=mat(16);
  for(let i=0;i<16;i++){const bits=[0,1,2,3].map(j=>(i>>(3-j))&1);const j=swap14Order.reduce((a,k)=>2*a+bits[k],0);swap14[j][i]=one;}
  assert.equal(M.signature(receiverChecked.operator),M.signature(swap14));
  const inverseCount=swap14Order.reduce((n,x,i)=>n+swap14Order.slice(i+1).filter(y=>x>y).length,0);assert.equal(inverseCount,5);
  const alternatives=receiver.states.filter(s=>{const W=M.operator(m,s.word);return receiverReq.relations.every(({before,after:O})=>
    isZero(mm(mm(Pi1,minus(mm(mm(adj(W),O),W),before)),Pi1)));});assert.equal(alternatives.length,1);
  const directAccess=M.access(['P','ReceiverQ']),direct=M.construct(m,directAccess,receiverReq);
  assert.equal(M.verify(m,directAccess,receiverReq,direct).minimumSections,3);
  const lateNoAccess=M.construct(m,beforeAccess,receiverReq);assert.equal(lateNoAccess.kind,'fixed-access-obstruction');
  // If the question arrives before transfer, its operation can be performed
  // there. It cannot be moved across an earlier cut after the fact.
  const earlyReq=M.crossConstraints(m,I,K,swap);
  const early=M.construct(m,available,earlyReq);assert.equal(M.verify(m,available,earlyReq,early).minimumSections,4);

  // Exact partial pulses and their moving projector. The common background
  // commutes with K, so the identities hold for every angle, not only these.
  const first=plus(scale(I,c(3,0,5)),scale(K,c(0,-4,5)));
  const last=plus(scale(I,c(4,0,5)),scale(K,c(0,-3,5)));
  eq(mm(last,first),scale(K,c(0,-1)));
  const PiMid=M.conjugate(first,Pi0);assert(!isZero(minus(PiMid,Pi0)));assert(!isZero(minus(PiMid,Pi1)));
  const sourceMixed=scale(Pi0,c(1,0,8)),atMid=after(first,sourceMixed);
  assert.deepEqual(expectation(atMid,PiMid),one);
  const oldFraction=expectation(atMid,Pi0);assert(oldFraction[0]<oldFraction[2]);
  for(const O of M.initialAlgebra(m))for(const S of generators){
    const moved=M.conjugate(first,O);eq(comm(S,moved),mat(16));
    // dot(O_theta)=-i[K,O_theta]; the control contribution cancels it.
    eq(plus(scale(comm(K,moved),c(0,-1)),scale(comm(K,moved),ii)),mat(16));
  }
  // Rational collective rotations are explicit test histories, not inputs to
  // the uniform Hamiltonian-family proof above.
  const rotation=A=>plus(scale(id,c(3,0,5)),scale(A,c(0,4,5)));
  const Gx=[0,1,2,3].map(()=>rotation(X)).reduce(kron),Gz=[0,1,2,3].map(()=>rotation(Z)).reduce(kron);
  assert(!isZero(comm(Gx,Gz)));
  const actualTransfer=mm(mm(last,Gz),mm(first,Gx));
  for(const {before,after:O}of transferReq.relations)eq(mm(mm(Pi0,minus(mm(mm(adj(actualTransfer),O),actualTransfer),before)),Pi0),mat(16));
  // An initially harmless local fourth-participant rotation is not protected
  // during this transition. It is a separate interaction assumption.
  const Z4=at(Z,3),localFourth=plus(scale(I,c(3,0,5)),scale(Z4,c(0,4,5)));
  for(const O of M.initialAlgebra(m))eq(comm(Z4,O),mat(16));
  const badTransition=mm(mm(last,localFourth),first),badSurvival=expectation(after(badTransition,sourceMixed),Pi1);
  assert(badSurvival[0]<badSurvival[2]);

  // Initial logical content, active participant 4 and reference are correlated.
  // No value for participant 4 is supplied to either synthesis operation.
  const v=mat(32,1);for(const [s,a,f,r]of [[1,2,0,0],[2,-1,0,0],[4,-1,0,0],[2,1,1,1],[4,-1,1,1]])v[(2*s+f)*2+r][0]=c(a);
  const rho=scale(mm(v,adj(v)),c(1,0,8));
  const live=new M.MovingBoundary(m,rho,1,2);
  live.transfer(K,available,transfer,generators,protection,[Gx]);
  const transferred=live.snapshot();eq(transferred.frame,K);
  const episodes=receiverChecked.word.map((_,i)=>i%2?Gz:Gx);
  live.continue(swap,available,receiver,generators,protection,episodes);
  const current=live.snapshot(),fullIdeal=kron(mm(receiverChecked.operator,transferChecked.operator),id),ideal=after(fullIdeal,rho);
  for(const O of M.algebra(m,K))for(const B of [id,X,Y,Z])
    assert.deepEqual(expectation(current.rho,kron(O,B)),expectation(ideal,kron(O,B)));
  assert(!isZero(minus(current.rho,ideal)));
  const earlyLive=new M.MovingBoundary(m,rho,1,2);
  earlyLive.continueAndTransfer(swap,K,available,early,generators,protection,[Gx,Gz,Gx,Gz]);
  for(const O of M.algebra(m,K))for(const B of [id,X,Y,Z])
    assert.deepEqual(expectation(earlyLive.snapshot().rho,kron(O,B)),expectation(current.rho,kron(O,B)));
  assert.equal(earlyLive.snapshot().history.length,1); // no intervening transfer-only promise
  // A second instance has a genuine retained joint environment instead of an
  // untouched reference. Both roles are explicit in the constructor.
  const zero=[[one,z],[z,z]],bitOne=[[z,z],[z,one]];
  const W1=plus(kron(Gx,zero),kron(adj(Gx),bitOne));
  const W2=mm(kron(I,rotation(X)),plus(kron(Gz,zero),kron(adj(Gz),bitOne)));
  assert(!isZero(comm(W1,W2)));
  const withMemory=new M.MovingBoundary(m,rho,2,1);
  withMemory.transfer(K,available,transfer,generators,protection,[W1]);
  withMemory.continue(swap,available,receiver,generators,protection,receiverChecked.word.map((_,i)=>i%2?W1:W2));
  const memoryIdeal=after(kron(mm(receiverChecked.operator,transferChecked.operator),id),rho);
  for(const O of M.algebra(m,K))assert.deepEqual(expectation(withMemory.snapshot().rho,kron(O,id)),expectation(memoryIdeal,kron(O,id)));

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  rejects(()=>M.proveMovingProtection(m,[Z4]));
  const wrongAccess={...available};delete wrongAccess.pathSemantics;rejects(()=>M.construct(m,wrongAccess,transferReq));
  rejects(()=>M.verify(m,beforeAccess,transferReq,transfer));
  // Same final projector does not fix the transported logical content.
  const wrongWord=['T','P'],wrongOperator=M.operator(m,wrongWord);
  eq(M.conjugate(wrongOperator,Pi0),Pi1);
  const wrong=structuredClone(transfer);wrong.chosen=wrong.states.findIndex(s=>M.signature(M.operator(m,s.word))===M.signature(wrongOperator));assert(wrong.chosen>=0);
  rejects(()=>M.verify(m,available,transferReq,wrong));
  const fake=structuredClone(receiver);fake.states[fake.chosen].distance=1;rejects(()=>M.verify(m,available,receiverReq,fake));
  const fakeClosure=structuredClone(receiver);fakeClosure.states[0].transitions[0]=0;rejects(()=>M.verify(m,available,receiverReq,fakeClosure));
  const before=live.snapshot();rejects(()=>live.continue(swap,available,receiver,generators,protection,episodes.map(()=>localFourth)));
  eq(before.rho,live.snapshot().rho);assert.deepEqual(before.history,live.snapshot().history);
  rejects(()=>M.verify({...m,operators:{...m.operators,T:I}},available,transferReq,transfer));
  rejects(()=>live.transfer(I,beforeAccess,absent,generators,protection,[I]));

  const out={scope:'Current symbolic source; conditional coherent moving boundary; no hardware admission',
    source_equalities:m.sourceEqualities,source_ports:m.ports,normal_forms:receiver.states.length,
    transfer_word:transferChecked.word,receiver_word:receiverChecked.word,
    minimum_sections:{transfer:1,receiver_with_original_nearest_contacts:5,receiver_with_direct_contact:3,
      early_known_question_including_transfer:4,late_question_after_required_transfer:6},
    old_access_cannot_transfer:true,new_receiver_contact_not_inferred_from_renaming:true,
    intermediate_support_on_original_sector:scalarText(oldFraction),intermediate_support_on_moving_sector:'1/1',
    failed_transfer_with_local_fourth_noise:scalarText(badSurvival),
    same_final_projector_can_corrupt_logical_content:true,continued_requests:current.history.length,
    active_fourth_participant_not_prepared_or_reset:true,retained_environment_continuation:true,
    all_four_logical_readings_and_reference_checked:true,negative_checks:negatives,
    milliseconds:Math.round(performance.now()-start),physical_admission:null};
  if(outputDirectory){fs.mkdirSync(outputDirectory,{recursive:true});
    fs.writeFileSync(path.join(outputDirectory,'wave-4-moving-source.swift'),'import VerificationIsIdentification\n'+m.sourceCertificate+'\n');
    const certificateFile=path.join(outputDirectory,'wave-4-moving-certificates.json');
    fs.writeFileSync(certificateFile,R.serialize({source:m.source,available,transfer,receiver,direct,early,absent,swap,protection})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_moving_boundary.js'),certificateFile],{encoding:'utf8',timeout:15000});
    assert.equal(cp.status,0,cp.stderr);out.persistedVerifier=JSON.parse(cp.stdout);
    assert.deepEqual(out.persistedVerifier.minimumSections,[1,5,3,4,null]);
    assert.equal(out.persistedVerifier.constructionCalls.normalFormClosures,0);
    out.milliseconds=Math.round(performance.now()-start);
    fs.writeFileSync(path.join(outputDirectory,'wave-4-moving-checks.json'),JSON.stringify(out,null,2)+'\n');}
  return out;
}
if(require.main===module)console.log(JSON.stringify(check(process.argv[2]),null,2));
module.exports={check};
