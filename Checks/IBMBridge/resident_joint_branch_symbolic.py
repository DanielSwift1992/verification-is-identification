#!/usr/bin/env python3
"""Exact blind-branch identity for the declared Ry/CX/CZ fixture.

Runs with system Python + SymPy; no SDK or cloud access. Independent equations
are compared with the SDK model by resident_joint_branch_analysis.py.
"""
import argparse
import json
from pathlib import Path
import sympy as sp


def embed(m,wires,n):
    out=sp.zeros(2**n)
    for col in range(2**n):
        j=sum(((col>>q)&1)<<i for i,q in enumerate(wires))
        base=col & ~sum(1<<q for q in wires)
        for i in range(2**len(wires)):
            row=base | sum(((i>>bit)&1)<<q for bit,q in enumerate(wires))
            out[row,col]=m[i,j]
    return out


def run():
    a,b,c,d=sp.symbols('a b c d',real=True)
    H=sp.Matrix([[1,1],[1,-1]])/sp.sqrt(2);S=sp.diag(1,sp.I)
    X=sp.Matrix([[0,1],[1,0]]);Y=sp.Matrix([[0,-sp.I],[sp.I,0]])
    Z=sp.diag(1,-1);CZ=sp.diag(1,1,1,-1)
    CX=sp.Matrix([[1,0,0,0],[0,0,0,1],[0,0,1,0],[0,1,0,0]])
    u=sp.eye(8)
    for m,w in [(sp.Matrix([[a,-b],[b,a]]),[0]),(CX,[1,0]),(CZ,[0,2]),
                (sp.Matrix([[c,-d],[d,c]]),[1]),(CX,[2,1])]:u=embed(m,w,3)*u
    ks=[u.extract(list(range(bit,8,2)),list(range(0,8,2))) for bit in (0,1)]
    v0=sp.zeros(16,1);v0[0]=1
    for m,w in [(H,[2]),(CX,[2,3]),(H,[1]),(CX,[1,0])]:v0=embed(m,w,4)*v0
    rho=sp.zeros(16)
    observables={'X_D':embed(X,[2],4),'Y_REF':embed(Y,[3],4),
                 'X_D_Y_REF':embed(X,[2],4)*embed(Y,[3],4)}
    by_history={}
    # First f=0 requires a fourth contact. Code 1 means r=1,f=0,l=0;
    # starting r=0, the exact transition gives these two histories only.
    histories=[(0,0,1,0),(0,1,0,0)]
    for history in histories:
        v=v0;r=0
        for bit in history:
            v=sp.kronecker_product(sp.eye(4),ks[bit])*v
            v=embed(H if (r^bit)==0 else S,[2],4)*v
            v=embed(Z,[1],4)*v;v=embed(CZ,[2,1],4)*v
            v=v.applyfunc(sp.expand);r=1^r^bit
        assert (r,history[0],history[-1])==(1,0,0)
        block=v*v.conjugate().T
        row={name:sp.expand(sp.trace(m*block)) for name,m in observables.items()}
        assert all(x==0 for x in row.values())
        by_history[''.join(map(str,history))]={k:str(v) for k,v in row.items()}
        rho+=block
    zeros={name:sp.expand(sp.trace(m*rho)) for name,m in observables.items()}
    assert all(v==0 for v in zeros.values())
    # No use of a²+b²=1 or c²+d²=1 is needed for these zero polynomials.
    values={a:sp.cos(sp.Rational(13,20)),b:sp.sin(sp.Rational(13,20)),
            c:sp.cos(-sp.Rational(2,5)),d:sp.sin(-sp.Rational(2,5))}
    numeric=rho.subs(values).evalf(17)
    mass=float(sp.re(sp.trace(numeric)))
    delta=embed(Z,[2],4)*numeric*embed(Z,[2],4)-numeric
    norm=float(sp.sqrt(sum(sp.Abs(x)**2 for x in delta)))
    return {'exact_zero_polynomials':{k:str(v) for k,v in zeros.items()},
            'per_history_exact_zero_polynomials':by_history,
            'scope':'Declared initial Bell preparations, First stopping rule, this real Ry/CX/CZ service family, code 1.',
            'histories':[list(h) for h in histories],'parameter_meaning':['cos(theta/2)','sin(theta/2)','cos(phi/2)','sin(phi/2)'],
            'numeric_fixture':[1.3,-.8],'numeric_branch_mass':mass,'numeric_state_difference_Frobenius':norm,
            'sympy_version':sp.__version__,
            'conclusion':'The entire available (X_D,Y_REF) distribution at code 1 is unchanged by Z_D, although the retained state can change.'}


if __name__=='__main__':
    cli=argparse.ArgumentParser(description=__doc__);cli.add_argument('--output',type=Path,required=True)
    args=cli.parse_args();result=run();args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
