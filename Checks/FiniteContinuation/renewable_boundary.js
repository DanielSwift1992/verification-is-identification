"use strict";
// A derived larger continuation boundary and an optional coherent return.
// All access below is conditional mathematics, not acquired hardware access.
const assert=require('node:assert/strict'),fs=require('node:fs');
const C=require('./coordinated_continuation.js'),R=require('./coordinated_relation_resolve.js');
const M=require('./coordinated_moving_boundary.js'),F=require('./coordinated_native_encoder.js'),D=require('./coordinated_native_exit.js');
const E=C.exact,{c,z,one,ii,add,mul,div,mat,eye,scale,plus,minus,adj,mm,comm,kron,tr,eq,isZero,kernel}=E,key=C.json;
const counters={completions:0,actionSolves:0,returnConstructions:0};
const X=[[z,one],[one,z]],P0=[[one,z],[z,z]],P1=[[z,z],[z,one]],ket0=[[one],[z]],I2=eye(2);
function exampleError(){const V=mat(16);for(let n=0;n<16;n++){const a=(n>>3)&1,b=(n>>2)&1,d=n&1;
  V[n][n]=c((a^b^(a&b)^(a&d)^(b&d))?-1:1);}return V;}
function frame(P,readings){return {kind:'declared-generated-star-algebra',support:P,readings};}
function completion(m,V){const d=F.exchangeCode(m);eq(adj(V),V);eq(mm(V,V),m.I);assert(V.length===16);counters.completions++;
  const cross=mm(mm(d.support,V),d.support);if(!isZero(cross))return {kind:'outside-orthogonal-completion-rule',source:m.source,error:V,cross,physicalAdmission:null};
  const other=mm(mm(V,d.support),V),support=plus(d.support,other),readings=d.readings.map(q=>({name:q.name,operator:plus(q.operator,mm(mm(V,q.operator),V))}));
  const p={kind:'orthogonal-continuation-completion',source:m.source,error:V,initial:d.support,other,support,readings,physicalAdmission:null};verifyCompletion(m,V,p);return p;}
function verifyCompletion(m,V,p){const d=F.exchangeCode(m);assert.equal(key(p.source),key(m.source));assert.equal(p.physicalAdmission,null);eq(p.error,V);eq(adj(V),V);eq(mm(V,V),m.I);
  const cross=mm(mm(d.support,V),d.support);if(p.kind==='outside-orthogonal-completion-rule'){eq(p.cross,cross);assert(!isZero(cross));return null;}
  assert.equal(p.kind,'orthogonal-continuation-completion');eq(cross,mat(16));eq(p.initial,d.support);eq(p.other,mm(mm(V,d.support),V));eq(mm(p.other,d.support),mat(16));
  eq(p.support,plus(d.support,p.other));eq(mm(p.support,p.support),p.support);eq(comm(V,p.support),mat(16));eq(comm(d.K,p.support),mat(16));
  assert.deepEqual(p.readings.map(q=>q.name),d.readings.map(q=>q.name));
  for(let j=0;j<3;j++){const O=p.readings[j].operator;eq(O,plus(d.readings[j].operator,mm(mm(V,d.readings[j].operator),V)));eq(adj(O),O);eq(mm(O,O),p.support);
    eq(comm(O,V),mat(16));eq(comm(O,d.K),mat(16));eq(mm(O,d.support),d.readings[j].operator);}
  eq(plus(mm(p.readings[0].operator,p.readings[2].operator),mm(p.readings[2].operator,p.readings[0].operator)),mat(16));
  eq(mm(plus(mm(V,d.K),mm(d.K,V)),p.support),mat(16));
  return {...d,other:p.other,extended:p.support,extendedReadings:p.readings,error:V,physicalAdmission:null};}
function actionAccess(){return {kind:'declared-completed-boundary-control',
  generators:'real linear combinations of the derived extended X and Z on the entire completed boundary',
  path:'that Hamiltonian throughout the episode; an equal endpoint gate does not provide this access',
  phase:'channel on the completed boundary, no coherent controlled lift',physicalAdmission:null};}
function actionData(m,cp,g){const d=verifyCompletion(m,cp.error,cp);assert(d);assert.equal(g.kind,'independent-continuation-relations');eq(g.input,d.extended);
  assert.deepEqual(g.requiredInteriorCuts,[]);assert(g.relations.length);for(const q of g.relations)for(const O of [q.before,q.after]){eq(adj(O),O);eq(mm(mm(d.extended,O),d.extended),O);}return d;}
function constructAction(m,cp,a,g){assert.equal(key(a),key(actionAccess()));const d=actionData(m,cp,g),basis=[d.extendedReadings[0].operator,d.extendedReadings[2].operator],rows=[];
  for(const q of g.relations){const cols=basis.map(B=>minus(mm(q.after,B),mm(B,q.before)).flat());for(let j=0;j<256;j++){rows.push(cols.map(v=>c(v[j][0],0,v[j][2])));rows.push(cols.map(v=>c(v[j][1],0,v[j][2])));}}
  counters.actionSolves++;const solutions=kernel(rows);if(!solutions.length)return null;
  const p={kind:'completed-boundary-reflection',source:m.source,completion:cp,available:a,goal:g,coefficients:solutions[0],physicalAdmission:null};verifyAction(m,cp,a,g,p);return p;}
function verifyAction(m,cp,a,g,p){assert.equal(key(a),key(actionAccess()));const d=actionData(m,cp,g);assert.equal(p.kind,'completed-boundary-reflection');assert.equal(key(p.source),key(m.source));
  assert.equal(key(p.completion),key(cp));assert.equal(key(p.available),key(a));assert.equal(key(p.goal),key(g));assert.equal(p.physicalAdmission,null);
  assert.equal(p.coefficients.length,2);p.coefficients.forEach(x=>{assert.deepEqual(x,c(...x));assert.equal(x[1],0n);});const [x,y]=p.coefficients,norm=add(mul(x,x),mul(y,y));assert(norm[0]>0n);
  const N=plus(scale(d.extendedReadings[0].operator,x),scale(d.extendedReadings[2].operator,y));eq(mm(N,N),scale(d.extended,norm));
  for(const q of g.relations)eq(mm(q.after,N),mm(N,q.before));for(const B of [d.error,d.K])eq(comm(N,B),mat(16));
  return {...d,N,norm,physicalAdmission:null};}
function returnAccess(){return {kind:'declared-coherent-return-access',freshCarriers:1,
  initialization:'one actual carrier in |0>, retained from input through output',
  native:'phase-fixed H, X, CX and CCX on four source roles and that carrier',
  episode:'exact ordered native word; its interior protection is not assumed',
  output:'same quantum source, used carrier and prior context all retained; no measurement or reset',physicalAdmission:null};}
function h(t){return {kind:'H',target:t};}function x(t,controls=[]){return {kind:'X',target:t,controls};}
function nativeGate(g){assert(Number.isSafeInteger(g.target)&&g.target>=0&&g.target<5);const N=mat(32),bit=1<<(4-g.target);
  if(g.kind==='H'){assert.deepEqual(Object.keys(g).sort(),['kind','target']);for(let s=0;s<32;s++){N[s][s]=c(s&bit?-1:1);N[s^bit][s]=one;}return {N,den:2};}
  assert.equal(g.kind,'X');assert.deepEqual(Object.keys(g).sort(),['controls','kind','target']);assert(g.controls.length<=2&&new Set(g.controls).size===g.controls.length);
  g.controls.forEach(t=>assert(Number.isSafeInteger(t)&&t>=0&&t<5&&t!==g.target));for(let s=0;s<32;s++)N[g.controls.every(t=>(s>>(4-t))&1)?s^bit:s][s]=one;return {N,den:1};}
function nativeProgram(word){let N=eye(32),den=1;for(const g of word){const v=nativeGate(g);N=mm(v.N,N);den*=v.den;assert(Number.isSafeInteger(den));}eq(mm(adj(N),N),scale(eye(32),c(den)));return {N,den};}
function recoveryWord(V){const a=4,word=[h(a)];for(const [i,j]of [[0,3],[1,2]])word.push(x(j,[i]),x(i,[a,j]),x(j,[i]));word.push(h(a),x(a));
  // Derive the Boolean phase polynomial. The bounded native lowering below
  // covers diagonal quadratic errors; the algebraic completion is broader.
  const coefficients=[];for(let s=0;s<16;s++){for(let t=0;t<16;t++)if(s!==t)assert.deepEqual(V[s][t],z,'this lowering requires a diagonal phase');
    assert([key(one),key(c(-1))].includes(key(V[s][s])));coefficients.push(V[s][s][0]===1n?0:1);}
  for(let bit=0;bit<4;bit++)for(let mask=0;mask<16;mask++)if(mask&(1<<bit))coefficients[mask]^=coefficients[mask^(1<<bit)];
  for(let mask=0;mask<16;mask++)if(coefficients[mask]){const bits=[0,1,2,3].filter(i=>mask&(1<<(3-i)));assert(bits.length<=2,'outside quadratic phase lowering, not a physical impossibility');
    const target=bits.length?bits.at(-1):a,controls=bits.length?[a,...bits.slice(0,-1)]:[];word.push(h(target),x(target,controls),h(target));}return word;}
function returnOperator(m,V){const d=F.exchangeCode(m),syndrome=plus(kron(d.support,I2),kron(minus(m.I,d.support),X)),correction=plus(kron(m.I,P0),kron(V,P1));
  return mm(correction,syndrome);}
function constructReturn(m,cp,a=returnAccess()){assert.equal(key(a),key(returnAccess()));const d=verifyCompletion(m,cp.error,cp);assert(d);counters.returnConstructions++;const word=recoveryWord(cp.error),U=returnOperator(m,cp.error);
  const p={kind:'native-coherent-return',source:m.source,completion:cp,available:a,word,U,physicalAdmission:null};verifyReturn(m,cp,a,p);return p;}
function verifyReturn(m,cp,a,p){const d=verifyCompletion(m,cp.error,cp);assert(d);assert.equal(key(a),key(returnAccess()));assert.equal(p.kind,'native-coherent-return');assert.equal(key(p.source),key(m.source));
  assert.equal(key(p.completion),key(cp));assert.equal(key(p.available),key(a));assert.equal(p.physicalAdmission,null);const q=nativeProgram(p.word),U=returnOperator(m,cp.error);
  eq(p.U,U);eq(mm(adj(U),U),eye(32));const hCount=p.word.filter(g=>g.kind==='H').length;assert.equal(hCount%2,0);eq(q.N,scale(U,c(1n<<BigInt(hCount/2))));
  const clean=kron(d.support,ket0),error=kron(mm(cp.error,d.support),ket0);eq(mm(U,clean),clean);eq(mm(U,error),kron(d.support,[[z],[one]]));
  for(let j=0;j<3;j++)eq(mm(kron(d.readings[j].operator,I2),mm(U,kron(d.extended,P0))),mm(mm(U,kron(d.extendedReadings[j].operator,P0)),eye(32)));
  return {...d,U,contacts:p.word.length,physicalAdmission:null};}
function embedEnvironment(W,e){assert(W.length===16*e&&W.every(r=>r.length===16*e));const out=mat(32*e);
  for(let s=0;s<16;s++)for(let t=0;t<16;t++)for(let b=0;b<2;b++)for(let i=0;i<e;i++)for(let j=0;j<e;j++)out[(s*2+b)*e+i][(t*2+b)*e+j]=W[s*e+i][t*e+j];return out;}
function validateEpisode(d,W,e){eq(mm(adj(W),W),eye(16*e));for(const O of [d.extended,...d.extendedReadings.map(q=>q.operator)])eq(comm(W,kron(O,eye(e))),mat(16*e));}
const live=new WeakMap();
class RenewableBoundary{
  constructor(m,cp,rho,e=1,r=1,memory){const d=verifyCompletion(m,cp.error,cp);assert(d);assert(memory!==undefined,'an actual supplied clean carrier is required; none is created by default');eq(memory,P0);
    live.set(this,{m,cp:structuredClone(cp),e,r,source:new F.EncodedBoundary(m,rho,e,r),rho:null,phase:'native',memoryUsed:false,steps:0});}
  enter(a,p){const s=live.get(this);assert.equal(s.phase,'native');s.source.encode(a,p);const J=kron(kron(eye(16),ket0),eye(s.e*s.r));s.rho=mm(mm(J,s.source.snapshot().rho),adj(J));s.source=null;s.phase='completed';return this;}
  act(a,g,p,episodes){const s=live.get(this);assert.equal(s.phase,'completed');const d=verifyAction(s.m,s.cp,a,g,p);assert(episodes.length>0);episodes.forEach(W=>validateEpisode(d,W,s.e));
    const P=kron(d.extended,eye(2*s.e*s.r));eq(mm(mm(P,s.rho),P),s.rho);let U=eye(16*s.e);for(const W of episodes)U=mm(W,U);U=mm(U,kron(d.N,eye(s.e)));
    const full=kron(embedEnvironment(U,s.e),eye(s.r)),rho=scale(mm(mm(full,s.rho),adj(full)),div(one,d.norm));eq(mm(mm(P,rho),P),rho);s.rho=rho;s.steps++;return this;}
  restore(a,p){const s=live.get(this);assert.equal(s.phase,'completed');assert(!s.memoryUsed,'the retained used carrier is not a fresh return resource');const d=verifyReturn(s.m,s.cp,a,p);
    const clean=kron(kron(d.extended,P0),eye(s.e*s.r));eq(mm(mm(clean,s.rho),clean),s.rho);const full=kron(d.U,eye(s.e*s.r)),rho=mm(mm(full,s.rho),adj(full));
    const P=kron(d.support,eye(2*s.e*s.r));eq(mm(mm(P,rho),P),rho);s.rho=rho;s.memoryUsed=true;return this;}
  exit(a,p){const s=live.get(this);assert.equal(s.phase,'completed');const d=D.verify(s.m,a,p),P=kron(d.support,eye(2*s.e*s.r));eq(mm(mm(P,s.rho),P),s.rho);
    s.rho=D.act(D.tensor(d.U,eye(2*s.e*s.r)),D.lift(s.rho));s.phase='returned';return this;}
  snapshot(){const s=live.get(this);return {phase:s.phase,rho:structuredClone(s.rho),steps:s.steps,memoryUsed:s.memoryUsed,physicalAdmission:null};}
}
if(require.main===module){const b=R.deserialize(fs.readFileSync(process.argv[2],'utf8')),m=M.currentModel();verifyCompletion(m,b.completion.error,b.completion);b.actions.forEach(p=>verifyAction(m,b.completion,p.available,p.goal,p));
  const v=verifyReturn(m,b.completion,b.return.available,b.return);console.log(R.serialize({verified:true,returnContacts:v.contacts,counters,physicalAdmission:null}));}
module.exports={completion,verifyCompletion,exampleError,frame,actionAccess,constructAction,verifyAction,returnAccess,constructReturn,verifyReturn,returnOperator,nativeProgram,recoveryWord,
  embedEnvironment,validateEpisode,RenewableBoundary,counters,exact:E};
