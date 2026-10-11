"use strict";
// Exact arithmetic extracted unchanged from derived_contact_boundary_checks.js.
// The prior checked file is retained byte-for-byte; this module has no physical semantics.
const assert=require("node:assert/strict");
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

module.exports={c,z,one,ii,nz,add,neg,sub,mul,conj,div,scalarText,mat,eye,scale,plus,minus,adj,mm,comm,tr,eq,isZero,kron,rref,rank,kernel,commutant,closure};
