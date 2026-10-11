"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),D=require('./coordinated_dynamic_instrument.js'),T=require('./coordinated_instrument_transport.js');
const {c,z,one,ii,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,scalarText}=T.exact;
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]];
const frame=(support,entries)=>({kind:'declared-generated-star-algebra',support,readings:entries.map(([name,operator])=>({name,operator}))});
const instrument=(n,outcomes)=>({kind:'declared-recorded-instrument',inputDimension:n,outcomes:outcomes.map(([label,kraus])=>({label,kraus}))});
const expectation=(rho,O)=>tr(mm(rho,O));
function check(outputDirectory){const start=performance.now(),m=C.currentModel();
  const f=frame(I2,[['x',X],['z',Z]]),U=plus(scale(I2,c(3,0,5)),scale(Z,c(0,-4,5))),rotation=instrument(2,[['move',[U]]]);
  const rotate=T.construct(m,f,rotation);assert.equal(rotate.kind,'instrument-algebra-transport');
  eq(rotate.outputs[0].frame.readings[0].operator,plus(scale(X,c(-7,0,25)),scale(Y,c(24,0,25))));
  eq(rotate.outputs[0].frame.readings[1].operator,Z);
  const alpha=c(1,1,2),k0=scale(I2,alpha),k1=scale(Z,alpha);
  const visible=instrument(2,[['0',[k0]],['1',[k1]]]),hidden=instrument(2,[['unread',[k0,k1]]]);
  const kept=T.construct(m,f,visible),lost=T.construct(m,f,hidden);
  assert.equal(kept.kind,'instrument-algebra-transport');assert.equal(lost.kind,'instrument-transport-obstruction');
  assert.notEqual(lost.witness.left,lost.witness.right,'diagonal effects alone must all pass in this example');
  for(const K of [k0,k1]){eq(mm(adj(K),K),scale(I2,c(1,0,2)));for(const O of [X,Z])assert(isZero(comm(mm(adj(K),K),O)));}
  const plusState=scale(plus(I2,X),c(1,0,2)),minusState=scale(minus(I2,X),c(1,0,2));
  const output=rho=>plus(mm(mm(k0,rho),adj(k0)),mm(mm(k1,rho),adj(k1)));
  eq(output(plusState),output(minusState));
  // A visible outcome does not identify one coherent amplitude: the hidden
  // CP sum and a coherent sum can have the same (constant) output record.
  const phased=scale(k1,ii),coherent=plus(k0,phased);eq(mm(adj(coherent),coherent),I2);
  const coherentInstrument=instrument(2,[['unread',[coherent]]]),coherentProof=T.construct(m,f,coherentInstrument);
  assert.equal(coherentProof.kind,'instrument-algebra-transport');
  eq(output(plusState),plus(mm(mm(k0,plusState),adj(k0)),mm(mm(phased,plusState),adj(phased))));
  assert(!isZero(minus(output(plusState),mm(mm(coherent,plusState),adj(coherent)))));
  const classical=frame(I2,[['z',Z]]),zOnly=T.construct(m,classical,hidden);assert.equal(zOnly.kind,'instrument-algebra-transport');
  // Change the unobserved Kraus basis without changing the physical map.
  const l0=plus(scale(k0,c(3,0,5)),scale(k1,c(4,0,5))),l1=plus(scale(k0,c(-4,0,5)),scale(k1,c(3,0,5)));
  for(let i=0;i<2;i++)for(let j=0;j<2;j++){const E=mat(2);E[i][j]=one;
    eq(output(E),plus(mm(mm(l0,E),adj(l0)),mm(mm(l1,E),adj(l1))));}
  assert.equal(T.construct(m,f,instrument(2,[['unread',[l0,l1]]])).kind,'instrument-transport-obstruction');

  // Rectangular transition: the declared joint carrier changes dimension.
  const V=mat(4,2);V[0][0]=one;V[3][1]=one;
  const embedding=instrument(2,[['same-content-new-carrier',[V]]]),embedded=T.construct(m,f,embedding);
  eq(embedded.outputs[0].frame.support,mm(V,adj(V)));
  for(const q of f.readings)eq(embedded.outputs[0].frame.readings.find(o=>o.name===q.name).operator,mm(mm(V,q.operator),adj(V)));
  const bell=mat(4);for(const i of [0,3])for(const j of [0,3])bell[i][j]=c(1,0,2);
  const changed=new T.InstrumentBoundary(m,f,bell,2);changed.continue(embedding,T.deriveStage(m,changed.frontier(),embedding));
  assert.deepEqual(changed.read('x',X),one);assert.deepEqual(changed.read('z',Z),one);
  // Returning along the isometry is complete only on the actual encoded cut.
  const returning=instrument(4,[['return',[adj(V)]]]);changed.continue(returning,T.deriveStage(m,changed.frontier(),returning));eq(changed.snapshot().blocks[0].rho,bell);

  // Infer record requirements from full branch compatibility, without supplying
  // the previous affine decoder. This does not assume a Pauli output catalog.
  const cycle=D.compileCycle(m,['XX','ZI','XX','IZ']),leaves=D.verifyCycle(m,cycle).leaves;
  const logical=frame(eye(4),[['x',D.pauli('XI')],['z',D.pauli('ZZ')]]);
  const fine=instrument(4,leaves.map(b=>[b.outcomes.join(''),[b.K]])),memory=T.deriveRecordPartition(m,logical,fine);
  assert.equal(memory.kind,'minimal-one-or-two-record-classes');assert.equal(memory.minimumClasses,2);
  assert.deepEqual(memory.classes,leaves.map(b=>b.outcomes[0]^b.outcomes[2]));
  const allForgotten=T.construct(m,logical,T.coarsen(fine,Array(16).fill(0)));assert.equal(allForgotten.kind,'instrument-transport-obstruction');
  const grouped=T.coarsen(fine,memory.classes),refInput=mat(8);for(const i of [0,5])for(const j of [0,5])refInput[i][j]=c(1,0,2);
  const recorded=new T.InstrumentBoundary(m,logical,refInput,2);recorded.continue(grouped,T.deriveStage(m,recorded.frontier(),grouped));
  assert.deepEqual(recorded.read('x',X),one);assert.deepEqual(recorded.read('z',Z),one);
  // The next actual step is non-Pauli and uses the current record-conditioned
  // output frame, not an input re-prepared from the promised answer.
  const afterCycleRotation=instrument(4,[['move',[kron(U,I2)]]]);
  recorded.continue(afterCycleRotation,T.deriveStage(m,recorded.frontier(),afterCycleRotation));
  assert.deepEqual(recorded.read('x',X),one);assert.deepEqual(recorded.read('z',Z),one);assert.equal(recorded.snapshot().steps,2);
  assert.equal(T.deriveRecordPartition(m,f,hidden).kind,'unavailable-record-refinement');
  assert.equal(T.deriveRecordPartition(m,f,rotation).minimumClasses,1);
  // Admissible merging need not be an equivalence relation when the physical
  // output also carries usable context. There need not be one least partition.
  const V0=mat(4,2),V1=mat(4,2);V0[0][0]=one;V0[2][1]=one;V1[1][0]=one;V1[3][1]=one;
  const contextual=instrument(2,[['a',[scale(V0,c(1,0,2))]],['b',[scale(V1,alpha)]],['c',[scale(mm(V0,Z),c(1,0,2))]]]);
  const partitions=[[0,0,1],[0,1,1]],contextCertificates=partitions.map(classes=>T.construct(m,f,T.coarsen(contextual,classes)));
  assert(contextCertificates.every(p=>p.kind==='instrument-algebra-transport'));
  const forbiddenAC=T.construct(m,f,T.coarsen(contextual,[0,1,0]));assert.equal(forbiddenAC.kind,'instrument-transport-obstruction');
  const noClass=T.construct(m,f,T.coarsen(contextual,[0,0,0]));assert.equal(noClass.kind,'instrument-transport-obstruction');
  const contextualMemory=T.deriveRecordPartition(m,f,contextual);assert.equal(contextualMemory.minimumClasses,2);

  // Integrate the same verifier with independent requests resolved from the
  // current Swift exchange root. Hidden gauge dynamics remains explicit.
  const e=R.reading,goal=relations=>({kind:'source-reading-relations',input:'derived-noncommuting-sector',relations});
  const q1=goal([{after:e(['P']),before:e(['Q'])},{after:e(['Q']),before:e(['P'])}]);
  const q2=goal([{after:e(['Q']),before:e(['Q'])},{after:e(['P']),before:e(['Q','P','Q'])}]);
  const access=C.accessModel([[1,0],[0,1],[1,1]]),r1=R.resolve(m,q1,access),r2=R.resolve(m,q2,access);
  const U1=R.verify(m,q1,access,r1).operator,U2=R.verify(m,q2,access,r2).operator;
  const sourceFrame=frame(m.Pi,[['P',mm(m.Pi,m.P)],['Q',mm(m.Pi,m.Q)]]),v=mat(16,1);
  for(const [i,a]of [[2,2],[4,-1],[8,-1],[5,1],[9,-1]])v[i][0]=c(a);
  const rho=scale(mm(v,adj(v)),c(1,0,8)),live=new T.InstrumentBoundary(m,sourceFrame,rho,2),reference=[I2,X,Y,Z];
  const initial=sourceFrame.readings.map(q=>reference.map(B=>expectation(rho,kron(q.operator,B))));
  const instruments=[instrument(8,[['first-request',[U1]]]),
    instrument(8,[['unread-gauge',[scale(m.I,c(3,0,5)),scale(kron(kron(X,X),X),c(4,0,5))]]]),
    instrument(8,[['second-request',[U2]]])];
  const stages=[];
  for(const inst of instruments){const stage=T.deriveStage(m,live.frontier(),inst);stages.push(stage);live.continue(inst,stage);
    sourceFrame.readings.forEach((q,j)=>reference.forEach((B,k)=>assert.deepEqual(live.read(q.name,B),initial[j][k])));}
  const actual=live.snapshot().blocks[0].rho,U12=kron(mm(U2,U1),I2),ideal=mm(mm(U12,rho),adj(U12));
  assert(!isZero(minus(actual,ideal)));assert.notDeepEqual(tr(mm(actual,actual)),one,'hidden gauge should actually change the retained state');
  for(const O of [mm(m.Pi,m.P),mm(m.Pi,m.Q)])for(const B of reference)
    assert.deepEqual(expectation(actual,kron(O,B)),expectation(ideal,kron(O,B)));

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  rejects(()=>T.verify(m,f,rotation,lost));
  rejects(()=>T.verify(m,f,hidden,coherentProof));
  const forged=structuredClone(rotate);forged.outputs[0].frame.readings[0].operator=X;rejects(()=>T.verify(m,f,rotation,forged));
  const fakeRange=structuredClone(embedded);fakeRange.outputs[0].frame.support=eye(4);rejects(()=>T.verify(m,f,embedding,fakeRange));
  const fakeWitness=structuredClone(lost);fakeWitness.witness.right=fakeWitness.witness.left;rejects(()=>T.verify(m,f,hidden,fakeWitness));
  rejects(()=>T.construct(m,f,instrument(2,[['incomplete',[scale(I2,c(1,0,2))]]])));
  const fakeMemory=structuredClone(memory);fakeMemory.classes.fill(0);rejects(()=>T.verifyRecordPartition(m,logical,fine,fakeMemory));
  const falseAdmission=structuredClone(rotate);falseAdmission.physicalAdmission={backend:'not-established'};rejects(()=>T.verify(m,f,rotation,falseAdmission));
  rejects(()=>T.verify({...m},f,rotation,rotate));
  const old=live.snapshot();rejects(()=>live.continue(instruments[0],stages[0]));assert.deepEqual(live.snapshot(),old);
  rejects(()=>live.read('undeclared-reading'));
  const before={...T.counters};
  for(const [F,I,P]of [[f,rotation,rotate],[f,hidden,lost],[classical,hidden,zOnly],[f,embedding,embedded]])T.verify(m,F,I,P);
  T.verifyRecordPartition(m,logical,fine,memory);assert.deepEqual(T.counters,before);
  const out={scope:'Exact generated-algebra transport through declared visible and hidden instrument alternatives',
    criterion:'Within each available record: [Pi K_mu† K_nu Pi,O]=0 for every declared generator and all hidden pairs',
    non_Pauli_rotated_X:['-7/25 X','24/25 Y'],rectangular_carrier_transition:[2,4,2],
    same_diagonal_effects_but_hidden_cross_obstruction:true,retaining_actual_record_admitted:true,
    identical_visible_effect_does_not_license_coherent_sum:true,
    same_hidden_channel_admitted_for_Z_algebra:true,Kraus_basis_change_same_channel_same_refusal:true,
    dynamic_cycle_records:16,derived_minimum_record_classes:memory.minimumClasses,derived_record_partition:'a XOR c',
    admissible_record_merging_is_not_transitive:true,incomparable_minimum_partitions:partitions,
    no_unique_least_admissible_partition:true,
    continuation_after_dynamic_cycle:'actual record-conditioned carrier followed by non-Pauli unitary',
    live_Swift_independent_requests:2,explicit_hidden_gauge_episode_between_requests:true,
    full_output_changes_but_logical_reference_content_agrees:true,negative_checks:negatives,
    verification_repeats_no_construction:true,physical_admission:null,milliseconds:Math.round(performance.now()-start)};
  if(outputDirectory){fs.mkdirSync(outputDirectory,{recursive:true});const file=path.join(outputDirectory,'wave-6-instrument-certificates.json');
    const bundle=[{frame:f,instrument:rotation,certificate:rotate},{frame:f,instrument:hidden,certificate:lost},
      {frame:classical,instrument:hidden,certificate:zOnly},{frame:f,instrument:embedding,certificate:embedded},
      {frame:logical,instrument:fine,certificate:memory},
      ...partitions.map((classes,i)=>({frame:f,instrument:T.coarsen(contextual,classes),certificate:contextCertificates[i]})),
      {frame:f,instrument:T.coarsen(contextual,[0,0,0]),certificate:noClass}];
    fs.writeFileSync(file,R.serialize(bundle)+'\n');
    fs.writeFileSync(path.join(outputDirectory,'wave-6-source-continuation.json'),R.serialize({q1,q2,access,r1,r2,sourceFrame,instruments,stages})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_instrument_transport.js'),file],{encoding:'utf8',timeout:15000});
    assert.equal(cp.status,0,cp.stderr);out.persistedVerifier=JSON.parse(cp.stdout);
    assert.deepEqual(out.persistedVerifier.constructionCalls,{constructions:0,pseudoinverses:0,recordPartitions:0});
    out.milliseconds=Math.round(performance.now()-start);
    fs.writeFileSync(path.join(outputDirectory,'wave-6-instrument-checks.json'),JSON.stringify(out,null,2)+'\n');}
  return out;
}
if(require.main===module)console.log(JSON.stringify(check(process.argv[2]),null,2));
module.exports={check};
