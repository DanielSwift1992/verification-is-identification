// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";

// A bounded adapter to the EXISTING court, not a new Swift parser or judge.
// Values are read by asking which named candidate equals a current type field.
// Every accepted plan is then applied back to all sixteen current source rows.
const fs=require("node:fs");
const path=require("node:path");
const crypto=require("node:crypto");
const assert=require("node:assert/strict");
const root=path.resolve(__dirname,"../..");
const judgePath=path.resolve(path.join(root,"Checks/Archive/WhereV2/judge-where.js"));
const {judgeWhereTexts}=require(judgePath);
const digest=x=>crypto.createHash("sha256").update(x).digest("hex");
const inputs=["Sources/Notation/Primitive.swift",
  "Sources/Examples/QuantumContinuation.swift","Sources/Examples/FinitePauliTSource.swift",
  "Checks/LocalPolicyCourt.swift"];

function context(){
  const texts=inputs.map(p=>fs.readFileSync(path.join(root,p),"utf8"));
  const extract=(text,name)=>{
    const matches=text.match(new RegExp("public (?:enum|protocol) "+name+"\\b[^{}]*\\{[^{}]*\\}","g"));
    assert(matches&&matches.length===1,"Exactly one complete current declaration: "+name);
    return matches[0];
  };
  const names=["QuantumBit","QBit0","QBit1","QuantumPauli","QI","QX","QY","QZ",
    "QuantumMeasureXQuestion","QuantumMeasureYQuestion"];
  const end=texts[3].indexOf("public typealias CourtPolicy");assert(end>0);
  const source=[extract(texts[0],"Paired"),...names.map(n=>extract(texts[1],n)),texts[2],texts[3].slice(0,end)].join("\n");
  const fingerprints=Object.fromEntries(inputs.map((p,i)=>[p,digest(texts[i])]));
  fingerprints[judgePath]=digest(fs.readFileSync(judgePath));
  return {source,fingerprints};
}

function equation(name,left,right){
  return `public typealias ${name} = LocalCourtSame<${left}, ${right}>\npublic typealias Use${name} = LocalCourtUse<${name}>\n`;
}
function reading(ctx,field,candidates){
  const accepted=candidates.filter(candidate=>{
    const r=judgeWhereTexts(ctx.source+"\n"+equation("ReadCandidate",field,candidate));
    assert.equal(r.judged,1,"The reader must judge the actual equality");
    return r.refusals.length===0;
  });
  assert.equal(accepted.length,1,"A unique interpreted value must follow at "+field);
  return accepted[0];
}

const columns={"A:X:X":"AX","A:Y:Y":"AY","A:Z:Z":"AZ",
  "B:X:X":"BX","B:Y:Y":"BY","B:Z:Z":"BZ",
  "neutral:X:X":"NX","neutral:Y:Y":"NY","neutral:Z:Z":"NZ","current:Z:Z":"CZ"};
const answerTypes={};const actions={};
for(const axis of ["X","Y"])for(const sign of [1,-1]){
  const key=`read:${sign===1?"+1":"-1"}:${axis}`;
  answerTypes[key]=`Paired<QuantumMeasure${axis}Question, QBit${sign===1?0:1}>`;
  actions[key]={kind:"terminal",read:axis,sign,physical_gates:0};
}
function sourceModel(ctx){
  const valid=[];const worlds=[];
  const probes=Object.entries(columns).map(([id])=>{
    const [p,prep,read]=id.split(":");
    return {id,path:p,prep,read,module_uses:p==="A"||p==="B"?1:2,replies:[]};
  });
  for(let i=0;i<16;i++){
    const base=`FinitePauliTXSource.Row${i}`;
    const value=reading(ctx,base+".Answer",Object.values(answerTypes));
    valid.push([Object.keys(answerTypes).find(k=>answerTypes[k]===value)]);
    worlds.push(["A","Second"].map(n=>reading(ctx,base+"."+n,["QI","QX","QY","QZ"]).slice(1)));
    for(const p of probes)p.replies.push(Number(reading(ctx,base+"."+columns[p.id],["QBit0","QBit1"]).slice(-1)));
  }
  assert.deepEqual(worlds,["I","X","Y","Z"].flatMap(a=>["I","X","Y","Z"].map(b=>[a,b])),
    "The caller's complete Pauli-pair family must be preserved");
  return {connector:["t"],consumer:"terminal",axis:"X",valid,actions,probes,worlds};
}
const chain=xs=>xs.reduceRight((tail,x)=>`Paired<${x}, ${tail}>`,"Never");

function applyPlan(ctx,model,program){
  assert.equal(program.schema,"vi.finite-continuation.program.v1");
  assert.deepEqual(program.request,{connector:["t"],consumer:"terminal",axis:"X",old_neutral_XZ_record:null});
  assert.deepEqual(program.plan.initial,Array.from({length:16},(_,i)=>i),"Full caller family required");
  const declared=new Map(program.contacts.map(p=>[p.id,p]));assert.equal(declared.size,program.contacts.length);
  const probes=new Map(model.probes.map(p=>[p.id,p]));
  for(const [id,descriptor] of declared){
    assert(probes.has(id));const {replies,...expected}=probes.get(id);assert.deepEqual(descriptor,expected);
  }
  for(const [id,action] of Object.entries(program.continuations))assert.deepEqual(action,actions[id]);
  let claims=equation("CallerQuestion", "Paired<FinitePauliTXSource.Target, FinitePauliTXSource.Question>",
    "Paired<FiniteTGate, QuantumMeasureXQuestion>");
  const reached=new Set();const leaves=new Map();
  for(let i=0;i<16;i++){
    let node=program.plan.tree;const trace=[];const values=[];let depth=0;
    while(node.kind==="probe"){
      assert(++depth<=10,"No cyclic or unnecessarily repeated path is admitted");
      assert(declared.has(node.probe));
      const bit=probes.get(node.probe).replies[i];
      trace.push(`FinitePauliTXSource.Row${i}.${columns[node.probe]}`);values.push(`QBit${bit}`);
      assert(node.branches&&node.branches[String(bit)],"Missing actual-source branch");
      node=node.branches[String(bit)];
    }
    assert.equal(node.kind,"act");assert(program.continuations[node.action]);reached.add(node.action);
    const spelling=`Paired<${chain(values)}, ${answerTypes[node.action]}>`;
    if(!leaves.has(node)){
      const name=`DecisionLeaf${leaves.size}`;leaves.set(node,{name,spelling});
      claims+=`public typealias ${name} = ${spelling}\n`;
    }
    const {name:leaf,spelling:existing}=leaves.get(node);assert.equal(existing,spelling);
    const [a,b]=model.worlds[i];
    const word=`Paired<Q${a}, Paired<FiniteTGate, Q${b}>>`;
    claims+=equation(`ApplyRow${i}`,
      `Paired<FinitePauliTXSource.Row${i}.Word, Paired<${chain(trace)}, FinitePauliTXSource.Row${i}.Answer>>`,
      `Paired<${word}, ${leaf}>`);
  }
  assert.deepEqual(new Set(Object.keys(program.continuations)),reached,"No detached execution bodies");
  const source=ctx.source+"\n"+claims;
  const verdict=judgeWhereTexts(source);
  assert.equal(verdict.judged,17,"Caller and all sixteen rows must actually be checked");
  assert.deepEqual(verdict.refusals,[],"Proposal is not an application of the current source");
  return {source,verdict};
}

function applyFamily(ctx,model,proposal){
  // This proves an implication on the stated family. Membership of the real
  // source is deliberately NOT asserted by any type in this certificate.
  assert.equal(proposal.schema,"vi.current-family-proposal.v1");
  assert.deepEqual(proposal.request,{connector:["t"],consumer:"terminal",axis:"X"});
  const family=proposal.family;
  assert(Array.isArray(family)&&family.length>0,"An empty family cannot authorize a continuation");
  assert(family.every(i=>Number.isInteger(i)&&i>=0&&i<16));
  assert.deepEqual(family,[...new Set(family)].sort((a,b)=>a-b),"Distinct current source rows required");
  assert(actions[proposal.action]);assert.deepEqual(proposal.execution,actions[proposal.action]);
  let claims=`public typealias RetainedFamily = ${chain(family.map(i=>`FinitePauliTXSource.Row${i}`))}\n`;
  claims+=`public typealias SharedContinuation = ${answerTypes[proposal.action]}\n`;
  claims+=equation("FamilyQuestion","Paired<FinitePauliTXSource.Target, FinitePauliTXSource.Question>",
    "Paired<FiniteTGate, QuantumMeasureXQuestion>");
  for(let n=0;n<family.length;n++){
    const row=`RetainedFamily.${"Right.".repeat(n)}Left`;
    const [a,b]=model.worlds[family[n]];
    claims+=equation(`FamilyRow${n}`,`Paired<${row}.Word, ${row}.Answer>`,
      `Paired<Paired<Q${a}, Paired<FiniteTGate, Q${b}>>, SharedContinuation>`);
  }
  const source=ctx.source+"\n"+claims;const verdict=judgeWhereTexts(source);
  assert.equal(verdict.judged,1+family.length,"Every retained row must be checked");
  assert.deepEqual(verdict.refusals,[],"One continuation must serve the whole retained family");
  return {source,verdict};
}

if(require.main===module){
  const [mode,file,out]=process.argv.slice(2);const ctx=context();const model=sourceModel(ctx);
  if(mode==="read")process.stdout.write(JSON.stringify({model,source_sha256:ctx.fingerprints}));
  else if(mode==="check"||mode==="family"){
    assert(file&&out,"check program.json certificates.swift");
    const program=JSON.parse(fs.readFileSync(file,"utf8"));
    const checked=mode==="check"?applyPlan(ctx,model,program):applyFamily(ctx,model,program);
    fs.writeFileSync(out,checked.source);
    process.stdout.write(JSON.stringify({verdict:checked.verdict,source_sha256:ctx.fingerprints,
      certificate_sha256:digest(checked.source),scope:"Exact conditional T/X row applications only; real-source membership is not certified here"}));
  }else throw Error("read | check program.json certificates.swift | family proposal.json certificates.swift");
}
module.exports={context,sourceModel,applyPlan,applyFamily,reading,equation,chain,digest,answerTypes,actions};
