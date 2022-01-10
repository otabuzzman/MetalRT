import MetalKit

public class Object {
    var _mtkMesh: MTKMesh? // backed var read-only access pattern
    public var mtkMesh: MTKMesh? { get { return _mtkMesh } }
    
    public init(wavefront: URL?, bufferAllocator: MTKMeshBufferAllocator!) {
        let mtkVertDesc = MTLVertexDescriptor()
        mtkVertDesc.attributes[0].format = .float3
        mtkVertDesc.attributes[0].offset = 0
        mtkVertDesc.attributes[0].bufferIndex = 0
        mtkVertDesc.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
        let mdlVertDesc = MTKModelIOVertexDescriptorFromMetal(mtkVertDesc)
        (mdlVertDesc.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        let mdlAsset = MDLAsset(
            url: wavefront,
            vertexDescriptor: mdlVertDesc,
            bufferAllocator: bufferAllocator)
        let mdlMesh = mdlAsset.object(at: 0) as! MDLMesh
        _mtkMesh = try? MTKMesh(mesh: mdlMesh, device: bufferAllocator.device)
    }
}
