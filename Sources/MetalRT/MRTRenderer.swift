import MetalKit

public protocol MRTRenderer: NSObject, MTKViewDelegate {
    var mtlLibrary: [MTLLibrary]! { get set }
    
    init()
    init(view: MRTView, device: MTLDevice) throws
    
    func makeAccelerationStructure()
    func makePipelineState()
    func makeCommandQueue()
    
    func makeFunction(fromMTLLibraries libraries: [MTLLibrary], name: String) -> MTLFunction?
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    func draw(in view: MTKView)
}

public extension MRTRenderer {
    init(view: MRTView, device: MTLDevice) throws {
        self.init()
        
        view.delegate = self
        
        guard let mtlLibrary = device.makeLibrary(fromResourcesWithSuffixes: ["msl"]) else {
            throw MRTError.noShaderSources
        }
        self.mtlLibrary = mtlLibrary
    }
    
    func makeFunction(fromMTLLibraries libraries: [MTLLibrary], name: String) -> MTLFunction? {
        for mtlLibrary in libraries {
            if mtlLibrary.functionNames.contains(name) {
                return mtlLibrary.makeFunction(name: name)
            }
        }
        
        return nil
    }
}
