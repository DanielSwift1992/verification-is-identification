"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),raw=require('./resident_raw_reply_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
const fields=['Relative','First','Last'];
const goals={continue:'ResidentContinueQuestion',first:'ResidentFirstQuestion',agreement:'ResidentAgreementQuestion'};
function context(){const c=raw.context(),n='Sources/Examples/ResidentGoalMemory.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function term(r,f,l){return `ResidentHistoryLast${l}<QBit${r},QBit${f}>`;}
function bit(c,t){return Number(base.reading(c,t,['QBit0','QBit1']).slice(-1));}
function read(c){
 const terms=[];for(let r=0;r<2;r++)for(let f=0;f<2;f++)for(let l=0;l<2;l++)terms.push(term(r,f,l));
 const states=terms.map(t=>fields.map(x=>bit(c,t+'.'+x)).join(''));
 const operations={};for(let b=0;b<2;b++)operations['reply'+b]=terms.map(t=>states.indexOf(fields.map(x=>bit(c,t+`.Reply${b}.`+x)).join('')));
 const observation={};for(const [name,type] of Object.entries(goals))observation[name]=terms.map(t=>['Left','Right'].map(s=>bit(c,`${type}<${t}>.${s}`)));
 const initial=[0,1].map(b=>states.indexOf(fields.map(f=>bit(c,`ResidentGoalMemoryRoot.Acquired${b}.${f}`)).join('')));
 return {schema:'vi.resident-goal-memory.v1',source_sha256:c.fingerprints,states,operations,observation,initial,
  recipient:['Left','Right'].map(s=>base.reading(c,'ResidentGoalMemoryRoot.Recipient.'+s,['QI','QZ'])),
  raw:raw.read(raw.context()),scope:'All eight finite monitor states; replies are incoming actual events, not freely forced measurement outcomes. DEM remains quantum.'};
}
function build(directory){
 const c=context(),reading=read(c);let claims='',count=0;const eq=(a,b)=>claims+=base.equation('GoalMemory'+count++,a,b);
 for(let r=0;r<2;r++)for(let f=0;f<2;f++)for(let l=0;l<2;l++){
  const t=term(r,f,l);
  for(let b=0;b<2;b++){
   eq(t+`.Reply${b}.Relative`,`ResidentRawReplyRoot.Interpreter.At${r^b}.Right.Right`);
   eq(t+`.Reply${b}.First`,t+'.First');eq(t+`.Reply${b}.Last`,`QBit${b}`);
  }
  eq(`ResidentFirstQuestion<${t}>.Right`,t+'.First');
  eq(`ResidentAgreementQuestion<${t}>.Right`,`QBit${f^l}`);
 }
 for(let b=0;b<2;b++)for(const f of ['First','Last'])eq(`ResidentGoalMemoryRoot.Acquired${b}.${f}`,`ResidentRawReplyRoot.Acquired${b}`);
 const proof=c.source+'\n'+claims,result=judgeWhereTexts(proof);assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 const bad=[['comparison substituted by first reply',`ResidentAgreementQuestion<${term(0,0,1)}>.Right`,`ResidentFirstQuestion<${term(0,0,1)}>.Right`],
 ['new reply overwrites first reply',term(0,0,1)+'.Reply1.First','QBit1'],
 ['relative update misses source tick',term(0,0,0)+'.Reply0.Relative','QBit0']];
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentGoalMemory.swift'),proof);
 const negatives=bad.map(([name,a,b],i)=>{const text=c.source+'\n'+base.equation('RejectedGoalMemory',a,b),v=judgeWhereTexts(text);assert.equal(v.judged,1);assert(v.refusals.length);const file=`RejectedGoalMemory-${i}.swift`;fs.writeFileSync(path.join(directory,file),text);return {name,file};});
 fs.writeFileSync(path.join(directory,'goal-reading.json'),JSON.stringify(reading,null,2)+'\n');
 return {equalities:count,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(proof)};
}
if(require.main===module){const [mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
