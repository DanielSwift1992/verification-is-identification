// The Solvability Criterion. Historical interface intersections are retained.
// E2 states their semantic obligations for one anchored-search architecture.
// A conformance alone supplies neither a solver nor model adequacy.

/// Names representation, uniqueness and geometric interfaces together.
/// C1–C5 distinguish actual witnesses for representability, identification,
/// access and bounded checking. C3 is optional representative economy.
/// This intersection does not encode all of those witnesses. [Spec §1]
public protocol EncoderConditions: HasEncoding, ExactlyOneSurvives, CompressionCriterion, BallSaturation {}

/// E2.1 derives the result under adequate identification and actual bounded
/// search premises. Safety is relative to the checked relation and its
/// interpretation. This declaration alone is not an executable proof of
/// coverage, termination or behavior on undeclared tasks. [Spec E2.1]
public protocol ConditionalSolving: EncoderConditions, PassIsIdentification {}

/// Legacy name for a scoped solving interface. E2.4–E2.5 reject the stronger
/// claim that all difficulty belongs to the encoder or that every solver
/// must use positive-radius routing. Exact generic applications also reuse
/// knowledge across new inputs. [Spec E2.3–E2.5]
public protocol DifficultyIsEncoder: ConditionalSolving, ScopeBoundedByEncoding {}

/// Collects geometric interfaces for a chosen search design. A complete
/// finite declaration permits checking specified properties on that domain.
/// Sampled measurements do not certify unobserved tasks or make geometric
/// compression a necessary condition for intelligence. [Spec §4]
public protocol MeasuredGeometry: SearchableIffClusteredAndAligned, FourthFace {}
