import SwiftUI

struct CUIView<Content>: UIViewRepresentable where Content: UIView {
    var content: Content
    
    public init(closure: () -> Content) {
        content = closure()
    }
    
    public func makeUIView(context: Context) -> Content {
        return content
    }
    
    public func updateUIView(_ uiView: Content, context: Context) {
    }
}
