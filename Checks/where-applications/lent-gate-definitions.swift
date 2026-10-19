// The definitions beside lent-gate.swift: a gated head and its gate.

public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
