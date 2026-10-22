import Notation
import DocumentKit

// GENERATED from the world drawing-binding/1 record.
// drawing-binding-value-sha256: 8fbfb9a007ebe952dd731ede7ab6f80fec1d35cf19810265007e83ef29fd13ad
public enum FixtureBindingTextSecondary: Paint, Close {}
extension FixtureBindingTextSecondary {
    public static var typeName: String { "currentColor" }
}
public enum FixtureBindingTextSecondaryDark: Paint, Close {}
extension FixtureBindingTextSecondaryDark {
    public static var typeName: String { "currentColor" }
}
public enum FixtureBindingAccentRole: Paint, Close {}
extension FixtureBindingAccentRole {
    public static var typeName: String { "currentColor" }
}
public enum FixtureBindingAccentRoleDark: Paint, Close {}
extension FixtureBindingAccentRoleDark {
    public static var typeName: String { "currentColor" }
}
public enum FixtureBindingTextPrimary: Paint, Close {}
extension FixtureBindingTextPrimary {
    public static var typeName: String { "#5A347D" }
}
public enum FixtureBindingTextPrimaryDark: Paint, Close {}
extension FixtureBindingTextPrimaryDark {
    public static var typeName: String { "#E7DDF2" }
}
public enum FixtureBindingBodyFace: Close {}
extension FixtureBindingBodyFace {
    public static var typeName: String { "Inter" }
}
public enum FixtureBindingCaptionFace: Close {}
extension FixtureBindingCaptionFace {
    public static var typeName: String { "Inter" }
}
public enum FixtureBindingShadowPaint: Paint, Close {}
extension FixtureBindingShadowPaint {
    public static var typeName: String { "currentColor" }
}
public enum FixtureBindingShadowOpacity: Close {}
extension FixtureBindingShadowOpacity {
    public static var typeName: String { "0" }
}
public enum FixtureBindingLeafCountBases: Close {}
extension FixtureBindingLeafCountBases {
    public static var typeName: String { "Structure Close Open Pair" }
}
public enum FixtureBinding: DrawingStyle, Close {
    public typealias TextSecondary = FixtureBindingTextSecondary
    public typealias AccentRole = FixtureBindingAccentRole
    public typealias TextPrimary = FixtureBindingTextPrimary
    public typealias BodyFace = FixtureBindingBodyFace
    public typealias CaptionFace = FixtureBindingCaptionFace
    public typealias ShadowPaint = FixtureBindingShadowPaint
    public typealias ShadowOpacity = FixtureBindingShadowOpacity
    public typealias LeafCountBases = FixtureBindingLeafCountBases
}
