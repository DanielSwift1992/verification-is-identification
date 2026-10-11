#!/usr/bin/env python3
"""Post-planned audit of an existing ideal obligation in acquired records.

No hardware calls, no changes to the preregistered XX/ZZ analysis.
The chain preparation -> contact -> record is audited, not a readout alone.
"""
from collections import Counter
import json
import numpy as np
import arrival_reference_pair_confirmation as p


def certificate():
    bodies,final=p.first.cores()
    # Native input order A,B,D,R,C, with scratch P initially zero.
    # A=1 and C=1 leave B,D,R arbitrary, including their entanglement.
    columns=[i for i in range(32) if (i&1)==1 and ((i>>4)&1)==1]
    assert len(columns)==8
    checks={}
    for arm,q in bodies.items():
        good=np.zeros((8,8),complex);bad=np.zeros((8,8),complex)
        for matrix,bits in p.old.native_rows(q,final):
            k=matrix[:,columns];effect=k.conj().T@k
            if bits[0]==1 and (bits[1]^bits[2])==1:good+=effect
            else:bad+=effect
        residual=float(np.max(abs(good-np.eye(8))));bad_norm=float(np.linalg.norm(bad,2))
        assert residual<1e-11 and bad_norm<1e-11
        checks[arm]={'free_input_dimension':8,'good_effect_identity_residual':residual,
                    'bad_effect_operator_norm':bad_norm}
    return checks


def summarize(path,variant):
    s=p.read(path);p.require(s['status']=='DONE','Incomplete observation')
    table=Counter();good=n=0;per_basis={}
    for row in s['rows']:
        if row.get('variant',row.get('arm'))!=variant or row['prepared_arrival']!=1:continue
        for key,count in row['counts'].items():
            c,r,w=key.split();p.require(set(c+r+w)<=set('01') and len(c)==1 and len(r)==2,'Invalid record')
            parity=int(r[0])^int(r[1]);ok=int(c)==1 and parity==1
            table[c+' '+r]+=count;n+=count;good+=count*ok
            part=per_basis.setdefault(row['basis'],{'good':0,'shots':0})
            part['good']+=count*ok;part['shots']+=count
    return {'job_id':s['job_id'],'variant':variant,'good_joint_request_and_reply_relation':good,
            'shots':n,'fraction':good/n,'joint_counts':dict(sorted(table.items())),
            'by_terminal_basis':per_basis}


def run():
    checks=certificate()
    rows=[summarize(p.PARENT/'status.json','conditional'),
          summarize(p.ROOT/'Research/Artifacts/xx-three-attempts-20260916/attempt-2/status.json','conditional')]
    rows += [summarize(p.ART/'status.json',arm) for arm in p.ARMS]
    return {'schema':'vi.xx-reply-relation-audit.v1','classification':'post-planned descriptive audit',
            'ideal_obligation':'Prepared A=1,C=1,P=0 -> actual C=1 and reply_B XOR reply_Parity=1; arbitrary B,D,R.',
            'operator_certificate':checks,'observations':rows,
            'excluded_model':'Errors solely from trace-preserving operations on isolated R, with ideal source '
                'preparation, the declared other operations and correctly acquired reply records. R is not '
                'a logical participant in the acquisition; such R operations cannot change this reply law.',
            'limits':'Failure belongs to the joint preparation/contact/record obligation. Does not identify '
                'which component failed, verify the actual prepared A, or equate this with the cause of old '
                'negative XX. Existing counts only; all shots retained; not a newly preregistered hypothesis test.'}


if __name__=='__main__':print(json.dumps(run(),indent=2))
