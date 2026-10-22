// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
// Bounded application of the existing judge. No new parser or trusted marker.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'Checks/Archive/WhereV2/judge-where.js'));
function context(){
 const c=base.context();
 // The monitor root has additional dependencies; only these three complete
 // existing declarations are needed. Nothing is changed in their bodies.
 const monitor='Sources/Examples/ResidentGoalMemory.swift';
 const text=fs.readFileSync(path.join(root,monitor),'utf8');
 const endpoint=text.indexOf('// The second field');assert(endpoint>0);
 c.source+='\n'+text.slice(0,endpoint);c.fingerprints[monitor]=base.digest(text);
 // base.context includes just bare Pauli declarations already, verbatim.
 const n='Sources/Examples/ReturningAttempt.swift',t=fs.readFileSync(path.join(root,n),'utf8');
 c.source+='\n'+t;c.fingerprints[n]=base.digest(t);return c;
}
function read(c=context()){
 const fields=['Control','ProbeB','ProbeParity','Residue'];
 const rows=Array.from({length:8},(_,i)=>Object.fromEntries(fields.map(f=>
  [f,Number(base.reading(c,`ReturningAttemptRoot.Row${i}.${f}`,['QBit0','QBit1']).slice(-1))])));
 return {schema:'vi.returning-attempt-source.v1',rows,source_sha256:c.fingerprints};
}
function check(directory){
 const c=context(),source=read(c);let claims='',count=0;
 const eq=(a,b)=>claims+=base.equation('ReturningAttempt'+count++,a,b);
 for(let i=0;i<source.rows.length;i++){
  const r=source.rows[i],row=`ReturningAttemptRoot.Row${i}`;
  eq(`ReturningControlAfter${r.ProbeParity}<${row}.ProbeB>`,`${row}.Control`);
 }
 for(const frame of ['QI','QX','QY','QZ'])for(const b of [0,1])
  eq(`ReturningReply${b}<${frame}>.Restored`,frame);
 const proof=c.source+'\n'+claims,result=judgeWhereTexts(proof);
 assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 if(directory){fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ReturningAttempt.swift'),proof);}
 const bad=[
  ['ProbeB is not Control','ReturningAttemptRoot.Row2.ProbeB','ReturningAttemptRoot.Row2.Control'],
  ['Parity is not Control','ReturningAttemptRoot.Row2.ProbeParity','ReturningAttemptRoot.Row2.Control'],
  ['A ready name does not undo disturbance','ReturningReply1<QI>.Disturbed','QI'],
  ['Residual sources remain distinct','ReturningAttemptRoot.Row0.Residue','ReturningAttemptRoot.Row1.Residue'],
 ].map(([name,a,b],i)=>{const text=c.source+'\n'+base.equation('BadReturning'+i,a,b),v=judgeWhereTexts(text);
   if(directory)fs.writeFileSync(path.join(directory,`RejectedReturningAttempt-${i}.swift`),text);
   assert.equal(v.judged,1);assert(v.refusals.length);return name;});
 return {source,equalities:count,rejections:bad,scope:'Finite equality applications only; physical instrument and execution are checked separately.'};
}
if(require.main===module)console.log(JSON.stringify(process.argv[2]==='read'?read():check(process.argv[3])));
module.exports={read,check,context};
