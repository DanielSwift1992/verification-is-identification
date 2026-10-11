"use strict";
// Uniform retained-environment conditions at declared cuts of the existing
// probe lowering. Atomic ideal primitives remain an explicit model premise.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const B=require('./coordinated_probe_continuation.js'),Q=require('./coordinated_question_bounds.js');
const E=C.exact,{c,z,one,ii,add,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,eq,isZero}=E;
const key=C.json,counters={programs:0,constructions:0};
const H0=[[one,one],[one,c(-1)]],Z=[[one,z],[z,c(-1)]],P0=[[one,z],[z,z]];
function touch(m){C.verifyPlan(m,{targetScore:[],inputProjector:m.Pi,requiredInteriorCuts:[]},C.accessModel([]),
  {rule:'retain-source-score',source:m.source,score:[]});}
function access(primitives=B.primitiveAccess(),directReadouts=[]){return {kind:'declared-probe-cut-access',primitives,directReadouts:[...directReadouts]};}
function constructProgram(m,name,mode,available){touch(m);counters.programs++;assert(['direct','lowered'].includes(mode));
  const out={kind:'probe-cut-program',source:m.source,name,mode,available:structuredClone(available),
    lowering:mode==='lowered'?B.lowerReadout(m,name,available.primitives):null,physicalAdmission:null};programData(m,out,available);return out;}
function programData(m,program,available){touch(m);assert.equal(program.kind,'probe-cut-program');assert.equal(key(program.source),key(m.source));
  assert.equal(key(program.available),key(available));assert.equal(program.physicalAdmission,null);assert.equal(available.kind,'declared-probe-cut-access');
  const base=B.primitiveAccess();for(const k of ['kind','probePreparation','measurement','reset','permutationEntries'])assert.equal(available.primitives[k],base[k]);
  assert(Array.isArray(available.directReadouts)&&available.directReadouts.every(x=>['P','Q'].includes(x)));assert.equal(new Set(available.directReadouts).size,available.directReadouts.length);
  assert(['P','Q'].includes(program.name));assert(available.primitives.gates.includes('H'));assert.equal(available.primitives.physicalAdmission,null);
  const n=m.I.length,H={matrix:kron(H0,m.I),normSquared:c(2),name:'H-probe'},steps=[H];
  if(program.mode==='direct'){assert.equal(program.lowering,null);assert(available.directReadouts.includes(program.name),'direct coherent control was not declared');
    steps.push({matrix:B.controlled(m[program.name]),normSquared:one,name:`controlled-${program.name}`});
  }else{assert.equal(program.mode,'lowered');B.verifyReadout(m,program.name,available.primitives,program.lowering);
    for(const g of program.lowering.word)steps.push({matrix:B.gateOperator(g,1+Math.log2(n),available.primitives),normSquared:one,name:g.kind});}
  steps.push(H);steps.forEach(s=>eq(mm(adj(s.matrix),s.matrix),scale(eye(2*n),s.normSquared)));
  const unnormalized=steps.reduce((U,s)=>mm(s.matrix,U),eye(2*n)),operator=scale(unnormalized,c(1,0,2));
  eq(operator,B.probeSandwich(B.controlled(m[program.name])));
  const inputSupport=kron(P0,m.Pi),rawQuestion=kron(Z,m.I);
  eq(mm(mm(inputSupport,mm(mm(adj(operator),rawQuestion),operator)),inputSupport),kron(P0,mm(m.Pi,m[program.name])));
  return {steps,operator,inputSupport,rawQuestion};
}
function questionsAtCuts(m,program,available,finalQuestions){const data=programData(m,program,available),n=2*m.I.length;
  assert(Array.isArray(finalQuestions)&&finalQuestions.length>0);assert.equal(new Set(finalQuestions.map(q=>q.name)).size,finalQuestions.length);
  const cuts=Array.from({length:data.steps.length+1},()=>[]);
  finalQuestions.forEach(({name,operator})=>{assert(typeof name==='string'&&name.length>0);assert(operator.length===n&&operator.every(row=>row.length===n));eq(adj(operator),operator);
    let O=operator;cuts.at(-1).push({name,operator:O});
    for(let i=data.steps.length-1;i>=0;i--){const step=data.steps[i];O=scale(mm(mm(adj(step.matrix),O),step.matrix),div(one,step.normSquared));cuts[i].push({name,operator:O});}});
  return {...data,cuts};
}
function cutData(m,spec){assert.equal(spec.kind,'probe-cut-background-question');const data=questionsAtCuts(m,spec.program,spec.available,spec.finalQuestions),n=2*m.I.length;
  assert.equal(spec.generators.length,data.cuts.length);
  const commutators=spec.generators.map((generators,cut)=>generators.map(S=>{assert(S.length===n&&S.every(row=>row.length===n));eq(adj(S),S);
    return data.cuts[cut].map(q=>scale(comm(S,q.operator),ii));}));
  return {...data,commutators};
}
function constructExact(m,spec){touch(m);counters.constructions++;const data=cutData(m,spec);let obstruction=null;
  for(let cut=0;cut<data.commutators.length&&!obstruction;cut++)for(let generator=0;generator<data.commutators[cut].length&&!obstruction;generator++)
    for(let question=0;question<data.commutators[cut][generator].length&&!obstruction;question++)if(!isZero(data.commutators[cut][generator][question]))
      obstruction={cut,generator,question,commutator:data.commutators[cut][generator][question]};
  const out={kind:obstruction?'cut-commutator-obstruction':'uniform-cut-background',source:m.source,spec:structuredClone(spec),obstruction,physicalAdmission:null};
  verifyExact(m,spec,out);return out;
}
function verifyExact(m,spec,certificate){touch(m);assert.equal(key(certificate.source),key(m.source));assert.equal(key(certificate.spec),key(spec));assert.equal(certificate.physicalAdmission,null);
  const data=cutData(m,spec);
  if(certificate.kind==='cut-commutator-obstruction'){const w=certificate.obstruction;assert([w.cut,w.generator,w.question].every(Number.isSafeInteger));
    const D=data.commutators[w.cut]?.[w.generator]?.[w.question];assert(D&&!isZero(D));eq(D,w.commutator);
    return {admitted:false,scope:'the declared full-cut commutant condition; not a claim excluding all implementations',obstruction:w,physicalAdmission:null};}
  assert.equal(certificate.kind,'uniform-cut-background');assert.equal(certificate.obstruction,null);
  data.commutators.forEach(row=>row.forEach(items=>items.forEach(D=>assert(isZero(D)))));
  return {admitted:true,scope:'declared atomic ideal primitives with arbitrary retained-environment interaction generated at these cuts',physicalAdmission:null};
}
function nonnegative(x){assert(Array.isArray(x)&&x.length===3&&x.every(v=>typeof v==='bigint'));assert.deepEqual(x,c(...x));assert.equal(x[1],0n);assert(x[0]>=0n);}
function validateBudget(data,limits,exposures){assert.equal(limits.length,data.cuts.length);assert.equal(exposures.length,data.cuts.length);
  data.commutators.forEach((row,cut)=>{assert.equal(limits[cut].length,row.length);assert.equal(exposures[cut].length,row.length);
    row.forEach((items,g)=>{nonnegative(exposures[cut][g]);assert.equal(limits[cut][g].length,items.length);limits[cut][g].forEach(nonnegative);});});}
function constructBudget(m,spec,limits,exposures){touch(m);counters.constructions++;const data=cutData(m,spec);validateBudget(data,limits,exposures);
  const factors=data.commutators.map((row,cut)=>row.map((items,g)=>items.map((D,q)=>{
    const M=scale(eye(D.length),limits[cut][g][q]);return [Q.factorOrWitness(plus(M,D)),Q.factorOrWitness(minus(M,D))];})));
  const out={kind:'uniform-cut-question-budget',source:m.source,spec:structuredClone(spec),limits:structuredClone(limits),exposures:structuredClone(exposures),factors,physicalAdmission:null};
  verifyBudget(m,spec,limits,exposures,out);return out;
}
function verifyBudget(m,spec,limits,exposures,certificate){touch(m);assert.equal(certificate.kind,'uniform-cut-question-budget');assert.equal(key(certificate.source),key(m.source));
  assert.equal(key(certificate.spec),key(spec));assert.equal(key(certificate.limits),key(limits));assert.equal(key(certificate.exposures),key(exposures));assert.equal(certificate.physicalAdmission,null);
  const data=cutData(m,spec);validateBudget(data,limits,exposures);assert.equal(certificate.factors.length,data.cuts.length);
  const errors=spec.finalQuestions.map(()=>z);
  data.commutators.forEach((row,cut)=>{assert.equal(certificate.factors[cut].length,row.length);row.forEach((items,g)=>{
    assert.equal(certificate.factors[cut][g].length,items.length);items.forEach((D,q)=>{const f=certificate.factors[cut][g][q];assert.equal(f.length,2);
      const M=scale(eye(D.length),limits[cut][g][q]);Q.verifyFactor(plus(M,D),f[0]);Q.verifyFactor(minus(M,D),f[1]);
      errors[q]=add(errors[q],mul(limits[cut][g][q],exposures[cut][g]));});});});
  return {admitted:true,errors,scope:'for every retained finite environment with the declared integrated coefficient-norm exposures; not acquired calibration',physicalAdmission:null};
}
function jointOperator(m,program,available,environmentDimension,episodes){const data=programData(m,program,available),n=2*m.I.length;
  assert(Number.isSafeInteger(environmentDimension)&&environmentDimension>0);assert.equal(episodes.length,data.steps.length+1);
  const I=eye(n*environmentDimension);let U=I;
  for(let cut=0;cut<episodes.length;cut++){const W=episodes[cut];assert(W.length===I.length&&W.every(row=>row.length===I.length));eq(mm(adj(W),W),I);
    U=mm(W,U);if(cut<data.steps.length)U=mm(kron(data.steps[cut].matrix,eye(environmentDimension)),U);}
  U=scale(U,c(1,0,2));eq(mm(adj(U),U),I);return U;
}
if(require.main===module){const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=C.currentModel();const results=bundle.map(b=>b.certificate.kind==='uniform-cut-question-budget'?
  verifyBudget(m,b.spec,b.limits,b.exposures,b.certificate):verifyExact(m,b.spec,b.certificate));
  console.log(R.serialize({results:results.map(r=>({admitted:r.admitted,errors:r.errors??null,scope:r.scope})),constructionCalls:counters,boundConstructionCalls:Q.counters,physicalAdmission:null}));}
module.exports={access,constructProgram,programData,questionsAtCuts,cutData,constructExact,verifyExact,constructBudget,verifyBudget,jointOperator,counters,exact:E};
