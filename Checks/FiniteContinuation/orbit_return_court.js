"use strict";
// Read and apply the new successor to the current old law, using the existing
// bounded court. No new parser, trust flag, or physical-phase assertion.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),old=require('./returning_attempt_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
function context(){
 const c=old.context(),name='Sources/Examples/OrbitReturn.swift';
 const text=fs.readFileSync(path.join(root,name),'utf8');
 c.source+='\n'+text;c.fingerprints[name]=base.digest(text);return c;
}
function read(c=context()){
 const names=Array.from({length:8},(_,i)=>`OrbitReturnRoot.Row${i}`);
 const rows=names.map(name=>Object.fromEntries(['Control','ProbeB','ProbeParity','Residue'].map(f=>
   [f,Number(base.reading(c,name+'.Law.'+f,['QBit0','QBit1']).slice(-1))])));
 const successor=names.map(name=>names.indexOf(base.reading(c,name+'.Next',names)));
 return {schema:'vi.orbit-return-source.v1',rows,successor,source_sha256:c.fingerprints};
}
function check(directory){
 const c=context(),source=read(c);let claims='',count=0;
 const eq=(a,b)=>claims+=base.equation('OrbitReturnClaim'+count++,a,b);
 for(let i=0;i<8;i++){
  const row=`OrbitReturnRoot.Row${i}`;
  eq(row+'.Law',`OrbitReturnRoot.Source.Row${i}`);
  eq(row+'.Next.Next.Next.Next',row);
  const p=source.rows[i].ProbeParity;
  // Apply the actual selected XOR branch directly. The native bounded reader
  // currently leaves the additional ReturningControlAfter generic alias open;
  // its failed spelling is retained as a limitation fixture, not hidden.
  eq(row+'.Law.ProbeB'+(p?'.Flipped':''),row+'.Law.Control');
 }
 const proof=c.source+'\n'+claims,r=judgeWhereTexts(proof);
 assert.equal(r.judged,count);assert.deepEqual(r.refusals,[]);
 const refusals=[
  ['One step is not a return','OrbitReturnRoot.Row0.Next','OrbitReturnRoot.Row0'],
  ['Two steps do not return the nuisance','OrbitReturnRoot.Row0.Next.Next.Law.ProbeB','OrbitReturnRoot.Row0.Law.ProbeB'],
  ['Fine reading is not the question','OrbitReturnRoot.Row2.Law.ProbeB','OrbitReturnRoot.Row2.Law.Control']
 ].map(([name,a,b],i)=>{
  const bad=c.source+'\n'+base.equation('BadOrbit'+i,a,b),v=judgeWhereTexts(bad);
  assert.equal(v.judged,1);assert(v.refusals.length);
  if(directory)fs.writeFileSync(path.join(directory,`RejectedOrbit-${i}.swift`),bad);
  return name;
 });
 if(directory)fs.writeFileSync(path.join(directory,'OrbitReturn.swift'),proof);
 return {source,equalities:count,expected_rejections:refusals,
  scope:'Current finite successor and decoder equalities only; no physical phase guarantee.'};
}
if(require.main===module){
 if(process.argv[3])fs.mkdirSync(process.argv[3],{recursive:true});
 console.log(JSON.stringify(process.argv[2]==='read'?read():check(process.argv[3])));
}
module.exports={context,read,check};
