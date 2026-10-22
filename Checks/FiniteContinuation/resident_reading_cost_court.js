// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),orientation=require('./resident_orientation_word_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'Checks/Archive/WhereV2/judge-where.js'));
function context(){const c=orientation.context(),n='Sources/Examples/ResidentReadingCost.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function read(c){const prior=orientation.read(orientation.context());const single=[0,1].map(b=>({votes:[b],answer:Number(base.reading(c,'ResidentReadingCostRoot.Single.'+(b?'Right':'Left'),['QBit0','QBit1']).slice(-1))}));
 const candidates={Single:single,...prior.policy.policies};return{schema:'vi.resident-reading-cost.v1',source_sha256:c.fingerprints,orientation:prior,candidates,
  report_counts:Object.fromEntries(Object.entries(candidates).map(([name,rows])=>{assert(rows.every(r=>r.votes.length==rows[0].votes.length));return[name,rows[0].votes.length];})),
  scope:'Choose one or three actual reports per logical step in complete three-step words; target is the final quantum output after report fields are cleared.'};}
function build(directory){const c=context(),reading=read(c);let claims='';for(let b=0;b<2;b++){assert.equal(reading.candidates.Single[b].answer,b);claims+=base.equation('SingleReading'+b,'ResidentReadingCostRoot.Single.'+(b?'Right':'Left'),'QBit'+b);}
 const proof=c.source+'\n'+claims,r=judgeWhereTexts(proof);assert.equal(r.judged,2);assert.deepEqual(r.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentReadingCost.swift'),proof);
 const text=c.source+'\n'+base.equation('RejectedReadingCost','ResidentReadingCostRoot.Single.Left','ResidentReadingCostRoot.Single.Right');assert(judgeWhereTexts(text).refusals.length);
 fs.writeFileSync(path.join(directory,'RejectedReadingCost.swift'),text);fs.writeFileSync(path.join(directory,'cost-reading.json'),JSON.stringify(reading,null,2)+'\n');
 return{equalities:2,negatives:[{name:'a report cannot be replaced by its opposite',file:'RejectedReadingCost.swift'}],source_sha256:c.fingerprints};}
if(require.main===module){const[mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build};
