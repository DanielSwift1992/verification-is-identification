"use strict";
const fs=require('node:fs'),path=require('node:path'),os=require('node:os');
const assert=require('node:assert/strict'),{spawnSync}=require('node:child_process');
const court=require('./contact_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const ctx=court.context(),model=base.sourceModel(ctx);
const original=JSON.parse(fs.readFileSync(process.argv[2],'utf8'));
const good=court.check(ctx,original);assert.equal(good.verdict.judged,10);
const refused=[];
function reject(name,mutate){const p=structuredClone(original);mutate(p);assert.throws(()=>court.check(ctx,p));refused.push(name);}
reject('missing original source row',p=>p.family.pop());
reject('old record belongs to another fiber',p=>p.old_memory[0]^=1);
reject('different target question',p=>p.request.axis='Z');
reject('individual module bypass was not granted',p=>p.contact.path='A');
reject('ungranted middle primitive',p=>p.contact.middle=['t']);
reject('middle changed behind the old native descriptor',p=>p.contact.middle=['h']);
reject('control moved outside the middle slot',p=>p.contact.placement='before-A');
reject('reply fiber narrowed to a convenient source',p=>p.branches['0'].family.pop());
reject('wrong common continuation with matching execution label',p=>{
  p.branches['0'].action='read:-1:X';p.branches['0'].execution=base.actions['read:-1:X'];
});
reject('a fully rebound H contact still cannot resolve this question',p=>{
  const q=court.composed(ctx,model,['h'],'X'),{applications,ideal,replies,...descriptor}=q;
  p.contact=descriptor;
  for(const bit of ['0','1'])p.branches[bit].family=p.family.filter(i=>String(replies[i])===bit);
});
const changed={...ctx,source:ctx.source.replace('public typealias Answer = Paired<QuantumMeasureXQuestion, B.ForX>',
  'public typealias Answer = Paired<QuantumMeasureXQuestion, B.ForX.Flipped>')};
assert.notEqual(changed.source,ctx.source);assert.throws(()=>court.check(changed,original));
refused.push('old continuation after current source answer changes');

// Five S operations describe a longer but equally valid contact. Minimality
// is not smuggled into applicability; the checker accepts this presentation.
const longer=structuredClone(original);
const {applications,ideal,replies,...descriptor}=court.composed(ctx,model,['s','s','s','s','s'],'X');
longer.contact=descriptor;const validLonger=court.check(ctx,longer);
assert.equal(validLonger.verdict.judged,10);

const tmp=fs.mkdtempSync(path.join(os.tmpdir(),'vi-composed-refusals-'));
try{
  const bad=good.source.replace('public typealias ContactReply0 = Paired<QBit0, Paired<QuantumMeasureXQuestion, QBit0>>',
    'public typealias ContactReply0 = Paired<QBit0, Paired<QuantumMeasureXQuestion, QBit1>>');
  assert.notEqual(bad,good.source);
  for(const [name,text,exit] of [['good',good.source,0],['longer',validLonger.source,0],['bad',bad,1]]){
    const file=path.join(tmp,name+'.swift');fs.writeFileSync(file,text);
    const r=spawnSync(path.join(root,'.build/arm64-apple-macosx/debug/Tools'),['judge','where',file],
      {encoding:'utf8',timeout:30000});if(r.error)throw r.error;assert.equal(r.status,exit,r.stdout+r.stderr);
    if(exit)assert.equal(r.stdout.split('\n').filter(s=>s.startsWith('✗ ')).length,2);
    else assert(r.stdout.includes('10 equalities'));
  }
  refused.push('native court rejects wrong common leaf on both retained sources');
}finally{fs.rmSync(tmp,{recursive:true,force:true});}
console.log(JSON.stringify({equalities:10,refused,valid_longer_equivalent_contact_accepted:true},null,2));
