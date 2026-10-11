"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),B=require('./coordinated_probe_continuation.js');
const Q=require('./coordinated_question_bounds.js'),G=require('./coordinated_cut_background.js');
const {c,z,one,ii,add,sub,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,scalarText}=G.exact;
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],P0=[[one,z],[z,z]];
const conjugate=(U,O)=>mm(mm(U,O),adj(U));
function check(directory){const started=performance.now(),m=C.currentModel(),available=G.access(B.primitiveAccess(),['Q']),bundle=[];
  const direct=G.constructProgram(m,'Q','direct',available),lowered=G.constructProgram(m,'Q','lowered',available);
  const dd=G.programData(m,direct,available),ld=G.programData(m,lowered,available);eq(dd.operator,ld.operator);
  const site=(axis,i)=>kron(I2,[0,1,2].map(j=>i===j?axis:I2).reduce(kron));
  const Sx=[0,1,2].map(i=>site(X,i)).reduce(plus),Sz=[0,1,2].map(i=>site(Z,i)).reduce(plus);
  const raw=[{name:'actual-probe-sign',operator:dd.rawQuestion}];
  const specification=(program,questions=raw)=>({kind:'probe-cut-background-question',program,available,finalQuestions:questions,
    generators:Array.from({length:G.programData(m,program,available).steps.length+1},()=>[Sx,Sz])});
  const verifyExact=spec=>{const certificate=G.constructExact(m,spec);bundle.push({spec,certificate});return G.verifyExact(m,spec,certificate);};
  const directSpec=specification(direct),lowerSpec=specification(lowered);assert(verifyExact(directSpec).admitted);
  const failed=verifyExact(lowerSpec);assert.equal(failed.admitted,false);assert.equal(failed.obstruction.cut,2);
  const data=G.cutData(m,lowerSpec),badCuts=data.commutators.map((row,i)=>row.some(qs=>qs.some(D=>!isZero(D)))?i:-1).filter(i=>i>=0);
  assert.deepEqual(badCuts,[2]);
  // Raw-record protection is weaker than preserving the complete former
  // instrument. The collective field can still rotate retained gauge content.
  const gaugeZ=kron(I2,kron(kron(Z,Z),Z)),fuller=specification(direct,[...raw,{name:'retained-gauge-Z',operator:gaugeZ}]);
  assert.equal(verifyExact(fuller).admitted,false);

  const rhoSource=scale(plus(m.Pi,mm(m.Pi,m.Q)),c(1,0,4)),rho=kron(P0,rhoSource);
  const u=plus(scale(I2,c(24,0,25)),scale(X,c(0,-7,25))),collective=kron(I2,kron(kron(u,u),u));
  const runAt=(program,cut,W)=>{const count=G.programData(m,program,available).steps.length+1,episodes=Array.from({length:count},()=>eye(16));episodes[cut]=W;
    const U=G.jointOperator(m,program,available,1,episodes);return {operator:U,mean:tr(mm(rho,mm(mm(adj(U),dd.rawQuestion),U)))};};
  const good=runAt(direct,1,collective),bad=runAt(lowered,2,collective);
  assert.deepEqual(good.mean,one);assert.deepEqual(bad.mean,c(1777,0,1875));
  const strong=kron(I2,kron(kron(X,X),X)),strongBad=runAt(lowered,2,strong);assert.deepEqual(strongBad.mean,c(1,0,3));
  assert.deepEqual(runAt(direct,1,strong).mean,one);

  // Every field is transported as an ACTUAL changed coupling, not merely
  // relabeled. This different declared family restores the sufficient rule.
  const transported=structuredClone(lowerSpec);let current=[Sx,Sz];transported.generators=[current];
  for(const step of ld.steps){current=current.map(S=>scale(mm(mm(step.matrix,S),adj(step.matrix)),div(one,step.normSquared)));transported.generators.push(current);}
  assert(verifyExact(transported).admitted);
  assert(!isZero(minus(transported.generators[2][0],Sx)));
  const F=ld.steps[1].matrix,matched=conjugate(F,collective);assert.deepEqual(runAt(lowered,2,matched).mean,one);

  // Uniform quantitative certificate: at cut 2 the commutator norm is at
  // most 2 for each field. Exposures are declared integral norm budgets.
  const limits=data.commutators.map((row,cut)=>row.map(items=>items.map(D=>isZero(D)?z:c(2))));
  for(const D of data.commutators[2].flat()){assert(!isZero(D));eq(mm(mm(D,D),D),scale(D,c(4)));}
  const exposures=lowerSpec.generators.map(row=>row.map(()=>z));exposures[2][0]=c(2,0,7);
  const budget=G.constructBudget(m,lowerSpec,limits,exposures);bundle.push({spec:lowerSpec,limits,exposures,certificate:budget});
  const checkedBudget=G.verifyBudget(m,lowerSpec,limits,exposures,budget);assert.deepEqual(checkedBudget.errors,[c(4,0,7)]);
  // u=exp(-i theta X), theta=2 arctan(1/7)<2/7. The finite example is
  // inside this model exposure budget. That is not a device calibration.
  const actualError=sub(one,bad.mean);assert(Q.compare(actualError,c(4,0,7))<0n);

  // Retain one environment across noncommuting coefficient episodes. The
  // full Heisenberg equality proves the statement for all joint inputs and
  // any additional untouched reference, without resetting that environment.
  function jointRotation(axis,environment,a,b,d){const I=eye(32);let U=I;
    for(let i=0;i<3;i++){const generator=kron(site(axis,i),environment),part=plus(scale(I,c(a,0,d)),scale(generator,c(0,-b,d)));U=mm(part,U);}eq(mm(adj(U),U),I);return U;}
  const W1=mm(kron(eye(16),plus(scale(I2,c(3,0,5)),scale(Y,c(0,-4,5)))),jointRotation(X,X,24,7,25));
  const W2=jointRotation(Z,Z,12,5,13);assert(!isZero(comm(W1,W2)));
  const retainedEpisodes=[eye(32),W1,W2,eye(32)],actual=G.jointOperator(m,direct,available,2,retainedEpisodes),ideal=kron(dd.operator,I2);
  eq(mm(mm(adj(actual),kron(dd.rawQuestion,I2)),actual),mm(mm(adj(ideal),kron(dd.rawQuestion,I2)),ideal));
  const old=R.deserialize(fs.readFileSync(path.resolve(__dirname,'../../Research/Artifacts/coordinated-continuation-20260917/wave-10-probe-realization.json'),'utf8'));
  const jointInput=kron(P0,old.inputWithReference);assert(!isZero(minus(conjugate(actual,jointInput),conjugate(ideal,jointInput))));

  let negatives=0;const rejects=fn=>{assert.throws(fn);negatives++;};
  rejects(()=>G.constructProgram(m,'Q','direct',G.access(B.primitiveAccess(),[])));
  const falseExact=structuredClone(bundle[0].certificate);falseExact.spec=lowerSpec;rejects(()=>G.verifyExact(m,lowerSpec,falseExact));
  const missingCut=structuredClone(lowerSpec);missingCut.generators.splice(2,1);rejects(()=>G.constructExact(m,missingCut));
  const misplaced=structuredClone(bundle[1].certificate);misplaced.obstruction.cut=1;rejects(()=>G.verifyExact(m,lowerSpec,misplaced));
  const pretendTransport=structuredClone(bundle[3].certificate);pretendTransport.spec=lowerSpec;rejects(()=>G.verifyExact(m,lowerSpec,pretendTransport));
  const zeroLimit=structuredClone(limits);zeroLimit[2][0][0]=z;rejects(()=>G.constructBudget(m,lowerSpec,zeroLimit,exposures));
  const otherExposure=structuredClone(exposures);otherExposure[2][0]=z;rejects(()=>G.verifyBudget(m,lowerSpec,limits,otherExposure,budget));
  const falsePhysical=structuredClone(budget);falsePhysical.physicalAdmission={backend:'unverified'};rejects(()=>G.verifyBudget(m,lowerSpec,limits,exposures,falsePhysical));
  rejects(()=>G.verifyExact({...m},directSpec,bundle[0].certificate));
  const badPhaseAccess=structuredClone(available);badPhaseAccess.primitives.permutationEntries='classical-table-only';rejects(()=>G.constructProgram(m,'Q','direct',badPhaseAccess));
  const calls={g:{...G.counters},q:{...Q.counters},b:{...B.counters}};
  bundle.forEach(item=>item.certificate.kind==='uniform-cut-question-budget'?G.verifyBudget(m,item.spec,item.limits,item.exposures,item.certificate):G.verifyExact(m,item.spec,item.certificate));
  assert.deepEqual({g:G.counters,q:Q.counters,b:B.counters},calls);
  const result={scope:'Existing probe lowering under explicitly declared background at discrete cuts, no guarantee inside unknown primitive pulses',
    equal_ideal_endpoints:true,direct_raw_question_uniform_family:true,lowered_failed_cuts:badCuts,
    common_field_control:{direct:'1',lowered:'1777/1875',strong_pulse_lowered:'1/3'},
    transported_actual_coupling_restores_raw_question:true,transport_is_an_additional_premise:true,
    same_environment_noncommuting_episodes:true,full_heisenberg_equality_for_all_joint_inputs:true,
    raw_question_protection_does_not_certify_full_retained_gauge:true,conditional_budget:{exposure:'2/7',commutator:'2',error:'4/7'},
    construction_does_not_receive_environment_dimension_or_trajectory:true,negative_checks:negatives,physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-13-cut-certificates.json');fs.writeFileSync(file,R.serialize(bundle)+'\n');
    fs.writeFileSync(path.join(directory,'wave-13-cut-realizations.json'),R.serialize({direct,lowered,rho,collective,matched,retainedEpisodes,
      goodMean:good.mean,badMean:bad.mean,strongBadMean:strongBad.mean})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_cut_background.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{programs:0,constructions:0});
    assert.deepEqual(result.persistedVerifier.boundConstructionCalls,{factorizations:0,constructions:0,chainConstructions:0});
    result.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'wave-13-cut-checks.json'),R.serialize(result)+'\n');}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
