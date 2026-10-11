import VerificationIsIdentification

// A prefix may determine a reading even when its remaining votes are not
// identified. This root names the existing readings; it does not grant
// that an omitted physical contact leaves every future question unchanged.
public enum ResidentStoppedReadRoot: Close {
    public typealias Source = ResidentReadingCostRoot
    public typealias Single = Source.Single
    public typealias AnyOne = Source.Triple.AnyOne
    public typealias Majority = Source.Triple.Majority
    public typealias AllOne = Source.Triple.AllOne
}
