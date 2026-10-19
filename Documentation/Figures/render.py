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
    f=Figure('VI: a determined answer and an adequate continuation', 'The first panel states VI U2c: a nonempty compatible family determines an answer exactly when the question is constant on it. The second states the adequacy law from Acquisition Keeps Its Question: intersect the available adequate continuations across all source-residue pairs compatible with the complete input. A chosen continuation and its realization must still be supplied. These are criteria, not a claim of automatic construction.', 1000)
    f.text(40,42,'VERIFICATION IS IDENTIFICATION','eyebrow blue')
    f.text(40,83,'What do the available relations determine?','heading')
    f.text(40,115,'The question fixes what must agree. The rest can remain unknown.','body muted')

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
    f.text(62,433,'“Not yet established” is a state of the check, separate from these three mathematical cases.','small muted')

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
    f.text(62,797,'For reached m. F covers all admitted outcomes, with an outcome for each admitted initial condition.','small muted')
    f.text(62,824,'A nonempty intersection establishes existence. It does not supply a choice or an executor.','small muted')

    f.path('M902 731V868H560V887',dashed=True)
    f.text(904,862,'record the actual result','small muted',text_anchor='end')
    f.rect(40,887,1040,72,'#ffffff','#a6b5c8')
    f.text(62,916,'For the next participant','label')
    f.text(62,944,'Keep the original requirement, actual residue, available access and grounds of the next use.','body muted')
    f.text(40,985,'The diagrams state the criteria. Their premises, action laws and source connections require grounds.','small muted')
    f.save('vi-method.svg')
    full=(OUT/'vi-method.svg').read_text()
    # Views of the same argument, placed beside the corresponding README text.
    for name, top, height in [('answer-determination.svg',140,320),('adequate-continuation.svg',470,500)]:
        view=full.replace('height="1000" viewBox="0 0 1120 1000"',f'height="{height}" viewBox="0 {top} 1120 {height}"',1)
        (OUT/name).write_text(view)


def architecture():
    f=Figure('VI framework: target responsibilities and present implementation', 'Target design: VI owns the research, constructions and where/count semantics. Showcase owns the worked organization, rendering and organizational policy. Gate supplies interfaces and a judge implementation. A versioned contract links the semantic owner to an implementation. The package split and gate alignment are not complete. Desk is a research workspace. Arrow labels distinguish source dependencies from conformance and delivery.', 890)
    f.text(40,42,'FRAMEWORK / TARGET RESPONSIBILITIES','eyebrow blue')
    f.text(40,83,'Three packages. Each pass has a semantic owner.','heading')
    f.text(40,115,'Dashed boundaries show the intended split. The present code has not yet been moved.','body muted')
    f.rect(40,149,1040,83,'#f6f8fb')
    f.text(62,180,'People and agents','label')
    f.text(62,209,'Bring a question, a record and access to work. Desk currently holds the research process.','body muted')
    f.path('M905 232V290')
    f.text(919,266,'submit a record','small muted')

    f.rect(40,302,300,326,'#edf3fb','#7c9fc9',True)
    f.text(62,339,'vi','heading blue')
    f.lines(62,376,['Research and constructions','Papers · relations · examples','Checks of stated consequences'],'body',29)
    f.rect(60,478,260,125,'#ffffff','#bdcfe7')
    f.text(78,509,'Semantic owner','label blue')
    f.lines(78,540,['where: declared type relations','count: selected count question','Canon + conformance fixtures'],'small',25)

    f.rect(410,302,300,326,'#f7f8fa','#98a5b7',True)
    f.text(432,339,'showcase','heading')
    f.lines(432,376,['A constructed world','Organization · DocumentKit','Pages · SVG · site generation'],'body',29)
    f.rect(430,478,260,125,'#ffffff')
    f.text(448,509,'Its own obligations','label')
    f.lines(448,540,['Organization policy + judge','Artifacts match constructions','Publication controls retain scope'],'small',25)

    f.rect(780,302,300,326,'#edf7f1','#7aa68f',True)
    f.text(802,339,'gate','heading green')
    f.lines(802,376,['Entry and delivery','Records from other projects','Calls checks · returns results'],'body',29)
    f.rect(800,478,260,125,'#ffffff','#bad9c8')
    f.text(818,509,'Supplied implementation','label green')
    f.lines(818,540,['Must pass the selected contract','Carries question + coverage','A port preserves the question'],'small',25)

    f.path('M410 442H340')
    f.text(375,424,'uses vi','small muted',text_anchor='middle')
    f.path('M190 628V684')
    f.text(205,663,'defines where / count','small muted')
    f.path('M560 628V684')
    f.text(575,663,'defines organization','small muted')
    f.rect(40,698,1040,99,'#ffffff','#8ba2be')
    f.text(62,730,'Contract of the selected pass','label blue')
    f.text(62,758,'Question / semantics     ·     accepted input     ·     response form     ·     conformance suite','body')
    f.text(62,783,'Versions belong to each pass. Passing finite fixtures establishes that scope of conformance.','small muted')
    f.path('M930 628V684')
    f.text(945,663,'conforms to','small muted')
    f.text(40,829,'CURRENT  Court and showcase targets share the vi repository. Gate still pins an older canon.','body')
    f.text(40,856,'NEXT  Align contracts and coverage, measure check profiles, then move the showcase and its controls.','small muted')
    f.text(40,880,'The publication checks depend on DocumentKit today; this is a test dependency, not a core-library import.','small muted')
    f.save('framework-architecture.svg')


if __name__=='__main__':
    method()
    architecture()
