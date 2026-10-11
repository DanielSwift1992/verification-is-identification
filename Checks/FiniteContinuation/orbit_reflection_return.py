#!/usr/bin/env python3
"""Exact whole-memory return from local projective involutions, no commutation.

The physical constructor generates U_s=exp(i theta_s) B_s diag(±1) B_s†.
Adjacent uses give a scalar, independently of the unknown memory input.
Ordered cancellation and remaining scalar counts are separate obligations.
"""
import numpy as np
import orbit_return as o
import orbit_future as f
import orbit_quantum_memory as memory

require=o.require


def model(source,relation='projective_involution'):
    require(relation in ('projective_involution','exact_involution'),'Unavailable memory relation')
    result=o.model(source);result['memory_relation']=relation
    result['oracle_contract']='same source/work XOR with persistent U_s whose squares are '+('identity' if relation=='exact_involution' else 'independent unknown source-dependent scalar phases')
    return result


def reduction(path):
    stack=[];pairs=[];counts=[0]*(max(path)+1)
    for index,s in enumerate(path):
        if stack and stack[-1][0]==s:
            _,before=stack.pop();pairs.append([before,index]);counts[s]+=1
        else:stack.append((s,index))
    return {'reduced':[s for s,_ in stack],'pairs':pairs,'square_counts':counts}


def whole_plan(m):
    _,length=f.cyclic_model(m);require(length>=2,'This minimum concerns a nontrivial q-fiber')
    relation=m.get('memory_relation');require(relation in ('exact_involution','projective_involution'),'Missing declared return relation')
    powers=[0,0] if relation=='exact_involution' else [k for _ in range(length) for k in (0,1)]
    _,info=f.word_data(m,powers);n=len(m['q']);reductions=[]
    for path in info['paths']:
        r=reduction(path);r['square_counts']+= [0]*(n-len(r['square_counts']));reductions.append(r)
    plan={'schema':'vi.whole-memory-return-plan.v1','model':o.fingerprint(m),
          'memory_relation':relation,'powers':powers,'computed':info,'reductions':reductions,
          'minimum_V':2 if relation=='exact_involution' else 2*length,
          'minimum_T':0 if relation=='exact_involution' else length,
          'scope':'Nonempty fixed forward V/T acquisition, returning source and workspace; full within-q source and memory preserved.'}
    verify(m,plan);return plan


def verify(m,plan):
    relation=m.get('memory_relation');_,length=f.cyclic_model(m);n=len(m['q'])
    require(length>=2 and relation in ('exact_involution','projective_involution'),'Wrong return domain')
    require(plan['schema']=='vi.whole-memory-return-plan.v1' and plan['model']==o.fingerprint(m)
            and plan['memory_relation']==relation,'Not an application of this return relation')
    _,info=f.word_data(m,plan['powers']);require(info==plan['computed'],'Different actual source path')
    reductions=[]
    for path in info['paths']:
        r=reduction(path);r['square_counts'] += [0]*(n-len(r['square_counts']))
        require(not r['reduced'],'Noncommuting memory word has not returned')
        reductions.append(r)
    require(reductions==plan['reductions'],'Not the actual ordered cancellation')
    if relation=='projective_involution':
        for cycle in f.cyclic_model(m)[0]:
            require(all(reductions[s]['square_counts']==reductions[cycle[0]]['square_counts'] for s in cycle),
                    'Local projective return leaves unresolved relative source phases')
    require(info['work_before_cleanup']==[0]*n,'Pair construction did not clear its actual scratch')
    minimum=2 if relation=='exact_involution' else 2*length
    minimum_t=0 if relation=='exact_involution' else length
    require(len(plan['powers'])==plan['minimum_V']==minimum and sum(plan['powers'])==plan['minimum_T']==minimum_t,
            'Not the stated attaining cost in this word language')
    return {'joint_V':minimum,'forward_T':minimum_t,'whole_internal_memory_returned':True}


class ReflectionDevice(memory.CommutingMemoryDevice):
    """Constructed reflections in different hidden frames, usually noncommuting."""
    def __init__(self,m,bases,signs,angles):
        n=len(m['q']);require(set(bases)==set(range(n)),'Missing per-source reflection frame')
        dimension=bases[0].shape[0]
        require(all(b.shape==(dimension,dimension) and np.max(abs(b.conj().T@b-np.eye(dimension)))<1e-12
                    for b in bases.values()),'Bad unitary frame')
        require(np.shape(signs)==(n,dimension) and all(x in (-1,1) for row in signs for x in row),
                'Not a constructed reflection spectrum')
        require(np.shape(angles)==(n,) and np.all(np.isfinite(angles)),'Bad scalar phases')
        relation=m.get('memory_relation');require(relation in ('exact_involution','projective_involution'),'Wrong device domain')
        if relation=='exact_involution':require(all(x==0 for x in angles),'Exact return cannot hide source-dependent scalar phases')
        self.model=o.fingerprint(m);self.owner=object();self.dimension=dimension
        self._actions=tuple(np.exp(1j*angles[s])*bases[s]@np.diag(signs[s])@bases[s].conj().T for s in range(n))


class WholeMemoryOrbit(memory.MemoryOrbit):
    def __init__(self,m,port):
        require(type(port) is ReflectionDevice,'The whole-memory exit needs its producing device construction, not a return label')
        super().__init__(m,port)

    def start(self,*args,**kwargs):
        raise ValueError('This physical family needs the whole-memory return constructor, not the commuting-word planner')

    def start_full(self,plan=None):
        require(self._answer is None and self.V_calls==0,'Do not restart an acquired carrier')
        certificate=whole_plan(self.m) if plan is None else plan
        verify(self.m,certificate)
        for index,k in enumerate(certificate['powers']):
            self._probe()
            if index==0:self._copy(certificate['computed']['decoder'])
            self._tick(k)
        self._clean(certificate['computed']['cleanup_by_answer']);self._read()
        # Ordered return plus scalar agreement derives this stronger boundary.
        # Counting alone would be wrong for the exact-involution short word.
        self._h=[0]*f.cyclic_model(self.m)[1]
        return certificate

    def internal_action(self,gate):
        self.boundary();dimension=self.environment_dimension
        require(gate.shape==(dimension,dimension) and np.max(abs(gate.conj().T@gate-np.eye(dimension)))<1e-12,
                'Not the declared known memory action')
        for a,matrix in list(self._branches.items()):
            shaped=matrix.reshape(dimension,self.physical_block,self.input_dim)
            self._branches[a]=np.einsum('ij,jrc->irc',gate,shaped).reshape(self.size,self.input_dim)
        self._ideal=np.kron(gate,np.eye(self.logical_block))@self._ideal

    def audit_return_target(self):
        return {a:np.kron(np.eye(self.environment_dimension*self.data_dim),
                         np.diag([int(q==a) for q in self.m['q']]))@self._ideal for a in set(self.m['q'])}


def finite_reflections(alphabet,depth):
    """Finite involutions realizing all reduced words up to a given depth.

    Vertices are words with no equal adjacent letters. Generator j toggles a
    final j; an outward edge absent at the boundary is a fixed point. Every
    internal edge is paired with its inverse. No dense matrices are needed.
    """
    require(alphabet>=2 and depth>=1,'A nontrivial finite tree is required')
    words=[()];layer=[()]
    for _ in range(depth):
        layer=[word+(j,) for word in layer for j in range(alphabet) if not word or word[-1]!=j]
        words.extend(layer)
    lookup={word:i for i,word in enumerate(words)};generators=[]
    for j in range(alphabet):
        permutation=[]
        for word in words:
            if word and word[-1]==j:target=word[:-1]
            elif len(word)<depth:target=word+(j,)
            else:target=word
            permutation.append(lookup[target])
        require(sorted(permutation)==list(range(len(words))) and
                all(permutation[permutation[i]]==i for i in range(len(words))),'Not a finite involution')
        generators.append(permutation)
    return {'words':words,'generators':generators}


def execute_reflections(tree,path):
    state=0
    for label in path:state=tree['generators'][label][state]
    return state
