"use strict";
// Source of the environment's finite semantics remains the current Swift
// constructions. This adapter also checks the finite controller by induction
// over its complete belief graph; it is not a second Swift parser.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),renewal=require('./renewal_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(process.env.VI_WHERE_JUDGE||path.join(root,'../gate/bin/judge-where.js')));
const rows=m=>Array.from({length:16},(_,i)=>i).filter(i=>(m>>i)&1);
const mask=xs=>xs.reduce((m,i)=>m|(1<<i),0);
const same=(a,b)=>JSON.stringify(a)===JSON.stringify(b);

function current(){
  const data=renewal.current(),reading=renewal.exported(data);
  // A complemented column gives the same partition, but its native sign is
  // retained. The executor must measure the specified, unnormalized bit.
  const distinct=new Map();
  for(const p of [...data.probes].sort((a,b)=>a.control_gates-b.control_gates||a.id.localeCompare(b.id))){
    const s=p.replies.join(''),t=p.replies.map(b=>1-b).join('');
    if(!distinct.has(s<t?s:t))distinct.set(s<t?s:t,p);
  }
  data.offered=[...distinct.values()];
  reading.probes=data.offered.map(({applications,ideal,...p})=>p);
  data.tasks=[{id:'phase',family:'X^t Rz(theta)',answers:data.keys.map(k=>'key:'+k.join('')),
    expressions:data.keys.map((_,i)=>`Paired<FinitePauliTXSource.Row${i}.NX, Paired<FinitePauliTXSource.Row${i}.NZ, FinitePauliTXSource.Row${i}.A.ForZ>>`)}];
  const seen=new Set();
  for(const p of data.probes){
    const name=p.middle.join(',');if(seen.has(name))continue;seen.add(name);
    const expressions=p.applications.map(a=>a.application+'.Right');
    const answers=expressions.map(e=>'pauli:'+base.reading(data.ctx,e,['QI','QX','QY','QZ']).slice(1));
    data.tasks.push({id:'clifford:'+name,middle:p.middle,answers,expressions,applications:p.applications});
  }
  reading.tasks=data.tasks.map(({expressions,applications,...t})=>t);
  return {data,reading};
}

function graph(reading){
  const split=new Map(reading.probes.map(p=>[p.id,[mask(rows(65535).filter(i=>p.replies[i]===0)),mask(rows(65535).filter(i=>p.replies[i]===1))]]));
  const edges={};for(const [name,changes] of Object.entries(reading.profiles)){
    edges[name]=rows(65535).map(i=>mask(reading.edges.filter(e=>e.before===i&&changes.some(d=>same(d,e.delta))).map(e=>e.after)));
  }
  const seen=new Set([65535]),todo=[65535],transitions={};
  for(let n=0;n<todo.length;n++){
    const m=todo[n],next={};
    for(const [name,es] of Object.entries(edges))next[name]=rows(m).reduce((a,i)=>a|es[i],0);
    transitions[m]=next;
    for(const v of [...Object.values(next),...[...split.values()].flatMap(bs=>bs.map(b=>b&m))]){
      if(v&&!seen.has(v)){seen.add(v);todo.push(v);}
    }
  }
  return {states:[...seen].sort((a,b)=>rows(a).length-rows(b).length||a-b),split,transitions};
}

function validate(reading,bundle){
  assert.equal(bundle.schema,'vi.continuing-environment.v1');
  assert.deepEqual(bundle.source_sha256,reading.source_sha256);
  assert.deepEqual(bundle.contacts,reading.probes.map(({replies,...p})=>p),'Native ports cannot be substituted');
  assert.deepEqual(bundle.changes,reading.profiles,'Change scope must not be narrowed');
  const g=graph(reading);assert.deepEqual(bundle.states,g.states);
  assert.deepEqual(bundle.transitions,g.transitions,'Use the whole relational image');
  const groups=new Map();
  for(const t of reading.tasks){const signature=JSON.stringify(t.answers);if(!groups.has(signature))groups.set(signature,'c'+groups.size);}
  const requests=Object.fromEntries(reading.tasks.map(t=>[t.id,{class:groups.get(JSON.stringify(t.answers)),...(t.middle?{middle:t.middle}:{family:t.family})}]));
  assert.deepEqual(bundle.requests,requests,'The recipient question selects the applicability class');
  assert.deepEqual(Object.keys(bundle.policies).sort(),[...groups.values()].sort());
  let checked=0;
  for(const [signature,id] of groups){
    const answers=JSON.parse(signature),policy=bundle.policies[id],cost={};
    assert.deepEqual(Object.keys(policy).sort(),g.states.map(String).sort());
    for(const m of g.states){
      const node=policy[m],values=[...new Set(rows(m).map(i=>answers[i]))];
      if(values.length===1){
        assert.deepEqual(node,{kind:'act',action:values[0],depth:0});cost[m]=0;
      }else{
        const candidates=[...g.split.entries()].filter(([_,bs])=>bs.every(b=>(b&m)!==0));
        const minimum=1+Math.min(...candidates.map(([_,bs])=>Math.max(...bs.map(b=>cost[b&m]))));
        assert.equal(node.kind,'probe');assert(g.split.has(node.probe));
        const bs=g.split.get(node.probe).map(b=>b&m);
        assert(bs.every(b=>b&&b!==m));assert.deepEqual(node.next,bs);
        assert.equal(node.depth,minimum,'A shorter admissible probe policy exists');
        assert.equal(node.depth,1+Math.max(...bs.map(b=>cost[b])));cost[m]=minimum;
      }
      checked++;
    }
  }
  return {states:g.states.length,policy_nodes:checked,change_transitions:g.states.length*Object.keys(reading.profiles).length};
}

function certificates(data){
  const claims=[];let n=0;
  const eq=(l,r)=>claims.push(base.equation('Environment'+n++,l,r));
  // Shared answer fibers, certified once. Every run-time family must be a
  // subset of the chosen fiber; validate() checks that for EVERY graph state.
  for(const task of data.tasks){
    for(let i=0;i<16;i++){
      const value=task.answers[i],row=`FinitePauliTXSource.Row${i}`;
      const term=value.startsWith('key:')?`Paired<QBit${value[4]}, Paired<QBit${value[5]}, QBit${value[6]}>>`:'Q'+value.slice(6);
      if(task.applications){const a=task.applications[i];eq(a.application+'.Left',`Paired<${row}.Second, ${a.frame}>`);}
      eq(task.expressions[i],term);
    }
  }
  for(const p of data.offered){
    eq(p.ideal.expression,p.ideal.value);
    for(let i=0;i<16;i++){
      const a=p.applications[i];eq(a.application+'.Left',`Paired<FinitePauliTXSource.Row${i}.Second, ${a.frame}>`);
      eq(a.bit,'QBit'+p.replies[i]);
    }
  }
  for(const e of data.edges){
    const before=`FinitePauliTXSource.Row${e.before}`,after=`FinitePauliTXSource.Row${e.after}`;
    eq(`Paired<${e.a}.Left, ${e.b}.Left>`,`Paired<Paired<Q${e.delta[0]}, ${before}.A>, Paired<Q${e.delta[1]}, ${before}.Second>>`);
    eq(`Paired<${e.a}.Right, ${e.b}.Right>`,`Paired<${after}.A, ${after}.Second>`);
  }
  return claims;
}

function check(directory){
  const {data,reading}=current(),bundle=JSON.parse(fs.readFileSync(path.join(directory,'controller.json')));
  assert.deepEqual(JSON.parse(fs.readFileSync(path.join(directory,'source-reading.json'))),reading);
  const graphCheck=validate(reading,bundle),claims=certificates(data),proofs=[];
  for(let i=0;i<claims.length;i+=128){
    const chunk=claims.slice(i,i+128),source=data.ctx.source+'\n'+chunk.join('\n');
    const verdict=judgeWhereTexts(source);assert.equal(verdict.judged,chunk.length);assert.deepEqual(verdict.refusals,[]);
    const name='basis-'+String(proofs.length).padStart(2,'0')+'.swift';fs.writeFileSync(path.join(directory,name),source);
    proofs.push({name,sha256:base.digest(source),equalities:verdict.judged});
  }
  return {graph:graphCheck,proofs,equalities:claims.length};
}
if(require.main===module){
  const [mode,directory]=process.argv.slice(2);
  if(mode==='read')console.log(JSON.stringify(current().reading));
  else if(mode==='check')console.log(JSON.stringify(check(directory)));
  else throw Error('read | check DIRECTORY');
}
module.exports={current,graph,validate,certificates,check};
