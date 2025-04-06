import SwiftUI
import Virtualization
import Combine

/// View model for creating a new virtual machine
class VMCreationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var cpuCount: Int = 2
    @Published var memorySizeGB: Double = 2.0
    @Published var diskImagePath: String = ""
    @Published var kernelPath: String = ""
    @Published var ramdiskPath: String = ""
    
    @Published var showDiskImagePicker: Bool = false
    @Published var showKernelPicker: Bool = false
    @Published var showRamdiskPicker: Bool = false
    
    @Published var errorMessage: String?
    
    private let vmManager: VMManager
    
    init(vmManager: VMManager) {
        self.vmManager = vmManager
    }
    
    var isFormValid: Bool {
        !name.isEmpty && 
        cpuCount >= 1 && 
        memorySizeGB >= 0.5 && 
        !diskImagePath.isEmpty && 
        !kernelPath.isEmpty
    }
    
    var memorySizeBytes: UInt64 {
        UInt64(memorySizeGB * Double(1024 * 1024 * 1024))
    }
    
    func createVM() -> Bool {
        guard isFormValid else {
            errorMessage = "Please fill in all required fields"
            return false
        }
        
        let config = VMConfiguration(
            name: name,
            cpuCount: cpuCount,
            memorySize: memorySizeBytes,
            diskImagePath: diskImagePath,
            kernelPath: kernelPath,
            ramdiskPath: ramdiskPath.isEmpty ? nil : ramdiskPath,
            isLinux: true
        )
        
        let vm = vmManager.createVM(configuration: config)
        vmManager.selectedVM = vm
        
        return true
    }
    
    func reset() {
        name = ""
        cpuCount = 2
        memorySizeGB = 2.0
        diskImagePath = ""
        kernelPath = ""
        ramdiskPath = ""
        errorMessage = nil
    }
}
