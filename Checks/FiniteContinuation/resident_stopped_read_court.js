"use strict";
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const base=require('./court_bridge.js'),cost=require('./resident_reading_cost_court.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
function context(){const c=cost.context(),n='Sources/Examples/ResidentStoppedRead.swift',s=fs.readFileSync(path.join(root,n),'utf8');c.source+='\n'+s;c.fingerprints[n]=base.digest(s);return c;}
function tree(rows,prefix=[]){const choices=rows.filter(r=>prefix.every((b,i)=>r.votes[i]===b));assert(choices.length);const answers=[...new Set(choices.map(r=>r.answer))];
 if(answers.length===1)return{prefix,answer:answers[0],completions:choices.map(r=>r.votes)};
 return{prefix,children:[tree(rows,[...prefix,0]),tree(rows,[...prefix,1])]};}
function read(c){const prior=cost.read(cost.context()),candidates={};for(const[name,rows]of Object.entries(prior.candidates)){
 const checked=rows.map(r=>{const term='ResidentStoppedReadRoot.'+name+r.votes.map(b=>b?'.Right':'.Left').join('');const answer=Number(base.reading(c,term,['QBit0','QBit1']).slice(-1));assert.equal(answer,r.answer);return{votes:r.votes,answer};});
 candidates[name]={rows:checked,tree:tree(checked)};}
 return{schema:'vi.resident-stopped-read.v1',source_sha256:c.fingerprints,cost:prior,candidates,
 scope:'Stop only when every completion of the actual prefix has the same current source answer; physical omission needs its own continuation relation.'};}
function leaves(t){return t.children?t.children.flatMap(leaves):[t];}
function build(directory){const c=context(),reading=read(c);let claims='',count=0;for(const[name,v]of Object.entries(reading.candidates))for(const leaf of leaves(v.tree))if(leaf.prefix.length<v.rows[0].votes.length){
 for(const votes of leaf.completions){claims+=base.equation('Prefix'+name+(count++),'ResidentStoppedReadRoot.'+name+votes.map(b=>b?'.Right':'.Left').join(''),'QBit'+leaf.answer);}}
 const proof=c.source+'\n'+claims,r=judgeWhereTexts(proof);assert.equal(r.judged,16);assert.deepEqual(r.refusals,[]);
 fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ResidentStoppedRead.swift'),proof);
 const negatives=[];for(const[name,prefix]of [['Majority',[0]],['AnyOne',[0]],['AllOne',[1]]]){
 const term='ResidentStoppedReadRoot.'+name;const suffix=Array(3-prefix.length).fill(0),other=Array(3-prefix.length).fill(1);
 const a=[...prefix,...suffix],b=[...prefix,...other],text=c.source+'\n'+base.equation('Unfinished'+name,term+a.map(x=>x?'.Right':'.Left').join(''),term+b.map(x=>x?'.Right':'.Left').join(''));
 assert(judgeWhereTexts(text).refusals.length);const file='RejectedStoppedRead-'+name+'.swift';fs.writeFileSync(path.join(directory,file),text);negatives.push({name:'unresolved '+name+' prefix',file});}
 fs.writeFileSync(path.join(directory,'stopped-reading.json'),JSON.stringify(reading,null,2)+'\n');return{equalities:16,negatives,source_sha256:c.fingerprints};}
if(require.main===module){const[mode,directory]=process.argv.slice(2);console.log(JSON.stringify(mode==='read'?read(context()):build(directory)));}
module.exports={context,read,build,tree,leaves};
