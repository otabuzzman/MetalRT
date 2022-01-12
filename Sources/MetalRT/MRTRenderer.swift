import MetalKit

class MRTRenderer: NSObject, MTKViewDelegate {
    let mtkView: MTKView
    let device: MTLDevice
    
    init(mtkView: MTKView, device: MTLDevice) {
        self.mtkView = mtkView
        self.device = device
        
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
    }
}
