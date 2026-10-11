"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js'),D=require('./coordinated_native_exit.js'),G=require('./coordinated_protected_control.js');
const {c,z,one,add,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=G.exact;
const I=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[c(0,1),z]],Z=[[one,z],[z,c(-1)]],Hn=plus(X,Z),axes=[I,X,Y,Z];
const counterSnapshot=()=>({direct:{...G.counters},entry:{...F.counters},exit:{...D.counters},exchange:{...M.counters}});
function traceE(A,e,r){const out=mat(2*r);for(let a=0;a<2;a++)for(let b=0;b<2;b++)for(let i=0;i<r;i++)for(let j=0;j<r;j++)for(let k=0;k<e;k++)
  out[a*r+i][b*r+j]=add(out[a*r+i][b*r+j],A[(a*e+k)*r+i][(b*e+k)*r+j]);return out;}
function check(directory){const started=performance.now(),m=M.currentModel(),d=F.exchangeCode(m),available=G.access(),L=d.readings.map(q=>q.operator);
  const goal=before=>({kind:'protected-reading-relations',input:d.support,requiredInteriorCuts:[],relations:[{after:d.support,before:d.support},...L.map((after,i)=>({after,before:before[i]}))]});
  // Goals name their future reading relations, not a source pulse sequence.
  const hGoal=goal([L[2],scale(L[1],c(-1)),L[0]]),zGoal=goal([scale(L[0],c(-1)),scale(L[1],c(-1)),L[2]]);
  const xGoal=goal([L[0],scale(L[1],c(-1)),scale(L[2],c(-1))]);
  const tiltedGoal=goal([plus(scale(L[0],c(-7,0,25)),scale(L[2],c(24,0,25))),scale(L[1],c(-1)),plus(scale(L[0],c(24,0,25)),scale(L[2],c(7,0,25)))]);
  const generators=[d.K,...d.J],plans=[hGoal,zGoal,xGoal,tiltedGoal].map(goal=>{const certificate=G.construct(m,available,goal);assert(certificate);
    return {goal,certificate,protection:G.protection(m,available,goal,certificate,generators)};});
  const hv=G.verify(m,available,hGoal,plans[0].certificate);assert.deepEqual(hv.coefficients,[one,one]);assert.deepEqual(hv.norm,c(2));
  assert.equal(G.construct(m,available,goal(L)),null,'a single nonzero plane reflection cannot be the identity on the full qubit');
  // The original no-H result applies to the fixed-quarter permutation grammar.
  const quarterRequirement={input:d.support,relations:hGoal.relations};
  const quarterObstruction=M.construct(m,F.access().exchange,quarterRequirement);assert.equal(M.verify(m,F.access().exchange,quarterRequirement,quarterObstruction),null);
  const base=path.join(__dirname,'../../Research/Artifacts/coordinated-continuation-20260917');
  const old=R.deserialize(fs.readFileSync(path.join(base,'wave-19-native-realizations.json'),'utf8'));
  const oldCert=R.deserialize(fs.readFileSync(path.join(base,'wave-20-exit-certificates.json'),'utf8'));
  const {entryAvailable,entry,available:exitAvailable,exit}=oldCert;F.verify(m,entryAvailable,entry);D.verify(m,exitAvailable,exit);
  const KX=kron(d.K,X),KZ=kron(d.K,Z),W1=plus(scale(eye(32),c(3,0,5)),scale(KX,c(0,-4,5))),
    W2=mm(old.W1,plus(scale(eye(32),c(24,0,25)),scale(KZ,c(0,-7,25))));
  assert(!isZero(comm(W1,W2)),'one retained E has genuinely noncommuting successive interactions');
  assert(!isZero(comm(W1,kron(m.operators.P,I))),'this family would be rejected by the previous individual-contact guarantee');
  const runtime=new G.ProtectedControlBoundary(m,old.rho,2,2),counts=counterSnapshot();
  runtime.enter(entryAvailable,entry).apply(available,hGoal,plans[0].certificate,[W1]).apply(available,zGoal,plans[1].certificate,[W2]).exit(exitAvailable,exit);
  assert.deepEqual(counterSnapshot(),counts,'execution verifies certificates without resolving or constructing');
  const actual=runtime.snapshot(),returned=runtime.nativeState();assert.deepEqual([actual.steps,actual.exits],[2,1]);assert(isZero(returned.B));
  const original=traceE(D.reduceNative(old.rho,2,2),2,2),N=kron(mm(Z,Hn),I),expected=scale(mm(mm(N,original),adj(N)),c(1,0,2));
  eq(traceE(returned.A,2,2),expected);
  for(let i=0;i<3;i++)for(const ref of axes)assert.deepEqual(runtime.read(['X','Y','Z'][i],ref),{a:tr(mm(expected,kron([X,Y,Z][i],ref))),b:z});
  const ideal=new G.ProtectedControlBoundary(m,old.rho,2,2).enter(entryAvailable,entry).apply(available,hGoal,plans[0].certificate,[eye(32)]).apply(available,zGoal,plans[1].certificate,[eye(32)]).exit(exitAvailable,exit);
  eq(traceE(ideal.nativeState().A,2,2),expected);const idealRho=ideal.snapshot().rho;
  assert(!isZero(minus(actual.rho.A,idealRho.A))||!isZero(minus(actual.rho.B,idealRho.B)),'the actual environment and gauge are retained, not reset');

  // Same endpoint channel, different interior admission. Five partial swaps
  // each have area pi/4, a resource absent from fixed-quarter M.access.
  const serial=['P','T','Q','P','T'],partial=name=>plus(m.I,scale(m.operators[name],c(0,-1)));
  let serialN=m.I;for(const name of serial)serialN=mm(partial(name),serialN);
  eq(mm(serialN,d.support),scale(plus(L[0],L[2]),c(-4)),'serial restriction is -H, with denominator sqrt(32)');
  const input=mm(mm(m.operators.Q,old.zeroEncoded),m.operators.Q),W=plus(scale(m.I,c(3,0,5)),scale(d.K,c(0,-4,5)));
  G.jointEpisode(hv,W,1);let serialRho=input,atCut;
  for(let i=0;i<serial.length;i++){const n=partial(serial[i]);serialRho=scale(mm(mm(n,serialRho),adj(n)),c(1,0,2));
    if(i===0){atCut=tr(mm(minus(m.I,d.support),serialRho));serialRho=mm(mm(W,serialRho),adj(W));}}
  const directN=mm(W,hv.N),directRho=scale(mm(mm(directN,input),adj(directN)),c(1,0,2));
  const leakage=tr(mm(minus(m.I,d.support),serialRho)),serialX=tr(mm(L[0],serialRho));
  assert.deepEqual(atCut,c(1,0,2));assert.deepEqual(leakage,c(16,0,25));assert.deepEqual(serialX,c(-9,0,25));
  assert.deepEqual(tr(mm(minus(m.I,d.support),directRho)),z);assert.deepEqual(tr(mm(L[0],directRho)),c(-1));
  const cleanSerial=scale(mm(mm(serialN,input),adj(serialN)),c(1,0,32));eq(cleanSerial,directRho);
  // Operator equalities cover the entire code and arbitrary reference, not
  // only the preceding positive test input.
  assert(isZero(comm(hv.H0,d.support)));assert(!isZero(comm(m.operators.P,d.support)));
  const rawProbe=mm(partial('P'),d.support);assert(!isZero(mm(minus(m.I,d.support),rawProbe)));

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  rejects(()=>G.verify(m,F.access().exchange,hGoal,plans[0].certificate));
  for(const [k,val]of [['synchronization','same areas but unrelated envelopes'],['area','pi/2'],['phase','free coherent controlled lift']]){
    const a=structuredClone(available);a[k]=val;rejects(()=>G.verify(m,a,hGoal,plans[0].certificate));}
  const port=structuredClone(hGoal);port.requiredInteriorCuts=['after P'];rejects(()=>G.verify(m,available,port,plans[0].certificate));
  const wrongSupport=structuredClone(hGoal);wrongSupport.input=m.I;rejects(()=>G.verify(m,available,wrongSupport,plans[0].certificate));
  const badSource=structuredClone(plans[0].certificate);badSource.source={};rejects(()=>G.verify(m,available,hGoal,badSource));
  rejects(()=>G.verify({...m},available,hGoal,plans[0].certificate));
  for(const coefficients of [[z,z],[one,z],[c(0,1),one]]){const p=structuredClone(plans[0].certificate);p.coefficients=coefficients;rejects(()=>G.verify(m,available,hGoal,p));}
  const hw=structuredClone(plans[0].certificate);hw.physicalAdmission={qpu:'unconfirmed'};rejects(()=>G.verify(m,available,hGoal,hw));
  rejects(()=>G.protection(m,available,hGoal,plans[0].certificate,[m.operators.P]));
  const early=new G.ProtectedControlBoundary(m,old.rho,2,2).enter(entryAvailable,entry),before=early.snapshot();
  const Zfull=mm(m.operators.P,m.operators.T),badW=kron(plus(scale(m.I,c(3,0,5)),scale(Zfull,c(0,-4,5))),I);
  rejects(()=>early.apply(available,hGoal,plans[0].certificate,[badW]));assert.deepEqual(early.snapshot(),before);
  rejects(()=>early.apply(available,port,plans[0].certificate,[W1]));assert.deepEqual(early.snapshot(),before);
  rejects(()=>runtime.apply(available,hGoal,plans[0].certificate,[W1]));assert.deepEqual(runtime.snapshot(),actual);
  const copied=runtime.snapshot();copied.rho.A=mat(64);copied.phase='protected';assert.deepEqual(runtime.snapshot(),actual);
  const checkCounts=counterSnapshot();plans.forEach(p=>{G.verify(m,available,p.goal,p.certificate);G.verifyProtection(m,available,p.goal,p.certificate,generators,p.protection);});assert.deepEqual(counterSnapshot(),checkCounts);
  const result={scope:'Conditional direct protected control, full-path background admission, same native input and retained context',
    direct_H_sections:1,previous_native_H_excursion_contacts:93,count_is_not_hardware_time:true,
    no_intermediate_exit:true,entry_contacts:entry.gates.length,final_exit_contacts:exit.gates.length,independent_successive_requests:2,
    source_loaded_once:true,measurements:0,resets:0,retained_noncommuting_environment:true,full_native_reference_exit_verified:true,
    serial_ideal_same_channel:true,serial_cut_outside_code:atCut,serial_final_leakage:leakage,serial_logical_X:serialX,direct_logical_X:c(-1),
    construction_calls_during_execution:0,negative_checks:negatives,native_window_noise_guarantee:false,physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-22-control-certificates.json');
    fs.writeFileSync(file,R.serialize({entryAvailable,entry,exitAvailable,exit,available,plans,generators,quarterRequirement,quarterObstruction})+'\n',{flag:'wx'});
    fs.writeFileSync(path.join(directory,'wave-22-control-realizations.json'),R.serialize({input,W,serialRho,directRho,rho:old.rho,W1,W2,actual,returned,expected})+'\n',{flag:'wx'});
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_protected_control.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{constructions:0,linearSolves:0});
    assert.deepEqual(result.persistedVerifier.entryConstructionCalls,{constructions:0});assert.deepEqual(result.persistedVerifier.exitConstructionCalls,{constructions:0});assert.deepEqual(result.persistedVerifier.exchangeConstructionCalls,{normalFormClosures:0});
    result.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'wave-22-control-checks.json'),R.serialize(result)+'\n',{flag:'wx'});}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
