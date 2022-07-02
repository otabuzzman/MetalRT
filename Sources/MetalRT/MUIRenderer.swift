import MetalKit
import SwiftUI

class MUIRenderer: NSObject, MTKViewDelegate {
    var commandQueue: MTLCommandQueue?
    var sharedBuffer = [MTLBuffer]()
    var renderPipelineState: MTLRenderPipelineState?
    
    let framesInFlightSignal: DispatchSemaphore
    
    let vertexFunctionName: String
    let fragmentFunctionName: String
    
    init(framesInFlightNumber: Int = 1, vertexFunctionName: String = "vertexFunction", fragmentFunctionName: String = "fragmentFunction") {
        framesInFlightSignal = DispatchSemaphore(value: framesInFlightNumber)
        
        self.vertexFunctionName = vertexFunctionName
        self.fragmentFunctionName = fragmentFunctionName
    }
    
    final func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        commandQueue = view.device!.makeCommandQueue()
        
        guard
            let mtlLibrary = view.device?.makeLibrary(fromResourcesWithSuffixes: ["msl"])
        else { return }
        let vertexFunction = MUIRenderer.makeFunction(
            fromMTLLibraries: mtlLibrary, name: vertexFunctionName)
        let fragmentFunction = MUIRenderer.makeFunction(
            fromMTLLibraries: mtlLibrary, name: fragmentFunctionName)
        
        var renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        configureRenderPipeline(descriptor: &renderPipelineDescriptor, view: view)
        
        renderPipelineState = try? view.device!.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        
        buildSharedBufferList(in: &sharedBuffer, view: view)
    }
    
    final func draw(in view: MTKView) {
        framesInFlightSignal.wait()
        
        updateUniformBuffer(in: &sharedBuffer)
        
        guard
            let commandBuffer = commandQueue?.makeCommandBuffer(),
            var renderPassDescriptor = view.currentRenderPassDescriptor
        else { return }
        
        configureRenderPass(descriptor: &renderPassDescriptor, view: view)
        
        guard
            var renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }
        
        issueDrawingCommands(encoder: &renderEncoder)
        renderEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.addCompletedHandler { _ in
            self.framesInFlightSignal.signal()
        }
        commandBuffer.commit()
    }
    
    func configureRenderPipeline(descriptor: inout MTLRenderPipelineDescriptor, view: MTKView) {}
    func buildSharedBufferList(in list: inout [MTLBuffer], view: MTKView) {}
    func updateUniformBuffer(in list: inout [MTLBuffer]) {}
    func configureRenderPass(descriptor: inout MTLRenderPassDescriptor, view: MTKView) {}
    func issueDrawingCommands(encoder: inout MTLRenderCommandEncoder) {}
    
    private static func makeFunction(fromMTLLibraries libraries: [MTLLibrary], name: String) -> MTLFunction? {
        for mtlLibrary in libraries {
            if mtlLibrary.functionNames.contains(name) {
                return mtlLibrary.makeFunction(name: name)
            }
        }
        
        return nil
    }
}
