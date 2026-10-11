// Numerical companion to the analytical one-port question-factorization note.
// No hardware, no source-state input to the controller, no VI kernel claim.
'use strict';
const assert = require('node:assert/strict');
const zero = (n, m = n) => Array.from({length:n}, () => Array(m).fill(0));
const eye = n => zero(n).map((r,i) => r.map((_,j) => +(i === j)));
const tr = a => a[0].map((_,j) => a.map(r => r[j]));
const dot = (a,b) => a.reduce((s,x,i) => s+x*b[i],0);
const mv = (a,x) => a.map(r => dot(r,x));
const mm = (a,b) => { const bt=tr(b); return a.map(r => bt.map(c => dot(r,c))); };
const add = (a,b) => a.map((r,i) => r.map((v,j) => v+b[i][j]));
const scale = (a,c) => a.map(r => r.map(v => v*c));
const plus = (a,b) => a.map((v,i) => v+b[i]);
const maxAbs = x => Math.max(0,...x.flat(Infinity).map(Math.abs));
function expm(a) {
  const norm=Math.max(...a.map(r => r.reduce((s,v)=>s+Math.abs(v),0)));
  const s=Math.max(0,Math.ceil(Math.log2(norm/0.25)));
  const b=scale(a,2**(-s)); let out=eye(a.length), term=eye(a.length);
  for(let k=1;k<=32;k++) { term=scale(mm(term,b),1/k); out=add(out,term); }
  for(let k=0;k<s;k++) out=mm(out,out);
  return out;
}
function power(a,n) { let r=eye(a.length); for(let i=0;i<n;i++) r=mm(a,r); return r; }
// Consistent rank-deficient systems are admitted: full state recovery is not required.
function solve(a,b) {
  const n=a.length, norm=maxAbs(a), w=a.map((r,i)=>[...r.map(v=>v/norm),b[i]/norm]);
  const pivots=[]; let row=0;
  for(let col=0;col<n && row<n;col++) {
    let p=row; for(let j=row+1;j<n;j++) if(Math.abs(w[j][col])>Math.abs(w[p][col])) p=j;
    if(Math.abs(w[p][col])<1e-11) continue;
    [w[row],w[p]]=[w[p],w[row]];
    const d=w[row][col]; for(let j=col;j<=n;j++) w[row][j]/=d;
    for(let i=0;i<n;i++) if(i!==row) { const q=w[i][col]; for(let j=col;j<=n;j++) w[i][j]-=q*w[row][j]; }
    pivots.push(col); row++;
  }
  const x=Array(n).fill(0); pivots.forEach((c,i)=>x[c]=w[i][n]);
  const residual=maxAbs(mv(a,x).map((v,i)=>v-b[i]));
  assert(residual<1e-18, `question not represented: ${residual}`);
  return {x,rank:row};
}
const nominal={la:.01,lb:.01,ca:1e-6,cb:1e-6,ra:33,rb:23,m:.003};
const Z=100, DT=1e-5, COUNT=60, PULSE_STEPS=10, DELAY_STEPS=2, U=.5;
function model(p) {
  const d=p.la*p.lb-p.m*p.m;
  assert(d>0);
  const a=[
    [0,0,1/(Z*p.ca),0], [0,0,0,1/(Z*p.cb)],
    [-Z*p.lb/d,Z*p.m/d,-p.lb*p.ra/d,p.m*p.rb/d],
    [Z*p.m/d,-Z*p.la/d,p.m*p.ra/d,-p.la*p.rb/d]
  ];
  const g=[0,0,Z*p.lb/d,-Z*p.m/d];
  const h=[[p.ca,0,0,0],[0,p.cb,0,0],[0,0,p.la/Z**2,p.m/Z**2],[0,0,p.m/Z**2,p.lb/Z**2]];
  const aug=a.map((r,i)=>[...r,g[i]]); aug.push([0,0,0,0,0]);
  const e=expm(scale(aug,DT)), f=e.slice(0,4).map(r=>r.slice(0,4)), b=e.slice(0,4).map(r=>r[4]);
  return {a,g,h,f,b,c:[0,0,1/Z,0],p};
}
const advance=(m,x,u=0)=>plus(mv(m.f,x),m.b.map(v=>v*u));
const energy=(m,x)=>dot(x,mv(m.h,x))/2;
function pulse(m,x) { for(let k=0;k<PULSE_STEPS;k++) x=advance(m,x,U); return x; }
function reader(m,r,c) {
  const rows=[]; let f=eye(4);
  for(let k=0;k<COUNT;k++) { rows.push(mv(tr(f),m.c)); if(k<COUNT-1) f=mm(m.f,f); }
  const rhs=mv(tr(f),r), gram=mm(tr(rows),rows), sol=solve(gram,rhs);
  const lambda=mv(rows,sol.x), residual=maxAbs(mv(tr(rows),lambda).map((v,i)=>v-rhs[i]));
  assert(residual<1e-18);
  return {r,c,lambda,rows,rank:sol.rank,residual};
}
function question(m,delaySteps=DELAY_STEPS) {
  const fp=power(m.f,PULSE_STEPS), fl=power(m.f,delaySteps), b=pulse(m,[0,0,0,0]);
  return reader(m,mv(tr(mm(fp,fl)),mv(m.h,b)),energy(m,b));
}
// Only actual A samples and the actual applied-input record enter this reading.
function readQuestion(m,q,records) {
  assert.equal(records.length,COUNT);
  let forced=[0,0,0,0]; const corrected=[];
  for(let k=0;k<COUNT;k++) {
    corrected.push(records[k].y-dot(m.c,forced));
    if(k<COUNT-1) forced=advance(m,forced,records[k].u);
  }
  return dot(q.lambda,corrected)+dot(q.r,forced)+q.c;
}
function history(m,x,inputs) {
  const records=[];
  for(let k=0;k<COUNT;k++) {
    records.push({y:dot(m.c,x),u:inputs[k]??0});
    if(k<COUNT-1) x=advance(m,x,inputs[k]??0);
  }
  return {records,current:x};
}
function oracleDifference(m,x) {
  for(let k=0;k<DELAY_STEPS;k++) x=advance(m,x);
  let idle=x.slice(); for(let k=0;k<PULSE_STEPS;k++) idle=advance(m,idle);
  return energy(m,pulse(m,x))-energy(m,idle);
}
function admission(estimate,error,goal,minChange) {
  if(goal==='decrease') return estimate+error <= -minChange;
  if(goal==='increase') return estimate-error >= minChange;
  throw new Error('unknown independent goal');
}
let seed=1024; const rand=()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/2**32;};
const m=model(nominal), q=question(m), epsilon=2e-6;
const noiseBound=epsilon*q.lambda.reduce((s,v)=>s+Math.abs(v),0);
let algebraError=0, historyError=0, noiseExcess=0, admissions=0;
for(let n=0;n<128;n++) {
  const x=Array.from({length:4},()=>3*(rand()-.5));
  const inputs=Array.from({length:COUNT},()=>rand()<.2?U:0);
  const h=history(m,x,inputs), exact=oracleDifference(m,h.current), estimated=readQuestion(m,q,h.records);
  algebraError=Math.max(algebraError,Math.abs(exact-dot(q.r,h.current)-q.c));
  historyError=Math.max(historyError,Math.abs(exact-estimated));
  const noisy=h.records.map(r=>({...r,y:r.y+epsilon*(2*rand()-1)}));
  const val=readQuestion(m,q,noisy);
  noiseExcess=Math.max(noiseExcess,Math.abs(val-exact)-noiseBound);
  for(const goal of ['increase','decrease']) if(admission(val,noiseBound+1e-17,goal,2e-9)) {
    admissions++; assert(goal==='increase'?exact>=2e-9:exact<=-2e-9);
  }
}
assert(algebraError<1e-18 && historyError<1e-18 && noiseExcess<1e-18);
// An adversarial noise vector saturates the l-infinity observation error bound.
const h0=history(m,[.7,-.3,.4,-.5],Array(COUNT).fill(0));
const adv=h0.records.map((r,i)=>({...r,y:r.y+epsilon*Math.sign(q.lambda[i])}));
const saturation=Math.abs(readQuestion(m,q,adv)-readQuestion(m,q,h0.records)-noiseBound);
assert(saturation<1e-18);
// Scale-equivalent secondary systems: same physical A record and same energy question.
let scaleError=0, coefficientError=0;
for(const gamma of [.25,4,9]) {
  const sg=Math.sqrt(gamma), pm={...nominal,lb:gamma*nominal.lb,rb:gamma*nominal.rb,cb:nominal.cb/gamma,m:sg*nominal.m};
  const mg=model(pm), qg=question(mg), hg=history(mg,[.7,-.3*sg,.4,-.5/sg],Array(COUNT).fill(0));
  scaleError=Math.max(scaleError,...hg.records.map((r,i)=>Math.abs(r.y-h0.records[i].y)),Math.abs(oracleDifference(mg,hg.current)-oracleDifference(m,h0.current)));
  coefficientError=Math.max(coefficientError,...qg.lambda.map((v,i)=>Math.abs(v-q.lambda[i])));
}
assert(scaleError<1e-12 && coefficientError<1e-10);
// Same instantaneous A current, different required pulse choices.
const candidates=[];
for(const va of [-2,-1,0,1,2]) for(const vb of [-1,0,1]) for(const ib of [-1,0,1]) {
  const x=[va,vb,-.2,ib]; candidates.push({x,y:dot(m.c,x),difference:oracleDifference(m,x)});
}
const negative=candidates.find(v=>v.difference < -2e-8), positive=candidates.find(v=>v.difference > 2e-8);
assert(negative && positive && negative.y===positive.y);
// The requested difference can remain available even when full B recovery is not.
const disconnected=model({...nominal,m:0}), dq=question(disconnected);
assert.equal(dq.rank,2);
const dh=history(disconnected,[1,12,-.6,7],Array(COUNT).fill(0));
assert(Math.abs(readQuestion(disconnected,dq,dh.records)-oracleDifference(disconnected,dh.current))<1e-17);
// One continued trajectory: no reset, no enumeration of future pulse positions.
let x=[1.5,-.7,.8,-1], records=[], goalIndex=0, clock=0, busy=null;
const goals=['increase','decrease'], events=[];
for(let tick=0;tick<2500 && goalIndex<goals.length;tick++) {
  records.push({y:dot(m.c,x),u:0}); if(records.length>COUNT) records.shift();
  if(!busy && records.length===COUNT) {
    const estimate=readQuestion(m,q,records), goal=goals[goalIndex];
    if(admission(estimate,noiseBound+1e-17,goal,2e-9)) {
      const actual=oracleDifference(m,x);
      assert(goal==='increase'?actual>=2e-9:actual<=-2e-9);
      events.push({goal,decisionTick:tick,pulseStartTick:tick+DELAY_STEPS,estimate,actual});
      busy={start:tick+DELAY_STEPS,end:tick+DELAY_STEPS+PULSE_STEPS};
    }
  }
  const u=busy && tick>=busy.start && tick<busy.end ? U : 0;
  records[records.length-1].u=u; x=advance(m,x,u); clock=tick+1;
  if(busy && clock===busy.end) { busy=null; goalIndex++; }
}
// Whether this particular trajectory finishes is reported, not assumed by the theorem.
// Omitting actual intervening inputs or the declared actuation latency changes the question.
const withInputs=history(m,[.4,.7,-.3,.2],Array.from({length:COUNT},(_,i)=>i>=25&&i<35?U:0));
const falseHistory=withInputs.records.map(r=>({...r,u:0}));
const missingInputError=Math.abs(readQuestion(m,q,falseHistory)-oracleDifference(m,withInputs.current));
assert(missingInputError>1e-9);
const noLatencyQuestion=question(m,0);
let latencyCounterexample=null;
for(let n=0;n<512 && !latencyCounterexample;n++) {
  const state=Array.from({length:4},()=>4*(rand()-.5));
  const wrong=dot(noLatencyQuestion.r,state)+noLatencyQuestion.c, actual=oracleDifference(m,state);
  if(wrong < -2e-9 && actual > 2e-9) latencyCounterexample={state,wrong,actual};
}
assert(latencyCounterexample,'missing-latency negative control must separate');
// Independent differential-equation integration checks the matrix exponential path.
function directDerivative(x,u) {
  const [va,vb,zia,zib]=x, ia=zia/Z, ib=zib/Z, p=nominal;
  const det=p.la*p.lb-p.m*p.m, aa=u-p.ra*ia-va, bb=-p.rb*ib-vb;
  return [ia/p.ca,ib/p.cb,Z*(p.lb*aa-p.m*bb)/det,Z*(-p.m*aa+p.la*bb)/det];
}
function rk4(x,u,duration) {
  const steps=1000, dt=duration/steps;
  for(let i=0;i<steps;i++) {
    const k1=directDerivative(x,u), k2=directDerivative(plus(x,k1.map(v=>v*dt/2)),u);
    const k3=directDerivative(plus(x,k2.map(v=>v*dt/2)),u), k4=directDerivative(plus(x,k3.map(v=>v*dt)),u);
    x=x.map((v,j)=>v+dt*(k1[j]+2*k2[j]+2*k3[j]+k4[j])/6);
  }
  return x;
}
let independentIntegrationError=0;
for(let n=0;n<8;n++) {
  const state=Array.from({length:4},()=>2*rand()-1);
  const start=rk4(state,0,DELAY_STEPS*DT);
  const actual=energy(m,rk4(start,U,PULSE_STEPS*DT))-energy(m,rk4(start,0,PULSE_STEPS*DT));
  independentIntegrationError=Math.max(independentIntegrationError,Math.abs(actual-oracleDifference(m,state)));
}
assert(independentIntegrationError<1e-16);
// Pull the second action's question back through the complete first action and gap.
// The gap is one declared local-clock word, not an online search of future times.
// Chosen in an offline finite design exploration; no optimality claim.
const GAP=16;
const firstMap=power(m.f,DELAY_STEPS+PULSE_STEPS), gapMap=power(m.f,GAP);
const firstOffset=pulse(m,[0,0,0,0]);
const futureQ=reader(m,mv(tr(mm(gapMap,firstMap)),q.r),dot(q.r,mv(gapMap,firstOffset))+q.c);
const futureError=epsilon*futureQ.lambda.reduce((s,v)=>s+Math.abs(v),0)+1e-17;
let jointX=[1.5,-.7,.8,-1], jointRecords=[], jointStart=null, secondStart=null;
let jointEvents=[], jointStop=2500;
for(let tick=0;tick<2500;tick++) {
  jointRecords.push({y:dot(m.c,jointX),u:0}); if(jointRecords.length>COUNT) jointRecords.shift();
  if(jointStart===null && jointRecords.length===COUNT) {
    const first=readQuestion(m,q,jointRecords), second=readQuestion(m,futureQ,jointRecords);
    // Reserve both sides of the later reading's error interval for re-admission.
    if(admission(first,noiseBound+1e-17,'increase',2e-9) && admission(second,futureError,'decrease',2e-9+2*(noiseBound+1e-17))) {
      jointStart=tick+DELAY_STEPS;
      secondStart=jointStart+PULSE_STEPS+GAP+DELAY_STEPS;
      jointEvents.push({goal:'increase',decisionTick:tick,pulseStartTick:jointStart,estimate:first,actual:oracleDifference(m,jointX),derivedNextEstimate:second});
    }
  }
  if(secondStart!==null && tick===secondStart-DELAY_STEPS) {
    const estimate=readQuestion(m,q,jointRecords), actual=oracleDifference(m,jointX);
    assert(admission(estimate,noiseBound+1e-17,'decrease',2e-9));
    assert(actual<=-2e-9);
    jointEvents.push({goal:'decrease',decisionTick:tick,pulseStartTick:secondStart,estimate,actual});
  }
  const active=jointStart!==null && ((tick>=jointStart&&tick<jointStart+PULSE_STEPS)||(tick>=secondStart&&tick<secondStart+PULSE_STEPS));
  const u=active?U:0; jointRecords[jointRecords.length-1].u=u; jointX=advance(m,jointX,u);
  if(secondStart!==null && tick+1===secondStart+PULSE_STEPS) { jointStop=tick+1; break; }
}
assert.equal(jointEvents.length,2,'the declared positive example must complete');
const report={
  scope:'Conditional linear RLC mathematics; not hardware or Swift court admission',
  localClock:{dt:DT,historySamples:COUNT,pulseSteps:PULSE_STEPS,declaredActuationDelaySteps:DELAY_STEPS},
  certificate:{rank:q.rank,residual:q.residual,noisePerSample:epsilon,questionNoiseBound:noiseBound},
  checks:{cases:128,algebraError,historyError,noiseExcess,adversarialNoiseBoundResidual:saturation,admissions,scaleError,coefficientError,disconnectedRank:dq.rank,missingInputError,independentIntegrationError},
  latencyCounterexample,
  sameCurrentOppositeConsequences:{negative,positive},
  continuedTrajectory:{requestedGoals:goals,initialStateForSimulatorOnly:[1.5,-.7,.8,-1],goalsCompleted:goalIndex,elapsedLocalTicks:clock,events},
  continuationGuardedTrajectory:{requestedGoals:goals,initialStateForSimulatorOnly:[1.5,-.7,.8,-1],gapLocalTicks:GAP,goalsCompleted:jointEvents.length,elapsedLocalTicks:jointStop,events:jointEvents},
  physicalAdmission:null
};
console.log(JSON.stringify(report,null,2));
