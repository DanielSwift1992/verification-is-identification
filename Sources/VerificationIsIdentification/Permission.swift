import Swift

/// A supplied spelling factorization answers its declared admission question
/// with the checked floor. The source and question stay bound. Two passing
/// sources keep their own identities. A grant comes only from the declared
/// vocabulary. [Permission PE4]
public protocol CheckedSpellingAdmission: ReadingFactors
where Answer == Never {}
