// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
// Apply a proposed finite word to the actual current Swift successor. Integer
// counts/observable semantics and optimality are proved in the companion layer.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const old=require('./orbit_return_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'Checks/Archive/WhereV2/judge-where.js'));
function check(payload,directory){
 const c=old.context(),source=old.read(c);assert.deepEqual(payload.source,source,'Must use the actual current root');
 assert.equal(new Set(source.rows.map(r=>JSON.stringify(r))).size,8);
 let claims='',count=0;
 const eq=(a,b)=>claims+=base.equation('OrbitFuture'+count++,a,b);
 function visits(s,powers){
  let at=s,steps=0;const result=[];
  for(const k of powers){
   assert(Number.isInteger(k)&&k>=0&&k<4);
   result.push({at,expression:`OrbitReturnRoot.Row${s}`+'.Next'.repeat(steps)+'.Law'});
   for(let j=0;j<k;j++)at=source.successor[at];steps+=k;
  }
  assert.equal(at,s,'Actual source must return');
  eq(`OrbitReturnRoot.Row${s}`+'.Next'.repeat(steps),`OrbitReturnRoot.Row${s}`);
  return result.sort((a,b)=>a.at-b.at).map(x=>x.expression);
 }
 const chain=xs=>xs.reduceRight((tail,x)=>`Paired<${x}, ${tail}>`,'Never');
 for(const plan of Object.values(payload.plans)){
  const paths=Array.from({length:8},(_,s)=>visits(s,plan.powers));
  for(const [s,t] of plan.question_edges){
   assert(s>=0&&s<8&&t>=0&&t<8&&s!==t);
   assert.equal(source.rows[s].Control,source.rows[t].Control);
   eq(chain(paths[s]),chain(paths[t]));
  }
 }
 const proof=c.source+'\n'+claims,result=judgeWhereTexts(proof);
 assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 // The short two-orbit word preserves B coherence but not C coherence.
 const left='Paired<OrbitReturnRoot.Row0.Law, Paired<OrbitReturnRoot.Row0.Next.Next.Law, Never>>';
 const right='Paired<OrbitReturnRoot.Row1.Law, Paired<OrbitReturnRoot.Row1.Next.Next.Law, Never>>';
 const bad=c.source+'\n'+base.equation('BadOrbitFuture',left,right),refused=judgeWhereTexts(bad);
 assert.equal(refused.judged,1);assert(refused.refusals.length);
 if(directory){fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'OrbitFuture.swift'),proof);
  fs.writeFileSync(path.join(directory,'RejectedOrbitFuture.swift'),bad);}
 return {equalities:count,expected_rejections:1,source_sha256:source.source_sha256,
  scope:'Actual successor return and requested visit-multiset equalities; not a full Swift build or physical oracle certification.'};
}
if(require.main===module)console.log(JSON.stringify(check(JSON.parse(fs.readFileSync(process.argv[2],'utf8')),process.argv[3])));
module.exports={check};
