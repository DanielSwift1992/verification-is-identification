#!/usr/bin/env python3
"""Finite implementation qualification, not a proof of the Swift/Lean bridge.
Run beneath the shared lockf with declared Swift, own TMPDIR/cache and >=5 GiB.
A new empty --output is required; previous observations are never overwritten.
"""
import argparse
from collections import Counter
from copy import deepcopy
import hashlib
import json
import math
from pathlib import Path
import shutil
import subprocess
import time


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--native',type=Path,required=True)
    ap.add_argument('--tools',type=Path,required=True)
    ap.add_argument('--lean',type=Path,required=True)
    args=ap.parse_args()
    project=Path(__file__).resolve().parents[3]
    repo=project.parents[1]
    out=args.output.resolve()
    if out.exists() and any(out.iterdir()): raise SystemExit('Output must be absent or empty')
    out.mkdir(parents=True,exist_ok=True)
    subprocess.run(['df','-h','/'],check=True)
    free=shutil.disk_usage('/').free
    if free<5*1024**3: raise SystemExit('STOP: less than 5 GiB free')
    core=sorted((repo/'Sources/ContinuationRecord').glob('*.swift'))
    court=sorted((repo/'Sources/Court').glob('*.swift'))
    contract=repo/'Contracts/Court/continuation-relations-v1'
    driver=Path(__file__).with_name('FixtureProbe.swift')
    inputs=core+court+[driver,Path(__file__),repo/'Sources/Notation/Primitive.swift',contract/'contract.json']
    inputs += [contract/name for name in ['image-cases.swift','agreement-cases.swift','repeat-cases.swift']]
    inputs += sorted((repo/'Proofs/U5/Record').rglob('*.lean'))
    sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
    before={str(p.relative_to(repo)):sha(p) for p in inputs}
    begin=time.monotonic()
    version=subprocess.check_output(['swiftc','--version'],text=True).strip()
    if '6.3.3' not in version: raise SystemExit('Expected declared Swift 6.3.3')
    lib=out/'libContinuationRecord.dylib';probe=out/'fixture-probe'
    subprocess.run(['swiftc','-emit-module','-emit-library','-module-name','ContinuationRecord',*map(str,core),
        '-o',str(lib),'-emit-module-path',str(out/'ContinuationRecord.swiftmodule')],check=True)
    subprocess.run(['swiftc','-I',str(out),'-L',str(out),'-lContinuationRecord','-Xlinker','-rpath','-Xlinker',str(out),
        *map(str,court),str(driver),'-o',str(probe)],check=True)
    observed=out/'observed'
    subprocess.run([str(probe),str(repo),str(observed)],check=True)
    exported=json.loads((observed/'worlds.json').read_text())
    work=out/'inputs';work.mkdir()
    rows=[];sequence=0
    dump=lambda value:json.dumps(value,ensure_ascii=True,separators=(',',':')).encode()
    def invoke(command):
        return subprocess.run(list(map(str,command)),capture_output=True,timeout=40)
    def compare(name,mode,proof,world,expected,group):
        nonlocal sequence
        sequence+=1
        if group in ['malformed','unread counterpart']:
            obj=json.loads(proof);obj['record']=world.decode('utf-8');proof=dump(obj)
        pf=work/f'{sequence}.proof.json';wf=work/f'{sequence}.world.json' 
        pf.write_bytes(proof);wf.write_bytes(world)
        commands=[[args.native,'replay',mode,pf,wf],[args.lean,mode,pf,wf],
                  [args.tools,'judge','replay-continuation','--record',mode,pf,wf]]
        results=[invoke(c) for c in commands]
        want=proof+(b'' if proof.endswith(b'\n') else b'\n') if expected in (0,1) else b''
        ok=all(r.returncode==expected and r.stdout==want for r in results)
        row=dict(name=name,mode=mode,group=group,expected=expected,
            codes=[r.returncode for r in results],printEqual=results[0].stdout==results[1].stdout==results[2].stdout,
            worldSHA256=hashlib.sha256(world).hexdigest(),proofSHA256=hashlib.sha256(proof).hexdigest(),
            stdoutSHA256=[hashlib.sha256(r.stdout).hexdigest() for r in results],
            diagnostics=[r.stderr.decode(errors='replace').strip() for r in results],ok=ok)
        rows.append(row)
        if group in ['malformed','unread counterpart'] and not row['diagnostics'][0].startswith('Continuation record unresolved: record'):
            ok=False;row['ok']=False
        if mode in ['--image','--agreement'] and any('record.observation' in d or
                (mode=='--image' and 'record.question' in d) for d in row['diagnostics']):
            ok=False;row['ok']=False
        if name=='--agreement/output-sort-gap' and any('record.source.sort' in d for d in row['diagnostics']):
            ok=False;row['ok']=False
        if not ok:
            (out/'failure.json').write_text(json.dumps(row,indent=2)+'\n')
            raise AssertionError(name+': '+str(row['codes'])+'; '+str(row['diagnostics']))
    base={}
    dataset=[]
    for row in exported:
        if row['layer']=='unread counterpart':continue
        key=row['id'];mode=row['mode'];expected=row['expectedCode']
        world=(observed/(key+'.world.json')).read_bytes();proof=(observed/(key+'.proof.json')).read_bytes()
        base[key]=(mode,world,proof,expected)
        dataset.append(dict(row,record=world.decode(),proof=proof.decode()))
        compare(key,mode,proof,world,expected,'contract' if row['layer']=='admitted correspondence' else 'record-only')
        # Both command entrances construct these same canonical payload bytes.
        derived=work/(key+'.derived.json')
        native=invoke([args.native,mode,'--certificate',derived,work/f'{sequence}.world.json'])
        if native.returncode!=expected or derived.read_bytes()!=proof or native.stdout!=proof+b'\n':
            raise AssertionError('native construction differs: '+key)
        compact=dump(json.loads(proof))
        for label,variant in [('compact',compact),('LF',compact+b'\n'),('whitespace',b' '+compact+b'\t'),('CRLF',compact+b'\r\n')]:
            compare(key+'/'+label,mode,variant,world,expected,'printing')
    def generic(mode):
        source=[{'pair':[1,2]},{'sort':0},{'sort':0}]
        if mode=='--image': return dict(schema=3,source=source,equalities=[],image={'pair':[{'place':[0]},{'place':[1]}]})
        if mode=='--agreement': return dict(schema=4,source=source,equalities=[],output=deepcopy(source),question={'pair':[{'place':[0]},{'place':[1]}]})
        return dict(schema=2,source=source,equalities=[],observation={'place':[0]},question={'place':[0]},hiddenActions=[{'at':[],'image':[[0],[1]]}])
    def unread(row):
        v=generic(row['mode']);n=row['request']
        if n=='SourceIsNotOutput':
            v['image']={'place':[0]};v['promise']=[dict(at=[],left=[0],right=[],basis='declared')]
        elif n=='UnreadPromiseAxis':v['promises']=[]
        elif n in ['DifferentPromiseSorts','DifferentAgreementSorts']:
            v['source'][2]['sort']=1
            if row['mode']=='--agreement':v['output'][2]['sort']=1
            v['promise']=[dict(at=[],left=[0],right=[1],basis='declared')]
        elif n=='MalformedImagePromise':v['promise']=[dict(at=[],left=[[0]],right=[1],basis='declared')]
        elif n=='UnrootedImage':v['image']={'sort':0}
        elif n=='ImageTemplateIsNotAChoice':v['hiddenActions']=[{'at':[],'image':[[0],[0]]}]
        elif n in ['MalformedImageFamily','MalformedRepeatMember']:v['hiddenActions']=[{'at':[],'image':[[0]]}]
        elif n in ['SourceAliasOutput','SwappedOutput','OutputThroughSourceCut','BorrowedOutput']:v['output']=[{'place':[0]}]
        elif n=='MissingBoundSources':v['boundOutputs']={'place':[0]}
        elif n=='MissingBoundOutputs':v['boundSources']={'place':[0]}
        elif n=='MismatchedBindingTrees':
            v['boundOutputs']={'pair':[{'place':[0]},{'place':[1]}]};v['boundSources']={'place':[0]}
        elif n=='SourceIsNotOutputPromise':
            v['output']=[{'sort':0}];v['promise']=[dict(at=[],left=[0],right=[],basis='declared')]
        elif n=='UnreadBindingAxis':v['boundSource']={'place':[0]}
        elif n=='UnrootedAgreementQuestion':v['question']={'sort':0}
        elif n=='MissingHidden':v.pop('hiddenActions')
        elif n=='UnreadRepeatAxis':v['hiddenAction']=v.pop('hiddenActions')
        else:raise AssertionError('No explicit unread counterpart: '+n)
        return v
    for row in exported:
        if row['layer']!='unread counterpart':continue
        world=dump(unread(row));mode=row['mode'];proof=next(b[2] for b in base.values() if b[0]==mode)
        compare(row['id'],mode,proof,world,2,'unread counterpart')
        if not rows[-1]['diagnostics'][0].startswith('Continuation record unresolved: record'):
            raise AssertionError('counterpart must fail world admission: '+row['id'])
        dataset.append(dict(row,record=world.decode()))
    # Generic corruption of the declared calculus, independently of case names.
    for key,(mode,world,raw,expected) in base.items():
        proof=json.loads(raw);kind='image' if mode=='--image' else 'agreement' if mode=='--agreement' else 'repetition'
        body=proof[kind]
        def forged(label,edit):
            value=deepcopy(proof);edit(value);compare(key+'/'+label,mode,dump(value),world,2,'forged')
        forged('format',lambda v:v.__setitem__('format',8))
        forged('record',lambda v:v.__setitem__('record','{}'))
        forged('extra-axis',lambda v:v.__setitem__('spare',1))
        forged('classes',lambda v:v[kind].__setitem__('classes',[]))
        forged('forests',lambda v:v[kind].__setitem__('connections',[]))
        if kind=='image':
            forged('members',lambda v:v[kind].__setitem__('images',[]))
            forged('member-address',lambda v:v[kind]['images'][0]['member'].append('Left'))
            forged('source-index',lambda v:v[kind]['images'][0]['sourceClassIndices'].__setitem__(0,999))
            forged('output-classes',lambda v:v[kind]['images'][0].__setitem__('classes',[]))
            forged('output-connections',lambda v:v[kind]['images'][0].__setitem__('connections',[]))
            def flip(v):
                p=v[kind]['images'][0]['promise']
                v[kind]['images'][0]['promise']={'violated':{'edge':[]}} if 'holds' in p else {'holds':{'_0':[]}}
            forged('promise',flip)
        elif kind=='agreement':
            forged('output-classes',lambda v:v[kind].__setitem__('outputClasses',[]))
            forged('output-forests',lambda v:v[kind].__setitem__('outputConnections',[]))
            if 'constructed' in body['conclusion']:
                def plan(v):return v[kind]['conclusion']['constructed']['_0']
                forged('assignments',lambda v:plan(v).__setitem__('assignments',[]))
                forged('step',lambda v:plan(v).__setitem__('step',{'pick':{'_0':['Left']*80}}))
                forged('decoder',lambda v:plan(v).__setitem__('decoder',{'pick':{'_0':['Right']*80}}))
                forged('selections',lambda v:plan(v).__setitem__('selections',[]))
                forged('capacity',lambda v:plan(v)['capacities'][0].__setitem__('minimumResidualLeaves',plan(v)['capacities'][0]['minimumResidualLeaves']+1))
                if len(plan(proof)['capacities'])>1:forged('capacity-order',lambda v:plan(v)['capacities'].reverse())
                if plan(proof)['bindingBases']:forged('binding-bases',lambda v:plan(v).__setitem__('bindingBases',[]))
                if plan(proof)['residualLeaves']:forged('residual',lambda v:plan(v).pop('residual'))
            elif 'unavailable' in body['conclusion']:
                forged('unavailable',lambda v:v[kind].__setitem__('conclusion',{'unavailable':{'output':['Left']*80}}))
            elif 'wrongSort' in body['conclusion']:
                forged('wrong-sort',lambda v:v[kind].__setitem__('conclusion',{'wrongSort':{'binding':['Left']*80}}))
            else:
                def same(v):
                    box=v[kind]['conclusion']['incompatible'];box['right']=box['left']
                forged('incompatible',same)
        else:
            forged('required',lambda v:v[kind].__setitem__('required',[]))
            forged('evidence',lambda v:v[kind].__setitem__('hiddenActions',[]))
            conclusion=body.get('conclusion',{})
            if 'returned' in conclusion:
                def block(v):return v[kind]['conclusion']['returned']['_0']
                forged('cycles',lambda v:block(v).__setitem__('cycles',[]))
                forged('calls',lambda v:block(v).__setitem__('calls',str(int(block(v)['calls'])+1)))
                forged('decimal',lambda v:block(v).__setitem__('calls','0'+block(v)['calls']))
                forged('gcd',lambda v:block(v)['arithmetic'][0].__setitem__('gcd',block(v)['arithmetic'][0]['gcd']+1))
            elif 'obstructed' in conclusion:
                t=conclusion['obstructed']['_0'];n=len(t['vertices'])-1
                returned={'returned':{'_0':dict(cycles=[dict(member=t['member'],block=t['block'],vertices=t['vertices'],length=n)],
                    arithmetic=[dict(gcd=math.gcd(1,n),multiplier=n,value=str(n))],calls=str(n),additionalCalls=str(n-1))}}
                forged('tail-as-returned',lambda v:v[kind].__setitem__('conclusion',returned))
                forged('tail-index',lambda v:v[kind]['conclusion']['obstructed']['_0'].__setitem__('repeatedIndex',999))
            else:forged('false-premise',lambda v:v[kind].__setitem__('conclusion',{'returned':{'_0':dict(cycles=[],arithmetic=[],calls='1',additionalCalls='0')}}))
    # World admission adversaries: preserve key order to reach the named check.
    for mode in ['--image','--agreement','--repeat']:
        proto=generic(mode);proof=next(b[2] for b in base.values() if b[0]==mode)
        def malformed(label,edit):
            v=deepcopy(proto);edit(v);compare(mode+'/'+label,mode,proof,dump(v),2,'malformed')
        malformed('extra-axis',lambda v:v.__setitem__('unread',[]))
        malformed('source-cycle',lambda v:v['source'][0].__setitem__('pair',[0,2]))
        malformed('shared-node',lambda v:v['source'][0].__setitem__('pair',[1,1]))
        malformed('source-sort',lambda v:v['source'][1].__setitem__('sort',9))
        raw=dump(proto)
        for label,bytes_ in [('BOM',b'\xef\xbb\xbf'+raw),('LF',raw+b'\n'),('trailing',raw+b'{}'),('duplicate',raw.replace(b'"schema":',b'"schema":0,"schema":',1))]:
            compare(mode+'/'+label,mode,proof,bytes_,2,'malformed')
        if mode=='--image':
            malformed('nonleaf-cut',lambda v:v.__setitem__('image',{'place':[]}))
            malformed('empty-H',lambda v:v.__setitem__('hiddenActions',[]))
            malformed('incomplete-member',lambda v:v.__setitem__('hiddenActions',[dict(at=[],image=[[0]])]))
            def foreign(v):
                v['source'][2]['sort']=1;v['image']={'place':[0]};v['hiddenActions']=[dict(at=[],image=[[1]])]
            malformed('foreign-member-sort',foreign)
        elif mode=='--agreement':
            malformed('question-nonleaf',lambda v:v.__setitem__('question',{'place':[]}))
            malformed('source-as-output',lambda v:v.__setitem__('output',[{'place':[0]}]))
            malformed('output-sort-gap',lambda v:v['output'][1].__setitem__('sort',9))
            malformed('missing-bound-source',lambda v:v.__setitem__('boundOutputs',{'place':[0]}))
            def mismatch(v):v['boundOutputs']={'pair':[{'place':[0]},{'place':[1]}]};v['boundSources']={'place':[0]}
            malformed('binding-shape',mismatch)
        else:
            malformed('missing-H',lambda v:v.pop('hiddenActions'))
            malformed('empty-H',lambda v:v.__setitem__('hiddenActions',[]))
            malformed('short-H',lambda v:v['hiddenActions'][0].__setitem__('image',[[0]]))
            malformed('extra-image',lambda v:v.__setitem__('image',{'place':[0]}))
    # Matching a changed record string cannot launder an old proof for another world.
    for key,edit in [('image-LeftMarginal',lambda v:v.__setitem__('image',{'place':[1]})),
                     ('agreement-BindOriginal',lambda v:v.__setitem__('boundSources',{'place':[1]}))]:
        mode,world,proof,_=base[key];w=json.loads(world);edit(w);changed=dump(w);p=json.loads(proof);p['record']=changed.decode()
        compare(key+'/coherent-substitution',mode,dump(p),changed,2,'coherent substitution')
    after={str(p.relative_to(repo)):sha(p) for p in inputs}
    if before!=after:raise AssertionError('Inputs changed during qualification')
    frozen=Path(__file__).resolve().parents[1]/'Cases/worlds.json'
    corpus=dict(baseRevision='d075be57cd5a04c6138480ee4e6130a484c94de8',cases=dataset)
    if frozen.exists() and json.loads(frozen.read_text())!=corpus:raise AssertionError('Frozen cases differ')
    (out/'worlds.json').write_text(json.dumps(corpus,ensure_ascii=False,indent=2)+'\n')
    receipt=dict(baseRevision=corpus['baseRevision'],sourceSHA256=before,inputsUnchanged=True,freeBytesBefore=free,
        swiftVersion=version,seconds=round(time.monotonic()-begin,3),comparisons=len(rows),groups=dict(Counter(r['group'] for r in rows)),
        exportedRows=len(exported),binarySHA256=dict(native=sha(args.native),tools=sha(args.tools),lean=sha(args.lean),probe=sha(probe)),
        worldCorpusSHA256=sha(out/'worlds.json'),rows=rows,
        claim='Finite correspondence observations; no proof of Swift, payload decoder, exporter, IO or toolchain.')
    (out/'receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({k:receipt[k] for k in ['comparisons','groups','inputsUnchanged','seconds']}),flush=True)

if __name__=='__main__':main()
