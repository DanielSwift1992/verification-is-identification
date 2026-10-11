"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const service=require('./resident_classical_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(process.env.VI_WHERE_JUDGE||path.join(root,'../gate/bin/judge-where.js')));
function context(){
 const c=service.context(),name='Sources/Examples/ResidentRawReply.swift',s=fs.readFileSync(path.join(root,name),'utf8');
 c.source+='\n'+s;c.fingerprints[name]=base.digest(s);return c;
}
function read(c){
 const r='ResidentRawReplyRoot',ports=['ResidentDataPort','ResidentServicePort','ResidentHiddenMemoryPort'];
 base.reading(c,r+'.Control',['ResidentAcquisitionRoot']);base.reading(c,r+'.Interpreter',['ResidentClassicalRoot']);
 return {schema:'vi.resident-raw-reply.v1',source_sha256:c.fingerprints,
  reply:['Left','Right'].map(s=>Number(base.reading(c,r+'.Reply.'+s,['QBit0','QBit1']).slice(-1))),
  working:base.reading(c,r+'.WorkingData',ports),
  contact:['Left','Right'].map(s=>base.reading(c,r+'.Contact.'+s,ports)),
  next_contact:['Left','Right'].map(s=>base.reading(c,r+'.NextContact.'+s,ports)),
  known:[0,1].map(b=>Number(base.reading(c,r+'.Acquired'+b,['QBit0','QBit1']).slice(-1))),
  interpreter:service.read(service.context()),scope:'Actual binary response on E and retained M; no measurement-accuracy or Pauli semantics. Unknown local instruments may depend on retained memory.'};
}
function build(directory){
 const c=context(),data=read(c);let claims='',n=0;const eq=(l,r)=>claims+=base.equation('RawReply'+n++,l,r),r='ResidentRawReplyRoot';
 eq(r+'.WorkingData',r+'.Carrier.Left');eq(r+'.NextContact',r+'.Contact');eq(r+'.NextContact.Right',r+'.ContinuedMemory');
 for(let b=0;b<2;b++){
  eq(r+'.Acquired'+b,r+'.Reply.'+(b?'Right':'Left'));
  for(let p=0;p<2;p++)for(let q=0;q<2;q++)eq(r+`.Control.Row${p}${q}.Install${b}.Left`,r+'.Reply.'+(b?'Right':'Left'));
 }
 const proof=c.source+'\n'+claims,v=judgeWhereTexts(proof);assert.equal(v.judged,n);assert.deepEqual(v.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentRawReply.swift'),proof);
 fs.writeFileSync(path.join(directory,'raw-reply-reading.json'),JSON.stringify(data,null,2)+'\n');
 const bad=[['data included in local detector scope',r+'.Contact.Left',r+'.WorkingData'],
  ['retained memory replaced by data port',r+'.NextContact.Right',r+'.WorkingData'],
  ['other record installs the program',r+'.Acquired0',r+'.Reply.Right']];
 const negatives=bad.map(([name,l,h],i)=>{const s=c.source+'\n'+base.equation('RejectedRawReply',l,h),v=judgeWhereTexts(s);assert.equal(v.judged,1);assert(v.refusals.length);
  const file=`RejectedRawReply-${i}.swift`;fs.writeFileSync(path.join(directory,file),s);return {name,file};});
 return {equalities:n,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(proof)};
}
if(require.main===module){const [mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
