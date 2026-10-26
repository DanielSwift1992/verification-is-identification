import Record.Extended.Image
import U10.Certificate

namespace Record.Extended
open U5
attribute [local simp] Bind.bind Pure.pure Functor.map Except.bind Except.pure Except.map

def agreementSource (w : AgreementRaw) : Record.Raw := ⟨w.base.source,w.base.edges,w.question,w.question⟩

def addresses : Term Nat → Path → Term Path
  | .leaf _,p => .leaf p
  | .pair l r,p => .pair (addresses l (p++[false])) (addresses r (p++[true]))

/-- Pair the two declared endpoint trees, retaining their own tree addresses. -/
def bindCuts : Term Path → Term Path → Path → Option (List U10.Binding)
  | .leaf o,.leaf s,p => some [⟨p,o,s⟩]
  | .pair l r,.pair a b,p => do
    let xs ← bindCuts l a (p++[false])
    let ys ← bindCuts r b (p++[true])
    pure (xs++ys)
  | _,_,_ => none

theorem bind_cuts_flat {o s : Term Path} {p : Path} {bs : List U10.Binding}
    (h : bindCuts o s p = some bs) :
    bs.map U10.Binding.output = o.values ∧ bs.map U10.Binding.source = s.values := by
  induction o generalizing s p bs with
  | leaf q =>
    cases s with
    | pair a b => simp [bindCuts] at h
    | leaf r => simp [bindCuts] at h; subst bs; exact ⟨rfl,rfl⟩
  | pair l r ihl ihr =>
    cases s with
    | leaf q => simp [bindCuts] at h
    | pair a b =>
      cases hl : bindCuts l a (p++[false]) with
      | none => simp [bindCuts,hl] at h
      | some xs =>
        cases hr : bindCuts r b (p++[true]) with
        | none => simp [bindCuts,hl,hr] at h
        | some ys =>
          simp [bindCuts,hl,hr] at h
          subst bs
          obtain ⟨hlo,hls⟩ := ihl hl
          obtain ⟨hro,hrs⟩ := ihr hr
          simp [List.map_append,Term.values,hlo,hls,hro,hrs]

def bindings (w : AgreementRaw) (source output : Term Nat) : Except String (List U10.Binding) := do
  match w.boundOutputs,w.boundSources with
  | none,none => pure []
  | some o,some s => do
    view output o "record.boundOutputs"
    view source s "record.boundSources"
    fromOption (bindCuts o s []) "record.boundSources: endpoint shapes differ"
  | some _,none => .error "record.boundSources: both binding endpoint fields are required together"
  | none,some _ => .error "record.boundOutputs: both binding endpoint fields are required together"

def BindingsDenote (w : AgreementRaw) (bs : List U10.Binding) : Prop :=
  match w.boundOutputs,w.boundSources with
  | none,none => bs = []
  | some o,some s => bindCuts o s [] = some bs
  | _,_ => False

theorem bindings_denote {w : AgreementRaw} {source output : Term Nat} {bs : List U10.Binding}
    (h : bindings w source output = .ok bs) : BindingsDenote w bs := by
  unfold bindings at h
  cases ho : w.boundOutputs <;> cases hs : w.boundSources <;>
    simp [ho,hs,BindingsDenote] at h ⊢
  · exact h
  · rename_i o s
    cases hv : view output o "record.boundOutputs" with
    | error e => simp [hv] at h
    | ok u =>
      cases hz : view source s "record.boundSources" with
      | error e => simp [hv,hz] at h
      | ok u =>
        cases hb : bindCuts o s [] with
        | none => simp [hv,hz,fromOption,hb] at h
        | some values => simp [hv,hz,fromOption,hb] at h; subst bs; rfl

structure AgreementEnvironment where
  request : U10.Request

def validateOutput (w : AgreementRaw) (target : Term Nat) : Except String Unit := do
  match sorts (w.base.source++w.output) 0 (w.base.source.length+w.output.length+1) with
  | .error e => .error (e.replace "record.source.sort" "record.output.sort")
  | .ok _ => pure ()
  validateEdges target (w.promise.getD []) "promise"

def admitAgreement (w : AgreementRaw) : Except String AgreementEnvironment :=
  match Record.admit (agreementSource w) with
  | .error e => .error (e.replace "record.observation" "record.question")
  | .ok m => match need (!w.output.isEmpty && w.output.length ≤ sourceLimit) "record.output" "expected a nonempty bounded tree" with
    | .error e => .error e
    | .ok _ => match shape w.output.toArray depthLimit 0 "record.output[0]" with
      | .error e => .error (e.replace "record.source" "record.output")
      | .ok (output,next) =>
        if next != w.output.length then .error "record.output: unreachable node"
        else match validateOutput w output with
        | .error e => .error e
        | .ok _ => match bindings w m.source output with
          | .error e => .error e
          | .ok bs =>
            let q := addresses output []
            .ok ⟨⟨m,⟨output,q,q,w.promise.getD []⟩,bs⟩⟩

structure AgreementDenotes (w : AgreementRaw) (e : AgreementEnvironment) : Prop where
  source : Record.Denotes (agreementSource w) e.request.source
  output : SourceAt w.output.toArray 0 e.request.target.source w.output.length
  question : e.request.source.question = w.question
  promise : e.request.target.edges = w.promise.getD []
  bindings : BindingsDenote w e.request.bindings

theorem admit_agreement_denotes {w : AgreementRaw} {e : AgreementEnvironment}
    (h : admitAgreement w = .ok e) : AgreementDenotes w e := by
  cases hm : Record.admit (agreementSource w) with
  | error err => simp [admitAgreement,hm] at h
  | ok m =>
    cases hn : need (!w.output.isEmpty && w.output.length ≤ sourceLimit) "record.output" "expected a nonempty bounded tree" with
    | error err => simp [admitAgreement,hm,hn] at h
    | ok u =>
      cases ho : shape w.output.toArray depthLimit 0 "record.output[0]" with
      | error err => simp [admitAgreement,hm,hn,ho] at h
      | ok pair =>
        rcases pair with ⟨output,next⟩
        by_cases he : next = w.output.length
        · cases hv : validateOutput w output with
          | error err => simp [admitAgreement,hm,hn,ho,he,hv] at h
          | ok u =>
            cases hb : bindings w m.source output with
            | error err => simp [admitAgreement,hm,hn,ho,he,hv,hb] at h
            | ok bs =>
              simp [admitAgreement,hm,hn,ho,he,hv,hb] at h
              subst e
              exact ⟨Record.admit_denotes hm,he ▸ shape_sound ho,
                (Record.admit_denotes hm).question,rfl,bindings_denote hb⟩
        · simp [admitAgreement,hm,hn,ho,he] at h
end Record.Extended
