"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),D=require('./coordinated_dynamic_instrument.js'),T=require('./coordinated_instrument_transport.js'),A=require('./coordinated_future_algebra.js');
const {c,z,one,ii,add,mul,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,rank}=A.exact;
const instrument=(n,outcomes)=>({kind:'declared-recorded-instrument',inputDimension:n,outcomes:outcomes.map(([label,kraus])=>({label,kraus}))});
const X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],I2=eye(2);
const evaluate=(rho,inst)=>inst.outcomes.map(out=>out.kraus.reduce((s,K)=>plus(s,mm(mm(K,rho),adj(K))),mat(out.kraus[0].length)));
function check(directory){const start=performance.now(),m=C.currentModel(),I=eye(4),cycle=D.compileCycle(m,['XX','ZI','XX','IZ']);
  const leaves=D.verifyCycle(m,cycle).leaves,fine=instrument(4,leaves.map(b=>[b.outcomes.join(''),[b.K]]));
  const middle=T.coarsen(fine,leaves.map(b=>b.outcomes[0]^b.outcomes[2])),last=T.coarsen(fine,Array(16).fill(0));
  const instruments=[fine,middle,last],algebras=instruments.map(inst=>A.derive(m,I,inst));
  assert.deepEqual(algebras.map(a=>a.dimension),[8,4,2]);assert.deepEqual(algebras.map(a=>a.centerDimension),[2,1,2]);
  const expected=[['II','IX','XI','XX','YY','YZ','ZY','ZZ'],['II','XI','YZ','ZZ'],['II','ZZ']];
  const queries=[];
  algebras.forEach((algebra,i)=>{const before={...A.counters},tBefore={...T.counters};
    for(const label of expected[i]){const O=D.pauli(label),w=A.query(m,I,instruments[i],algebra,O);assert.equal(w.kind,'inside-maximal-algebra');
      assert(A.verifyQuery(m,I,instruments[i],algebra,O,w));queries.push({index:i,operator:O,witness:w});}
    assert.equal(A.counters.algebraSolves,before.algebraSolves);assert.equal(A.counters.centerSolves,before.centerSolves);
    assert.deepEqual(T.counters,tBefore,'inside query must reuse transport instead of rebuilding it');
    assert.equal(rank(expected[i].map(p=>D.pauli(p).flat())),algebra.dimension);
  });
  const outside=[{index:0,operator:D.pauli('ZI')},{index:1,operator:D.pauli('XX')},{index:2,operator:D.pauli('XI')}];
  for(const q of outside){q.witness=A.query(m,I,instruments[q.index],algebras[q.index],q.operator);assert.equal(q.witness.kind,'outside-maximal-algebra');
    assert.equal(A.verifyQuery(m,I,instruments[q.index],algebras[q.index],q.operator,q.witness),false);queries.push(q);}
  // Explicit central projections and noncommuting logical generators identify
  // the algebra types; dimensions alone are not interpreted as qubit counts.
  const gx=D.pauli('XX'),lx=D.pauli('XI'),ly=D.pauli('YZ'),lz=D.pauli('ZZ');
  const central=bit=>scale(plus(I,scale(gx,c(bit?-1:1))),c(1,0,2));
  for(const bit of [0,1]){const P=central(bit);eq(mm(P,P),P);assert.equal(rank(P),2);
    for(const label of expected[0])eq(comm(P,D.pauli(label)),mat(4));
    eq(mm(plus(mm(lx,lz),mm(lz,lx)),P),mat(4));
    assert.equal(rank([P,mm(P,lx),mm(P,ly),mm(P,lz)].map(O=>O.flat())),4);
  }
  eq(mm(lx,lx),I);eq(mm(lz,lz),I);eq(plus(mm(lx,lz),mm(lz,lx)),mat(4));
  eq(comm(lx,lz),scale(ly,c(0,-2))); // X Z = -i Y
  // Losing the full first record really loses its central content, even if the
  // surviving logical algebra is enough for the original continuation task.
  const plusGauge=scale(plus(I,gx),c(1,0,4)),minusGauge=scale(minus(I,gx),c(1,0,4));
  const cp=evaluate(plusGauge,middle),cm=evaluate(minusGauge,middle);cp.forEach((b,i)=>eq(b,cm[i]));
  assert.deepEqual(tr(mm(plusGauge,gx)),one);assert.deepEqual(tr(mm(minusGauge,gx)),c(-1));
  const plusLogical=scale(plus(I,lx),c(1,0,4)),minusLogical=scale(minus(I,lx),c(1,0,4));
  eq(evaluate(plusLogical,last)[0],evaluate(minusLogical,last)[0]);
  // Late questions are reconstructed from the precomputed maximal frame,
  // after the same actual input has already passed through the process.
  const rho=mat(8);for(const i of [0,5])for(const j of [0,5])rho[i][j]=c(1,0,2);
  const checked=A.verify(m,I,middle,algebras[1]),boundary=new T.InstrumentBoundary(m,checked.frame,rho,2);
  const stage={kind:'instrument-stage',instrument:middle,cases:[algebras[1].transport],physicalAdmission:null};boundary.continue(middle,stage);
  const lateO=plus(scale(lx,c(3,0,5)),scale(lz,c(4,0,5))),late=A.query(m,I,middle,algebras[1],lateO);
  for(const B of [I2,X,Y,Z]){
    const answer=late.coefficients.reduce((s,v,i)=>add(s,mul(v,boundary.read(`O${i}`,B))),z);
    assert.deepEqual(answer,tr(mm(rho,kron(lateO,B))));}
  queries.push({index:1,operator:lateO,witness:late});

  // Same operator-space dimension, different algebraic structure.
  const projectors=Array.from({length:4},(_,i)=>{const P=mat(4);P[i][i]=one;return P;});
  const diagonal=instrument(4,projectors.map((P,i)=>[String(i),[P]])),classical=A.derive(m,I,diagonal);
  assert.equal(classical.dimension,4);assert.equal(classical.centerDimension,4);
  const qutrit=instrument(3,[['unchanged',[eye(3)]]]),qutritAlgebra=A.derive(m,eye(3),qutrit);
  assert.equal(qutritAlgebra.dimension,9);assert.equal(qutritAlgebra.centerDimension,1);
  const erased=instrument(2,[['unread',[I2,X,Y,Z].map(P=>scale(P,c(1,0,2)))]]),nothing=A.derive(m,I2,erased);
  assert.equal(nothing.dimension,1);assert.equal(nothing.centerDimension,1);
  // The maximal algebra on the current source sector is derived from the full
  // gauge instrument; P and Q are checked afterwards rather than supplied.
  const gauge=instrument(8,[['unread',[m.I,...[X,Y,Z].map(P=>kron(kron(P,P),P))].map(P=>scale(P,c(1,0,2)))]]);
  const sourceAlgebra=A.derive(m,m.Pi,gauge);assert.equal(sourceAlgebra.dimension,4);assert.equal(sourceAlgebra.centerDimension,1);
  for(const O of [mm(m.Pi,m.P),mm(m.Pi,m.Q)])assert.equal(A.query(m,m.Pi,gauge,sourceAlgebra,O).kind,'inside-maximal-algebra');

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  const fewer=structuredClone(algebras[1]);fewer.dimension=1;fewer.linear.vectors=[I.flat()];
  fewer.linear.basisMinor={rows:[0],columns:[0],inverse:[[one]]};
  fewer.centerDimension=1;fewer.center={vectors:[[one]],constraintMinor:{rows:[],columns:[],inverse:[]},basisMinor:{rows:[0],columns:[0],inverse:[[one]]}};
  const identityFrame={kind:'declared-generated-star-algebra',support:I,readings:[{name:'O0',operator:I}]};
  fewer.transport=T.construct(m,identityFrame,middle);assert(T.verify(m,identityFrame,middle,fewer.transport).admitted);
  rejects(()=>A.verify(m,I,middle,fewer)); // sound subset is not a complete answer
  const badMinor=structuredClone(algebras[1]);badMinor.linear.constraintMinor.inverse[0][0]=c(999);rejects(()=>A.verify(m,I,middle,badMinor));
  const duplicate=structuredClone(algebras[1]);duplicate.linear.vectors[1]=duplicate.linear.vectors[0];rejects(()=>A.verify(m,I,middle,duplicate));
  const fakeCenter=structuredClone(algebras[1]);fakeCenter.centerDimension=2;rejects(()=>A.verify(m,I,middle,fakeCenter));
  rejects(()=>A.verify(m,I,last,algebras[1]));
  const fakeQuery=structuredClone(late);fakeQuery.coefficients[0]=add(fakeQuery.coefficients[0],one);rejects(()=>A.verifyQuery(m,I,middle,algebras[1],lateO,fakeQuery));
  const fakeOutput=structuredClone(late);fakeOutput.outputReadings[0].operator=mat(4);rejects(()=>A.verifyQuery(m,I,middle,algebras[1],lateO,fakeOutput));
  rejects(()=>A.verify({...m},I,middle,algebras[1]));
  const before={...A.counters},tBefore={...T.counters};
  algebras.forEach((p,i)=>A.verify(m,I,instruments[i],p));queries.forEach(q=>A.verifyQuery(m,I,instruments[q.index],algebras[q.index],q.operator,q.witness));
  assert.deepEqual(A.counters,before);assert.deepEqual(T.counters,tBefore);
  const out={scope:'Maximal correctable generated algebras for complete declared instruments and accessible records',
    cycle_dimensions:algebras.map(a=>a.dimension),cycle_center_dimensions:algebras.map(a=>a.centerDimension),
    cycle_algebra_types:['M2 direct-sum M2','M2 with multiplicity two','C direct-sum C'],
    central_information_lost_by_parity_only:true,quantum_relation_lost_by_no_record:true,
    same_dimension_four_examples:{parity_cycle:'one quantum matrix algebra M2',basis_measurement:'four classical sectors C^4'},
    qutrit_dimension:9,complete_erasure_dimension:1,source_sector_algebra_dimension:4,
    late_question_uses_saved_transport:true,late_question_with_reference:true,
    maximality_uses_kernel_and_independent_minor_bounds:true,
    negative_checks:negatives,verification_repeats_no_algebra_or_transport_construction:true,
    physical_admission:null,milliseconds:Math.round(performance.now()-start)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-7-algebra-certificates.json');
    const bundle=algebras.map((certificate,i)=>({support:I,instrument:instruments[i],certificate,queries:queries.filter(q=>q.index===i).map(({operator,witness})=>({operator,witness}))}));
    bundle.push({support:I,instrument:diagonal,certificate:classical},{support:eye(3),instrument:qutrit,certificate:qutritAlgebra},
      {support:I2,instrument:erased,certificate:nothing},{support:m.Pi,instrument:gauge,certificate:sourceAlgebra});
    fs.writeFileSync(file,R.serialize(bundle)+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_future_algebra.js'),file],{encoding:'utf8',timeout:15000});
    assert.equal(cp.status,0,cp.stderr);out.persistedVerifier=JSON.parse(cp.stdout);
    assert.deepEqual(out.persistedVerifier.constructionCalls,{algebraSolves:0,centerSolves:0,querySubstitutions:0});
    assert.deepEqual(out.persistedVerifier.instrumentConstructionCalls,{constructions:0,pseudoinverses:0,recordPartitions:0});
    out.milliseconds=Math.round(performance.now()-start);fs.writeFileSync(path.join(directory,'wave-7-algebra-checks.json'),JSON.stringify(out,null,2)+'\n');}
  return out;
}
if(require.main===module)console.log(JSON.stringify(check(process.argv[2]),null,2));
module.exports={check};
