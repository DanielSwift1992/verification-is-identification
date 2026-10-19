#!/usr/bin/env python3
"""Render source-addressed README diagrams. No runtime counts or inferred imports."""
from html import escape
from pathlib import Path

OUT = Path(__file__).resolve().parent


class Figure:
    def __init__(self, title, desc, height):
        self.parts = [f'''<svg xmlns="http://www.w3.org/2000/svg" width="1120" height="{height}" viewBox="0 0 1120 {height}" role="img" aria-labelledby="title desc">
<title id="title">{escape(title)}</title><desc id="desc">{escape(desc)}</desc>
<defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0L10 5L0 10Z" fill="#64748b"/></marker></defs>
<style>text{{font-family:Inter,'Segoe UI',Arial,sans-serif;fill:#18263b}}.muted{{fill:#526174}}.blue{{fill:#204f8f}}.green{{fill:#16634b}}.amber{{fill:#8b5e16}}.math{{font-family:'DejaVu Sans',sans-serif}}.small{{font-size:16px}}.body{{font-size:18px}}.label{{font-size:20px;font-weight:600}}.heading{{font-size:28px;font-weight:650}}.eyebrow{{font-size:14px;font-weight:700;letter-spacing:1.6px}}</style>
<rect width="1120" height="{height}" rx="16" fill="#ffffff"/>
''']

    def text(self, x, y, content, cls='body', **attrs):
        extra=' '.join(f'{k.replace("_","-")}="{v}"' for k,v in attrs.items())
        self.parts.append(f'<text x="{x}" y="{y}" class="{cls}" {extra}>{escape(content)}</text>')

    def lines(self,x,y,lines,cls='body',step=27):
        for i,line in enumerate(lines): self.text(x,y+i*step,line,cls)

    def rect(self,x,y,w,h,fill='#f6f8fb',stroke='#dde3eb',dashed=False):
        dash=' stroke-dasharray="7 5"' if dashed else ''
        self.parts.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="12" fill="{fill}" stroke="{stroke}" stroke-width="1.5"{dash}/>')

    def path(self,d,dashed=False):
        dash=' stroke-dasharray="6 5"' if dashed else ''
        self.parts.append(f'<path d="{d}" fill="none" stroke="#64748b" stroke-width="1.8" marker-end="url(#arrow)"{dash}/>')

    def save(self,name):
        (OUT/name).write_text(''.join(self.parts)+'</svg>\n')


def method():
    f=Figure('A determined answer and an adequate continuation', 'Left: the cases compatible with the constraints determine an answer when they exist and the question takes one value on all of them (U2c). Right: a continuation is adequate when it works at every source and reached state compatible with the complete input to the choice (Acquisition Keeps Its Question). The chosen continuation still has to be supplied and carried out.', 1000)
    f.text(40,42,'VERIFICATION IS IDENTIFICATION','eyebrow blue')
    f.text(40,83,'What do the available relations determine?','heading')

    f.rect(40,150,1040,300)
    f.text(62,184,'1   Establish an answer','label')
    f.text(1048,184,'VI · U2c','small muted',text_anchor='end')
    f.rect(62,211,254,155,'#ffffff')
    f.text(80,243,'Compatible cases','label')
    f.text(80,279,'S = {s ∈ F : C(s)}','body math blue')
    f.lines(80,310,['F: admitted candidates','C: supplied constraints'],'small muted',24)
    f.path('M316 287H367')
    f.text(341,268,'ask','small muted',text_anchor='middle')
    f.rect(380,243,176,90,'#edf3fb','#bdcfe7')
    f.text(468,278,'Question q','label blue',text_anchor='middle')
    f.text(468,308,'q : F → A','body math',text_anchor='middle')
    f.path('M556 287H595V240H627')
    f.path('M556 287H627')
    f.path('M595 287V345H627')
    f.rect(640,209,412,63,'#edf7f1','#bad9c8')
    f.text(659,235,'One answer','label green')
    f.text(659,257,'S ≠ ∅ and q(S) = {a}','body math')
    f.rect(640,279,412,52,'#ffffff')
    f.text(659,311,'Several answers: q varies on S','body')
    f.rect(640,338,412,52,'#fff8ec','#e8d2aa')
    f.text(659,370,'No compatible case: S = ∅','body amber')
    f.text(62,407,'One answer can be established while several source candidates remain.','body')
    f.text(62,433,'A check that has not yet decided which case holds is in a separate state.','small muted')

    f.rect(40,480,1040,360)
    f.text(62,514,'2   Choose a continuation','label')
    f.text(1048,514,'Acquisition Keeps Its Question · The law','small muted',text_anchor='end')
    f.rect(62,541,284,190,'#ffffff')
    f.text(80,573,'Source and reached state','label')
    f.text(80,606,'F ⊆ X × Y, actual relation','small math blue')
    f.lines(80,635,['x: initial condition','y: reached state','m = E(y): complete input','to the choice of continuation'],'small muted',23)
    f.path('M346 638H383')
    f.rect(396,541,306,190,'#edf3fb','#bdcfe7')
    f.text(414,573,'What works throughout','label blue')
    f.text(414,608,'S(m) = {(x,y) ∈ F : E(y)=m}','small math')
    f.text(414,636,'W(m) = ⋂ W(x,y)','body math')
    f.text(414,659,'over all (x,y) in S(m)','small muted')
    f.lines(414,682,['W(x,y): available continuations','that meet the original requirement','at this actual source–residue pair.'],'small muted',20)
    f.path('M702 638H739',dashed=True)
    f.rect(752,541,300,190,'#edf7f1','#bad9c8')
    f.text(770,573,'Supply and carry it out','label green')
    f.text(770,604,'If W(m) ≠ ∅:','body math')
    f.text(770,632,'supply d(m) ∈ W(m)','body math')
    f.lines(770,659,['Provide its laws and access.','Realize the chosen continuation.','If required, every admitted','execution must complete.'],'small',20)
    f.text(62,770,'The same chosen program can act on different unknown contents and produce different results.','body')
    f.text(62,797,'F lists an outcome for each admitted initial condition.','small muted')
    f.text(62,824,'W(m) ≠ ∅ shows that a continuation exists. Choosing it and running it are separate steps.','small muted')

    f.path('M902 731V868H560V887',dashed=True)
    f.text(904,862,'record the actual result','small muted',text_anchor='end')
    f.rect(40,887,1040,72,'#ffffff','#a6b5c8')
    f.text(62,916,'For the next participant','label')
    f.text(62,944,'Keep the original requirement, actual residue, available access and grounds of the next use.','body muted')
    f.save('vi-method.svg')
    full=(OUT/'vi-method.svg').read_text()
    # Views of the same argument, placed beside the corresponding README text.
    for name, top, height in [('answer-determination.svg',140,320),('adequate-continuation.svg',470,500)]:
        view=full.replace('height="1000" viewBox="0 0 1120 1000"',f'height="{height}" viewBox="0 {top} 1120 {height}"',1)
        (OUT/name).write_text(view)


def architecture():
    f=Figure('vi, showcase and gate', 'vi owns the research, the constructions and the where and count semantics. showcase is a separate repository with the worked company, its rendering and its policy, and it pins a revision of vi. gate brings records from other projects to a judge built from a pinned revision of vi. A versioned contract with conformance fixtures states what an implementation of a check must pass.', 890)
    f.text(40,42,'THREE PACKAGES','eyebrow blue')
    f.text(40,83,'Each check has one owner of its meaning.','heading')
    f.rect(40,149,1040,83,'#f6f8fb')
    f.text(62,180,'People and agents','label')
    f.text(62,209,'Bring a question, a record and access to work.','body muted')
    f.path('M905 232V290')
    f.text(919,266,'submit a record','small muted')

    f.rect(40,302,300,326,'#edf3fb','#7c9fc9')
    f.text(62,339,'vi','heading blue')
    f.lines(62,376,['Research and constructions','Papers · relations · examples','Checks of stated consequences'],'body',29)
    f.rect(60,478,260,125,'#ffffff','#bdcfe7')
    f.text(78,509,'Semantic owner','label blue')
    f.lines(78,540,['where: declared type relations','count: selected count question','Canon + conformance fixtures'],'small',25)

    f.rect(410,302,300,326,'#f7f8fa','#98a5b7')
    f.text(432,339,'showcase','heading')
    f.lines(432,376,['A constructed world','Organization · DocumentKit','Pages · SVG · site generation'],'body',29)
    f.rect(430,478,260,125,'#ffffff')
    f.text(448,509,'Its own checks','label')
    f.lines(448,540,['Policy + differential judge','Artifacts match constructions','Seven publication refusals'],'small',25)

    f.rect(780,302,300,326,'#edf7f1','#7aa68f')
    f.text(802,339,'gate','heading green')
    f.lines(802,376,['Entry and delivery','Records from other projects','Calls checks · returns results'],'body',29)
    f.rect(800,478,260,125,'#ffffff','#bad9c8')
    f.text(818,509,'Supplied implementation','label green')
    f.lines(818,540,['Passes the selected contract','Carries question + coverage','Pinned revision of vi'],'small',25)

    f.path('M410 442H340')
    f.text(375,424,'uses vi','small muted',text_anchor='middle')
    f.path('M190 628V684')
    f.text(205,663,'defines where / count','small muted')
    f.path('M560 628V684')
    f.text(575,663,'defines organization','small muted')
    f.rect(40,698,1040,99,'#ffffff','#8ba2be')
    f.text(62,730,'Contract of each check','label blue')
    f.text(62,758,'Question / semantics     ·     accepted input     ·     response form     ·     conformance suite','body')
    f.text(62,783,'Each check has its own version. Passing the finite fixtures shows conformance on that suite.','small muted')
    f.path('M930 628V684')
    f.text(945,663,'conforms to','small muted')
    f.text(40,829,'NOW  vi and showcase are separate repositories, and showcase pins vi. Gate pins an older revision.','body')
    f.text(40,856,'A Rust sample of the judge passes the finite suite of the contract. NEXT  Gate re-pins through the contract.','small muted')
    f.save('framework-architecture.svg')


if __name__=='__main__':
    method()
    architecture()
