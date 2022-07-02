import MetalKit
import SwiftUI

class MHWRenderer: MUIRenderer {
    var lastFrameTime: CFTimeInterval? = nil
    var uptime: Double = 0
    
    override func configureRenderPipeline(descriptor: inout MTLRenderPipelineDescriptor, view: MTKView) {
        descriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
    }
    
    override func buildSharedBufferList(in list: inout [MTLBuffer], view: MTKView) {
        let triangle = [
            Vertex(coord: [-1, -1], color: [1, 0, 0, 1]),
            Vertex(coord: [0, 1], color: [0, 1, 0, 1]),
            Vertex(coord: [1, -1], color: [0, 0, 1, 1])
        ]
        list.append(view.device!.makeBuffer( 
            bytes: triangle, length: triangle.count*MemoryLayout<Vertex>.stride)!)
        
        var uniform = Uniform(brightness: 1)
        list.append(view.device!.makeBuffer(
            bytes: &uniform, length: MemoryLayout<Uniform>.stride)!)
    }
    
    override func updateUniformBuffer(in list: inout [MTLBuffer]) {
        let thisFrameTime = CACurrentMediaTime()
        let diffFrameTime = lastFrameTime == nil ? 0 : thisFrameTime-lastFrameTime!
        
        let uniform = list[1].contents().bindMemory(to: Uniform.self, capacity: 1)
        uniform.pointee.brightness = Float(0.5*cos(uptime)+0.5)
        
        lastFrameTime = thisFrameTime
        uptime += diffFrameTime
    }
    
    override func configureRenderPass(descriptor: inout MTLRenderPassDescriptor, view: MTKView) {
        descriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.3, 0.1, 0.2, 1)
    }
    
    override func issueDrawingCommands(encoder: inout MTLRenderCommandEncoder) {
        encoder.setRenderPipelineState(renderPipelineState!)
        encoder.setVertexBuffer(sharedBuffer[0], offset: 0, index: 0)
        encoder.setFragmentBuffer(sharedBuffer[1], offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
    }
}
                        
struct ContentView: View {
    var body: some View {
        CUIView {
            MUIView() { this in
                this.renderer = MHWRenderer()
                this.delegate = this.renderer
            }
        }
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
