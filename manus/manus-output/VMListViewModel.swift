import SwiftUI
import Virtualization
import Combine

/// View model for the list of virtual machines
class VMListViewModel: ObservableObject {
    @Published var vmManager: VMManager
    
    init(vmManager: VMManager) {
        self.vmManager = vmManager
    }
    
    var virtualMachines: [VirtualMachine] {
        vmManager.virtualMachines
    }
    
    var selectedVM: VirtualMachine? {
        get { vmManager.selectedVM }
        set { vmManager.selectedVM = newValue }
    }
    
    func selectVM(_ vm: VirtualMachine) {
        vmManager.selectedVM = vm
    }
    
    func createNewVM(name: String, cpuCount: Int, memorySize: UInt64, diskImagePath: String, kernelPath: String?, ramdiskPath: String?) {
        let config = VMConfiguration(
            name: name,
            cpuCount: cpuCount,
            memorySize: memorySize,
            diskImagePath: diskImagePath,
            kernelPath: kernelPath,
            ramdiskPath: ramdiskPath,
            isLinux: true
        )
        
        let vm = vmManager.createVM(configuration: config)
        selectVM(vm)
    }
    
    func removeVM(_ vm: VirtualMachine) {
        vmManager.removeVM(vm)
    }
}
