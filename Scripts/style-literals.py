#!/usr/bin/env python3
"""Check selected visual values at the drawing mechanism's syntactic reading edge."""
import re

ATTRIBUTES=r'font-weight|font-size|font-family|font-style|stroke-width|stroke-dasharray|stroke-linecap|stroke-linejoin|rx|ry|r|markerWidth|markerHeight|refX|refY|fill-opacity|stroke-opacity|flood-opacity|opacity|color|fill|stroke|flood-color'
CSS=r'font-weight|font-size|font-family|font-style|stroke-width|stroke-dasharray|stroke-linecap|stroke-linejoin|border-radius|opacity|color|background(?:-color)?|fill|stroke|flood-color'

def code_without_comments(text):
    # Keep strings intact; only comments outside strings disappear.
    token=re.compile(r'"""[\s\S]*?"""|"(?:\\.|[^"\\])*"|`(?:\\.|[^`\\])*`|\'(?:\\.|[^\'\\])*\'|//[^\n]*|/\*[\s\S]*?\*/|<!--[\s\S]*?-->')
    return token.sub(lambda m: '\n'*m[0].count('\n') if m[0].startswith(('//','/*','<!--')) else m[0],text)

def readout(text,literals=None):
    literals=literals or {}
    def field(match):
        expression=match[1].strip()
        key=re.sub(r'^svgAttr\((\w+)\)$',r'\1',expression)
        if key in literals:return literals[key]
        if re.fullmatch(r'(?:0x[0-9a-fA-F]+|[0-9.]+)',key):return key
        return '{reading}'+'\n'*match[0].count('\n')
    text=re.sub(r'"\s*\+\s*"',lambda m:'\n'*m[0].count('\n'),text)
    text=re.sub(r"'\s*\+\s*'",lambda m:'\n'*m[0].count('\n'),text)
    text=re.sub(r"'\s*\+\s*([^'\n]+?)\s*\+\s*'",field,text)
    text=re.sub(r'"\s*\+\s*([^"\n]+?)\s*\+\s*"',field,text)
    return text.replace('\\"','"').replace("\\'", "'")


def interpolation(expression):
    expression=expression.strip()
    scalar=r'(?:0x[0-9a-fA-F]+|[+-]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+))'
    if re.fullmatch(scalar,expression):return expression
    if re.fullmatch(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',expression):return expression[1:-1]
    # A literal passed at this serialization edge is a selected value. Counts
    # inside an arithmetic expression (such as a division by two) stay readings.
    argument=r'(?:"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|'+scalar+r')'
    if re.search(r'[(,:]\s*'+argument+r'\s*(?=[,)])',expression):return 'literal-style-argument'
    return '{reading}'


def dynamic(text):
    out='';index=0
    while index<len(text):
        if text.startswith('\\(',index):
            at=index+2;depth=1;quote=None
            while at<len(text) and depth:
                char=text[at]
                if quote:
                    if char=='\\':at+=2;continue
                    if char==quote:quote=None
                elif char in ['"',"'"]:quote=char
                elif char=='(':depth+=1
                elif char==')':depth-=1
                at+=1
            out+=interpolation(text[index+2:at-1])+'\n'*text[index:at].count('\n');index=at
        else:out+=text[index];index+=1
    return re.sub(r'\$\{([^}]*)\}',lambda m:interpolation(m[1]),out)


def check(text,address,swift=True):
    code=code_without_comments(text)
    def fail(offset,message):
        raise ValueError(address+':'+str(code[:offset].count('\n')+1)+': '+message)
    if swift:
        for declaration in re.finditer(r'\benum\s+\w+\s*:\s*([^{}]+)\{',code):
            if re.search(r'\bPaint\b',declaration[1]):fail(declaration.start(),'concrete paint belongs to a world')
        for declaration in re.finditer(r'(?:enum|protocol)\s+(Cover\d+|WeightRegular|WeightBold)\b',code):
            if re.search(r'extension\s+'+declaration[1]+r'\s*\{[^{}]*typeName[^{}]*\{\s*(?:"|0x|\d)',code):
                fail(declaration.start(),'alpha or weight value belongs to a world')
    # Fold adjacent literal pieces and the simple literal atoms used by this edge.
    literals={}
    for m in re.finditer(r'\b(?:let|var|const)\s+(\w+)(?:\s*:\s*[\w.]+)?\s*=\s*(0x[0-9a-fA-F]+|[0-9.]+|"(?:\\.|[^"\\])*")',code):literals[m[1]]=m[2].strip('"')
    for m in re.finditer(r'extension\s+(\w+)\s*\{[^{}]*typeName[^{}]*\{\s*"([^"\\]*)"\s*\}',code):literals[m[1]+'.typeName']=m[2]
    for m in re.finditer(r'(?:enum|struct|class)\s+(\w+)[^{}]*\{[^{}]*typeName[^{}]*\{\s*"([^"\\]*)"\s*\}',code):literals[m[1]+'.typeName']=m[2]
    for name,value in literals.items():
        code=code.replace('\\('+name+')',value).replace('${'+name+'}',value)
        code=re.sub(r'\\\(XMLEscaped<'+re.escape(name.removesuffix('.typeName'))+r'>\.typeName\)',lambda _:value,code) if name.endswith('.typeName') else code
    view=dynamic(readout(code,literals))
    for m in re.finditer(r'(?<![\w-])('+ATTRIBUTES+r')\s*=\s*(["\'])(.*?)\2',view,re.S):
        value=m[3]
        before=view[max(0,m.start()-100):m.start()]
        # SMIL's fill=freeze is a timing policy; it is not a paint attribute.
        if m[1]=='fill' and value=='freeze' and '<set ' in before:continue
        rest=re.sub(r'\{[^}]*\}','',value).strip()
        if not value or (not '{' in value and not re.fullmatch(r'var\(--[\w-]+\)',value)) or re.search(r'[A-Za-z0-9#]',re.sub(r'var\(--[\w-]+,?\s*|url\(#?[\w-]*|[)\s%,;]','',rest)):
            raise ValueError(address+':'+str(view[:m.start()].count('\n')+1)+': literal visual attribute '+m[1]+' belongs to a world')
    for m in re.finditer(r'(?<![\w-])('+CSS+r')\s*:\s*([^;{}\n]+)',view):
        value=m[2].strip()
        if not value and view[m.end():].startswith('{reading}'):continue
        if value.startswith('{') or '{reading}' in value:continue
        if re.fullmatch(r'var\(--[\w-]+\)',value):continue
        # Match actual declarations, not Swift bindings, parameter labels or prose.
        before=view[max(0,m.start()-2):m.start()]
        if not re.search(r'[;{]\s*$',before):continue
        raise ValueError(address+':'+str(view[:m.start()].count('\n')+1)+': literal visual CSS '+m[1]+' belongs to a world')
