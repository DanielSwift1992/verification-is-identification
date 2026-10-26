import U7.Words

namespace U7.Examples
open U5

/-- Additional normalized examples, not exports of the Swift reader. -/
def scalar : Model := ⟨.leaf 0, .leaf [], .leaf [], []⟩
def identityAction : Action := ⟨[], .leaf []⟩
def selectSelf : Construction := ⟨[⟨[], [], .address⟩], .leaf []⟩
def scalarCertificate : U7.Certificate :=
  ⟨[⟨0, [[]]⟩], [[]], [⟨[], .preserved []⟩], some
    ⟨[⟨0, [], [], .address⟩], [[]], .leaf [],
      [⟨[], [0], selectSelf⟩], selectSelf⟩⟩

theorem scalar_accepted : U7.check scalar [identityAction] scalarCertificate = true := by decide

def twoSorts : Model := ⟨.pair (.leaf 0) (.leaf 1), .leaf [false],
  .pair (.leaf [false]) (.leaf [true]), []⟩
def identityPair : Action := ⟨[], .pair (.leaf [false]) (.leaf [true])⟩
def selectPair : Construction :=
  ⟨[⟨[false], [false], .address⟩, ⟨[true], [true], .address⟩],
    .pair (.leaf [false]) (.leaf [true])⟩
def pairCertificate : U7.Certificate :=
  ⟨[⟨0, [[false]]⟩, ⟨1, [[true]]⟩], [[], []], [⟨[], .preserved []⟩], some
    ⟨[⟨0, [false], [], .address⟩, ⟨1, [true], [], .address⟩], [[false], [true]],
      .pair (.leaf [false]) (.leaf [true]), [⟨[], [0,1], selectPair⟩], selectPair⟩⟩

theorem pair_accepted : U7.check twoSorts [identityPair] pairCertificate = true := by decide
theorem swapped_sorts_rejected : checkAction twoSorts ⟨[], .pair (.leaf [true]) (.leaf [false])⟩ = false := by decide
theorem incomplete_shape_rejected : checkAction twoSorts ⟨[], .leaf [false]⟩ = false := by decide
theorem absent_origin_rejected : checkAction twoSorts ⟨[], .pair (.leaf [false,false]) (.leaf [true])⟩ = false := by decide
theorem duplicate_members_rejected : U7.check scalar [identityAction, identityAction] scalarCertificate = false := by decide

end U7.Examples
