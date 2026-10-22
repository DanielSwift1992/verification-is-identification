// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const acq=require('./resident_acquisition_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(path.join(root,'Checks/Archive/WhereV2/judge-where.js')));
function context(){
 const c=acq.context(),name='Sources/Examples/ResidentClassicalControl.swift',s=fs.readFileSync(path.join(root,name),'utf8');
 c.source+='\n'+s;c.fingerprints[name]=base.digest(s);return c;
}
function read(c){
 const r='ResidentClassicalRoot',ports=['ResidentDataPort','ResidentServicePort'];
 const quantum_ports=['Left','Right'].map(side=>base.reading(c,r+'.QuantumPorts.'+side,ports));
 const probes=Object.fromEntries(['X','Z'].map(axis=>[axis,{
  port:base.reading(c,r+'.Probe'+axis+'.Left',ports),
  question:base.reading(c,r+'.Probe'+axis+'.Right',['ResidentAcquisitionRoot.ProbeX','ResidentAcquisitionRoot.ProbeZ'])
 }]));
 base.reading(c,r+'.Control',['ResidentAcquisitionRoot']);
 const controls=[0,1].map(bit=>({bit:Number(base.reading(c,r+'.Known'+bit,['QBit0','QBit1']).slice(-1)),
  gate:base.reading(c,r+'.At'+bit+'.Instruction',['JointHLabel','JointSLabel']),
  next:Number(base.reading(c,r+'.At'+bit+'.Right.Right',['QBit0','QBit1']).slice(-1))}));
 return {schema:'vi.resident-service-classical.v1',source_sha256:c.fingerprints,quantum_ports,
  payload:base.reading(c,r+'.Payload',ports),probes,controls,
  memory_action:base.reading(c,r+'.MemoryAction',['QZ']),reopen:base.reading(c,r+'.Reopen',['JointCZLabel']),
  acquisition:acq.read(acq.context()),scope:'Measured service E; retained quantum D,E and a classically acquired relative control. No unacquired initial bit.'};
}
function build(directory){
 const c=context(),data=read(c);let claims='',n=0;const eq=(a,b)=>claims+=base.equation('Classical'+n++,a,b);
 const r='ResidentClassicalRoot';
 eq(r+'.Payload',r+'.QuantumPorts.Left');eq(r+'.AcquiredAt',r+'.QuantumPorts.Right');
 for(const axis of ['X','Z']){
  eq(r+'.Probe'+axis+'.Left',r+'.AcquiredAt');eq(r+'.Probe'+axis+'.Right','ResidentAcquisitionRoot.Probe'+axis);
 }
 for(let b=0;b<2;b++){
  const record=r+'.ProbeZ.Right.Right.'+(b?'Right':'Left');
  eq(r+'.Known'+b,record);
  for(let p=0;p<2;p++)for(let c=0;c<2;c++){
   eq(r+`.Control.Row${p}${c}.Install${b}.Left`,record);
   eq(r+`.Control.Row${p}${c}.Install${b}.Right`,'QBit0');
  }
  eq(r+`.At${b}.Right.Right`,r+`.At${b}.Left.Right.Flipped`);
  eq(r+`.At${b}.Instruction`,`ResidentInterpreterRoot.Row1${1-b}.Instruction`);
 }
 eq(r+'.MemoryAction','QZ');eq(r+'.Reopen','JointCZLabel');
 const proof=c.source+'\n'+claims,v=judgeWhereTexts(proof);assert.equal(v.judged,n);assert.deepEqual(v.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentClassical.swift'),proof);
 fs.writeFileSync(path.join(directory,'classical-reading.json'),JSON.stringify(data,null,2)+'\n');
 const negative=[['wrong measured port',r+'.ProbeX.Left',r+'.Payload'],
  ['wrong source record seeds control',r+'.Known1',r+'.ProbeZ.Right.Right.Left'],
  ['lost control update',r+'.At0.Right.Right',r+'.At0.Left.Right']];
 const negatives=negative.map(([name,l,h],i)=>{
  const s=c.source+'\n'+base.equation('RejectedClassical',l,h),v=judgeWhereTexts(s);assert.equal(v.judged,1);assert(v.refusals.length);
  const file=`RejectedClassical-${i}.swift`;fs.writeFileSync(path.join(directory,file),s);return {name,file};
 });
 return {equalities:n,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(proof)};
}
if(require.main===module){const [mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
