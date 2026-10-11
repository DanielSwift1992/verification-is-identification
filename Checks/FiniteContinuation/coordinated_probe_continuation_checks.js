"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const A=require('./coordinated_acquired_question.js'),T=require('./coordinated_instrument_transport.js'),B=require('./coordinated_probe_continuation.js');
const {c,z,one,ii,add,mat,eye,scale,plus,minus,adj,mm,kron,tr,eq,isZero}=B.exact;
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],P0=[[one,z],[z,z]];
const apply=(K,rho)=>mm(mm(K,rho),adj(K)),e=R.reading;
const goal=relations=>({kind:'source-reading-relations',input:'derived-noncommuting-sector',relations});
function check(directory){const started=performance.now(),m=C.currentModel(),primitives=B.primitiveAccess();
  const p=B.lowerReadout(m,'P',primitives),q=B.lowerReadout(m,'Q',primitives);
  const lowered=B.verifyReadout(m,'Q',primitives,q),n=m.I.length;
  assert.deepEqual(q.word,[{kind:'CX',controls:[3],target:2},{kind:'CCX',controls:[0,2],target:3},{kind:'CX',controls:[3],target:2}]);
  assert.deepEqual(p.word,[{kind:'CX',controls:[2],target:1},{kind:'CCX',controls:[0,1],target:2},{kind:'CX',controls:[2],target:1}]);
  // All complex source amplitudes are covered by the exact full operators.
  // The finite basis loop checks the source address convention independently.
  for(let x=0;x<16;x++){
    const bits=[3,2,1,0].map(j=>(x>>j)&1),expected=bits.slice();if(bits[0])[expected[2],expected[3]]=[bits[3],bits[2]];
    const y=expected.reduce((s,b)=>2*s+b,0);for(let row=0;row<16;row++)assert.deepEqual(lowered.controlled[row][x],row===y?one:z);
  }
  const channelSame=scale(m.Q,c(0,-1));
  // Equality of source channels is exact, including arbitrary references;
  // their controlled extensions do not have the same probe effects.
  const choi=U=>{const vec=U.flat().map(x=>[x]);return mm(vec,adj(vec));};eq(choi(channelSame),choi(m.Q));
  const wrongW=B.probeSandwich(B.controlled(channelSame));
  const wrongRaw=[0,1].map(a=>wrongW.slice(a*n,(a+1)*n).map(row=>row.slice(0,n)));
  wrongRaw.forEach(K=>eq(mm(adj(K),K),scale(m.I,c(1,0,2))));
  assert(!isZero(minus(mm(adj(wrongRaw[0]),wrongRaw[0]),lowered.sourceOperators[0])));

  const controls=C.accessModel([[1,0],[0,1],[1,1]]);
  const identity=goal([{after:e(['P']),before:e(['P'])},{after:e(['Q']),before:e(['Q'])}]);
  const pGoal=goal([{after:e(['P']),before:e(['P'])},{after:e(['Q']),before:e(['P','Q','P'])}]);
  const swap=goal([{after:e(['P']),before:e(['Q'])},{after:e(['Q']),before:e(['P'])}]);
  const qGoal=goal([{after:e(['Q']),before:e(['Q'])},{after:e(['P']),before:e(['Q','P','Q'])}]);
  const next=[{goal:swap,access:controls},{goal:qGoal,access:controls}],next2=[{goal:identity,access:controls},{goal:pGoal,access:controls}];
  const acquisitionAccess={kind:'declared-source-acquisition-access',quarterDirections:[[1,0],[0,1],[1,1]],partialP:[[3,4,5],[3,-4,5]],readouts:['P','Q']};
  const U=plus(scale(m.I,c(3,0,5)),scale(m.P,c(0,-4,5))),O=mm(mm(adj(U),mm(m.Pi,m.Q)),U);
  const request={kind:'projective-acquisition',question:O,returnFrame:'input'};
  const gauge=[X,Y,Z].map(G=>mm(m.Pi,kron(kron(G,G),G)));
  const frame={kind:'declared-generated-star-algebra',support:m.Pi,readings:[{name:'acquired',operator:O},
    ...gauge.map((operator,i)=>({name:`retained-${i}`,operator}))]};
  const plan=B.compile(m,request,acquisitionAccess,primitives,next,[frame]);
  const request2={...request,question:mm(m.Pi,m.Q)};
  const frames2=plan.stage.cases[0].outputs.map(o=>o.frame).filter(Boolean);
  const plan2=B.compile(m,request2,acquisitionAccess,primitives,next2,frames2);
  // Plans, all branch choices and future-transport witnesses exist before
  // loading the source. No search takes place while that source is retained.
  const v=mat(16,1);for(const [i,a]of [[2,2],[4,-1],[8,-1],[5,1],[9,-1]])v[i][0]=c(a);
  const rho=scale(mm(v,adj(v)),c(1,0,8)),boundary=new B.ProbeBoundary(m,frame,rho,2);
  const counts=()=>({probe:{...B.counters},acquisition:{...A.counters},relation:{...R.counters},transport:{...T.counters}}),before=counts();
  boundary.execute(request,acquisitionAccess,primitives,next,plan).execute(request2,acquisitionAccess,primitives,next2,plan2);
  assert.deepEqual(counts(),before);const actual=boundary.snapshot();assert.equal(actual.steps,2);assert.equal(actual.blocks.length,4);
  const checked1=B.verify(m,request,acquisitionAccess,primitives,next,plan),checked2=B.verify(m,request2,acquisitionAccess,primitives,next2,plan2);
  let weights=[];for(const b of actual.blocks){const [a,d]=b.record.map(r=>r.answer);
    const K=mm(checked2.branches.find(x=>x.answer===d).sourceOperator,checked1.branches.find(x=>x.answer===a).sourceOperator);
    eq(b.rho,kron(P0,apply(kron(K,I2),rho)));weights.push(tr(b.rho));}
  assert(weights.filter(x=>x[0]>0n).length>1);
  for(const ref of [I2,X,Y,Z]){
    assert.deepEqual(boundary.inspect('acquired',ref),tr(mm(rho,kron(O,ref))));
    gauge.forEach((G,i)=>assert.deepEqual(boundary.inspect(`retained-${i}`,ref),tr(mm(rho,kron(G,ref)))));
  }
  // The same record frequencies do not license replacing the actual branch
  // with an independently chosen following program.
  const gaugeFrame={...frame,readings:frame.readings.slice(1)},simple=B.compile(m,request2,acquisitionAccess,primitives,next2,[gaugeFrame]);
  const mixed=scale(m.Pi,c(1,0,4)),bSimple=new B.ProbeBoundary(m,gaugeFrame,mixed);
  bSimple.execute(request2,acquisitionAccess,primitives,next2,simple);
  const reduced=bSimple.snapshot().blocks.reduce((s,b)=>plus(s,b.rho.slice(0,8).map(row=>row.slice(0,8))),mat(8));
  assert.deepEqual(tr(mm(reduced,m.Q)),c(3,0,4));
  const rawBranches=[0,1].map(a=>apply(scale(plus(m.Pi,scale(mm(m.Pi,m.Q),c(a?-1:1))),c(1,0,2)),mixed));
  let independent=mat(8);for(const rhoA of rawBranches)for(const V of [m.I,m.P])independent=plus(independent,scale(apply(V,rhoA),c(1,0,2)));
  assert.deepEqual(tr(mm(independent,m.Q)),z);

  // Constant and negated questions use the actual acquisition semantics;
  // neither implicitly allocates another measurement nor accepts a fake bit.
  const constantRequest={...request,question:m.Pi},noRead={...acquisitionAccess,readouts:[],partialP:[],quarterDirections:[]};
  const noGates={...primitives,gates:[]};const constant=B.compile(m,constantRequest,noRead,noGates,next2,[gaugeFrame]);
  assert.equal(constant.lowering,null);const constBoundary=new B.ProbeBoundary(m,gaugeFrame,mixed);constBoundary.execute(constantRequest,noRead,noGates,next2,constant);
  eq(constBoundary.snapshot().blocks[0].rho,kron(P0,mixed));assert.deepEqual(constBoundary.snapshot().blocks[0].record,[{raw:null,answer:0}]);
  const oppositeRequest={...request2,question:scale(request2.question,c(-1))};
  const opposite=B.compile(m,oppositeRequest,acquisitionAccess,primitives,next2,[gaugeFrame]);
  const oppositeBoundary=new B.ProbeBoundary(m,gaugeFrame,mixed);oppositeBoundary.execute(oppositeRequest,acquisitionAccess,primitives,next2,opposite);
  oppositeBoundary.snapshot().blocks.forEach(b=>assert.equal(b.record[0].answer,1-b.record[0].raw));

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  const wrongPhase=structuredClone(q);wrongPhase.word.push({kind:'Sdg',target:0});rejects(()=>B.verifyReadout(m,'Q',primitives,wrongPhase));
  const wrongPair=structuredClone(q);wrongPair.word=p.word;rejects(()=>B.verifyReadout(m,'Q',primitives,wrongPair));
  const noCCX={...primitives,gates:primitives.gates.filter(x=>x!=='CCX')};rejects(()=>B.lowerReadout(m,'Q',noCCX));
  rejects(()=>B.lowerReadout(m,'Q',{...primitives,probePreparation:'unknown'}));
  rejects(()=>B.lowerReadout(m,'Q',{...primitives,permutationEntries:'known-classical-table-only'}));
  const wrongReset=structuredClone(q);wrongReset.reset='expected-answer';rejects(()=>B.verifyReadout(m,'Q',primitives,wrongReset));
  const badPlan=structuredClone(plan);badPlan.nextCertificates.reverse();
  const clean=new B.ProbeBoundary(m,frame,rho,2),snapshot=clean.snapshot();rejects(()=>clean.execute(request,acquisitionAccess,primitives,next,badPlan));assert.deepEqual(clean.snapshot(),snapshot);
  const badLowering=structuredClone(plan);badLowering.lowering.word.push({kind:'Sdg',target:0});rejects(()=>clean.execute(request,acquisitionAccess,primitives,next,badLowering));assert.deepEqual(clean.snapshot(),snapshot);
  const wrongDecoder=structuredClone(plan);wrongDecoder.acquisition.program.decoder.reverse();rejects(()=>clean.execute(request,acquisitionAccess,primitives,next,wrongDecoder));assert.deepEqual(clean.snapshot(),snapshot);
  const wrongPhysical=structuredClone(plan);wrongPhysical.physicalAdmission={backend:'unverified'};rejects(()=>clean.execute(request,acquisitionAccess,primitives,next,wrongPhysical));
  rejects(()=>B.verify({...m},request,acquisitionAccess,primitives,next,plan));
  const missingFuture=structuredClone(plan);missingFuture.stage.cases=[];rejects(()=>clean.execute(request,acquisitionAccess,primitives,next,missingFuture));
  const excessive={...frame,readings:[...frame.readings,{name:'incompatible-future',operator:mm(m.Pi,m.P)}]};
  rejects(()=>B.compile(m,request,acquisitionAccess,primitives,next,[excessive]));
  // Modifying a returned snapshot cannot replace an owned record or carrier.
  const exposed=boundary.snapshot();exposed.blocks[0].record[0].answer^=1;exposed.blocks[0].rho=mat(32);assert.deepEqual(boundary.snapshot(),actual);

  const result={scope:'Declared ideal phase-fixed primitives; complete same-carrier continuation, no hardware admission',
    live_source_readouts:['P','Q'],controlled_swap_basis_cases:16,probe_return:'zero using the same raw record',
    equivalent_uncontrolled_channels_can_have_different_probe_effects:true,wrong_controlled_phase_effects:'I/2 for both records',
    independently_requested_episodes:2,retained_actual_branches:4,source_repreparations_after_input:0,
    second_plan_compiled_before_source_loaded:true,execution_construction_calls:0,arbitrary_reference_full_branch_identity:true,
    retained_noncommuting_content_and_reference:true,actual_record_test:{correct_mean_Q:'3/4',independent_record_same_frequencies_mean_Q:'0'},
    constant_question_reads:0,negative_question_uses_same_raw_record:true,negative_checks:negatives,rejection_before_mutation:true,
    physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-10-probe-certificates.json');
    const entry=(request,access,next,certificate,probeAccess=primitives)=>({request,acquisitionAccess:access,probeAccess,next,certificate});
    fs.writeFileSync(file,R.serialize([entry(request,acquisitionAccess,next,plan),entry(request2,acquisitionAccess,next2,plan2),
      entry(request2,acquisitionAccess,next2,simple),entry(constantRequest,noRead,next2,constant,noGates),entry(oppositeRequest,acquisitionAccess,next2,opposite)])+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_probe_continuation.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=JSON.parse(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{lowerings:0,compilations:0});
    assert.deepEqual(result.persistedVerifier.acquisitionConstructionCalls,{constructions:0});assert.deepEqual(result.persistedVerifier.relationConstructionCalls,{linearSolves:0,normalFormClosures:0});
    assert.deepEqual(result.persistedVerifier.transportConstructionCalls,{constructions:0,pseudoinverses:0,recordPartitions:0});
    fs.writeFileSync(path.join(directory,'wave-10-probe-realization.json'),R.serialize({loweredQ:q,inputWithReference:rho,output:actual,
      wrongControlledPhase:{sourceOperator:channelSame,probeEffects:wrongRaw.map(K=>mm(adj(K),K))}})+'\n');
    result.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'wave-10-probe-checks.json'),JSON.stringify(result,null,2)+'\n');}
  return result;
}
if(require.main===module)console.log(JSON.stringify(check(process.argv[2]),null,2));
module.exports={check};
