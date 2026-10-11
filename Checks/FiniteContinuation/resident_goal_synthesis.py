#!/usr/bin/env python3
"""Sure finite continuation for a requested entry/exit reading of the VI monitor.

The only acquisition is the actual source contact; its reply cannot be chosen.
No probability, service matrix, true state or hidden historical answer enters
the planner. A closed losing region is distinct from an exhausted search.
"""
from collections import deque
from copy import deepcopy
from functools import lru_cache
import json
from pathlib import Path

import resident_goal_compiler as goal
import whole_word_admission as admission
from environment import digest
from build_from_source import ROOT, HERE, run


def require(condition, message):
    if not condition:
        raise ValueError(message)


def reading():
    return json.loads(run(['node', HERE/'resident_goal_synthesis_court.js', 'read']))


@lru_cache(maxsize=2)
def reading_at(key):
    return reading()


def validate_source(source):
    require(source['schema']=='vi.resident-goal-synthesis.v1', 'Wrong synthesis source')
    for path,h in source['source_sha256'].items():
        require(digest(ROOT/path)==h, 'Current source changed: '+path)
    goal.validate(source['goal'])
    key=tuple(sorted(source['source_sha256'].items()))+tuple((str(p),digest(p)) for p in
        [HERE/'resident_goal_synthesis_court.js',HERE/'resident_goal_court.js',HERE/'court_bridge.js'])
    require(source==reading_at(key), 'Not a reading of the current source')


def request(source, values, occurrence):
    require(occurrence in ('entry','exit'), 'A question must name its occurrence')
    require(type(values) is list and len(values)==len(source['goal']['states']) and
            all(type(v) is int and v in (0,1) for v in values), 'Complete binary question required')
    return {'source':admission.fingerprint(source), 'values':list(values), 'occurrence':occurrence,
        'output':'Return the exact binary reading and apply the current source I/Z recipient it selects.',
        'allowed_change':'Zero or more actual source contacts before the recipient; no replacement payload.',
        'winning':'Uniform finite contact bound for every admitted reply history.'}


def validate_request(source, query):
    require(query==request(source,query['values'],query['occurrence']), 'Question, source or temporal contract changed')


def graph(source, support):
    """Pairs keep the entry occurrence as a ghost used only in the proof.

    The executor receives a node index computed from its acquired replies,
    never one of these possible true-state pairs.
    """
    src=source['goal']; n=len(src['states'])
    require(type(support) is list and support and support==sorted(set(support)) and
            all(type(s) is int and 0<=s<n for s in support), 'Nonempty declared input support required')
    relative=[x[0] for x in src['observation']['continue']]
    require(len({relative[i] for i in support})==1, 'Available input cannot select the source contact action')
    root=tuple((i,i) for i in support); nodes=[root]; ids={root:0}; todo=deque([root]); edges=[]
    while todo:
        current=todo.popleft(); successor=[]
        for b in (0,1):
            table=src['operations']['reply'+str(b)]
            post=tuple(sorted(set((entry,table[state]) for entry,state in current)))
            if post not in ids:
                require(len(nodes)<512, 'Finite graph budget exhausted; no impossibility claim')
                ids[post]=len(nodes); nodes.append(post); todo.append(post)
            successor.append(ids[post])
        edges.append(successor)
    return nodes,edges


def answer(query, pairs):
    side=0 if query['occurrence']=='entry' else 1
    possible={query['values'][p[side]] for p in pairs}
    return next(iter(possible)) if len(possible)==1 else None


def synthesize(source, support, query):
    validate_request(source,query)
    nodes,edges=graph(source,support)
    outputs=[answer(query,node) for node in nodes]
    ranks=[0 if v is not None else None for v in outputs]
    layer=0
    while True:
        entering=[i for i in range(len(nodes)) if ranks[i] is None and
                  all(ranks[j] is not None for j in edges[i])]
        if not entering:
            break
        layer+=1
        for i in entering:
            ranks[i]=1+max(ranks[j] for j in edges[i])
    relative=[v[0] for v in source['goal']['observation']['continue']]
    rows=[]
    for i,pairs in enumerate(nodes):
        r={relative[j] for _,j in pairs}; require(len(r)==1, 'Acquired evidence lost usable control')
        row={'pairs':[list(x) for x in pairs], 'relative':next(iter(r)), 'next':edges[i], 'rank':ranks[i], 'answer':outputs[i]}
        if ranks[i] is None:
            row['obstructing_reply']=next(b for b,j in enumerate(edges[i]) if ranks[j] is None)
        rows.append(row)
    result={'schema':'vi.goal-continuation.v1', 'source':admission.fingerprint(source),
        'query':deepcopy(query), 'input_support':list(support), 'nodes':rows, 'root':0,
        'worst_case_contacts':ranks[0],
        'scope':'Exact finite monitor; common source instrument on retained quantum memory. All branches, no IID or fairness assumption.'}
    if ranks[0] is None:
        result['obstruction_kind']=('no_answer_on_any_finite_transcript' if all(v is None for v in outputs)
                                    else 'no_uniform_bound_for_all_reply_histories')
    verify(source,result)
    return result


def verify(source, certificate):
    """Check the exhibited graph, Bellman ranks and closed obstruction.

    Does not call synthesize. Terminal readings factor on the declared pairs;
    finite ranks strictly descend; every losing node has a losing successor.
    """
    require(certificate['schema']=='vi.goal-continuation.v1' and
        certificate['source']==admission.fingerprint(source) and certificate['root']==0, 'Wrong continuation root')
    query=certificate['query']; validate_request(source,query)
    nodes=certificate['nodes']; support=certificate['input_support']; src=source['goal']
    n=len(src['states'])
    require(type(support) is list and support and support==sorted(set(support)) and
            all(type(s) is int and 0<=s<n for s in support), 'Invalid source support')
    require(nodes and nodes[0]['pairs']==[[s,s] for s in support], 'Entry occurrence was replaced')
    keys=[]; relative=[x[0] for x in src['observation']['continue']]
    for row in nodes:
        pairs=row['pairs']
        require(pairs and pairs==[list(x) for x in sorted(set(map(tuple,pairs)))] and
                all(len(x)==2 and all(type(s) is int and 0<=s<n for s in x) for x in pairs), 'Invalid belief correspondence')
        keys.append(tuple(map(tuple,pairs)))
        require(len(row['next'])==2 and all(type(x)is int and 0<=x<len(nodes) for x in row['next']), 'Unbound reply branch')
        require({relative[j] for _,j in pairs}=={row['relative']}, 'Source quantum selector is not determined')
        require(row['answer']==answer(query,pairs), 'Unsupported terminal reading')
        require(row['answer'] is None or type(row['answer']) is int and row['answer'] in (0,1), 'Invalid answer representation')
        rank=row['rank']; require(rank is None or type(rank)is int and rank>=0, 'Invalid contact bound')
        for b,j in enumerate(row['next']):
            image=sorted(set((i,src['operations']['reply'+str(b)][s]) for i,s in pairs))
            require(nodes[j]['pairs']==[list(x) for x in image], 'Not the actual source post-contact image')
    require(len(keys)==len(set(keys)), 'Duplicate belief node')
    visited={0}; pending=[0]
    while pending:
        for j in nodes[pending.pop()]['next']:
            if j not in visited:
                visited.add(j); pending.append(j)
    require(len(visited)==len(nodes), 'Unrelated certificate nodes')
    for row in nodes:
        rank=row['rank']; children=[nodes[j]['rank'] for j in row['next']]
        if row['answer'] is not None:
            require(rank==0 and 'obstructing_reply' not in row, 'Known answer must stop without another contact')
        elif rank is not None:
            require(all(x is not None for x in children) and rank==1+max(children) and
                    'obstructing_reply' not in row, 'Claimed minimum is not a strict rank descent')
        else:
            b=row.get('obstructing_reply')
            require(type(b)is int and b in (0,1) and children[b] is None, 'No closed obstruction')
    require(certificate['worst_case_contacts']==nodes[0]['rank'], 'Wrong root contact bound')
    if nodes[0]['rank'] is None:
        expected=('no_answer_on_any_finite_transcript' if all(r['answer'] is None for r in nodes)
                  else 'no_uniform_bound_for_all_reply_histories')
        require(certificate.get('obstruction_kind')==expected, 'Obstruction overstates what was proved')
    else:
        require('obstruction_kind' not in certificate, 'Winning plan contains an unrelated obstruction')
    return True


def working_table(source, certificate):
    verify(source,certificate)
    require(certificate['worst_case_contacts'] is not None, 'No uniformly bounded continuation; retain obstruction')
    table=[]
    for row in certificate['nodes']:
        if row['rank'] is None:
            table.append(None)
        else:
            table.append({'answer':row['answer'],'relative':row['relative'],'next':row['next'],
                'current_support':sorted({s for _,s in row['pairs']})})
    return table


class Continuation:
    """A consumer of a certified table and a bound opaque port, not a model."""
    def __init__(self, source, port):
        validate_source(source)
        self.source=source; self.port=port
        self.source_id=admission.fingerprint(source); self.events=[]
        self.pending=None
        require(port.source_id==self.source_id, 'Port is bound to another source')
        checkpoint=port.checkpoint()
        require(checkpoint['basis'] in source['goal']['observation'], 'No source reading for the checkpoint')
        observations=source['goal']['observation'][checkpoint['basis']]
        self.support=[i for i,value in enumerate(observations) if value==checkpoint['value']]
        require(self.support, 'Checkpoint is outside the source reading')

    def perform(self, query):
        require(self.pending is None, 'Previous physical act has no confirmed continuation; no automatic replay')
        validate_source(self.source)
        require(self.port.source_id==self.source_id, 'The retained port changed source')
        cert=synthesize(self.source,self.support,query)
        if cert['worst_case_contacts'] is None:
            return {'executed':False,'certificate':cert,'contacts':0,'support':list(self.support)}
        table=working_table(self.source,cert); node=0; contacts=0
        while table[node]['answer'] is None:
            row=table[node]
            # Only a declared control goes outward. No true source, first
            # reply, channel matrix or expected outcome is supplied inward.
            require(self.port.source_id==self.source_id, 'Contact port changed its source')
            self.pending={'kind':'contact','relative':row['relative'],'node':node,
                          'certificate':admission.fingerprint(cert)}
            b=self.port.contact(row['relative'])
            require(type(b)is int and b in (0,1), 'Port did not return an acquired binary result')
            require(self.port.source_id==self.source_id, 'Returned contact belongs to another source')
            self.events.append({'contact':row['relative'],'reply':b})
            node=row['next'][b]; contacts+=1
            self.support=table[node]['current_support']
            self.pending=None
            require(contacts<=cert['worst_case_contacts'], 'Rank descent failed')
        bit=table[node]['answer']
        require(self.port.source_id==self.source_id, 'Recipient port changed its source')
        self.pending={'kind':'recipient','bit':bit,'node':node,'certificate':admission.fingerprint(cert)}
        self.port.recipient(bit)
        require(self.port.source_id==self.source_id, 'Recipient completion belongs to another source')
        self.pending=None
        self.support=table[node]['current_support']
        self.events.append({'recipient':bit,'support':list(self.support)})
        return {'executed':True,'answer':bit,'contacts':contacts,'support':list(self.support),
                'terminal_node':node,'certificate':cert}
