// The definitions beside aliased.swift: an alias of the world's Owner,
// extended through the alias.

public typealias Other = Owner
extension Other { public typealias Left = Bad }
