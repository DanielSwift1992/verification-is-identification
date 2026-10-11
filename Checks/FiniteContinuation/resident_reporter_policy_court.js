"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),repeated=require('./resident_repeated_read_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
const names=['AnyOne','Majority','AllOne'];
function context(){const c=repeated.context(),n='Sources/Examples/ResidentReporterPolicy.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function address(name,v){return 'ResidentReporterPolicyRoot.'+name+'.'+v.map(b=>b?'Right':'Left').join('.');}
function read(c){return{schema:'vi.resident-reporter-policy.v1',source_sha256:c.fingerprints,
 repeated:repeated.read(repeated.context()),
 policies:Object.fromEntries(names.map(name=>[name,Array.from({length:8},(_,i)=>{const votes=[i>>2,(i>>1)&1,i&1];return{votes,answer:Number(base.reading(c,address(name,votes),['QBit0','QBit1']).slice(-1))};})])),
 scope:'Candidate readings of actual reports; their likelihood ordering must be acquired, not assumed by a candidate name.'};}
function build(directory){const c=context(),reading=read(c);let claims='',count=0;
 for(const [index,name] of names.entries())for(const row of reading.policies[name]){
  const expected=Number(row.votes.reduce((a,b)=>a+b,0)>=index+1);assert.equal(row.answer,expected);
  claims+=base.equation('ReporterPolicy'+count++,address(name,row.votes),'QBit'+expected);
 }
 const proof=c.source+'\n'+claims,r=judgeWhereTexts(proof);assert.equal(r.judged,count);assert.deepEqual(r.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentReporterPolicy.swift'),proof);
 const bad=[['a different reading cannot inherit the selected answer','AnyOne','AllOne',[0,1,1]],
 ['majority cannot inherit the answer of an any-one reader','Majority','AnyOne',[0,0,1]],
 ['a changed actual third report changes this selected answer','AllOne','Majority',[0,1,1]]];
 const negatives=bad.map(([name,a,b,v],i)=>{const text=c.source+'\n'+base.equation('RejectedReporterPolicy',address(a,v),address(b,v)),result=judgeWhereTexts(text);assert(result.refusals.length);const file=`RejectedReporterPolicy-${i}.swift`;fs.writeFileSync(path.join(directory,file),text);return{name,file};});
 fs.writeFileSync(path.join(directory,'policy-reading.json'),JSON.stringify(reading,null,2)+'\n');return{equalities:count,negatives,source_sha256:c.fingerprints};
}
if(require.main===module){const[mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
