// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),os=require('node:os');
const {spawnSync}=require('node:child_process');
const {createHash}=require('node:crypto');
const court=require('./routed_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.resolve(path.join(root,'Checks/Archive/WhereV2/judge-where.js')));
const directory=process.argv[2],d=court.current();
const routes=JSON.parse(fs.readFileSync(path.join(directory,'routes.json'))).actions;
const h=d.goals.find(g=>JSON.stringify(g.word)==='["h"]').id;
const [id,route]=Object.entries(routes).find(([id,r])=>r.goal===h&&r.resources.A===1&&(r.support&1));
const rejected=[];
function reject(name,mutate){
 const r=structuredClone(route);mutate(r);
 // Give the forged program its correct content address. A stale hash must
 // not be the only reason that a false source/support/resource claim fails.
 const address='route:'+createHash('sha256').update(JSON.stringify([r.goal,r.program])).digest('hex').slice(0,24);
 assert.throws(()=>court.validateRoute(d,address,r));rejected.push(name);
}
reject('an independently named A substituted for the resident first',r=>r.program.find(o=>o.kind==='A').source='another.first');
reject('turning a restricted support into all sources',r=>r.support=65535);
reject('discarding an applicable source instead of reporting the full support',r=>r.support&=r.support-1);
reject('omitting the real reentry call',r=>r.program=r.program.filter(o=>o.kind!=='A'));
reject('exchanging the middle contact while retaining the old claim',r=>r.program.find(o=>o.kind==='slot').goal=(r.program.find(o=>o.kind==='slot').goal+1)%24);
reject('unaccounted extra standalone calls',r=>r.program.unshift({kind:'A',source:'resident.first'},{kind:'A',source:'resident.first'}));
reject('falsely reduced access price',r=>r.resources.A=0);
reject('free external H smuggled into the Pauli interface',r=>r.program.push({kind:'pauli',value:'H'}));
const build=JSON.parse(fs.readFileSync(path.join(directory,'build.json')));
const proof=build.certificate.proofs.find(p=>p.action===id),source=fs.readFileSync(path.join(directory,proof.file),'utf8');
let step=0;
for(const op of route.program){if(op.kind==='A')break;step+=op.kind==='slot'?2+d.goals[op.goal].word.length:1;}
const old=`public typealias Path${id.slice(6)}_0_${step} = RoutedI<`;
assert(source.includes(old));
const wrong=source.replace(old,old.replace('RoutedI<','RoutedX<'));
const verdict=judgeWhereTexts(wrong);assert(verdict.refusals.length);rejected.push('JS: actual standalone X cannot claim the current I source');
const tmp=fs.mkdtempSync(path.join(os.tmpdir(),'vi-same-A-'));
try{
 const file=path.join(tmp,'WrongA.swift');fs.writeFileSync(file,wrong);
 const r=spawnSync(path.join(root,'.build/arm64-apple-macosx/debug/Tools'),['judge','where',file],{encoding:'utf8',timeout:30000});
 assert.equal(r.status,1);assert(/requires the types/.test(r.stdout+r.stderr));rejected.push('native: same falsely bound source fails');
}finally{fs.rmSync(tmp,{recursive:true,force:true});}
console.log(JSON.stringify({count:rejected.length,rejected,
 auditor_sha256:createHash('sha256').update(fs.readFileSync(__filename)).digest('hex')}));
