// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const service=require('./resident_classical_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(path.join(root,'Checks/Archive/WhereV2/judge-where.js')));
function context(){
 const c=service.context(),name='Sources/Examples/ResidentFramedContact.swift',s=fs.readFileSync(path.join(root,name),'utf8');
 c.source+='\n'+s;c.fingerprints[name]=base.digest(s);return c;
}
function read(c){
 const r='ResidentFramedRoot',bits=['QBit0','QBit1'];base.reading(c,r+'.Service',['ResidentClassicalRoot']);
 const rows=[];
 for(let p=0;p<2;p++)for(let c0=0;c0<2;c0++){
  const at=r+`.Row${p}${c0}`,bit=f=>Number(base.reading(c,at+'.'+f,bits).slice(-1)),pair=f=>['Left','Right'].map(s=>bit(f+'.'+s));
  const frames={};
  for(const frame of ['Program','Clock'])frames[frame]=[0,1].map(b=>({raw:bit(frame+b+'.Left'),after:pair(frame+b+'.Right'),returned:pair(frame+'Return'+b)}));
  rows.push({input:pair('Input'),frames});
 }
 return {schema:'vi.resident-framed-contact.v1',source_sha256:c.fingerprints,rows,
  service:service.read(service.context()),scope:'Raw record writes P while C is preserved. Exported relative record is a new actual post-write PC-parity contact, not free relabeling.'};
}
function build(directory){
 const c=context(),data=read(c);let claims='',n=0;const eq=(l,r)=>claims+=base.equation('Framed'+n++,l,r),root='ResidentFramedRoot';
 for(const row of data.rows){
  const [p,c0]=row.input,at=root+`.Row${p}${c0}`;
  for(const frame of ['Program','Clock'])for(let b=0;b<2;b++){
   const source=at+'.Input.'+(frame==='Program'?'Left':'Right')+(b?'.Flipped':'');
   eq(at+`.${frame}${b}.Left`,source);
   eq(at+`.${frame}${b}.Right.Left`,at+`.${frame}${b}.Left`);
   eq(at+`.${frame}${b}.Right.Right`,at+'.Input.Right');
   eq(at+`.${frame}Return${b}`,at+`.${frame}${b}.Right`);
  }
 }
 const proof=c.source+'\n'+claims,v=judgeWhereTexts(proof);assert.equal(v.judged,n);assert.deepEqual(v.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentFramed.swift'),proof);
 fs.writeFileSync(path.join(directory,'framed-reading.json'),JSON.stringify(data,null,2)+'\n');
 const negative=[['raw record detached from actual write',root+'.Row00.Program1.Right.Left',root+'.Row00.Program1.Left.Flipped'],
 ['return reads the old PC pair',root+'.Row00.ProgramReturn1',root+'.Row00.Input'],
 ['clock frame replaced by program frame',root+'.Row01.Clock0.Left',root+'.Row01.Program0.Left']];
 const negatives=negative.map(([name,l,h],i)=>{const s=c.source+'\n'+base.equation('RejectedFramed',l,h),v=judgeWhereTexts(s);assert.equal(v.judged,1);assert(v.refusals.length);
  const file=`RejectedFramed-${i}.swift`;fs.writeFileSync(path.join(directory,file),s);return {name,file};});
 return {equalities:n,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(proof)};
}
if(require.main===module){const [mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
