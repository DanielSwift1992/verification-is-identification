"use strict";
// A native realization of an explicitly answer-only future. It does not
// promise a returned quantum source, and never inserts a readout for a constant.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js');
const E=C.exact,{c,z,one,mat,scale,plus,minus,adj,mm,eq,isZero}=E,key=C.json,counters={constructions:0};
function access(){return {kind:'declared-answer-only-native-readout',native:F.access(),
  terminalReadout:'projective computational readout of all four source roles, retaining their actual same-shot raw word',
  decoder:'deterministic function of that actual raw word',returnedSource:'no quantum source is required by the answer-only contract',
  reference:'external reference is retained jointly with the produced answer',physicalAdmission:null};}
function gates(){return [{kind:'phase-fixed-bit-flip',target:1,controls:[{bit:0,value:1}]},{kind:'phase-fixed-H',target:0},
  {kind:'phase-fixed-bit-flip',target:3,controls:[{bit:2,value:1}]},{kind:'phase-fixed-H',target:2}];}
function data(m,a,q){F.exchangeCode(m);assert.equal(key(a),key(access()));assert(q.length===16&&q.every(r=>r.length===16));eq(adj(q),q);eq(mm(q,q),m.I);
  if(isZero(minus(q,m.I)))return {constant:0};if(isZero(plus(q,m.I)))return {constant:1};
  const program=F.program(gates(),a.native);assert.equal(program.denominatorSquared,4);return {rows:program.N.map(row=>scale([row],c(1,0,2)))};}
function construct(m,a,q){const d=data(m,a,q);counters.constructions++;const common={source:m.source,available:structuredClone(a),question:q,physicalAdmission:null};
  if(d.constant!==undefined)return {...common,kind:'constant-answer-without-readout',constant:d.constant,gates:[]};
  const decoder=[];for(let i=0;i<d.rows.length;i++){const K=d.rows[i],Kq=mm(K,q);if(isZero(minus(Kq,K)))decoder.push(0);
    else if(isZero(plus(Kq,K)))decoder.push(1);else return {...common,kind:'fixed-readout-basis-obstruction',row:i};}
  return {...common,kind:'native-answer-readout',gates:gates(),decoder};}
function verify(m,a,q,p){const d=data(m,a,q);assert.equal(key(p.source),key(m.source));assert.equal(key(p.available),key(a));eq(p.question,q);assert.equal(p.physicalAdmission,null);
  if(d.constant!==undefined){assert.equal(p.kind,'constant-answer-without-readout');assert.equal(p.constant,d.constant);assert.deepEqual(p.gates,[]);
    return {admitted:true,instrument:{kind:'declared-recorded-instrument',inputDimension:16,outcomes:[{label:String(d.constant),kraus:[m.I]}]},sourcePreserved:true,measurements:0,nativeContacts:0,physicalAdmission:null};}
  if(p.kind==='fixed-readout-basis-obstruction'){assert(Number.isSafeInteger(p.row)&&p.row>=0&&p.row<16);const K=d.rows[p.row],Kq=mm(K,q);
    assert(!isZero(minus(Kq,K))&&!isZero(plus(Kq,K)));return {admitted:false,scope:'No deterministic decoder of this fixed Bell-basis readout realizes this question; other readouts are not excluded',physicalAdmission:null};}
  assert.equal(p.kind,'native-answer-readout');assert.equal(key(p.gates),key(gates()));assert(p.decoder.length===16&&p.decoder.every(x=>x===0||x===1));
  const outcomes=[0,1].map(a=>({label:String(a),kraus:d.rows.filter((_,i)=>p.decoder[i]===a)})).filter(o=>o.kraus.length);
  const effects=[mat(16),mat(16)];for(let i=0;i<16;i++){const K=d.rows[i];eq(mm(K,q),scale(K,c(p.decoder[i]?-1:1)));effects[p.decoder[i]]=plus(effects[p.decoder[i]],mm(adj(K),K));}
  eq(effects[0],scale(plus(m.I,q),c(1,0,2)));eq(effects[1],scale(minus(m.I,q),c(1,0,2)));
  return {admitted:true,instrument:{kind:'declared-recorded-instrument',inputDimension:16,outcomes},effects,
    sourcePreserved:false,measurements:4,nativeContacts:4,scope:'Exact answer/reference instrument after discarding the source; not a nondestructive question acquisition',physicalAdmission:null};}
if(require.main===module){const b=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=M.currentModel();console.log(R.serialize({results:b.map(p=>{const v=verify(m,p.available,p.question,p);return {admitted:v.admitted,measurements:v.measurements,nativeContacts:v.nativeContacts};}),constructionCalls:counters,physicalAdmission:null}));}
module.exports={access,gates,construct,verify,counters,exact:E};
