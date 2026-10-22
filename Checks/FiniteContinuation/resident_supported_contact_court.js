// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),completion=require('./resident_completion_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'Checks/Archive/WhereV2/judge-where.js'));
function context(){const c=completion.context(),n='Sources/Examples/ResidentSupportedContact.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function bit(c,t){return Number(base.reading(c,t,['QBit0','QBit1']).slice(-1));}
function read(c){
 const prior=completion.read(completion.context()),rows=[];
 for(let b=0;b<2;b++){
  const t='ResidentSupportedContactRoot';
  rows.push({first:bit(c,`${t}.At${b}.Reply`),next:bit(c,`${t}.At${b}.After.Reply`),
   first_relative:bit(c,`${t}.First${b}.Relative`),next_contact_reply:bit(c,`${t}.Next${b}.Reply`),
   final_relative:bit(c,`${t}.Next${b}.After.Relative`),completion:bit(c,`${t}.Completed${b}`)});
 }
 return{schema:'vi.resident-supported-contact.v1',source_sha256:c.fingerprints,completion:prior,rows,
  scope:'Support transitions of the owned M-read/flip, E-only-payload constructor; no guarantee for arbitrary three-wire service gates.'};
}
function build(directory){
 const c=context(),reading=read(c);let claims='',count=0;const eq=(a,b)=>claims+=base.equation('SupportedContact'+count++,a,b),t='ResidentSupportedContactRoot';
 for(let b=0;b<2;b++){
  eq(`${t}.At${b}.After.Reply`,`${t}.Next${b}.Reply`);
  eq(`${t}.At${b}.After.After.Reply`,`${t}.At${b}.Reply`);
  eq(`${t}.Completed${b}`,`${t}.Source.Target`);
  eq(`${t}.Next${b}.After.Relative`,'QBit1');
  eq(`${t}.First${b}.First`,`${t}.At${b}.Reply`);
  eq(`${t}.At${b}.PayloadPort`,`${t}.Source.Contact.Left`);
  eq(`${t}.At${b}.After.PayloadPort`,`${t}.At${b}.PayloadPort`);
 }
 eq(`${t}.SelectorPort`,`${t}.Source.RetainedMemory`);
 // The reply/support relation does not require identifying the E payload.
 eq('ResidentSupportedAt0<ResidentDataPort>.After.Reply','ResidentSupportedAt0<ResidentServicePort>.After.Reply');
 const proof=c.source+'\n'+claims,result=judgeWhereTexts(proof);assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 const bad=[['unchanged selector is not the constructed next support',`${t}.At0.After.Reply`,`${t}.At0.Reply`],
 ['first acquisition does not already complete the goal','ResidentCompletionFlag<ResidentSupportedContactRoot.First1>',`${t}.Source.Target`],
 ['environment payload cannot be relocated onto selector',`${t}.PayloadPort`,`${t}.SelectorPort`]];
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentSupportedContact.swift'),proof);
 const negatives=bad.map(([name,a,b],i)=>{const text=c.source+'\n'+base.equation('RejectedSupportedContact',a,b),v=judgeWhereTexts(text);assert.equal(v.judged,1);assert(v.refusals.length);const file=`RejectedSupportedContact-${i}.swift`;fs.writeFileSync(path.join(directory,file),text);return{name,file};});
 fs.writeFileSync(path.join(directory,'support-reading.json'),JSON.stringify(reading,null,2)+'\n');
 return{equalities:count,negatives,source_sha256:c.fingerprints,proof_sha256:base.digest(proof)};
}
if(require.main===module){const[mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
