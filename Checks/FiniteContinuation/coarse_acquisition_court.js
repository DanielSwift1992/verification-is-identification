"use strict";
// Existing bounded equality court, used on current source constructions.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
function context(){
 const c=base.context(),name='Sources/Examples/CoarseAcquisition.swift';
 const source=fs.readFileSync(path.join(root,name),'utf8');
 c.source+='\n'+source;c.fingerprints[name]=base.digest(source);return c;
}
const answers=[0,1].flatMap(h=>[0,1].map(l=>`Paired<QBit${h}, QBit${l}>`));
function read(c=context()){
 const rows=Array.from({length:8},(_,i)=>{
  const row=`CoarseAcquisitionRoot.Row${i}`;
  return {Question:answers.indexOf(base.reading(c,row+'.Question',answers)),
   ...Object.fromEntries(['Half','Low','High','Nuisance'].map(f=>
     [f,Number(base.reading(c,row+'.'+f,['QBit0','QBit1']).slice(-1))]))};
 });
 return {schema:'vi.coarse-acquisition-source.v1',rows,source_sha256:c.fingerprints};
}
function check(directory){
 const c=context(),source=read(c);let claims='',count=0;
 const eq=(a,b)=>claims+=base.equation('CoarseAcquisition'+count++,a,b);
 for(let i=0;i<8;i++){
  const r=source.rows[i],row=`CoarseAcquisitionRoot.Row${i}`,contact=r.Half?'High':'Low';
  eq(`Paired<${row}.Half, ${row}.${contact}>`,`${row}.Question`);
 }
 for(let i=0;i<8;i+=2){
  const a=`CoarseAcquisitionRoot.Row${i}`,b=`CoarseAcquisitionRoot.Row${i+1}`;
  eq(a+'.Half',b+'.Half');
  const contact=source.rows[i].Half?'High':'Low';eq(a+'.'+contact,b+'.'+contact);
 }
 const proof=c.source+'\n'+claims,verdict=judgeWhereTexts(proof);
 assert.equal(verdict.judged,count);assert.deepEqual(verdict.refusals,[]);
 const rejected=[
  ['High leaks the lower nuisance','CoarseAcquisitionRoot.Row0.High','CoarseAcquisitionRoot.Row1.High'],
  ['Low leaks the upper nuisance','CoarseAcquisitionRoot.Row4.Low','CoarseAcquisitionRoot.Row5.Low'],
  ['Different requested positions remain different','CoarseAcquisitionRoot.Row0.Question','CoarseAcquisitionRoot.Row2.Question']
 ].map(([name,a,b],i)=>{
  const bad=c.source+'\n'+base.equation('BadCoarse'+i,a,b),r=judgeWhereTexts(bad);
  assert.equal(r.judged,1);assert(r.refusals.length);
  if(directory)fs.writeFileSync(path.join(directory,`RejectedCoarse-${i}.swift`),bad);
  return name;
 });
 if(directory)fs.writeFileSync(path.join(directory,'CoarseAcquisition.swift'),proof);
 return {source,equalities:count,rejections:rejected,
  scope:'Finite source equalities only; no physical coherence claim follows from these names.'};
}
if(require.main===module){
 if(process.argv[3])fs.mkdirSync(process.argv[3],{recursive:true});
 console.log(JSON.stringify(process.argv[2]==='read'?read():check(process.argv[3])));
}
module.exports={read,check,context};
