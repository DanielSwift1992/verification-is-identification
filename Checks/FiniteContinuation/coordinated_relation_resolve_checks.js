"use strict";
const assert=require("node:assert/strict"),fs=require("node:fs"),path=require("node:path");
const C=require("./coordinated_continuation.js"),R=require("./coordinated_relation_resolve.js");
const {c,z,one,mat,eye,scale,plus,minus,adj,mm,kron,eq}=C.exact;
const e=R.reading;
function goal(relations){return {kind:"source-reading-relations",input:"derived-noncommuting-sector",relations};}
function check(outputDirectory){
  const model=C.currentModel(),{P,Q,Pi,I}=model;
  const serial=C.accessModel([[1,0],[0,1]]),joint=C.accessModel([[1,0],[0,1],[1,1]]);
  const swap=goal([{after:e(["P"]),before:e(["Q"])},{after:e(["Q"]),before:e(["P"])}]);
  assert.equal('targetScore' in swap,false);
  const a=R.resolve(model,swap,serial),b=R.resolve(model,swap,joint);
  const av=R.verify(model,swap,serial,a),bv=R.verify(model,swap,joint,b);
  assert.equal(av.dimension,1);assert.equal(bv.dimension,1);assert.equal(av.minimalSections,3);assert.equal(bv.minimalSections,1);
  const counts={...R.counters};R.verify(model,swap,joint,b);assert.deepEqual(R.counters,counts,"verification must not solve or search again");

  const impossible=goal([{after:e(["P"]),before:e(["P"])},{after:e(["Q"]),before:e(["Q"],[-1,0,1])}]);
  const noUnitary=R.resolve(model,impossible,joint);assert.equal(noUnitary.kind,"inconsistent-unitary-relations");
  assert.equal(R.verify(model,impossible,joint,noUnitary).dimension,0);
  const quarter=goal([{after:e(["P"]),before:e(["P"])},{after:e(["Q"]),before:[
    ...e(["P"],[-1,0,2]),...e(["P","Q"],[0,1,2]),...e(["Q","P"],[0,-1,2])]}]);
  const beyond=R.resolve(model,quarter,joint);assert.equal(beyond.kind,"fixed-access-obstruction");
  assert.equal(R.verify(model,quarter,joint,beyond).dimension,1);
  assert.equal(beyond.normalForms.states.length,6);
  // An analytic partial-P pulse exists outside this fixed-pulse grammar.
  // Its unnormalised numerator I-iP supplies the intertwiner directly.
  const N=plus(I,scale(P,c(0,-1)));
  for(const relation of R.system(model,quarter).relations)
    eq(mm(mm(Pi,scale(mm(mm(adj(N),relation.after),N),c(1,0,2))),Pi),relation.before);

  const partial=goal([{after:e(["P"]),before:e(["P"])}]);
  const many=R.resolve(model,partial,joint);assert.equal(R.verify(model,partial,joint,many).dimension,2);
  assert.equal(R.verify(model,partial,joint,many).minimalSections,0);
  const justP=R.resolve(model,swap,C.accessModel([[1,0]]));assert.equal(justP.kind,"fixed-access-obstruction");

  const wrong=structuredClone(b);wrong.chosen=0;assert.throws(()=>R.verify(model,swap,joint,wrong));
  const fakeKernel=structuredClone(noUnitary);fakeKernel.linear.constraintMinor.inverse[0][0]=C.exact.add(fakeKernel.linear.constraintMinor.inverse[0][0],one);
  assert.throws(()=>R.verify(model,impossible,joint,fakeKernel));
  const fakeClosure=structuredClone(beyond);fakeClosure.normalForms.states[0].transitions[0]=0;
  assert.throws(()=>R.verify(model,quarter,joint,fakeClosure));
  const fakeDistance=structuredClone(a);fakeDistance.normalForms.states[a.chosen].distance=1;
  assert.throws(()=>R.verify(model,swap,serial,fakeDistance));
  assert.throws(()=>R.verify(model,impossible,joint,b));

  // Both programs below are produced from independently declared relations.
  const second=goal([{after:e(["Q"]),before:e(["Q"])},{after:e(["P"]),before:e(["Q","P","Q"])}]);
  const secondSolution=R.resolve(model,second,joint);assert.equal(R.verify(model,second,joint,secondSolution).minimalSections,1);
  const v=mat(16,1);v[2][0]=c(2);v[4][0]=c(-1);v[8][0]=c(-1);v[5][0]=one;v[9][0]=c(-1);
  const supplied=scale(mm(v,adj(v)),c(1,0,8)),live=new R.RelationalBoundary(model,supplied,2);
  const context={kind:"specified-per-section-evolution",background:I,
    questions:[Pi,mm(Pi,P),mm(Pi,Q)],futureActions:[{name:"P",operator:P},{name:"Q",operator:Q}]};
  assert.equal(live.continue(swap,joint,b,context),live);
  assert.equal(live.continue(second,joint,secondSolution,context),live);
  const U=mm(R.verify(model,second,joint,secondSolution).operator,bv.operator),UR=kron(U,eye(2));
  eq(live.rho,mm(mm(UR,supplied),adj(UR)));
  const before=live.rho,count=live.history.length;
  assert.throws(()=>live.continue(swap,joint,wrong,context));
  // A valid control witness does not excuse an unrelated joint background.
  assert.throws(()=>live.continue(swap,joint,b,{...context,background:P}),/actual joint episode/);
  assert.equal(live.rho,before);assert.equal(live.history.length,count);
  // Independent trine oracle. Native exchanges permute the three axes
  // P,Q,-P-Q. Preserving their 120-degree relation permits the negative
  // trine too, but native S3 words never reach that second orientation.
  const axes=[e(["P"]),e(["Q"]),[...e(["P"],[-1,0,1]),...e(["Q"],[-1,0,1])]];
  axes.push(...axes.slice().map(terms=>terms.map(t=>({...t,coefficient:t.coefficient.map((x,i)=>i===0?-x:x)}))));
  const axisActions=[[0,2,1],[2,1,0],[1,0,2]],controlDirections=[[1,0],[0,1],[1,1]];
  let covered=0;
  for(let mask=0;mask<8;mask++){
    const available=controlDirections.filter((_,i)=>(mask>>i)&1);
    const indexActions=axisActions.filter((_,i)=>(mask>>i)&1);
    const reachable=new Map([["0,1,2",0]]),queue=[[0,1,2]];
    for(let k=0;k<queue.length;k++)for(const action of indexActions){
      const next=action.map(i=>queue[k][i]),signature=next.join(',');
      if(!reachable.has(signature)){reachable.set(signature,reachable.get(queue[k].join(','))+1);queue.push(next);}
    }
    for(let i=0;i<6;i++)for(let j=0;j<6;j++){
      const query=goal([{after:e(["P"]),before:axes[i]},{after:e(["Q"]),before:axes[j]}]);
      const outcome=R.resolve(model,query,C.accessModel(available));
      const compatible=Math.floor(i/3)===Math.floor(j/3)&&i%3!==j%3;
      const target=i<3&&j<3?[i,j,3-i-j].join(','):null;
      const distance=target===null?undefined:reachable.get(target);
      if(!compatible)assert.equal(outcome.kind,"inconsistent-unitary-relations");
      else if(distance===undefined)assert.equal(outcome.kind,"fixed-access-obstruction");
      else {assert.equal(outcome.kind,"realization");assert.equal(R.verify(model,query,C.accessModel(available),outcome).minimalSections,distance);}
      covered++;
    }
  }
  let persistedVerifier=null;
  if(outputDirectory){
    fs.mkdirSync(outputDirectory,{recursive:true});persistedVerifier=[];
    for(const [filename,query,resolution]of [
      ['wave-2-relational-certificate.json',swap,b],
      ['wave-2-inconsistent-certificate.json',impossible,noUnitary],
      ['wave-2-access-obstruction.json',quarter,beyond]]){
      const file=path.join(outputDirectory,filename);
      fs.writeFileSync(file,R.serialize({goal:query,access:joint,resolution})+'\n');
      const cp=require('node:child_process').spawnSync(process.execPath,[path.join(__dirname,'coordinated_relation_resolve.js'),file],{encoding:'utf8',timeout:15000});
      assert.equal(cp.status,0,cp.stderr);const verification=JSON.parse(cp.stdout);persistedVerifier.push(verification);
      assert.deepEqual(verification.constructionCalls,{linearSolves:0,normalFormClosures:0});
    }
  }
  return {scope:"Independent reading relations, exact fixed-pulse grammar, no QPU admission",
    independent_goal:swap,intertwiner_dimension:av.dimension,minimum_sections:{serial:av.minimalSections,joint:bv.minimalSections},
    serial_score:av.score,joint_score:bv.score,normal_forms:b.normalForms.states.length,
    inconsistent_relations:noUnitary.kind,available_algebra_but_missing_control:beyond.kind,
    partial_question_intertwiner_dimension:2,partial_question_minimum_sections:0,
    checker_repeats_neither_linear_solve_nor_normal_form_closure:true,
    complete_native_access_obstruction:true,continued_independent_requests:live.history.length,
    admission_rechecks_independent_goal:true,invalid_background_refused_before_mutation:true,
    independent_trine_and_access_cases:covered,persisted_verifier:persistedVerifier,
    negative_checks:7,physical_admission:null};
}
if(require.main===module){const text=JSON.stringify(check(process.argv[2]),null,2)+"\n";if(process.argv[2]){fs.mkdirSync(process.argv[2],{recursive:true});fs.writeFileSync(path.join(process.argv[2],"wave-2-relations.json"),text);}console.log(text);}
module.exports={check};
