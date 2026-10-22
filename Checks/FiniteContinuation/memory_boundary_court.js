// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
// Read the actual finite choice tree through the existing equality court.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const frame=require('./whole_word_frame.js'),joint=require('./joint_return_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(path.join(root,'Checks/Archive/WhereV2/judge-where.js')));
function context(){
 const c=frame.context(),name='Sources/Examples/MemoryBoundaryPreparation.swift',s=fs.readFileSync(path.join(root,name),'utf8');
 c.source+='\n'+s;c.fingerprints[name]=base.digest(s);return c;
}
function equals(c,l,r){
 const v=judgeWhereTexts(c.source+'\n'+base.equation('BoundaryRead',l,r));
 assert.equal(v.judged,1);return !v.refusals.length;
}
function choice(c,t,depth=0){
 assert(depth<5,'Finite choice grammar exceeded');
 const leaves=['QI','QX','QY','QZ'].filter(p=>equals(c,t,p));
 if(leaves.length){assert.equal(leaves.length,1);return {pauli:leaves[0].slice(1)};}
 assert(equals(c,t,`Paired<${t}.Left, ${t}.Right>`),'Not a Pauli leaf or an actual pair');
 return {choice:[choice(c,t+'.Left',depth+1),choice(c,t+'.Right',depth+1)]};
}
function read(c){
 const p=joint.construction('Moving',['h']).full,recipes={};
 for(const name of ['Retain','Half','Uniform']){
  const t=`MemoryBoundaryPrograms<${p}>.${name}`;
  base.reading(c,t+'.Left.Left',['MemoryBoundaryRegister']);
  base.reading(c,t+'.Right',[p]);
  base.reading(c,t+'.Question',[p+'.Ideal.Word']);
  recipes[name]={target:'E',placement:'before_complete_word',tree:choice(c,t+'.Left.Right')};
 }
 return {schema:'vi.memory-boundary-recipes.v1',source_sha256:c.fingerprints,recipes,
  scope:'Private fair choices of actual E Pauli controls before one complete source-derived word; no numerical error theorem asserted by the court.'};
}
function build(directory){
 const c=context(),data=read(c);let claims='',count=0;
 const eq=(l,r)=>{claims+=base.equation('MemoryBoundary'+count++,l,r);};
 const literal={Retain:'QI',Half:'Paired<QI, Paired<Paired<QI, QX>, Paired<QY, QZ>>>',Uniform:'Paired<Paired<QI, QX>, Paired<QY, QZ>>'};
 const words=joint.read(joint.context()).goals;
 for(const model of ['Keep','Moving'])for(const goal of words){
  const p=joint.construction(model,goal.word).full;
  const trace=`Paired<${p}, MemoryBoundaryPalette.Uniform>`;
  for(const name of Object.keys(literal)){
   const plan=`MemoryBoundaryPrograms<${p}>.${name}`;
   const use=`MemoryBoundaryApplication<${plan}, ${trace}>`;
   const nameOfUse='MemoryBoundary'+count++;
   claims+=`public typealias ${nameOfUse} = ${use}\npublic typealias Use${nameOfUse} = MemoryBoundaryUse<${nameOfUse}>\n`;
   eq(plan,`MemoryBoundaryWord<${p}, ${literal[name]}>`);
   eq(plan+'.Question',p+'.Ideal.Word');
  }
 }
 const t=c.source+'\n'+claims,v=judgeWhereTexts(t);
 assert.equal(v.judged,count);assert.deepEqual(v.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'MemoryBoundary.swift'),t);
 fs.writeFileSync(path.join(directory,'boundary-reading.json'),JSON.stringify(data,null,2)+'\n');
 const p=joint.construction('Moving',['h']).full,q=joint.construction('Keep',['h']).full;
 const plan=`MemoryBoundaryPrograms<${p}>.Half`;
 const wrong=`MemoryBoundaryApplication<${plan}, Paired<${q}, MemoryBoundaryPalette.Uniform>>`;
 const neg=[['same target, different acquired word',wrong,null],
  ['memory control changed to data control',plan+'.Left.Left','WholeWordXLabel'],
  ['half preparation replaced by full',plan+'.Left.Right','MemoryBoundaryPalette.Uniform']];
 const negatives=[];
 for(const [name,l,r]of neg){
  const claim=r===null?`public typealias RejectedBoundary = ${l}\npublic typealias UseRejectedBoundary = MemoryBoundaryUse<RejectedBoundary>\n`:base.equation('RejectedBoundary',l,r);
  const s=c.source+'\n'+claim,v=judgeWhereTexts(s);
  assert.equal(v.judged,1);assert(v.refusals.length);
  const file='RejectedBoundary-'+negatives.length+'.swift';fs.writeFileSync(path.join(directory,file),s);negatives.push({name,file});
 }
 return {equalities:count,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(t)};
}
if(require.main===module){const[mode,dir]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(dir)));}
module.exports={context,read,build};
