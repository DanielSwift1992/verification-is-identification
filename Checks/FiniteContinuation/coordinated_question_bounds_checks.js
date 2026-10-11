"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const B=require('./coordinated_probe_continuation.js'),Q=require('./coordinated_question_bounds.js');
const {c,z,one,ii,add,mat,eye,scale,plus,minus,adj,mm,kron,tr,eq,isZero,scalarText}=Q.exact;
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],P0=[[one,z],[z,z]],P1=[[z,z],[z,one]];
const apply=(K,rho)=>mm(mm(K,rho),adj(K));
const artifact=path.resolve(__dirname,'../../Research/Artifacts/coordinated-continuation-20260917');
function check(directory){const start=performance.now(),m=C.currentModel(),bundle=[];
  const single=(spec,epsilon)=>{const certificate=Q.construct(m,spec,epsilon);bundle.push({spec,epsilon,certificate});return Q.verify(m,spec,epsilon,certificate);};
  const chain=(spec,epsilons,wholeEpsilon)=>{const certificate=Q.constructChain(m,spec,epsilons,wholeEpsilon);bundle.push({spec,epsilons,wholeEpsilon,certificate});
    return Q.verifyChain(m,spec,epsilons,wholeEpsilon,certificate);};
  const plans=R.deserialize(fs.readFileSync(path.join(artifact,'wave-10-probe-certificates.json'),'utf8')),p=plans[0];
  const checked=B.verify(m,p.request,p.acquisitionAccess,p.probeAccess,p.next,p.certificate),frame=p.certificate.stage.cases[0].input;
  const before=frame.readings.find(r=>r.name==='retained-2').operator;
  const ideal={kind:'declared-recorded-instrument',inputDimension:8,outcomes:checked.branches.map(b=>({label:String(b.answer),kraus:[b.sourceOperator]}))};
  const after=p.certificate.stage.cases[0].outputs.map(o=>({label:o.label,operator:o.frame.readings.find(r=>r.name==='retained-2').operator}));
  const spec={kind:'recorded-question-bound',support:m.Pi,before,instrument:ideal,after};
  assert(single(spec,z).admitted);eq(Q.instrumentDefect(spec),mat(8));
  const G=kron(kron(X,X),X),V=plus(scale(m.I,c(24,0,25)),scale(G,c(0,-7,25)));
  eq(mm(adj(V),V),m.I);const perturbed={...spec,instrument:{...ideal,outcomes:ideal.outcomes.map(o=>({label:o.label,kraus:o.kraus.map(K=>mm(V,K))}))}};
  const exact=single(perturbed,c(14,0,25));assert(exact.admitted);
  const tooSmall=single(perturbed,c(13,0,25));assert.equal(tooSmall.admitted,false);assert(Q.compare(c(tooSmall.defect[0]<0n?-tooSmall.defect[0]:tooSmall.defect[0],0,tooSmall.defect[2]),c(13,0,25))>0n);
  // D²=(14/25)² Pi gives the exact operator norm, independently of LDL.
  const D=Q.instrumentDefect(perturbed);eq(mm(D,D),scale(m.Pi,c(196,0,625)));
  const joint=R.deserialize(fs.readFileSync(path.join(artifact,'wave-10-probe-realization.json'),'utf8')).inputWithReference;
  for(const reference of [I2,X,Y,Z]){const error=tr(mm(joint,kron(D,reference)));assert(Q.compare(error,c(14,0,25))<=0n);assert(Q.compare(error,c(-14,0,25))>=0n);}

  // Read the actual probe record. A relative controlled phase erases this
  // question even though it is invisible in the uncontrolled source channel.
  // Use the source operators directly to avoid an implicit measurement table.
  const readout={kind:'declared-recorded-instrument',inputDimension:8,
    outcomes:[0,1].map(a=>({label:String(a),kraus:[scale(plus(m.I,scale(m.Q,c(a?-1:1))),c(1,0,2))]}))};
  const recordSpec={kind:'recorded-question-bound',support:m.Pi,before:mm(m.Pi,m.Q),instrument:readout,
    after:[{label:'0',operator:m.I},{label:'1',operator:scale(m.I,c(-1))}]};
  assert(single(recordSpec,z).admitted);
  const badPhase={...recordSpec,instrument:{...readout,outcomes:[0,1].map(a=>({label:String(a),kraus:[scale(plus(m.I,scale(m.Q,c(0,a?1:-1))),c(1,0,2))]}))}};
  assert(single(badPhase,one).admitted);assert.equal(single(badPhase,c(1,0,2)).admitted,false);
  const reversed={...recordSpec,after:recordSpec.after.map(o=>({...o,label:o.label==='0'?'1':'0'}))};
  assert.equal(single(reversed,z).admitted,false);eq(Q.instrumentDefect(reversed),scale(mm(m.Pi,m.Q),c(-2)));
  // Keep the acquired record as part of the NEXT input instead of replacing it
  // by its marginal. The later conditional action changes the error question.
  const goodRecord=Q.recordedChannel(readout,recordSpec.after),badRecord=Q.recordedChannel(badPhase.instrument,recordSpec.after);
  const cqSupport=kron(I2,m.Pi),follow=B.controlled(m.P);
  const recorded={kind:'retained-process-question-bound',supports:[m.Pi,cqSupport,cqSupport],finalQuestion:kron(I2,mm(m.Pi,m.Q)),
    stages:[{actual:badRecord.channel,ideal:goodRecord.channel},{actual:Q.channel([follow]),ideal:Q.channel([follow])}]};
  const recordedBound=chain(recorded,[c(6,0,5),z],c(6,0,5));assert(recordedBound.admitted);
  assert.equal(chain(recorded,[one,z],null).admitted,false);
  const recordDefect=Q.chainData(recorded).whole,centered=plus(recordDefect,scale(m.Pi,c(3,0,4)));
  eq(mm(centered,centered),scale(m.Pi,c(3,0,16)));assert.deepEqual(tr(centered),z);
  assert.deepEqual(tr(mm(scale(m.Pi,c(1,0,4)),recordDefect)),c(-3,0,4));

  // The same retained environment controls both contacts. They may each
  // disturb the question, while their complete joint product is the identity.
  const W=plus(kron(m.I,P0),kron(m.P,P1)),support=kron(m.Pi,I2),question=kron(mm(m.Pi,m.Q),I2);
  eq(mm(W,W),eye(16));const held={kind:'retained-process-question-bound',supports:[support,support,support],finalQuestion:question,
    stages:[0,1].map(()=>({actual:Q.channel([W]),ideal:Q.channel([eye(16)])}))};
  const heldResult=chain(held,[c(2),c(2)],z);assert(heldResult.admitted);assert.deepEqual(heldResult.telescopingError,c(4));assert.deepEqual(heldResult.error,z);
  assert(!isZero(Q.chainData(held).defects[0]));eq(Q.chainData(held).whole,mat(16));
  // A newly supplied environment on each contact gives a different process.
  // Duplicate rational Kraus operators implement the fair mixture exactly.
  const fresh=Q.channel([scale(m.I,c(1,0,2)),scale(m.I,c(1,0,2)),scale(m.P,c(1,0,2)),scale(m.P,c(1,0,2))]);
  const reset={kind:'retained-process-question-bound',supports:[m.Pi,m.Pi,m.Pi],finalQuestion:mm(m.Pi,m.Q),
    stages:[0,1].map(()=>({actual:fresh,ideal:Q.channel([m.I])}))};
  const resetResult=chain(reset,[one,one],z);assert.equal(resetResult.admitted,false);assert.equal(resetResult.step,'whole');
  const input=scale(plus(m.Pi,mm(m.Pi,m.Q)),c(1,0,4));let resetInput=input;
  for(let i=0;i<2;i++)resetInput=fresh.kraus.reduce((rho,K)=>plus(rho,apply(K,resetInput)),mat(8));
  assert.deepEqual(tr(mm(input,mm(m.Pi,m.Q))),one);assert.deepEqual(tr(mm(resetInput,mm(m.Pi,m.Q))),c(1,0,4));

  // Pull back the FUTURE question. Checking P at both intermediate contacts
  // would miss that the following joint control turns final P into earlier Q.
  const swap=C.sectionOperator(m,{coeff:[1,1],quarters:1});
  const future={kind:'retained-process-question-bound',supports:[m.Pi,m.Pi,m.Pi],finalQuestion:mm(m.Pi,m.P),
    stages:[{actual:Q.channel([m.P]),ideal:Q.channel([m.I])},{actual:Q.channel([swap]),ideal:Q.channel([swap])}]};
  eq(mm(mm(m.P,mm(m.Pi,m.P)),m.P),mm(m.Pi,m.P));
  const missed=chain(future,[z,z],null);assert.equal(missed.admitted,false);assert.equal(missed.step,0);
  assert(chain(future,[c(7,0,4),z],c(7,0,4)).admitted);
  const futureData=Q.chainData(future);eq(futureData.questions[1],mm(m.Pi,m.Q));assert.deepEqual(tr(mm(input,futureData.whole)),c(-3,0,2));

  // Leakage defeats sector-only local bounds if the intermediate support is
  // guessed from the ideal path instead of proved for the actual path.
  const Z1=kron(kron(Z,I2),I2),ZZZ=kron(kron(Z,Z),Z),V2=plus(m.Pi,mm(m.E,G));eq(mm(V2,V2),m.I);
  const leakage={kind:'retained-process-question-bound',supports:[m.Pi,m.Pi,m.Pi],finalQuestion:mm(m.E,ZZZ),
    stages:[{actual:Q.channel([Z1]),ideal:Q.channel([Z1])},{actual:Q.channel([V2]),ideal:Q.channel([m.I])}]};
  let negatives=0;const refuses=fn=>{assert.throws(fn);negatives++;};
  refuses(()=>Q.constructChain(m,leakage,[z,z],z));
  const moved=apply(Z1,m.Pi),last=apply(V2,moved),honest={...leakage,supports:[m.Pi,moved,last]};
  const honestData=Q.chainData(honest);assert(!isZero(honestData.whole));assert(chain(honest,[z,c(2)],c(2)).admitted);
  const badWhole=chain(honest,[z,c(2)],z);assert.equal(badWhole.admitted,false);assert.equal(badWhole.step,'whole');
  const v=mat(8,1);for(let i=0;i<8;i++)v[i][0]=m.Pi[i][4];const rho=scale(mm(v,adj(v)),c(3,0,2));
  assert.deepEqual(tr(mm(rho,honestData.whole)),c(16,0,9));
  // The falsely restricted second defect is zero, making the missing support
  // premise material rather than a bookkeeping inconvenience.
  eq(mm(mm(m.Pi,minus(Q.pull(Q.channel([V2]),leakage.finalQuestion),leakage.finalQuestion)),m.Pi),mat(8));

  // Exact factor witnesses exercise singular and imaginary off-diagonal cases.
  for(const M of [[[z,one],[one,z]],[[z,ii],[c(0,-1),z]],[[c(-1),z],[z,one]]]){
    const f=Q.factorOrWitness(M);assert.equal(f.kind,'negative-vector');assert(Q.compare(mm(mm(adj(f.vector),M),f.vector)[0][0],z)<0n);}
  const proof=bundle[1],bad=structuredClone(proof.certificate);bad.envelope.factors[0].weights[1]=c(-1);
  refuses(()=>Q.verify(m,proof.spec,proof.epsilon,bad));
  const wrongQuestion=structuredClone(proof.spec);wrongQuestion.after.reverse();wrongQuestion.after[0].operator=mat(8);
  refuses(()=>Q.verify(m,wrongQuestion,proof.epsilon,proof.certificate));
  const wrongPhysical=structuredClone(proof.certificate);wrongPhysical.physicalAdmission={backend:'unverified'};refuses(()=>Q.verify(m,proof.spec,proof.epsilon,wrongPhysical));
  refuses(()=>Q.verify({...m},proof.spec,proof.epsilon,proof.certificate));
  refuses(()=>Q.construct(m,spec,c(-1)));
  const duplicate={...spec,after:spec.after.map(o=>({...o,label:'0'}))};refuses(()=>Q.construct(m,duplicate,z));
  const invalidBound=structuredClone(bundle[2].certificate);invalidBound.envelope.vector=mat(8,1);
  refuses(()=>Q.verify(m,bundle[2].spec,bundle[2].epsilon,invalidBound));
  const count={...Q.counters};for(const b of bundle)b.spec.kind==='recorded-question-bound'?Q.verify(m,b.spec,b.epsilon,b.certificate):Q.verifyChain(m,b.spec,b.epsilons,b.wholeEpsilon,b.certificate);
  assert.deepEqual(Q.counters,count);
  const result={scope:'Exact conditional question bounds on complete instruments and retained-context processes; not calibration or a diamond norm',
    coherent_perturbation_exact_bound:'14/25',smaller_bound_refuted:'13/25',external_reference:'every Hermitian reference contraction for the declared question',
    controlled_phase_record_error:'1',actual_record_reversal_defect_norm:'2',record_retained_through_following_action:{bound:'6/5',bound_one_refuted:true,control_input_defect:'-3/4'},
    common_retained_memory:{local_sum:'4',complete_episode:'0'},fresh_memory_after_two_contacts:{initial_Q:'1',final_Q:'1/4'},
    backward_future_required:{naive_local_bounds:'0,0',actual_final_defect_on_control_input:'-3/2'},
    actual_support_required:{false_intermediate_support_rejected:true,hidden_complete_defect_on_control_input:'16/9'},
    exact_positive_factors_and_negative_input_witnesses:true,certificates:bundle.length,negative_mutation_checks:negatives,
    verification_does_not_factor_again:true,physical_admission:null,milliseconds:Math.round(performance.now()-start)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-12-question-bound-certificates.json');fs.writeFileSync(file,R.serialize(bundle)+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_question_bounds.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{factorizations:0,constructions:0,chainConstructions:0});
    fs.writeFileSync(path.join(directory,'wave-12-question-bound-witnesses.json'),R.serialize({tooSmall:tooSmall.rho,tooSmallDefect:tooSmall.defect,
      resetInput,honestLeakageInput:rho,backwardInput:input})+'\n');result.milliseconds=Math.round(performance.now()-start);
    fs.writeFileSync(path.join(directory,'wave-12-question-bound-checks.json'),R.serialize(result)+'\n');}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
