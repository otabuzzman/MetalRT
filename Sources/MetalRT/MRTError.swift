import Foundation

public enum MRTError: Error {
    case noDefaultDevice
    case noShaderSources
}

extension MRTError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noDefaultDevice:
            return NSLocalizedString("no default device", comment: "")
        case .noShaderSources:
            return NSLocalizedString("no shader sources", comment: "")
        }
    }
}
