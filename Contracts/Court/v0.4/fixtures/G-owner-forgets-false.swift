import VerificationIsIdentification
enum A: PredicateReading { typealias Left = Unit; typealias Right = Unit; typealias Answer = Unit; typealias Sigma = Unit; typealias Encoding = Unit; typealias Predicate = Unit }
enum B: PredicateReading { typealias Left = Never; typealias Right = Unit; typealias Answer = Unit; typealias Sigma = Unit; typealias Encoding = Unit; typealias Predicate = Unit }
enum F: EncodingForgets { typealias Left = A; typealias Right = B; typealias LeftSource = Unit; typealias RightSource = Never; typealias SharedImage = Never; typealias Answer = Unit; typealias Predicate = Unit; typealias Sigma = Unit; typealias Encoding = Unit }
