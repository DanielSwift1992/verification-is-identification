# Self-showing

The source page and the gallery's code block read the same declared source atom.

```swift
public enum VectorSelfShowingExampleDiagram: Diagram, SelfShowing {
    public typealias Binding = DocumentationBinding
    public typealias Size = VectorExampleCanvasSize
    public typealias AriaLabel = VectorSelfShowingExampleAlt
    public typealias Content = VectorSelfShowingExampleContent
}
```
