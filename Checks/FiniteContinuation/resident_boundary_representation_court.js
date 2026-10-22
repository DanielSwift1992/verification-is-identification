// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
// Read two actual Swift presentations using the unchanged relation judge.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const source=require('./resident_goal_synthesis_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'Checks/Archive/WhereV2/judge-where.js'));
function context(){const c=source.context(),n='Sources/Examples/ResidentBoundaryRepresentation.swift';
 const text=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+text;c.fingerprints[n]=base.digest(text);return c;}
function read(){
 const c=context(),s=source.read(source.context()),views={};
 for(const [name,form]of [['direct','ResidentBoundaryDirect'],['turned','ResidentBoundaryTurned']]){
  views[name]=s.states.map(t=>['Left','Right'].map(side=>Number(base.reading(c,`${form}<${t}>.${side}`,['QBit0','QBit1']).slice(-1))));
 }
 return {schema:'vi.resident-boundary-presentations.v1',source_sha256:c.fingerprints,
  base_source_sha256:s.source_sha256,views,
  scope:'Concrete finite presentations of the current First reading; not a certificate of arbitrary external memory.'};
}
function build(directory){
 const c=context(),s=source.read(source.context()),r=read();let claims='',count=0;
 const eq=(a,b)=>claims+=base.equation('BoundaryPresentation'+count++,a,b);
 for(const state of s.states)for(const side of ['Left','Right']){
  eq(`ResidentBoundaryDirect<${state}>.${side}`,`ResidentFirstQuestion<${state}>.${side}`);
  eq(`ResidentBoundaryTurnedReading<${state}>.${side}`,`ResidentFirstQuestion<${state}>.${side}`);
 }
 const text=c.source+'\n'+claims,result=judgeWhereTexts(text);
 assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentBoundaryRepresentation.swift'),text);
 const bad=c.source+'\n'+base.equation('RejectedBoundaryPresentation',
  'ResidentBoundaryTurned<ResidentGoalSynthesisRoot.State000>.Right','ResidentFirstQuestion<ResidentGoalSynthesisRoot.State000>.Left');
 const rejection=judgeWhereTexts(bad);assert.equal(rejection.judged,1);assert(rejection.refusals.length);
 fs.writeFileSync(path.join(directory,'RejectedBoundaryRepresentation.swift'),bad);
 fs.writeFileSync(path.join(directory,'reading.json'),JSON.stringify(r,null,2)+'\n');
 return {equalities:count,negative_cases:1,proof_sha256:base.digest(text),source_sha256:c.fingerprints};
}
if(require.main===module){const [mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read():build(directory)));}
module.exports={read,build,context};
