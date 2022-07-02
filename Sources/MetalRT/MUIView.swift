import MetalKit
import SwiftUI

class MUIView: MTKView {
    var renderer: MUIRenderer!
    
    init(configure: (MUIView) -> ()) {
        guard
            let device = MTLCreateSystemDefaultDevice()
        else {
            let error: MUIError = .noDefaultDevice
            fatalError(error.localizedDescription)
        }
        super.init(frame: .zero, device: device)
        
        configure(self)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
