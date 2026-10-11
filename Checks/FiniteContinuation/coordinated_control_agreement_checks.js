"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js'),D=require('./coordinated_native_exit.js'),G=require('./coordinated_protected_control.js'),A=require('./coordinated_control_agreement.js');
const {c,z,one,add,mul,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=A.exact;
const counts=()=>({agreement:{...A.counters},direct:{...G.counters},entry:{...F.counters},exit:{...D.counters},exchange:{...M.counters}});
function check(directory){const t=performance.now(),m=M.currentModel(),space=A.derive(m),v=A.verifySpace(m,space),available=A.access();
  assert.equal(v.dimension,2);assert.deepEqual(space.basis,[[z,one,z],[one,z,one]]);assert.deepEqual(v.differenceNorm,c(2));
  const base=path.join(__dirname,'../../Research/Artifacts/coordinated-continuation-20260917'),old=R.deserialize(fs.readFileSync(path.join(base,'wave-22-control-certificates.json'),'utf8')),
    realizations=R.deserialize(fs.readFileSync(path.join(base,'wave-22-control-realizations.json'),'utf8')),
    native=R.deserialize(fs.readFileSync(path.join(base,'wave-19-native-realizations.json'),'utf8'));
  const plans=old.plans.map(p=>({goal:p.goal,certificate:A.construct(m,available,p.goal,space)}));
  const hv=A.verify(m,available,plans[0].goal,plans[0].certificate),zv=A.verify(m,available,plans[1].goal,plans[1].certificate);
  assert.equal(hv.minimumSections,3);assert.equal(zv.minimumSections,2);assert.equal(plans[0].certificate.states.length,24);
  assert.equal(A.verify(m,available,plans[3].goal,plans[3].certificate),null);
  const weak=A.resolve(m,[available],old.plans[0].goal,space),strong=A.resolve(m,[G.access()],old.plans[0].goal,space);
  assert.deepEqual([weak.sections,strong.sections],[3,1]);
  const tilted=A.resolve(m,[available,G.access()],old.plans[3].goal,space);assert.equal(tilted.sections,1);assert.equal(tilted.attempted[0].found,false);
  const noTilt=A.resolve(m,[available],old.plans[3].goal,space);assert.equal(noTilt.unresolved,true);
  const d=F.exchangeCode(m),L=d.readings.map(q=>q.operator),input=mm(mm(m.operators.Q,native.zeroEncoded),m.operators.Q);
  const piece=name=>plus(m.I,scale(m.operators[name],c(0,-1)));
  let unsafe=input;for(const name of ['P','Q','T']){const N=piece(name);unsafe=scale(mm(mm(N,unsafe),adj(N)),c(1,0,2));}
  const leak=tr(mm(minus(m.I,d.support),unsafe));assert.deepEqual(leak,c(1,0,8));
  const safe=A.program(m,available,['PT+','Q+']),safeState=scale(mm(mm(safe.N,input),adj(safe.N)),c(1,0,safe.den));assert.deepEqual(tr(mm(minus(m.I,d.support),safeState)),z);
  // Both paths have exactly pi/4 in each of P,Q,T. The paired path alone
  // satisfies the pointwise control condition. Safe orders still compute differently.
  const reverse=A.program(m,available,['Q+','PT+']),forward=A.program(m,available,['PT+','Q+']);
  const mean=p=>tr(mm(L[0],scale(mm(mm(p.N,native.zeroEncoded),adj(p.N)),c(1,0,p.den))));
  assert.deepEqual(mean(reverse),one);assert.deepEqual(mean(forward),z);
  const budget=A.mismatchBound([{duration:c(1,0,10),P:one,T:z},{duration:c(1,0,10),P:z,T:one}]);
  assert.deepEqual(budget.signedIntegral,z);assert.deepEqual(budget.delta,c(1,0,5));assert.deepEqual(budget.leakageUpper,c(1,0,25));assert.deepEqual(budget.questionErrorUpper,c(2,0,5));
  assert.deepEqual(A.mismatchBound([{duration:c(4),P:c(3),T:c(3)}]).leakageUpper,z);
  // A single owner executes two independent goals under two different
  // declared implementations, with one actual retained E and native input.
  const {entryAvailable,entry,exitAvailable,exit}=old,{rho,W1,W2,expected}=realizations;
  const runtime=new A.BoundarySession(m,rho,2,2),beforeCounts=counts();runtime.enter(entryAvailable,entry)
    .apply(weak.available,weak.goal,weak.certificate,[W1,W2,W1])
    .apply(old.available,old.plans[1].goal,old.plans[1].certificate,[W2]).exit(exitAvailable,exit);
  assert.deepEqual(counts(),beforeCounts);const actual=runtime.snapshot(),returned=runtime.nativeState();assert.deepEqual([actual.steps,actual.exits],[2,1]);assert(isZero(returned.B));
  const I=eye(2),total=mm(W1,mm(W2,W1));
  const direct=new A.BoundarySession(m,rho,2,2).enter(entryAvailable,entry).apply(strong.available,strong.goal,strong.certificate,[total])
    .apply(old.available,old.plans[1].goal,old.plans[1].certificate,[W2]).exit(exitAvailable,exit);
  D.qeq(actual.rho,direct.snapshot().rho,'same composed environment, same full output; no fresh environment at implementation change');
  const reduced=mat(4);for(let a=0;a<2;a++)for(let b=0;b<2;b++)for(let i=0;i<2;i++)for(let j=0;j<2;j++)for(let e=0;e<2;e++)reduced[a*2+i][b*2+j]=add(reduced[a*2+i][b*2+j],returned.A[(a*2+e)*2+i][(b*2+e)*2+j]);eq(reduced,expected);
  let negatives=0;const reject=f=>{assert.throws(f);negatives++;};
  const badBasis=structuredClone(space);badBasis.basis[1]=[one,z,z];reject(()=>A.verifySpace(m,badBasis));
  const duplicate=structuredClone(space);duplicate.basis[1]=duplicate.basis[0];reject(()=>A.verifySpace(m,duplicate));
  const badRank=structuredClone(space);badRank.nonzeroMinor.value=z;reject(()=>A.verifySpace(m,badRank));
  const fakeRoot=structuredClone(space);fakeRoot.source={};reject(()=>A.verifySpace(m,fakeRoot));reject(()=>A.verifySpace({...m},space));
  const weakened=structuredClone(available);weakened.pair='only equal total integrals';reject(()=>A.verify(m,weakened,weak.goal,weak.certificate));
  const distance=structuredClone(weak.certificate);distance.states[distance.chosen].distance=1;reject(()=>A.verify(m,available,weak.goal,distance));
  const transition=structuredClone(weak.certificate);transition.states[0].transitions[0]=0;reject(()=>A.verify(m,available,weak.goal,transition));
  const wrongPick=structuredClone(weak.certificate);wrongPick.chosen=0;reject(()=>A.verify(m,available,weak.goal,wrongPick));
  const cut=structuredClone(weak.goal);cut.requiredInteriorCuts=['between P and T'];reject(()=>A.verify(m,available,cut,weak.certificate));
  const noPhysical=structuredClone(weak.certificate);noPhysical.physicalAdmission=true;reject(()=>A.verify(m,available,weak.goal,noPhysical));
  reject(()=>A.mismatchBound([{duration:c(-1),P:one,T:z}]));
  const early=new A.BoundarySession(m,rho,2,2).enter(entryAvailable,entry),snapshot=early.snapshot();
  const badW=kron(plus(scale(m.I,c(3,0,5)),scale(mm(m.operators.P,m.operators.T),c(0,-4,5))),I);
  reject(()=>early.apply(available,weak.goal,weak.certificate,[W1,W2,badW]));assert.deepEqual(early.snapshot(),snapshot,'all segments validated before the first mutation');
  reject(()=>early.apply(available,weak.goal,weak.certificate,[W1]));assert.deepEqual(early.snapshot(),snapshot);
  reject(()=>runtime.apply(available,weak.goal,weak.certificate,[W1,W2,W1]));assert.deepEqual(runtime.snapshot(),actual);
  const saved=counts();A.verifySpace(m,space);plans.forEach(p=>A.verify(m,available,p.goal,p.certificate));assert.deepEqual(counts(),saved);
  const result={scope:'Exact fixed-boundary control subspace, weaker admitted access, endpoint compilation and retained-context execution',
    control_space_dimension:2,necessary_pair_agreement:'P(t)=T(t) almost everywhere',Q_envelope_independent:true,
    protected_quarter_forms:24,H_minimum_quarter_sections:3,H_single_ratio_section:1,
    equal_total_areas_do_not_protect:true,explicit_leakage:leak,safe_orders_X:[mean(forward),mean(reverse)],
    mismatch_budget:budget,one_owned_input:true,two_independent_goals:true,same_retained_environment:true,no_intermediate_measurements:true,
    construction_calls_during_execution:0,negative_checks:negatives,physical_admission:null,milliseconds:Math.round(performance.now()-t)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-23-agreement-certificates.json');
    fs.writeFileSync(file,R.serialize({space,available,plans,weak,strong,tilted})+'\n',{flag:'wx'});
    fs.writeFileSync(path.join(directory,'wave-23-agreement-realizations.json'),R.serialize({input,unsafe,safeState,budget,actual,returned,reduced})+'\n',{flag:'wx'});
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_control_agreement.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{spaceConstructions:0,linearSolves:0,wordClosures:0});
    result.milliseconds=Math.round(performance.now()-t);fs.writeFileSync(path.join(directory,'wave-23-agreement-checks.json'),R.serialize(result)+'\n',{flag:'wx'});}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
