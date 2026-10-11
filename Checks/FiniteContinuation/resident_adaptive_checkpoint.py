#!/usr/bin/env python3
"""One live quantum checkpoint selects new work using an actually acquired bit.

Integration of the existing current sources, not a new Swift proof language.
The old quantum-output-only guarantee is not relabelled as a joint guarantee.
"""
import argparse
from copy import deepcopy
import json
from pathlib import Path

from qiskit import ClassicalRegister,qpy

import resident_stopped_read as stopped
from environment import write,digest

FIRST=[{'z':[1,3],'x':[1,4]}]
NEXT={'0':[{'z':[-1,6],'x':[0,1]}],'1':[{'z':[0,1],'x':[1,4]}]}


def good_mass(packet):
    c=packet['cost_reading'];modes=c['selected']['modes'];success=1.;blocks=[]
    for offset in range(0,len(modes),3):
        contrasts=[max(0.,1-2*c['candidates'][name]['witness_primitive_error']-4e-12) for name in modes[offset:offset+3]]
        if len(contrasts)!=3:raise ValueError('Incomplete orientation block')
        a,b,d=contrasts;p=max(0.,(1+a*b+a*d+b*d)/4-4e-12);success*=p;blocks.append(p)
    return {'per_block_success_lower':blocks,'all_blocks_correct_lower':success,
        'joint_records_and_quantum_error_upper':min(1.,1-success+4e-12)}


def retained_block_bound(first,branches):
    """One recorded Pauli block followed by the same isotropic error law.

    The two branches may request different rotations. Equality of their
    noise contractions is derived from their current complete schedules.
    """
    f=first['cost_reading'];left=branches['0']['cost_reading'];right=branches['1']['cost_reading']
    if len(f['selected']['modes'])!=3 or left['selected']['modes']!=right['selected']['modes']:return None
    modes=left['selected']['modes'];lam=1.;sharp_lam=1.
    for offset in range(0,len(modes),3):
        block=modes[offset:offset+3]
        if len(block)!=3 or len(set(block))!=1:return None
        r=left['candidates'][block[0]]['witness_primitive_error'];sharp=max(0.,1-2*r)
        sharp_lam*=sharp*sharp;lam*=max(0.,sharp-4e-12)**2
    contrasts=[max(0.,1-2*f['candidates'][name]['witness_primitive_error']) for name in f['selected']['modes']]
    a,b,c=contrasts;sharp_p=(1+a*b+a*c+b*c)/4
    p=max(.25,good_mass(first)['all_blocks_correct_lower'])
    return {'kind':'one_retained_Pauli_block_same_isotropic_suffix','suffix_contraction_lower':lam,
        'first_identity_class_lower':p,'joint_error_upper':min(1.,.75-lam*(p-.25)+1e-11),
        'compatible_witness_joint_error':.75-sharp_lam*(sharp_p-.25),
        'scope':'Only the first block supplies retained classical control. All later complete blocks are unrecorded, isotropic, and have the same schedule in both acquired branches.'}


class AdaptiveCheckpoint:
    def __init__(self,source,pair,artifact):
        self.view=stopped.StoppedView(source,pair,artifact)

    def request(self,first=FIRST,next_requests=NEXT,*,stage_risk=.2,joint_risk=.30):
        if set(next_requests)!={'0','1'}:raise ValueError('Both actually acquired raw replies need a continuation')
        first_packet=self.view.request(first,stage_risk)
        branch_packets={b:self.view.request(next_requests[b],stage_risk) for b in ['0','1']}
        base={'source':stopped.cost.admission.fingerprint(self.view.source),'first':first_packet,'next':branch_packets,
            'stage_risk':stage_risk,'required_joint_error':joint_risk,
            'evidence_occurrence':self.view.saved.origin}
        if not 0<joint_risk<1:raise ValueError('A joint-output tolerance is required')
        if any(p['kind']!='act' for p in [first_packet,*branch_packets.values()]):return {**base,'kind':'needs_evidence'}
        first_owner=(3*len(first))%2
        owners={b:first_owner^(3*len(next_requests[b])%2) for b in ['0','1']}
        if owners['0']!=owners['1']:raise ValueError('Different final owners need an explicit owner-aware output interface')
        masses={'first':good_mass(first_packet),**{b:good_mass(p) for b,p in branch_packets.items()}}
        good=masses['first']['all_blocks_correct_lower']*min(masses[b]['all_blocks_correct_lower'] for b in ['0','1'])
        upper=min(1.,1-good+1e-11)
        general_upper=upper;refinement=retained_block_bound(first_packet,branch_packets)
        if refinement is not None:upper=min(upper,refinement['joint_error_upper'])
        return {**base,'kind':'act' if upper<=joint_risk else 'needs_evidence','joint_error_upper':upper,'correct_branch_mass':masses,
            'general_correct_mass_bound':general_upper,'retained_block_refinement':refinement,
            'checkpoint_owner':first_owner,'final_owner':owners['0'],
            'expected_report_reads_upper':first_packet['expected_report_reads_interval'][1]+max(p['expected_report_reads_interval'][1] for p in branch_packets.values()),
            'maximum_report_reads':first_packet['maximum_report_reads']+max(p['maximum_report_reads'] for p in branch_packets.values()),
            'scope':'Actual first report retained for next-program selection; whole final classical choice plus quantum/reference output. Common owned stationary memoryless reporter. No host result round trip, no claim of minimum cost for this enlarged question.'}

    def check_packet(self,packet):
        first=packet['first']['cost_reading']['request'];nxt={b:packet['next'][b]['cost_reading']['request'] for b in ['0','1']}
        if packet!=self.request(first,nxt,stage_risk=packet['stage_risk'],joint_risk=packet['required_joint_error']) or packet['kind']!='act':
            raise ValueError('No applicable joint checkpoint reading')

    def working_body(self,packet):
        self.check_packet(packet);first=self.view.working_body(packet['first']);self.view.admit(packet['first'],first)
        branches={b:self.view.working_body(packet['next'][b]) for b in ['0','1']}
        for b,body in branches.items():self.view.admit(packet['next'][b],body)
        return self.assemble(self.view.source,packet,first,branches)

    @staticmethod
    def assemble(source,packet,first,branches):
        """Pure body assembly; acquired admission is performed by working_body."""
        q=first.copy_empty_like();choice=ClassicalRegister(1,'next_request');q.add_register(choice);q.store(choice[0],False);captured=0
        for item in first.data:
            q.append(item)
            if item.operation.name=='measure' and item.operation.label=='vote:0:0:root':
                if item.clbits!=(first.cregs[2][0],):raise ValueError('The retained report is not the actual reply port')
                q.store(choice[0],item.clbits[0]);captured+=1
        if captured!=1:raise ValueError('Exactly one actual first acquisition must install the next request')
        first_end=len(q.data);owner=packet['checkpoint_owner'];ports=[owner,owner^1,2,3,4]
        # Build and map complete bodies before binding the runtime choice.
        # Nested builder-scope compose in this installed SDK cannot map the
        # Store-only classical ports reliably; explicit full bodies can.
        mapped={}
        for b,body in branches.items():
            mapped[b]=q.copy_empty_like();mapped[b].metadata={}
            mapped[b].compose(body,qubits=ports,clbits=list(first.clbits),inplace=True)
        q.if_else((choice[0],0),mapped['0'],mapped['1'],list(q.qubits),list(q.clbits))
        if len(q.data)!=first_end+1:raise ValueError('The single runtime choice did not contain both next programs')
        q.metadata={'source':stopped.cost.admission.fingerprint(source),'joint_reading':stopped.cost.admission.fingerprint(packet),
            'first_instruction_end':first_end,'continuation_control_index':first_end,'choice_bit':q.find_bit(choice[0]).index,
            'first_actual_reply_label':'vote:0:0:root','checkpoint_owner':owner,'continuation_quantum_ports':ports,
            'final_owner':packet['final_owner'],'first_request':packet['first']['cost_reading']['request'],
            'next_requests':{b:packet['next'][b]['cost_reading']['request'] for b in ['0','1']},
            'joint_error_upper':packet['joint_error_upper'],'maximum_report_reads':packet['maximum_report_reads'],
            'expected_report_reads_upper':packet['expected_report_reads_upper'],
            'working_classical_bits':q.num_clbits,'scope':'A same-circuit live checkpoint; this QPY is a program, not an exported surviving quantum state.'}
        return stopped.check_control(q)

    def admit(self,packet,candidate):
        expected=self.working_body(packet)
        if candidate.metadata!=expected.metadata or candidate!=expected or stopped.cost.policy.repeated.work.ordered_bindings(candidate)!=stopped.cost.policy.repeated.work.ordered_bindings(expected):
            raise ValueError('The actual live checkpoint or continuation binding changed')
        return candidate


def prepare(output,source,artifact):
    output.mkdir(parents=True,exist_ok=True);session=AdaptiveCheckpoint(source,(.8,.99),artifact);packet=session.request()
    if packet['kind']!='act':raise ValueError('The integrated requested guarantee is not available')
    q=session.working_body(packet);session.admit(packet,q)
    with (output/'adaptive-checkpoint.qpy').open('wb') as f:qpy.dump(q,f)
    write(output/'joint-reading.json',packet);write(output/'program.json',q.metadata)
    return {'joint_error_upper':packet['joint_error_upper'],'expected_report_reads_upper':packet['expected_report_reads_upper'],
        'maximum_report_reads':packet['maximum_report_reads'],'QPY_sha256':digest(output/'adaptive-checkpoint.qpy'),
        'new_device_calibrations':0,'new_QPU_jobs':0}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);args=p.parse_args()
    root=stopped.cost.policy.repeated.wire.goal.ROOT
    source=json.loads((root/'Research/Artifacts/resident-stopped-read-20260915/stopped-reading.json').read_text())
    print(json.dumps(prepare(args.output.resolve(),source,root/'Research/Artifacts/resident-orientation-word-20260915')))
