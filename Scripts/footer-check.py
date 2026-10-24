#!/usr/bin/env python3
"""Parse delivered footer HTML and ask the JavaScript parser about every script."""
from html.parser import HTMLParser
import os
import subprocess

class Scripts(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=False)
        self.scripts=[]
        self.current=None
    def handle_starttag(self,tag,attrs):
        if tag=='script':
            if self.current is not None:raise ValueError('footer#script: nested script')
            self.current=''
    def handle_endtag(self,tag):
        if tag=='script' and self.current is not None:
            self.scripts.append(self.current)
            self.current=None
    def handle_data(self,data):
        if self.current is not None:self.current+=data

def check(text,address):
    parser=Scripts();parser.feed(text);parser.close()
    if parser.current is not None:raise ValueError(address+'#script: unclosed script')
    if len(parser.scripts)!=2:raise ValueError(address+'#script: expected the inline and table hooks')
    first=parser.scripts[0]
    if '__viInlineHook' not in first or 'var ROLE_CSS = ' not in first or 'WORLD_ROLE_CSS' in first:
        raise ValueError(address+'#script/1: missing inline hook or owner role CSS')
    if '__viTableHook' not in parser.scripts[1] or 'WORLD_TABLE_CSS' in parser.scripts[1]:
        raise ValueError(address+'#script/2: missing table hook or owner table CSS')
    env={k:v for k,v in os.environ.items() if k!='NODE_USE_SYSTEM_CA'}
    for number,source in enumerate(parser.scripts,1):
        result=subprocess.run(['node','--check','-'],input=source,text=True,capture_output=True,env=env)
        if result.returncode:raise ValueError(address+'#script/'+str(number)+': JavaScript parse failed: '+result.stderr)
    return len(parser.scripts)
