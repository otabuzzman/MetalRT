import MetalKit

public class MRTRenderer: NSObject, MTKViewDelegate {
    let mtkView: MTKView
    let device: MTLDevice
    
    public init(mtkView: MTKView, device: MTLDevice) {
        self.mtkView = mtkView
        self.device = device
        
        super.init()
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    public func draw(in view: MTKView) {
    }
}
