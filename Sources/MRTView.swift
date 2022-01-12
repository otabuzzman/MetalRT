import MetalKit

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-wrap-a-custom-uiview-for-swiftui

struct MRTView: UIViewRepresentable {
    var mtkView:     MTKView!
    var mrtRenderer: MRTRenderer!
    
    func makeUIView(context: Context) -> MTKView {
        let device = MTLCreateSystemDefaultDevice()!
        
        mtkView                  = MTKView(frame: .zero, device: device)
        mtkView.colorPixelFormat = .bgra8Unorm
        
        mrtRenderer              = MRTRenderer(mtkView: mtkView, device: device)
        mtkView.delegate         = mrtRenderer
        
        return mtkView
    }
    
    func updateUIView(_ uiView: Content, context: Context) {
    }
}

// https://www.hackingwithswift.com/books/ios-swiftui/custom-modifiers

struct MRTLoadScene: ViewModifier {
    var resourceArray: [String]?
    
    func body(content: Content) -> some View {
        content
            .loadScene(fromObjResourceArray resourceArray: [String]?)
    }
}

extension View {
    func loadScene(fromObjResourceArray resourceArray: [String]?) -> some View {
        modifier(MRTLoadScene(resourceArray: resource))
    }
}
