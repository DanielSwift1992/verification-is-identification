// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
// A new application of the existing court, not a parser or a noise proof.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const joint=require('./joint_return_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const judgeFile=path.resolve(path.join(root,'Checks/Archive/WhereV2/judge-where.js'));
const {judgeWhereTexts}=require(judgeFile);
const frame=(p,t)=>p==='I'?t:`WholeWord${p}<${t}>`;
const apply=(word,t)=>word.reduce((s,g)=>`Joint${g.toUpperCase()}<${s}>`,t);
function context(){
 const c=joint.context(),name='Sources/Examples/WholeWordFrame.swift',s=fs.readFileSync(path.join(root,name),'utf8');
 c.source+='\n'+s;c.fingerprints[name]=base.digest(s);return c;
}
function equal(c,l,r){
 const v=judgeWhereTexts(c.source+'\n'+base.equation('FrameQuestion',l,r));
 assert.equal(v.judged,1);return !v.refusals.length;
}
function body(model,word,t){
 const a=s=>`Joint${model}A<${s}>`,b=s=>`Joint${model}B<${s}>`;
 return a(b(a(b(apply(word,a(a(t)))))));
}
function read(c){
 const source=joint.read(joint.context()),start='JointReturnStart',paulis=['I','X','Y','Z'];
 const controls={};
 for(const p of paulis.slice(1)){
  const t=frame(p,start),words=['I','X','Z','XZ'];
  base.reading(c,t+'.Left.Left',[`WholeWord${p}Label`]);
  controls[p]=[0,1].map(i=>({
   word:words[words.map(w=>`Coherent${w}<CoherentPhase0>.Word`).indexOf(base.reading(c,t+`.Block${i}.Word`,words.map(w=>`Coherent${w}<CoherentPhase0>.Word`)))],
   phase:Number(base.reading(c,t+`.Block${i}.Phase`,[0,1,2,3].map(x=>'CoherentPhase'+x)).slice(-1))}));
  base.reading(c,t+'.Ideal.Word',['CoherentIdealEmpty.Word']);
 }
 const rows=[];
 for(const g of source.goals){
  const target=apply(g.word,start),frames=[];
  for(const before of paulis){
   const matches=[];
   for(const after of paulis){
    const w=frame(after,apply(g.word,frame(before,start)));
    for(const sign of [1,-1])if(equal(c,w+'.Right',(sign===1?target:`WholeWordNegated<${target}>`)+'.Right'))matches.push({before,after,sign});
   }
   assert.equal(matches.length,1);frames.push(matches[0]);
  }
  rows.push({question:g.word,frames});
 }
 return {schema:'vi.whole-word-frames.v1',source,frame_source_sha256:c.fingerprints,controls,rows,
  scope:'Exact data controls around a COMPLETE word. Ordinary channels, private uniform fresh seed; no acquired error bound in this type certificate.'};
}
function build(directory){
 const c=context(),data=read(c);let claims='',count=0;
 const eq=(l,r)=>{claims+=base.equation('WholeWordFrame'+count++,l,r);};
 for(const row of data.rows)for(const f of row.frames)for(const model of ['Keep','Moving']){
  const target=joint.construction(model,row.question).target;
  eq(frame(f.after,body(model,row.question,frame(f.before,'JointReturnStart')))+'.Right',
     (f.sign===1?target:`WholeWordNegated<${target}>`)+'.Right');
 }
 const text=c.source+'\n'+claims,v=judgeWhereTexts(text);
 assert.equal(v.judged,count);assert.deepEqual(v.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'WholeWordFrames.swift'),text);
 fs.writeFileSync(path.join(directory,'frame-reading.json'),JSON.stringify(data,null,2)+'\n');
 const h=joint.construction('Keep',['h']).target,m=joint.construction('Moving',['h']).target;
 const wrong=frame('X',body('Keep',['h'],frame('X','JointReturnStart')));
 const neg=[['wrong conjugated correction',wrong+'.Right',h+'.Right'],
            ['missing matching end control',body('Keep',['h'],frame('X','JointReturnStart'))+'.Right',h+'.Right'],
            ['changing memory falsely restored',m+'.Right',h+'.Right']];
 const negatives=[];
 for(const [name,l,r]of neg){
  const t=c.source+'\n'+base.equation('RejectedFrame',l,r),v=judgeWhereTexts(t);
  assert.equal(v.judged,1);assert(v.refusals.length);
  const file='RejectedFrame-'+negatives.length+'.swift';fs.writeFileSync(path.join(directory,file),t);negatives.push({name,file});
 }
 return {equalities:count,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(text)};
}
if(require.main===module){const [mode,dir]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(dir)));}
module.exports={context,read,build};
