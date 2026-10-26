import Record.Admission

namespace Record
open U5

/-- Declarative meaning of the flat preorder Source: a sort is the unknown
at this occurrence; a pair's stored child indices delimit its two subtrees. -/
inductive SourceAt (nodes : Array Node) : Nat → Term Nat → Nat → Prop where
  | sort {idx s} : nodes[idx]? = some (.sort s) → SourceAt nodes idx (.leaf s) (idx + 1)
  | pair {idx middle stop l r} :
      nodes[idx]? = some (.pair (idx + 1) middle) →
      SourceAt nodes (idx + 1) l middle → SourceAt nodes middle r stop →
      SourceAt nodes idx (.pair l r) stop

theorem shape_sound {nodes : Array Node} {fuel idx next : Nat} {s : Term Nat} {address : String}
    (h : shape nodes fuel idx address = .ok (s, next)) : SourceAt nodes idx s next := by
  induction fuel generalizing idx next s address with
  | zero => simp [shape] at h
  | succ fuel ih =>
    cases hn : nodes[idx]? with
    | none => simp [shape, hn, fromOption, Bind.bind, Except.bind] at h
    | some n =>
      cases n with
      | sort value =>
        simp [shape, hn, fromOption, Bind.bind, Except.bind, Pure.pure, Except.pure] at h
        obtain ⟨rfl, rfl⟩ := h
        exact .sort hn
      | pair l r =>
        simp only [shape, hn, fromOption, Bind.bind, Except.bind, need] at h
        split at h <;> try contradiction
        rename_i hl
        have hli : l = idx + 1 := by simpa using hl
        subst l
        simp only [Nat.toString_eq_repr] at h
        cases hp : shape nodes fuel (idx + 1) ("record.source[" ++ idx.repr ++ "].pair" ++ "[0]") with
        | error e => simp [hp] at h
        | ok value =>
          obtain ⟨left, middle⟩ := value
          simp only [hp] at h
          split at h <;> try contradiction
          rename_i hr
          have hri : r = middle := by simpa using hr
          subst r
          cases hq : shape nodes fuel middle ("record.source[" ++ idx.repr ++ "].pair" ++ "[1]") with
          | error e => simp [hq] at h
          | ok value =>
            obtain ⟨right, stop⟩ := value
            simp [hq, Pure.pure, Except.pure] at h
            obtain ⟨rfl, rfl⟩ := h
            exact .pair hn (ih hp) (ih hq)

structure Denotes (w : Raw) (m : Model) : Prop where
  source : SourceAt w.source.toArray 0 m.source w.source.length
  observation : m.observation = w.observation
  question : m.question = w.question
  edges : m.edges = w.edges

theorem admit_denotes {w : Raw} {m : Model} (h : admit w = .ok m) : Denotes w m := by
  unfold admit at h
  split at h <;> try contradiction
  split at h <;> try contradiction
  rename_i s next hs
  split at h <;> try contradiction
  rename_i hnext
  split at h <;> try contradiction
  simp only [Except.ok.injEq] at h
  subst m
  have he : next = w.source.length := by simpa using hnext
  exact ⟨he ▸ shape_sound hs, rfl, rfl, rfl⟩

theorem World.denotes (w : World) : Denotes w.val w.model := admit_denotes w.admit_model

end Record
