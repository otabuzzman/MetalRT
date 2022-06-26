import MetalKit

public protocol MRTRenderer: NSObject, MTKViewDelegate {
    var mtlLibrary: [MTLLibrary]! { get set }
    
    init()
    init(view: MRTView) throws
    
    func makeAccelerationStructure()
    func makeGraphicsPipeline()
    
    func makeFunction(fromMTLLibraries libraries: [MTLLibrary], name: String) -> MTLFunction?
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    func draw(in view: MTKView)
}

public extension MRTRenderer {
    init(view: MRTView) throws {
        self.init()
        
        view.delegate = self
        
        guard let mtlLibrary = view.device?.makeLibrary(fromResourcesWithSuffixes: ["msl"]) else {
            throw MRTError.noShaderSources
        }
        self.mtlLibrary = mtlLibrary
        
        makeAccelerationStructure()
        makeGraphicsPipeline()
        
        mtkView(view, drawableSizeWillChange: view.frame.size)
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
