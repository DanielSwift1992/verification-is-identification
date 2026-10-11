"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const B=require('./coordinated_probe_continuation.js'),G=require('./coordinated_cut_background.js');
const Q=require('./coordinated_question_bounds.js'),P=require('./coordinated_pulse_relation.js');
const {c,z,one,ii,add,div,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=P.exact;
const I2=eye(2),X=[[z,one],[one,z]],Z=[[one,z],[z,c(-1)]],P0=[[one,z],[z,z]];
function check(directory){const started=performance.now(),m=C.currentModel(),available=G.access(B.primitiveAccess(),['Q']),bundle=[];
  const direct=G.constructProgram(m,'Q','direct',available),lowered=G.constructProgram(m,'Q','lowered',available);
  const dd=G.programData(m,direct,available),ld=G.programData(m,lowered,available);
  eq(dd.operator,ld.operator);
  const site=(axis,i)=>kron(I2,[0,1,2].map(j=>i===j?axis:I2).reduce(kron));
  const Sx=[0,1,2].map(i=>site(X,i)).reduce(plus),Sz=[0,1,2].map(i=>site(Z,i)).reduce(plus);
  const raw=[{name:'actual-probe-sign',operator:dd.rawQuestion}];
  const specification=(program,questions=raw)=>({kind:'probe-pulse-background-question',program,available,finalQuestions:questions,
    paths:P.declaredPaths(m,program,available),generators:Array.from({length:G.programData(m,program,available).steps.length},()=>[Sx,Sz])});
  const directSpec=specification(direct),lowerSpec=specification(lowered);
  const verify=spec=>{const certificate=P.construct(m,spec);bundle.push({spec,certificate});return P.verify(m,spec,certificate);};
  assert(verify(directSpec).admitted);assert.equal(verify(lowerSpec).admitted,false);
  const lowerData=P.pulseData(m,lowerSpec),badSegments=lowerData.commutators.map((row,j)=>row.some(qs=>qs.some(parts=>Object.values(parts).some(D=>!isZero(D))))?j:-1).filter(j=>j>=0);
  // Exact rational parameter checks supplement the coefficient proof. They
  // do not establish whole-arc admission: that uses linear independence.
  for(const segment of dd.steps.filter(s=>s.normSquared[0]===1n))for(const O of [dd.rawQuestion,Sx,Sz]){
    const a=P.coefficients(segment.matrix,segment.normSquared,O),U=plus(scale(eye(16),c(3,0,5)),scale(segment.matrix,c(0,4,5)));
    const predicted=minus(plus(a.A,scale(a.B,c(-7,0,25))),scale(a.Cscaled,c(24,0,25)));
    eq(mm(mm(adj(U),O),U),predicted);
  }
  const H=dd.steps[0],hArc=P.coefficients(H.matrix,H.normSquared,dd.rawQuestion);
  // H O H and the scaled sine coefficient are checked without sqrt(2).
  eq(minus(hArc.A,hArc.B),scale(mm(mm(H.matrix,dd.rawQuestion),H.matrix),c(1,0,2)));
  assert(!isZero(hArc.Cscaled));
  const gaugeZ=kron(I2,kron(kron(Z,Z),Z));
  assert.equal(verify(specification(direct,[...raw,{name:'retained-gauge-Z',operator:gaugeZ}])).admitted,false);

  // Full original-source example: endpoints alone miss an interior defect.
  const O=scale(comm(m.P,m.Q),ii),rho=scale(plus(m.Pi,scale(O,c(1,0,2))),c(1,0,4));
  eq(mm(O,O),scale(m.Pi,c(3)));eq(mm(mm(m.P,O),m.P),scale(O,c(-1)));assert.deepEqual(tr(rho),one);
  Q.verifyFactor(rho,Q.factorOrWitness(rho));eq(mm(mm(m.Pi,rho),m.Pi),rho);
  const arc=P.coefficients(m.P,one,O),S=O;
  assert(isZero(comm(S,plus(arc.A,arc.B))));assert(isZero(comm(S,minus(arc.A,arc.B))));
  assert(isZero(arc.A));assert(!isZero(comm(S,arc.Cscaled)));
  const W=plus(m.E,scale(plus(m.Pi,scale(O,c(0,-1))),c(1,0,2))),half=plus(m.I,scale(m.P,ii));
  const actual=scale(mm(mm(half,W),half),c(0,-1,2));
  eq(mm(adj(W),W),m.I);eq(mm(adj(actual),actual),m.I);assert(isZero(comm(W,O)));
  // Two phase-fixed half-pulses without W have exactly endpoint P.
  eq(scale(mm(half,half),c(0,-1,2)),m.P);
  const mean=U=>tr(mm(rho,mm(mm(adj(U),O),U))),idealMean=mean(m.P),actualMean=mean(actual);
  assert.deepEqual(idealMean,c(-3,0,2));assert.deepEqual(actualMean,c(3,0,4));
  assert.deepEqual(mean(mm(W,m.P)),idealMean);assert.deepEqual(mean(mm(m.P,W)),idealMean);
  // A pause halfway, with integrable background S during the pause, is
  // allowed by an absolutely continuous path. No impulsive delta is needed.
  // W=exp(-i*pi*S/(3*sqrt(3))), since S^2=3 Pi and S E=0.
  eq(mm(m.E,S),scale(m.E,z));

  // The same finite insertion in the direct probe path commutes with the
  // middle F and the final backward question, so survives even at midpoint.
  const middle=dd.steps[1].matrix,u=plus(scale(I2,c(24,0,25)),scale(X,c(0,-7,25))),collective=kron(I2,kron(kron(u,u),u));
  assert(isZero(comm(middle,collective)));
  const midHalf=plus(eye(16),scale(middle,ii));
  const noisyMiddle=scale(mm(mm(midHalf,collective),midHalf),c(0,-1,2));
  const actualProbe=scale(mm(mm(dd.steps[2].matrix,noisyMiddle),dd.steps[0].matrix),c(1,0,2));
  eq(mm(adj(actualProbe),actualProbe),eye(16));
  eq(mm(mm(adj(actualProbe),dd.rawQuestion),actualProbe),mm(mm(adj(dd.operator),dd.rawQuestion),dd.operator));

  let negatives=0;const rejects=fn=>{assert.throws(fn);negatives++;};
  const missing=structuredClone(directSpec);delete missing.paths;rejects(()=>P.construct(m,missing));
  const noPath=structuredClone(directSpec);noPath.paths.segments[1].path='same-endpoint-only';rejects(()=>P.construct(m,noPath));
  const wrongPhase=structuredClone(directSpec);wrongPhase.paths.segments[1].path='exp(-i*s*F)';rejects(()=>P.construct(m,wrongPhase));
  const wrongEnd=structuredClone(directSpec);wrongEnd.paths.segments[1].parameterEnd='pi';rejects(()=>P.construct(m,wrongEnd));
  const noSegment=structuredClone(directSpec);noSegment.paths.segments.splice(1,1);rejects(()=>P.construct(m,noSegment));
  const wrongNormalization=structuredClone(directSpec);wrongNormalization.paths.segments[0].endpoint.normSquared=one;rejects(()=>P.construct(m,wrongNormalization));
  const falseLower=structuredClone(bundle[0].certificate);falseLower.spec=lowerSpec;falseLower.arcs=lowerData.arcs;rejects(()=>P.verify(m,lowerSpec,falseLower));
  const wrongCoefficient=structuredClone(bundle[0].certificate);wrongCoefficient.arcs[0][0].Cscaled=scale(eye(16),z);rejects(()=>P.verify(m,directSpec,wrongCoefficient));
  const wrongWitness=structuredClone(bundle[1].certificate);wrongWitness.obstruction.segment=0;rejects(()=>P.verify(m,lowerSpec,wrongWitness));
  const inventedPhysical=structuredClone(bundle[0].certificate);inventedPhysical.physicalAdmission={backend:'unverified'};rejects(()=>P.verify(m,directSpec,inventedPhysical));
  const inventedPathPhysical=structuredClone(directSpec);inventedPathPhysical.paths.physicalAdmission={endpointWasVerified:true};rejects(()=>P.construct(m,inventedPathPhysical));
  rejects(()=>P.verify({...m},directSpec,bundle[0].certificate));
  const nonInvolution=plus(m.P,scale(m.Q,ii));rejects(()=>P.coefficients(nonInvolution,one,O));
  const calls={p:{...P.counters},g:{...G.counters}};bundle.forEach(b=>P.verify(m,b.spec,b.certificate));
  assert.deepEqual({p:P.counters,g:G.counters},calls);
  const result={scope:'Exact whole-arc conditions for separately declared phase-fixed involution paths of the current probe lowering',
    direct_all_declared_pulse_arcs:true,lowered_bad_segments_zero_based:badSegments,
    hadamard_coefficient_test_without_irrational_arithmetic:true,
    endpoint_only_counterexample:{ideal:'-3/2',background_at_either_endpoint:'-3/2',same_background_inside:'3/4',defect:'9/4'},
    full_operator_midpoint_direct_check:true,source_density_positive:true,all_parameter_values_from_coefficients_not_samples:true,
    raw_question_does_not_certify_retained_gauge:true,physical_path_separate_from_endpoint:true,
    negative_checks:negatives,physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-14-pulse-certificates.json');fs.writeFileSync(file,R.serialize(bundle)+'\n');
    fs.writeFileSync(path.join(directory,'wave-14-pulse-realizations.json'),R.serialize({O,rho,W,actual,idealMean,actualMean,direct,lowered,actualProbe})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_pulse_relation.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{declarations:0,constructions:0});
    assert.deepEqual(result.persistedVerifier.cutConstructionCalls,{programs:0,constructions:0});
    result.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'wave-14-pulse-checks.json'),R.serialize(result)+'\n');}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
