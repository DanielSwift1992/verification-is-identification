#!/usr/bin/env python3
"""Synthesize words and acquisitions from the same current finite semantics.

Search does not receive a realized source. Known Pauli corrections are moved
to the end; search exhausts at most two slot and two standalone-A calls.
Prices are declared comparison units, not measured hardware error or dollars.
"""
from copy import deepcopy
import hashlib
import json
from pathlib import Path
import argparse

from environment import Environment,load,rows,write,digest
from build_from_source import ROOT,HERE,run

PRICES={
 'acquire':{'probe':1,'A':5,'F':1,'same_A':True},
 'one_A':{'probe':30,'A':5,'F':1,'same_A':True},
 'two_A':{'probe':30,'A':1,'F':5,'same_A':True},
 'old_access':{'probe':1,'A':5,'F':1,'same_A':False},
}


def uid(goal,program):
    raw=json.dumps([goal,program],separators=(',',':')).encode()
    return 'route:'+hashlib.sha256(raw).hexdigest()[:24]


def words(reading):
    compose=reading['compose'];zero=(0,)*16
    layers={(0,0):{zero:(0,[])}};frontier={};states=0
    def put(goal,support,resource,program):
        candidates=frontier.setdefault((goal,support),[])
        vector=(resource['A'],resource['F'],resource['known_gates'])
        if any(all(x<=y for x,y in zip(v,vector)) for v,_ in candidates):return
        candidates[:]=[(v,r) for v,r in candidates if not all(x<=y for x,y in zip(vector,v))]
        candidates.append((vector,{'goal':goal,'support':support,'resources':resource,'program':program}))
    for total in range(5):
        for a in range(3):
            f=total-a
            if not 0<=f<=2:continue
            for profile,(controls,program) in list(layers.get((a,f),{}).items()):
                states+=1
                if f:
                    for letter in 'IXYZ':
                        c=reading['transitions'][letter][0]
                        corrected=[compose[c][g] for g in profile]
                        for goal in set(corrected):
                            support=sum(1<<i for i,g in enumerate(corrected) if g==goal)
                            resource={'A':a,'F':f,'known_gates':controls+int(letter!='I')}
                            put(goal,support,resource,program+[{'kind':'pauli','value':letter}])
                extensions=[]
                if a<2:extensions.append((a+1,f,reading['separate'],0,{'kind':'A','source':'resident.first'}))
                if f<2:
                    extensions.extend((a,f+1,reading['slots'][g['id']],len(g['word']),
                          {'kind':'slot','goal':g['id'],'source':'resident'}) for g in reading['goals'])
                for aa,ff,operator,cost,op in extensions:
                    target=tuple(compose[v][p] for v,p in zip(operator,profile))
                    new=(controls+cost,program+[op]);layer=layers.setdefault((aa,ff),{})
                    if target not in layer or new[0]<layer[target][0]:layer[target]=new
    actions={uid(r['goal'],r['program']):r for xs in frontier.values() for _,r in xs}
    return actions,{'bounded_joint_states':states,'nondominated_words':len(actions),
                    'bounds':{'A':2,'F':2,'F_minimum':1},
                    'normalization':'External Paulis can be moved to the end because F_C P = (C P C†) F_C up to phase.'}


def compile_policies(base,reading,actions):
    split={p['id']:[sum(1<<i for i,b in enumerate(p['replies']) if b==v) for v in (0,1)]
           for p in reading['probes']}
    states=base['states'];policies={};used=set()
    for name,price in PRICES.items():
        view={}
        for goal in range(24):
            candidates=[(key,r) for key,r in actions.items() if r['goal']==goal and (price['same_A'] or r['resources']['A']==0)]
            candidates.sort(key=lambda pair:(price['A']*pair[1]['resources']['A']+price['F']*pair[1]['resources']['F'],pair[1]['resources']['known_gates'],pair[0]))
            policy={}
            for state in states:
                common=next(((k,r) for k,r in candidates if state & ~r['support']==0),None)
                if common:
                    key,r=common;cost=price['A']*r['resources']['A']+price['F']*r['resources']['F']
                    best={'kind':'act','action':key,'depth':0,'value':cost}
                    score=(cost,0,r['resources']['known_gates'],key)
                else:best=None;score=None
                for probe,bits in split.items():
                    branches=[b&state for b in bits]
                    if any(b==0 or b==state for b in branches):continue
                    children=[policy[str(b)] for b in branches]
                    cost=price['probe']+max(c['value'] for c in children)
                    depth=1+max(c['depth'] for c in children)
                    candidate=(cost,depth,0,probe)
                    if score is None or candidate<score:
                        best={'kind':'probe','probe':probe,'next':branches,'depth':depth,'value':cost};score=candidate
                assert best is not None
                policy[str(state)]=best
                if best['kind']=='act':used.add(best['action'])
            view[str(goal)]=policy
        policies[name]=view
    return policies,used


def verify_policies(base,reading,all_actions,policies):
    # Independent Bellman check against ALL searched words, including words
    # not selected for publication. Truth tables come from the type source.
    checked=0
    for name,view in policies.items():
        price=PRICES[name]
        for goal,policy in view.items():
            routes=[r for r in all_actions.values() if r['goal']==int(goal) and (price['same_A'] or r['resources']['A']==0)]
            for state in base['states']:
                alternatives=[price['A']*r['resources']['A']+price['F']*r['resources']['F']
                              for r in routes if state & ~r['support']==0]
                for p in reading['probes']:
                    bs=[sum(1<<i for i in rows(state) if p['replies'][i]==bit) for bit in (0,1)]
                    if all(b and b!=state for b in bs):alternatives.append(price['probe']+max(policy[str(b)]['value'] for b in bs))
                node=policy[str(state)];assert node['value']==min(alternatives)
                if node['kind']=='act':
                    r=all_actions[node['action']]
                    assert r['goal']==int(goal) and state & ~r['support']==0
                    assert price['same_A'] or r['resources']['A']==0
                    assert node['value']==price['A']*r['resources']['A']+price['F']*r['resources']['F']
                else:
                    p=next(p for p in reading['probes'] if p['id']==node['probe'])
                    bs=[sum(1<<i for i in rows(state) if p['replies'][i]==bit) for bit in (0,1)]
                    assert node['next']==bs and all(bs)
                    assert node['value']==price['probe']+max(policy[str(b)]['value'] for b in bs)
                checked+=1
    return checked


def build(base_dir,output):
    if output.exists():raise ValueError('Use a new output directory')
    output.mkdir(parents=True)
    base,base_id=load(base_dir)
    original=json.loads((base_dir/'source-reading.json').read_text())
    source=json.loads(run(['node',HERE/'routed_court.js','read']))
    write(output/'source-reading.json',source)
    actions,search=words(source)
    planning={**source,'probes':original['probes']}
    policies,used=compile_policies(base,planning,actions)
    checked=verify_policies(base,planning,actions,policies)
    published={k:v for k,v in actions.items() if k in used}
    write(output/'routes.json',{'schema':'vi.same-A-routes.v1','source_sha256':source['source_sha256'],'actions':published})
    write(output/'policies.json',{'prices':PRICES,'policies':policies})
    certificate=json.loads(run(['node',HERE/'routed_court.js','check',output]))
    for proof in certificate['proofs']:
        native=run([ROOT/'.build/arm64-apple-macosx/debug/Tools','judge','where',output/proof['file']])
        assert 'THE WHERE holds' in native and f"{proof['equalities']} equalities" in native
        proof['native']=native.strip()
    assert json.loads(run(['node',HERE/'routed_court.js','read']))==source
    result={'base_controller_sha256':base_id,'search':search,'weighted_nodes_checked':checked,
       'certificate':certificate,'file_sha256':{n:digest(output/n) for n in ['source-reading.json','routes.json','policies.json']},
       'implementation_sha256':{str(p.relative_to(ROOT)):digest(p) for p in [Path(__file__),HERE/'routed_court.js',HERE/'environment.py']}}
    write(output/'build.json',result)
    return result


class RoutedEnvironment(Environment):
    """One added continuation kind; acquisition/change/journal stay inherited."""
    def __init__(self,base_dir,extension,journal,price):
        extension=Path(extension);self.extension_report=json.loads((extension/'build.json').read_text())
        for name,sha in self.extension_report['file_sha256'].items():
            if digest(extension/name)!=sha:raise ValueError('Routed artifact changed')
        for name,sha in self.extension_report['implementation_sha256'].items():
            if digest(ROOT/name)!=sha:raise ValueError('Routed interpreter changed')
        self.reading=json.loads((extension/'source-reading.json').read_text())
        self.routes=json.loads((extension/'routes.json').read_text())['actions']
        p=json.loads((extension/'policies.json').read_text());self.price=p['prices'][price];self.view=p['policies'][price]
        self.price_name=price
        super().__init__(base_dir,journal)

    def execution_identity(self,base_identity):
        if base_identity!=self.extension_report['base_controller_sha256']:raise ValueError('Wrong base environment')
        return hashlib.sha256(json.dumps([base_identity,self.extension_report['file_sha256'],self.price_name],sort_keys=True).encode()).hexdigest()

    def _ready(self):
        super()._ready()
        for name,sha in self.reading['source_sha256'].items():
            if digest(ROOT/name)!=sha:raise ValueError('Current routed source changed')

    def validate_port(self,port):
        if self.price['same_A']:
            binding=port.reentry_binding()
            if (binding['resident']!=port.resident or not binding['slot_first']
                or binding['slot_first']!=binding['separate_first']):
                raise ValueError('No owned link from the separate port to the same A')

    def node(self,state,request):
        if request['kind']=='clifford':
            g=next(g['id'] for g in self.reading['goals'] if g['word']==request['middle'])
            return self.view[str(g)][str(state)]
        return super().node(state,request)

    def native(self,request,node):
        if not node['action'].startswith('route:'):return super().native(request,node)
        action=self.routes[node['action']]
        goal=next(g['id'] for g in self.reading['goals'] if g['word']==request['middle'])
        if action['goal']!=goal or self.state & ~action['support']:
            raise ValueError('Route not applicable to the full current family and question')
        ops=[]
        for op in action['program']:
            if op['kind']=='slot':ops.append({'kind':'slot','middle':self.reading['goals'][op['goal']]['word'],'source':'resident'})
            else:ops.append(deepcopy(op))
        return {'route':ops}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--base',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();r=build(a.base.resolve(),a.output.resolve())
    print(json.dumps({'search':r['search'],'weighted_nodes_checked':r['weighted_nodes_checked'],
                     'actions':r['certificate']['actions'],'equalities':r['certificate']['equalities']},indent=2))
