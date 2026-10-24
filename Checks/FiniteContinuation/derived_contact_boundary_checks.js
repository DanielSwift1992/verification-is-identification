// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";
// Independent exact finite mathematics. No SDK, QPU, physical-admission flag,
// floating-point tolerance, or new runtime executor. See the paired note.
const fs = require("node:fs"), path = require("node:path");
const assert = require("node:assert/strict"), crypto = require("node:crypto");
const root = path.resolve(__dirname, "../..");
const judgeFile = path.resolve(root, "Checks/Archive/WhereV2/judge-where.js");
const { judgeWhereTexts } = require(judgeFile);
const sha = x => crypto.createHash("sha256").update(x).digest("hex");

// Exact Gaussian rationals (a + i b) / d, in canonical form.
function gcd(a,b) { a=a<0n?-a:a; b=b<0n?-b:b; while(b) [a,b]=[b,a%b]; return a; }
function c(a=0,b=0,d=1) {
  a=BigInt(a); b=BigInt(b); d=BigInt(d); assert(d!==0n);
  if(d<0n) { a=-a;b=-b;d=-d; }
  const g=gcd(gcd(a,b),d); return [a/g,b/g,d/g];
}
const z=c(), one=c(1), ii=c(0,1);
const nz=x=>x[0]!==0n||x[1]!==0n;
const add=(x,y)=>c(x[0]*y[2]+y[0]*x[2],x[1]*y[2]+y[1]*x[2],x[2]*y[2]);
const neg=x=>[-x[0],-x[1],x[2]];
const sub=(x,y)=>add(x,neg(y));
const mul=(x,y)=>c(x[0]*y[0]-x[1]*y[1],x[0]*y[1]+x[1]*y[0],x[2]*y[2]);
const conj=x=>[x[0],-x[1],x[2]];
const div=(x,y)=>{assert(nz(y));return mul(x,c(y[0]*y[2],-y[1]*y[2],y[0]**2n+y[1]**2n));};
const scalarText=x=>x[1]===0n?`${x[0]}/${x[2]}`:`(${x[0]}+${x[1]}i)/${x[2]}`;
const mat=(n,m=n)=>Array.from({length:n},()=>Array.from({length:m},()=>z));
const eye=n=>Array.from({length:n},(_,i)=>Array.from({length:n},(_,j)=>i===j?one:z));
const scale=(A,x)=>A.map(row=>row.map(y=>mul(y,x)));
const plus=(A,B)=>A.map((row,i)=>row.map((x,j)=>add(x,B[i][j])));
const minus=(A,B)=>plus(A,scale(B,c(-1)));
const adj=A=>A[0].map((_,j)=>A.map(row=>conj(row[j])));
function mm(A,B) {
  assert.equal(A[0].length,B.length);const out=mat(A.length,B[0].length);
  for(let i=0;i<A.length;i++)for(let k=0;k<B.length;k++)if(nz(A[i][k]))
    for(let j=0;j<B[0].length;j++)if(nz(B[k][j]))out[i][j]=add(out[i][j],mul(A[i][k],B[k][j]));
  return out;
}
const comm=(A,B)=>minus(mm(A,B),mm(B,A));
const tr=A=>A.reduce((a,row,i)=>add(a,row[i]),z);
const eq=(A,B,message)=>assert.deepEqual(A,B,message);
const isZero=A=>A.every(row=>row.every(x=>!nz(x)));
function kron(A,B) {
  return A.flatMap(row=>B.map(brow=>row.flatMap(x=>brow.map(y=>mul(x,y)))));
}
function rref(input) {
  const A=input.map(row=>row.slice()),pivots=[];let r=0;
  for(let j=0;j<A[0].length&&r<A.length;j++) {
    const k=A.findIndex((row,k)=>k>=r&&nz(row[j]));if(k<0)continue;
    [A[r],A[k]]=[A[k],A[r]];const t=A[r][j];A[r]=A[r].map(x=>div(x,t));
    for(let i=0;i<A.length;i++)if(i!==r&&nz(A[i][j])) {
      const f=A[i][j];A[i]=A[i].map((x,k)=>sub(x,mul(f,A[r][k])));
    }
    pivots.push(j);r++;
  }
  return {A,pivots};
}
const rank=rows=>rref(rows).pivots.length;
function kernel(rows) {
  const {A,pivots}=rref(rows),out=[];
  for(let j=0;j<A[0].length;j++)if(!pivots.includes(j)) {
    const v=Array.from({length:A[0].length},()=>z);v[j]=one;
    pivots.forEach((p,i)=>v[p]=neg(A[i][j]));out.push(v);
  }
  return out;
}
function commutant(gens) {
  const n=gens[0].length,rows=[];
  for(const G of gens)for(let i=0;i<n;i++)for(let j=0;j<n;j++) {
    const row=Array.from({length:n*n},()=>z);
    for(let k=0;k<n;k++) {
      row[i*n+k]=add(row[i*n+k],G[k][j]);
      row[k*n+j]=sub(row[k*n+j],G[i][k]);
    }
    rows.push(row);
  }
  return kernel(rows).map(v=>Array.from({length:n},(_,i)=>v.slice(i*n,(i+1)*n)));
}
function closure(seed,steps) {
  const basis=[];const extend=A=>{
    const next=[...basis,A];if(rank(next.map(x=>x.flat()))>basis.length){basis.push(A);return true;}return false;
  };
  seed.forEach(extend);
  for(let i=0;i<basis.length;i++)for(const f of steps)extend(f(basis[i]));
  for(const A of basis)for(const f of steps)assert.equal(rank([...basis,f(A)].map(x=>x.flat())),basis.length);
  return basis;
}
function readSource() {
  const paths=["Sources/Notation/Primitive.swift","Checks/LocalPolicyCourt.swift","Checks/DerivedContactRelations.swift"];
  const texts=paths.map(p=>fs.readFileSync(path.join(root,p),"utf8"));
  const paired=texts[0].match(/public enum Paired\b[^{}]*\{[^{}]*\}/g);assert.equal(paired.length,1);
  const gate=texts[1].slice(0,texts[1].indexOf("public typealias CourtPolicy"));
  let source=paired[0]+"\n"+gate+"\n"+texts[2];
  const tags=["Never","Paired<Never, Never>","Paired<Never, Paired<Never, Never>>"];
  const perms=[[0,1,2],[1,0,2],[0,2,1],[1,2,0],[2,0,1],[2,1,0]];
  perms.forEach((p,i)=>source+=`\npublic typealias DC${i} = DerivedContactTriple<${p.map(j=>tags[j]).join(", ")}>\n`);
  const equation=(name,a,b)=>`\npublic typealias ${name} = LocalCourtSame<${a}, ${b}>\npublic typealias Use${name} = LocalCourtUse<${name}>\n`;
  function judge(a,b){const v=judgeWhereTexts(source+equation("ReadDC",a,b));assert.equal(v.judged,1);return v.refusals.length===0;}
  const action={};
  for(const name of ["P","Q"])action[name]=perms.map((_,i)=>{
    const accepted=perms.map((_,j)=>j).filter(j=>judge(`DC${i}.${name}`,`DC${j}`));
    assert.equal(accepted.length,1,"Unique result must be read from the current constructor");return accepted[0];
  });
  let certificate=source;
  for(let i=0;i<6;i++)for(const suffix of ["P.P","Q.Q","P.Q.P.Q.P.Q"])
    certificate+=equation(`Law${i}_${suffix.replaceAll(".","")}`,`DC${i}.${suffix}`,`DC${i}`);
  const verdict=judgeWhereTexts(certificate);assert.equal(verdict.judged,18);assert.deepEqual(verdict.refusals,[]);
  const refusals=[['Order is not freely exchangeable','DC0.P.Q','DC0.Q.P'],
    ['One swap is not identity','DC0.P','DC0'],['Two contacts are not a return','DC0.P.Q','DC0']];
  for(const [,a,b] of refusals)assert.equal(judge(a,b),false);
  // Meaning mutation, not a hash-only test: replacing Q with P is rejected
  // against the already requested current-root action on all six forms.
  const changed=source.replace('DerivedContactTriple<A, C, B>','DerivedContactTriple<B, A, C>');
  assert.notEqual(changed,source);
  const mutation=judgeWhereTexts(changed+equation("ChangedQ","DC0.Q",`DC${action.Q[0]}`));
  assert(mutation.refusals.length>0);
  return {action,perms,certificate,source_sha256:Object.fromEntries([...paths.map((p,i)=>[p,sha(texts[i])]),[judgeFile,sha(fs.readFileSync(judgeFile))]]),
    equalities:18,refusals:refusals.map(x=>x[0]),meaning_mutation_rejected:true};
}
function permutationMatrix(images) {
  const A=mat(images.length);images.forEach((j,i)=>A[j][i]=one);return A;
}
const X=[[z,one],[one,z]],Y=[[z,neg(ii)],[ii,z]],Z=[[one,z],[z,c(-1)]];
function at(A,i,n) {let out=[[one]];for(let j=0;j<n;j++)out=kron(out,i===j?A:eye(2));return out;}
function sum(A) {return A.reduce(plus,mat(A[0].length));}
function spinFromPorts(order) {
  const n=order.length;
  return permutationMatrix(Array.from({length:2**n},(_,k)=>{
    const bits=Array.from({length:n},(_,q)=>(k>>(n-1-q))&1);
    return order.map(j=>bits[j]).reduce((a,b)=>2*a+b,0);
  }));
}
function identities(P,Q) {
  const I=eye(P.length),zero=mat(P.length),r=mm(P,Q),r2=mm(r,r);
  eq(adj(P),P);eq(adj(Q),Q);eq(mm(P,P),I);eq(mm(Q,Q),I);eq(mm(r2,r),I);
  const Pi=scale(minus(scale(I,c(2)),plus(r,mm(Q,P))),c(1,0,3));
  const C=comm(P,Q),T=plus(P,scale(Q,c(2)));
  eq(adj(Pi),Pi);eq(mm(Pi,Pi),Pi);eq(comm(Pi,P),zero);eq(comm(Pi,Q),zero);
  eq(mm(adj(C),C),scale(Pi,c(3)),"Contrast norm determines sector support");
  eq(mm(Pi,plus(r,mm(Q,P))),scale(Pi,c(-1)));
  eq(mm(Pi,mm(T,T)),scale(Pi,c(3)));eq(mm(Pi,plus(mm(T,P),mm(P,T))),zero);
  return {Pi,C,T};
}

function run() {
  const source=readSource();
  // The regular representation has all six independent group-algebra basis
  // elements. This is stronger than testing only one two-dimensional irrep.
  const regularP=permutationMatrix(source.action.P),regularQ=permutationMatrix(source.action.Q);
  assert.equal(rank([eye(6),regularP,regularQ,mm(regularP,regularQ),mm(regularQ,regularP),
    mm(mm(regularP,regularQ),regularP)].map(A=>A.flat())),6);
  const universal=identities(regularP,regularQ);assert.equal(scalarText(tr(universal.Pi)),"4/1");
  // The interpretation is explicitly a coherent, phase-free permutation.
  // Its addressed permutation is READ from the current Swift constructor.
  const portsP=source.perms[source.action.P[0]],portsQ=source.perms[source.action.Q[0]];
  const P=spinFromPorts(portsP),Q=spinFromPorts(portsQ),I=eye(8),{Pi,C}=identities(P,Q);
  eq(identities(eye(2),eye(2)).Pi,mat(2),"A return without contrast need not contain a logical sector");
  assert.equal(scalarText(tr(Pi)),"4/1");

  const collective=[X,Y,Z].map(A=>sum([0,1,2].map(i=>at(A,i,3))));
  for(const J of collective){eq(comm(J,P),mat(8));eq(comm(J,Q),mat(8));}
  const two=commutant([X,Y,Z].map(A=>sum([0,1].map(i=>at(A,i,2)))));
  const three=commutant(collective),broken=commutant([...collective,at(Z,0,3)]);
  assert.equal(two.length,2);assert.equal(three.length,5);assert.equal(broken.length,2);
  for(const basis of [two,broken])for(const A of basis)for(const B of basis)assert(isZero(comm(A,B)));
  assert(!isZero(comm(P,Q)));assert(!isZero(comm(at(Z,0,3),P)));

  // A derived frame, not an input premise. Columns: L0G0,L0G1,L1G0,L1G1.
  // Norms are 6,6,2,2. Keeping the frame unnormalised makes checks rational.
  const W=mat(8,4);
  for(const [row,col,value] of [[1,0,2],[2,0,-1],[4,0,-1],[3,1,1],[5,1,1],[6,1,-2],
      [2,2,1],[4,2,-1],[3,3,1],[5,3,-1]])W[row][col]=c(value);
  const metric=mm(adj(W),W),invMetric=mat(4);
  [6,6,2,2].forEach((v,i)=>{assert.deepEqual(metric[i][i],c(v));invMetric[i][i]=c(1,0,v);});
  const dual=mm(invMetric,adj(W));eq(mm(W,dual),Pi);eq(mm(dual,W),eye(4));
  const pL=Z,qL=[[c(-1,0,2),c(1,0,2)],[c(3,0,2),c(1,0,2)]];
  eq(mm(P,W),mm(W,kron(pL,eye(2))));eq(mm(Q,W),mm(W,kron(qL,eye(2))));
  for(let i=0;i<3;i++)eq(mm(collective[i],W),mm(W,kron(eye(2),[X,Y,Z][i])));

  // Singlet(12) + unknown spin(3): the input lives in G, NOT in L.
  const S=W.map(row=>row.slice(2,4));
  eq(mm(dual,S),[[z,z],[z,z],[one,z],[z,one]]);
  for(let i=0;i<3;i++)eq(mm(collective[i],S),mm(S,[X,Y,Z][i]));
  // All fixed two-spin ancillary vectors admitting EVERY state of spin 3
  // into Pi form exactly the one-dimensional singlet space.
  const ancillaConstraints=[];
  for(let b=0;b<2;b++) {
    const insert=mat(8,4);for(let a=0;a<4;a++)insert[2*a+b][a]=one;
    ancillaConstraints.push(...mm(minus(I,Pi),insert));
  }
  const ancillaryKernel=kernel(ancillaConstraints);assert.equal(ancillaryKernel.length,1);
  assert(!nz(ancillaryKernel[0][0]));assert(!nz(ancillaryKernel[0][3]));
  assert.deepEqual(add(ancillaryKernel[0][1],ancillaryKernel[0][2]),z);
  const outside=mat(8,1);outside[0][0]=one;
  eq(mm(Pi,outside),mat(8,1));eq(mm(P,outside),outside);eq(mm(Q,outside),outside);

  // Even granting sharp P/Q acquisitions, every permitted Kraus operator
  // is real. The exact backwards closure is only three-dimensional.
  const p=mm(Pi,P),q=mm(Pi,Q);
  const instruments=[p,q].flatMap(A=>[scale(plus(Pi,A),c(1,0,2)),scale(minus(Pi,A),c(1,0,2))]);
  const steps=[A=>mm(mm(P,A),P),A=>mm(mm(Q,A),Q),...instruments.map(K=>A=>mm(mm(K,A),K))];
  const realClosure=closure([Pi,p,q],steps);assert.equal(realClosure.length,3);
  const imaginary=scale(C,c(0,1,12)),rhoPlus=plus(scale(Pi,c(1,0,4)),imaginary),rhoMinus=minus(scale(Pi,c(1,0,4)),imaginary);
  eq(adj(rhoPlus),rhoPlus);eq(adj(rhoMinus),rhoMinus);
  assert.deepEqual(tr(rhoPlus),one);assert.deepEqual(tr(rhoMinus),one);
  eq(mm(imaginary,imaginary),scale(Pi,c(1,0,48))); // eigenvalues ±1/sqrt(48) < 1/4.
  for(const A of realClosure)assert.deepEqual(tr(mm(rhoPlus,A)),tr(mm(rhoMinus,A)));

  // One granted partial exchange exp(-i pi P/4), followed by Q acquisition.
  // U's square root cancels in U* A U, so no irrational arithmetic is used.
  const left=plus(I,scale(P,ii)),right=minus(I,scale(P,ii));
  const rotate=A=>scale(mm(mm(left,A),right),c(1,0,2));
  const qQuarter=rotate(q),fullClosure=closure([Pi,p,q], [...steps,rotate]);
  assert.equal(fullClosure.length,4);
  assert.deepEqual(tr(mm(rhoPlus,qQuarter)),c(1,0,2));
  assert.deepEqual(tr(mm(rhoMinus,qQuarter)),c(-1,0,2));
  // A finite-word obstruction stronger than a span count. In coordinates
  // (sqrt(3)*a, sqrt(3)*b, c), all three conjugations have dyadic matrices.
  const axisBasis=[mm(Pi,plus(P,scale(Q,c(2)))),scale(C,c(0,-1)),p];
  const axisMaps=[
    [[c(-1),z,z],[z,c(-1),z],[z,z,one]],
    [[c(1,0,2),z,c(-1,0,2)],[z,c(-1),z],[c(-3,0,2),z,c(-1,0,2)]],
    [[z,one,z],[c(-1),z,z],[z,z,one]]
  ];
  const axisActions=[A=>mm(mm(P,A),P),A=>mm(mm(Q,A),Q),rotate];
  axisMaps.forEach((R,k)=>axisBasis.forEach((A,j)=>
    eq(axisActions[k](A),sum(axisBasis.map((B,i)=>scale(B,R[i][j]))))));

  // Exact constructive sharp Y access with two tunable partial exchanges.
  // Faithful rational-matrix representation of Q(sqrt(2),sqrt(3)); no trig
  // approximation. The positive square-root embedding selects the angles.
  const fI=eye(4),s2=kron([[z,c(2)],[one,z]],eye(2)),s3=kron(eye(2),[[z,c(3)],[one,z]]);
  eq(mm(s2,s2),scale(fI,c(2)));eq(mm(s3,s3),scale(fI,c(3)));eq(comm(s2,s3),mat(4));
  const cos2t=scale(fI,c(-1,0,3)),sin2t=scale(s2,c(2,0,3));
  const nx=scale(s3,c(1,0,2)),nzField=scale(fI,c(-1,0,2));
  const firstX=mm(mm(nx,nzField),minus(fI,cos2t)),firstY=mm(nx,sin2t);
  const firstZ=plus(cos2t,mm(mm(nzField,nzField),minus(fI,cos2t)));
  const cos2a=scale(mm(s2,s3),c(1,0,3)),sin2a=scale(s3,c(1,0,3));
  eq(plus(mm(firstX,cos2a),mm(firstY,sin2a)),mat(4));
  eq(minus(mm(firstY,cos2a),mm(firstX,sin2a)),fI);eq(firstZ,mat(4));

  // Exact continuation on the WHOLE sector: arbitrary gauge dynamics can
  // be interleaved with controls without assuming a product input state.
  const gauge=at(X,0,3); // This physical local action is deliberately NOT claimed to be gauge.
  assert(!isZero(comm(gauge,P)));
  // Two DIFFERENT, noncommuting gauge/environment interactions. The retained
  // environment is never reset. Neither is chosen from a hidden input state.
  const WE=kron(W,eye(2)),dualE=kron(dual,eye(2)),PiE=kron(Pi,eye(2)),IE=eye(16);
  const gauge1=scale(plus(scale(eye(4),c(3)),scale(kron(X,X),c(0,4))),c(1,0,5));
  const gauge2=scale(plus(scale(eye(4),c(5)),scale(kron(Z,X),c(0,12))),c(1,0,13));
  assert(!isZero(comm(gauge1,gauge2)));
  const embedGauge=G=>plus(mm(mm(WE,kron(eye(2),G)),dualE),minus(IE,PiE));
  const G1=embedGauge(gauge1),G2=embedGauge(gauge2);
  for(const G of [G1,G2]) {
    eq(mm(adj(G),G),IE);eq(comm(G,kron(P,eye(2))),mat(16));eq(comm(G,kron(Q,eye(2))),mat(16));
  }
  // Full operator identities, hence tensor extension to arbitrary reference,
  // including inputs already correlated with the retained environment.
  const Uscaled=kron(mm(Q,right),eye(2));
  const actualScaled=mm(mm(G2,kron(Q,eye(2))),mm(G1,kron(right,eye(2))));
  for(const A of fullClosure) {
    const AE=kron(A,eye(2));
    eq(mm(mm(adj(actualScaled),AE),actualScaled),mm(mm(adj(Uscaled),AE),Uscaled));
  }

  // The same classical permutation table has a destructive implementation.
  // Measurement in the addressed basis followed by relabelling has the
  // correct table, but squaring it yields dephasing, not the identity.
  const diagonal=A=>A.map((row,i)=>row.map((x,j)=>i===j?x:z));
  const classicalP=A=>mm(mm(P,diagonal(A)),P);
  for(let j=0;j<8;j++) {const A=mat(8);A[j][j]=one;eq(classicalP(A),mm(mm(P,A),P));}
  const coherence=mat(8);for(const i of [0,1])for(const j of [0,1])coherence[i][j]=c(1,0,2);
  eq(classicalP(classicalP(coherence)),diagonal(coherence));
  assert(!isZero(minus(classicalP(classicalP(coherence)),coherence)));

  // Covariance is not conservation: a replacing channel commutes with all
  // conjugations yet sends traceless logical observables to zero.
  const depol=A=>scale(eye(2),mul(tr(A),c(1,0,2)));
  eq(depol(Z),mat(2));assert(!isZero(Z));
  for(const U of [X,Z])for(const A of [X,Y,Z,eye(2)])
    eq(depol(mm(mm(U,A),U)),mm(mm(U,depol(A)),U));

  return {source:{equalities:source.equalities,expected_refusals:source.refusals,
      meaning_mutation_rejected:source.meaning_mutation_rejected,sha256:source.source_sha256},
    exact_arithmetic:"Gaussian rationals with BigInt; zero tolerances",interpreted_source_ports:{P:portsP,Q:portsQ},
    universal_group_algebra_dimension:6,physical_spin_sector_dimension:4,
    conserved_algebra_dimensions:{two_spins:two.length,three_spins:three.length,three_with_independent_first_Z:broken.length},
    two_spin_and_broken_algebras_commutative:true,
    future_question_closure:{fixed_swaps_and_sharp_readings:realClosure.length,with_one_partial_exchange:fullClosure.length},
    fixed_quarter_axis_invariant:"(sqrt(3)*a, sqrt(3)*b, c), a,b,c dyadic; excludes exact Y axis in every finite word",
    new_reading_on_previously_indistinguishable_states:[scalarText(tr(mm(rhoPlus,qQuarter))),scalarText(tr(mm(rhoMinus,qQuarter)))],
    tunable_sharp_Y_construction:"U = exp(-i t Q) exp(-i alpha P), t=acos(-1/3)/2, alpha=atan(1/sqrt(2))/2; U* P U = Y_L",
    ingress:{all_zero_cannot_enter_sector:true,singlet_plus_unknown_spin_keeps_unknown_in_gauge:true,
      ancillary_subspace_admitting_every_input_dimension:ancillaryKernel.length},
    whole_sector_continuation_verified:true,retained_noncommuting_environment_episodes:2,
    classical_table_is_not_coherent_contact:true,
    scope:"Conditional mathematical construction; source court checks symbolic rearrangements only. No hardware admission, encoder availability, or full Swift quantum theorem.",
    certificate:source.certificate};
}
if(require.main===module) {
  const out=run(),certificate=out.certificate;delete out.certificate;
  if(process.argv[2]) {const dir=path.resolve(process.argv[2]);fs.mkdirSync(dir,{recursive:true});
    fs.writeFileSync(path.join(dir,"checks.json"),JSON.stringify(out,null,2)+"\n");
    fs.writeFileSync(path.join(dir,"ContactWordCertificate.swift"),certificate);
  }
  console.log(JSON.stringify(out,null,2));
}
module.exports={run};
