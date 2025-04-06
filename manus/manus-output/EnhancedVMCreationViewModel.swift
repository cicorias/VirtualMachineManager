import SwiftUI
import UniformTypeIdentifiers

/// Enhanced view model for creating a new virtual machine with disk image creation
class EnhancedVMCreationViewModel: VMCreationViewModel {
    @Published var diskSizeGB: Double = 20.0
    @Published var createNewDiskImage: Bool = true
    @Published var diskImageCreationPath: String = ""
    @Published var showDiskImageSavePicker: Bool = false
    @Published var isCreatingDiskImage: Bool = false
    @Published var diskImageCreationProgress: Double = 0.0
    
    override var isFormValid: Bool {
        if createNewDiskImage {
            return !name.isEmpty && 
                   cpuCount >= 1 && 
                   memorySizeGB >= 0.5 && 
                   !diskImageCreationPath.isEmpty && 
                   !kernelPath.isEmpty
        } else {
            return super.isFormValid
        }
    }
    
    /// Create a new disk image and then create the VM
    func createDiskImageAndVM() async -> Bool {
        guard isFormValid else {
            errorMessage = "Please fill in all required fields"
            return false
        }
        
        if createNewDiskImage {
            do {
                isCreatingDiskImage = true
                diskImageCreationProgress = 0.1
                
                // Create the disk image
                let diskImageURL = try await createDiskImage()
                diskImagePath = diskImageURL.path
                diskImageCreationProgress = 1.0
                
                // Create the VM
                let success = createVM()
                isCreatingDiskImage = false
                return success
            } catch {
                isCreatingDiskImage = false
                errorMessage = "Failed to create disk image: \(error.localizedDescription)"
                return false
            }
        } else {
            return createVM()
        }
    }
    
    /// Create a new disk image
    private func createDiskImage() async throws -> URL {
        // Simulate progress updates
        for progress in stride(from: 0.2, to: 0.9, by: 0.1) {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            await MainActor.run {
                diskImageCreationProgress = progress
            }
        }
        
        return try DiskImageCreator.createDiskImage(at: diskImageCreationPath, sizeGB: diskSizeGB)
    }
}
