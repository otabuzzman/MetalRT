import MetalKit
import SwiftUI

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-wrap-a-custom-uiview-for-swiftui

struct MRTView: UIViewRepresentable {
    var device: MTLDevice!
    var mtkView: MTKView!
    var mrtRenderer: MRTRenderer!
    
    init() {
        device = MTLCreateSystemDefaultDevice()!
        
        mtkView = MTKView(frame: .zero, device: device)
        mtkView.colorPixelFormat = .bgra8Unorm
        
        mrtRenderer = MRTRenderer(mtkView: mtkView, device: device)
        mtkView.delegate = mrtRenderer
    }
    
    func makeUIView(context: Context) -> MTKView {
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
    }
}

