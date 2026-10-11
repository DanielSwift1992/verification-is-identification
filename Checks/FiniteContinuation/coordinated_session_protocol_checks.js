"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const A=require('./coordinated_acquired_question.js'),T=require('./coordinated_instrument_transport.js');
const B=require('./coordinated_probe_continuation.js'),S=require('./coordinated_session_protocol.js');
const {eq,mm,eye,kron,tr}=S.exact;
const base=path.resolve(__dirname,'../../Research/Artifacts/coordinated-continuation-20260917');
const counts=()=>({b:{...B.counters},a:{...A.counters},r:{...R.counters},t:{...T.counters}});
function fixture(){const plans=R.deserialize(fs.readFileSync(path.join(base,'wave-10-probe-certificates.json'),'utf8'));
  const actual=R.deserialize(fs.readFileSync(path.join(base,'wave-10-probe-realization.json'),'utf8'));
  return {plans,actual,config:{initialFrame:plans[0].certificate.stage.cases[0].input,
    acquisitionAccess:plans[0].acquisitionAccess,probeAccess:plans[0].probeAccess,controlAccess:plans[0].next[0].access}};}
function prepare(plan,after='entry',certificate=undefined){return {op:'prepare',after,request:plan.request,next:plan.next.map(x=>x.goal),
  ...(certificate?{certificate}:{} )};}
function admitted(result){assert.equal(result.accepted,true,JSON.stringify(result,(_,v)=>typeof v==='bigint'?v.toString():v));return result;}
async function streamCheck(configPath,fixture){const cp=require('node:child_process').spawn(process.execPath,[path.join(__dirname,'coordinated_session_protocol.js'),configPath],{stdio:['pipe','pipe','pipe']});
  let errors='',queue=[],pending=[];cp.stderr.on('data',x=>errors+=x);const lines=require('node:readline').createInterface({input:cp.stdout});
  lines.on('line',line=>{const value=R.deserialize(line);if(pending.length)pending.shift()(value);else queue.push(value);});
  let timer;const deadline=new Promise((_,reject)=>{timer=setTimeout(()=>{cp.kill();reject(new Error('Stateful model console timed out: '+errors));},15000);});
  const trace=[],read=()=>queue.length?Promise.resolve(queue.shift()):new Promise(resolve=>pending.push(resolve));
  const write=async message=>{cp.stdin.write(typeof message==='string'?message+'\n':R.serialize(message)+'\n');const response=await read();
    trace.push({op:typeof message==='string'?'malformed-json':message.op,accepted:response.accepted,kind:response.kind,
      revision:response.revision??response.retainedRevision??null,branches:response.branches??null});return response;};
  const actions=(async()=>{const ready=await read();assert(ready.ready&&ready.physicalAdmission===null);
    const first=admitted(await write(prepare(fixture.plans[0]))),second=admitted(await write(prepare(fixture.plans[1],first.ticket)));
    const supplied={op:'load',rho:fixture.actual.inputWithReference,referenceDimension:2};admitted(await write(supplied));
    const wrong=await write({op:'execute',ticket:second.ticket});assert.equal(wrong.kind,'wrong-occurrence');
    const applied1=admitted(await write({op:'execute',ticket:first.ticket}));assert.equal(applied1.kind,'continued');assert.equal(applied1.revision,1);
    const forged=await write({op:'execute',ticket:second.ticket,actual_a:0});assert.equal(forged.kind,'invalid-message');
    const malformed=await write('{oops');assert.equal(malformed.kind,'invalid-json');assert.equal(malformed.retainedRevision,1);
    const applied2=admitted(await write({op:'execute',ticket:second.ticket}));assert.equal(applied2.kind,'continued');assert.equal(applied2.revision,2);
    const snapshot=admitted(await write({op:'audit-snapshot'}));assert.deepEqual(snapshot.snapshot,fixture.actual.output);
    const status=admitted(await write({op:'status'}));assert.equal(status.revision,2);assert.equal(status.halted,false);
    const exited=new Promise((resolve,reject)=>{cp.on('error',reject);cp.on('exit',code=>code===0?resolve():reject(new Error(errors||`exit ${code}`)));});cp.stdin.end();await exited;
    return {distinct_process:true,queries:2,continued_after_three_rejections:true,revision:status.revision,trace,physicalAdmission:null};})();
  try{return await Promise.race([actions,deadline]);}finally{clearTimeout(timer);if(cp.exitCode===null)cp.kill();lines.close();}
}
async function check(directory){const started=performance.now(),m=C.currentModel(),f=fixture(),session=new S.Session(m,f.config);
  let refusals=0;const denied=(result,kind)=>{assert.equal(result.accepted,false);assert.equal(result.kind,kind);refusals++;return result;};
  const wrongPhase=structuredClone(f.plans[0].certificate);wrongPhase.lowering.word.push({kind:'Sdg',target:0});
  denied(session.handle(prepare(f.plans[0],'entry',wrongPhase)),'invalid-evidence');assert.equal(session.status().tickets,0);
  denied(session.handle({...prepare(f.plans[0]),future:{},actual_a:0}),'invalid-message');assert.equal(session.status().tickets,0);
  const first=admitted(session.handle(prepare(f.plans[0])));
  const second=admitted(session.handle(prepare(f.plans[1],first.ticket,f.plans[1].certificate)));
  denied(session.handle({op:'execute',ticket:first.ticket}),'input-not-loaded');
  // All inputs and capabilities are copied. External mutation grants no access.
  const configCopy=structuredClone(f.config),other=new S.Session(m,configCopy);configCopy.initialFrame.readings=[];
  const imported=admitted(other.handle(prepare(f.plans[0],'entry',f.plans[0].certificate)));
  assert.notEqual(imported.ticket,first.ticket);
  admitted(session.handle({op:'load',rho:f.actual.inputWithReference,referenceDimension:2}));
  let old=admitted(session.handle({op:'audit-snapshot'})).snapshot;
  denied(session.handle({op:'execute',ticket:second.ticket}),'wrong-occurrence');
  denied(session.handle({op:'execute',ticket:imported.ticket}),'unknown-ticket');
  denied(session.handle({op:'load',rho:f.actual.inputWithReference,referenceDimension:2}),'already-loaded');
  assert.deepEqual(admitted(session.handle({op:'audit-snapshot'})).snapshot,old);
  const noBuild=counts();admitted(session.handle({op:'execute',ticket:first.ticket}));
  denied(session.handle({op:'execute',ticket:first.ticket}),'wrong-occurrence');
  denied(session.handle({op:'execute',ticket:second.ticket,record:0}),'invalid-message');
  denied(session.handle({...prepare(f.plans[1],first.ticket),rho:f.actual.inputWithReference}),'invalid-message');
  denied(session.handle(prepare(f.plans[1],first.ticket)),'host-planning-closed');
  admitted(session.handle({op:'execute',ticket:second.ticket}));assert.deepEqual(counts(),noBuild);
  assert.deepEqual(admitted(session.handle({op:'audit-snapshot'})).snapshot,f.actual.output);
  denied(session.handle({op:'audit-reading',name:'new-unpromised-question'}),'outside-declared-future');
  assert.equal(session.status().revision,2);assert.equal(session.status().halted,false);
  const inspected=admitted(session.handle({op:'audit-snapshot'}));inspected.snapshot.blocks[0].record[0].answer^=1;
  assert.deepEqual(admitted(session.handle({op:'audit-snapshot'})).snapshot,f.actual.output);
  for(const reading of f.config.initialFrame.readings){const result=admitted(session.handle({op:'audit-reading',name:reading.name}));
    assert.deepEqual(result.value,tr(mm(f.actual.inputWithReference,kron(reading.operator,eye(2)))));}

  // Reusing a mathematical proof is allowed when the next actual frontier is
  // still covered; reusing its occurrence ticket out of order is not.
  const constant={...f.plans[3],acquisitionAccess:f.config.acquisitionAccess},repeat=new S.Session(m,f.config);
  const r1=admitted(repeat.handle(prepare(constant))),proof=admitted(repeat.handle({op:'export-certificate',ticket:r1.ticket}));
  const r2=admitted(repeat.handle(prepare(constant,r1.ticket,proof.certificate)));
  admitted(repeat.handle({op:'load',rho:f.actual.inputWithReference,referenceDimension:2}));
  admitted(repeat.handle({op:'execute',ticket:r1.ticket}));denied(repeat.handle({op:'execute',ticket:r1.ticket}),'wrong-occurrence');
  admitted(repeat.handle({op:'execute',ticket:r2.ticket}));assert.equal(repeat.status().revision,2);
  // An acquired boundary is smaller and has transported readings. A root
  // certificate cannot silently replace it with the old declared frame.
  const wrongBoundary=new S.Session(m,f.config),parent=admitted(wrongBoundary.handle(prepare(f.plans[0])));
  denied(wrongBoundary.handle(prepare(f.plans[0],parent.ticket,f.plans[0].certificate)),'wrong-boundary');
  assert.equal(wrongBoundary.status().tickets,1);

  const oldAccess={...f.config.acquisitionAccess,partialP:[]};
  const anti=new S.Session(m,{...f.config,acquisitionAccess:oldAccess});
  const antiResult=denied(anti.handle(prepare(f.plans[0])),'proved-access-obstruction');assert.equal(antiResult.evidence.kind,'antiunitary-access-obstruction');
  const forward=new S.Session(m,{...f.config,acquisitionAccess:{...oldAccess,partialP:[[3,4,5]]}});
  denied(forward.handle(prepare(f.plans[0])),'unresolved-template');
  const missing=new S.Session(m,{...f.config,probeAccess:{...f.config.probeAccess,gates:['H','X','CX']}});
  denied(missing.handle(prepare(f.plans[0])),'missing-declared-primitive');
  const inaccessible=new S.Session(m,{...f.config,controlAccess:C.accessModel([[1,0]])});
  const blockedControl=denied(inaccessible.handle(prepare(f.plans[0])),'proved-control-obstruction');assert.equal(blockedControl.evidence.certificate.kind,'fixed-access-obstruction');
  const inconsistent={kind:'source-reading-relations',input:'derived-noncommuting-sector',relations:[
    {after:R.reading(['P']),before:R.reading(['P'])},{after:R.reading(['P']),before:R.reading(['Q'])}]};
  const inconsistentSession=new S.Session(m,f.config),impossible=prepare(f.plans[0]);impossible.next=[inconsistent,inconsistent];
  const blockedAlgebra=denied(inconsistentSession.handle(impossible),'proved-control-obstruction');assert.equal(blockedAlgebra.evidence.certificate.kind,'inconsistent-unitary-relations');
  // An impossible obligation under a globally impossible answer is vacuous.
  // This is proved from the question, not guessed from an expected input.
  const unused=new S.Session(m,f.config),deadBranch=prepare(constant);deadBranch.next[1]=inconsistent;
  const dead=admitted(unused.handle(deadBranch));assert.deepEqual(dead.inactiveAnswers,[1]);
  const liveBranch={...deadBranch,next:[inconsistent,deadBranch.next[0]]};denied(unused.handle(liveBranch),'proved-control-obstruction');
  admitted(unused.handle({op:'load',rho:f.actual.inputWithReference,referenceDimension:2}));
  admitted(unused.handle({op:'execute',ticket:dead.ticket}));assert.equal(unused.status().branches,1);
  const excessiveFrame={...f.config.initialFrame,readings:[...f.config.initialFrame.readings,{name:'additional-P',operator:mm(m.Pi,m.P)}]};
  const future=new S.Session(m,{...f.config,initialFrame:excessiveFrame});denied(future.handle(prepare(f.plans[0])),'proved-future-obstruction');
  const limited=new S.Session(m,{...f.config,maximumBranches:2}),l1=admitted(limited.handle(prepare(f.plans[0]))),l2=admitted(limited.handle(prepare(f.plans[1],l1.ticket)));
  admitted(limited.handle({op:'load',rho:f.actual.inputWithReference,referenceDimension:2}));admitted(limited.handle({op:'execute',ticket:l1.ticket}));
  old=admitted(limited.handle({op:'audit-snapshot'})).snapshot;denied(limited.handle({op:'execute',ticket:l2.ticket}),'host-resource-limit');
  assert.deepEqual(admitted(limited.handle({op:'audit-snapshot'})).snapshot,old);assert.equal(limited.status().halted,false);
  // Model an uncertain completion after the lower operation has committed.
  // The protocol must not claim rollback or silently execute it a second time.
  const interrupted=new S.Session(m,f.config),it=admitted(interrupted.handle(prepare(f.plans[0])));
  admitted(interrupted.handle({op:'load',rho:f.actual.inputWithReference,referenceDimension:2}));
  const original=B.ProbeBoundary.prototype.execute;let invoked=0;
  try{B.ProbeBoundary.prototype.execute=function(...args){invoked++;original.apply(this,args);throw new Error('deliberate failure after model commit');};
    const uncertain=interrupted.handle({op:'execute',ticket:it.ticket});assert.equal(uncertain.kind,'execution-unconfirmed');assert.equal(uncertain.halted,true);
  }finally{B.ProbeBoundary.prototype.execute=original;}
  denied(interrupted.handle({op:'execute',ticket:it.ticket}),'session-halted');denied(interrupted.handle({op:'load',rho:f.actual.inputWithReference}),'session-halted');assert.equal(invoked,1);

  const result={scope:'Stateful local declared-model protocol; no QPU or physical-time guarantee',
    source_loaded_once:true,capabilities_and_promised_future_owned_by_session:true,raw_record_not_a_message_argument:true,
    predecessor_binding_rejects_replay_and_reordering:true,mathematical_proof_reused_at_compatible_later_boundary:true,
    wrong_boundary_certificate_rejected:true,continued_after_rejected_messages:true,construction_calls_during_execution:0,
    host_preparation_closed_after_source_load:true,globally_zero_answer_discharges_its_conditional_goal:true,
    unexpected_post_execution_failure_halts_without_retry:true,refusal_kinds:['proved-access-obstruction','unresolved-template','missing-declared-primitive',
      'proved-control-obstruction','proved-future-obstruction','host-resource-limit','invalid-evidence','wrong-boundary','wrong-occurrence'],
    negative_checks:refusals,physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const configPath=path.join(directory,'wave-11-session-config.json');fs.writeFileSync(configPath,R.serialize(f.config)+'\n');
    result.stream=await streamCheck(configPath,f);result.milliseconds=Math.round(performance.now()-started);
    fs.writeFileSync(path.join(directory,'wave-11-session-checks.json'),JSON.stringify(result,null,2)+'\n');
    fs.writeFileSync(path.join(directory,'wave-11-session-reusable-proof.json'),R.serialize(proof.certificate)+'\n');}
  return result;
}
if(require.main===module)check(process.argv[2]).then(result=>console.log(JSON.stringify(result,null,2))).catch(error=>{console.error(error);process.exitCode=1;});
module.exports={check};
