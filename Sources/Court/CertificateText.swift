// Source-reader text enters proof storage through ScalarName. These initializers
// preserve the typed memberwise forms; Codable writes the same JSON strings.

extension Press.Certificate {
    init(version: String, arguments: [String], inputs: [String], readings: [StructuralSource.ReadingCertificate], slot: String, lowerByte: Int, upperByte: Int, candidates: [Press.Candidate], selected: Int?) {
        self.version = version
        self.arguments = arguments.map { ScalarName($0) }
        self.inputs = inputs
        self.readings = readings
        self.slot = ScalarName(slot)
        self.lowerByte = lowerByte
        self.upperByte = upperByte
        self.candidates = candidates
        self.selected = selected
    }
}

extension Press.Candidate {
    init(rule: String, substitution: NameMap<String>, mismatch: [Int]?, bounds: ApplicationCourt.Derivation?) {
        self.rule = ScalarName(rule)
        self.substitution = substitution.mapValues { ScalarName($0) }
        self.mismatch = mismatch
        self.bounds = bounds
    }
}

extension RosterResponse.Axis {
    init(normal: String, derivation: RosterResponse.Reduction, literal: StructuralSource.Literal?) {
        self.normal = ScalarName(normal)
        self.derivation = derivation
        self.literal = literal
    }
}

extension RosterResponse.Row {
    init(name: String, at: StructuralSource.Address, admission: RosterResponse.Admission, axes: NameMap<RosterResponse.Axis>, literal: StructuralSource.Literal?) {
        self.name = ScalarName(name)
        self.at = at
        self.admission = admission
        self.axes = axes
        self.literal = literal
    }
}

extension RosterResponse.Input {
    init(path: String, sha256: String) {
        self.path = ScalarName(path)
        self.sha256 = sha256
    }
}

extension RosterResponse.Report {
    init(schema: String, question: String, reader: String, inputs: [RosterResponse.Input], outcome: String, records: [RosterResponse.Row], diagnostics: [String]) {
        self.schema = schema
        self.question = ScalarName(question)
        self.reader = reader
        self.inputs = inputs
        self.outcome = outcome
        self.records = records
        self.diagnostics = diagnostics
    }
}

extension ContinuationCourt.Certificate {
    init(request: String, constructor: String, source: ContinuationCourt.ReadProof, observation: ContinuationCourt.ReadProof, question: ContinuationCourt.ReadProof, missing: [ContinuationCourt.Missing], program: ContinuationCourt.Program) {
        self.request = ScalarName(request)
        self.constructor = ScalarName(constructor)
        self.source = source
        self.observation = observation
        self.question = question
        self.missing = missing
        self.program = program
    }
}

extension ContinuationCourt.RelatedCertificate {
    init(request: String, constructor: String, source: ContinuationCourt.ReadProof, observation: ContinuationCourt.RouteProof, question: ContinuationCourt.RouteProof, equalities: ContinuationCourt.RouteProof?, conclusion: ContinuationCourt.RelatedConclusion, retention: ContinuationCourt.RelatedRetention? = nil, actions: ContinuationCourt.RouteProof? = nil, hiddenActions: ContinuationCourt.RouteProof? = nil, dynamics: ContinuationCourt.Dynamics? = nil, repetition: ContinuationCourt.Repetition? = nil) {
        self.request = ScalarName(request)
        self.constructor = ScalarName(constructor)
        self.source = source
        self.observation = observation
        self.question = question
        self.equalities = equalities
        self.conclusion = conclusion
        self.retention = retention
        self.actions = actions
        self.hiddenActions = hiddenActions
        self.dynamics = dynamics
        self.repetition = repetition
    }
}

extension ContinuationCourt.PartitionClass {
    init(sort: String, leaves: [ContinuationCourt.Path]) {
        self.sort = ScalarName(sort)
        self.leaves = leaves
    }
}

extension ContinuationCourt.ImageCertificate {
    init(request: String, constructor: String, source: ContinuationCourt.ReadProof, equalities: ContinuationCourt.RouteProof?, image: ContinuationCourt.RouteProof, promise: ContinuationCourt.RouteProof?, hiddenActions: ContinuationCourt.RouteProof?, classes: [ContinuationCourt.PartitionClass], connections: [[ContinuationCourt.EqualityStep]], images: [ContinuationCourt.InducedImage]) {
        self.request = ScalarName(request)
        self.constructor = ScalarName(constructor)
        self.source = source
        self.equalities = equalities
        self.image = image
        self.promise = promise
        self.hiddenActions = hiddenActions
        self.classes = classes
        self.connections = connections
        self.images = images
    }
}

extension ContinuationCourt.AgreementCertificate {
    init(request: String, constructor: String, source: ContinuationCourt.ReadProof, equalities: ContinuationCourt.RouteProof?, output: ContinuationCourt.ReadProof, question: ContinuationCourt.RouteProof, promise: ContinuationCourt.RouteProof?, boundOutputs: ContinuationCourt.RouteProof?, boundSources: ContinuationCourt.RouteProof?, classes: [ContinuationCourt.PartitionClass], connections: [[ContinuationCourt.EqualityStep]], outputClasses: [ContinuationCourt.PartitionClass], outputConnections: [[ContinuationCourt.EqualityStep]], conclusion: ContinuationCourt.AgreementConclusion) {
        self.request = ScalarName(request)
        self.constructor = ScalarName(constructor)
        self.source = source
        self.equalities = equalities
        self.output = output
        self.question = question
        self.promise = promise
        self.boundOutputs = boundOutputs
        self.boundSources = boundSources
        self.classes = classes
        self.connections = connections
        self.outputClasses = outputClasses
        self.outputConnections = outputConnections
        self.conclusion = conclusion
    }
}

extension ContinuationCourt.AgreementCapacity {
    init(sort: String, requiredClasses: Int, outputClasses: Int, fixedRequiredClasses: Int, freeOutputClasses: Int, minimumResidualLeaves: Int) {
        self.sort = ScalarName(sort)
        self.requiredClasses = requiredClasses
        self.outputClasses = outputClasses
        self.fixedRequiredClasses = fixedRequiredClasses
        self.freeOutputClasses = freeOutputClasses
        self.minimumResidualLeaves = minimumResidualLeaves
    }
}

extension ContinuationCourt.LawCoverCertificate {
    init(request: String, constructor: String, source: ContinuationCourt.ReadProof, equalities: ContinuationCourt.RouteProof?, coverage: ContinuationCourt.RouteProof, classes: [ContinuationCourt.PartitionClass], connections: [[ContinuationCourt.EqualityStep]], conclusion: ContinuationCourt.LawCoverConclusion) {
        self.request = ScalarName(request)
        self.constructor = ScalarName(constructor)
        self.source = source
        self.equalities = equalities
        self.coverage = coverage
        self.classes = classes
        self.connections = connections
        self.conclusion = conclusion
    }
}

extension DefinitionReduction.Derivation {
    static func name(_ text: String) -> Self { .name(ScalarName(text)) }
    static func arguments(_ text: String, _ children: [Self]) -> Self { .arguments(ScalarName(text), children) }
    static func field(_ owner: Self, _ text: String) -> Self { .field(owner, ScalarName(text)) }
}

extension StructuralSource.Address {
    init(path: String, line: Int, start: Int, end: Int) {
        self.path = ScalarName(path)
        self.line = line
        self.start = start
        self.end = end
    }
}

extension StructuralSource.Literal {
    init(at: StructuralSource.Address, bytes: String, judged: Bool) {
        self.at = at
        self.bytes = ScalarName(bytes)
        self.judged = judged
    }
}

extension StructuralSource.Token {
    init(word: String, bytes: Range<Int>) {
        self.word = ScalarName(word)
        self.bytes = bytes
    }
}
