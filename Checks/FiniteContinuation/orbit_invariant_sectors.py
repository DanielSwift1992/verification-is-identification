#!/usr/bin/env python3
"""One common acquisition across coherent, unknown invariant memory sectors.

A fixed hidden basis conjugates a commuting sector and a projective reflection
sector. The complete device generally belongs to neither old family. The
planner applies both relations to one current word without reading a sector.
"""
import numpy as np
import orbit_return as o
import orbit_future as f
import orbit_quantum_memory as memory
import orbit_reflection_return as reflection

require=o.require
SHARED=('schema','source','q','f','work_bits','elementary_contacts_per_oracle','permutations')


def model(source):
    result=o.model(source)
    result['oracle_contract']='fixed unknown invariant direct sum of commuting and projective-involution memory, in one common hidden basis'
    result['components']={'commuting':memory.memory_model(source),'reflection':reflection.model(source)}
    return result


def validate_recipe(m):
    require(set(m.get('components',{}))=={'commuting','reflection'},'Wrong invariant-sector recipe')
    for component in m['components'].values():
        require(all(component[key]==m[key] for key in SHARED),'Component uses another current source/contact relation')
    require(m['components']['reflection'].get('memory_relation')=='projective_involution','Wrong reflection sector scope')


def block_sum(left,right):
    n=left.shape[0];m=right.shape[0];result=np.zeros((n+m,n+m),complex)
    result[:n,:n]=left;result[n:,n:]=right;return result


class InvariantSectorDevice(memory.CommutingMemoryDevice):
    def __init__(self,m,commuting,reflected,basis):
        validate_recipe(m)
        require(type(commuting) is memory.CommutingMemoryDevice and type(reflected) is reflection.ReflectionDevice,
                'Sectors must come from the producing constructors')
        require(commuting.model==o.fingerprint(m['components']['commuting']) and
                reflected.model==o.fingerprint(m['components']['reflection']),'Unbound component relation')
        dimension=commuting.dimension+reflected.dimension
        require(basis.shape==(dimension,dimension) and np.max(abs(basis.conj().T@basis-np.eye(dimension)))<1e-12,
                'Not one fixed unitary sector frame')
        self.model=o.fingerprint(m);self.owner=object();self.dimension=dimension
        self._left=commuting;self._right=reflected;self._basis=basis.copy()
        self._actions=tuple(basis@block_sum(a,b)@basis.conj().T for a,b in zip(commuting._actions,reflected._actions))
        for action in self._actions:action.setflags(write=False)

    def audit_common(self,cycle):
        left=self._left.audit_word(cycle);left=left@left
        scalar=1+0j
        for s in cycle:scalar*=np.trace(self._right._actions[s]@self._right._actions[s])/self._right.dimension
        right=scalar*np.eye(self._right.dimension)
        return self._basis@block_sum(left,right)@self._basis.conj().T

    def audit_sector_projector(self):
        return self._basis@block_sum(np.eye(self._left.dimension),np.zeros((self._right.dimension,self._right.dimension)))@self._basis.conj().T


def common_plan(m):
    validate_recipe(m);candidate=reflection.whole_plan(m['components']['reflection'])
    _,info=f.word_data(m,candidate['powers'])
    plan={'schema':'vi.invariant-sector-common-word.v1','model':o.fingerprint(m),
          'goal':'source_and_declared_future','powers':candidate['powers'],'computed':info,
          'reflection_interpretation':candidate,'minimum_V':candidate['minimum_V'],
          'minimum_T':candidate['minimum_T']}
    verify(m,plan);return plan


def verify(m,plan):
    validate_recipe(m)
    require(plan['schema']=='vi.invariant-sector-common-word.v1' and plan['model']==o.fingerprint(m),
            'Not a common word on this current source')
    require(plan['goal']=='source_and_declared_future','Common word does not promise the initial entire memory')
    _,actual=f.word_data(m,plan['powers']);require(plan['computed']==actual,'Wrong performed source path')
    # Commuting interpretation: actual visit characters agree within q.
    for cycle in f.cyclic_model(m)[0]:
        require(all(actual['visits'][s]==actual['visits'][cycle[0]] for s in cycle),
                'Commuting sector retains an unknown relative response')
    # Reflection interpretation: same word, ordered pair cancellation and its
    # residual scalar obligations. It is NOT a whole-E proof for the composite.
    interpreted=plan['reflection_interpretation']
    require(interpreted['powers']==plan['powers'],'Two proofs concern different actual words')
    reflection.verify(m['components']['reflection'],interpreted)
    _,length=f.cyclic_model(m)
    require(len(plan['powers'])==plan['minimum_V']==2*length and sum(plan['powers'])==plan['minimum_T']==length,
            'Wrong worst-case minimum for this composite family')
    return {'minimum_V':2*length,'minimum_T':length,'scope':'source, acquired q, and q-preserving future that does not directly access E'}


class SectorOrbit(memory.MemoryOrbit):
    def __init__(self,m,port):
        require(type(port) is InvariantSectorDevice,'Need the actual invariant-sector construction')
        super().__init__(m,port)

    def start(self,*args,**kwargs):
        raise ValueError('Use the common-sector construction; do not guess a hidden component')

    def upgrade(self,boundary,observables,certificate=None):
        self._check_boundary(boundary)
        require(not any(self._h),'A noncommuting residual needs its ordered relation, not a count-only extension')
        require(certificate is None,'This boundary already serves every declared within-q reading')
        f.edges(self.m,observables)
        return {'kind':'reuse','additional_V':0,'additional_T':0}

    def audit_common_memory_target(self,*args,**kwargs):
        raise ValueError('Use audit_common_target: a commuting word alone is not the composite target')

    def start_for(self,goal='source_and_declared_future',plan=None):
        require(self._answer is None and self.V_calls==0,'Do not reprepare the existing carrier')
        if goal=='whole_initial_memory':
            return {'kind':'no_uniform_positive_word','target':'initial E, not merely whatever E exists now',
                    'counterexample_constructor':'whole_memory_counterexample(m, positive_V_count)',
                    'reason':'An allowed common commuting rotation accumulates on E at every call.'}
        require(goal=='source_and_declared_future','Unsupported continuation question')
        certificate=common_plan(self.m) if plan is None else plan;verify(self.m,certificate)
        for index,power in enumerate(certificate['powers']):
            self._probe()
            if index==0:self._copy(certificate['computed']['decoder'])
            self._tick(power)
        self._clean(certificate['computed']['cleanup_by_answer']);self._read()
        # One common memory motion commutes with all promised future contacts.
        # No physical memory reset or sector measurement occurs here.
        self._h=[0]*f.cyclic_model(self.m)[1]
        return certificate

    def audit_common_target(self):
        result={}
        for cycle in f.cyclic_model(self.m)[0]:
            a=self.m['q'][cycle[0]];p=np.diag([int(q==a) for q in self.m['q']])
            result[a]=np.kron(self._port.audit_common(cycle),np.kron(np.eye(self.data_dim),p))@self._ideal
        return result


def whole_memory_counterexample(m,positive_V_count):
    """Produce an allowed device and input defeating whole-E return at L calls."""
    require(type(positive_V_count) is int and positive_V_count>0,'Positive finite word length needed')
    n=len(m['q']);angle=np.pi/positive_V_count
    angles=np.array([[0,angle]]*n)
    left=memory.CommutingMemoryDevice(m['components']['commuting'],{a:np.eye(2) for a in set(m['q'])},angles)
    right=reflection.ReflectionDevice(m['components']['reflection'],{s:np.eye(2) for s in range(n)},
                                      [[1,1]]*n,np.zeros(n))
    device=InvariantSectorDevice(m,left,right,np.eye(4))
    state=np.array([1,1,0,0],complex)/np.sqrt(2)
    return device,state
