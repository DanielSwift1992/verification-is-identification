"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const A=require('./coordinated_acquired_question.js'),B=require('./coordinated_probe_continuation.js');
const T=require('./coordinated_instrument_transport.js'),G=require('./coordinated_cut_background.js'),P=require('./coordinated_pulse_relation.js');
const F=require('./coordinated_cq_context.js');
const {c,z,one,ii,add,mul,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=F.exact;
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],P0=[[one,z],[z,z]];
const apply=(U,rho)=>mm(mm(U,rho),adj(U));
const read=name=>R.deserialize(fs.readFileSync(path.resolve(__dirname,`../../Research/Artifacts/coordinated-continuation-20260917/${name}`),'utf8'));
const counts=()=>({f:{...F.counters},p:{...P.counters},g:{...G.counters},b:{...B.counters},a:{...A.counters},r:{...R.counters},t:{...T.counters}});
function check(directory){const started=performance.now(),m=C.currentModel(),plans=read('wave-10-probe-certificates.json'),old=read('wave-10-probe-realization.json');
  const first=plans[0].certificate,second=plans[1].certificate,available=G.access(first.probeAccess,['Q']);
  const context=F.context(available,'direct',[kron(I2,m.Q)]),bundle=[];
  const certify=(plan,ctx)=>{const certificate=F.construct(m,plan,ctx);bundle.push({plan,context:ctx,certificate});return certificate;};
  const firstProof=certify(first,context),secondProof=certify(second,context);
  assert(F.verify(m,first,context,firstProof).admitted);assert(F.verify(m,second,context,secondProof).admitted);
  assert.deepEqual(F.verify(m,first,context,firstProof).outputDimensions,[[2,2]]);
  const site=i=>kron(I2,[0,1,2].map(j=>j===i?X:I2).reduce(kron)),Sx=[0,1,2].map(site).reduce(plus);
  const wrongContext=F.context(available,'direct',[Sx]),wrongProof=certify(first,wrongContext);
  const refused=F.verify(m,first,wrongContext,wrongProof);assert.equal(refused.admitted,false);assert(refused.affected.name.startsWith('full-output'));
  // Raw-only evidence is valid for this same collective field. It must not
  // be promoted to a certificate for the previously promised gauge qubit.
  const low=G.programData(m,wrongProof.program,available),rawSpec={kind:'probe-pulse-background-question',program:wrongProof.program,available,
    paths:wrongProof.paths,finalQuestions:[{name:'raw',operator:low.rawQuestion}],generators:low.steps.map(()=>[Sx])};
  const rawOnly=P.construct(m,rawSpec);assert(P.verify(m,rawSpec,rawOnly).admitted);

  // Build branch maps independently of the new admission constructor. They
  // retain one E across both episodes; R is untouched and never reloaded.
  function jointBranches(plan,W){const checked=B.verify(m,plan.request,plan.acquisitionAccess,plan.probeAccess,plan.next,plan),program=plan.acquisition.program;
    const parts=A.instantiate(m,plan.acquisitionAccess),control=name=>name===null?m.I:parts.controls.find(x=>x.name===name).operator;
    const pre=control(program.pre),post=control(program.post);
    return checked.branches.map(b=>{const L=scale(plus(m.I,scale(m[program.readout],c(b.raw?-1:1))),c(1,0,2));
      const tail=mm(checked.nextChecked[b.answer].operator,post);
      return {...b,joint:mm(kron(mm(tail,L),I2),mm(W,kron(pre,I2)))};});}
  // source,E,R ordering, starting with the old retained source/R input and E=0.
  const initial=mat(32);for(let s=0;s<8;s++)for(let t=0;t<8;t++)for(let r=0;r<2;r++)for(let u=0;u<2;u++)
    initial[(s*2)*2+r][(t*2)*2+u]=old.inputWithReference[s*2+r][t*2+u];
  const gaugeX=kron(kron(X,X),X),correlate=plus(scale(eye(32),c(3,0,5)),scale(kron(kron(gaugeX,X),I2),c(0,-4,5)));
  const jointInput=apply(correlate,initial);eq(mm(adj(correlate),correlate),eye(32));
  function traceEnvironment(rho){const out=mat(16);for(let s=0;s<8;s++)for(let t=0;t<8;t++)for(let r=0;r<2;r++)for(let u=0;u<2;u++)
    for(let e=0;e<2;e++)out[s*2+r][t*2+u]=add(out[s*2+r][t*2+u],rho[(s*2+e)*2+r][(t*2+e)*2+u]);return out;}
  const sourceInput=traceEnvironment(jointInput);
  const environmentInput=mat(2);for(let e=0;e<2;e++)for(let f=0;f<2;f++)for(let s=0;s<8;s++)for(let r=0;r<2;r++)
    environmentInput[e][f]=add(environmentInput[e][f],jointInput[(s*2+e)*2+r][(s*2+f)*2+r]);
  const productInput=mat(32);for(let s=0;s<8;s++)for(let t=0;t<8;t++)for(let r=0;r<2;r++)for(let u=0;u<2;u++)for(let e=0;e<2;e++)for(let f=0;f<2;f++)
    productInput[(s*2+e)*2+r][(t*2+f)*2+u]=mul(sourceInput[s*2+r][t*2+u],environmentInput[e][f]);
  assert(!isZero(minus(jointInput,productInput)),'the test must really start with correlated retained context');
  const W1=plus(scale(eye(16),c(24,0,25)),scale(kron(m.Q,X),c(0,-7,25)));
  const W2=mm(kron(m.I,plus(scale(I2,c(3,0,5)),scale(Y,c(0,-4,5)))),
    plus(scale(eye(16),c(12,0,13)),scale(kron(m.Q,Z),c(0,-5,13))));
  eq(mm(adj(W1),W1),eye(16));eq(mm(adj(W2),W2),eye(16));assert(!isZero(comm(W1,W2)));
  const actual1=jointBranches(first,W1),actual2=jointBranches(second,W2),actual=[];
  for(const a of actual1)for(const b of actual2){const joint=mm(b.joint,a.joint),rho=apply(kron(joint,I2),jointInput);
    const idealSource=mm(b.sourceOperator,a.sourceOperator),ideal=apply(kron(idealSource,I2),sourceInput);
    eq(traceEnvironment(rho),ideal);actual.push({record:[{raw:a.raw,answer:a.answer},{raw:b.raw,answer:b.answer}],rho,ideal});}
  assert.deepEqual(actual.reduce((s,b)=>add(s,tr(b.rho)),z),one);
  const firstIdealJoint=mm(actual2[0].sourceOperator,actual1[0].sourceOperator);
  assert(!isZero(minus(actual[0].rho,apply(kron(kron(firstIdealJoint,I2),I2),jointInput))));

  // The complete old logical/gauge continuation now passes through a
  // mandatory context check, using exactly the frozen session plans.
  const config=read('wave-11-session-config.json'),session=new F.ContextSession(m,config,context);
  const prepare=(plan,proof,after='entry')=>({op:'prepare',after,request:plan.request,next:plan.next.map(n=>n.goal),certificate:plan,contextCertificate:proof});
  const yes=r=>{assert.equal(r.accepted,true,r.detail);return r;};let negatives=0;
  const no=(r,kind)=>{assert.equal(r.accepted,false);assert.equal(r.kind,kind);negatives++;return r;};
  no(session.handle({...prepare(first,firstProof),contextCertificate:undefined}),'missing-context-evidence');assert.equal(session.status().tickets,0);
  const bad=new F.ContextSession(m,config,wrongContext);
  no(bad.handle(prepare(first,wrongProof)),'unadmitted-context');assert.equal(bad.status().tickets,0);
  const lowerContext=F.context(available,'lowered',[kron(I2,m.Q)]),lowerProof=F.construct(m,first,lowerContext);
  const lowerSession=new F.ContextSession(m,config,lowerContext);
  no(lowerSession.handle(prepare(first,lowerProof)),'unadmitted-context');assert.equal(lowerSession.status().tickets,0);
  const p1=yes(session.handle(prepare(first,firstProof))),p2=yes(session.handle(prepare(second,secondProof,p1.ticket)));
  yes(session.handle({op:'load',rho:sourceInput,referenceDimension:2}));
  no(session.handle({op:'execute',ticket:p2.ticket}),'wrong-occurrence');
  const before=counts();yes(session.handle({op:'execute',ticket:p1.ticket}));yes(session.handle({op:'execute',ticket:p2.ticket}));assert.deepEqual(counts(),before);
  const snapshot=yes(session.handle({op:'audit-snapshot'})).snapshot;
  assert.equal(snapshot.blocks.length,4);assert.equal(snapshot.steps,2);
  for(const b of snapshot.blocks){const match=actual.find(a=>key(a.record)===key(b.record));assert(match);eq(b.rho,kron(P0,match.ideal));}
  for(const q of config.initialFrame.readings)for(const reference of [I2,X,Y,Z]){
    const r=yes(session.handle({op:'audit-reading',name:q.name,reference}));assert.deepEqual(r.value,tr(mm(sourceInput,kron(q.operator,reference))));}
  no(session.handle({op:'execute',ticket:p2.ticket}),'wrong-occurrence');
  no(session.handle({op:'execute',ticket:p2.ticket,record:0}),'invalid-message');
  no(session.handle({op:'load',rho:sourceInput,referenceDimension:2}),'already-loaded');

  // Explicit separator: the collective field leaves all record weights
  // intact but changes retained gauge Z. This is not just a failed test.
  const gaugeZ=mm(m.Pi,kron(kron(Z,Z),Z)),polarized=scale(plus(m.Pi,gaugeZ),c(1,0,4));
  const u=plus(scale(I2,c(3,0,5)),scale(X,c(0,-4,5))),collective=kron(kron(u,u),u);
  const idealChecked=B.verify(m,first.request,first.acquisitionAccess,first.probeAccess,first.next,first);
  let normal=z,damaged=z;
  for(let j=0;j<idealChecked.branches.length;j++){const K=idealChecked.branches[j].sourceOperator,ideal=apply(K,polarized),noisy=apply(collective,ideal);
    assert.deepEqual(tr(noisy),tr(ideal));const O=first.stage.cases[0].outputs[j].frame.readings.find(q=>q.name==='retained-2').operator;
    normal=add(normal,tr(mm(ideal,O)));damaged=add(damaged,tr(mm(noisy,O)));}
  assert.deepEqual(normal,one);assert.deepEqual(damaged,c(-7,0,25));

  const rejects=fn=>{assert.throws(fn);negatives++;};
  const rawSubstitution=structuredClone(firstProof);rawSubstitution.pulse=rawOnly;rejects(()=>F.verify(m,first,context,rawSubstitution));
  const omitted=structuredClone(firstProof);omitted.pulse.spec.finalQuestions.pop();rejects(()=>F.verify(m,first,context,omitted));
  const wrongDual=structuredClone(firstProof);wrongDual.ranges[0][0].dual[0]=wrongDual.ranges[0][0].dual[0].map(()=>z);rejects(()=>F.verify(m,first,context,wrongDual));
  const wrongPlan=structuredClone(first);wrongPlan.next.reverse();rejects(()=>F.verify(m,wrongPlan,context,firstProof));
  const missingRest=structuredClone(context);delete missingRest.remainingEpisode;rejects(()=>F.construct(m,first,missingRest));
  const everywhere=structuredClone(context);everywhere.backgroundScope='entire-execution';rejects(()=>F.construct(m,first,everywhere));
  const fakePhysical=structuredClone(firstProof);fakePhysical.physicalAdmission={backend:'unverified'};rejects(()=>F.verify(m,first,context,fakePhysical));
  rejects(()=>F.verify({...m},first,context,firstProof));
  rejects(()=>F.construct(m,plans[3].certificate,context)); // unsupported constant template, not impossibility
  const different=new F.ContextSession(m,config,wrongContext);no(different.handle(prepare(first,firstProof)),'invalid-context-evidence');assert.equal(different.status().tickets,0);
  const calls=counts();bundle.forEach(b=>F.verify(m,b.plan,b.context,b.certificate));assert.deepEqual(counts(),calls);
  const opposite=plans[4].certificate,oppositeProof=F.construct(m,opposite,context);assert(F.verify(m,opposite,context,oppositeProof).admitted);
  assert.deepEqual(opposite.acquisition.program.decoder,[1,0]);
  const result={scope:'The frozen complete cq continuations, with uniform retained background during coherent probe segments and an explicitly ideal remainder',
    original_full_quantum_future_retained:true,source_record_reference_complete_output_basis:true,
    original_two_plans_and_live_session_used:true,source_loaded_once:true,four_joint_branches_match_after_tracing_same_environment:true,
    initially_correlated_environment:true,noncommuting_environment_episodes:true,environment_state_not_restored_or_reset:true,
    all_original_readings_with_reference_retained:true,mandatory_context_guard_before_ticket_creation:true,
    raw_only_certificate_rejected:true,equal_ideal_lowered_implementation_not_admitted:true,
    collective_field_separator:{raw_weights:'unchanged',gauge_Z_ideal:'1',gauge_Z_actual:'-7/25'},
    actual_raw_to_negated_answer_binding:true,construction_calls_during_execution:0,negative_checks:negatives,physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-15-cq-certificates.json');fs.writeFileSync(file,R.serialize(bundle)+'\n');
    fs.writeFileSync(path.join(directory,'wave-15-cq-realizations.json'),R.serialize({jointInput,sourceInput,W1,W2,actual,sessionOutput:snapshot,
      collectiveFieldWitness:{polarized,collective,normal,damaged}})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_cq_context.js'),file],{encoding:'utf8',timeout:20000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{rangeConstructions:0,constructions:0});
    assert.deepEqual(result.persistedVerifier.probeConstructionCalls,{lowerings:0,compilations:0});assert.deepEqual(result.persistedVerifier.pulseConstructionCalls,{declarations:0,constructions:0});
    result.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'wave-15-cq-checks.json'),R.serialize(result)+'\n');}
  return result;
}
const key=C.json;
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
