// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),goal=require('./resident_goal_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'Checks/Archive/WhereV2/judge-where.js'));
function context(){const c=goal.context(),n='Sources/Examples/ResidentGoalAcquisition.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function bit(c,t){return Number(base.reading(c,t,['QBit0','QBit1']).slice(-1));}
function read(c){
 const g=goal.read(goal.context()),after_first={};
 for(let b=0;b<2;b++){
  const rows=[];
  for(let r=0;r<2;r++)for(let f=0;f<2;f++){
   const t=`ResidentFirstAfter${b}<QBit${r},QBit${f}>.After`;
   rows.push(g.states.indexOf(['Relative','First','Last'].map(x=>bit(c,t+'.'+x)).join('')));
  }
  after_first['reply'+b]=rows;
 }
 return {schema:'vi.resident-goal-acquisition.v1',source_sha256:c.fingerprints,goal:g,after_first,
  scope:'The next actual contact reconstructs a post-contact class from the old First reading. No old Last field is acquired.'};
}
function build(directory){
 const c=context(),reading=read(c);let claims='',count=0;const eq=(a,b)=>claims+=base.equation('GoalAcquisition'+count++,a,b);
 for(let r=0;r<2;r++)for(let f=0;f<2;f++)for(let l=0;l<2;l++){
  const t=`ResidentHistoryLast${l}<QBit${r},QBit${f}>`;
  for(let b=0;b<2;b++)for(const field of ['Relative','First','Last'])
   eq(`ResidentFirstAfter${b}<ResidentFirstQuestion<${t}>.Left,ResidentFirstQuestion<${t}>.Right>.After.${field}`,`${t}.Reply${b}.${field}`);
 }
 eq('ResidentGoalAcquisitionRoot.Contact','ResidentRawReplyRoot.Contact');
 eq('ResidentGoalAcquisitionRoot.RetainedMemory','ResidentRawReplyRoot.ContinuedMemory');
 eq('ResidentGoalAcquisitionRoot.NextContact.Right','ResidentRawReplyRoot.ContinuedMemory');
 const proof=c.source+'\n'+claims,result=judgeWhereTexts(proof);assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 const bad=[['new occurrence is not the old last reply','ResidentFirstAfter0<QBit0,QBit0>.After.Last','ResidentHistoryLast1<QBit0,QBit0>.Last'],
 ['new reply does not replace the old first','ResidentFirstAfter1<QBit0,QBit0>.After.First','QBit1'],
 ['next relative bit includes the source tick','ResidentFirstAfter0<QBit0,QBit0>.After.Relative','QBit0']];
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentGoalAcquisition.swift'),proof);
 const negatives=bad.map(([name,a,b],i)=>{const text=c.source+'\n'+base.equation('RejectedGoalAcquisition',a,b),v=judgeWhereTexts(text);assert.equal(v.judged,1);assert(v.refusals.length);const file=`RejectedGoalAcquisition-${i}.swift`;fs.writeFileSync(path.join(directory,file),text);return{name,file};});
 fs.writeFileSync(path.join(directory,'acquisition-reading.json'),JSON.stringify(reading,null,2)+'\n');
 return{equalities:count,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(proof)};
}
if(require.main===module){const[mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
