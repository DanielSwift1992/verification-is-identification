"use strict";
// Apply each tuple to ONE current-source index. No new Correct/Trusted marker.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const single=require('./resident_goal_synthesis_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
const chain=xs=>xs.reduceRight((tail,x)=>`Paired<${x}, ${tail}>`,'Never');

function build(directory){
 const c=single.context(),source=single.read(c);
 const certificates=JSON.parse(fs.readFileSync(path.join(directory,'certificates.json'),'utf8'));
 let declarations='',claims='',count=0;
 const eq=(left,right)=>claims+=base.equation('CommonEndpoint'+count++,left,right);
 certificates.forEach((cert,k)=>{
  const questions=cert.query.questions.map((values,i)=>{
   assert.equal(values.length,8);assert(values.every(x=>x===0||x===1));
   const name=`Bundle${k}Question${i}`;
   declarations+=`\npublic typealias ${name} = ResidentAnswers8<${values.map(x=>'QBit'+x).join(', ')}>\n`;
   return name;
  });
  assert.equal(questions.length,2); // This application suite is the two-question fragment.
  const actions=cert.query.recipient.map(bit=>`ResidentGoalSynthesisRoot.Source.Recipient.${bit?'Right':'Left'}`);
  assert.equal(actions.length,4);
  declarations+=`public typealias Bundle${k}Recipient = Paired<Paired<${actions[0]}, ${actions[1]}>, Paired<${actions[2]}, ${actions[3]}>>\n`;
  for(const node of cert.nodes)for(const [entry,current]of node.pairs){
   const state=source.goal.states[current];
   eq(`ResidentGoalSynthesisRoot.State${state}.Relative`,`QBit${node.relative}`);
   for(let b=0;b<2;b++){
    const next=source.goal.operations['reply'+b][current];
    assert(cert.nodes[node.next[b]].pairs.some(p=>p[0]===entry&&p[1]===next));
    for(const field of ['Relative','First','Last'])
     eq(`ResidentGoalSynthesisRoot.State${state}.Reply${b}.${field}`,`ResidentGoalSynthesisRoot.State${source.goal.states[next]}.${field}`);
   }
   if(node.answers!==null){
    const index=cert.query.occurrence==='entry'?entry:current;
    // Both projections name exactly the SAME indexed occurrence here.
    eq(chain(questions.map(q=>`${q}.State${source.goal.states[index]}`)),chain(node.answers.map(x=>'QBit'+x)));
    const [a,b]=node.answers;
    eq(`Bundle${k}Recipient.${b?'Right':'Left'}.${a?'Right':'Left'}`,node.recipient?'QZ':'QI');
   }
  }
 });
 const text=c.source+declarations+claims,answer=judgeWhereTexts(text);
 assert.equal(answer.judged,count);assert.deepEqual(answer.refusals,[]);
 fs.writeFileSync(path.join(directory,'ResidentCommonEndpoint.swift'),text);
 const negatives=[
  ['the previous true answer need not stay true','Bundle0Question1.State000','Bundle0Question1.State100'],
  ['answers at different occurrences cannot be returned as a current pair',
   chain(['Bundle0Question0.State100','Bundle0Question1.State100']),chain(['QBit1','QBit1'])],
  ['one unmeasured first bit still changes the common tuple',
   chain(['Bundle0Question0.State000','Bundle0Question1.State000']),
   chain(['Bundle0Question0.State010','Bundle0Question1.State010'])],
  ['a correct tuple does not authorize a different recipient','Bundle0Recipient.Left.Right','QZ']
 ].map(([name,left,right],i)=>{
  const file=`RejectedCommonEndpoint-${i}.swift`,bad=c.source+declarations+base.equation('RejectedCommonEndpoint',left,right);
  const result=judgeWhereTexts(bad);assert.equal(result.judged,1);assert(result.refusals.length);
  fs.writeFileSync(path.join(directory,file),bad);return {name,file};
 });
 const result={equalities:count,negatives,source_sha256:source.source_sha256,proof_sha256:base.digest(text),
  scope:'Current-source tuple projections and receiver applications; the finite common-rank theorem is checked separately.'};
 fs.writeFileSync(path.join(directory,'court.json'),JSON.stringify(result,null,2)+'\n');
 return result;
}
if(require.main===module)console.log(JSON.stringify(build(process.argv[2])));
module.exports={build};
