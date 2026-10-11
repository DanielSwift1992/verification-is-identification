"use strict";
// A moving algebra of usable readings. Symbolic source ports, conditional
// coherent interpretation, and physical control availability remain separate.
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const {c,z,one,ii,nz,sub,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=C.exact;
const root=path.resolve(__dirname,'../..'),judgeFile=path.resolve(root,'../gate/bin/judge-where.js');
const {judgeWhereTexts}=require(judgeFile),hash=x=>crypto.createHash('sha256').update(x).digest('hex'),key=C.json;
const issued=new WeakSet();
const counters={normalFormClosures:0};
function freeze(x){if(x&&typeof x==='object'){Object.values(x).forEach(freeze);Object.freeze(x);}return x;}
function permutations(items){return items.length?items.flatMap((x,i)=>permutations(items.filter((_,j)=>j!==i)).map(p=>[x,...p])):[[]];}
function readMovingSource() {
  const paths=['Sources/VerificationIsIdentification/Primitive.swift','Checks/LocalPolicyCourt.swift','Checks/DerivedContactRelations.swift','Checks/MovingContactRelations.swift'];
  const texts=paths.map(p=>fs.readFileSync(path.join(root,p),'utf8'));
  const paired=texts[0].match(/public enum Paired\b[^{}]*\{[^{}]*\}/g);assert.equal(paired.length,1);
  let source=paired[0]+'\n'+texts[1].slice(0,texts[1].indexOf('public typealias CourtPolicy'))+'\n'+texts[2]+'\n'+texts[3];
  const tags=['Never','Paired<Never, Never>','Paired<Never, Paired<Never, Never>>','Paired<Paired<Never, Never>, Never>'];
  const perms=permutations([0,1,2,3]);
  perms.forEach((p,i)=>source+=`\npublic typealias MC${i} = MovingContactQuadruple<${p.map(j=>tags[j]).join(', ')}>\n`);
  const equation=(name,a,b)=>`\npublic typealias ${name} = LocalCourtSame<${a}, ${b}>\npublic typealias Use${name} = LocalCourtUse<${name}>\n`;
  const ports={};
  for(const name of ['P','Q','T','ReceiverQ']){
    const matches=perms.filter((_,j)=>{const v=judgeWhereTexts(source+equation('ReadMoving',`MC0.${name}`,`MC${j}`));assert.equal(v.judged,1);return !v.refusals.length;});
    assert.equal(matches.length,1);ports[name]=matches[0];
  }
  let certificate=source;
  for(let i=0;i<24;i++)for(const [a,b]of [['T.T',''],['T.P.T','P'],['T.Q.T','ReceiverQ'],['P.Left','Left.P'],['Q.Left','Left.Q']])
    certificate+=equation(`Moving${i}_${a.replaceAll('.','')}`,`MC${i}.${a}`,b?`MC${i}.${b}`:`MC${i}`);
  const verdict=judgeWhereTexts(certificate);assert.equal(verdict.judged,120);assert.deepEqual(verdict.refusals,[]);
  const falseDirect=judgeWhereTexts(source+equation('FalseDirect','MC0.Q','MC0.ReceiverQ'));assert(falseDirect.refusals.length);
  const mutated=source.replace('MovingContactQuadruple<A, B, D, C>','MovingContactQuadruple<A, B, C, D>');assert.notEqual(mutated,source);
  assert(judgeWhereTexts(mutated+equation('MutatedT','MC0.T',`MC${perms.findIndex(p=>key(p)===key(ports.T))}`)).refusals.length);
  return {ports,certificate,equalities:120,source:Object.fromEntries([...paths.map((p,i)=>[p,hash(texts[i])]),[judgeFile,hash(fs.readFileSync(judgeFile))]])};
}
function spin(order){const n=2**order.length,A=mat(n);for(let x=0;x<n;x++){
  const bits=order.map((_,j)=>(x>>(order.length-1-j))&1);const y=order.reduce((y,j)=>2*y+bits[j],0);A[y][x]=one;
}return A;}
function currentModel(){
  const base=C.currentModel(),source=readMovingSource(),operators=Object.fromEntries(Object.entries(source.ports).map(([k,v])=>[k,spin(v)]));
  eq(operators.P,kron(base.P,eye(2)));eq(operators.Q,kron(base.Q,eye(2)));
  const initial=kron(base.Pi,eye(2)),I=eye(16),K=operators.T;
  const model=freeze({base,operators,I,initial,receiver:mm(mm(K,initial),K),source:source.source,ports:source.ports,
    sourceCertificate:source.certificate,sourceEqualities:source.equalities});issued.add(model);return model;
}
function touchRoot(model){assert(issued.has(model),'moving model must be read from the current source');
  for(const [p,h]of Object.entries(model.source))assert.equal(hash(fs.readFileSync(path.isAbsolute(p)?p:path.join(root,p))),h,'moving source changed');
  C.verifyPlan(model.base,{targetScore:[],inputProjector:model.base.Pi,requiredInteriorCuts:[]},C.accessModel([]),
    {rule:'retain-source-score',source:model.base.source,score:[]});
}
function initialAlgebra(model){return [model.initial,mm(model.initial,model.operators.P),mm(model.initial,model.operators.Q),scale(comm(model.operators.P,model.operators.Q),ii)];}
function conjugate(V,O){return mm(mm(V,O),adj(V));}
function algebra(model,frame){return initialAlgebra(model).map(O=>conjugate(frame,O));}
function access(names){return {kind:'declared-four-role-fixed-exchange-access',names:[...names],
  pathSemantics:'exp(-i integral(u) S) with final area pi/2'};}
function validateAccess(model,available){assert.equal(available.kind,'declared-four-role-fixed-exchange-access');
  assert.equal(available.pathSemantics,'exp(-i integral(u) S) with final area pi/2','endpoint permutation alone does not specify the intervening interaction');
  assert.equal(new Set(available.names).size,available.names.length);
  available.names.forEach(name=>assert(Object.hasOwn(model.operators,name),'unknown addressed contact'));
}
function operator(model,word){return word.reduce((W,name)=>{assert(Object.hasOwn(model.operators,name));return mm(scale(model.operators[name],c(0,-1)),W);},model.I);}
function signature(A){const first=A.flat().find(nz);assert(first);return key(A.map(row=>row.map(x=>div(x,first))));}
function constraints(model,frame,goal){
  return crossConstraints(model,frame,frame,goal);
}
function crossConstraints(model,from,to,goal){
  eq(mm(adj(from),from),model.I);eq(mm(adj(to),to),model.I);
  const system=R.system(model.base,goal);
  const input=conjugate(from,model.initial),output=conjugate(to,model.initial);
  return {input,relations:[{after:output,before:input},...system.relations.map(({after,before})=>({
    after:conjugate(to,kron(after,eye(2))),before:conjugate(from,kron(before,eye(2)))}))]};
}
function transferConstraints(model,from,to){
  eq(mm(adj(from),from),model.I);eq(mm(adj(to),to),model.I);
  return {input:conjugate(from,model.initial),relations:algebra(model,from).map((before,i)=>({before,after:algebra(model,to)[i]}))};
}
function satisfies(requirement,U){return requirement.relations.every(({before,after})=>
  isZero(mm(mm(requirement.input,minus(mm(mm(adj(U),after),U),before)),requirement.input)));
}
function construct(model,available,requirement){
  counters.normalFormClosures++;
  touchRoot(model);validateAccess(model,available);
  const states=[{word:[],distance:0,transitions:[]}],operators=[model.I],seen=new Map([[signature(model.I),0]]);
  for(let i=0;i<states.length;i++)for(const name of available.names){
    const U=mm(scale(model.operators[name],c(0,-1)),operators[i]),s=signature(U);let j=seen.get(s);
    if(j===undefined){j=states.length;assert(j<24,'four addressed roles have at most 24 permutation actions');seen.set(s,j);operators.push(U);states.push({word:[...states[i].word,name],distance:states[i].distance+1,transitions:[]});}
    states[i].transitions.push(j);
  }
  const matches=operators.map((U,i)=>i).filter(i=>satisfies(requirement,operators[i]));
  matches.sort((a,b)=>states[a].distance-states[b].distance);
  return {kind:matches.length?'realization':'fixed-access-obstruction',source:model.source,states,chosen:matches.length?matches[0]:null,physicalAdmission:null};
}
function verify(model,available,requirement,certificate){
  touchRoot(model);validateAccess(model,available);assert.equal(key(certificate.source),key(model.source));
  const states=certificate.states;assert(states.length>0&&states.length<=24);
  const operators=states.map(s=>{assert(Number.isSafeInteger(s.distance)&&s.distance>=0);assert.equal(s.word.length,s.distance);
    s.word.forEach(name=>assert(available.names.includes(name),'unavailable physical address'));
    return operator(model,s.word);});
  const signatures=operators.map(signature);assert.equal(new Set(signatures).size,states.length);
  assert.equal(states[0].distance,0);assert.equal(signatures[0],signature(model.I));
  states.forEach((s,i)=>{assert.equal(s.transitions.length,available.names.length);
    available.names.forEach((name,k)=>{const j=s.transitions[k];assert(Number.isInteger(j)&&j>=0&&j<states.length);
      assert.equal(signature(mm(scale(model.operators[name],c(0,-1)),operators[i])),signatures[j]);
      assert(states[j].distance<=s.distance+1,'invalid lower-bound labels');});});
  const matches=operators.map((U,i)=>i).filter(i=>satisfies(requirement,operators[i]));
  if(!matches.length){assert.equal(certificate.kind,'fixed-access-obstruction');assert.equal(certificate.chosen,null);return null;}
  assert.equal(certificate.kind,'realization');assert(matches.includes(certificate.chosen));
  const chosen=states[certificate.chosen];assert(matches.every(i=>chosen.distance<=states[i].distance));
  return {word:chosen.word,operator:operators[certificate.chosen],minimumSections:chosen.distance,physicalAdmission:null};
}
function proveMovingProtection(model,generators){
  touchRoot(model);
  for(const S of generators){assert(S.length===16&&S.every(row=>row.length===16));eq(adj(S),S);
    for(const O of initialAlgebra(model))assert(isZero(comm(S,O)),'initial content not protected');
    for(const name of ['P','Q','T'])assert(isZero(comm(S,model.operators[name])),'background does not commute with the moving controls');
  }
  return {source:model.source,generators:structuredClone(generators),
    claim:'Every partial exchange path transports the logical algebra under arbitrary retained joint background in the declared family',physicalAdmission:null};
}
function verifyMovingProtection(model,generators,certificate){
  assert.equal(key(certificate.source),key(model.source));assert.equal(key(certificate.generators),key(generators));
  proveMovingProtection(model,generators);return true;
}
function validDensity(rho,n){
  assert(rho.length===n&&rho.every(row=>row.length===n));eq(adj(rho),rho);assert.deepEqual(tr(rho),one);
  const A=rho.map(row=>row.slice());
  for(let k=0;k<n;k++){const p=A[k][k];assert.equal(p[1],0n);assert(p[0]>=0n,'negative joint input');
    if(!nz(p)){for(let j=k+1;j<n;j++)assert(!nz(A[k][j]),'nonpositive input');continue;}
    for(let i=k+1;i<n;i++)for(let j=k+1;j<n;j++)A[i][j]=sub(A[i][j],div(mul(A[i][k],A[k][j]),p));
  }
}
function verifyJointBackground(model,frame,dimension,W){
  const I=eye(16*dimension),E=eye(dimension);
  assert(W.length===I.length&&W.every(row=>row.length===I.length));eq(mm(adj(W),W),I);
  for(const O of [...algebra(model,frame),...['P','Q','T'].map(name=>model.operators[name])])
    assert(isZero(comm(W,kron(O,E))),'joint episode lacks the promised moving-algebra relation');
}
const liveStates=new WeakMap();
class MovingBoundary {
  constructor(model,rho,environmentDimension=1,referenceDimension=1){
    touchRoot(model);assert(Number.isSafeInteger(environmentDimension)&&environmentDimension>0);
    assert(Number.isSafeInteger(referenceDimension)&&referenceDimension>0);
    validDensity(rho,16*environmentDimension*referenceDimension);
    const support=kron(model.initial,eye(environmentDimension*referenceDimension));eq(mm(mm(support,rho),support),rho);
    liveStates.set(this,{model,rho:structuredClone(rho),frame:model.I,environmentDimension,referenceDimension,history:[]});
  }
  transfer(targetFrame,available,certificate,generators,protection,jointEpisodes){
    const s=liveStates.get(this),requirement=transferConstraints(s.model,s.frame,targetFrame);
    return apply(this,requirement,targetFrame,available,certificate,generators,protection,jointEpisodes,'transport');
  }
  continue(goal,available,certificate,generators,protection,jointEpisodes){
    const s=liveStates.get(this),requirement=constraints(s.model,s.frame,goal);
    return apply(this,requirement,s.frame,available,certificate,generators,protection,jointEpisodes,'independent-goal');
  }
  continueAndTransfer(goal,targetFrame,available,certificate,generators,protection,jointEpisodes){
    const s=liveStates.get(this),requirement=crossConstraints(s.model,s.frame,targetFrame,goal);
    return apply(this,requirement,targetFrame,available,certificate,generators,protection,jointEpisodes,'joint-goal-and-transport');
  }
  snapshot(){const s=liveStates.get(this);return {rho:structuredClone(s.rho),frame:structuredClone(s.frame),history:structuredClone(s.history),
    activePhysicalParticipants:4,environmentDimension:s.environmentDimension,referenceDimension:s.referenceDimension};}
}
function apply(boundary,requirement,targetFrame,available,certificate,generators,protection,jointEpisodes,kind){
  const s=liveStates.get(boundary),checked=verify(s.model,available,requirement,certificate);assert(checked,'no available realization');
  verifyMovingProtection(s.model,generators,protection);
  assert(Array.isArray(jointEpisodes)&&jointEpisodes.length===Math.max(1,checked.word.length));
  jointEpisodes.forEach(W=>verifyJointBackground(s.model,s.frame,s.environmentDimension,W));
  const E=eye(s.environmentDimension);let W=eye(16*s.environmentDimension);
  for(let i=0;i<jointEpisodes.length;i++){
    const control=checked.word[i]?scale(s.model.operators[checked.word[i]],c(0,-1)):s.model.I;
    W=mm(mm(jointEpisodes[i],kron(control,E)),W);
  }
  const jointRequirement={input:kron(requirement.input,E),relations:requirement.relations.map(({before,after})=>({before:kron(before,E),after:kron(after,E)}))};
  assert(satisfies(jointRequirement,W),'actual complete episode violates requested relations');
  const sourceSupport=kron(requirement.input,eye(s.environmentDimension*s.referenceDimension));
  eq(mm(mm(sourceSupport,s.rho),sourceSupport),s.rho);
  const full=kron(W,eye(s.referenceDimension)),next=mm(mm(full,s.rho),adj(full));
  s.rho=next;s.frame=structuredClone(targetFrame);s.history.push({kind,word:[...checked.word],minimumSections:checked.minimumSections,physicalAdmission:null});
  return boundary;
}
if(require.main===module){
  const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),model=currentModel();
  const {available,transfer,receiver,direct,early,absent,swap,protection}=bundle;
  verifyMovingProtection(model,protection.generators,protection);
  const stages=[
    verify(model,available,transferConstraints(model,model.I,model.operators.T),transfer),
    verify(model,available,constraints(model,model.operators.T,swap),receiver),
    verify(model,access(['P','ReceiverQ']),constraints(model,model.operators.T,swap),direct),
    verify(model,available,crossConstraints(model,model.I,model.operators.T,swap),early),
    verify(model,access(['P','Q']),transferConstraints(model,model.I,model.operators.T),absent)];
  console.log(JSON.stringify({verified:true,minimumSections:stages.map(s=>s?.minimumSections??null),
    constructionCalls:counters,physicalAdmission:null}));
}
module.exports={currentModel,initialAlgebra,algebra,access,operator,constraints,crossConstraints,transferConstraints,construct,verify,counters,
  proveMovingProtection,verifyMovingProtection,conjugate,signature,MovingBoundary,exact:C.exact};
