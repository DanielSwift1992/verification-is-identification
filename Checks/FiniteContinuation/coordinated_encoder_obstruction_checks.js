"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_protected_acquisition.js'),A=require('./coordinated_encoder_obstruction.js');
const {c,z,one,ii,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=A.exact,key=C.json;
const I=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]],axes=[X,Y,Z];
function check(directory){const started=performance.now(),model=M.currentModel(),joining=A.inputJoining(model),access=A.catalogue(model),d=F.sourceData(model);
  const request={kind:'native-spin-to-invariant-continuation',readings:axes.map((operator,i)=>({name:['X','Y','Z'][i],operator}))};
  const requests=[...request.readings.map(q=>({...request,readings:[q]})),{...request,readings:[{name:'constant',operator:scale(I,c(7))}]}];
  const claims=requests.map(request=>({request,certificate:A.construct(model,request,joining,access)}));
  const before={...A.counters},results=claims.map(x=>A.verify(model,x.request,joining,access,x.certificate));
  assert.deepEqual(A.counters,before);assert.deepEqual(results.map(r=>r.admitted),[false,false,false,null]);
  const native=axes.map(O=>kron(kron(eye(4),O),I));
  const identity={inputDimension:16,outputDimension:16,outcomes:[{label:'same-source',kraus:[model.I]}]};
  // The unknown input has not ceased to exist: the original physical exit
  // reads it. This is not a protected exit and is not called an encoding.
  A.verifyCandidate(model,request,joining,identity,[native]);
  native.forEach(O=>assert(joining.symmetries.some(G=>!isZero(comm(O,G)))));

  // A real adaptive composition from the declared invariant catalogue.
  // Compare every visible branch, not only an average over actual records.
  function run(rho){let blocks=[{history:'',rho:A.apply(joining.instrument.outcomes[0].kraus,rho)}];
    for(let round=0;round<3;round++){const next=[];for(const block of blocks)for(const o of access.controls.at(-1).instrument.outcomes){
      let state=A.apply(o.kraus,block.rho);const names=o.label==='0'?['P','T','Q']:['Q','P'];
      for(const name of names){const control=access.controls.find(x=>x.name===name);state=A.apply(control.instrument.outcomes[0].kraus,state);}
      if(!isZero(state))next.push({history:block.history+o.label,rho:state});}blocks=next;}return blocks;}
  const fullPlus=run(scale(plus(I,Z),c(1,0,2))),fullMinus=run(scale(minus(I,Z),c(1,0,2)));
  assert.deepEqual(fullPlus.map(b=>b.history),fullMinus.map(b=>b.history));
  const invariantReadings=[model.I,...Object.values(model.operators),d.singlet,d.spin1,d.spin2];
  fullPlus.forEach((b,i)=>{invariantReadings.forEach(O=>assert.deepEqual(tr(mm(b.rho,O)),tr(mm(fullMinus[i].rho,O))));});
  const summed=blocks=>blocks.map(b=>b.rho).reduce(plus);
  assert.deepEqual(tr(mm(summed(fullPlus),d.J[2])),one);assert.deepEqual(tr(mm(summed(fullMinus),d.J[2])),c(-1));

  // Covariance does not require each hidden Kraus operator to commute.
  const site=O=>kron(O,eye(8)),depolarizing={inputDimension:16,outputDimension:16,outcomes:[{label:'unread',kraus:[I,X,Y,Z].map(O=>scale(site(O),c(1,0,2)))}]};
  const diagonal=signs=>signs.map((s,i)=>signs.map((_,j)=>i===j?c(s):z));
  const noiseCovariance={kind:'visible-branch-covariance',mixing:[[diagonal([1,1,-1,-1])],[diagonal([1,-1,-1,1])]]};
  A.verifyCovariance(depolarizing,joining.symmetries,joining.symmetries,noiseCovariance);
  assert(!isZero(comm(site(X),joining.symmetries[1])));

  // Visible record ownership matters. A Z measurement swaps labels under X.
  // Hiding that record gives a covariant channel, but not the same instrument.
  const zRead={inputDimension:2,outputDimension:2,outcomes:[1,-1].map((s,i)=>({label:String(i),kraus:[scale(plus(I,scale(Z,c(s))),c(1,0,2))]}))};
  const hiddenZ={inputDimension:2,outputDimension:2,outcomes:[{label:'unread',kraus:zRead.outcomes.flatMap(o=>o.kraus)}]};
  A.verifyCovariance(hiddenZ,[X,Z],[X,Z],{kind:'visible-branch-covariance',mixing:[[X],[I]]});
  const z0=zRead.outcomes[0].kraus[0],z1=zRead.outcomes[1].kraus[0];eq(mm(z0,X),mm(X,z1));assert(!isZero(minus(mm(z0,X),mm(X,z0))));

  // Additional known alignment is a real changed input resource. It permits
  // a nonconstant invariant comparison, not yet an arbitrary quantum encoder.
  const directionKraus=joining.instrument.outcomes[0].kraus.map(()=>{const K=mat(16,2);for(let q=0;q<2;q++){K[4+2*q][q]=c(1,0,2);K[8+2*q][q]=c(-1,0,2);}return K;});
  eq(directionKraus.map(K=>mm(adj(K),K)).reduce(plus),I);
  const relativeQuestion=A.pull(directionKraus,model.operators.T);eq(relativeQuestion,scale(plus(I,Z),c(1,0,2)));
  eq(A.pull(joining.instrument.outcomes[0].kraus,model.operators.T),scale(I,c(1,0,2)));
  const rho0=scale(plus(I,Z),c(1,0,2)),rho1=scale(minus(I,Z),c(1,0,2));
  assert(!isZero(minus(A.apply(directionKraus,rho1),mm(mm(joining.symmetries[0],A.apply(directionKraus,rho0)),joining.symmetries[0]))));

  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  const badDiff=structuredClone(claims[2].certificate);badDiff.difference=mat(2);rejects(()=>A.verify(model,requests[2],joining,access,badDiff));
  const badPartner=structuredClone(claims[2].certificate);badPartner.partner=badPartner.rho;rejects(()=>A.verify(model,requests[2],joining,access,badPartner));
  const fakeNone=structuredClone(claims[2].certificate);fakeNone.kind='no-symmetry-obstruction';rejects(()=>A.verify(model,requests[2],joining,access,fakeNone));
  const falseSource=structuredClone(claims[2].certificate);falseSource.source={};rejects(()=>A.verify(model,requests[2],joining,access,falseSource));
  rejects(()=>A.verify({...model},requests[2],joining,access,claims[2].certificate));
  const changedJoining=structuredClone(joining);changedJoining.instrument.outcomes[0].kraus=directionKraus;rejects(()=>A.verify(model,requests[2],changedJoining,access,claims[2].certificate));
  const added=structuredClone(access);added.controls.push({name:'orientation-bearing-local-Z-read',instrument:zRead});rejects(()=>A.verify(model,requests[2],joining,added,claims[2].certificate));
  const nonunitary=structuredClone(noiseCovariance);nonunitary.mixing[0][0][0][0]=c(2);rejects(()=>A.verifyCovariance(depolarizing,joining.symmetries,joining.symmetries,nonunitary));
  rejects(()=>A.verifyCovariance(zRead,[X,Z],[X,Z],A.trivialCovariance(zRead,2)));
  rejects(()=>A.verifyCovariance(zRead,[X,Z],[X,Z],{kind:'visible-branch-covariance',mixing:[[X],[I]]}));
  rejects(()=>A.verifyCandidate(model,request,joining,identity,[[model.operators.P,model.operators.Q,d.readings[2].operator]]));
  const incomplete=structuredClone(identity);incomplete.outcomes[0].kraus=[scale(model.I,c(1,0,2))];rejects(()=>A.verifyCandidate(model,request,joining,incomplete,[native]));
  const badMix=structuredClone(joining.covariance);badMix.mixing[0][0]=I;rejects(()=>A.verifyCovariance(joining.instrument,[X,Z],joining.symmetries,badMix));
  const result={scope:'Exact symmetry obstruction to moving the original native spin into an invariant exit using covariant visible branches and the specified invariant joining',
    X_Y_Z_excluded:true,constant_is_not_an_encoder:true,arbitrary_finite_adaptive_closure:'proved by composition of visible-branch covariance',
    direct_original_readings_still_exist:true,three_round_model_branches:fullPlus.length,all_protected_history_readings_identical:true,
    original_Jz_distinction:[1,-1],hidden_kraus_mixing_checked:true,visible_record_not_coarsened:true,
    invariant_fourth_swap_pullback:'I/2',aligned_fourth_swap_pullback:'(I+Z)/2',aligned_ancilla_not_a_full_encoder:true,
    negative_checks:negatives,physical_admission:null,milliseconds:Math.round(performance.now()-started)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-18-encoder-certificates.json');
    fs.writeFileSync(file,R.serialize({joining,access,claims})+'\n');
    fs.writeFileSync(path.join(directory,'wave-18-encoder-realizations.json'),R.serialize({fullPlus,fullMinus,directionKraus,relativeQuestion,depolarizing,noiseCovariance,native})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_encoder_obstruction.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    result.persistedVerifier=R.deserialize(cp.stdout);assert.deepEqual(result.persistedVerifier.constructions,{constructions:0});result.milliseconds=Math.round(performance.now()-started);
    fs.writeFileSync(path.join(directory,'wave-18-encoder-checks.json'),R.serialize(result)+'\n');}
  return result;
}
if(require.main===module)console.log(R.serialize(check(process.argv[2])));
module.exports={check};
