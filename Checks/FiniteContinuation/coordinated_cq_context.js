"use strict";
// Bind uniform pulse evidence to the complete supported cq output of an
// existing continuation. Omitted environment remains retained, never fresh.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const A=require('./coordinated_acquired_question.js'),B=require('./coordinated_probe_continuation.js');
const G=require('./coordinated_cut_background.js'),P=require('./coordinated_pulse_relation.js');
const S=require('./coordinated_session_protocol.js');
const E=C.exact,{c,z,one,ii,mat,eye,scale,plus,adj,mm,kron,eq,rref}=E;
const key=C.json,counters={rangeConstructions:0,constructions:0};
const I2=eye(2),P0=[[one,z],[z,z]],P1=[[z,z],[z,one]];
const remaining='exact-bound-precontrol-projective-Z-same-raw-reset-postcontrol-and-conditional-next';
function touch(m){C.verifyPlan(m,{targetScore:[],inputProjector:m.Pi,requiredInteriorCuts:[]},C.accessModel([]),
  {rule:'retain-source-score',source:m.source,score:[]});}
function context(available,mode,generators){return {kind:'declared-cq-continuation-context',available:structuredClone(available),mode,
  generators:structuredClone(generators),pulseLaw:'exp(-i*s*(I-F)), s absolutely continuous from 0 to pi/2',
  backgroundScope:'coherent-probe-segments-only',remainingEpisode:remaining,physicalAdmission:null};}
function validateContext(ctx){assert.equal(ctx.kind,'declared-cq-continuation-context');assert(['direct','lowered'].includes(ctx.mode));
  assert.equal(ctx.pulseLaw,'exp(-i*s*(I-F)), s absolutely continuous from 0 to pi/2');
  assert.equal(ctx.backgroundScope,'coherent-probe-segments-only');assert.equal(ctx.remainingEpisode,remaining);
  assert(Array.isArray(ctx.generators));assert.equal(ctx.physicalAdmission,null);}
function inverse(M){const n=M.length,rr=rref(M.map((row,i)=>[...row,...eye(n)[i]]));
  assert.deepEqual(rr.pivots.slice(0,n),Array.from({length:n},(_,i)=>i));return rr.A.map(row=>row.slice(n));}
function rangeCoordinates(support){counters.rangeConstructions++;
  const columns=rref(support).pivots,U=support.map(row=>columns.map(j=>row[j])),D=mm(inverse(mm(adj(U),U)),adj(U));
  const proof={columns:U,dual:D};verifyRange(support,proof);return proof;}
function verifyRange(support,proof){const {columns:U,dual:D}=proof,n=support.length;
  assert(U.length===n&&U[0].length>0&&U.every(row=>row.length===U[0].length));const k=U[0].length;
  assert(D.length===k&&D.every(row=>row.length===n));eq(mm(D,U),eye(k));eq(mm(U,D),support);
  // These two equalities prove the precise range and dimension without a
  // rank computation or a pseudoinverse in the checking path.
  return k;}
function fullOutputBasis(support,proof){const k=verifyRange(support,proof),small=[];
  for(let i=0;i<k;i++){const H=mat(k);H[i][i]=one;small.push(H);}
  for(let i=0;i<k;i++)for(let j=i+1;j<k;j++){
    const H=mat(k),J=mat(k);H[i][j]=one;H[j][i]=one;J[i][j]=ii;J[j][i]=c(0,-1);small.push(H,J);}
  return small.map(H=>mm(mm(adj(proof.dual),H),proof.dual));}
function planData(m,plan,ctx){touch(m);validateContext(ctx);
  const checked=B.verify(m,plan.request,plan.acquisitionAccess,plan.probeAccess,plan.next,plan),program=plan.acquisition.program;
  assert(program.readout!==null,'constant acquisitions need no probe episode; outside this adapter');
  assert.equal(key(ctx.available.primitives),key(plan.probeAccess));
  const available=A.instantiate(m,plan.acquisitionAccess);
  const control=name=>{if(name===null)return m.I;const q=available.controls.find(x=>x.name===name);assert(q);return q.operator;};
  return {checked,program,pre:control(program.pre),post:control(program.post)};}
function obligation(m,plan,ctx,program,paths,ranges){const d=planData(m,plan,ctx);
  assert.equal(program.name,d.program.readout);assert.equal(program.mode,ctx.mode);assert.equal(key(program.available),key(ctx.available));
  const low=G.programData(m,program,ctx.available),cases=plan.stage.cases,n=m.I.length;
  assert.equal(ranges.length,cases.length);const finalQuestions=[],links=[];
  for(let i=0;i<cases.length;i++){assert.equal(ranges[i].length,d.checked.branches.length);
    for(let j=0;j<d.checked.branches.length;j++){
      const branch=d.checked.branches[j],out=cases[i].outputs[j],raw=branch.raw;assert(raw===0||raw===1);
      assert.equal(out.label,String(branch.answer));const selector=raw?P1:P0;
      const tail=mm(d.checked.nextChecked[branch.answer].operator,d.post);
      const insert=(name,O)=>{const operator=kron(selector,mm(mm(adj(tail),O),tail));
        const pulled=mm(mm(adj(low.operator),operator),low.operator).slice(0,n).map(row=>row.slice(0,n));
        const whole=mm(mm(adj(d.pre),pulled),d.pre),input=cases[i].input.support;
        eq(mm(mm(input,whole),input),mm(mm(input,mm(mm(adj(branch.sourceOperator),O),branch.sourceOperator)),input));
        finalQuestions.push({name:`case-${i}/raw-${raw}/${name}`,operator});links.push({case:i,branch:j,raw,answer:branch.answer,name,outputOperator:O});};
      insert('weight',m.I);
      if(out.frame){const proof=ranges[i][j],basis=fullOutputBasis(out.frame.support,proof);
        insert('output-support',out.frame.support);basis.forEach((O,k)=>insert(`full-output-${k}`,O));
      }else assert.equal(ranges[i][j],null);
    }
  }
  const pulseSpec={kind:'probe-pulse-background-question',program,available:ctx.available,paths,finalQuestions,
    generators:Array.from({length:low.steps.length},()=>ctx.generators)};
  return {...d,pulseSpec,links,low};}
function construct(m,plan,ctx){touch(m);counters.constructions++;const d=planData(m,plan,ctx);
  const program=G.constructProgram(m,d.program.readout,ctx.mode,ctx.available),paths=P.declaredPaths(m,program,ctx.available);
  const ranges=plan.stage.cases.map(c=>c.outputs.map(out=>out.frame?rangeCoordinates(out.frame.support):null));
  const data=obligation(m,plan,ctx,program,paths,ranges),pulse=P.construct(m,data.pulseSpec);
  const certificate={kind:'full-cq-continuation-context',source:m.source,plan:structuredClone(plan),context:structuredClone(ctx),
    program,paths,ranges,pulse,physicalAdmission:null};verify(m,plan,ctx,certificate);return certificate;}
function verify(m,plan,ctx,certificate){touch(m);assert.equal(certificate.kind,'full-cq-continuation-context');
  assert.equal(key(certificate.source),key(m.source));assert.equal(key(certificate.plan),key(plan));assert.equal(key(certificate.context),key(ctx));
  assert.equal(certificate.physicalAdmission,null);
  const data=obligation(m,plan,ctx,certificate.program,certificate.paths,certificate.ranges),p=P.verify(m,data.pulseSpec,certificate.pulse);
  if(!p.admitted)return {admitted:false,scope:'this sufficient uniform full-output pulse condition failed; other context organizations are not excluded',
    affected:data.links[p.obstruction.question],obstruction:p.obstruction,physicalAdmission:null};
  return {admitted:true,scope:'complete supported source-plus-record output, including any untouched reference, for every retained environment in the declared episode model',
    remainingEpisode:ctx.remainingEpisode,backgroundScope:ctx.backgroundScope,branches:data.checked.branches.length,
    boundImplementation:{mode:certificate.program.mode,readout:certificate.program.name},
    outputDimensions:certificate.ranges.map(row=>row.map(r=>r?r.columns[0].length:0)),physicalAdmission:null};}

// Mandatory gate around the existing LOCAL MATHEMATICAL session. Its state
// is a sufficient source/record representative for the uniform family; it
// is not the hidden environment or a claimed QPU state. The old session API
// is neither modified nor advertised as carrying this extra obligation.
const live=new WeakMap();
class ContextSession {
  constructor(m,config,ctx){touch(m);validateContext(ctx);live.set(this,{m,context:structuredClone(ctx),inner:new S.Session(m,config),proofs:new Map()});}
  status(){const s=live.get(this);return {...s.inner.status(),kind:'declared-uniform-context-model-session',contextAdmittedTickets:s.proofs.size,
    boundImplementationMode:s.context.mode,
    represented:'source, actual classical history and untouched reference; environment omitted under the bound relation'};}
  handle(message){const s=live.get(this);
    if(!message||typeof message!=='object'||Array.isArray(message))return {accepted:false,kind:'invalid-message',physicalAdmission:null};
    if(message.op==='status'&&Object.keys(message).length===1)return {accepted:true,...this.status()};
    if(message.op==='prepare'){
      if(!message.certificate||!message.contextCertificate)return {accepted:false,kind:'missing-context-evidence',physicalAdmission:null};
      const {contextCertificate,...plain}=message;
      let v;try{v=verify(s.m,plain.certificate,s.context,contextCertificate);}catch(error){return {accepted:false,kind:'invalid-context-evidence',detail:'Context evidence failed exact verification for the current plan and declared family',physicalAdmission:null};}
      if(!v.admitted)return {accepted:false,kind:'unadmitted-context',affected:v.affected,scope:v.scope,physicalAdmission:null};
      const result=s.inner.handle(plain);if(result.accepted)s.proofs.set(result.ticket,{plan:structuredClone(plain.certificate),certificate:structuredClone(contextCertificate)});
      return {...result,contextAdmission:result.accepted?v:null};
    }
    if(message.op==='execute'){
      const proof=s.proofs.get(message.ticket);if(!proof)return {accepted:false,kind:'unknown-context-ticket',physicalAdmission:null};
      try{assert(verify(s.m,proof.plan,s.context,proof.certificate).admitted);}catch(error){return {accepted:false,kind:'invalid-context-evidence',detail:'The saved context evidence no longer verifies',physicalAdmission:null};}
      return {...s.inner.handle(message),contextModel:'uniform-full-cq-output; actual background restricted to coherent probe segments'};
    }
    return s.inner.handle(message);
  }
}
if(require.main===module){const m=C.currentModel(),bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8'));
  const results=bundle.map(b=>verify(m,b.plan,b.context,b.certificate));console.log(R.serialize({results:results.map(r=>({admitted:r.admitted,scope:r.scope,affected:r.affected?.name})),
    constructionCalls:counters,probeConstructionCalls:B.counters,pulseConstructionCalls:P.counters,physicalAdmission:null}));}
module.exports={context,construct,verify,obligation,fullOutputBasis,ContextSession,counters,exact:E};
