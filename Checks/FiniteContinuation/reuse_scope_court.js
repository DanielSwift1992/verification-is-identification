"use strict";
// A finite acquired key for a DIFFERENT consumer: live monomial unitaries.
// These row equalities certify the key; the continuous recovery law is proved
// algebraically in the report, not by giving its name to a Swift protocol.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),contact=require('./contact_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(process.env.VI_WHERE_JUDGE||path.join(root,'../gate/bin/judge-where.js')));
const request={consumer:'live-unitary',family:'X^t Rz(theta)',port:'A middle B'};
const bits=value=>`Paired<QBit${value[0]}, Paired<QBit${value[1]}, QBit${value[2]}>>`;

function current(){
  const ctx=contact.context(),model=base.sourceModel(ctx);
  const inserted=contact.composed(ctx,model,['s'],'X');
  const q=model.probes.find(p=>p.id==='neutral:X:X');
  const p=model.probes.find(p=>p.id==='neutral:Z:Z');
  const observations=model.worlds.map((_,i)=>[q.replies[i],p.replies[i],inserted.replies[i]]);
  return {ctx,model,inserted,observations};
}
function check(data,proposal){
  const {ctx,inserted,observations}=data;
  assert.equal(proposal.schema,'vi.reusable-phase-key.v1');
  assert.deepEqual(proposal.request,request);
  assert.deepEqual(proposal.source_sha256,ctx.fingerprints,'Current source changed');
  const families=new Map();
  observations.forEach((b,i)=>{const k=b.join('');if(!families.has(k))families.set(k,[]);families.get(k).push(i);});
  assert.deepEqual(Object.keys(proposal.cells).sort(),[...families.keys()].sort());
  let claims='';
  for(const [name,indices] of families){
    const cell=proposal.cells[name];
    assert.deepEqual(cell.family,indices,'The full acquired fiber is required');
    assert(Array.isArray(cell.key)&&cell.key.length===3&&cell.key.every(b=>b===0||b===1));
    claims+=`public enum ReusableMemory${name}: Pair {\n`+
      ` public typealias Left = ${bits(observations[indices[0]])}\n`+
      ` public typealias Right = ${bits(cell.key)}\n}\n`;
  }
  for(let i=0;i<16;i++){
    const row=`FinitePauliTXSource.Row${i}`,a=inserted.applications[i],name=observations[i].join('');
    claims+=base.equation(`ReusableContactInput${i}`,a.application+'.Left',`Paired<${row}.Second, ${a.frame}>`);
    claims+=base.equation(`ReusableKey${i}`,
      `Paired<Paired<${row}.NX, Paired<${row}.NZ, ${a.bit}>>, Paired<${row}.NX, Paired<${row}.NZ, ${row}.A.ForZ>>>`,
      `Paired<ReusableMemory${name}.Left, ReusableMemory${name}.Right>`);
  }
  const source=ctx.source+'\n'+claims,verdict=judgeWhereTexts(source);
  assert.equal(verdict.judged,32);assert.deepEqual(verdict.refusals,[]);
  return {source,verdict,source_sha256:ctx.fingerprints,certificate_sha256:base.digest(source)};
}
if(require.main===module){
  const [mode,file,out]=process.argv.slice(2),data=current();
  if(mode==='read')console.log(JSON.stringify({source_sha256:data.ctx.fingerprints,request,
    worlds:data.model.worlds,observations:data.observations}));
  else if(mode==='check'){
    const {source,...report}=check(data,JSON.parse(fs.readFileSync(file,'utf8')));
    fs.writeFileSync(out,source);console.log(JSON.stringify(report));
  }else throw Error('read | check proposal.json Applications.swift');
}
module.exports={current,check,request};
