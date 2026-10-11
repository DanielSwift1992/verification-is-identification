"use strict";
// Read the actual Swift source; application equations bind a particular
// requested truth table to each terminal fiber and each actual Reply image.
const fs=require('node:fs'), path=require('node:path'), assert=require('node:assert/strict');
const base=require('./court_bridge.js'), goal=require('./resident_goal_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
function context(){
 const c=goal.context(), n='Sources/Examples/ResidentGoalSynthesis.swift', text=fs.readFileSync(path.join(root,n),'utf8');
 c.source+='\n'+text; c.fingerprints[n]=base.digest(text); return c;
}
function read(c){
 const g=goal.read(goal.context());
 for(const s of g.states)for(const [i,f]of ['Relative','First','Last'].entries())
  assert.equal(base.reading(c,`ResidentGoalSynthesisRoot.State${s}.${f}`,['QBit0','QBit1']),`QBit${s[i]}`);
 for(const side of ['Left','Right'])
  assert.equal(base.reading(c,`ResidentGoalSynthesisRoot.Source.Recipient.${side}`,['QI','QZ']),base.reading(c,`ResidentGoalMemoryRoot.Recipient.${side}`,['QI','QZ']));
 return {schema:'vi.resident-goal-synthesis.v1',source_sha256:c.fingerprints,goal:g,
  states:g.states.map(s=>`ResidentGoalSynthesisRoot.State${s}`),
  scope:'Question rows are given; applicability is checked on current-source entry/current correspondences.'};
}
function build(directory){
 const c=context(),src=read(c),certs=JSON.parse(fs.readFileSync(path.join(directory,'selected-certificates.json'),'utf8'));
 let body='',claims='',count=0; const eq=(a,b)=>claims+=base.equation('GoalSynthesis'+count++,a,b);
 for(let k=0;k<certs.length;k++){
  const cert=certs[k], table=`RequestedAnswer${k}`;
  assert.equal(cert.query.values.length,8); assert(['entry','exit'].includes(cert.query.occurrence));
  body+=`\npublic typealias ${table} = ResidentAnswers8<${cert.query.values.map(x=>{assert(x===0||x===1);return 'QBit'+x;}).join(', ')}>\n`;
  for(const node of cert.nodes){
   for(const [entry,current]of node.pairs){
    const state=src.goal.states[current];
    eq(`ResidentGoalSynthesisRoot.State${state}.Relative`,`QBit${node.relative}`);
    if(node.answer!==null){
     const at=cert.query.occurrence==='entry'?entry:current;
     eq(`${table}.State${src.goal.states[at]}`,`QBit${node.answer}`);
    }
    for(let b=0;b<2;b++){
     const post=src.goal.operations['reply'+b][current];
     assert(cert.nodes[node.next[b]].pairs.some(([a,s])=>a===entry&&s===post));
     for(const field of ['Relative','First','Last'])eq(`ResidentGoalSynthesisRoot.State${state}.Reply${b}.${field}`,`ResidentGoalSynthesisRoot.State${src.goal.states[post]}.${field}`);
    }
   }
  }
 }
 const text=c.source+body+claims, result=judgeWhereTexts(text);
 assert.equal(result.judged,count); assert.deepEqual(result.refusals,[]);
 fs.writeFileSync(path.join(directory,'ResidentGoalSynthesis.swift'),text);
 const negatives=[
  ['entry is not the next occurrence','ResidentGoalSynthesisRoot.State001.Last','ResidentGoalSynthesisRoot.State001.Reply0.Last'],
  ['discarded first is not determined by relative','ResidentGoalSynthesisRoot.State000.First','ResidentGoalSynthesisRoot.State010.First'],
  ['contact must include its actual tick','ResidentGoalSynthesisRoot.State000.Reply0.Relative','ResidentGoalSynthesisRoot.State000.Relative']
 ].map(([name,a,b],i)=>{
  const file=`RejectedGoalSynthesis-${i}.swift`,bad=c.source+base.equation('RejectedGoalSynthesis',a,b),answer=judgeWhereTexts(bad);
  assert.equal(answer.judged,1); assert(answer.refusals.length); fs.writeFileSync(path.join(directory,file),bad); return {name,file};
 });
 const out={equalities:count,negatives,source_sha256:src.source_sha256,proof_sha256:base.digest(text)};
 fs.writeFileSync(path.join(directory,'build.json'),JSON.stringify(out,null,2)+'\n'); return out;
}
if(require.main===module){const [mode,directory]=process.argv.slice(2); console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
