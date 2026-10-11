"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),contact=require('./contact_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(process.env.VI_WHERE_JUDGE||path.join(root,'../gate/bin/judge-where.js')));
const letters=['I','X','Y','Z'];
const signed=['CoherentX<CoherentPhase0>','CoherentX<CoherentPhase2>',
 'CoherentZ<CoherentPhase0>','CoherentZ<CoherentPhase2>',
 'CoherentXZ<CoherentPhase1>','CoherentXZ<CoherentPhase3>'];
const expr=word=>word.reduce((p,g)=>`Routed${g.toUpperCase()}<${p}>`,'RoutedStart');
const mask=xs=>xs.reduce((m,i)=>m|(1<<i),0);
const rows=m=>Array.from({length:16},(_,i)=>i).filter(i=>(m>>i)&1);

function current(){
 const ctx=contact.context(),name='Sources/Examples/RoutedPauliAccess.swift';
 const source=fs.readFileSync(path.join(root,name),'utf8');ctx.source+='\n'+source;ctx.fingerprints[name]=base.digest(source);
 const model=base.sourceModel(ctx),goals=contact.closure(ctx).map((c,id)=>({id,word:c.word,
   profile:[c.profile[0].value,c.profile[2].value]}));
 const identify=p=>{const i=goals.findIndex(g=>JSON.stringify(g.profile)===JSON.stringify(p));assert(i>=0);return i;};
 const transitions={};
 for(const gate of ['H','S',...letters])transitions[gate]=goals.map(g=>
   identify(['OnX','OnZ'].map(axis=>base.reading(ctx,`Routed${gate}<${expr(g.word)}>.${axis}`,signed))));
 const apply=(word,state)=>word.reduce((s,g)=>transitions[g.toUpperCase()][s],state);
 const slots=goals.map(g=>model.worlds.map(([a,b])=>transitions[b][apply(g.word,transitions[a][0])]));
 const separate=model.worlds.map(([a])=>transitions[a][0]);
 const compose=goals.map(g=>goals.map(h=>apply(g.word,h.id)));
 const neutral=id=>model.probes.find(p=>p.id===id).replies;
 const keys=model.worlds.map((_,i)=>[neutral('neutral:X:X')[i],neutral('neutral:Z:Z')[i],neutral('A:Z:Z')[i]]);
 return {ctx,model,goals,transitions,slots,separate,compose,keys};
}
function exported(d){return {source_sha256:d.ctx.fingerprints,worlds:d.model.worlds,
 goals:d.goals,transitions:d.transitions,slots:d.slots,separate:d.separate,compose:d.compose,keys:d.keys,
 capability:{separate_A:'same first module as every slot call',outside:'Pauli only',
             maximum_separate_A:2,maximum_slots:2,minimum_slots:1,measurements_inside_word:false}};}

function semantics(d,program){
 assert(Array.isArray(program)&&program.length>0);
 const result=Array(16).fill(0);let a=0,f=0,controls=0;
 for(let j=0;j<program.length;j++){
  const op=program[j];let values;
  if(op.kind==='A'){
   assert.deepEqual(op,{kind:'A',source:'resident.first'});a++;values=d.separate;
  }else if(op.kind==='slot'){
   assert(Number.isInteger(op.goal)&&d.goals[op.goal]);
   assert.deepEqual(op,{kind:'slot',goal:op.goal,source:'resident'});f++;
   controls+=d.goals[op.goal].word.length;values=d.slots[op.goal];
  }else{
   assert.equal(j,program.length-1,'Known Paulis are normalized to one terminal correction');
   assert(letters.includes(op.value));assert.deepEqual(op,{kind:'pauli',value:op.value});
   values=Array(16).fill(d.transitions[op.value][0]);controls+=op.value==='I'?0:1;
  }
  for(let i=0;i<16;i++)result[i]=d.compose[values[i]][result[i]];
 }
 assert(a<=2&&f>=1&&f<=2);
 return {profile:result,resources:{A:a,F:f,known_gates:controls}};
}

function validateRoute(d,name,route){
 const r=semantics(d,route.program);assert(d.goals[route.goal]);
 const support=mask(rows(65535).filter(i=>r.profile[i]===route.goal));
 assert.equal(route.support,support,'Complete applicability set, not a selected source');
 assert.deepEqual(route.resources,r.resources);
 assert.equal(name,'route:'+base.digest(JSON.stringify([route.goal,route.program])).slice(0,24));
 return support;
}

function check(directory){
 const d=current(),proposal=JSON.parse(fs.readFileSync(path.join(directory,'routes.json')));
 assert.equal(proposal.schema,'vi.same-A-routes.v1');
 assert.deepEqual(proposal.source_sha256,d.ctx.fingerprints);
 assert.deepEqual(JSON.parse(fs.readFileSync(path.join(directory,'source-reading.json'))),exported(d));
 let claims=[],number=0;const proofs=[];
 const eq=(l,r)=>claims.push(base.equation('RoutedClaim'+number++,l,r));
 for(const [name,route]of Object.entries(proposal.actions)){
  claims=[];const before=number;
  const support=validateRoute(d,name,route);
  for(const i of rows(support)){
   let state='RoutedStart',step=0;
   const owner=`FinitePauliTXSource.Row${i}`,prefix=name.slice(6)+'_'+i;
   const gate=(g,sourceTerm)=>{
    const expression=`Routed${g}<${state}>`,alias='Path'+prefix+'_'+step++;
    // Each actual A/B invocation is bound to the same current source row.
    const label=sourceTerm||(['H','S'].includes(g)?'Routed'+g+'Label':'Q'+g);
    claims.push(`public typealias ${alias} = ${expression}\n`);
    eq(alias+'.Left',`Paired<${label}, ${state}>`);state=alias;
   };
   for(const op of route.program){
    if(op.kind==='A')gate(d.model.worlds[i][0],owner+'.A');
    else if(op.kind==='slot'){
     gate(d.model.worlds[i][0],owner+'.A');
     for(const g of d.goals[op.goal].word)gate(g.toUpperCase());
     gate(d.model.worlds[i][1],owner+'.Second');
    }else gate(op.value);
   }
   eq(state+'.Right',expr(d.goals[route.goal].word)+'.Right');
  }
  const source=d.ctx.source+'\n'+claims.join('\n'),verdict=judgeWhereTexts(source);
  assert.equal(verdict.judged,number-before);assert.deepEqual(verdict.refusals,[]);
  const file='Route-'+String(proofs.length).padStart(3,'0')+'.swift';
  fs.writeFileSync(path.join(directory,file),source);
  proofs.push({file,action:name,equalities:number-before,sha256:base.digest(source)});
 }
 // Keep aliases with their obligations; splitting arbitrary lines would lose
 // the preceding derived profile. Each action/source proof stays in a chunk.
 return {actions:Object.keys(proposal.actions).length,equalities:number,source_sha256:d.ctx.fingerprints,proofs};
}
if(require.main===module){
 const [mode,directory]=process.argv.slice(2);
 if(mode==='read')console.log(JSON.stringify(exported(current())));
 else if(mode==='check')console.log(JSON.stringify(check(directory)));
 else throw Error('read | check DIRECTORY');
}
module.exports={current,exported,semantics,validateRoute,check};
