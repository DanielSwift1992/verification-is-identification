"use strict";
const fs=require("node:fs"),path=require("node:path"),os=require("node:os");
const assert=require("node:assert/strict"),{spawnSync}=require("node:child_process");
const {context,sourceModel,applyPlan}=require("./court_bridge.js");
const root=path.resolve(__dirname,"../..");
const {judgeWhereTexts}=require(path.resolve(process.env.VI_WHERE_JUDGE||path.join(root,"../gate/bin/judge-where.js")));
const original=JSON.parse(fs.readFileSync(process.argv[2],"utf8"));
const ctx=context(),model=sourceModel(ctx),good=applyPlan(ctx,model,original);
assert.equal(good.verdict.judged,17);
const refused=[];
function reject(name,mutate){
  const p=structuredClone(original);mutate(p);assert.throws(()=>applyPlan(ctx,model,p));refused.push(name);
}
reject("different caller question",p=>p.request.axis="Z");
reject("incomplete caller family",p=>p.plan.initial.pop());
reject("physical reading changed behind the same action name",p=>Object.values(p.continuations)[0].sign*=-1);
reject("contact fields changed behind the same probe name",p=>p.contacts[0].prep="X");
reject("missing acquired-source branch",p=>delete p.plan.tree.branches["0"]);

const changed=good.source.replace(/(public typealias DecisionLeaf0 = [^\n]*QBit)([01])(>+)\n/,
  (_,head,bit,tail)=>head+(bit==="0"?"1":"0")+tail+"\n");
assert.notEqual(changed,good.source,"Mutation must alter an actual leaf answer");
const bad=judgeWhereTexts(changed);assert.equal(bad.judged,17);assert.equal(bad.refusals.length,4);
refused.push("wrong leaf answer refused in all four actual source rows");

const changedSource={...ctx,source:ctx.source.replace(
  "public typealias Answer = Paired<QuantumMeasureXQuestion, B.ForX>",
  "public typealias Answer = Paired<QuantumMeasureXQuestion, B.ForX.Flipped>")};
assert.notEqual(changedSource.source,ctx.source);
const newModel=sourceModel(changedSource);
assert.throws(()=>applyPlan(changedSource,newModel,original));
refused.push("old decoder is not applicable after current source answer changes");
const missingSource={...ctx,source:ctx.source.replace("public typealias Row0 = FiniteTAI<QI>","public typealias Row0 = FiniteTAI<QX>")};
assert.throws(()=>sourceModel(missingSource));refused.push("duplicated row cannot replace the complete caller domain");

const tmp=fs.mkdtempSync(path.join(os.tmpdir(),"vi-court-applications-"));
try{
  for(const [name,source,status] of [["good",good.source,0],["wrong-answer",changed,1]]){
    const file=path.join(tmp,name+".swift");fs.writeFileSync(file,source);
    const r=spawnSync(path.join(root,".build/arm64-apple-macosx/debug/Tools"),["judge","where",file],
      {encoding:"utf8",timeout:30000});
    if(r.error)throw r.error;assert.equal(r.status,status,r.stdout+r.stderr);
    if(status===0)assert(r.stdout.includes("17 equalities"));
    else assert.equal(r.stdout.split("\n").filter(line=>line.startsWith("✗ ")).length,4);
  }
}finally{fs.rmSync(tmp,{recursive:true,force:true});}
console.log(JSON.stringify({current_source_equalities:17,refused,
  native_and_js_agree:true,swift_modeled_program_execution:false},null,2));
