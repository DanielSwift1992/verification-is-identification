"use strict";
// Bounded application of the existing reader, no parser or judge extension.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const resident=require('./resident_program_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(process.env.VI_WHERE_JUDGE||path.join(root,'../gate/bin/judge-where.js')));
const actions=['Toggle0','Toggle1','Write0','Write1','Install0','Install1','Restart'];
function context(){
 const c=resident.context(),name='Sources/Examples/ResidentAcquisition.swift';
 const s=fs.readFileSync(path.join(root,name),'utf8');c.source+='\n'+s;c.fingerprints[name]=base.digest(s);return c;
}
function read(c){
 const r='ResidentAcquisitionRoot',bits=['QBit0','QBit1'];
 base.reading(c,r+'.Interpreter',['ResidentInterpreterRoot']);
 const probes=Object.fromEntries(['X','Z'].map(axis=>[axis,{
  observable:base.reading(c,r+'.Probe'+axis+'.Left',['QX','QZ']).slice(1),
  records:['Left','Right'].map(side=>Number(base.reading(c,r+'.Probe'+axis+'.Right.'+side,bits).slice(-1)))
 }]));
 const rows=[];
 for(let p=0;p<2;p++)for(let t=0;t<2;t++){
  const at=r+`.Row${p}${t}`;
  const pair=field=>['Left','Right'].map(side=>Number(base.reading(c,at+'.'+field+'.'+side,bits).slice(-1)));
  rows.push({input:pair('Input'),actions:Object.fromEntries(actions.map(n=>[n,pair(n)]))});
 }
 return {schema:'vi.resident-acquisition.v1',source_sha256:c.fingerprints,
  interpreter:resident.read(resident.context()),probes,rows,
  scope:'Selective data-Pauli instrument followed by a current-root control map. Branch probabilities are not established by the equality court.'};
}
function build(directory){
 const c=context(),data=read(c);let claims='',n=0;
 const eq=(l,r)=>claims+=base.equation('Acquisition'+n++,l,r);
 const r='ResidentAcquisitionRoot';
 for(const row of data.rows){
  const [p,t]=row.input,at=r+`.Row${p}${t}`;
  eq(at+'.Toggle0',at+'.Input');
  eq(at+'.Toggle1.Left',at+'.Input.Left.Flipped');eq(at+'.Toggle1.Right',at+'.Input.Right');
  for(const name of ['Write','Install'])for(let b=0;b<2;b++){
   // The very record address that names this branch supplies the new bit.
   eq(at+`.${name}${b}.Left`,r+'.ProbeZ.Right.'+(b?'Right':'Left'));
   eq(at+`.${name}${b}.Right`,name==='Write'?at+'.Input.Right':'QBit0');
  }
  eq(at+'.Restart.Left',at+'.Input.Left');eq(at+'.Restart.Right','QBit0');
 }
 for(const axis of ['X','Z']){
  eq(r+'.Probe'+axis+'.Left','Q'+axis);
  eq(r+'.Probe'+axis+'.Right','Paired<QBit0, QBit1>');
 }
 const proof=c.source+'\n'+claims,v=judgeWhereTexts(proof);assert.equal(v.judged,n);assert.deepEqual(v.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentAcquisition.swift'),proof);
 fs.writeFileSync(path.join(directory,'acquisition-reading.json'),JSON.stringify(data,null,2)+'\n');
 const rejected=[['wrong acquired branch',r+'.Row00.Install1.Left',r+'.ProbeZ.Right.Left'],
  ['clock reset claimed to preserve unknown clock',r+'.Row01.Restart.Right',r+'.Row01.Input.Right'],
  ['absolute write claimed to preserve clock-independent parity',r+'.Row00.Write0',r+'.Row11.Write0']];
 const negatives=rejected.map(([name,l,h],i)=>{
  const text=c.source+'\n'+base.equation('RejectedAcquisition',l,h),v=judgeWhereTexts(text);
  assert.equal(v.judged,1);assert(v.refusals.length);const file=`RejectedAcquisition-${i}.swift`;
  fs.writeFileSync(path.join(directory,file),text);return {name,file};
 });
 return {equalities:n,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(proof)};
}
if(require.main===module){const [mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
