"use strict";
// Reuse the existing instrument court with independently different futures.
// The receiver's full-source PT port is declared before constructing transport.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js'),M=require('./coordinated_moving_boundary.js');
const F=require('./coordinated_native_encoder.js'),T=require('./coordinated_instrument_transport.js');
const E=C.exact,{c,z,one,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero}=E,key=C.json;
function data(m){const d=F.exchangeCode(m),{P,Q,T:swapT}=m.operators,O=mm(P,swapT),U=plus(scale(m.I,c(3,0,5)),scale(P,c(0,-4,5))),
  V=plus(scale(m.I,c(5,0,13)),scale(swapT,c(0,-12,13)));
  eq(mm(adj(U),U),m.I);eq(mm(adj(V),V),m.I);eq(mm(O,O),m.I);eq(adj(O),O);
  eq(comm(P,O),mat(16));eq(comm(swapT,O),mat(16));assert(!isZero(comm(Q,O)));
  eq(comm(d.K,O),mat(16));eq(mm(d.support,O),d.readings[2].operator);
  const frame=readings=>({kind:'declared-generated-star-algebra',support:d.support,readings});
  const weak=frame([{name:'Z',operator:d.readings[2].operator}]),strong=frame(d.readings);
  const first={kind:'declared-recorded-instrument',inputDimension:16,outcomes:[{label:'unread',kraus:[scale(U,c(3,0,5)),scale(mm(d.K,U),c(4,0,5))]}]};
  const next={kind:'declared-recorded-instrument',inputDimension:16,outcomes:[{label:'unread',kraus:[V]}]};
  const port={kind:'declared-full-source-question-port',source:m.source,word:['P','T'],operator:O,
    meaning:'physical full-source PT reading, not Pi*PT and not an inverse-defined reading',physicalAdmission:null};
  return {...d,O,U,V,weak,strong,first,next,port};}
function verifyPort(m,port,frame){const d=data(m);assert.equal(key(port),key(d.port),'receiver must supply the independently specified full-source reading');
  T.validateFrame(frame);assert.equal(frame.readings.length,1);assert.equal(frame.readings[0].name,'Z');
  eq(mm(port.operator,frame.support),frame.readings[0].operator,'declared receiver does not implement the transported future on the actual output');return true;}
function construct(m){const d=data(m),weak=T.deriveStage(m.base,[d.weak],d.first),strong=T.deriveStage(m.base,[d.strong],d.first);
  const out=weak.cases[0].outputs[0].frame;verifyPort(m,d.port,out);
  const next=T.deriveStage(m.base,[out],d.next);verifyPort(m,d.port,next.cases[0].outputs[0].frame);
  const bundle={source:m.source,weak,strong,next,port:d.port,physicalAdmission:null};verify(m,bundle);return bundle;}
function verify(m,b){const d=data(m);assert.equal(key(b.source),key(m.source));assert.equal(b.physicalAdmission,null);
  for(const [stage,frame,instrument]of [[b.weak,d.weak,d.first],[b.strong,d.strong,d.first]]){
    assert.equal(stage.kind,'instrument-stage');assert.equal(stage.physicalAdmission,null);assert.equal(key(stage.instrument),key(instrument));assert.equal(stage.cases.length,1);
    const result=T.verify(m.base,frame,instrument,stage.cases[0]);assert.equal(result.admitted,stage===b.weak);}
  const out=b.weak.cases[0].outputs[0].frame;verifyPort(m,b.port,out);
  assert.equal(b.next.kind,'instrument-stage');assert.equal(b.next.physicalAdmission,null);assert.equal(key(b.next.instrument),key(d.next));assert.equal(b.next.cases.length,1);
  const after=T.verify(m.base,out,d.next,b.next.cases[0]);assert(after.admitted);verifyPort(m,b.port,after.outputs[0].frame);
  return {weakAdmitted:true,strongAdmitted:false,outputRank:tr(out.support),scope:'one fixed full-source PT future, with hidden alternatives of the declared instrument; no hardware port supplied by this proof',physicalAdmission:null};}
const owned=new WeakMap();
class FutureBoundary {
  constructor(m,frame,rho,referenceDimension=1){const d=data(m);T.validateFrame(frame);eq(frame.support,d.support);
    owned.set(this,{m,frame:structuredClone(frame),source:new F.EncodedBoundary(m,rho,1,referenceDimension),boundary:null,r:referenceDimension});}
  enter(a,p){const s=owned.get(this);assert(s.source,'only one input can enter');s.source.encode(a,p);
    s.boundary=new T.InstrumentBoundary(s.m.base,s.frame,s.source.snapshot().rho,s.r);s.source=null;return this;}
  continue(instrument,stage){const s=owned.get(this);data(s.m);assert(s.boundary);s.boundary.continue(instrument,stage);return this;}
  read(name,reference){const s=owned.get(this);assert(s.boundary);return s.boundary.read(name,reference);}
  snapshot(){const s=owned.get(this);assert(s.boundary);return s.boundary.snapshot();}
}
if(require.main===module){const b=R.deserialize(fs.readFileSync(process.argv[2],'utf8'));console.log(R.serialize({...verify(M.currentModel(),b),instrumentConstructionCalls:T.counters}));}
module.exports={data,verifyPort,construct,verify,FutureBoundary,exact:E};
