"use strict";
// Stateful host protocol for the exact declared model. It is not a QPU driver.
// Certificates are reusable mathematics; tickets bind a planned occurrence to
// its predecessor in this session. Neither kind creates physical admission.
const assert=require('node:assert/strict'),fs=require('node:fs'),crypto=require('node:crypto');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const A=require('./coordinated_acquired_question.js'),T=require('./coordinated_instrument_transport.js');
const B=require('./coordinated_probe_continuation.js');
const E=C.exact,{c,eq,mm,minus,scale,isZero}=E,key=C.json,copy=structuredClone;
const sessions=new WeakMap();
class Refusal extends Error {constructor(code,detail,evidence=null){super(detail);this.code=code;this.evidence=evidence;}}
function need(test,code,detail){if(!test)throw new Refusal(code,detail);}
function fields(value,required,optional=[]){need(value&&typeof value==='object'&&!Array.isArray(value),'invalid-message','Object required');
  need(required.every(k=>Object.hasOwn(value,k))&&Object.keys(value).every(k=>[...required,...optional].includes(k)),
    'invalid-message',`Expected only ${required.join(', ')}${optional.length?'; optionally '+optional.join(', '):''}`);}
function touch(m){C.verifyPlan(m,{targetScore:[],inputProjector:m.Pi,requiredInteriorCuts:[]},C.accessModel([]),
  {rule:'retain-source-score',source:m.source,score:[]});}
const uniqueFrames=frames=>[...new Map(frames.map(f=>[key(f),copy(f)])).values()];
function effectiveGoals(m,request,goals){need(Array.isArray(goals)&&goals.length===2,'invalid-message','Two conditional goal slots are required');
  const inactive=[false,false];
  // Only a globally zero answer projector on Pi is used by this rule. A
  // branch that merely has small weight on one supplied input is not omitted.
  for(let answer=0;answer<2;answer++)if(isZero(minus(request.question,scale(m.Pi,c(answer?-1:1)))))inactive[1-answer]=true;
  const identity={kind:'source-reading-relations',input:'derived-noncommuting-sector',relations:[
    {after:R.reading(['P']),before:R.reading(['P'])},{after:R.reading(['Q']),before:R.reading(['Q'])}]};
  return {inactive,next:goals.map((goal,a)=>copy(inactive[a]?identity:goal))};
}
function configuration(m,config){fields(config,['initialFrame','acquisitionAccess','probeAccess','controlAccess'],['maximumBranches','maximumTickets']);
  touch(m);T.validateFrame(config.initialFrame);eq(mm(m.Pi,config.initialFrame.support),config.initialFrame.support);
  A.instantiate(m,config.acquisitionAccess);C.accessModel(config.controlAccess.generators);
  assert.equal(config.controlAccess.kind,'declared-generator-grammar');
  // Primitive access is still a declaration, not authenticated hardware.
  const p=config.probeAccess,known=B.primitiveAccess();assert.equal(p.kind,known.kind);assert.equal(p.physicalAdmission,null);
  for(const k of ['probePreparation','measurement','reset','permutationEntries'])assert.equal(p[k],known[k]);
  assert(Array.isArray(p.gates)&&p.gates.every(g=>known.gates.includes(g)));assert.equal(new Set(p.gates).size,p.gates.length);
  for(const key of ['maximumBranches','maximumTickets'])if(config[key]!==undefined)assert(Number.isSafeInteger(config[key])&&config[key]>0);
  return {...copy(config),maximumBranches:config.maximumBranches??64,maximumTickets:config.maximumTickets??64};}
function build(s,request,goals,frames){const {m,config}=s,acquisitionAccess=config.acquisitionAccess,probeAccess=config.probeAccess;
  const acquisition=A.construct(m,request,acquisitionAccess);
  if(acquisition.kind==='antiunitary-access-obstruction'){
    const checked=A.verify(m,request,acquisitionAccess,acquisition);throw new Refusal('proved-access-obstruction',checked.scope,acquisition);}
  if(acquisition.kind!=='constructed-projective-acquisition')throw new Refusal('unresolved-template',
    'The one-conjugation acquisition template did not construct a complete instrument; no global impossibility follows',acquisition);
  const normalized=effectiveGoals(m,request,goals),next=normalized.next.map(goal=>({goal,access:copy(config.controlAccess)}));
  let lowering=null;
  if(acquisition.program.readout!==null){const missing=['H','X','CX','CCX'].filter(g=>!probeAccess.gates.includes(g));
    need(!missing.length,'missing-declared-primitive',`This lowering needs ${missing.join(', ')}; no different implementation was excluded`);
    lowering=B.lowerReadout(m,acquisition.program.readout,probeAccess);}
  const nextCertificates=next.map(({goal,access})=>R.resolve(m,goal,access));
  for(let a=0;a<2;a++)if(nextCertificates[a].kind!=='realization'){
    R.verify(m,next[a].goal,next[a].access,nextCertificates[a]);
    const scope=nextCertificates[a].kind==='fixed-access-obstruction'?'No finite word in the declared fixed-quarter control grammar meets this following goal':
      'No nonzero intertwiner in the declared source logical algebra meets these following relations';
    throw new Refusal('proved-control-obstruction',scope,{answer:a,certificate:nextCertificates[a]});}
  const checked=A.verify(m,request,acquisitionAccess,acquisition),actuals=next.map(({goal,access},a)=>R.verify(m,goal,access,nextCertificates[a]).operator);
  const answers=acquisition.program.readout===null?[acquisition.program.constant]:acquisition.program.decoder;
  const instrument={kind:'declared-recorded-instrument',inputDimension:m.I.length,
    outcomes:answers.map(a=>({label:String(a),kraus:[mm(actuals[a],checked.operators[a])]}))};
  const stage=T.deriveStage(m,frames,instrument);
  for(const certificate of stage.cases)if(certificate.kind==='instrument-transport-obstruction'){
    T.verify(m,certificate.input,instrument,certificate);throw new Refusal('proved-future-obstruction',
      'This constructed complete instrument cannot transport the promised algebra; other instruments are not excluded',certificate);}
  const certificate={kind:'owned-probe-continuation',source:m.source,request:copy(request),acquisitionAccess:copy(acquisitionAccess),probeAccess:copy(probeAccess),
    next,acquisition,lowering,nextCertificates,stage,physicalAdmission:null};
  B.verify(m,request,acquisitionAccess,probeAccess,next,certificate);return certificate;
}
function admit(s,request,goals,frames,certificate){const normalized=effectiveGoals(s.m,request,goals);
  const next=normalized.next.map(goal=>({goal,access:copy(s.config.controlAccess)}));
  const checked=B.verify(s.m,request,s.config.acquisitionAccess,s.config.probeAccess,next,certificate);
  // A mathematically valid certificate can concern the wrong input boundary.
  const frontier=uniqueFrames(frames),cases=certificate.stage.cases;
  for(const frame of frontier)need(cases.some(c=>key(c.input)===key(frame)),'wrong-boundary','Certificate does not cover this actual planned boundary');
  const outputFrames=uniqueFrames(frontier.flatMap(frame=>cases.find(c=>key(c.input)===key(frame)).outputs.map(o=>o.frame).filter(Boolean)));
  return {checked,next,outputFrames,inactive:normalized.inactive};}
class Session {
  constructor(model,config){sessions.set(this,{m:model,config:configuration(model,config),id:crypto.randomUUID(),tickets:new Map(),
    current:'entry',boundary:null,halted:false,revision:0});}
  status(){const s=sessions.get(this);return {kind:'declared-local-model-session',session:s.id,loaded:s.boundary!==null,current:s.current,
    revision:s.revision,tickets:s.tickets.size,halted:s.halted,branches:s.boundary?.snapshot().blocks.length??0,physicalAdmission:null};}
  handle(message){const s=sessions.get(this);try{
    fields(message,['op'],['after','request','next','certificate','rho','referenceDimension','ticket','name','reference']);
    need(!s.halted,'session-halted','Execution status is unresolved; this session cannot retry or start again');
    if(message.op==='status'){fields(message,['op']);return {accepted:true,...this.status()};}
    if(message.op==='prepare'){
      fields(message,['op','after','request','next'],['certificate']);touch(s.m);
      need(!s.boundary,'host-planning-closed','Plan and evidence preparation must finish before loading this model carrier');
      need(s.tickets.size<s.config.maximumTickets,'host-resource-limit','Prepared ticket limit; no physical impossibility is claimed');
      need(Array.isArray(message.next)&&message.next.length===2,'invalid-message','Two following goals required');
      let frames;if(message.after==='entry')frames=[s.config.initialFrame];else{
        const parent=s.tickets.get(message.after);need(parent,'unknown-predecessor','No locally admitted predecessor ticket');frames=parent.outputFrames;}
      let certificate,admitted;
      try{certificate=message.certificate?copy(message.certificate):build(s,message.request,message.next,frames);
        admitted=admit(s,message.request,message.next,frames,certificate);
      }catch(error){if(error instanceof Refusal)throw error;
        if(error instanceof assert.AssertionError||error instanceof TypeError||error instanceof RangeError)
          throw new Refusal('invalid-evidence',error.message);throw error;}
      const id=`${s.id}:${s.tickets.size+1}`;
      s.tickets.set(id,{id,parent:message.after,request:copy(message.request),next:admitted.next,certificate:copy(certificate),
        inputFrames:uniqueFrames(frames),outputFrames:admitted.outputFrames,branchFactor:admitted.checked.branches.length});
      return {accepted:true,kind:'prepared-continuation',ticket:id,after:message.after,source:s.m.source,
        outputBoundaries:admitted.outputFrames.length,inactiveAnswers:admitted.inactive.map((x,i)=>x?i:-1).filter(x=>x>=0),physicalAdmission:null};
    }
    if(message.op==='load'){
      fields(message,['op','rho'],['referenceDimension']);need(!s.boundary,'already-loaded','The actual input can be loaded only once');touch(s.m);
      let candidate;try{candidate=new B.ProbeBoundary(s.m,s.config.initialFrame,message.rho,message.referenceDimension??1);}
      catch(error){if(error instanceof assert.AssertionError||error instanceof TypeError)throw new Refusal('invalid-input',error.message);throw error;}
      s.boundary=candidate;return {accepted:true,kind:'input-retained',current:s.current,physicalAdmission:null};
    }
    if(message.op==='execute'){
      fields(message,['op','ticket']);need(s.boundary,'input-not-loaded','Load the source once before executing');const node=s.tickets.get(message.ticket);
      need(node,'unknown-ticket','Ticket was not admitted in this session');need(node.parent===s.current,'wrong-occurrence','Ticket does not follow the actual retained predecessor');
      need(s.boundary.snapshot().blocks.length*node.branchFactor<=s.config.maximumBranches,'host-resource-limit',
        'Explicit branch representation would exceed the host limit; no physical impossibility is claimed');
      try{touch(s.m);admit(s,node.request,node.next.map(n=>n.goal),s.boundary.frontier(),node.certificate);}
      catch(error){if(error instanceof Refusal)throw error;throw new Refusal('invalid-evidence',error.message);}
      // The lower model is transactional. Still stop on any unexpected failure
      // here; this policy must not become a silent retry in a physical adapter.
      try{s.boundary.execute(node.request,s.config.acquisitionAccess,s.config.probeAccess,node.next,node.certificate);}
      catch(error){s.halted=true;return {...this.status(),accepted:false,kind:'execution-unconfirmed',detail:error.message};}
      s.current=node.id;s.revision++;return {...this.status(),accepted:true,kind:'continued'};
    }
    if(message.op==='audit-reading'){
      fields(message,['op','name'],['reference']);need(s.boundary,'input-not-loaded','No actual model input');
      let value;try{value=s.boundary.inspect(message.name,message.reference);}catch(error){throw new Refusal('outside-declared-future',error.message);}
      return {accepted:true,kind:'mathematical-inspection-only',name:message.name,value,physicalAdmission:null};
    }
    if(message.op==='audit-snapshot'){fields(message,['op']);need(s.boundary,'input-not-loaded','No actual model input');
      return {accepted:true,kind:'mathematical-snapshot-only',snapshot:s.boundary.snapshot(),physicalAdmission:null};}
    if(message.op==='export-certificate'){fields(message,['op','ticket']);const node=s.tickets.get(message.ticket);need(node,'unknown-ticket','No such ticket');
      return {accepted:true,kind:'reusable-mathematical-certificate',certificate:copy(node.certificate),physicalAdmission:null};}
    throw new Refusal('invalid-message','Unknown operation');
  }catch(error){if(error instanceof Refusal)return {accepted:false,kind:error.code,detail:error.message,evidence:error.evidence,
      retainedRevision:s.revision,physicalAdmission:null};
    // No automatic reconstruction of the session after a programming failure.
    s.halted=true;return {...this.status(),accepted:false,kind:'internal-error',detail:error.message};}}
}
function runConsole(configPath){const model=C.currentModel(),config=R.deserialize(fs.readFileSync(configPath,'utf8')),session=new Session(model,config);
  const emit=x=>process.stdout.write(R.serialize(x)+'\n');emit({ready:true,...session.status()});
  require('node:readline').createInterface({input:process.stdin}).on('line',line=>{if(!line.trim())return;
    let message;try{message=R.deserialize(line);}catch(error){emit({accepted:false,kind:'invalid-json',retainedRevision:session.status().revision});return;}
    emit(session.handle(message));});}
if(require.main===module)runConsole(process.argv[2]);
module.exports={Session,runConsole,exact:E};
