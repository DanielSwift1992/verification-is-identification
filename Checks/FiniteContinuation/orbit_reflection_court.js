"use strict";
// Ordered pair cancellation applies at the actual source addresses. The
// device-square operator law is a separate constructed physical interpretation.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const old=require('./orbit_return_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
function check(payload,directory){
 const c=old.context(),source=old.read(c);assert.deepEqual(source,payload.source);
 let claims='',count=0;const eq=(a,b)=>claims+=base.equation('ReflectionReturn'+count++,a,b);
 const chain=xs=>xs.reduceRight((tail,x)=>`Paired<${x}, ${tail}>`,'Never');
 for(const [relation,plan] of Object.entries(payload.plans)){
  assert.equal(relation,plan.memory_relation);const squareWords=[];
  for(let s=0;s<8;s++){
   let at=s,steps=0;const visits=[],stack=[],pairs=[];
   for(const power of plan.powers){
    assert(Number.isInteger(power)&&power>=0&&power<4);
    visits.push({at,expression:`OrbitReturnRoot.Row${s}`+'.Next'.repeat(steps)+'.Law'});
    for(let k=0;k<power;k++)at=source.successor[at];steps+=power;
   }
   assert.equal(at,s);eq(`OrbitReturnRoot.Row${s}`+'.Next'.repeat(steps),`OrbitReturnRoot.Row${s}`);
   for(let j=0;j<visits.length;j++){
    if(stack.length&&visits[stack.at(-1)].at===visits[j].at)pairs.push([stack.pop(),j]);
    else stack.push(j);
   }
   assert.equal(stack.length,0,'Ordered word has not reduced to local squares');
   assert.deepEqual(pairs,plan.reductions[s].pairs);
   for(const [i,j] of pairs)eq(visits[i].expression,visits[j].expression);
   squareWords.push(pairs.map(([i])=>visits[i]).sort((a,b)=>a.at-b.at).map(x=>x.expression));
  }
  if(relation==='projective_involution'){
   for(let s=0;s<8;s++){
    const reference=source.rows.findIndex(row=>row.Control===source.rows[s].Control);
    if(s!==reference)eq(chain(squareWords[s]),chain(squareWords[reference]));
   }
  }else assert.equal(relation,'exact_involution');
 }
 const proof=c.source+'\n'+claims,result=judgeWhereTexts(proof);assert.equal(result.judged,count);assert.deepEqual(result.refusals,[]);
 const bad=c.source+'\n'+base.equation('SeparatedVisitsAreNotASquare','OrbitReturnRoot.Row0.Law','OrbitReturnRoot.Row0.Next.Law');
 const denied=judgeWhereTexts(bad);assert.equal(denied.judged,1);assert(denied.refusals.length);
 if(directory){fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'ReflectionReturn.swift'),proof);
  fs.writeFileSync(path.join(directory,'RejectedReflectionReturn.swift'),bad);}
 return {equalities:count,expected_rejections:1,source_sha256:source.source_sha256,
  scope:'Actual source return, ordered identical-address pairs, and equal residual square multisets; not a physical proof of U_s squared or a full Swift build.'};
}
if(require.main===module)console.log(JSON.stringify(check(JSON.parse(fs.readFileSync(process.argv[2],'utf8')),process.argv[3])));
module.exports={check};
