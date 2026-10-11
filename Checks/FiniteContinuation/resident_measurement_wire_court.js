"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),contact=require('./contact_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
const frames=['CoherentI','CoherentZ','CoherentX','CoherentXZ'];
function term(k,x,z){return `${frames[2*x+z]}<CoherentPhase${k}>`;}
function context(){const c=contact.context(),n='Sources/Examples/ResidentMeasurementWire.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function bit(c,t){return Number(base.reading(c,t,['QBit0','QBit1']).slice(-1));}
function frame(c,t){return {phase:Number(base.reading(c,t+'.Phase',[0,1,2,3].map(k=>'CoherentPhase'+k)).slice(-1)),x:bit(c,t+'.Word.Left'),z:bit(c,t+'.Word.Right')};}
function read(c){
 const rows=[];
 for(let k=0;k<4;k++)for(let x=0;x<2;x++)for(let z=0;z<2;z++){
  const t=term(k,x,z);rows.push({before:frame(c,t),negate:bit(c,`ResidentWireReply0<${t}>.NegateMeasurementAngle`),
   next:[0,1].map(b=>frame(c,`ResidentWireReply${b}<${t}>.After`))});
 }
 const r='ResidentMeasurementWireRoot';
 return {schema:'vi.resident-measurement-wire.v1',source_sha256:c.fingerprints,rows,
  initial:frame(c,r+'.InitialFrame'),initial_owner:bit(c,r+'.Input.Index'),
  next_owner:[0,1].map(b=>bit(c,`ResidentWireCarrier${b}.After.Index`)),
  corrections:['Left','Right'].map(s=>base.reading(c,r+'.CorrectionsInTimeOrder.'+s,['QX','QZ'])),
  scope:'Exact frame propagation for actual measurement branches; physical one-bit teleportation and requested J(alpha) interpretation are separately established.'};
}
function build(directory){
 const c=context(),reading=read(c);let claims='',count=0;const eq=(a,b)=>claims+=base.equation('MeasurementWire'+count++,a,b);
 for(let k=0;k<4;k++)for(let x=0;x<2;x++)for(let z=0;z<2;z++){
  const t=term(k,x,z);
  for(let b=0;b<2;b++){
   eq(`ResidentWireReply${b}<${t}>.NegateMeasurementAngle`,`${t}.Word.Left`);
   eq(`ResidentWireReply${b}<${t}>.After.Word.Left`,`QBit${b^z}`);
   eq(`ResidentWireReply${b}<${t}>.After.Word.Right`,`QBit${x}`);
  }
 }
 for(let b=0;b<2;b++)eq(`ResidentWireCarrier${b}.After.After.Index`,`ResidentWireCarrier${b}.Index`);
 eq('ResidentMeasurementWireRoot.InitialFrame.Word','CoherentIdentityWord');
 const proof=c.source+'\n'+claims,result=judgeWhereTexts(proof);assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 const bad=[['the angle depends on incoming X, not incoming Z','ResidentWireReply0<CoherentX<CoherentPhase0>>.NegateMeasurementAngle','QBit0'],
 ['fresh reply alone is not the accumulated frame','ResidentWireReply0<CoherentZ<CoherentPhase0>>.After.Word.Left','QBit0'],
 ['old physical carrier is not the output carrier','ResidentWireCarrier0.After.Index','ResidentWireCarrier0.Index']];
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentMeasurementWire.swift'),proof);
 const negatives=bad.map(([name,a,b],i)=>{const text=c.source+'\n'+base.equation('RejectedMeasurementWire',a,b),r=judgeWhereTexts(text);assert.equal(r.judged,1);assert(r.refusals.length);const file=`RejectedMeasurementWire-${i}.swift`;fs.writeFileSync(path.join(directory,file),text);return{name,file};});
 fs.writeFileSync(path.join(directory,'wire-reading.json'),JSON.stringify(reading,null,2)+'\n');
 return{equalities:count,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(proof)};
}
if(require.main===module){const[mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
