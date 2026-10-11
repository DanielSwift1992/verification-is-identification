"use strict";
const assert=require("node:assert/strict"),fs=require("node:fs"),path=require("node:path");
const C=require("./coordinated_continuation.js"),R=require("./coordinated_relation_resolve.js"),U=require("./coordinated_uniform_environment.js");
const {c,z,one,add,nz,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,scalarText}=C.exact;
const e=R.reading;
const goal=relations=>({kind:"source-reading-relations",input:"derived-noncommuting-sector",relations});
const expectation=(rho,O)=>tr(mm(rho,O));
function traceEnvironment(rho,sourceDimension,environmentDimension,referenceDimension=1) {
  const n=sourceDimension*referenceDimension,out=mat(n);
  for(let s=0;s<sourceDimension;s++)for(let t=0;t<sourceDimension;t++)
    for(let r=0;r<referenceDimension;r++)for(let q=0;q<referenceDimension;q++)
      for(let e=0;e<environmentDimension;e++)out[s*referenceDimension+r][t*referenceDimension+q]=
        add(out[s*referenceDimension+r][t*referenceDimension+q],
          rho[(s*environmentDimension+e)*referenceDimension+r][(t*environmentDimension+e)*referenceDimension+q]);
  return out;
}
function check(outputDirectory) {
  const start=performance.now(),model=C.currentModel(),{P,Q,Pi,I,E}=model;
  const id=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[c(0,1),z]],Z=[[one,z],[z,c(-1)]];
  const local=(A,j)=>[0,1,2].map(k=>k===j?A:id).reduce(kron);
  const collective=A=>[0,1,2].map(j=>local(A,j)).reduce(plus);
  const Jx=collective(X),Jy=collective(Y),Jz=collective(Z),generators=[Jx,Jy,Jz];
  const family=U.deriveFamily(model,generators);U.verifyFamily(model,generators,family);
  for(const S of generators)assert.equal(U.generatorObstruction(model,S),null);
  const badSector=U.generatorObstruction(model,local(Z,0));
  const badReading=U.generatorObstruction(model,mm(Pi,P));
  assert.equal(badSector.kind,"sector-survival-second-derivative");
  assert.equal(badReading.kind,"logical-reading-first-derivative");
  U.verifyGeneratorObstruction(model,local(Z,0),badSector);
  U.verifyGeneratorObstruction(model,mm(Pi,P),badReading);
  const joint=C.accessModel([[1,0],[0,1],[1,1]]),serial=C.accessModel([[1,0],[0,1]]);
  const swap=goal([{after:e(["P"]),before:e(["Q"])},{after:e(["Q"]),before:e(["P"])}]);
  const second=goal([{after:e(["Q"]),before:e(["Q"])},{after:e(["P"]),before:e(["Q","P","Q"])}]);
  const swapJoint=U.compile(model,swap,joint,R.resolve(model,swap,joint),generators);
  const swapSerial=U.compile(model,swap,serial,R.resolve(model,swap,serial),generators);
  const secondJoint=U.compile(model,second,joint,R.resolve(model,second,joint),generators);
  const counters={...R.counters};
  for(const certificate of [swapJoint,swapSerial,secondJoint])
    U.verify(model,certificate.goal,certificate.access,generators,certificate);
  assert.deepEqual(R.counters,counters);
  assert.equal('background' in swapJoint,false);assert.equal('environmentDimension' in swapJoint,false);

  const Rse=kron(Pi,id),outside=kron(E,id);
  const rotor=(J,a,b,d)=>plus(outside,plus(scale(Rse,c(a,0,d)),scale(kron(mm(Pi,J),X),c(0,b,d))));
  const Wx=rotor(Jx,3,4,5),Wz=rotor(Jz,5,12,13),We=kron(I,plus(scale(id,c(3,0,5)),scale(Z,c(0,4,5))));
  const W2=mm(We,Wz);
  for(const W of [Wx,Wz,We,W2])U.verifyJointEpisode(model,2,W);
  assert(!isZero(comm(Wx,W2)),"test histories must genuinely fail to commute");
  // Complete joint-operator identities cover every initial correlation and
  // every external reference; the following particular input tests retention.
  const control1=R.verify(model,swap,joint,swapJoint.resolution).operator;
  const control2=R.verify(model,second,joint,secondJoint.resolution).operator;
  const noisyU=mm(mm(W2,kron(control2,id)),mm(Wx,kron(control1,id)));
  const idealU=kron(mm(control2,control1),id);
  for(const O of U.logicalBasis(model))eq(mm(mm(Rse,
    minus(mm(mm(adj(noisyU),kron(O,id)),noisyU),mm(mm(adj(idealU),kron(O,id)),idealU))),Rse),mat(16));
  // The reference is entangled with the logical content. E begins in 0, then
  // is retained and becomes correlated; subsequent calls never replace it.
  const v=mat(32,1),v16=mat(16,1);
  for(const [i,a]of [[2,2],[4,-1],[8,-1],[5,1],[9,-1]]){v16[i][0]=c(a);v[Math.floor(i/2)*4+i%2][0]=c(a);}
  const initial=scale(mm(v,adj(v)),c(1,0,8));
  const boundary=new U.RetainedJointBoundary(model,initial,2,2);
  boundary.continue(swap,joint,generators,swapJoint,[Wx]);
  const afterFirst=boundary.snapshot().rho;
  const reduced=traceEnvironment(afterFirst,8,2,2);
  assert(tr(mm(reduced,reduced))[0]<tr(mm(reduced,reduced))[2],"environment must become correlated, not remain a spectator");
  boundary.continue(second,joint,generators,secondJoint,[W2]);
  const actual=boundary.snapshot(),full=kron(noisyU,id);
  eq(actual.rho,mm(mm(full,initial),adj(full)));
  assert(!isZero(minus(actual.rho,mm(mm(kron(idealU,id),initial),adj(kron(idealU,id))))),"whole state should be different");
  // Include every Pauli reference reading: equality is not merely local means.
  const ideal=mm(mm(kron(idealU,id),initial),adj(kron(idealU,id)));
  for(const O of U.logicalBasis(model))for(const B of [id,X,Y,Z])
    assert.deepEqual(expectation(actual.rho,kron(kron(O,id),B)),expectation(ideal,kron(kron(O,id),B)));

  // Three serial sections see three different histories; one joint section
  // sees one. Equality concerns the full logical algebra, not the whole E.
  const serialBoundary=new U.RetainedJointBoundary(model,initial,2,2);
  serialBoundary.continue(swap,serial,generators,swapSerial,[Wz,Wx,We]);
  const serialState=serialBoundary.snapshot().rho;
  for(const O of U.logicalBasis(model))for(const B of [id,X,Y,Z])
    assert.deepEqual(expectation(afterFirst,kron(kron(O,id),B)),expectation(serialState,kron(kron(O,id),B)));
  assert(!isZero(minus(afterFirst,serialState)));

  // An empty control program does not erase an arbitrary retained episode.
  const unchanged=goal([{after:e(["P"]),before:e(["P"])},{after:e(["Q"]),before:e(["Q"])}]);
  const idle=U.compile(model,unchanged,joint,R.resolve(model,unchanged,joint),generators);
  const idleBoundary=new U.RetainedJointBoundary(model,initial,2,2);
  idleBoundary.continue(unchanged,joint,generators,idle,[Wx]);
  assert(!isZero(minus(idleBoundary.snapshot().rho,initial)));
  assert.equal(idleBoundary.snapshot().history[0].sections,0);

  // Weakly inspecting the current S cannot license a new contact to E.
  const zero=[[one,z],[z,z]],bitOne=[[z,z],[z,one]];
  const rhoP=scale(mm(Pi,plus(I,P)),c(1,0,4));
  const a=kron(rhoP,zero),b=kron(rhoP,bitOne);
  eq(traceEnvironment(a,8,2),traceEnvironment(b,8,2));
  const controlledQ=plus(kron(I,zero),kron(Q,bitOne));
  const qa=expectation(mm(mm(controlledQ,a),adj(controlledQ)),kron(mm(Pi,P),id));
  const qb=expectation(mm(mm(controlledQ,b),adj(controlledQ)),kron(mm(Pi,P),id));
  assert.deepEqual(qa,one);assert.deepEqual(qb,c(-1,0,2));

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  rejects(()=>U.deriveFamily(model,[local(Z,0)])); // leakage, not inferred safe from a local name
  rejects(()=>U.deriveFamily(model,[mm(Pi,P)])); // sector intact, logical relation broken
  rejects(()=>U.verifyFamily(model,[Jx,Jy],family));
  rejects(()=>U.verify(model,second,joint,generators,swapJoint));
  rejects(()=>U.verifyJointEpisode(model,2,controlledQ));
  const before=boundary.snapshot();
  rejects(()=>boundary.continue(swap,joint,generators,swapJoint,[controlledQ]));
  eq(before.rho,boundary.snapshot().rho);assert.deepEqual(before.history,boundary.snapshot().history);
  rejects(()=>idleBoundary.continue(unchanged,joint,generators,idle,[]));
  rejects(()=>new U.RetainedJointBoundary(model,kron(kron(scale(E,c(1,0,4)),zero),zero),2,2));
  const fakeDerivative=structuredClone(badReading);fakeDerivative.derivative=c(123);
  rejects(()=>U.verifyGeneratorObstruction(model,mm(Pi,P),fakeDerivative));
  rejects(()=>U.verifyGeneratorObstruction(model,Jz,badSector));
  // Changing only the environment dimension does not require new compilation.
  U.verifyJointEpisode(model,3,eye(24));
  const three=new U.RetainedJointBoundary(model,kron(rhoP,scale(eye(3),c(1,0,3))),3);
  three.continue(swap,joint,generators,swapJoint,[eye(24)]);
  const out={scope:"Conditional generator criterion and arbitrary retained joint history; no laboratory admission",
    source_generators:3,logical_algebra_dimension:4,compilation_uses_environment_dimension:false,
    compilation_uses_environment_history:false,verification_does_not_resolve_control_again:true,
    noncommuting_joint_histories:true,environment_is_retained_and_correlated:true,
    arbitrary_input_operator_identities:4,reference_readings_per_comparison:16,
    continued_independent_requests:actual.history.length,
    serial_and_joint_outputs_differ_but_logical_reference_readings_agree:true,
    empty_control_still_has_environment_episode:true,
    outside_future_separator:{same_source_input:true,after_new_contact_P:[scalarText(qa),scalarText(qb)]},
    generator_obstructions:{sector_second_derivative:scalarText(badSector.derivative),
      logical_first_derivative:scalarText(badReading.derivative)},
    tested_environment_dimensions:[2,3],negative_checks:negatives,
    invalid_joint_history_refused_before_mutation:true,physical_admission:null,
    milliseconds:Math.round(performance.now()-start)};
  if(outputDirectory){fs.mkdirSync(outputDirectory,{recursive:true});
    const certificateFile=path.join(outputDirectory,'wave-3-uniform-certificate.json');
    fs.writeFileSync(certificateFile,R.serialize({goal:swap,access:joint,generators,certificate:swapJoint})+'\n');
    fs.writeFileSync(path.join(outputDirectory,'wave-3-generator-obstructions.json'),R.serialize({badSector,badReading})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_uniform_environment.js'),certificateFile],{encoding:'utf8',timeout:15000});
    assert.equal(cp.status,0,cp.stderr);out.persistedVerifier=JSON.parse(cp.stdout);
    assert.deepEqual(out.persistedVerifier.constructionCalls,{linearSolves:0,normalFormClosures:0});
    out.milliseconds=Math.round(performance.now()-start);
    fs.writeFileSync(path.join(outputDirectory,'wave-3-uniform-checks.json'),JSON.stringify(out,null,2)+'\n');}
  return out;
}
if(require.main===module)console.log(JSON.stringify(check(process.argv[2]),null,2));
module.exports={check};
