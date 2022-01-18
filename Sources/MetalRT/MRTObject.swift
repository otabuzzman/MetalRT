import MetalKit
import ModelIO

public class MRTObject {
    public private(set) var mtkMesh: [MTKMesh]?
    
    public init(wavefront: URL, bufferAllocator: MTKMeshBufferAllocator) {
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
            (_, mtkMesh) = try MTKMesh.newMeshes(asset: mdlAsset, device: bufferAllocator.device)
        } catch {
            mtkMesh = []
        }
    }
}
