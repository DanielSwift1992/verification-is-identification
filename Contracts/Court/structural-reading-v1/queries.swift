protocol Counting {}
extension Never: Counting {}
enum Tick<Previous: Counting>: Counting {}
enum LampOff {}
enum Witness: Counting {}
protocol CandidateLeafReading {}
enum Atom {}
enum CandidateList { typealias Left = Atom; typealias Right = Never }
enum Covered: CandidateLeafReading {
  typealias Candidates = CandidateList
  typealias Left = Atom
  typealias Right = Atom
  typealias Answer = Atom
}
enum Identity<S: Structure> {
  typealias Source = S
  typealias Observation = Source
  typealias Question = Source
}
