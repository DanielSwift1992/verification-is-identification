#!/usr/bin/env python3
"""IiS19 applied to a persistent contact: derive invisible memory motions.

The exact domain is a two-qubit Clifford interface. Every retained basis
direction is an actual terminal Pauli pulled back through an available word.
Closure proves every finite word, rather than testing a chosen depth cutoff.
This is an audit/synthesizer for declared contact models, not hardware learning.
"""
from collections import deque
from itertools import product
import numpy as np
import orbit_return as o

I=np.eye(2,dtype=complex)
X=np.array([[0,1],[1,0]],complex)
Y=np.array([[0,-1j],[1j,0]],complex)
Z=np.diag([1,-1]).astype(complex)
H=np.array([[1,1],[1,-1]],complex)/np.sqrt(2)
S=np.diag([1,1j])
PAULI=dict(zip('IXYZ',(I,X,Y,Z)))
MATRICES={e+s:np.kron(PAULI[e],PAULI[s]) for e,s in product('IXYZ',repeat=2)}
VISIBLE=('II','IX','IY','IZ')
require=o.require


def controlled(actions):
    """S is low and E high, as in the existing full orbit simulator."""
    out=np.zeros((4,4),complex)
    for s in (0,1):
        for i,j in product(range(2),repeat=2):out[s+2*i,s+2*j]=actions[s][i,j]
    return out


def contacts(kind):
    if kind=='common_factor':actions=(H,-H)
    elif kind=='phase_memory':actions=(I,Z)
    elif kind=='rotating_memory':actions=(H,H@Z)
    else:raise ValueError('Unknown producing contact recipe')
    return actions


def gates(kind):
    return {'V':controlled(contacts(kind)),'H_source':np.kron(I,H),'S_source':np.kron(I,S)}


def matrix_code(matrix):
    # Serialization precision is not the proof criterion: image() below checks
    # the complete matrix against the exact finite Pauli vocabulary.
    return [[[round(float(x.real),14),round(float(x.imag),14)] for x in row] for row in matrix]


def interface(source,kind,extra_memory_h=False):
    gs=gates(kind)
    if extra_memory_h:gs['H_memory']=np.kron(H,I)
    description={'schema':'vi.declared-clifford-future.v1','source':source,'kind':kind,
        'subspace':'A=B=0; source C and persistent E retained, F=0 on this subspace',
        'terminal_paulis':list(VISIBLE),'gates':{name:matrix_code(g) for name,g in gs.items()}}
    return {'description':description,'id':o.fingerprint(description),'gates':gs}


def image(gate,label):
    actual=gate.conj().T@MATRICES[label]@gate
    for out,matrix in MATRICES.items():
        coefficient=np.trace(matrix@actual)/4
        if abs(abs(coefficient)-1)<1e-12 and abs(coefficient.imag)<1e-12:
            sign=1 if coefficient.real>0 else -1
            require(np.max(abs(actual-sign*matrix))<1e-12,'Not a Pauli image')
            return out,sign
    raise ValueError('This constructor only certifies Clifford images, not arbitrary rounded matrices')


def pauli_product(a,b):
    positive={('X','Y'):'Z',('Y','Z'):'X',('Z','X'):'Y'}
    phase=1;out=''
    for x,y in zip(a,b):
        if x=='I':out+=y
        elif y=='I':out+=x
        elif x==y:out+='I'
        elif (x,y) in positive:phase*=1j;out+=positive[x,y]
        else:phase*=-1j;out+=positive[y,x]
    return out,phase


def exact_image(kind,name,label):
    """Exact signed Pauli rules, independent of the dense matrix reader."""
    def hadamard(value,wire):
        chars=list(value);x=chars[wire];chars[wire]={'I':'I','X':'Z','Y':'Y','Z':'X'}[x]
        return ''.join(chars),-1 if x=='Y' else 1
    def cz(value):
        left={'I':'II','X':'XZ','Y':'YZ','Z':'ZI'}[value[0]]
        right={'I':'II','X':'ZX','Y':'ZY','Z':'IZ'}[value[1]]
        out,phase=pauli_product(left,right);assert phase in (-1,1)
        return out,int(phase.real)
    if name=='H_source':return hadamard(label,1)
    if name=='H_memory':return hadamard(label,0)
    if name=='S_source':
        return label[0]+{'I':'I','X':'Y','Y':'X','Z':'Z'}[label[1]],-1 if label[1]=='X' else 1
    require(name=='V','Unknown producing generator')
    if kind=='phase_memory':return cz(label)
    label,sign=hadamard(label,0)
    if kind=='common_factor':return label,sign*(-1 if label[1] in 'XY' else 1)
    require(kind=='rotating_memory','Unknown contact recipe')
    label,other=cz(label);return label,sign*other


def declared_image(spec,name,label):
    result=exact_image(spec['description']['kind'],name,label)
    require(image(spec['gates'][name],label)==result,'Declared Pauli rule disagrees with the actual gate')
    return result


def build(spec):
    found={label:{'terminal':label,'word':[],'sign':1} for label in VISIBLE}
    queue=deque(VISIBLE);layers=[len(found)]
    while queue:
        count=len(queue)
        for _ in range(count):
            label=queue.popleft();witness=found[label]
            for name in spec['gates']:
                out,sign=declared_image(spec,name,label)
                if out not in found:
                    found[out]={'terminal':witness['terminal'],'word':[name]+witness['word'],
                                'sign':sign*witness['sign']};queue.append(out)
        if queue:layers.append(len(found))
    closure={label:{name:list(declared_image(spec,name,label)) for name in spec['gates']} for label in found}
    cert={'schema':'vi.future-pauli-closure.v1','interface':spec['id'],'basis':found,
          'closure':closure,'strict_expansion_dimensions':layers}
    verify(spec,cert);return cert


def word_operator(spec,word):
    result=np.eye(4,dtype=complex)
    for name in word:result=spec['gates'][name]@result
    return result


def verify(spec,cert):
    require(spec['id']==o.fingerprint(spec['description']) and
            spec['description']['gates']=={name:matrix_code(g) for name,g in spec['gates'].items()},
            'Changed actual generators behind the interface description')
    require(cert['schema']=='vi.future-pauli-closure.v1' and cert['interface']==spec['id'],
            'Future proof belongs to another current interface')
    basis=cert['basis'];require(set(VISIBLE)<=set(basis)<=set(MATRICES),'Missing terminal direction or invented basis')
    for label,witness in basis.items():
        require(witness['terminal'] in VISIBLE and witness['sign'] in (-1,1),'Not a real terminal witness')
        word=word_operator(spec,witness['word'])
        observed=word.conj().T@MATRICES[witness['terminal']]@word
        require(np.max(abs(observed-witness['sign']*MATRICES[label]))<1e-12,
                'Retained direction has no matching available continuation')
        require(set(cert['closure'][label])==set(spec['gates']),'Missing actual future generator')
        for name in spec['gates']:
            out,sign=declared_image(spec,name,label)
            require(out in basis and cert['closure'][label][name]==[out,sign],
                    'Finite questions not closed under the actual future')
    return {'dimension':len(basis),'all_finite_words':True}


def admit(spec,cert,memory_action):
    require(memory_action.shape==(2,2) and np.max(abs(memory_action.conj().T@memory_action-I))<1e-12,
            'Need an actual unitary memory transformation')
    return admit_channel(spec,cert,[memory_action])


def admit_channel(spec,cert,kraus):
    verify(spec,cert)
    require(len(kraus)>0 and all(k.shape==(2,2) for k in kraus) and
            np.max(abs(sum(k.conj().T@k for k in kraus)-I))<1e-12,
            'Not a producing trace-preserving memory operation')
    lifted=[np.kron(k,I) for k in kraus]
    for label,witness in cert['basis'].items():
        difference=sum(k.conj().T@MATRICES[label]@k for k in lifted)-MATRICES[label]
        if np.max(abs(difference))>1e-12:
            return {'kind':'distinguished','interface':spec['id'],'basis_direction':label,
                    'continuation':witness,'operator_difference':matrix_code(difference)}
    return {'kind':'preserves_declared_future','interface':spec['id'],'basis_dimension':len(cert['basis'])}


def audit_reading(spec,word,terminal,rho,memory_action=I):
    u=word_operator(spec,word);j=np.kron(memory_action,I)
    effect=(np.eye(4)+MATRICES[terminal])/2
    output=u@j@rho@j.conj().T@u.conj().T
    return float(np.trace(effect@output).real)


def witness_state(spec,rejection,memory_action):
    require(rejection['kind']=='distinguished','No distinguishing continuation')
    w=rejection['continuation'];u=word_operator(spec,w['word']);j=np.kron(memory_action,I)
    a=u.conj().T@MATRICES[w['terminal']]@u
    change=j.conj().T@a@j-a
    values,vectors=np.linalg.eigh(change);index=int(np.argmax(abs(values)));v=vectors[:,index]
    rho=np.outer(v,v.conj())
    return rho,[audit_reading(spec,w['word'],w['terminal'],rho,k) for k in (I,memory_action)]


def retained_memory_plan(spec,cert):
    """A small physical realization, derived from the CLOSED future questions.

    The concrete two-qubit interface admits the three realizations below. This
    is not a generic recipe for physically encoding any low-dimensional span.
    """
    verify(spec,cert)
    axes={label[0] for label in cert['basis']}
    if axes=={'I'}:
        return {'interface':spec['id'],'kind':'no_active_environment_memory','quantum_qubits':0,'classical_bits':0}
    if axes=={'I','Z'}:
        require(spec['description']['kind']=='phase_memory' and 'H_memory' not in spec['gates'],
                'No supplied update construction for this classical reduction')
        return {'interface':spec['id'],'kind':'classical_Z_record','quantum_qubits':0,'classical_bits':1}
    require(set(cert['basis'])==set(MATRICES),'No supplied minimum-memory construction for this partial span')
    return {'interface':spec['id'],'kind':'retain_quantum_environment','quantum_qubits':1,'classical_bits':0}


class ReducedFlow:
    """Executable updates on the retained carrier; rho is a simulator input.

    No gate selection depends on a hidden state index. Classical branches are
    the ACTUAL Z measurement instrument, unnormalized and correlated with R.
    The quantum case keeps E; the other cases allocate no quantum E afterward.
    """
    def __init__(self,spec,certificate,rho):
        self.spec=spec;self.plan=retained_memory_plan(spec,certificate)
        require(rho.ndim==2 and rho.shape[0]==rho.shape[1] and rho.shape[0]%4==0,'Wrong S/E/reference carrier')
        self.reference=len(rho)//4;self.count=0
        kind=self.plan['kind'];block=2*self.reference
        if kind=='retain_quantum_environment':self.quantum=rho.copy();self.branches=None
        elif kind=='classical_Z_record':
            self.quantum=None;self.branches={z:rho[z*block:(z+1)*block,z*block:(z+1)*block].copy() for z in (0,1)}
        else:
            self.quantum=None;self.branches={None:np.trace(rho.reshape(2,block,2,block),axis1=0,axis2=2)}

    def step(self,name):
        require(name in self.spec['gates'],'No such continuation in the retained interface')
        kind=self.plan['kind'];r=self.reference
        if self.quantum is not None:
            gate=np.kron(self.spec['gates'][name],np.eye(r))
            self.quantum=gate@self.quantum@gate.conj().T
        else:
            for record,rho in list(self.branches.items()):
                if name=='V':
                    gate=Z if kind=='no_active_environment_memory' or record==1 else I
                elif name=='H_memory' and kind=='no_active_environment_memory':
                    continue
                else:
                    require(name in ('H_source','S_source'),'No reduced update construction for this memory access')
                    gate=H if name=='H_source' else S
                gate=np.kron(gate,np.eye(r));self.branches[record]=gate@rho@gate.conj().T
        self.count+=1

    def source_and_reference(self):
        if self.quantum is None:return sum(self.branches.values())
        n=2*self.reference
        return np.trace(self.quantum.reshape(2,n,2,n),axis1=0,axis2=2)
