import MetalKit
import ModelIO

public class Object {
    var _mtkMesh: [MTKMesh]? // backed var read-only access pattern
    public var mtkMesh: [MTKMesh]? { get { return _mtkMesh } }
    
    public init(wavefront: URL?, bufferAllocator: MTKMeshBufferAllocator!) {
        let mdlVertDesc = MDLVertexDescriptor()
        mdlVertDesc.attributes[0] = MDLVertexAttribute(
            name: MDLVertexAttributePosition,
            format: .float3,
            offset: 0,
            bufferIndex: 0)
        mdlVertDesc.layouts[0] = MDLVertexBufferLayout(stride: MemoryLayout<SIMD3<Float>>.stride)
        let mdlAsset = MDLAsset(
            url: wavefront,
            vertexDescriptor: mdlVertDesc,
            bufferAllocator: bufferAllocator)
        do {
            // discard MDLMesh from returned tuple
            (_, _mtkMesh) = try MTKMesh.newMeshes(asset: mdlAsset, device: bufferAllocator.device)
        } catch {
            _mtkMesh = []
        }
    }
}
