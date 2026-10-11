"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),A=require('./coordinated_acquired_question.js');
const B=require('./coordinated_probe_continuation.js'),G=require('./coordinated_cut_background.js'),P=require('./coordinated_pulse_relation.js');
const F=require('./coordinated_cq_context.js'),K=require('./coordinated_context_family.js');
const {c,z,one,add,mul,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=K.exact;
const I2=eye(2),X=[[z,one],[one,z]],P0=[[one,z],[z,z]];
const read=name=>R.deserialize(fs.readFileSync(path.resolve(__dirname,`../../Research/Artifacts/coordinated-continuation-20260917/${name}`),'utf8'));
function check(directory){const started=performance.now(),m=C.currentModel(),previous=read('wave-15-cq-certificates.json'),direct=previous[0];
  const lowerContext={...direct.context,mode:'lowered'},lowered={plan:direct.plan,context:lowerContext,certificate:F.construct(m,direct.plan,lowerContext)};
  const templates=[direct,lowered,previous[1]],bundle=templates.map(template=>({template,certificate:K.derive(m,template),queries:[]}));
  const checked=bundle.map(b=>K.verify(m,b.template,b.certificate));assert.deepEqual(checked.map(x=>x.dimension),[18,5,18]);

  // Independent transparent bases: symmetric spin sector from the source,
  // and the common fixed vectors of the actual reversible lowering gates.
  const U=mat(8,4);U[0][0]=one;for(const i of [1,2,4])U[i][1]=one;for(const i of [3,5,6])U[i][2]=one;U[7][3]=one;
  const D=adj(U).map((row,i)=>row.map(x=>mul(x,c(1,0,[1,3,3,1][i]))));eq(mm(D,U),eye(4));eq(mm(U,D),m.E);
  const symmetricBasis=F.fullOutputBasis(m.E,{columns:U,dual:D}),qp=scale(plus(m.Pi,mm(m.Pi,m.Q)),c(1,0,2)),qm=minus(m.Pi,qp);
  eq(mm(qp,qp),qp);eq(mm(qm,qm),qm);assert.deepEqual(tr(qp),c(2));assert.deepEqual(tr(qm),c(2));
  const expectedDirect=[m.Pi,mm(m.Pi,m.Q),...symmetricBasis];assert.equal(expectedDirect.length,18);
  for(const index of [0,2])for(const S of checked[index].basis){
    const a=mul(tr(mm(qp,S)),c(1,0,2)),b=mul(tr(mm(qm,S)),c(1,0,2));
    eq(S,plus(plus(scale(qp,a),scale(qm,b)),mm(mm(m.E,S),m.E)));}

  const V=mat(8,2);V[0][0]=one;for(let i=1;i<8;i++)V[i][1]=one;
  const Edual=adj(V).map((row,i)=>row.map(x=>mul(x,c(1,0,i?7:1)))),R0=mm(V,Edual),active=minus(m.I,R0);
  eq(mm(Edual,V),I2);eq(mm(R0,R0),R0);eq(mm(m.E,R0),R0);assert.deepEqual(tr(R0),c(2));
  const fixedBasis=F.fullOutputBasis(R0,{columns:V,dual:Edual}),expectedLower=[active,...fixedBasis];
  for(const S of checked[1].basis)eq(S,plus(scale(active,mul(tr(mm(active,S)),c(1,0,6))),mm(mm(R0,S),R0)));
  // Every proposed basis satisfies the independently rebuilt full set of
  // constraints. Together with completeness above, the displayed forms are
  // exact classifications rather than fits to a few accepted generators.
  for(const [index,candidates]of [[0,expectedDirect],[1,expectedLower],[2,expectedDirect]]){
    const data=K.constraintData(m,bundle[index].template);
    for(const S of candidates)eq(mm(data.rows,S.flat().map(x=>[x])),mat(data.rows.length,1));}
  // The two-dimensional residual sector is fixed by every source-flip
  // primitive of the lowering, not merely unused at the start.
  const lowerData=G.programData(m,lowered.certificate.program,lowerContext.available);
  for(const step of lowerData.steps.slice(1,-1))eq(mm(step.matrix,kron(I2,R0)),kron(I2,R0));

  const Sx=[0,1,2].map(i=>[0,1,2].map(j=>i===j?X:I2).reduce(kron)).reduce(plus);
  const unused=mat(8);unused[0][7]=one;unused[7][0]=one;eq(mm(mm(m.E,unused),m.E),unused);
  const fixedCross=plus(mm(V.map(row=>[row[0]]),adj(V.map(row=>[row[1]]))),mm(V.map(row=>[row[1]]),adj(V.map(row=>[row[0]]))));
  function query(index,generator,expected){const b=bundle[index],proof=K.membership(m,b.template,b.certificate,generator);
    assert.equal(K.verifyMembership(m,b.template,b.certificate,generator,proof),expected);b.queries.push({generator,proof});return proof;}
  query(0,m.Q,true);query(0,Sx,false);query(0,unused,true);
  query(1,m.Q,false);query(1,unused,false);query(1,fixedCross,true);

  // A nontrivial field wholly outside the initial Pi can become destructive
  // when the lowered path visits that sector. The direct path does not.
  const two=mm(unused,unused),W=plus(minus(m.I,two),plus(scale(two,c(3,0,5)),scale(unused,c(0,-4,5))));
  eq(mm(adj(W),W),m.I);eq(mm(W,m.Pi),m.Pi);
  const vector=m.Pi.map(row=>[row[5]]),probeInput=scale(mm(vector,adj(vector)),c(3,0,2));assert.deepEqual(tr(probeInput),one);
  const plan=direct.plan,ap=A.instantiate(m,plan.acquisitionAccess),aProgram=plan.acquisition.program;
  const control=name=>name===null?m.I:ap.controls.find(p=>p.name===name).operator,pre=control(aProgram.pre),post=control(aProgram.post);
  const sourceInput=mm(mm(adj(pre),probeInput),pre),original=B.verify(m,plan.request,plan.acquisitionAccess,plan.probeAccess,plan.next,plan);
  const realized=[];
  for(const [template,cut]of [[direct,1],[lowered,2]]){
    const program=template.certificate.program,data=G.programData(m,program,template.context.available);
    const episodes=Array.from({length:data.steps.length+1},()=>eye(16));episodes[cut]=kron(I2,W);
    const Uactual=G.jointOperator(m,program,template.context.available,1,episodes),out=[];
    for(const branch of original.branches){const block=Uactual.slice(branch.raw*8,(branch.raw+1)*8).map(row=>row.slice(0,8));
      const tail=mm(original.nextChecked[branch.answer].operator,post),Kactual=mm(tail,mm(block,pre)),rho=mm(mm(Kactual,sourceInput),adj(Kactual));
      out.push({raw:branch.raw,answer:branch.answer,rho});}
    assert.deepEqual(out.reduce((s,b)=>add(s,tr(b.rho)),z),one);
    realized.push({mode:program.mode,leak:out.reduce((s,b)=>add(s,tr(mm(b.rho,m.E))),z),branches:out});}
  assert.deepEqual(realized[0].leak,z);assert.deepEqual(realized[1].leak,c(104,0,225));
  // An admitted derived combination feeds the existing context guard; no
  // search over background candidates or environment trajectories occurs.
  const derivedGenerator=plus(mm(m.Pi,m.Q),unused),membership=K.membership(m,direct,bundle[0].certificate,derivedGenerator);
  assert(K.verifyMembership(m,direct,bundle[0].certificate,derivedGenerator,membership));
  const derivedContext={...direct.context,generators:[kron(I2,derivedGenerator)]},derivedAdmission=F.construct(m,plan,derivedContext);
  assert(F.verify(m,plan,derivedContext,derivedAdmission).admitted);

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  const missing=structuredClone(bundle[0].certificate);missing.vectors.pop();missing.dimension--;rejects(()=>K.verify(m,direct,missing));
  const tooLarge=structuredClone(bundle[1].certificate);tooLarge.vectors.push(m.Q.flat());tooLarge.dimension++;rejects(()=>K.verify(m,lowered,tooLarge));
  const rankLie=structuredClone(bundle[0].certificate);rankLie.constraintMinor.inverse[0][0]=c(123);rejects(()=>K.verify(m,direct,rankLie));
  const duplicate=structuredClone(bundle[0].certificate);duplicate.basisMinor.rows[0]=duplicate.basisMinor.rows[1];rejects(()=>K.verify(m,direct,duplicate));
  const imaginary=structuredClone(bundle[0].queries[0].proof);imaginary.coefficients[0]=c(0,1);rejects(()=>K.verifyMembership(m,direct,bundle[0].certificate,m.Q,imaginary));
  const fakePositive=structuredClone(bundle[0].queries[0].proof);rejects(()=>K.verifyMembership(m,lowered,bundle[1].certificate,m.Q,fakePositive));
  const fakeWitness=structuredClone(bundle[1].queries[0].proof);fakeWitness.obstruction.commutator=mat(16);rejects(()=>K.verifyMembership(m,lowered,bundle[1].certificate,m.Q,fakeWitness));
  rejects(()=>K.verify(m,lowered,bundle[0].certificate));
  const fakeHardware=structuredClone(bundle[0].certificate);fakeHardware.physicalAdmission={backend:'unverified'};rejects(()=>K.verify(m,direct,fakeHardware));
  rejects(()=>K.verify({...m},direct,bundle[0].certificate));
  const before={...K.counters};bundle.forEach(b=>{K.verify(m,b.template,b.certificate);b.queries.forEach(q=>K.verifyMembership(m,b.template,b.certificate,q.generator,q.proof));});
  assert.deepEqual(K.counters,before);
  const result={scope:'Maximal constant source-only generator space for the complete supported cq whole-arc condition of the existing continuations',
    dimensions:{direct_first:18,direct_second:18,lowered_first:5},identity_direction_included:true,
    direct_form:'a Pi_plus + b Pi_minus + E T E, E=I-Pi',lowered_form:'a (I-R0) + R0 T R0, R0 projects onto span(e000, sum of the other seven basis states)',
    classification_checked_on_complete_bases:true,omitted_sector_does_not_mean_irrelevant_during_lowering:true,
    unused_sector_field:{direct_leak:'0',lowered_leak:'104/225'},source_input_and_actual_conditional_tail_included:true,
    derived_combination_admitted_by_existing_context_gate:true,complete_kernel_witness_checked_without_elimination:true,
    positive_and_negative_membership_witnesses:true,negative_checks:negatives,physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-16-family-certificates.json');fs.writeFileSync(file,R.serialize(bundle)+'\n');
    fs.writeFileSync(path.join(directory,'wave-16-family-realizations.json'),R.serialize({R0,qp,qm,unused,W,probeInput,sourceInput,realized,derivedGenerator,membership,derivedContext,derivedAdmission})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_context_family.js'),file],{encoding:'utf8',timeout:30000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructionCalls,{kernelConstructions:0,membershipConstructions:0});
    assert.deepEqual(result.persistedVerifier.cqConstructionCalls,{rangeConstructions:0,constructions:0});assert.deepEqual(result.persistedVerifier.pulseConstructionCalls,{declarations:0,constructions:0});
    result.milliseconds=Math.round(performance.now()-started);fs.writeFileSync(path.join(directory,'wave-16-family-checks.json'),R.serialize(result)+'\n');}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
