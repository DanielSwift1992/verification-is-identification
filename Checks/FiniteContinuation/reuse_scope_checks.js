"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const court=require('./reuse_scope_court.js'),base=require('./court_bridge.js');
const [file,out]=process.argv.slice(2),original=JSON.parse(fs.readFileSync(file,'utf8'));
const data=court.current(),refusals=[];
function reject(name,change){
  const proposal=structuredClone(original);change(proposal);
  assert.throws(()=>court.check(data,proposal),undefined,name);refusals.push(name);
}
assert.equal(court.check(data,original).verdict.judged,32);
reject('one source omitted from a retained pair',p=>p.cells['000'].family.pop());
reject('terminal answer substituted for the live consumer',p=>p.request.consumer='terminal');
reject('unproved expansion to every unitary',p=>p.request.family='all U(2)');
reject('wrong unknown first-module bit',p=>p.cells['000'].key[2]^=1);
reject('neutral frame bit lost',p=>p.cells['000'].key[1]^=1);
reject('acquisition cell omitted',p=>delete p.cells['001']);
reject('another acquired family reused under this key',p=>p.cells['000'].family=p.cells['001'].family);
reject('stale source fingerprint',p=>p.source_sha256['Sources/Examples/FinitePauliTSource.swift']='stale');
// A future source edit cannot be masked by updating only the fingerprint.
const changed={...data,ctx:{...data.ctx,source:data.ctx.source.replace('public typealias ForZ = QBit0','public typealias ForZ = QBit1')}};
assert.notEqual(changed.ctx.source,data.ctx.source);
assert.throws(()=>court.check(changed,original));refusals.push('changed current fields refuse the old key');
const verdict=court.check(data,original);
// The native court independently refuses a changed shared key too.
const forged=verdict.source.replace(
  'public enum ReusableMemory000: Pair {\n public typealias Left = Paired<QBit0, Paired<QBit0, QBit0>>\n public typealias Right = Paired<QBit0, Paired<QBit0, QBit0>>',
  'public enum ReusableMemory000: Pair {\n public typealias Left = Paired<QBit0, Paired<QBit0, QBit0>>\n public typealias Right = Paired<QBit0, Paired<QBit0, QBit1>>');
assert.notEqual(forged,verdict.source);
fs.writeFileSync(path.join(path.dirname(out),'WrongKey.swift'),forged);
const {spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'../..');
const native=spawnSync(path.join(root,'.build/arm64-apple-macosx/debug/Tools'),
  ['judge','where',path.join(path.dirname(out),'WrongKey.swift')],{encoding:'utf8',timeout:10000});
const diagnostic=native.stdout+native.stderr;
assert.equal(native.status,1);
assert(diagnostic.includes('ReusableKey0')&&diagnostic.includes('ReusableKey15')&&diagnostic.includes('requires the types'));
refusals.push('native court rejects changed common key');
const report={positive_equalities:32,refusals,native_refusal:diagnostic.trim(),
              source_sha256:verdict.source_sha256,certificate_sha256:base.digest(verdict.source)};
fs.writeFileSync(out,JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
