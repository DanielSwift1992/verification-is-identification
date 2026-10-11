"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),D=require('./coordinated_dynamic_instrument.js');
const {c,z,one,ii,add,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,commutant,scalarText}=D.exact;
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],zero=[[one,z],[z,z]];
const projection=(O,bit)=>scale(plus(eye(O.length),scale(O,c(bit?-1:1))),c(1,0,2));
const expectation=(rho,O)=>tr(mm(rho,O));
function check(outputDirectory){
  const start=performance.now(),model=C.currentModel();
  const request={kind:'logical-boundary-route',preserve:['XI','ZZ'],input:'complete-two-participant-carrier',targets:['ZI','IZ']};
  const available=['XX','ZI','IZ'],plan=D.resolveRoute(model,request,available);
  assert.equal(plan.kind,'constructed-dynamic-route');assert.deepEqual(plan.cycle.program.word,['XX','ZI','XX','IZ']);
  assert.deepEqual(plan.cuts,[1,3]);assert.deepEqual(plan.cycle.decoder,{offset:0,selected:[1,0,1,0]});
  assert.equal(D.resolveRoute(model,request,['ZI','IZ']).kind,'outside-one-bridge-rule');
  const counters={...D.counters},checked=D.verifyRoute(model,request,available,plan),leaves=checked.leaves;
  assert.deepEqual(D.counters,counters);assert.equal(leaves.length,16);
  const logical=[D.pauli('XI'),D.pauli('YZ'),D.pauli('ZZ')];
  // Full operator identities, including the imaginary logical generator,
  // cover arbitrary input states and arbitrary external references.
  for(let j=0;j<3;j++){
    let pulled=mat(4);
    for(const b of leaves){const bit=D.decode(b.outcomes,plan.cycle.decoder),O=scale(logical[j],c(j<2&&bit?-1:1));
      eq(mm(O,b.K),mm(b.K,logical[j]));pulled=plus(pulled,mm(mm(adj(b.K),O),b.K));}
    eq(pulled,logical[j]);
  }
  const fixed=commutant(available.map(D.pauli));assert.equal(fixed.length,2);
  for(const a of fixed)for(const b of fixed)assert(isZero(comm(a,b)));
  const bad=D.compileWord(model,['XX','XX','ZI','IZ']),badCheck=D.verifyWord(model,bad);
  assert.equal(badCheck.admitted,false);assert.equal(badCheck.refusedAfter,3);
  // This is a complete lower bound only inside this three-contact, fixed-word
  // grammar and the independent requirement to visit ZI before final IZ.
  let shorterRoutes=0;
  for(let n=2;n<4;n++)for(let k=0;k<3**n;k++){
    let v=k;const word=Array.from({length:n},()=>{const label=available[v%3];v=Math.floor(v/3);return label;});
    if(word.at(-1)!=='IZ'||!word.slice(0,-1).includes('ZI'))continue;
    shorterRoutes++;assert.equal(D.verifyWord(model,D.compileWord(model,word)).admitted,false);
  }
  // Same actual carrier and its reference continue twenty times. The runtime
  // stores two subnormalized blocks, not the exponentially growing history.
  const bell=mat(8);for(const i of [0,5])for(const j of [0,5])bell[i][j]=c(1,0,2); // A,B,R; B=0
  const boundary=new D.RecordedBoundary(model,bell,2);
  const reference=[I2,X,Y,Z],before=logical.map(O=>reference.map(T=>expectation(bell,kron(O,T))));
  for(let i=0;i<20;i++){
    boundary.continue(request,available,plan);
    ['x','y','z'].forEach((q,j)=>reference.forEach((T,k)=>assert.deepEqual(boundary.readLogical(q,T),before[j][k])));
    assert.equal(boundary.snapshot().blocks.length,2);
  }
  assert.deepEqual(before.map((row,j)=>row[j+1]),[one,c(-1),one]);
  // No preparation of the gauge is needed: its correlation with logical X
  // can condition normalized branch states even while the aggregate survives.
  const correlated=scale(plus(eye(4),D.pauli('IX')),c(1,0,4));
  const Kplus=D.instrument('XX').branches[0].K,conditioned=mm(mm(Kplus,correlated),Kplus);
  assert.deepEqual(expectation(correlated,logical[0]),z);
  assert.deepEqual(expectation(conditioned,logical[0]),c(1,0,2));assert.deepEqual(tr(conditioned),c(1,0,2));
  const corrBoundary=new D.RecordedBoundary(model,correlated);
  corrBoundary.continue(request,available,plan);
  logical.forEach((O,j)=>assert.deepEqual(corrBoundary.readLogical(['x','y','z'][j]),expectation(correlated,O)));
  // Forgetting the actual parity makes orthogonal logical inputs identical.
  const plusBoundary=new D.RecordedBoundary(model,kron(projection(X,0),zero));
  const minusBoundary=new D.RecordedBoundary(model,kron(projection(X,1),zero));
  plusBoundary.continue(request,available,plan);minusBoundary.continue(request,available,plan);
  const bp=plusBoundary.snapshot().blocks,bm=minusBoundary.snapshot().blocks;
  eq(plus(bp[0],bp[1]),plus(bm[0],bm[1]));
  assert.deepEqual(plusBoundary.readLogical('x'),one);assert.deepEqual(minusBoundary.readLogical('x'),c(-1));
  bp.forEach(block=>assert.deepEqual(tr(block),c(1,0,2)));
  const independent=bp.map(()=>scale(plus(bp[0],bp[1]),c(1,0,2)));
  assert.deepEqual(add(expectation(independent[0],logical[0]),D.exact.neg(expectation(independent[1],logical[0]))),z);
  // If B is discarded and the output is the original physical A, B=0 is an
  // additional input condition. Four projectively distinct Pauli frames remain.
  const frames=new Set();
  for(const b of leaves){const m=D.decode(b.outcomes,plan.cycle.decoder),d=b.outcomes[3];
    const reduced=Array.from({length:2},(_,i)=>Array.from({length:2},(_,j)=>b.K[2*i+d][2*j]));
    const U=mm(d?X:I2,m?Z:I2),four=scale(reduced,c(4));
    assert(isZero(minus(four,U))||isZero(plus(four,U)));
    frames.add(`${m},${d}`);
    // The record distribution cannot detect a Pauli error on the unknown A.
    eq(mm(adj(reduced),reduced),scale(I2,c(1,0,16)));
  }
  assert.equal(frames.size,4);
  // An error during the cycle, immediately after the first acquisition, can
  // also act logically without changing the complete record distribution.
  let disturbedZ=mat(4);
  for(const b of leaves){let K=eye(4);
    b.outcomes.forEach((bit,i)=>{K=mm(D.instrument(plan.cycle.program.word[i]).branches[bit].K,K);if(i===0)K=mm(logical[0],K);});
    eq(K,mm(b.K,logical[0]));
    const fromB0=K.map(row=>[row[0],row[2]]);eq(mm(adj(fromB0),fromB0),scale(I2,c(1,0,16)));
    disturbedZ=plus(disturbedZ,mm(mm(adj(K),logical[2]),K));
  }
  eq(disturbedZ,scale(logical[2],c(-1)));
  // Such an error remains a logical error. This construction is not a code
  // correcting arbitrary external noise, even though it survives its checks.
  const corrupted=mm(mm(kron(kron(Z,I2),I2),bell),kron(kron(Z,I2),I2));
  const erroneous=new D.RecordedBoundary(model,corrupted,2);erroneous.continue(request,available,plan);
  assert.deepEqual(erroneous.readLogical('x',X),c(-1));
  assert.deepEqual(erroneous.readLogical('z',Z),one);

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  const clone=()=>structuredClone(plan);
  let badPlan=clone();badPlan.cycle.decoder.selected[0]=0;
  rejects(()=>D.verifyRoute(model,request,available,badPlan));
  badPlan=clone();badPlan.cycle.program.nodes[1].step.outputs[0].x=D.pauli('XI');
  rejects(()=>D.verifyRoute(model,request,available,badPlan));
  badPlan=clone();badPlan.cycle.program.nodes[1].outcomes=[1];
  rejects(()=>D.verifyRoute(model,request,available,badPlan));
  badPlan=clone();badPlan.cycle.sourceFlip=[0,1];rejects(()=>D.verifyRoute(model,request,available,badPlan));
  badPlan=clone();badPlan.physicalAdmission={backend:'unverified'};rejects(()=>D.verifyRoute(model,request,available,badPlan));
  badPlan=clone();badPlan.cycle.program.source={forged:true};rejects(()=>D.verifyRoute(model,request,available,badPlan));
  rejects(()=>D.verifyRoute({...model},request,available,plan));
  rejects(()=>D.verifyRoute(model,{...request,targets:['IZ','ZI']},available,plan));
  rejects(()=>D.verifyRoute(model,request,['ZI','IZ'],plan));
  const beforeRejected=boundary.snapshot();badPlan=clone();badPlan.cycle.decoder.offset=1;
  rejects(()=>boundary.continue(request,available,badPlan));assert.deepEqual(boundary.snapshot(),beforeRejected);
  rejects(()=>boundary.readLogical('x',[[one,ii],[z,one]]));
  const out={scope:'Exact ideal instruments and record-conditioned logical algebra; no hardware or error-correction admission',
    independently_requested_boundaries:request.targets,constructed_word:plan.cycle.program.word,
    minimum_sections_in_declared_fixed_word_grammar:4,shorter_routes_refuted:shorterRoutes,
    branch_count:leaves.length,logical_operator_identities:3,fixed_common_commutant_dimension:fixed.length,
    fixed_common_commutant_is_abelian:true,wrong_order_refused_after:badCheck.refusedAfter,
    decoder:plan.cycle.decoder,continued_cycles:20,retained_classical_blocks:2,
    reference_correlations_preserved:['XX=1','YY=-1','ZZ=1'],full_carrier_requires_one_record_bit:true,
    discarded_second_carrier_has_distinct_Pauli_frames:frames.size,
    forgotten_record_collapses_logical_X_inputs:true,independent_record_same_frequency_fails:true,
    branch_conditioning_is_not_claimed_absent:true,external_logical_error_undetected:true,
    error_during_cycle_same_record_effects_and_reversed_Z:true,
    negative_checks:negatives,rejection_before_state_mutation:true,physical_admission:null,
    milliseconds:Math.round(performance.now()-start)};
  if(outputDirectory){fs.mkdirSync(outputDirectory,{recursive:true});const f=path.join(outputDirectory,'wave-5-dynamic-route.json');
    fs.writeFileSync(f,R.serialize(plan)+'\n');
    fs.writeFileSync(path.join(outputDirectory,'wave-5-dynamic-obstruction.json'),R.serialize(bad)+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_dynamic_instrument.js'),f],{encoding:'utf8',timeout:15000});
    assert.equal(cp.status,0,cp.stderr);out.persistedVerifier=JSON.parse(cp.stdout);
    assert.deepEqual(out.persistedVerifier.constructionCalls,{frameSearches:0,decoderSolves:0});
    out.milliseconds=Math.round(performance.now()-start);
    fs.writeFileSync(path.join(outputDirectory,'wave-5-dynamic-checks.json'),JSON.stringify(out,null,2)+'\n');}
  return out;
}
if(require.main===module)console.log(JSON.stringify(check(process.argv[2]),null,2));
module.exports={check};
