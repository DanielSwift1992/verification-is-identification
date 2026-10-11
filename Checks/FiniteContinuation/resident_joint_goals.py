#!/usr/bin/env python3
"""One endpoint for a tuple of questions, with one explicitly given recipient.

Reuse the existing source graph and binary proof applications. Join their
terminal sets, not their independently reached final answers or root ranks.
"""
from copy import deepcopy
import uuid

import resident_goal_synthesis as s
import whole_word_admission as a


def request(source, questions, occurrence, recipient):
    s.require(type(questions)is list and 1<=len(questions)<=8,'One through eight question tables required')
    members=[s.request(source,q,occurrence) for q in questions]
    s.require(type(recipient)is list and len(recipient)==2**len(questions) and
              all(type(b)is int and b in (0,1) for b in recipient),'Complete binary recipient table required')
    return {'source':a.fingerprint(source),'questions':[m['values'] for m in members],
            'occurrence':occurrence,'recipient':list(recipient),
            'endpoint':'All requested values refer to one common source occurrence.',
            'encoding':'Question i is bit i of the returned tuple code.',
            'output':'Return the complete tuple, then apply one source I/Z selected by its measured code.',
            'allowed_change':members[0]['allowed_change'],'winning':members[0]['winning']}


def validate_request(source,query):
    s.require(query==request(source,query['questions'],query['occurrence'],query['recipient']),
              'The common endpoint, questions, recipient or source changed')


def rank_targets(edges,terminal):
    ranks=[0 if t else None for t in terminal]
    while True:
        layer=[i for i,r in enumerate(ranks) if r is None and all(ranks[j] is not None for j in edges[i])]
        if not layer:return ranks
        for i in layer:ranks[i]=1+max(ranks[j] for j in edges[i])


def synthesize(source,support,query):
    validate_request(source,query)
    members=[s.synthesize(source,support,s.request(source,q,query['occurrence'])) for q in query['questions']]
    edges=[r['next'] for r in members[0]['nodes']]
    tuples=[[m['nodes'][i]['answer'] for m in members] for i in range(len(edges))]
    known=[all(v is not None for v in row) for row in tuples]
    ranks=rank_targets(edges,known);nodes=[]
    for i,base in enumerate(members[0]['nodes']):
        row={k:deepcopy(base[k]) for k in ('pairs','relative','next')}
        row.update(answers=tuples[i] if known[i] else None,rank=ranks[i])
        if known[i]:
            row['code']=sum(v<<j for j,v in enumerate(tuples[i]))
            row['recipient']=query['recipient'][row['code']]
        elif ranks[i] is None:
            row['obstructing_reply']=next(b for b,j in enumerate(edges[i]) if ranks[j] is None)
        nodes.append(row)
    cert={'schema':'vi.common-endpoint.v1','source':a.fingerprint(source),'query':deepcopy(query),
          'members':members,'input_support':list(support),'root':0,'nodes':nodes,
          'worst_case_contacts':ranks[0]}
    if ranks[0] is None:
        cert['obstruction_kind']=('no_common_answer_on_any_finite_transcript' if not any(known)
                                  else 'no_uniform_common_endpoint_bound')
    verify(source,cert)
    return cert


def verify(source,cert):
    s.require(cert['schema']=='vi.common-endpoint.v1' and cert['root']==0 and
              cert['source']==a.fingerprint(source),'Wrong common-endpoint root')
    query=cert['query'];validate_request(source,query)
    members=cert['members'];nodes=cert['nodes']
    s.require(len(members)==len(query['questions']),'A requested question was omitted')
    for member,question in zip(members,query['questions']):
        s.verify(source,member)
        s.require(member['input_support']==cert['input_support'] and
                  member['query']==s.request(source,question,query['occurrence']),
                  'Member substituted its input or source occurrence')
        s.require(len(member['nodes'])==len(nodes),'Member graph does not share the actual endpoint graph')
    for i,row in enumerate(nodes):
        for m in members:
            s.require(all(row[k]==m['nodes'][i][k] for k in ('pairs','relative','next')),
                      'Member uses a different intermediate source correspondence')
        values=[m['nodes'][i]['answer'] for m in members]
        known=all(v is not None for v in values)
        s.require(row['answers']==(values if known else None),'Separate answers were promoted to a joint tuple')
        rank=row['rank'];s.require(rank is None or type(rank)is int and rank>=0,'Invalid rank')
        if known:
            code=sum(v<<j for j,v in enumerate(values))
            s.require(rank==0 and row.get('code')==code and row.get('recipient')==query['recipient'][code]
                      and 'obstructing_reply' not in row,'Wrong common tuple, receiver or stopping price')
        else:
            s.require('code' not in row and 'recipient' not in row,'Unknown tuple was sent to the recipient')
            children=[nodes[j]['rank'] for j in row['next']]
            if rank is not None:
                s.require(all(r is not None for r in children) and rank==1+max(children)
                          and 'obstructing_reply' not in row,'No exact decreasing common rank')
            else:
                b=row.get('obstructing_reply')
                s.require(type(b)is int and b in (0,1) and children[b] is None,'No closed joint obstruction')
    s.require(cert['worst_case_contacts']==nodes[0]['rank'],'Wrong common root bound')
    if nodes[0]['rank'] is None:
        kind=('no_common_answer_on_any_finite_transcript' if all(r['answers'] is None for r in nodes)
              else 'no_uniform_common_endpoint_bound')
        s.require(cert.get('obstruction_kind')==kind,'Joint obstruction overstates the result')
    else:s.require('obstruction_kind' not in cert,'Winning packet contains an unrelated obstruction')
    return True


class Continuation(s.Continuation):
    def __init__(self,source,port):
        super().__init__(source,port)
        self.bound_port=port;self.session_id=uuid.uuid4().hex

    def perform_bundle(self,query):
        s.require(self.pending is None,'Previous physical act is unconfirmed; no automatic replay')
        s.validate_source(self.source)
        s.require(self.port is self.bound_port and self.port.source_id==self.source_id,'Live port was replaced')
        cert=synthesize(self.source,self.support,query)
        if cert['worst_case_contacts'] is None:
            return {'executed':False,'contacts':0,'certificate':cert,'support':list(self.support)}
        node=0;contacts=0;entry_event=len(self.events)
        while cert['nodes'][node]['answers'] is None:
            row=cert['nodes'][node]
            self.pending={'kind':'contact','node':node,'certificate':a.fingerprint(cert)}
            b=self.port.contact(row['relative'])
            s.require(type(b)is int and b in (0,1) and self.port is self.bound_port and
                      self.port.source_id==self.source_id,'Contact did not confirm the actual source reply')
            self.events.append({'contact':row['relative'],'reply':b})
            node=row['next'][b];contacts+=1
            self.support=sorted({x[1] for x in cert['nodes'][node]['pairs']})
            self.pending=None
            s.require(contacts<=cert['worst_case_contacts'],'Common rank did not descend')
        row=cert['nodes'][node]
        at={'session':self.session_id,'event':entry_event if query['occurrence']=='entry' else len(self.events)}
        self.pending={'kind':'recipient','bit':row['recipient'],'endpoint':at}
        self.port.recipient(row['recipient'])
        s.require(self.port is self.bound_port and self.port.source_id==self.source_id,'Recipient belongs to another live source')
        self.pending=None
        self.support=sorted({x[1] for x in row['pairs']})
        self.events.append({'answers':list(row['answers']),'at':at,'recipient':row['recipient']})
        return {'executed':True,'contacts':contacts,'answers':list(row['answers']),'code':row['code'],
                'recipient':row['recipient'],'at':at,'support':list(self.support),'certificate':cert}


if __name__=='__main__':
    import argparse
    import json
    import sys
    from resident_goal_synthesis_checks import InstrumentPort,RetainingFirstPort
    from resident_raw_reply_checks import fixture
    cli=argparse.ArgumentParser(description='Local declared instrument; common-endpoint JSON-lines requests. No QPU client.')
    cli.add_argument('--memory',choices=('continue','first'),default='continue')
    cli.add_argument('--seed',type=int,default=193)
    args=cli.parse_args();source=s.reading();_,maps,_=fixture(1.3,-.8)
    port=(InstrumentPort if args.memory=='continue' else RetainingFirstPort)(source,maps,args.seed)
    actor=Continuation(source,port)
    def emit(value):print(json.dumps(value,separators=(',',':')),flush=True)
    emit({'ready':True,'backend':'local-declared-instrument','memory':args.memory,
          'support':actor.support,'session':actor.session_id})
    for line in sys.stdin:
        if not line.strip():continue
        try:
            v=json.loads(line)
            s.require(type(v)is dict and set(v)=={'masks','occurrence','recipient'},'Expected masks, occurrence and recipient')
            s.require(type(v['masks'])is list and 1<=len(v['masks'])<=8 and
                      all(type(m)is int and 0<=m<256 for m in v['masks']),'One through eight binary question masks required')
            q=request(source,[[(m>>i)&1 for i in range(8)] for m in v['masks']],v['occurrence'],v['recipient'])
            result=actor.perform_bundle(q);cert=result.pop('certificate')
            result['minimum_worst_case_contacts']=cert['worst_case_contacts']
            if not result['executed']:result['obstruction']=cert['obstruction_kind']
            emit(result)
        except Exception as error:
            emit({'error':str(error),'unconfirmed_act':actor.pending})
            if actor.pending is not None:raise SystemExit(2)
