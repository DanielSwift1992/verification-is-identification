"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),os=require('node:os');
const {spawnSync}=require('node:child_process');
const court=require('./environment_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(process.env.VI_WHERE_JUDGE||path.join(root,'../gate/bin/judge-where.js')));
const directory=process.argv[2];
const {reading}=court.current();
const original=JSON.parse(fs.readFileSync(path.join(directory,'controller.json')));
const checked=[];
function reject(name,mutate){
  const b=structuredClone(original);mutate(b);
  assert.throws(()=>court.validate(reading,b),undefined,name);checked.push(name);
}
reject('narrowed reachable current family',b=>{b.transitions['65535'].arbitrary=1;});
reject('undeclared individual-module access',b=>{b.contacts[0].id='A:Z:Z';});
reject('different native middle contact',b=>{b.contacts[0].middle=['h','h'];});
reject('weakened recipient question',b=>{b.requests.phase.class=b.requests['clifford:'].class;});
reject('stale current-source hash',b=>{b.source_sha256[Object.keys(b.source_sha256)[0]]='0'.repeat(64);});
reject('omitted reachable state',b=>{b.states.pop();});
reject('changed relation hidden under the same name',b=>{b.changes.arbitrary=[['I','I']];});
const phase=original.requests.phase.class;
reject('returning a key without sufficient evidence',b=>{b.policies[phase]['65535']={kind:'act',action:'key:000',depth:0};});
reject('wrong current-source branch',b=>{b.policies[phase]['65535'].next.reverse();});
reject('incorrect acquisition bound',b=>{b.policies[phase]['65535'].depth=2;});
reject('detached continuation on a singleton',b=>{b.policies[phase]['1'].action='key:111';});
reject('missing controller family',b=>{delete b.policies[phase]['1'];});
// Both actual judges must reject a changed equality, not just JSON validation.
const basis=fs.readFileSync(path.join(directory,'basis-00.swift'),'utf8');
const old='LocalCourtSame<Paired<FinitePauliTXSource.Row0.NX, Paired<FinitePauliTXSource.Row0.NZ, FinitePauliTXSource.Row0.A.ForZ>>, Paired<QBit0, Paired<QBit0, QBit0>>>';
assert(basis.includes(old));
const wrong=basis.replace(old,old.replace('Paired<QBit0, Paired<QBit0, QBit0>>>','Paired<QBit1, Paired<QBit0, QBit0>>>'));
const verdict=judgeWhereTexts(wrong);assert(verdict.refusals.length>0);checked.push('JS rejects false source-key equality');
const tmp=fs.mkdtempSync(path.join(os.tmpdir(),'vi-environment-refusal-'));
try{
  const file=path.join(tmp,'WrongBasis.swift');fs.writeFileSync(file,wrong);
  const r=spawnSync(path.join(root,'.build/arm64-apple-macosx/debug/Tools'),['judge','where',file],{encoding:'utf8',timeout:30000});
  assert.equal(r.status,1);assert(/requires the types/.test(r.stdout+r.stderr));
  checked.push('native rejects false source-key equality');
}finally{fs.rmSync(tmp,{recursive:true,force:true});}
console.log(JSON.stringify({rejected:checked,count:checked.length}));
