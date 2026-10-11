"use strict";
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),P=require('./coordinated_port_continuation.js');
const {c,z,one,ii,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=P.exact;
const I2=eye(2),X=[[z,one],[one,z]],Y=[[z,c(0,-1)],[ii,z]],Z=[[one,z],[z,c(-1)]];
const conjugate=(F,O)=>mm(mm(F,O),adj(F));
const e=R.reading,goal=relations=>({kind:'source-reading-relations',input:'derived-noncommuting-sector',relations});
function check(directory){const start=performance.now(),m=C.currentModel();
  const swap=goal([{after:e(['P']),before:e(['Q'])},{after:e(['Q']),before:e(['P'])}]);
  const second=goal([{after:e(['Q']),before:e(['Q'])},{after:e(['P']),before:e(['Q','P','Q'])}]);
  const serial=C.accessModel([[1,0],[0,1]]),joint=C.accessModel([[1,0],[0,1],[1,1]]);
  const p1=P.construct(m,swap,joint),p2=P.construct(m,second,joint),slow=P.construct(m,swap,serial);
  assert.equal(P.verify(m,swap,joint,p1).score.length,1);assert.equal(P.verify(m,swap,serial,slow).score.length,3);
  // All basis products agree with the live source representation. The proof
  // certificate itself reduces the universal defining relations, not frames.
  const sourcePorts={support:m.Pi,P:m.P,Q:m.Q,controls:[]};
  const units=Array.from({length:4},(_,i)=>Array.from({length:4},(_,j)=>i===j?one:z));
  for(const a of units)for(const b of units)eq(P.evaluate(sourcePorts,P.product(a,b)),mm(P.evaluate(sourcePorts,a),P.evaluate(sourcePorts,b)));
  const Z1=kron(kron(Z,I2),I2),X2=kron(kron(I2,X),I2),gauge=kron(kron(X,X),X);
  const F=plus(scale(m.I,c(3,0,5)),scale(Z1,c(0,-4,5)));
  const G=mm(plus(scale(m.I,c(5,0,13)),scale(X2,c(0,-12,13))),m.Q);
  const realize=(frame,access,extraGauge=false)=>({support:conjugate(frame,m.Pi),P:conjugate(frame,m.P),Q:conjugate(frame,m.Q),
    controls:access.generators.map(coeff=>{const section={coeff,quarters:1},U=C.sectionOperator(m,section);
      const extra=extraGauge&&coeff[0]===1&&coeff[1]===1?gauge:m.I;return {section,operator:conjugate(frame,mm(extra,U))};})});
  const fPorts=realize(F,joint,true),gPorts=realize(G,joint,true);P.validatePorts(fPorts);P.validatePorts(gPorts);
  const v=mat(16,1);for(const [i,a]of [[2,2],[4,-1],[8,-1],[5,1],[9,-1]])v[i][0]=c(a);
  const rho=scale(mm(v,adj(v)),c(1,0,8)),framed=conjugate(kron(F,I2),rho),boundary=new P.PortBoundary(m,fPorts,framed,2);
  const V=mm(G,adj(F));P.verifyHandover(fPorts,gPorts,V);
  boundary.continue(swap,joint,p1,{ports:gPorts,operator:V});boundary.continue(second,joint,p2);
  const u1=P.verify(m,swap,joint,p1).operator,u2=P.verify(m,second,joint,p2).operator;
  const ideal=conjugate(kron(mm(u2,u1),I2),rho),actual=boundary.snapshot();
  const readings=[e([]),e(['P']),e(['Q']),[{word:['P','Q'],coefficient:[0,1,1]},{word:['Q','P'],coefficient:[0,-1,1]}]];
  for(const terms of readings)for(const B of [I2,X,Y,Z])
    assert.deepEqual(boundary.inspectReading(terms,B),tr(mm(ideal,kron(R.expression(m,terms),B))));
  assert(!isZero(minus(actual.rho,conjugate(kron(G,I2),ideal))),'extra content should actually change');
  assert.equal(actual.history.length,2);assert.equal(actual.history[0].hasHandover,true);
  // The same compiled certificate works for another representation without
  // recompilation, and the serial and joint implementations need not leave
  // identical complete context states.
  const slowBoundary=new P.PortBoundary(m,realize(F,serial),framed,2),fastBoundary=new P.PortBoundary(m,fPorts,framed,2);
  slowBoundary.continue(swap,serial,slow);fastBoundary.continue(swap,joint,p1);
  for(const terms of readings)for(const B of [I2,X,Y,Z])assert.deepEqual(slowBoundary.inspectReading(terms,B),fastBoundary.inspectReading(terms,B));
  assert(!isZero(minus(slowBoundary.snapshot().rho,fastBoundary.snapshot().rho)));
  // Add retained internal context, including correlations. The compiler still
  // receives only the original abstract goal and access grammar.
  const contextPorts={support:kron(m.Pi,I2),P:kron(m.P,I2),Q:kron(m.Q,I2),
    controls:joint.generators.map(coeff=>({section:{coeff,quarters:1},operator:kron(C.sectionOperator(m,{coeff,quarters:1}),X)}))};
  const contextual=new P.PortBoundary(m,contextPorts,rho);contextual.continue(swap,joint,p1);contextual.continue(second,joint,p2);
  for(const terms of readings)assert.deepEqual(contextual.inspectReading(terms),tr(mm(ideal,kron(R.expression(m,terms),I2))));

  // Two deterministic realizations, no distribution over models: the same
  // returned state requires different answers about the original input.
  const input0=scale(plus(m.Pi,mm(m.Pi,m.Q)),c(1,0,4)),input1=conjugate(m.P,input0);
  const returned0=input0,returned1=conjugate(m.P,input1);eq(returned0,returned1);
  const answer0=tr(mm(input0,mm(m.Pi,m.Q))),answer1=tr(mm(input1,mm(m.Pi,m.Q)));
  assert.deepEqual(answer0,one);assert.deepEqual(answer1,c(-1,0,2));
  // The same role Q, physically matched to its encoder, distinguishes them.
  const matched0=new P.PortBoundary(m,realize(m.I,joint),returned0),matched1=new P.PortBoundary(m,realize(m.P,joint),returned1);
  assert.deepEqual(matched0.inspectReading(e(['Q'])),answer0);assert.deepEqual(matched1.inspectReading(e(['Q'])),answer1);
  // A receiver may satisfy every local source law and share exactly the same
  // support while still being incorrectly joined to the arriving content.
  const mismatched=realize(mm(F,m.P),joint);P.validatePorts(mismatched);eq(mismatched.support,fPorts.support);
  let negatives=0;const rejects=f=>{assert.throws(f);negatives++;};
  rejects(()=>P.verifyHandover(fPorts,mismatched,m.I));
  const old=fastBoundary.snapshot();rejects(()=>fastBoundary.continue(second,joint,p2,{ports:mismatched,operator:m.I}));assert.deepEqual(fastBoundary.snapshot(),old);
  const missingJoint=new P.PortBoundary(m,realize(F,serial),framed,2);rejects(()=>missingJoint.continue(swap,joint,p1));assert.equal(missingJoint.snapshot().history.length,0);
  const badPair=structuredClone(fPorts);badPair.Q=badPair.P;eq(mm(mm(badPair.Q,badPair.Q),badPair.support),badPair.support);rejects(()=>P.validatePorts(badPair));
  const badContact=structuredClone(fPorts);badContact.controls[2].operator=m.I;rejects(()=>P.validatePorts(badContact));
  const badProof=structuredClone(p1);badProof.unitary[0]=one;rejects(()=>P.verify(m,swap,joint,badProof));
  rejects(()=>P.verify(m,second,joint,p1));rejects(()=>P.verify({...m},swap,joint,p1));
  const falsePhysical=structuredClone(p1);falsePhysical.physicalAdmission={backend:'unconfirmed'};rejects(()=>P.verify(m,swap,joint,falsePhysical));
  rejects(()=>new P.PortBoundary(m,fPorts,scale(kron(eye(8),I2),c(1,0,16)),2));
  const before={...P.counters},rBefore={...R.counters};P.verify(m,swap,joint,p1);P.verify(m,second,joint,p2);P.verify(m,swap,serial,slow);
  assert.deepEqual(P.counters,before);assert.deepEqual(R.counters,rBefore);
  const out={scope:'One relation program for all admitted contact representations; explicit coherent model access only',
    defining_algebra:'p²=q²=1, pq+qp=-1 on admitted support',formal_basis_products_checked:16,
    compilation_takes_no_frame_matrix:true,control_sections:{joint:1,serial:3},
    same_certificate_actual_carrier_dimensions:[8,16],independent_continued_requests:2,
    changing_frame_handover_preserves_logical_reference:true,extra_retained_content_changes:true,
    serial_and_joint_need_not_leave_same_full_state:true,
    deterministic_unknown_encoding_separator:{same_returned_state:true,required_answers:['1','-1/2']},
    matched_receiver_uses_same_role_without_frame_identification:true,
    same_support_and_valid_individual_laws_do_not_prove_handover:true,
    negative_checks:negatives,rejection_before_mutation:true,physical_admission:null,
    milliseconds:Math.round(performance.now()-start)};
  if(directory){fs.mkdirSync(directory,{recursive:true});const file=path.join(directory,'wave-8-port-certificates.json');
    fs.writeFileSync(file,R.serialize([{goal:swap,access:joint,certificate:p1},{goal:second,access:joint,certificate:p2},{goal:swap,access:serial,certificate:slow}])+'\n');
    fs.writeFileSync(path.join(directory,'wave-8-port-realizations.json'),R.serialize({fPorts,gPorts,V,contextPorts,mismatched,input0,input1})+'\n');
    const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_port_continuation.js'),file],{encoding:'utf8',timeout:15000});assert.equal(cp.status,0,cp.stderr);
    out.persistedVerifier=JSON.parse(cp.stdout);assert.deepEqual(out.persistedVerifier.constructionCalls,{constructions:0});assert.deepEqual(out.persistedVerifier.sourceConstructionCalls,{linearSolves:0,normalFormClosures:0});
    out.milliseconds=Math.round(performance.now()-start);fs.writeFileSync(path.join(directory,'wave-8-port-checks.json'),JSON.stringify(out,null,2)+'\n');}
  return out;
}
if(require.main===module)console.log(JSON.stringify(check(process.argv[2]),null,2));
module.exports={check};
