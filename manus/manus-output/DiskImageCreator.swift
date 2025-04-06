import Foundation
import Virtualization
import Combine

/// Service for creating disk images for virtual machines
class DiskImageCreator {
    enum DiskImageError: Error {
        case invalidSize
        case creationFailed(String)
    }
    
    /// Create a new disk image file at the specified path with the given size
    /// - Parameters:
    ///   - path: Path where the disk image should be created
    ///   - sizeGB: Size of the disk image in gigabytes
    /// - Returns: URL of the created disk image
    static func createDiskImage(at path: String, sizeGB: Double) throws -> URL {
        let url = URL(fileURLWithPath: path)
        
        // Validate size
        guard sizeGB > 0 else {
            throw DiskImageError.invalidSize
        }
        
        // Convert GB to bytes
        let sizeInBytes = UInt64(sizeGB * 1024 * 1024 * 1024)
        
        // Create the disk image
        do {
            // Create an empty file
            FileManager.default.createFile(atPath: path, contents: nil)
            
            // Get a file handle
            let fileHandle = try FileHandle(forWritingTo: url)
            
            // Set the file size
            try fileHandle.truncate(atOffset: sizeInBytes)
            try fileHandle.close()
            
            return url
        } catch {
            throw DiskImageError.creationFailed(error.localizedDescription)
        }
    }
}
