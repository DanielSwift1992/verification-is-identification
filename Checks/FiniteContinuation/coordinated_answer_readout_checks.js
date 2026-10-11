"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const T=require('./coordinated_instrument_transport.js'),W=require('./coordinated_future_conditioned_admission.js'),A=require('./coordinated_answer_readout.js');
const {c,z,one,ii,add,mat,eye,scale,plus,minus,adj,mm,kron,tr,eq,isZero}=A.exact;
function check(directory){const start=performance.now(),m=M.currentModel(),d=W.data(m),available=A.access();
  const certificates=[d.O,scale(d.O,c(-1)),m.I,scale(m.I,c(-1)),m.operators.Q].map(q=>A.construct(m,available,q));
  const verified=certificates.map(p=>A.verify(m,available,p.question,p));assert.deepEqual(verified.map(v=>v.admitted),[true,true,true,true,false]);
  assert.deepEqual(verified.slice(0,4).map(v=>v.measurements),[4,4,0,0]);
  for(let x=0;x<16;x++){const expected=(((x>>3)&1)&((x>>2)&1))^(((x>>1)&1)&(x&1));assert.equal(certificates[0].decoder[x],expected);assert.equal(certificates[1].decoder[x],1-expected);}
  const base=path.join(__dirname,'../../Research/Artifacts/coordinated-continuation-20260917'),old=R.deserialize(fs.readFileSync(path.join(base,'wave-19-native-realizations.json'),'utf8')),
    native=R.deserialize(fs.readFileSync(path.join(base,'wave-20-exit-certificates.json'),'utf8')),continuation=R.deserialize(fs.readFileSync(path.join(base,'wave-25-future-certificates.json'),'utf8'));
  W.verify(m,continuation);const output=continuation.next.cases[0].outputs[0].frame,readoutStage=T.deriveStage(m.base,[output],verified[0].instrument);
  assert.equal(readoutStage.cases[0].kind,'instrument-algebra-transport');
  const source=new W.FutureBoundary(m,d.weak,old.rho,4).enter(native.entryAvailable,native.entry),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],paulis=[eye(2),X,Y,Z],refs=paulis.flatMap(P=>paulis.map(Q=>kron(P,Q))),initial=refs.map(O=>source.read('Z',O));
  const counts={instrument:{...T.counters},readout:{...A.counters}};
  source.continue(d.first,continuation.weak).continue(d.next,continuation.next);const before=source.snapshot();
  source.continue(verified[0].instrument,readoutStage);const actual=source.snapshot();assert.equal(actual.blocks.length,2);assert.equal(actual.steps,3);
  refs.forEach((O,i)=>assert.deepEqual(source.read('Z',O),initial[i]));assert.deepEqual({instrument:{...T.counters},readout:{...A.counters}},counts);
  // The grouped raw outcomes equal the intended cq answer/reference output
  // on this correlated input; no expected preparation bit is substituted.
  const rho=before.blocks[0].rho;for(let a=0;a<2;a++){const P=verified[0].effects[a],projected=mm(kron(P,eye(4)),rho),conditional=mat(4);
    for(let i=0;i<16;i++)for(let r=0;r<4;r++)for(let s=0;s<4;s++)conditional[r][s]=add(conditional[r][s],projected[i*4+r][i*4+s]);
    const b=actual.blocks.find(b=>b.record.at(-1)===String(a));eq(b.rho,conditional);eq(b.frame.readings[0].operator,[[c(a?-1:1)]]);}
  // This is not a retained-source Lüders instrument. The same readout
  // cannot transport full logical X/Y/Z, even on the original code.
  const strong=T.construct(m.base,d.strong,verified[0].instrument);assert.equal(strong.kind,'instrument-transport-obstruction');assert.equal(T.verify(m.base,d.strong,verified[0].instrument,strong).admitted,false);
  let negatives=0;const reject=f=>{assert.throws(f);negatives++;};
  const swapped=structuredClone(certificates[0]);swapped.decoder[0]^=1;reject(()=>A.verify(m,available,d.O,swapped));
  const weakened=structuredClone(available);weakened.terminalReadout='four unrelated raw samples';reject(()=>A.verify(m,weakened,d.O,certificates[0]));
  const freeSource=structuredClone(available);freeSource.returnedSource='full source preserved';reject(()=>A.verify(m,freeSource,d.O,certificates[0]));
  const wrongRoot=structuredClone(certificates[0]);wrongRoot.source={};reject(()=>A.verify(m,available,d.O,wrongRoot));reject(()=>A.verify({...m},available,d.O,certificates[0]));
  const physical=structuredClone(certificates[0]);physical.physicalAdmission=true;reject(()=>A.verify(m,available,d.O,physical));
  const wrongGate=structuredClone(certificates[0]);wrongGate.gates[1].target=1;reject(()=>A.verify(m,available,d.O,wrongGate));
  const needless=structuredClone(certificates[2]);needless.gates=A.gates();reject(()=>A.verify(m,available,m.I,needless));
  const beforeCheck={...A.counters};certificates.forEach(p=>A.verify(m,available,p.question,p));assert.deepEqual(A.counters,beforeCheck);
  const result={scope:'Native realization of explicit answer-only PT continuation, with same-shot decoder and retained reference',
    native_operations:4,terminal_physical_Z_readings:4,returned_answer_bits:1,constant_question_measurements:0,
    full_effects_verified:true,actual_record_not_expected_input:true,all_reference_basis_relations:16,
    one_owned_input_three_continuations:true,source_return_not_promised:true,strong_quantum_future_refused:true,
    construction_calls_during_application:0,negative_checks:negatives,physical_admission:null,milliseconds:Math.round(performance.now()-start)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-26-readout-certificates.json');fs.writeFileSync(file,R.serialize(certificates)+'\n',{flag:'wx'});
    fs.writeFileSync(path.join(directory,'wave-26-readout-realizations.json'),R.serialize({readoutStage,strong,before,actual,initial})+'\n',{flag:'wx'});
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_answer_readout.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{constructions:0});
    result.milliseconds=Math.round(performance.now()-start);fs.writeFileSync(path.join(directory,'wave-26-readout-checks.json'),R.serialize(result)+'\n',{flag:'wx'});}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
