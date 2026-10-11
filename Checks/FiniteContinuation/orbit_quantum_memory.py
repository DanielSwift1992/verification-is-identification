#!/usr/bin/env python3
"""The same count-based continuation with an actual quantum memory device.

Construction: within each q-fiber U_s=B_a diag(exp(i theta_s)) B_a†.
The device builder supplies a common basis, not a caller proof of the desired
recovery. The controller sees neither basis nor angles. Full memory matrices
exist in this local physical simulation/auditor, not in the planner's inputs.
"""
import numpy as np

import orbit_return as o
import orbit_future as f
import orbit_live_upgrade as u

require=o.require


def memory_model(source):
    model=o.model(source)
    model['oracle_contract']='same source/work XOR and static commuting controlled unitaries within each q-fiber on persistent internal memory'
    return model


class CommutingMemoryDevice:
    def __init__(self,m,bases,angles):
        require(set(bases)==set(m['q']),'Missing common memory frame')
        dimension=next(iter(bases.values())).shape[0]
        require(all(b.shape==(dimension,dimension) and np.max(abs(b.conj().T@b-np.eye(dimension)))<1e-12
                    for b in bases.values()),'Not a unitary device construction frame')
        require(np.shape(angles)==(len(m['q']),dimension) and np.all(np.isfinite(angles)),
                'Wrong source-conditioned angles')
        self.model=o.fingerprint(m);self.owner=object();self.dimension=dimension
        self._actions=tuple(bases[a]@np.diag(np.exp(1j*np.array(angles[s])))@bases[a].conj().T
                            for s,a in enumerate(m['q']))

    def forward(self,live):
        require(self.model==live.model_hash and self.dimension==live.environment_dimension,'Wrong same-device carrier')
        n=live.n;wdim=live.wdim;block=live.physical_block
        for a,matrix in list(live._branches.items()):
            shaped=matrix.reshape(self.dimension,block,live.input_dim);out=np.zeros_like(shaped)
            for row in range(block):
                s=row%n;w=(row//n)%wdim;tail=row//(n*wdim)
                target=s+n*((w^live.m['f'][s])+wdim*tail)
                out[:,target,:]=self._actions[s]@shaped[:,row,:]
            live._branches[a]=out.reshape(live.size,live.input_dim)

    def audit_word(self,path):
        result=np.eye(self.dimension,dtype=complex)
        for s in path:result=self._actions[s]@result
        return result


class MemoryOrbit(u.LiveOrbit):
    """Inherited planner, actual persistent E, arbitrary initial correlation.

    E is included in the FULL input isometry, not initialized/reset by the
    executor. Controller profile/cost/record logic is inherited unchanged.
    """
    def __init__(self,m,port):
        super().__init__(m,port)
        self.environment_dimension=port.dimension;self.physical_block=self.size
        self.logical_block=self.input_dim
        self.size*=port.dimension;self.input_dim*=port.dimension
        self._branches={None:np.kron(np.eye(port.dimension),self._branches[None])}
        self._ideal=np.eye(self.input_dim,dtype=complex)

    def source_action(self,name):
        self.boundary();require(name in f.CONTROLS,'Unavailable continuation')
        matrix=f.CONTROLS[name];counts=self._counts
        for s,t in np.argwhere(matrix!=0):
            require(self.m['q'][s]==self.m['q'][t] and counts[s]==counts[t],
                    'The current memory response need not commute with this action')
        self._source(matrix)
        self._ideal=np.kron(np.eye(self.environment_dimension*self.data_dim),matrix)@self._ideal

    def work(self,gate,port_index):
        self.boundary();require(port_index in (0,1),'Wrong retained data port')
        require(gate.shape==(2,2) and np.max(abs(gate.conj().T@gate-np.eye(2)))<1e-12,'Bad working action')
        matrix=np.kron(np.eye(2),gate) if port_index==0 else np.kron(gate,np.eye(2))
        rest=self.physical_block//self.data_dim
        for a,branch in list(self._branches.items()):
            shaped=branch.reshape(self.environment_dimension,self.data_dim,rest,self.input_dim)
            out=np.einsum('pq,eqrc->eprc',matrix,shaped).reshape(self.size,self.input_dim)
            for row in range(self.size):
                s=row%self.n;o0=(row//(self.n*self.wdim))%self.adim
                d=(row//(self.n*self.wdim*self.adim))%self.data_dim
                out[row]*=(-1)**((self.m['q'][s]^o0)*((d>>port_index)&1))
            self._branches[a]=out
        self._ideal=np.kron(np.eye(self.environment_dimension),np.kron(matrix,np.eye(self.n)))@self._ideal

    def audit_maps(self):
        self.boundary();result={}
        for a,matrix in self._branches.items():
            indices=[s+self.n*self.wdim*(a+self.adim*(d+self.data_dim*e))
                     for e in range(self.environment_dimension) for d in range(self.data_dim) for s in range(self.n)]
            allowed=set(indices)
            require(max((float(np.max(abs(matrix[row]))) for row in range(self.size) if row not in allowed),default=0)<1e-12,
                    'Actual scratch/record did not return to the declared boundary')
            result[a]=matrix[indices,:]
        return result

    def audit_common_memory_target(self,visits_per_position=1):
        target={}
        for cycle in f.cyclic_model(self.m)[0]:
            a=self.m['q'][cycle[0]]
            common=self._port.audit_word(cycle*visits_per_position)
            projector=np.diag([int(q==a) for q in self.m['q']])
            target[a]=np.kron(common,np.kron(np.eye(self.data_dim),projector))@self._ideal
        return target


def trace_memory(rho,dimension):
    block=rho.shape[0]//dimension
    return np.trace(rho.reshape(dimension,block,dimension,block),axis1=0,axis2=2)


def first_contact_memory(size,query_budget):
    """Fixed reversible U_s that retain the first source label for L queries.

    E=clock_(L+1) × label_size. No later change of law. Each U_s is a
    permutation; at clock zero only, add s modulo size to the label.
    """
    require(type(query_budget) is int and query_budget>=1,'Positive finite query budget needed')
    clock=query_budget+1;dimension=clock*size;result=[]
    for s in range(size):
        permutation=[]
        for time in range(clock):
            for label in range(size):
                newlabel=(label+s)%size if time==0 else label
                permutation.append(((time+1)%clock)*size+newlabel)
        require(sorted(permutation)==list(range(dimension)),'Not a reversible memory contact')
        result.append(permutation)
    return result


def retained_first_labels(paths):
    """An actual finite-memory simulation, not just a symbolic history tag."""
    size=len(paths);length=len(paths[0])
    require(all(len(p)==length for p in paths),'One fixed word must have a common length')
    permutations=first_contact_memory(size,length);outputs=[]
    for path in paths:
        state=0
        for s in path:state=permutations[s][state]
        outputs.append(state)
    return {'memory_dimension':size*(length+1),'query_budget':length,
            'final_memory_states':outputs,'first_source_labels':[p[0] for p in paths]}
