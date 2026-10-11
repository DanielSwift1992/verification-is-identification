"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js'),D=require('./coordinated_native_exit.js'),T=require('./coordinated_instrument_transport.js'),B=require('./renewable_boundary.js');
const {c,z,one,ii,add,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=B.exact;
const I=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],P0=[[one,z],[z,z]],P1=minus(I,P0),axes=[I,X,Y,Z];
function traceContext(A,e,r){const out=mat(2*r);for(let a=0;a<2;a++)for(let b=0;b<2;b++)for(let i=0;i<r;i++)for(let j=0;j<r;j++)for(let k=0;k<e;k++)
  out[a*r+i][b*r+j]=add(out[a*r+i][b*r+j],A[(a*e+k)*r+i][(b*e+k)*r+j]);return out;}
const counts=()=>({local:{...B.counters},entry:{...F.counters},transport:{...T.counters},exit:{...D.counters}});
function check(directory){const started=performance.now(),m=M.currentModel(),V=B.exampleError(),cp=B.completion(m,V),d=B.verifyCompletion(m,V,cp),L=cp.readings.map(q=>q.operator);
  assert.deepEqual(tr(cp.support),c(12));assert.deepEqual(tr(cp.initial),c(6));assert.deepEqual(tr(cp.other),c(6));
  const available=B.actionAccess(),goal=before=>({kind:'independent-continuation-relations',input:cp.support,requiredInteriorCuts:[],relations:L.map((after,i)=>({after,before:before[i]}))});
  const hGoal=goal([L[2],scale(L[1],c(-1)),L[0]]),zGoal=goal([scale(L[0],c(-1)),scale(L[1],c(-1)),L[2]]);
  const actions=[hGoal,zGoal].map(g=>B.constructAction(m,cp,available,g));actions.forEach(p=>assert(p));
  const ret=B.constructReturn(m,cp),rv=B.verifyReturn(m,cp,ret.available,ret);assert.equal(ret.word.length,24);
  // Native lowering is derived from phases, including their controlled sign.
  const negCp=B.completion(m,scale(V,c(-1))),negRet=B.constructReturn(m,negCp);assert.equal(negRet.word.length,27);B.verifyReturn(m,negCp,negRet.available,negRet);
  // The previous generic court accepts the full algebra for unobserved I/V
  // alternatives and refuses hidden logical errors. No new rule in that court.
  const initial=B.frame(cp.initial,d.readings),extended=B.frame(cp.support,cp.readings),noise={kind:'declared-recorded-instrument',inputDimension:16,outcomes:[{label:'unread',kraus:[scale(m.I,c(3,0,5)),scale(V,c(4,0,5))]}]};
  const transported=T.construct(m.base,initial,noise);assert(T.verify(m.base,initial,noise,transported).admitted);const tf=transported.outputs[0].frame;eq(tf.support,cp.support);tf.readings.forEach((q,i)=>eq(q.operator,L[i]));
  const logicalError=plus(d.readings[2].operator,minus(m.I,cp.initial)),badNoise={...noise,outcomes:[{label:'unread',kraus:[scale(m.I,c(3,0,5)),scale(logicalError,c(4,0,5))]}]};
  const forbidden=T.construct(m.base,initial,badNoise);assert.equal(T.verify(m.base,initial,badNoise,forbidden).admitted,false);
  // The coherent return transports all of the declared algebra without a
  // classical outcome, but with an actual separate quantum output carrier.
  const J=mm(rv.U,kron(m.I,[[one],[z]])),returnInstrument={kind:'declared-recorded-instrument',inputDimension:16,outcomes:[{label:'unread',kraus:[J]}]},returnProof=T.construct(m.base,extended,returnInstrument);
  assert(T.verify(m.base,extended,returnInstrument,returnProof).admitted);returnProof.outputs[0].frame.readings.forEach((q,i)=>eq(q.operator,kron(d.readings[i].operator,I)));
  // A recovery generator, not a classical feedback schedule. Its nonlogical
  // resource is an explicitly engineered dissipative coupling, not assumed.
  const jump=mm(cp.initial,V);eq(mm(adj(jump),jump),cp.other);eq(mm(jump,adj(jump)),cp.initial);
  const lindbladStar=O=>minus(mm(mm(adj(jump),O),jump),scale(plus(mm(cp.other,O),mm(O,cp.other)),c(1,0,2)));
  L.forEach(O=>{eq(comm(O,jump),mat(16));eq(lindbladStar(O),mat(16));});eq(lindbladStar(cp.other),scale(cp.other,c(-1)));
  const A0=plus(minus(m.I,cp.other),scale(cp.other,c(3,0,5))),A1=scale(jump,c(4,0,5)),damping={kind:'declared-recorded-instrument',inputDimension:16,outcomes:[{label:'unread',kraus:[A0,A1]}]},dampingProof=T.construct(m.base,extended,damping);
  assert(T.verify(m.base,extended,damping,dampingProof).admitted);eq(plus(mm(mm(adj(A0),cp.other),A0),mm(mm(adj(A1),cp.other),A1)),scale(cp.other,c(9,0,25)));
  // All noise is joint with the SAME retained environment. The two source
  // generators do not commute; no fresh-channel/iid premise is introduced.
  const W1=plus(scale(eye(32),c(3,0,5)),scale(kron(V,X),c(0,-4,5))),W2=plus(scale(eye(32),c(5,0,13)),scale(kron(d.K,X),c(0,-12,13)));
  assert(!isZero(comm(W1,W2)));B.validateEpisode(d,W1,2);B.validateEpisode(d,W2,2);
  const root=path.join(__dirname,'../../Research/Artifacts/coordinated-continuation-20260917'),old=R.deserialize(fs.readFileSync(path.join(root,'wave-19-native-realizations.json'),'utf8')),native=R.deserialize(fs.readFileSync(path.join(root,'wave-20-exit-certificates.json'),'utf8'));
  const runtime=new B.RenewableBoundary(m,cp,old.rho,2,2,P0),beforeCounts=counts();runtime.enter(native.entryAvailable,native.entry).act(available,hGoal,actions[0],[W1]);
  const disturbed=runtime.snapshot(),leak=tr(mm(kron(cp.other,eye(8)),disturbed.rho));assert.deepEqual(leak,c(16,0,25));
  runtime.restore(ret.available,ret);const restored=runtime.snapshot();eq(mm(mm(kron(cp.initial,eye(8)),restored.rho),kron(cp.initial,eye(8))),restored.rho);
  const usedWeight=tr(mm(kron(kron(m.I,P1),eye(4)),restored.rho));assert.deepEqual(usedWeight,leak);
  runtime.act(available,zGoal,actions[1],[W2]).exit(native.available,native.exit);assert.deepEqual(counts(),beforeCounts);
  const final=runtime.snapshot();assert.equal(final.phase,'returned');assert(isZero(final.rho.B));const actual=traceContext(D.reduceNative(final.rho.A,4,2),4,2),original=traceContext(D.reduceNative(old.rho,2,2),2,2),NH=kron(mm(Z,plus(X,Z)),I),expected=scale(mm(mm(NH,original),adj(NH)),c(1,0,2));eq(actual,expected);
  // Alternative continuation: keep the larger boundary, perform the second
  // action BEFORE any return. Same input, same E; no intermediate restoration.
  const carry=new B.RenewableBoundary(m,cp,old.rho,2,2,P0).enter(native.entryAvailable,native.entry).act(available,hGoal,actions[0],[W1]).act(available,zGoal,actions[1],[W2]);
  const carried=carry.snapshot();assert.deepEqual(tr(mm(kron(cp.other,eye(8)),carried.rho)),leak);carry.restore(ret.available,ret).exit(native.available,native.exit);
  eq(traceContext(D.reduceNative(carry.snapshot().rho.A,4,2),4,2),expected);
  // Finite repeated use covers one E with accumulated history. The operator
  // commutators, not this sample count, establish the general family claim.
  const loop=new B.RenewableBoundary(m,cp,old.rho,2,2,P0).enter(native.entryAvailable,native.entry);let nativeExpected=original;
  for(let k=0;k<4;k++)for(let j=0;j<2;j++){loop.act(available,[hGoal,zGoal][j],actions[j],[[W1,W2][j]]);const n=kron(j?Z:plus(X,Z),I);nativeExpected=scale(mm(mm(n,nativeExpected),adj(n)),c(1,0,j?1:2));}
  loop.restore(ret.available,ret).exit(native.available,native.exit);eq(traceContext(D.reduceNative(loop.snapshot().rho.A,4,2),4,2),nativeExpected);
  // One retained syndrome carrier cannot be silently reinitialized. An exact
  // V error followed by no error causes deterministic leakage on raw reuse.
  const encoded=old.zeroEncoded,error=mm(mm(V,encoded),V),first=mm(mm(rv.U,kron(error,P0)),adj(rv.U));eq(first,kron(encoded,P1));
  const reused=mm(mm(rv.U,first),adj(rv.U));assert.deepEqual(tr(mm(kron(cp.other,I),reused)),one);
  // The old native Q acts correctly in the original code but is not the
  // derived extended X. Show a concrete distinguishing input in the error sector.
  const fullLogicalZ=plus(d.readings[2].operator,mm(mm(V,d.readings[2].operator),V));
  const rawOut=mm(mm(m.operators.Q,error),m.operators.Q),rightOut=mm(mm(L[0],error),L[0]);const rawZ=tr(mm(fullLogicalZ,rawOut)),rightZ=tr(mm(fullLogicalZ,rightOut));
  assert(!isZero(minus(rawOut,rightOut)));assert.notDeepEqual(rawZ,rightZ);
  // Some old collective background generators are not admitted in the new
  // completion. The enlarged domain is NOT universally stronger protection.
  assert(!isZero(comm(d.J[0],cp.support)));
  let negatives=0;const reject=f=>{assert.throws(f);negatives++;};
  const wrong=structuredClone(cp);wrong.support=m.I;reject(()=>B.verifyCompletion(m,V,wrong));const source=structuredClone(cp);source.source={};reject(()=>B.verifyCompletion(m,V,source));reject(()=>B.verifyCompletion({...m},V,cp));
  const fake=structuredClone(cp);fake.physicalAdmission=true;reject(()=>B.verifyCompletion(m,V,fake));
  const wrongCoeffs=structuredClone(actions[0]);wrongCoeffs.coefficients=[one,z];reject(()=>B.verifyAction(m,cp,available,hGoal,wrongCoeffs));
  const endpointOnly=structuredClone(available);endpointOnly.path='only final matrix';reject(()=>B.verifyAction(m,cp,endpointOnly,hGoal,actions[0]));
  const badReturn=structuredClone(ret);badReturn.word.pop();reject(()=>B.verifyReturn(m,cp,ret.available,badReturn));
  const noFresh=structuredClone(ret.available);noFresh.freshCarriers=0;reject(()=>B.verifyReturn(m,cp,noFresh,ret));
  const bareModel=B.completion(m,m.operators.P);assert.equal(B.verifyCompletion(m,m.operators.P,bareModel),null);
  reject(()=>new B.RenewableBoundary(m,cp,old.rho,2,2,P1));reject(()=>new B.RenewableBoundary(m,cp,old.rho,2,2));
  const locked=new B.RenewableBoundary(m,cp,old.rho,2,2,P0).enter(native.entryAvailable,native.entry).act(available,hGoal,actions[0],[W1]).restore(ret.available,ret),prior=locked.snapshot();
  reject(()=>locked.restore(ret.available,ret));assert.deepEqual(locked.snapshot(),prior);
  const badW=kron(plus(scale(m.I,c(3,0,5)),scale(logicalError,c(0,-4,5))),I);
  reject(()=>locked.act(available,zGoal,actions[1],[W2,badW]));assert.deepEqual(locked.snapshot(),prior);
  reject(()=>runtime.act(available,zGoal,actions[1],[W2]));
  const copy=runtime.snapshot();copy.rho.A=mat(128);assert.deepEqual(runtime.snapshot(),final);
  const stats={scope:'Derived larger boundary, optional coherent return and same-input continued use; conditional exact model',initial_dimension:6,completed_dimension:12,minimal_common_invariant_extension:true,
    independent_actions:2,one_owned_native_input:true,retained_noncommuting_environment:true,full_native_reference_output_verified:true,
    classical_acquisition_bits:0,measurements:0,resets:0,fresh_return_carriers:1,return_native_contacts:24,old_boundary_leakage:leak,
    logical_content_survives_before_return:true,return_can_be_postponed:true,retained_return_record_weight:usedWeight,raw_reuse_leakage:one,
    repeated_actions_before_single_return:8,old_raw_Q_Z:rawZ,extended_X_Z:rightZ,old_collective_family_not_automatically_admitted:true,
    hidden_logical_error_refused:true,generic_instrument_court_unchanged:true,dissipative_generator_preserves_logical_algebra:true,declared_partial_return_leakage_factor:c(9,0,25),
    application_construction_calls:0,negative_checks:negatives,physical_admission:null,native_return_interior_protection:false,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const bundle={completion:cp,actions,return:ret},cert=path.join(directory,'certificates.json');fs.writeFileSync(cert,R.serialize(bundle)+'\n',{flag:'wx'});
    const receipt={transported,returnProof,forbidden,dampingProof,noise,damping,jump,W1,W2,expected,actual,rawZ,rightZ};fs.writeFileSync(path.join(directory,'operator-evidence.json'),R.serialize(receipt)+'\n',{flag:'wx'});
    const result=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'renewable_boundary.js'),cert],{encoding:'utf8',timeout:15000});assert.equal(result.status,0,result.stderr);stats.persistedVerifier=R.deserialize(result.stdout);assert.deepEqual(stats.persistedVerifier.counters,{completions:0,actionSolves:0,returnConstructions:0});
    stats.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'checks.json'),R.serialize(stats)+'\n',{flag:'wx'});}
  return stats;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
