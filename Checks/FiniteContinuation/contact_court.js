// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
// Compose probe laws from current fields through the EXISTING court. No
// numerical quantum model and no caller-supplied probe reply table.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(path.join(root,'Checks/Archive/WhereV2/judge-where.js')));
const blocks={X:'CoherentX<CoherentPhase0>',Y:'CoherentXZ<CoherentPhase1>',Z:'CoherentZ<CoherentPhase0>'};
const signed={
  'CoherentX<CoherentPhase0>':{axis:'X',sign:1},'CoherentX<CoherentPhase2>':{axis:'X',sign:-1},
  'CoherentXZ<CoherentPhase1>':{axis:'Y',sign:1},'CoherentXZ<CoherentPhase3>':{axis:'Y',sign:-1},
  'CoherentZ<CoherentPhase0>':{axis:'Z',sign:1},'CoherentZ<CoherentPhase2>':{axis:'Z',sign:-1}};

function context(){
  const ctx=base.context();
  const file='Sources/Examples/QuantumCoherentControl.swift',text=fs.readFileSync(path.join(root,file),'utf8');
  const end=text.indexOf('public protocol CoherentIdeal:');assert(end>0);
  ctx.source+='\n'+text.slice(0,end);
  ctx.fingerprints[file]=base.digest(text);
  const name='Sources/Examples/PauliContactComposition.swift',extra=fs.readFileSync(path.join(root,name),'utf8');
  ctx.source+='\n'+extra;ctx.fingerprints[name]=base.digest(extra);
  return ctx;
}
function validateWord(word){
  assert(Array.isArray(word)&&word.length<=12&&word.every(g=>g==='h'||g==='s'),
    'Only declared H/S operations in the middle slot');
}
function direction(ctx,word,prep){
  validateWord(word);assert(blocks[prep]);
  const expression=blocks[prep]+word.map(g=>'.Conjugated'+g.toUpperCase()).join('');
  const value=base.reading(ctx,expression,Object.keys(signed));
  return {expression,value,...signed[value]};
}
function closure(ctx){
  const words=[[]],seen=new Map();const result=[];
  while(words.length){
    const word=words.shift(),profile=['X','Y','Z'].map(a=>direction(ctx,word,a));
    const key=JSON.stringify(profile.map(p=>p.value));
    if(seen.has(key))continue;
    assert(result.length<24,'Declared H/S action exceeded the bounded Clifford closure');
    seen.set(key,word);result.push({word,profile});
    for(const g of ['h','s'])words.push([...word,g]);
  }
  assert.equal(result.length,24);return result;
}
function composed(ctx,model,word,prep){
  const ideal=direction(ctx,word,prep),applications=[];
  for(let i=0;i<16;i++){
    const row=`FinitePauliTXSource.Row${i}`;
    const frame=row+'.A'+word.map(g=>'.After'+g.toUpperCase()).join('');
    const application=`PauliContact${model.worlds[i][1]}<${frame}>`;
    const bit=application+'.Right.For'+ideal.axis+(ideal.sign<0?'.Flipped':'');
    const value=base.reading(ctx,bit,['QBit0','QBit1']);
    applications.push({frame,application,bit,value});
  }
  return {id:'slot:'+word.join(',')+':'+prep+':'+ideal.axis,
          middle:word,prep,read:ideal.axis,ideal_sign:ideal.sign,
          module_uses:2,control_gates:word.length,
          replies:applications.map(a=>Number(a.value.slice(-1))),applications,ideal};
}
function read(ctx){
  const model=base.sourceModel(ctx),cliffords=closure(ctx);
  const probes=cliffords.flatMap(c=>['X','Y','Z'].map(prep=>{
    const {applications,ideal,...p}=composed(ctx,model,c.word,prep);return p;
  }));
  return {model:{...model,probes},source_sha256:ctx.fingerprints,
          source:'FinitePauliTXSource',grammar:{middle:['h','s'],paths:['A middle B'],
            preparations:['X','Y','Z'],readings:['X','Y','Z'],individual_module_access:false},
          generated_clifford_profiles:cliffords.length};
}
function check(ctx,proposal){
  assert.equal(proposal.schema,'vi.composed-contact-proposal.v1');
  assert.deepEqual(proposal.request,{connector:['t'],consumer:'terminal',axis:'X',port:'A middle B'});
  const model=base.sourceModel(ctx);
  assert(Array.isArray(proposal.old_memory)&&proposal.old_memory.length===2&&proposal.old_memory.every(b=>b===0||b===1));
  const family=Array.from({length:16},(_,i)=>i).filter(i=>['neutral:X:X','neutral:Z:Z'].every((id,n)=>
    model.probes.find(p=>p.id===id).replies[i]===proposal.old_memory[n]));
  assert.equal(family.length,4);assert.deepEqual(proposal.family,family,'Complete old-record fiber required');
  const contact=composed(ctx,model,proposal.contact.middle,proposal.contact.prep);
  const {applications,ideal,replies,...descriptor}=contact;
  assert.deepEqual(proposal.contact,descriptor,'Native contact must match its composed reading');
  const groups=new Map();for(const i of family){const b=replies[i];if(!groups.has(b))groups.set(b,[]);groups.get(b).push(i);}
  assert(groups.size>1,'The proposed contact must add a distinction');
  assert.deepEqual(Object.keys(proposal.branches).sort(),[...groups.keys()].map(String).sort());
  let claims=base.equation('ComposedQuestion','Paired<FinitePauliTXSource.Target, FinitePauliTXSource.Question>',
    'Paired<FiniteTGate, QuantumMeasureXQuestion>');
  claims+=base.equation('SignedIdealContact',ideal.expression,ideal.value);
  for(const [bit,indices] of groups){
    const branch=proposal.branches[bit];assert(base.actions[branch.action]);
    assert.deepEqual(branch.execution,base.actions[branch.action]);
    assert.deepEqual(branch.family,indices,'Cannot narrow a reply fiber');
    claims+=`public typealias ContactReply${bit} = Paired<QBit${bit}, ${base.answerTypes[branch.action]}>\n`;
  }
  for(const i of family){
    const row=`FinitePauliTXSource.Row${i}`,a=applications[i],bit=replies[i];
    claims+=base.equation(`ContactInput${i}`,a.application+'.Left',`Paired<${row}.Second, ${a.frame}>`);
    claims+=base.equation(`ContactAnswer${i}`,
      `Paired<Paired<${row}.NX, ${row}.NZ>, Paired<${a.bit}, ${row}.Answer>>`,
      `Paired<Paired<QBit${proposal.old_memory[0]}, QBit${proposal.old_memory[1]}>, ContactReply${bit}>`);
  }
  const source=ctx.source+'\n'+claims,verdict=judgeWhereTexts(source);
  assert.equal(verdict.judged,2+2*family.length);assert.deepEqual(verdict.refusals,[]);
  return {source,verdict,source_sha256:ctx.fingerprints,certificate_sha256:base.digest(source)};
}
if(require.main===module){
  const [mode,file,out]=process.argv.slice(2),ctx=context();
  if(mode==='read')process.stdout.write(JSON.stringify(read(ctx)));
  else if(mode==='check'){
    const checked=check(ctx,JSON.parse(fs.readFileSync(file,'utf8')));fs.writeFileSync(out,checked.source);
    const {source,...proof}=checked;process.stdout.write(JSON.stringify(proof));
  }else throw Error('read | check proposal.json Applications.swift');
}
module.exports={context,direction,closure,composed,read,check};
