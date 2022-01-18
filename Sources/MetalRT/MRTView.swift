import MetalKit

public protocol MRTView: MTKView {
    var renderer: MRTRenderer! { get }
    
    init()
    
    func tune()
    func tuneMTKView()
    func tuneMRTView()
}

public extension MRTView {
    func tune() {
        tuneMTKView()
        tuneMRTView()
    }
}
