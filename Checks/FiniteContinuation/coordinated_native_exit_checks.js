"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js'),D=require('./coordinated_native_exit.js');
const {c,z,one,ii,add,mul,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=D.exact;
const {lift,qmul,qadj,qeq,tensor,act}=D;
const I=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],Hn=[[one,one],[one,c(-1)]],axes=[I,X,Y,Z];
const counters=()=>({exit:{...D.counters},entry:{...F.counters},exchange:{...M.counters}});
function traceE(A,e,r){const out=mat(2*r);for(let a=0;a<2;a++)for(let b=0;b<2;b++)for(let i=0;i<r;i++)for(let j=0;j<r;j++)for(let k=0;k<e;k++)out[a*r+i][b*r+j]=add(out[a*r+i][b*r+j],A[(a*e+k)*r+i][(b*e+k)*r+j]);return out;}
function check(directory){const started=performance.now(),model=M.currentModel(),entryAvailable=F.access(),entry=F.construct(model),available=D.access(),exit=D.construct(model),v=D.verify(model,available,exit),d=F.verify(model,entryAvailable,entry);
  assert.equal(exit.gates.length,46);assert.equal(exit.gates.filter(g=>g.kind==='phase-fixed-controlled-H').length,2);assert.deepEqual(tr(v.output),c(6));
  // A coherent excursion through the native interface supplies H on the
  // same encoded data, with the complete gauge context retained.
  const nativeH={kind:'phase-fixed-H',target:2},H=D.gate(nativeH,available),excursion=qmul(qadj(v.U),qmul(H,v.U));
  const expectedH={A:mat(16),B:scale(plus(d.readings[0].operator,d.readings[2].operator),c(1,0,2))};
  qeq(qmul(excursion,lift(d.support)),expectedH);
  const hRequirement={input:d.support,relations:[{after:d.support,before:d.support},
    {after:d.readings[0].operator,before:d.readings[2].operator},{after:d.readings[1].operator,before:scale(d.readings[1].operator,c(-1))},{after:d.readings[2].operator,before:d.readings[0].operator}]};
  const hObstruction=M.construct(model,entryAvailable.exchange,hRequirement);assert.equal(hObstruction.kind,'fixed-access-obstruction');assert.equal(M.verify(model,entryAvailable.exchange,hRequirement,hObstruction),null);
  const next=[[1,-1,-1],[-1,-1,1],[1,1,1]].map(signs=>({signs,certificate:F.compileNext(model,signs)}));
  const old=R.deserialize(fs.readFileSync(path.join(__dirname,'../../Research/Artifacts/coordinated-continuation-20260917/wave-19-native-realizations.json'),'utf8'));
  const {rho,W1,W2}=old,boundary=new D.ContinuingBoundary(model,rho,2,2),initial={};
  for(const name of ['X','Y','Z'])initial[name]=axes.map(ref=>boundary.read(name,ref));
  const baseline=counters();boundary.enter(entryAvailable,entry);assert.deepEqual(counters(),baseline);
  boundary.continue(next[0].signs,next[0].certificate,[W1]);const beforeVisit=boundary.snapshot();
  boundary.exit(available,exit).reenter(available,exit);qeq(boundary.snapshot().rho,beforeVisit.rho,'exit and immediate inverse preserve the full changed context');
  boundary.exit(available,exit);const afterX=boundary.nativeState();assert(isZero(afterX.B));
  boundary.nativeControl(nativeH,available).reenter(available,exit);
  boundary.continue(next[1].signs,next[1].certificate,[W2,W1]).exit(available,exit);assert.deepEqual(counters(),baseline);
  const actual=boundary.snapshot();assert.deepEqual([actual.steps,actual.exits,actual.reentries],[2,3,2]);
  const returned=boundary.nativeState();assert(isZero(returned.B),'native data and actual E/reference have rational reduction for this witness');
  const initialReduced=traceE(D.reduceNative(rho,2,2),2,2),logicalN=mm(mm(Z,Hn),X),logicalOnReference=kron(logicalN,I);
  const expected=scale(mm(mm(logicalOnReference,initialReduced),adj(logicalOnReference)),c(1,0,2));eq(traceE(returned.A,2,2),expected);
  for(let i=0;i<3;i++)for(const ref of axes){const O=kron([X,Y,Z][i],ref);assert.deepEqual(boundary.read(['X','Y','Z'][i],ref),{a:tr(mm(expected,O)),b:z});}
  // The same sequence without background keeps different total quantum
  // context, while the promised native data/reference exit is identical.
  const ideal=new D.ContinuingBoundary(model,rho,2,2).enter(entryAvailable,entry).continue(next[0].signs,next[0].certificate,[eye(32)]);
  ideal.exit(available,exit).nativeControl(nativeH,available).reenter(available,exit).continue(next[1].signs,next[1].certificate,[eye(32),eye(32)]).exit(available,exit);
  const idealFull=ideal.snapshot().rho;assert(!isZero(minus(actual.rho.A,idealFull.A))||!isZero(minus(actual.rho.B,idealFull.B)));
  eq(traceE(ideal.nativeState().A,2,2),expected);

  // Correct the precise previous counterexample through an actual owned
  // continuation. The input is not replaced with a newly prepared answer.
  const collective=Array.from({length:4},()=>plus(scale(I,c(3,0,5)),scale(X,c(0,-4,5)))).reduce(kron);
  const counter=new D.ContinuingBoundary(model,old.nativeZero).enter(entryAvailable,entry).continue(next[2].signs,next[2].certificate,[collective]);
  qeq(counter.snapshot().rho,lift(old.shifted));counter.exit(available,exit);assert.deepEqual(counter.read('Z'),{a:one,b:z});
  eq(counter.nativeState().A,[[one,z],[z,z]]);assert(isZero(counter.nativeState().B));
  const oldZ=tr(mm(old.merelyReversed,d.native[2].operator));assert.deepEqual(oldZ,c(337,0,625));

  // Unitarity of a controlled contact alone does not bind its relative phase.
  let badU=lift(model.I),changed=false;for(const g of exit.gates){let U=D.gate(g,available);
    if(!changed&&g.kind==='phase-fixed-controlled-H'){U={A:U.A,B:scale(U.B,c(0,-1))};D.unitary(U);changed=true;}badU=qmul(U,badU);}
  D.unitary(badU);const badOnCode=qmul(badU,lift(d.support));
  assert(d.readings.some((L,i)=>{const a=qmul(lift(d.native[i].operator),badOnCode),b=qmul(badOnCode,lift(L.operator));return !isZero(minus(a.A,b.A))||!isZero(minus(a.B,b.B));}));

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  const missing=structuredClone(available);delete missing.controlledH;rejects(()=>D.verify(model,missing,exit));
  const unknown=structuredClone(available);unknown.windows='same endpoints with uncontrolled unknown interactions';rejects(()=>D.verify(model,unknown,exit));
  const badRoot=structuredClone(exit);badRoot.source={};rejects(()=>D.verify(model,available,badRoot));
  rejects(()=>D.verify({...model},available,exit));
  const fakeHardware=structuredClone(exit);fakeHardware.physicalAdmission={qpu:'unconfirmed'};rejects(()=>D.verify(model,available,fakeHardware));
  const wrongOperator=structuredClone(exit);wrongOperator.operator.B[0][0]=one;rejects(()=>D.verify(model,available,wrongOperator));
  const wrongFrame=structuredClone(exit);wrongFrame.output=entry.input;rejects(()=>D.verify(model,available,wrongFrame));
  const truncated=structuredClone(exit);truncated.gates.pop();rejects(()=>D.verify(model,available,truncated));
  const oldBoundary=boundary.snapshot();rejects(()=>boundary.exit(available,exit));assert.deepEqual(boundary.snapshot(),oldBoundary);
  rejects(()=>boundary.continue(next[0].signs,next[0].certificate,[W1]));assert.deepEqual(boundary.snapshot(),oldBoundary);
  rejects(()=>boundary.nativeControl({kind:'phase-fixed-H',target:0},available));assert.deepEqual(boundary.snapshot(),oldBoundary);
  rejects(()=>boundary.reenter(missing,exit));assert.deepEqual(boundary.snapshot(),oldBoundary);
  const switched=structuredClone(exit);switched.gates.reverse();rejects(()=>boundary.reenter(available,switched));assert.deepEqual(boundary.snapshot(),oldBoundary);
  const snapshot=boundary.snapshot();snapshot.rho.A=mat(64);snapshot.phase='protected';assert.deepEqual(boundary.snapshot(),oldBoundary);
  const verifyBefore=counters();D.verify(model,available,exit);M.verify(model,entryAvailable.exchange,hRequirement,hObstruction);assert.deepEqual(counters(),verifyBefore);
  const result={scope:'Conditional full-code coherent native exit, same-context re-entry and a new action between visits',
    entry_contacts:51,exit_contacts:46,controlled_H_contacts:2,full_code_rank:6,native_boundary_rank:6,
    no_measurements:true,no_resets:true,source_loaded_once:true,retained_environment:true,unchanged_context_on_immediate_reentry:true,
    one_new_native_H_between_visits:true,H_available_in_fixed_quarter_exchange_language:false,all_native_reference_relations_verified:true,
    previous_naive_inverse_Z:oldZ,correct_native_exit_Z:one,construction_calls_during_execution:0,negative_checks:negatives,
    encoding_and_exit_noise_guarantee:false,physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-20-exit-certificates.json');
    fs.writeFileSync(file,R.serialize({entryAvailable,entry,available,exit,next,hRequirement,hObstruction})+'\n');
    fs.writeFileSync(path.join(directory,'wave-20-exit-realizations.json'),R.serialize({rho,actual,returned,expected,beforeVisit,counter:counter.snapshot(),badU})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_native_exit.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{constructions:0});assert.deepEqual(result.persistedVerifier.entryConstructionCalls,{constructions:0});assert.deepEqual(result.persistedVerifier.exchangeConstructionCalls,{normalFormClosures:0});
    result.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'wave-20-exit-checks.json'),R.serialize(result)+'\n');}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
