import MetalKit
import SwiftUI

public struct MUIView<Content>: UIViewRepresentable where Content: MRTView {
    var mrtView: Content
    
    init(closure: () -> Content) {
        mrtView = closure()
    }
    
    public func makeUIView(context: Context) -> Content {
        return mrtView
    }
    
    public func updateUIView(_ uiView: Content, context: Context) {
    }
}
