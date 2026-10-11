"use strict";
// Read the coordinate exchange from the current Swift root and apply it.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const old=require('./orbit_return_court.js'),base=require('./court_bridge.js');
const root=path.resolve(__dirname,'../..');
const {judgeWhereTexts}=require(path.join(root,'../gate/bin/judge-where.js'));
function context(){
 const c=old.context(),name='Sources/Examples/OrbitSourceFrame.swift',s=fs.readFileSync(path.join(root,name),'utf8');
 c.source+='\n'+s;c.fingerprints[name]=base.digest(s);return c;
}
function read(c=context()){
 const source=old.read(c),permutation=[];
 for(let s=0;s<8;s++){
  const row=`OrbitReturnRoot.Row${s}.Law`,exchange=`OrbitCoordinateExchange<${row}.ProbeB, ${row}.Residue>`;
  const b=Number(base.reading(c,exchange+'.After.Left',['QBit0','QBit1']).slice(-1));
  const z=Number(base.reading(c,exchange+'.After.Right',['QBit0','QBit1']).slice(-1));
  const matches=source.rows.map((r,i)=>r.Control===source.rows[s].Control&&r.ProbeB===b&&r.Residue===z?i:-1).filter(i=>i>=0);
  assert.equal(matches.length,1);permutation.push(matches[0]);
 }
 return {schema:'vi.orbit-source-frame.v1',source,permutation,source_sha256:c.fingerprints};
}
function check(directory){
 const c=context(),source=read(c);let claims='',direct='',count=0;
 const eq=(a,b)=>claims+=base.equation('OrbitFrame'+count++,a,b);
 for(let s=0;s<8;s++){
  const row=`OrbitReturnRoot.Row${s}.Law`,target=`OrbitReturnRoot.Row${source.permutation[s]}.Law`;
  const exchange=`OrbitCoordinateExchange<${row}.ProbeB, ${row}.Residue>`;
  eq(exchange+'.After.Left',target+'.ProbeB');eq(exchange+'.After.Right',target+'.Residue');
  eq(exchange+'.Reversed.After',exchange+'.Before');eq(target+'.Control',row+'.Control');
  direct+=base.equation('DirectFrame'+s+'B',target+'.ProbeB',row+'.Residue');
  direct+=base.equation('DirectFrame'+s+'C',target+'.Residue',row+'.ProbeB');
  direct+=base.equation('DirectFrame'+s+'Return',`Paired<${target}.Residue, ${target}.ProbeB>`,`Paired<${row}.ProbeB, ${row}.Residue>`);
  direct+=base.equation('DirectFrame'+s+'Question',target+'.Control',row+'.Control');
 }
 const proof=c.source+'\n'+claims,r=judgeWhereTexts(proof);assert.equal(r.judged,count);assert.deepEqual(r.refusals,[]);
 const bad=c.source+'\n'+base.equation('BadFixedFrame','OrbitCoordinateExchange<QBit0, QBit1>.After','Paired<QBit0, QBit1>');
 const rejected=judgeWhereTexts(bad);assert.equal(rejected.judged,1);assert(rejected.refusals.length);
 const directProof=c.source+'\n'+direct,dr=judgeWhereTexts(directProof);assert.equal(dr.judged,count);assert.deepEqual(dr.refusals,[]);
 const directBad=c.source+'\n'+base.equation('BadDirectFrame','OrbitReturnRoot.Row2.Law.ProbeB','OrbitReturnRoot.Row1.Law.ProbeB');
 assert(judgeWhereTexts(directBad).refusals.length);
 if(directory){fs.mkdirSync(directory,{recursive:true});fs.writeFileSync(path.join(directory,'OrbitFrame.swift'),proof);
  fs.writeFileSync(path.join(directory,'RejectedOrbitFrame.swift'),bad);
  fs.writeFileSync(path.join(directory,'OrbitFrameDirect.swift'),directProof);
  fs.writeFileSync(path.join(directory,'RejectedOrbitFrameDirect.swift'),directBad);}
 return {source,equalities:count,expected_rejections:1,scope:'Constructed coordinate exchange, its reversal, and application to the current eight-row source. No physical stability or full compiler claim.'};
}
if(require.main===module)console.log(JSON.stringify(process.argv[2]==='read'?read():check(process.argv[3])));
module.exports={read,check};
