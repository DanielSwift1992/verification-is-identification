import VerificationIsIdentification

public enum ResidentReadingCostRoot: Close {
    public typealias Source = ResidentOrientationWordRoot
    // One actual report is already a reading. Its acquisition cost differs
    // from a three-report threshold; it need not identify the device.
    public typealias Single = Source.Source.Report
    public typealias Triple = Source.Source
}
