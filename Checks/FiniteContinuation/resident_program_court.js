// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
// New application of the existing finite reader; no new parser or judge.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),joint=require('./joint_return_court.js'),contact=require('./contact_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(path.join(root,'Checks/Archive/WhereV2/judge-where.js')));
function context(){
 const c=joint.context();
 for(const name of ['Sources/Examples/MemoryBoundaryPreparation.swift','Sources/Examples/ResidentInterpreter.swift']){
  const s=fs.readFileSync(path.join(root,name),'utf8');c.source+='\n'+s;c.fingerprints[name]=base.digest(s);
 }
 return c;
}
function read(c){
 const r='ResidentInterpreterRoot',programs=['ResidentHS','ResidentSH'],gates=['JointHLabel','JointSLabel'];
 const rows=[];
 for(let p=0;p<2;p++)for(let t=0;t<2;t++){
  const row=r+`.Row${p}${t}`;
  base.reading(c,row+'.Left.Left',[r+`.Program${p}`]);
  base.reading(c,row+'.Right.Left',[row+'.Left.Left']);
  const input=Number(base.reading(c,row+'.Left.Right',['QBit0','QBit1']).slice(-1));assert.equal(input,t);
  const next=Number(base.reading(c,row+'.Right.Right',['QBit0','QBit1']).slice(-1));
  const gate=base.reading(c,row+'.Instruction',gates)==='JointHLabel'?'h':'s';
  const inverse=gate==='h'?['h']:['s','s','s'];
  const pullback={I:{axis:'I',sign:1}};
  for(const axis of ['X','Y','Z']){
   const d=contact.direction(c,inverse,axis);pullback[axis]={axis:d.axis,sign:d.sign};
  }
  rows.push({program:p,clock:t,next_clock:next,gate,pullback});
 }
 base.reading(c,r+'.ServiceAction',['QZ']);base.reading(c,r+'.ReopenService',['JointCZLabel']);
 base.reading(c,r+'.ServiceRenewal',['MemoryBoundaryPalette.Uniform']);
 const memory_pullback=Object.fromEntries(['X','Y','Z'].map(a=>[a,
  {axis:a,sign:base.reading(c,r+'.ServiceAction.For'+a,['QBit0','QBit1'])==='QBit0'?1:-1}]));
 const leaves=['Left.Left','Left.Right','Right.Left','Right.Right'].map(s=>
  ({pauli:base.reading(c,r+'.ServiceRenewal.'+s,['QI','QX','QY','QZ']).slice(1)}));
 return {schema:'vi.resident-interpreter.v1',source_sha256:c.fingerprints,rows,
  memory_pullback:{I:{axis:'I',sign:1},...memory_pullback},
  renewal:{choice:[{choice:leaves.slice(0,2)},{choice:leaves.slice(2)}]},
  coordinated_PC:['Left','Right'].map(side=>['Left','Right'].map(slot=>
   base.reading(c,r+'.CoordinatedPC.'+side+'.'+slot,['QI','QX','QY','QZ']).slice(1))),
  reopen_blocks:[0,1].map(i=>({
   word:base.reading(c,`JointCZ<JointReturnStart>.Block${i}.Word`,['CoherentI<CoherentPhase0>.Word','CoherentZ<CoherentPhase0>.Word'])==='CoherentI<CoherentPhase0>.Word'?'I':'Z',
   phase:Number(base.reading(c,`JointCZ<JointReturnStart>.Block${i}.Phase`,[0,1,2,3].map(n=>'CoherentPhase'+n)).slice(-1))})),
  scope:'Fixed coherent step on D,P,C,E; classical program/clock diagonal observable grammar, not arbitrary program-coherence readings.'};
}
function build(directory){
 const c=context(),data=read(c);let claims='',count=0;
 const eq=(l,r)=>{claims+=base.equation('Resident'+count++,l,r);};
 const root='ResidentInterpreterRoot';
 for(const row of data.rows){
  const p=root+`.Row${row.program}${row.clock}`;
  eq(p+'.Right.Left',p+'.Left.Left');eq(p+'.Right.Right',p+'.Left.Right.Flipped');
  eq(p+'.Right.Right.Flipped',p+'.Left.Right');
  eq(p+'.Instruction',p+'.Left.Left.'+(row.clock===0?'Left':'Right'));
  for(const axis of ['X','Y','Z']){
   const d=contact.direction(c,row.gate==='h'?['h']:['s','s','s'],axis);eq(d.expression,d.value);
  }
 }
 eq(root+'.ServiceRenewal','Paired<Paired<QI, QX>, Paired<QY, QZ>>');
 eq(root+'.CoordinatedPC','Paired<Paired<QI, QI>, Paired<QX, QX>>');
 const text=c.source+'\n'+claims,v=judgeWhereTexts(text);assert.equal(v.judged,count);assert.deepEqual(v.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentInterpreter.swift'),text);
 fs.writeFileSync(path.join(directory,'resident-reading.json'),JSON.stringify(data,null,2)+'\n');
 const neg=[['clock does not advance',root+'.Row00.Right.Right','QBit0'],
  ['next instruction copied from wrong program',root+'.Row00.Instruction',root+'.Row10.Instruction'],
  ['one tick falsely returns the complete clock',root+'.Row01.Right',root+'.Row01.Left']];
 const negatives=[];
 for(const [name,l,r]of neg){const s=c.source+'\n'+base.equation('RejectedResident',l,r),v=judgeWhereTexts(s);
  assert.equal(v.judged,1);assert(v.refusals.length);const file='RejectedResident-'+negatives.length+'.swift';
  fs.writeFileSync(path.join(directory,file),s);negatives.push({name,file});}
 return {equalities:count,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(text)};
}
if(require.main===module){const[mode,dir]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(dir)));}
module.exports={context,read,build};
