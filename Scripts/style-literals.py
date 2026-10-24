#!/usr/bin/env python3
"""Check selected visual values at the drawing mechanism's syntactic reading edge."""
import re

SVG_ATTRIBUTES=('font-weight', 'font-size', 'font-family', 'font-style', 'stroke-width', 'stroke-dasharray', 'stroke-linecap', 'stroke-linejoin', 'rx', 'ry', 'r', 'markerWidth', 'markerHeight', 'refX', 'refY', 'orient', 'viewBox', 'd', 'fill-opacity', 'stroke-opacity', 'flood-opacity', 'opacity', 'color', 'fill', 'stroke', 'flood-color', 'dur', 'values', 'dx', 'dy', 'stdDeviation')
CSS_PROPERTIES=('font-weight', 'font-size', 'font-family', 'font-style', 'stroke-width', 'stroke-dasharray', 'stroke-linecap', 'stroke-linejoin', 'border-radius', 'opacity', 'color', 'background', 'background-color', 'fill', 'stroke', 'flood-color', 'transition', 'transition-duration', 'transition-delay', 'transition-timing-function', 'animation', 'animation-duration', 'animation-delay', 'animation-timing-function', 'box-shadow', 'text-shadow', 'margin', 'margin-top', 'margin-right', 'margin-bottom', 'margin-left', 'padding', 'padding-top', 'padding-right', 'padding-bottom', 'padding-left', 'gap', 'row-gap', 'column-gap')
ATTRIBUTES='|'.join(SVG_ATTRIBUTES)
CSS='|'.join(CSS_PROPERTIES)

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
    if re.search(r'\b(?:White|Black)\b',expression):return 'fixed-spectrum-endpoint'
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
        before=view[max(0,m.start()-400):m.start()]
        # A frame's coordinate construction is mathematical. The selected box
        # and path of a marker are the visual geometry of its owner.
        if m[1] in ['viewBox','d'] and '<marker' not in before:continue
        if m[1]=='fill' and value=='freeze' and '<set ' in before:continue
        rest=re.sub(r'\{reading\}|var\(--[\w-]+,?\s*|url\(#[\w-]+\)','',value).strip()
        if m[1]=='dur':rest=re.sub(r'(?<![\w])(ms|s)(?![\w])','',rest)
        if not value or ('{reading}' not in value and not re.fullmatch(r'var\(--[\w-]+\)',value)) or re.search(r'[A-Za-z0-9#]',rest):
            raise ValueError(address+':'+str(view[:m.start()].count('\n')+1)+': literal visual attribute '+m[1]+' belongs to a world')
    for m in re.finditer(r'(?<![\w-])('+CSS+r')\s*:\s*((?:\{reading\}|[^;{}\n])+)',view):
        value=m[2].strip()
        before=view[max(0,m.start()-2):m.start()]
        if not re.search(r'[;{]\s*$',before):continue
        rest=re.sub(r'\{reading\}|var\(--[\w-]+,?\s*|url\(#[\w-]+\)','',value).strip()
        if m[1].startswith('transition'):
            # The emitter names the property whose state transition it implements.
            rest=re.sub(r'\b(?:opacity|stroke-width|stroke|transform|visibility)\b','',rest)
        rest=re.sub(r'(?<![\w])(?:ms|s|px|em|rem)(?![\w])','',rest)
        if value and ('{reading}' in value or re.fullmatch(r'var\(--[\w-]+\)',value)) and not re.search(r'[A-Za-z0-9#]',rest):continue
        raise ValueError(address+':'+str(view[:m.start()].count('\n')+1)+': literal visual CSS '+m[1]+' belongs to a world')


def controls():
    """Exercise every closed visual position in both serialization carriers."""
    counts={'svg':0,'css':0,'refusals':0}
    def refuse(source,swift):
        try:check(source,'new/subfolder/Control.swift' if swift else 'new/subfolder/Control.js',swift)
        except ValueError:counts['refusals']+=1
        else:raise AssertionError('literal style admitted: '+source)
    for attribute in SVG_ATTRIBUTES:
        for swift in [True,False]:
            opening='<marker><path ' if attribute=='d' else '<marker ' if attribute in ['viewBox','orient','markerWidth','markerHeight','refX','refY'] else '<g '
            literal=opening+attribute+'="9"/>'
            refuse(literal,swift)
            owner=opening+attribute+'="'+('\\(Binding.Value)' if swift else '${binding.value}')+'"/>'
            check(owner,'positive.swift' if swift else 'positive.js',swift)
            interpolated=opening+attribute+'="'+('\\(9)' if swift else '${9}')+'"/>'
            refuse(interpolated,swift)
        counts['svg']+=1
    for property in CSS_PROPERTIES:
        for swift in [True,False]:
            refuse('<style>.new{'+property+':9;}</style>',swift)
            owner='<style>.new{'+property+':'+('\\(Binding.Value)' if swift else '${binding.value}')+';}</style>'
            check(owner,'positive.swift' if swift else 'positive.js',swift)
        counts['css']+=1
    for endpoint in ['White','Black']:
        refuse('<g fill="\\('+endpoint+'.typeName)"/>',True)
        refuse('<g fill="${'+endpoint+'.typeName}"/>',False)
    check('let count=12/2; let radix=8; let text="White #abc Inter-world"','algorithm.swift')
    check('<g stroke-width="\\(Binding.width / 2)"/>','algorithm.swift')
    check('<g stroke-width="${binding.width / 2}"/>','algorithm.js',False)
    return counts
