"use strict";
// A relation obstruction before program search. The symmetry of each visible
// instrument branch, of the input joining, and of the requested exit is explicit.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const M=require('./coordinated_moving_boundary.js'),F=require('./coordinated_protected_acquisition.js');
const E=C.exact,{c,z,one,ii,nz,add,sub,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=E;
const key=C.json,counters={constructions:0};
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]];
function touch(m){M.proveMovingProtection(m,[]);}
function matrix(A,n,k=n){assert(A.length===n&&A.every(row=>row.length===k));for(const row of A)for(const v of row)assert.deepEqual(v,c(...v));}
function unitary(U){matrix(U,U.length);eq(mm(adj(U),U),eye(U.length));}
function apply(kraus,rho){return kraus.map(K=>mm(mm(K,rho),adj(K))).reduce(plus);}
function pull(kraus,O){return kraus.map(K=>mm(mm(adj(K),O),K)).reduce(plus);}
// For each visible a, K_mu G_in = sum_nu V_mu,nu G_out K_nu.
// A unitary V mixes hidden Kraus alternatives, never visible record labels.
function verifyCovariance(instrument,inputSymmetries,outputSymmetries,certificate){
  const n=instrument.inputDimension,d=instrument.outputDimension;assert(Number.isSafeInteger(n)&&n>0&&Number.isSafeInteger(d)&&d>0);
  assert(instrument.outcomes.length>0);assert.equal(new Set(instrument.outcomes.map(o=>o.label)).size,instrument.outcomes.length);
  assert.equal(inputSymmetries.length,outputSymmetries.length);assert(inputSymmetries.length>0);
  assert.equal(certificate.kind,'visible-branch-covariance');assert.equal(certificate.mixing.length,inputSymmetries.length);
  let complete=mat(n);for(const o of instrument.outcomes){assert(typeof o.label==='string'&&o.kraus.length>0);
    for(const K of o.kraus){matrix(K,d,n);complete=plus(complete,mm(adj(K),K));}}
  eq(complete,eye(n),'full instrument is not trace preserving');
  inputSymmetries.forEach((G,s)=>{matrix(G,n);unitary(G);const H=outputSymmetries[s];matrix(H,d);unitary(H);
    assert.equal(certificate.mixing[s].length,instrument.outcomes.length);
    instrument.outcomes.forEach((o,a)=>{const V=certificate.mixing[s][a];matrix(V,o.kraus.length);unitary(V);
      o.kraus.forEach((K,mu)=>eq(mm(K,G),o.kraus.map((L,nu)=>scale(mm(H,L),V[mu][nu])).reduce(plus),'visible outcome lacks covariance'));});});
  return true;
}
function trivialCovariance(instrument,count){return {kind:'visible-branch-covariance',mixing:Array.from({length:count},()=>instrument.outcomes.map(o=>eye(o.kraus.length)))};}
function inputJoining(model){touch(model);const ks=[mat(16,2),mat(16,2)];
  // (|01>-|10>)_12 tensor rho_3 tensor I_4/2. The factors of sqrt(2)
  // combine to rational Kraus amplitudes 1/2; no classical value of rho is read.
  for(let e=0;e<2;e++)for(let q=0;q<2;q++){ks[e][4+2*q+e][q]=c(1,0,2);ks[e][8+2*q+e][q]=c(-1,0,2);}
  const instrument={inputDimension:2,outputDimension:16,outcomes:[{label:'joined',kraus:ks}]};
  const covariance={kind:'visible-branch-covariance',mixing:[[scale(X,c(-1))],[scale(Z,c(-1))]]};
  const symmetries=[X,Z].map(A=>[A,A,A,A].reduce(kron));
  verifyCovariance(instrument,[X,Z],symmetries,covariance);ks.forEach(K=>eq(mm(model.initial,K),K));
  return {instrument,covariance,symmetries,inputSymmetries:[X,Z],physicalAdmission:null};
}
function catalogue(model){touch(model);const d=F.sourceData(model),j=inputJoining(model);
  const controls=Object.entries(model.operators).map(([name,U])=>({name,instrument:{inputDimension:16,outputDimension:16,outcomes:[{label:'done',kraus:[scale(U,c(0,-1))]}]}}));
  controls.push({name:'protected-sector-question',instrument:{inputDimension:16,outputDimension:16,outcomes:
    [d.singlet,minus(model.I,d.singlet)].map((A,a)=>({label:String(a),kraus:[A]}))}});
  for(const entry of controls){entry.covariance=trivialCovariance(entry.instrument,2);verifyCovariance(entry.instrument,j.symmetries,j.symmetries,entry.covariance);}
  return {kind:'declared-invariant-encoder-access',controls,closure:'arbitrary finite composition, feedback on the same visible labels, coarse-graining and covariant ancilla join/discard',
    readout:'operators commuting with both declared collective symmetries, separately on every actual history',physicalAdmission:null};
}
function validate(model,joining,access){touch(model);assert.equal(key(joining),key(inputJoining(model)),'the old unknown input joining was changed');
  assert.equal(key(access),key(catalogue(model)),'an additional interface changes the scope of this obstruction');}
function densityWitnesses(){return [X,Y,Z].flatMap(A=>[1,-1].map(s=>scale(plus(I2,scale(A,c(s))),c(1,0,2))));}
function requestCheck(request){assert.equal(request.kind,'native-spin-to-invariant-continuation');assert(request.readings.length>0);
  assert.equal(new Set(request.readings.map(q=>q.name)).size,request.readings.length);
  request.readings.forEach(q=>{assert(typeof q.name==='string');matrix(q.operator,2);eq(adj(q.operator),q.operator);});}
function construct(model,request,joining=inputJoining(model),access=catalogue(model)){validate(model,joining,access);requestCheck(request);counters.constructions++;
  for(let q=0;q<request.readings.length;q++)for(let s=0;s<2;s++){
    const O=request.readings[q].operator,G=joining.inputSymmetries[s],difference=minus(O,mm(mm(adj(G),O),G));
    if(!isZero(difference)){const rho=densityWitnesses().find(r=>nz(tr(mm(r,difference))));assert(rho);
      const certificate={kind:'invariant-exit-encoding-obstruction',source:model.source,request:structuredClone(request),
        joining:structuredClone(joining),access:structuredClone(access),reading:q,symmetry:s,rho,
        partner:mm(mm(G,rho),adj(G)),difference,physicalAdmission:null};verify(model,request,joining,access,certificate);return certificate;}}
  return {kind:'no-symmetry-obstruction',source:model.source,request:structuredClone(request),joining:structuredClone(joining),access:structuredClone(access),physicalAdmission:null};
}
function verify(model,request,joining,access,p){validate(model,joining,access);requestCheck(request);
  assert.equal(key(p.source),key(model.source));assert.equal(key(p.request),key(request));assert.equal(key(p.joining),key(joining));assert.equal(key(p.access),key(access));assert.equal(p.physicalAdmission,null);
  if(p.kind==='no-symmetry-obstruction'){request.readings.forEach(q=>joining.inputSymmetries.forEach(G=>assert(isZero(comm(q.operator,G)))));
    return {admitted:null,reason:'absence of this obstruction is not an encoder',physicalAdmission:null};}
  assert.equal(p.kind,'invariant-exit-encoding-obstruction');assert(Number.isSafeInteger(p.reading)&&p.reading>=0&&p.reading<request.readings.length);
  assert([0,1].includes(p.symmetry));assert(densityWitnesses().some(r=>key(r)===key(p.rho)));
  const O=request.readings[p.reading].operator,G=joining.inputSymmetries[p.symmetry];eq(p.partner,mm(mm(G,p.rho),adj(G)));
  eq(p.difference,minus(O,mm(mm(adj(G),O),G)));const requiredDifference=tr(mm(p.rho,p.difference));assert(nz(requiredDifference));
  const source=inputJoining(model),a=apply(source.instrument.outcomes[0].kraus,p.rho),b=apply(source.instrument.outcomes[0].kraus,p.partner);
  eq(b,mm(mm(joining.symmetries[p.symmetry],a),adj(joining.symmetries[p.symmetry])));
  // If the effective input observable commutes with X and Z, its Pauli
  // coefficients vanish except I. This is a symbolic 2x2 identity, not search.
  for(const A of [X,Y,Z])assert(!joining.inputSymmetries.every(G=>isZero(comm(A,G))));
  return {admitted:false,requiredDifference,sourceInputs:[a,b],scope:'all finite adaptive programs whose visible branches preserve the declared covariance and whose exit is invariant',physicalAdmission:null};
}
// A separate candidate can discharge the actual input-to-exit obligation.
// This checks the joined unknown input, not a freshly prepared target state.
function verifyCandidate(model,request,joining,encoder,exitReadings){touch(model);requestCheck(request);assert.equal(key(joining),key(inputJoining(model)));
  assert.equal(encoder.inputDimension,16);assert(encoder.outcomes.length>0&&encoder.outputDimension>0);assert.equal(exitReadings.length,encoder.outcomes.length);
  let complete=mat(16);for(const o of encoder.outcomes)for(const K of o.kraus){matrix(K,encoder.outputDimension,16);complete=plus(complete,mm(adj(K),K));}
  eq(complete,model.I);const pullbacks=request.readings.map((q,j)=>{let O=mat(16);
    encoder.outcomes.forEach((o,a)=>{assert.equal(exitReadings[a].length,request.readings.length);const A=exitReadings[a][j];matrix(A,encoder.outputDimension);eq(adj(A),A);O=plus(O,pull(o.kraus,A));});
    const before=pull(joining.instrument.outcomes[0].kraus,O);eq(before,q.operator,'candidate does not carry the old unknown input');return before;});
  return {scope:'exact declared question channel including arbitrary external reference; physical access separate',pullbacks,physicalAdmission:null};
}
if(require.main===module){const b=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=M.currentModel();
  const results=b.claims.map(x=>verify(m,x.request,b.joining,b.access,x.certificate));
  console.log(R.serialize({results:results.map(r=>({admitted:r.admitted,requiredDifference:r.requiredDifference??null})),constructions:counters,physicalAdmission:null}));}
module.exports={inputJoining,catalogue,construct,verify,verifyCovariance,trivialCovariance,verifyCandidate,apply,pull,counters,exact:E};
