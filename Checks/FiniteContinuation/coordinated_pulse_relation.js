"use strict";
// A continuous-path premise is separate from the phase-fixed endpoint gate.
// Exact coefficient relations cover the entire declared arc, not samples.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const G=require('./coordinated_cut_background.js');
const E=C.exact,{c,one,ii,div,eye,scale,plus,minus,adj,mm,comm,eq,isZero}=E;
const key=C.json,counters={declarations:0,constructions:0};
function touch(m){C.verifyPlan(m,{targetScore:[],inputProjector:m.Pi,requiredInteriorCuts:[]},C.accessModel([]),
  {rule:'retain-source-score',source:m.source,score:[]});}
function declaredPaths(m,program,available){touch(m);counters.declarations++;
  const d=G.programData(m,program,available);
  // This is a DECLARATION constructor, not acquisition of a physical path.
  return {kind:'declared-involution-pulse-paths',source:m.source,program:structuredClone(program),
    segments:d.steps.map(s=>({kind:'phase-fixed-involution-arc',name:s.name,endpoint:{matrix:s.matrix,normSquared:s.normSquared},
      path:'exp(-i*s*(I-F))',parameterStart:'0',parameterEnd:'pi/2',parameterRegularity:'absolutely-continuous',
      F:'endpoint-matrix/sqrt(normSquared)'})),physicalAdmission:null};}
function coefficients(matrix,normSquared,O){const n=matrix.length;assert(n>0&&matrix.every(r=>r.length===n));
  assert(O.length===n&&O.every(r=>r.length===n));eq(adj(matrix),matrix);eq(adj(O),O);
  assert([key(one),key(c(2))].includes(key(normSquared)),'only explicit rational or Hadamard normalization is supported');
  eq(mm(matrix,matrix),scale(eye(n),normSquared));
  const FOF=scale(mm(mm(matrix,O),matrix),div(one,normSquared));
  const A=scale(plus(O,FOF),c(1,0,2)),B=scale(minus(O,FOF),c(1,0,2)),Cscaled=scale(comm(matrix,O),c(0,1,2));
  [A,B,Cscaled].forEach(M=>eq(adj(M),M));eq(plus(A,B),O);eq(minus(A,B),FOF);
  return {A,B,Cscaled,normSquared,
    formula:'A+cos(2*r)*B-sin(2*r)*Cscaled/sqrt(normSquared)'};}
function pulseData(m,spec){touch(m);assert.equal(spec.kind,'probe-pulse-background-question');
  const d=G.questionsAtCuts(m,spec.program,spec.available,spec.finalQuestions),paths=spec.paths;
  assert(paths,'an endpoint program does not establish its continuous path');
  assert.equal(paths.kind,'declared-involution-pulse-paths');assert.equal(key(paths.source),key(m.source));
  assert.equal(key(paths.program),key(spec.program));assert.equal(paths.physicalAdmission,null);
  assert.equal(paths.segments.length,d.steps.length);assert.equal(spec.generators.length,d.steps.length);
  const arcs=d.steps.map((s,j)=>{const p=paths.segments[j];assert.equal(p.kind,'phase-fixed-involution-arc');assert.equal(p.name,s.name);
    assert.equal(key(p.endpoint),key({matrix:s.matrix,normSquared:s.normSquared}));
    assert.equal(p.path,'exp(-i*s*(I-F))');assert.equal(p.parameterStart,'0');assert.equal(p.parameterEnd,'pi/2');
    assert.equal(p.parameterRegularity,'absolutely-continuous');assert.equal(p.F,'endpoint-matrix/sqrt(normSquared)');
    return d.cuts[j+1].map(q=>({name:q.name,...coefficients(s.matrix,s.normSquared,q.operator)}));});
  const commutators=spec.generators.map((row,j)=>row.map(S=>{const n=2*m.I.length;
    assert(S.length===n&&S.every(r=>r.length===n));eq(adj(S),S);
    return arcs[j].map(a=>Object.fromEntries(['A','B','Cscaled'].map(k=>[k,scale(comm(S,a[k]),ii)])));}));
  return {...d,arcs,commutators};}
function construct(m,spec){touch(m);counters.constructions++;const data=pulseData(m,spec);let obstruction=null;
  for(let segment=0;segment<data.commutators.length&&!obstruction;segment++)
    for(let generator=0;generator<data.commutators[segment].length&&!obstruction;generator++)
      for(let question=0;question<data.commutators[segment][generator].length&&!obstruction;question++)
        for(const coefficient of ['A','B','Cscaled'])if(!isZero(data.commutators[segment][generator][question][coefficient])){
          obstruction={segment,generator,question,coefficient,commutator:data.commutators[segment][generator][question][coefficient]};break;}
  const certificate={kind:obstruction?'pulse-coefficient-obstruction':'uniform-declared-pulse-relation',source:m.source,
    spec:structuredClone(spec),arcs:data.arcs,obstruction,physicalAdmission:null};verify(m,spec,certificate);return certificate;}
function verify(m,spec,certificate){touch(m);assert.equal(key(certificate.source),key(m.source));assert.equal(key(certificate.spec),key(spec));
  assert.equal(certificate.physicalAdmission,null);const data=pulseData(m,spec);assert.equal(key(certificate.arcs),key(data.arcs));
  if(certificate.kind==='pulse-coefficient-obstruction'){const w=certificate.obstruction;
    assert([w.segment,w.generator,w.question].every(Number.isSafeInteger));assert(['A','B','Cscaled'].includes(w.coefficient));
    const D=data.commutators[w.segment]?.[w.generator]?.[w.question]?.[w.coefficient];assert(D&&!isZero(D));eq(D,w.commutator);
    return {admitted:false,scope:'failure of this full-space, fixed-generator, whole-arc relation; not universal unimplementability',
      obstruction:w,physicalAdmission:null};}
  assert.equal(certificate.kind,'uniform-declared-pulse-relation');assert.equal(certificate.obstruction,null);
  data.commutators.forEach(row=>row.forEach(qs=>qs.forEach(parts=>Object.values(parts).forEach(D=>assert(isZero(D))))));
  return {admitted:true,scope:'every declared pulse parameter value with arbitrary retained finite environment and integrable coupling histories in the declared generators',
    ignoresPhysicalPathCertification:false,physicalAdmission:null};}
if(require.main===module){const bundle=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=C.currentModel();
  const results=bundle.map(b=>verify(m,b.spec,b.certificate));console.log(R.serialize({results:results.map(r=>({admitted:r.admitted,scope:r.scope})),
    constructionCalls:counters,cutConstructionCalls:G.counters,physicalAdmission:null}));}
module.exports={declaredPaths,coefficients,pulseData,construct,verify,counters,exact:E};
