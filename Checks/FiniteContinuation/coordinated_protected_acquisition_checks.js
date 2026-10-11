"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const T=require('./coordinated_instrument_transport.js'),F=require('./coordinated_protected_acquisition.js');
const {c,z,one,ii,add,sub,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=F.exact;
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]];
const key=C.json,counts=()=>({f:{...F.counters},m:{...M.counters},t:{...T.counters}});
function check(directory){const started=performance.now(),model=M.currentModel(),decompositions=[1,2,3,4].map(n=>F.decomposition(model,n));
  const verified=decompositions.map(p=>F.verifyDecomposition(model,p.n,p));
  assert.deepEqual(verified.map(p=>p.multiplicities),[[1],[1,1],[1,2],[1,3,2]]);
  assert.deepEqual(verified.map(p=>p.protectedAlgebraDimension),[1,2,5,14]);
  const capacities=[1,2,3,4].map(n=>({n,d:2,r:2,certificate:F.capacity(model,decompositions[n-1],2,2)}));
  assert.deepEqual(capacities.map(x=>F.verifyCapacity(model,decompositions[x.n-1],2,2,x.certificate)),[false,false,false,true]);
  assert(F.verifyCapacity(model,decompositions[2],1,2,F.capacity(model,decompositions[2],1,2)));
  const goal={kind:'source-reading-relations',input:'derived-noncommuting-sector',relations:[
    {after:R.reading(['P']),before:R.reading(['Q'])},{after:R.reading(['Q']),before:R.reading(['P'])}]};
  const following={...goal,relations:[{after:R.reading(['P']),before:R.reading(['P'])},{after:R.reading(['Q']),before:R.reading(['P','Q','P'])}]};
  const available=F.access(),plan=F.construct(model,goal,available),secondPlan=F.construct(model,following,available),d=F.verify(model,goal,available,plan);
  const second=F.verify(model,following,available,secondPlan);assert.deepEqual(d.next.map(p=>p.minimumSections),[3,1]);
  assert.deepEqual(d.branches.map(tr),[c(2),c(6)]);
  // Three-spin comparison: a nontrivial protected question uses the same
  // multiplicity qubit, so its projectors cannot retain both P and Q.
  const base=model.base,q=mm(base.Pi,base.Q),projs=[scale(plus(base.Pi,q),c(1,0,2)),scale(minus(base.Pi,q),c(1,0,2))];
  const oldFrame={kind:'declared-generated-star-algebra',support:base.Pi,readings:[{name:'P',operator:mm(base.Pi,base.P)},{name:'Q',operator:q}]};
  const oldInstrument={kind:'declared-recorded-instrument',inputDimension:8,outcomes:projs.map((p,a)=>({label:String(a),kraus:[p]}))};
  const obstruction=T.construct(base,oldFrame,oldInstrument);assert.equal(T.verify(base,oldFrame,oldInstrument,obstruction).admitted,false);
  const gaugeZ=mm(base.Pi,kron(kron(Z,Z),Z)),J3=F.collective(model,3).J;assert(!isZero(comm(J3[0],gaugeZ)));

  // A single unknown four-source/E/reference input. The fourth participant
  // is retained in the same correlated input, never initialized by a method.
  const raw=mat(64,1);for(const [s,e,r,value]of [[5,0,0,1],[9,0,1,1],[4,1,0,1],[8,1,1,2]])raw[(s*2+e)*2+r][0]=c(value);
  const v=mm(kron(d.support,eye(4)),raw),rho=scale(mm(v,adj(v)),div(one,mm(adj(v),v)[0][0]));
  const site=(axis,i)=>Array.from({length:4},(_,j)=>j===i?axis:I2).reduce(kron);
  function background(axis,env,a,b,den){let W=eye(32);for(let i=0;i<4;i++)W=mm(plus(scale(eye(32),c(a,0,den)),scale(kron(site(axis,i),env),c(0,-b,den))),W);
    eq(mm(adj(W),W),eye(32));return W;}
  const W1=background(X,X,3,4,5),W2=mm(kron(model.I,plus(scale(I2,c(12,0,13)),scale(Y,c(0,-5,13)))),background(Z,Z,24,7,25));
  assert(!isZero(comm(W1,W2)));
  const boundary=new F.ProtectedBoundary(model,rho,2,2),reference=[I2,X,Y,Z],beforeReadings={};
  for(const name of ['P','Q','C'])beforeReadings[name]=reference.map(ref=>boundary.read(name,ref));
  const before=counts();boundary.acquire(goal,available,plan,[W1,W2]);assert.deepEqual(counts(),before);
  for(const name of ['P','Q','C'])reference.forEach((ref,i)=>assert.deepEqual(boundary.read(name,ref),beforeReadings[name][i]));
  const afterAcquisition=boundary.snapshot();assert(afterAcquisition.blocks.every(b=>tr(b.rho)[0]>0n));
  const episodes=d.next.map(p=>Array.from({length:Math.max(1,p.word.length)},(_,i)=>i%2?W1:W2));
  boundary.continue(goal,available,plan,episodes);assert.deepEqual(counts(),before);
  reference.forEach((ref,i)=>{assert.deepEqual(boundary.read('P',ref),beforeReadings.Q[i]);assert.deepEqual(boundary.read('Q',ref),beforeReadings.P[i]);
    assert.deepEqual(boundary.read('C',ref),mul(c(-1),beforeReadings.C[i]));});
  const followingEpisodes=second.next.map(p=>Array.from({length:Math.max(1,p.word.length)},()=>W1));
  boundary.continue(following,available,secondPlan,followingEpisodes);assert.deepEqual(counts(),before);
  const totalControl=mm(second.next[0].operator,d.next[0].operator);
  for(const q of d.readings)for(const ref of reference){const expected=tr(mm(rho,kron(mm(mm(adj(totalControl),q.operator),totalControl),kron(I2,ref))));
    assert.deepEqual(boundary.read(q.name,ref),expected);}
  const actual=boundary.snapshot();assert.equal(actual.continuations,2);
  // The full state can change despite exact survival of the promised data.
  const ideal=new F.ProtectedBoundary(model,rho,2,2).acquire(goal,available,plan,[eye(32),eye(32)]);
  ideal.continue(goal,available,plan,episodes.map(row=>row.map(()=>eye(32))));
  ideal.continue(following,available,secondPlan,followingEpisodes.map(row=>row.map(()=>eye(32))));
  assert(actual.blocks.some((b,i)=>!isZero(minus(b.rho,ideal.snapshot().blocks[i].rho))));
  // Record corruption with unchanged marginal frequencies is a different
  // joining: replacing a branch's transported frame already changes a
  // required joint operator. No value-injection argument exists in execute.
  const wrongFrame=mm(mm(plan.frames[1],d.readings[1].operator),adj(plan.frames[1]));
  assert(!isZero(mm(mm(d.branches[0],minus(wrongFrame,d.readings[1].operator)),d.branches[0])));

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  const wrongMult=structuredClone(decompositions[2]);wrongMult.blocks[1].multiplicity=3;rejects(()=>F.verifyDecomposition(model,3,wrongMult));
  const wrongBasis=structuredClone(decompositions[3]);wrongBasis.basis[0][0]=c(2);rejects(()=>F.verifyDecomposition(model,4,wrongBasis));
  const wrongCap=structuredClone(capacities[2].certificate);wrongCap.maximumOutcomes=2;wrongCap.kind='protected-source-question-capacity';rejects(()=>F.verifyCapacity(model,decompositions[2],2,2,wrongCap));
  const wrongQ=structuredClone(plan);wrongQ.question=model.I;rejects(()=>F.verify(model,goal,available,wrongQ));
  const missingReadout=structuredClone(available);delete missingReadout.sectorProbe;rejects(()=>F.construct(model,goal,missingReadout));
  const noPath=structuredClone(available);noPath.controls.pathSemantics='endpoint only';rejects(()=>F.construct(model,goal,noPath));
  const noQ=structuredClone(available);noQ.controls=M.access(['P']);rejects(()=>F.construct(model,goal,noQ));
  const fakePhysical=structuredClone(plan);fakePhysical.physicalAdmission={backend:'unverified'};rejects(()=>F.verify(model,goal,available,fakePhysical));
  rejects(()=>F.verify({...model},goal,available,plan));
  const old=boundary.snapshot();rejects(()=>boundary.acquire(goal,available,plan,[W1,W2]));assert.deepEqual(boundary.snapshot(),old);
  const localZ=kron(site(Z,0),I2),badEpisodes=episodes.map(row=>row.map(()=>localZ));rejects(()=>boundary.continue(goal,available,plan,badEpisodes));assert.deepEqual(boundary.snapshot(),old);
  rejects(()=>boundary.continue(following,available,plan,episodes));assert.deepEqual(boundary.snapshot(),old);
  const outside=mat(64);outside[0][0]=one;rejects(()=>new F.ProtectedBoundary(model,outside,2,2));
  const copy=boundary.snapshot();copy.blocks[0].raw=1;copy.blocks[0].rho=mat(64);assert.deepEqual(boundary.snapshot(),old);
  const verifyBefore=counts();decompositions.forEach(p=>F.verifyDecomposition(model,p.n,p));F.verify(model,goal,available,plan);assert.deepEqual(counts(),verifyBefore);
  const result={scope:'A fixed protected-source boundary carrying a nonconstant projective source record and a common arbitrary qubit; not a lower bound for all dynamic protocols',
    multiplicities:verified.map(p=>p.multiplicities),protected_algebra_dimensions:[1,2,5,14],maximum_qubit_bearing_outcomes:[0,0,1,2],
    explicit_four_spin_support_rank:8,record_branch_ranks:[2,6],same_logical_P_Q_on_both_branches:true,
    readout_derived_from_total_spin_projector:true,record_dependent_next_sections:[3,1],source_loaded_once:true,fourth_participant_not_reset:true,
    one_acquisition_and_two_independent_continuations:true,retained_noncommuting_environment_episodes:true,all_logical_reference_readings_retained:true,
    full_joint_state_changes:true,no_encoder_inferred_from_capacity:true,construction_calls_during_execution:0,negative_checks:negatives,
    physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-17-protected-certificates.json');
    fs.writeFileSync(file,R.serialize({decompositions,capacities,goal,available,plan,secondPlan,following})+'\n');
    fs.writeFileSync(path.join(directory,'wave-17-protected-realization.json'),R.serialize({rho,W1,W2,afterAcquisition,actual,beforeReadings})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_protected_acquisition.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{decompositions:0,constructions:0});
    assert.deepEqual(result.persistedVerifier.movingConstructionCalls,{normalFormClosures:0});assert.deepEqual(result.persistedVerifier.instrumentConstructionCalls,{constructions:0,pseudoinverses:0,recordPartitions:0});
    result.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'wave-17-protected-checks.json'),R.serialize(result)+'\n');}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
