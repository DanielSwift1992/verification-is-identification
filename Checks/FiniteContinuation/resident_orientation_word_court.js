// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),policy=require('./resident_reporter_policy_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'Checks/Archive/WhereV2/judge-where.js'));
const fields=['Left','Right.Left','Right.Right'];
function context(){const c=policy.context(),n='Sources/Examples/ResidentOrientationWord.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function bit(c,p){return Number(base.reading(c,p,['QBit0','QBit1']).slice(-1));}
function read(c){return{schema:'vi.resident-orientation-word.v1',source_sha256:c.fingerprints,policy:policy.read(policy.context()),
 selectors:Object.fromEntries(['Z','X'].map(a=>[a,fields.map(f=>bit(c,`ResidentOrientationWordRoot.${a}Placement.${f}`))])),
 errors:Array.from({length:8},(_,i)=>{const name=i.toString(2).padStart(3,'0'),p='ResidentOrientationWordRoot.E'+name+'.Word';return{errors:[...name].map(Number),x:bit(c,p+'.Left'),z:bit(c,p+'.Right')};}),
 scope:'Three residual error bits mapped to the density-output Pauli frame; common complement is forgotten, not each arbitrary error.'};}
function build(directory){const c=context(),reading=read(c);let claims='',count=0;const eq=(a,b)=>claims+=base.equation('OrientationWord'+count++,a,b);
 for(const r of reading.errors){const name=r.errors.join(''),other=r.errors.map(b=>1-b).join(''),p='ResidentOrientationWordRoot.E'+name;
  assert.equal(r.x,r.errors[1]^r.errors[2]);assert.equal(r.z,r.errors[0]^r.errors[1]);
  eq(p+'.Word.Left','QBit'+r.x);eq(p+'.Word.Right','QBit'+r.z);eq(p+'.Word','ResidentOrientationWordRoot.E'+other+'.Word');
 }
 for(const a of ['Z','X'])for(let i=0;i<3;i++){assert.equal(reading.selectors[a][i],Number(i===(a==='Z'?0:2)));eq(`ResidentOrientationWordRoot.${a}Placement.${fields[i]}`,'QBit'+reading.selectors[a][i]);}
 const proof=c.source+'\n'+claims,r=judgeWhereTexts(proof);assert.equal(r.judged,count);assert.deepEqual(r.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentOrientationWord.swift'),proof);
 const bad=[['one changed error is not a common orientation change','ResidentOrientationWordRoot.E000.Word','ResidentOrientationWordRoot.E100.Word'],
 ['an X residual cannot be erased','ResidentOrientationWordRoot.E001.Word.Left','QBit0'],
 ['the requested rotation cannot be moved to another slot without changing the question','ResidentOrientationWordRoot.XPlacement.Left','ResidentOrientationWordRoot.ZPlacement.Left']];
 const negatives=bad.map(([name,a,b],i)=>{const text=c.source+'\n'+base.equation('RejectedOrientationWord',a,b),result=judgeWhereTexts(text);assert(result.refusals.length);const file=`RejectedOrientationWord-${i}.swift`;fs.writeFileSync(path.join(directory,file),text);return{name,file};});
 fs.writeFileSync(path.join(directory,'orientation-reading.json'),JSON.stringify(reading,null,2)+'\n');return{equalities:count,negatives,source_sha256:c.fingerprints};
}
if(require.main===module){const[mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
