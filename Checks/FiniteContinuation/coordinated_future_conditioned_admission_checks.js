"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js'),T=require('./coordinated_instrument_transport.js'),W=require('./coordinated_future_conditioned_admission.js');
const {c,z,one,ii,add,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=W.exact;
function check(directory){const t=performance.now(),m=M.currentModel(),d=W.data(m),bundle=W.construct(m),v=W.verify(m,bundle);assert.deepEqual(v.outputRank,c(9));
  // Leaving a chosen fixed code under a known unitary is not by itself loss
  // of the whole quantum content. The old court transports all three readings.
  const noFault={kind:'declared-recorded-instrument',inputDimension:16,outcomes:[{label:'unread',kraus:[d.U]}]},lossless=T.construct(m.base,d.strong,noFault);
  assert(T.verify(m.base,d.strong,noFault,lossless).admitted);
  const base=path.join(__dirname,'../../Research/Artifacts/coordinated-continuation-20260917'),old=R.deserialize(fs.readFileSync(path.join(base,'wave-19-native-realizations.json'),'utf8')),
    certs=R.deserialize(fs.readFileSync(path.join(base,'wave-20-exit-certificates.json'),'utf8'));
  const X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],axis=[eye(2),X,Y,Z],refs=axis.flatMap(A=>axis.map(B=>kron(A,B)));
  const boundary=new W.FutureBoundary(m,d.weak,old.rho,4).enter(certs.entryAvailable,certs.entry),initial=refs.map(O=>boundary.read('Z',O)),encoded=boundary.snapshot().blocks[0].rho;
  const counts={instrument:{...T.counters},entry:{...F.counters},exchange:{...M.counters}};
  boundary.continue(d.first,bundle.weak);refs.forEach((O,i)=>assert.deepEqual(boundary.read('Z',O),initial[i]));
  const middle=boundary.snapshot();boundary.continue(d.next,bundle.next);refs.forEach((O,i)=>assert.deepEqual(boundary.read('Z',O),initial[i]));
  assert.deepEqual({instrument:{...T.counters},entry:{...F.counters},exchange:{...M.counters}},counts);
  const actual=boundary.snapshot();assert.equal(actual.steps,2);assert.equal(actual.blocks.length,1);
  // Keep the unobserved environment instead of reusing a memoryless channel.
  // This one isometry covers the noisy episode; the next action touches only
  // the same source. Partial trace at the end agrees with the owned output.
  const J=d.first.outcomes[0].kraus.flat();eq(mm(adj(J),J),m.I);
  const JE=kron(J,eye(4)),joint=mm(mm(JE,encoded),adj(JE)),nextJoint=kron(kron(eye(2),d.V),eye(4)),jointAfter=mm(mm(nextJoint,joint),adj(nextJoint));
  const traced=mat(64);for(let i=0;i<64;i++)for(let j=0;j<64;j++)traced[i][j]=add(jointAfter[i][j],jointAfter[64+i][64+j]);eq(traced,actual.blocks[0].rho);
  for(const stage of [bundle.weak,bundle.next])for(const output of stage.cases[0].outputs)W.verifyPort(m,d.port,output.frame);
  const direct=tr(mm(actual.blocks[0].rho,kron(d.O,eye(4))));assert.deepEqual(direct,initial[0]);
  const strong=new W.FutureBoundary(m,d.strong,old.rho,4).enter(certs.entryAvailable,certs.entry),before=strong.snapshot();
  assert.throws(()=>strong.continue(d.first,bundle.strong));assert.deepEqual(strong.snapshot(),before);
  // A separating input: a full PT answer remains -1 while the old restricted
  // reading and membership in the old code no longer have that meaning.
  const input=mm(mm(m.operators.Q,old.zeroEncoded),m.operators.Q);let after=mat(16);
  for(const K of d.first.outcomes[0].kraus)after=plus(after,mm(mm(K,input),adj(K)));
  const leakage=tr(mm(minus(m.I,d.support),after)),fullAnswer=tr(mm(d.O,after)),oldRestricted=tr(mm(d.readings[2].operator,after));
  assert.deepEqual(leakage,c(16,0,25));assert.deepEqual(fullAnswer,c(-1));assert.deepEqual(oldRestricted,c(-9,0,25));
  const crosses=mm(mm(d.support,mm(adj(d.first.outcomes[0].kraus[0]),d.first.outcomes[0].kraus[1])),d.support);
  assert(!isZero(comm(crosses,d.readings[0].operator)));assert(isZero(comm(crosses,d.readings[2].operator)));
  let negatives=1;const reject=f=>{assert.throws(f);negatives++;};
  const falsePort=structuredClone(bundle);falsePort.port.operator=d.readings[2].operator;reject(()=>W.verify(m,falsePort));
  const wrongRoot=structuredClone(bundle);wrongRoot.source={};reject(()=>W.verify(m,wrongRoot));reject(()=>W.verify({...m},bundle));
  const fake=structuredClone(bundle);fake.physicalAdmission={admitted:true};reject(()=>W.verify(m,fake));
  const erased=structuredClone(bundle);erased.weak.instrument.outcomes[0].kraus.pop();reject(()=>W.verify(m,erased));
  const zero=structuredClone(bundle);zero.strong.cases[0].witness.commutator=mat(16);reject(()=>W.verify(m,zero));
  const invalidPort=structuredClone(bundle);invalidPort.port.physicalAdmission=true;reject(()=>W.verify(m,invalidPort));
  const wrongStage=structuredClone(bundle);wrongStage.next.instrument=d.first;reject(()=>W.verify(m,wrongStage));
  reject(()=>boundary.read('X'));assert.deepEqual(boundary.snapshot(),actual);
  reject(()=>boundary.enter(certs.entryAvailable,certs.entry));assert.deepEqual(boundary.snapshot(),actual);
  const saved={...T.counters};W.verify(m,bundle);assert.deepEqual(T.counters,saved);
  const result={scope:'Same full instrument admitted for independently fixed PT future and refused for the full logical algebra',
    future_only_PT:true,receiver_port_declared_before_transport:true,weak_admitted:true,strong_admitted:false,
    known_unitary_alone_preserves_full_information_with_moving_representatives:true,full_hidden_alternatives_included:true,
    actual_output_rank:9,old_code_leakage:leakage,independent_full_PT_answer:fullAnswer,old_restricted_question:oldRestricted,
    one_owned_native_input:true,two_continuations:true,all_16_reference_basis_relations:true,visible_acquisition_bits:0,
    same_unobserved_environment_retained_through_later_action:true,full_information_in_joint_isometry:true,refusal_applies_to_source_only_receiver:true,
    construction_calls_during_application:0,negative_checks:negatives,physical_admission:null,milliseconds:Math.round(performance.now()-t)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-25-future-certificates.json');fs.writeFileSync(file,R.serialize(bundle)+'\n',{flag:'wx'});
    fs.writeFileSync(path.join(directory,'wave-25-future-realizations.json'),R.serialize({initial,middle,actual,input,after,crosses,J,traced})+'\n',{flag:'wx'});
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_future_conditioned_admission.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.instrumentConstructionCalls,{constructions:0,pseudoinverses:0,recordPartitions:0});
    result.milliseconds=Math.round(performance.now()-t);fs.writeFileSync(path.join(directory,'wave-25-future-checks.json'),R.serialize(result)+'\n',{flag:'wx'});}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
