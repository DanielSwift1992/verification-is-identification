// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
// Conditional refresh from an old key and an explicitly declared change
// relation. The physical change relation is NOT inferred from its profile name.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),contact=require('./contact_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(path.join(root,'Checks/Archive/WhereV2/judge-where.js')));
const letters=['I','X','Y','Z'];
const profiles={
  known_A_X:[['X','I']],
  paired_Z:[['I','I'],['Z','Z']],
  same_Pauli:letters.map(d=>[d,d]),
  A_only:letters.map(d=>[d,'I']),
  B_only:letters.map(d=>['I',d]),
  one_unspecified_module:[...letters.map(d=>[d,'I']),...letters.slice(1).map(d=>['I',d])],
  arbitrary:letters.flatMap(a=>letters.map(b=>[a,b]))};
const literal=k=>`Paired<QBit${k[0]}, Paired<QBit${k[1]}, QBit${k[2]}>>`;
const row=i=>`FinitePauliTXSource.Row${i}`;
const keyExpression=i=>`Paired<${row(i)}.NX, Paired<${row(i)}.NZ, ${row(i)}.A.ForZ>>`;

function current(){
  const ctx=contact.context(),model=base.sourceModel(ctx);
  const probes=contact.closure(ctx).flatMap(c=>['X','Y','Z'].map(a=>contact.composed(ctx,model,c.word,a)));
  const column=id=>model.probes.find(p=>p.id===id).replies;
  const q=column('neutral:X:X'),p=column('neutral:Z:Z'),u=column('A:Z:Z');
  const keys=model.worlds.map((_,i)=>[q[i],p[i],u[i]]),edges=[];
  for(let i=0;i<16;i++)for(const a of letters)for(const b of letters){
    const ae=`PauliContact${a}<${row(i)}.A>`,be=`PauliContact${b}<${row(i)}.Second>`;
    const pair=[ae,be].map(e=>base.reading(ctx,e+'.Right',letters.map(l=>'Q'+l)).slice(1));
    const j=model.worlds.findIndex(w=>JSON.stringify(w)===JSON.stringify(pair));assert(j>=0);
    edges.push({before:i,after:j,delta:[a,b],a:ae,b:be});
  }
  return {ctx,model,probes,keys,edges};
}
function exported(data){
  const {ctx,model,probes,keys,edges}=data;
  return {source_sha256:ctx.fingerprints,worlds:model.worlds,keys,
    profiles,edges:edges.map(({a,b,...e})=>e),
    probes:probes.map(({applications,ideal,...q})=>q)};
}
function reachable(data,profile,oldKey){
  assert(profiles[profile]);
  assert(Array.isArray(oldKey)&&oldKey.length===3&&oldKey.every(b=>b===0||b===1));
  const old=data.keys.flatMap((k,i)=>JSON.stringify(k)===JSON.stringify(oldKey)?[i]:[]);
  assert.equal(old.length,2);
  const allowed=new Set(profiles[profile].map(d=>d.join('')));
  const edges=data.edges.filter(e=>old.includes(e.before)&&allowed.has(e.delta.join('')));
  return {old,edges,family:[...new Set(edges.map(e=>e.after))].sort((a,b)=>a-b)};
}
function check(data,proposal){
  assert.equal(proposal.schema,'vi.phase-key-renewal.v1');
  assert.equal(proposal.request,'refresh full monomial recovery key');
  assert.deepEqual(proposal.source_sha256,data.ctx.fingerprints);
  const scope=reachable(data,proposal.profile,proposal.old_key);
  assert.deepEqual(proposal.allowed_changes,profiles[proposal.profile],'Change relation cannot be narrowed');
  assert.deepEqual(proposal.old_family,scope.old);
  assert.deepEqual(proposal.family,scope.family,'All reachable current sources are required');
  assert.deepEqual(proposal.plan.initial,scope.family,'Plan must start from the actual current family');
  const probes=new Map(data.probes.map(p=>[p.id,p]));
  const leaves=new Map(),paths=new Map();let claims='';
  for(const i of scope.family){
    let node=proposal.plan.tree,trace=[],values=[],path='root',seen=new Set();
    while(node.kind==='probe'){
      assert(probes.has(node.probe));assert(!seen.has(node.probe),'Repeated ideal probe adds no evidence');
      seen.add(node.probe);assert(seen.size<=9,'Bounded fresh-key search');
      const probe=probes.get(node.probe),bit=probe.replies[i];
      trace.push(probe.applications[i].bit);values.push(`QBit${bit}`);
      assert.deepEqual(Object.keys(node.branches).sort(),['0','1']);
      node=node.branches[String(bit)];path+=String(bit);
    }
    assert.equal(node.kind,'act');assert(/^key:[01]{3}$/.test(node.action));
    const key=node.action.slice(4).split('').map(Number);
    if(!leaves.has(path)){
      const name=`RefreshLeaf${leaves.size}`;
      const spelling=`Paired<${base.chain(values)}, ${literal(key)}>`;
      leaves.set(path,{name,spelling});claims+=`public typealias ${name} = ${spelling}\n`;
    }
    assert.equal(leaves.get(path).spelling,`Paired<${base.chain(values)}, ${literal(key)}>`);
    paths.set(i,{trace,leaf:leaves.get(path).name});
  }
  scope.edges.forEach((e,n)=>{
    const reached=paths.get(e.after);
    claims+=base.equation(`RenewalEdge${n}`,
      `Paired<${keyExpression(e.before)}, Paired<Paired<${e.a}.Right, ${e.b}.Right>, Paired<${base.chain(reached.trace)}, ${keyExpression(e.after)}>>>`,
      `Paired<${literal(proposal.old_key)}, Paired<Paired<${row(e.after)}.A, ${row(e.after)}.Second>, ${reached.leaf}>>`);
  });
  const source=data.ctx.source+'\n'+claims,verdict=judgeWhereTexts(source);
  assert.equal(verdict.judged,scope.edges.length);assert.deepEqual(verdict.refusals,[]);
  return {source,verdict,source_sha256:data.ctx.fingerprints,certificate_sha256:base.digest(source)};
}
if(require.main===module){
  const [mode,file,out]=process.argv.slice(2),data=current();
  if(mode==='read')console.log(JSON.stringify(exported(data)));
  else if(mode==='check'){
    const {source,...r}=check(data,JSON.parse(fs.readFileSync(file,'utf8')));
    fs.writeFileSync(out,source);console.log(JSON.stringify(r));
  }else throw Error('read | check proposal.json Applications.swift');
}
module.exports={current,exported,reachable,check,profiles};
