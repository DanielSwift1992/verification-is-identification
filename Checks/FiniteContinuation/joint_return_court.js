"use strict";
// New finite application, using the existing equality court and operator
// constructors. No caller-supplied final answer or new Swift parser.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),contact=require('./contact_court.js');
const root=path.resolve(__dirname,'../..');
const judgeFile=path.resolve(process.env.VI_WHERE_JUDGE||path.join(root,'../gate/bin/judge-where.js'));
const {judgeWhereTexts}=require(judgeFile);
function context(){
 const c=base.context();
 for(const name of ['Sources/Examples/QuantumCoherentControl.swift','Sources/Examples/JointReturnSource.swift']){
  const t=fs.readFileSync(path.join(root,name),'utf8');
  const source=name.endsWith('QuantumCoherentControl.swift')?t.slice(0,t.indexOf('public enum CoherentOwnedResident')):t;
  assert(source.length>0);c.source+='\n'+source;c.fingerprints[name]=base.digest(t);
 }
 return c;
}
function byte(c,term){
 let n=0;
 for(let i=0;i<8;i++){n=2*n+Number(base.reading(c,term+'.Left',['QBit0','QBit1']).slice(-1));term+='.Right';}
 base.reading(c,term,['Never']);return n;
}
function operations(c,term){
 const labels={JointCZLabel:'cz',JointHLabel:'h',JointSLabel:'s',JointMemorySLabel:'memory_s'};
 const reversed=[];
 for(let k=0;k<16;k++){
  const end=judgeWhereTexts(c.source+'\n'+base.equation('TraceEnd',term+'.Left','Never'));
  assert.equal(end.judged,1);
  if(!end.refusals.length){base.reading(c,term,['JointReturnStart']);return reversed.reverse();}
  reversed.push(labels[base.reading(c,term+'.Left.Left',Object.keys(labels))]);
  term+='.Left.Right';
 }
 throw Error('Joint primitive trace exceeded its finite source bound');
}
function read(c){
 const goals=contact.closure(contact.context()).map((g,id)=>({id,word:g.word}));
 const offers={};
 for(const name of ['Keep','Moving','Fast','Protected','Replace']){
  const p='JointOffer'+name;
  const model=base.reading(c,p+'.Left',['JointKeep','JointMoving']);
  const at=base.reading(c,p+'.Right.Left',['JointBetweenPairs','JointEveryCall']);
  const rate=p+'.Right.Right',num=byte(c,rate+'.Left'),den=byte(c,rate+'.Right');
  assert(den>0&&num<=den);
  offers[name]={model,placement:at,rate:[num,den],cost:byte(c,p+'.Cost')};
 }
 const modules=Object.fromEntries(['Keep','Moving'].map(m=>['Joint'+m,
  Object.fromEntries(['A','B'].map(side=>[side,operations(c,`Joint${m}${side}<JointReturnStart>`)]))]));
 const wordTypes=['I','X','Z','XZ'],ideals=['CoherentIdealEmpty','CoherentIdealH<CoherentIdealEmpty>','CoherentIdealS1<CoherentIdealEmpty>'];
 const primitives=Object.fromEntries(['CZ','H','S','MemoryS'].map(g=>{
  const term=`Joint${g}<JointReturnStart>`;
  const blocks=[0,1].map(i=>({
   word:wordTypes.find(w=>`Coherent${w}<CoherentPhase0>.Word`===base.reading(c,term+`.Block${i}.Word`,wordTypes.map(x=>`Coherent${x}<CoherentPhase0>.Word`))),
   phase:Number(base.reading(c,term+`.Block${i}.Phase`,[0,1,2,3].map(p=>'CoherentPhase'+p)).slice(-1))}));
  const ideal=ideals.indexOf(base.reading(c,term+'.Ideal.Word',ideals.map(x=>x+'.Word')).slice(0,-5));
  return [g,{blocks,ideal:[[],['h'],['s']][ideal]}];
 }));
 return {schema:'vi.joint-return-source.v1',source_sha256:c.fingerprints,goals,offers,modules,primitives,
  scope:'Ordinary channels on full D,E and arbitrary reference; mixture weights are model assumptions.'};
}
function applyWord(word,start){return word.reduce((p,g)=>`Joint${g.toUpperCase()}<${p}>`,start);}
function construction(model,word){
 const a=p=>`Joint${model}A<${p}>`,b=p=>`Joint${model}B<${p}>`;
 const start='JointReturnStart',r1=a(a(start)),r2=a(b(a(b(start))));
 const full=a(b(a(b(applyWord(word,r1)))));
 const mem=(p,n)=>Array(n).fill(0).reduce(s=>`JointMemoryS<${s}>`,p);
 return {r1,r2,full,r1target:mem(start,model==='Moving'?2:0),r2target:start,
  target:mem(applyWord(word,start),model==='Moving'?2:0)};
}
function build(directory){
 const c=context(),data=read(c);let claims='',count=0;
 const eq=(l,r)=>{claims+=base.equation('JointReturn'+count++,l,r);};
 for(const model of ['Keep','Moving']){
  const zero=construction(model,[]);
  eq(zero.r1+'.Right',zero.r1target+'.Right');eq(zero.r2+'.Right',zero.r2target+'.Right');
  for(const goal of data.goals){
   const p=construction(model,goal.word);
   // The source's ACTUAL A/B definitions occur at every site of the word.
   eq(p.full+'.Right',p.target+'.Right');
  }
 }
 // Return the read mixture and cost fields to this same current source.
 for(const name of Object.keys(data.offers)){
  const p='JointOffer'+name,o=data.offers[name];eq(p+'.Left',o.model);eq(p+'.Right.Left',o.placement);
 }
 const text=c.source+'\n'+claims,verdict=judgeWhereTexts(text);
 assert.equal(verdict.judged,count);assert.deepEqual(verdict.refusals,[]);
 fs.writeFileSync(path.join(directory,'JointReturns.swift'),text);
 fs.writeFileSync(path.join(directory,'source-reading.json'),JSON.stringify(data,null,2)+'\n');
 // A data-only target must not silently claim restoration of memory.
 const moving=construction('Moving',['h']);
 const neg=[
  ['changing memory advertised as unchanged',moving.full+'.Right',applyWord(['h'],'JointReturnStart')+'.Right'],
  ['one unmatched memory contact','JointKeepA<JointReturnStart>.Right','JointReturnStart.Right'],
  ['wrong target after the same returns',construction('Keep',['s']).full+'.Right',construction('Keep',['h']).target+'.Right'],
 ];
 const negatives=[];
 for(const [name,l,r]of neg){
  const s=c.source+'\n'+base.equation('FalseJointReturn',l,r),v=judgeWhereTexts(s);
  assert.equal(v.judged,1);assert(v.refusals.length);
  const file='Rejected-'+negatives.length+'.swift';fs.writeFileSync(path.join(directory,file),s);negatives.push({name,file});
 }
 return {equalities:count,source_sha256:c.fingerprints,proof_sha256:base.digest(text),negatives};
}
if(require.main===module){
 const [mode,dir]=process.argv.slice(2);
 console.log(JSON.stringify(mode==='read'?read(context()):build(dir)));
}
module.exports={context,read,construction,build};
