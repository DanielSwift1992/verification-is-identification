#!/usr/bin/env python3
"""JSON-lines console for the local, declared-instrument continuation demo.

The actor is the production finite consumer. InstrumentPort is explicitly the
local quantum fixture from the checks, not an IBM connection or a live QPU.
Each input is a new goal at the current retained boundary; no reload occurs.
"""
import argparse
import json
import sys

import resident_goal_synthesis as synthesis
from resident_goal_synthesis_checks import InstrumentPort, RetainingFirstPort
from resident_raw_reply_checks import fixture


def emit(value):
    print(json.dumps(value, separators=(',', ':')), flush=True)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fixture', type=int, choices=(0, 1), default=0)
    parser.add_argument('--seed', type=int, default=193)
    parser.add_argument('--memory', choices=('continue','first'), default='continue',
                        help='Choose what to retain before the first contact, not during an upgrade')
    args=parser.parse_args()
    source=synthesis.reading()
    theta,phi=((1.3,-.8),(1.45,.91))[args.fixture]
    _,maps,_=fixture(theta,phi)
    port=(InstrumentPort if args.memory=='continue' else RetainingFirstPort)(source,maps,args.seed)
    actor=synthesis.Continuation(source,port)
    emit({'ready':True, 'backend':'local-declared-instrument',
          'source':actor.source_id, 'support':actor.support, 'initial_memory':args.memory,
          'state_order':source['goal']['states'],
          'input':{'mask':'integer 0..255; bit i is the question on state i',
                   'occurrence':'entry or exit'}})
    for line in sys.stdin:
        if not line.strip():
            continue
        try:
            value=json.loads(line)
            synthesis.require(type(value) is dict and set(value)=={'mask','occurrence'},
                              'Expected exactly mask and occurrence')
            mask=value['mask']
            synthesis.require(type(mask) is int and 0<=mask<256, 'Mask must be an integer in 0..255')
            query=synthesis.request(source,[(mask>>i)&1 for i in range(8)],value['occurrence'])
            result=actor.perform(query)
            certificate=result.pop('certificate')
            result['minimum_worst_case_contacts']=certificate['worst_case_contacts']
            if not result['executed']:
                result['obstruction']=certificate['obstruction_kind']
            emit(result)
        except (ValueError,KeyError,TypeError) as error:
            emit({'error':str(error), 'unconfirmed_act':actor.pending})
            if actor.pending is not None:
                return 2
        except Exception as error:
            # A physical call may have happened. Do not recreate the port,
            # retry the request, or process the next line as a fresh session.
            emit({'error':type(error).__name__, 'unconfirmed_act':actor.pending})
            return 2
    return 0


if __name__=='__main__':
    raise SystemExit(main())
