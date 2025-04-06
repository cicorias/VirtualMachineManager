import Foundation
import Virtualization

/// Represents the status of a virtual machine
enum VMStatus: String, Codable {
    case stopped
    case starting
    case running
    case pausing
    case paused
    case resuming
    case shuttingDown
    case error
    
    var displayName: String {
        switch self {
        case .stopped: return "Stopped"
        case .starting: return "Starting"
        case .running: return "Running"
        case .pausing: return "Pausing"
        case .paused: return "Paused"
        case .resuming: return "Resuming"
        case .shuttingDown: return "Shutting Down"
        case .error: return "Error"
        }
    }
    
    var isActive: Bool {
        switch self {
        case .running, .starting, .pausing, .resuming, .shuttingDown:
            return true
        case .stopped, .paused, .error:
            return false
        }
    }
}

/// Represents a virtual machine configuration
struct VMConfiguration: Codable, Identifiable {
    var id: UUID
    var name: String
    var cpuCount: Int
    var memorySize: UInt64 // in bytes
    var diskImagePath: String
    var kernelPath: String?
    var ramdiskPath: String?
    var isLinux: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        cpuCount: Int = 2,
        memorySize: UInt64 = 2 * 1024 * 1024 * 1024, // 2GB default
        diskImagePath: String,
        kernelPath: String? = nil,
        ramdiskPath: String? = nil,
        isLinux: Bool = true
    ) {
        self.id = id
        self.name = name
        self.cpuCount = cpuCount
        self.memorySize = memorySize
        self.diskImagePath = diskImagePath
        self.kernelPath = kernelPath
        self.ramdiskPath = ramdiskPath
        self.isLinux = isLinux
    }
}

/// Represents a virtual machine with its configuration and runtime state
class VirtualMachine: Identifiable, ObservableObject {
    let id: UUID
    let configuration: VMConfiguration
    
    @Published var status: VMStatus = .stopped
    @Published var vzVirtualMachine: VZVirtualMachine?
    @Published var errorMessage: String?
    
    init(configuration: VMConfiguration) {
        self.id = configuration.id
        self.configuration = configuration
    }
    
    var name: String {
        configuration.name
    }
    
    var diskImageURL: URL {
        URL(fileURLWithPath: configuration.diskImagePath)
    }
    
    var kernelURL: URL? {
        if let path = configuration.kernelPath {
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    var ramdiskURL: URL? {
        if let path = configuration.ramdiskPath {
            return URL(fileURLWithPath: path)
        }
        return nil
    }
}

// Extension for Codable support
extension VirtualMachine: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case configuration
        case status
        case errorMessage
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        configuration = try container.decode(VMConfiguration.self, forKey: .configuration)
        status = try container.decode(VMStatus.self, forKey: .status)
        errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(configuration, forKey: .configuration)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(errorMessage, forKey: .errorMessage)
    }
}
