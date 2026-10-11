"use strict";
// Bounded aggregate audit. Child checks receive NO artifact directory.
// Existing manifests and their files are read-only and checked before/after.
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const {execFile}=require('node:child_process');
const root=path.resolve(__dirname,'../..'),base='Research/Artifacts/coordinated-continuation-20260917/';
const digest=p=>crypto.createHash('sha256').update(fs.readFileSync(path.join(root,p))).digest('hex');
function inventory(through=20){assert(Number.isSafeInteger(through)&&through>=1&&through<=100);
  const manifests=['Research/Artifacts/derived-contact-boundary-20260916/manifest.json',...Array.from({length:through},(_,i)=>base+`wave-${i+1}-manifest.json`)];
  const files=new Map(),manifestHashes=[];for(const p of manifests){manifestHashes.push({path:p,sha256:digest(p)});const m=JSON.parse(fs.readFileSync(path.join(root,p),'utf8'));
    for(const f of m.files){assert.equal(digest(f.path),f.sha256,'frozen file changed: '+f.path);if(files.has(f.path))assert.equal(files.get(f.path),f.sha256);files.set(f.path,f.sha256);}}
  return {manifests:manifestHashes,files:[...files].map(([path,sha256])=>({path,sha256})),scripts:[...files.keys()].filter(p=>/checks\.js$/.test(p))};}
function runScript(script){const start=performance.now();return new Promise(resolve=>{
  execFile(process.execPath,[path.join(root,script)],{cwd:root,encoding:'utf8',timeout:45000,maxBuffer:10*1024*1024},(error,stdout,stderr)=>{
    let result;try{result=JSON.parse(stdout);}catch{result={unparsedOutput:stdout};}
    resolve({script,passed:!error&&!Object.hasOwn(result,'unparsedOutput'),exitCode:error?.code??0,signal:error?.signal??null,
      elapsedMilliseconds:Math.round(performance.now()-start),result,stderr});});});}
async function audit(outputFile,through=20){const startedAt=new Date().toISOString(),before=inventory(through),pending=[...before.scripts],results=[];
  async function worker(){while(pending.length){const script=pending.shift(),r=await runScript(script);results.push(r);
      if(!r.passed||results.length%4===0)console.log(JSON.stringify({completed:results.length,total:before.scripts.length,last:script,passed:r.passed}));}}
  await Promise.all([worker(),worker()]);const after=inventory(through);assert.deepEqual(after,before,'frozen inventory changed during checks');
  results.sort((a,b)=>before.scripts.indexOf(a.script)-before.scripts.indexOf(b.script));
  const report={startedAt,finishedAt:new Date().toISOString(),scope:'targeted exact-model suites through wave '+through+'; not the full Swift regression or hardware validation',
    through,unchangedFiles:before.files.length,manifestHashes:before.manifests,commands:results.map(r=>({executable:process.execPath,args:[r.script]})),
    maxConcurrentChildren:2,perChildTimeoutMilliseconds:45000,allPassed:results.every(r=>r.passed),results};
  if(outputFile){const full=path.resolve(root,outputFile);assert(full.startsWith(path.join(root,'Research/Artifacts')+path.sep));fs.mkdirSync(path.dirname(full),{recursive:true});
    fs.writeFileSync(full,JSON.stringify(report,null,2)+'\n',{flag:'wx'});}
  return report;}
if(require.main===module)audit(process.argv[2],process.argv[3]?Number(process.argv[3]):20).then(r=>{console.log(JSON.stringify({allPassed:r.allPassed,suites:r.results.length,unchangedFiles:r.unchangedFiles,failures:r.results.filter(x=>!x.passed).map(x=>x.script)}));if(!r.allPassed)process.exitCode=1;}).catch(e=>{console.error(e);process.exitCode=1;});
module.exports={inventory,audit};
