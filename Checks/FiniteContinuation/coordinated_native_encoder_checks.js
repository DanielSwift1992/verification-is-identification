"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js');
const {c,z,one,ii,add,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=F.exact;
const I=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],axes=[I,X,Y,Z];
const counts=()=>({encoder:{...F.counters},exchange:{...M.counters}});
function check(directory){const started=performance.now(),model=M.currentModel(),available=F.access(),encoder=F.construct(model,available),d=F.verify(model,available,encoder);
  assert.equal(encoder.gates.length,51);assert.equal(d.denominatorSquared,8);assert.deepEqual(tr(d.input),c(4));assert.deepEqual(tr(d.support),c(6));
  assert(!isZero(minus(d.support,model.initial)),'this is a new boundary, not wave17 support');
  const next=[[1,-1,-1],[-1,-1,1]].map(signs=>({signs,certificate:F.compileNext(model,signs)}));
  const verified=next.map(x=>F.verifyNext(model,x.signs,x.certificate));assert.deepEqual(verified.map(x=>x.minimumSections),[1,2]);
  const quaternary=[0,1,2,3],power=(a,n)=>Array.from({length:n},()=>a).reduce(kron);
  // Full encoding covariance fails, as it must for this extra native access.
  const Gx=power(X,4),Gz=power(Z,4);assert(!isZero(comm(d.N,Gx))||!isZero(comm(d.N,Gz)));

  const raw=mat(64,1);for(const [source,e,r,value]of [[4,0,0,one],[6,1,1,ii],[5,0,1,c(2)],[7,1,0,c(-1)]])raw[(source*2+e)*2+r][0]=value;
  const v=mm(kron(d.input,eye(4)),raw),rho=scale(mm(v,adj(v)),div(one,mm(adj(v),v)[0][0]));
  const boundary=new F.EncodedBoundary(model,rho,2,2),initial={};for(const name of ['X','Y','Z'])initial[name]=axes.map(ref=>boundary.read(name,ref));
  const baseline=counts();boundary.encode(available,encoder);assert.deepEqual(counts(),baseline);
  for(const name of ['X','Y','Z'])axes.forEach((ref,i)=>assert.deepEqual(boundary.read(name,ref),initial[name][i]));
  const encoded=boundary.snapshot(),Nfull=kron(d.N,eye(4));eq(scale(mm(mm(adj(Nfull),encoded.rho),Nfull),c(1,0,8)),rho,'full immediate inverse retains the fourth participant too');
  const site=(A,i)=>quaternary.map(j=>i===j?A:I).reduce(kron);
  function background(axis,environment,a,b,den){let W=eye(32);for(let i=0;i<4;i++)W=mm(plus(scale(eye(32),c(a,0,den)),scale(kron(site(axis,i),environment),c(0,-b,den))),W);return W;}
  const W1=background(X,X,3,4,5),W2=mm(kron(model.I,plus(scale(I,c(12,0,13)),scale(Y,c(0,-5,13)))),background(Z,Z,24,7,25));
  assert(!isZero(comm(W1,W2)));
  const episodes=[[W1],[W2,W1]];for(let step=0;step<next.length;step++){boundary.continue(next[step].signs,next[step].certificate,episodes[step]);assert.deepEqual(counts(),baseline);
    for(let q=0;q<3;q++){const sign=next.slice(0,step+1).reduce((s,x)=>s*x.signs[q],1);axes.forEach((ref,i)=>assert.deepEqual(boundary.read(['X','Y','Z'][q],ref),mul(c(sign),initial[['X','Y','Z'][q]][i])));}}
  const actual=boundary.snapshot();assert.equal(actual.steps,2);
  const ideal=new F.EncodedBoundary(model,rho,2,2).encode(available,encoder);next.forEach(x=>ideal.continue(x.signs,x.certificate,F.verifyNext(model,x.signs,x.certificate).word.map(()=>eye(32))));
  assert(!isZero(minus(actual.rho,ideal.snapshot().rho)));

  // The whole joint P/T section has the same endpoint as both sequential
  // quarter sections because P and T commute. Commuting background preserves
  // the logical claim throughout either separately declared implementation.
  assert(isZero(comm(model.operators.P,model.operators.T)));
  eq(verified[1].operator,scale(mm(model.operators.T,model.operators.P),c(-1)));
  // A demanded intermediate P boundary is different from the final code.
  const intermediate=mm(mm(model.operators.P,d.support),model.operators.P);assert(!isZero(minus(intermediate,d.support)));

  // Reversing the entrance after gauge evolution is a different exit claim.
  const pureRaw=mat(16,1);pureRaw[4][0]=one;pureRaw[8][0]=c(-1);const nativeZero=scale(mm(pureRaw,adj(pureRaw)),c(1,0,2));
  const zeroEncoded=scale(mm(mm(d.N,nativeZero),adj(d.N)),c(1,0,8));const collective=power(plus(scale(I,c(3,0,5)),scale(X,c(0,-4,5))),4);
  const nativePartner=mm(mm(Gx,nativeZero),Gx),partnerEncoded=scale(mm(mm(d.N,nativePartner),adj(d.N)),c(1,0,8));
  assert(!isZero(minus(partnerEncoded,mm(mm(Gx,zeroEncoded),Gx))),'the full encoding channel, not only its chosen matrix phase, breaks the former covariance');
  assert.deepEqual(tr(mm(partnerEncoded,d.readings[2].operator)),c(-1));
  const shifted=mm(mm(collective,zeroEncoded),adj(collective));assert.deepEqual(tr(mm(shifted,d.readings[2].operator)),one);
  const merelyReversed=scale(mm(mm(adj(d.N),shifted),d.N),c(1,0,8)),reversedZ=tr(mm(merelyReversed,d.native[2].operator));assert.notDeepEqual(reversedZ,one);
  const enteredSupport=scale(mm(mm(d.N,d.input),adj(d.N)),c(1,0,8));assert(!isZero(comm(enteredSupport,d.J[0])));

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  const absent=structuredClone(available);delete absent.native;rejects(()=>F.verify(model,absent,encoder));
  const weak=structuredClone(available);weak.encodingEpisode='same gate endpoints but arbitrary unbounded intermediate interaction';rejects(()=>F.verify(model,weak,encoder));
  const phase=structuredClone(encoder);phase.gates[1].kind='H up to an undeclared phase';rejects(()=>F.verify(model,available,phase));
  const incomplete=structuredClone(encoder);incomplete.gates.pop();rejects(()=>F.verify(model,available,incomplete));
  const differentSource=structuredClone(encoder);differentSource.source={};rejects(()=>F.verify(model,available,differentSource));
  rejects(()=>F.verify({...model},available,encoder));
  const lie=structuredClone(encoder);lie.physicalAdmission={backend:'unverified'};rejects(()=>F.verify(model,available,lie));
  const noControls=structuredClone(available);noControls.native.maximumControls=2;rejects(()=>F.verify(model,noControls,encoder));
  const pWrong=structuredClone(encoder);pWrong.permutation[0]=0;rejects(()=>F.verify(model,available,pWrong));
  const wrongNorm=structuredClone(encoder);wrongNorm.denominatorSquared=4;rejects(()=>F.verify(model,available,wrongNorm));
  const outside=mat(64);outside[0][0]=one;rejects(()=>new F.EncodedBoundary(model,outside,2,2));
  const unchanged=boundary.snapshot();rejects(()=>boundary.encode(available,encoder));assert.deepEqual(boundary.snapshot(),unchanged);
  const badBackground=kron(site(Z,0),I);rejects(()=>boundary.continue(next[0].signs,next[0].certificate,[badBackground]));assert.deepEqual(boundary.snapshot(),unchanged);
  rejects(()=>boundary.continue(next[1].signs,next[0].certificate,[W1]));assert.deepEqual(boundary.snapshot(),unchanged);
  const snapshot=boundary.snapshot();snapshot.rho=mat(64);snapshot.phase='native';assert.deepEqual(boundary.snapshot(),unchanged);
  const checkBefore=counts();F.verify(model,available,encoder);next.forEach(x=>F.verifyNext(model,x.signs,x.certificate));assert.deepEqual(counts(),checkBefore);
  const result={scope:'Conditional unitary entry of the same unknown native spin, with arbitrary correlated fourth participant/reference, followed by protected exchange continuations',
    native_encoding_contacts:encoder.gates.length,Hadamards:encoder.gates.filter(g=>g.kind==='phase-fixed-H').length,scaled_unitary_denominator_squared:8,
    measurements:0,resets:0,input_support_rank:4,protected_code_rank:6,code_spin:1,logical_X:'Q',logical_Z:'P*T',
    next_exchange_sections:[1,2],full_immediate_inverse:true,retained_correlated_environment:true,all_three_logical_reference_readings_checked:true,
    full_joint_state_changes:true,encoding_noise_guarantee:false,physical_admission:null,construction_calls_during_execution:0,
    naive_inverse_after_gauge_evolution_Z:reversedZ,correct_protected_Z:one,negative_checks:negatives,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-19-native-certificates.json');
    fs.writeFileSync(file,R.serialize({available,encoder,next})+'\n');
    fs.writeFileSync(path.join(directory,'wave-19-native-realizations.json'),R.serialize({rho,encoded,actual,W1,W2,nativeZero,zeroEncoded,shifted,merelyReversed,initial})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_native_encoder.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{constructions:0});assert.deepEqual(result.persistedVerifier.movingConstructionCalls,{normalFormClosures:0});
    result.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'wave-19-native-checks.json'),R.serialize(result)+'\n');}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
