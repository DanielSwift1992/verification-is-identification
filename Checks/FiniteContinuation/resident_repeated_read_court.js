"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),wire=require('./resident_measurement_wire_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
const patterns=['NoError','FirstWrong','SecondWrong','ThirdWrong'];
function context(){const c=wire.context(),n='Sources/Examples/ResidentRepeatedRead.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function bit(c,t){return Number(base.reading(c,t,['QBit0','QBit1']).slice(-1));}
function pathFor(v){return 'ResidentRepeatedReadRoot.Decode.'+v.map(b=>b?'Right':'Left').join('.');}
function read(c){
 const table=Array.from({length:8},(_,i)=>{const votes=[i>>2,(i>>1)&1,i&1];return{votes,answer:bit(c,pathFor(votes))};});
 const cases=[];
 for(let b=0;b<2;b++)for(const pattern of patterns){
  const t=`ResidentRepeatedReadRoot.Branch${b}`,p=t+'.'+pattern;
  const votes=['Left','Right.Left','Right.Right'].map(f=>bit(c,p+'.'+f));
  cases.push({truth:bit(c,t+'.Truth'),pattern,votes,answer:bit(c,pathFor(votes))});
 }
 return {schema:'vi.resident-repeated-read.v1',source_sha256:c.fingerprints,wire:wire.read(wire.context()),table,cases,
  scope:'Three reports of the same classical branch, at most one report differs. The source family does not establish this noise condition for a device.'};
}
function build(directory){
 const c=context(),reading=read(c);let claims='',count=0;const eq=(a,b)=>claims+=base.equation('RepeatedRead'+count++,a,b);
 for(const row of reading.cases){assert.equal(row.answer,row.truth);eq(pathFor(row.votes),`ResidentRepeatedReadRoot.Branch${row.truth}.Truth`);}
 const proof=c.source+'\n'+claims,result=judgeWhereTexts(proof);assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 const bad=[['two wrong reports are outside the contract',pathFor([1,1,0]),'ResidentRepeatedReadRoot.Branch0.Truth'],
 ['first report is not always the correct read','ResidentRepeatedReadRoot.Branch0.FirstWrong.Left','ResidentRepeatedReadRoot.Branch0.Truth'],
 ['the decoder cannot replace an acquired third vote by a favourable one',pathFor([0,1,1]),pathFor([0,1,0])]];
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentRepeatedRead.swift'),proof);
 const negatives=bad.map(([name,a,b],i)=>{const text=c.source+'\n'+base.equation('RejectedRepeatedRead',a,b),r=judgeWhereTexts(text);assert.equal(r.judged,1);assert(r.refusals.length);const file=`RejectedRepeatedRead-${i}.swift`;fs.writeFileSync(path.join(directory,file),text);return{name,file};});
 fs.writeFileSync(path.join(directory,'repeated-reading.json'),JSON.stringify(reading,null,2)+'\n');
 return{equalities:count,negatives,source_sha256:c.fingerprints};
}
if(require.main===module){const[mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
