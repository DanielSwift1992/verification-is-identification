"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),acquisition=require('./resident_goal_acquisition_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
function context(){const c=acquisition.context(),n='Sources/Examples/ResidentCompletion.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function bit(c,t){return Number(base.reading(c,t,['QBit0','QBit1']).slice(-1));}
function term(r,f,l){return `ResidentHistoryLast${l}<QBit${r},QBit${f}>`;}
function read(c){
 const a=acquisition.read(acquisition.context()),flags=[],after={};
 for(let r=0;r<2;r++)for(let f=0;f<2;f++)for(let l=0;l<2;l++)flags.push(bit(c,`ResidentCompletionFlag<${term(r,f,l)}>`));
 for(let b=0;b<2;b++){after['reply'+b]=[];for(let r=0;r<2;r++)for(let f=0;f<2;f++)after['reply'+b].push(bit(c,`ResidentCompletionAfter${b}<QBit${r},QBit${f}>.Flag`));}
 return{schema:'vi.resident-completion.v1',source_sha256:c.fingerprints,acquisition:a,
  target:bit(c,'ResidentCompletionRoot.Target'),flags,after,
  initial_flags:[0,1].map(b=>bit(c,`ResidentCompletionFlag<ResidentCompletionRoot.Acquired${b}>`)),
  scope:'First actual acquired comparison reaching Target; no guarantee that the service will produce it.'};
}
function build(directory){
 const c=context(),reading=read(c);let claims='',count=0;const eq=(a,b)=>claims+=base.equation('ResidentCompletion'+count++,a,b);
 for(let r=0;r<2;r++)for(let f=0;f<2;f++)for(let l=0;l<2;l++)eq(`ResidentCompletionFlag<${term(r,f,l)}>`,`ResidentAgreementQuestion<${term(r,f,l)}>.Right`);
 for(let r=0;r<2;r++)for(let f=0;f<2;f++)for(let b=0;b<2;b++)eq(`ResidentCompletionAfter${b}<QBit${r},QBit${f}>.Flag`,`ResidentFirstAfter${b}<QBit${r},QBit${f}>.After.Different`);
 for(let b=0;b<2;b++)eq(`ResidentCompletionFlag<ResidentCompletionRoot.Acquired${b}>`,'QBit0');
 eq('ResidentCompletionRoot.Target','QBit1');
 eq('ResidentCompletionRoot.Contact','ResidentRawReplyRoot.Contact');
 eq('ResidentCompletionRoot.RetainedMemory','ResidentRawReplyRoot.ContinuedMemory');
 const proof=c.source+'\n'+claims,result=judgeWhereTexts(proof);assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 const bad=[['initial acquisition is not completion','ResidentCompletionFlag<ResidentCompletionRoot.Acquired0>','ResidentCompletionRoot.Target'],
 ['same first and new reply is not different','ResidentCompletionAfter0<QBit1,QBit0>.Flag','QBit1'],
 ['target cannot be replaced by its opposite','ResidentCompletionRoot.Target','QBit0']];
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentCompletion.swift'),proof);
 const negatives=bad.map(([name,a,b],i)=>{const text=c.source+'\n'+base.equation('RejectedCompletion',a,b),v=judgeWhereTexts(text);assert.equal(v.judged,1);assert(v.refusals.length);const file=`RejectedCompletion-${i}.swift`;fs.writeFileSync(path.join(directory,file),text);return{name,file};});
 fs.writeFileSync(path.join(directory,'completion-reading.json'),JSON.stringify(reading,null,2)+'\n');
 return{equalities:count,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(proof)};
}
if(require.main===module){const[mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
