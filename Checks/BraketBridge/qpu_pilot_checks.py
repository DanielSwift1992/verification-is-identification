#!/usr/bin/env python3
"""Offline budget/idempotency checks. Fake AWS client only; no paid calls."""
import copy
from decimal import Decimal
from pathlib import Path
import tempfile
from unittest.mock import patch

import qpu_pilot as pilot
from build import ROOT
from execute import terminal_job
from prepare import prepare
from runtime import CheckFailure, require, load_json, write_json


class Identity:
    def get_caller_identity(self):
        return {'Account':'fixture'}


class FakeBraket:
    def __init__(self):
        self.calls, self.created, self.drop_reply = [], {}, True

    def create_quantum_task(self, **kwargs):
        self.calls.append(copy.deepcopy(kwargs))
        token = kwargs['clientToken']
        self.created.setdefault(token, 'arn-fixture-'+token)
        if self.drop_reply:
            self.drop_reply = False
            raise TimeoutError('reply lost after task creation')
        return {'quantumTaskArn':self.created[token]}


def main():
    for amount in ('0','1','5.01','NaN'):
        try:
            pilot.validate_budget(Decimal(amount))
        except CheckFailure:
            pass
        else:
            raise AssertionError('bad budget accepted: '+amount)
    pilot.validate_budget(Decimal('5'))
    docs, _ = prepare(ROOT/'private/braket-prepared')
    cases = []
    for name, state, _ in pilot.CASES:
        job, _, request = terminal_job(docs, name, state, pilot.SHOTS)
        cases.append({'job':job,'request':request,'input':state})
    plan = {'profile':'fixture','account':'fixture','bucket':'fixture',
            'prefix':'fixture','budget_usd':'5','cases':cases}
    fake = FakeBraket()
    with tempfile.TemporaryDirectory() as temporary:
        directory = Path(temporary)
        write_json(directory/'ledger.json', {'schema':'vi.braket.qpu-ledger.v1','entries':{}})
        with patch.object(pilot,'read_plan',return_value=plan), \
             patch.object(pilot,'clients',return_value=(fake,None,Identity())), \
             patch.object(pilot,'capabilities',return_value={}):
            try:
                pilot.submit(directory)
            except TimeoutError:
                pass
            else:
                raise AssertionError('uncertain submission not propagated')
            require(len(load_json(directory/'ledger.json')['entries']) == 1, 'missing pre-call reservation')
            pilot.submit(directory)
            require(fake.calls[0] == fake.calls[1], 'retry changed token or request body')
            require(len(fake.created) == 3 and len(fake.calls) == 4, 'duplicate unique task created')
            pilot.submit(directory)
            require(len(fake.calls) == 4, 'repeated submit created another task')
    print('PASS: budget; durable token; exact retry; three unique tasks; completed submission is a no-op')


if __name__ == '__main__':
    main()
