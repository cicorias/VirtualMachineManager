import SwiftUI
import Virtualization
import Combine

/// View model for the details of a selected virtual machine
class VMDetailViewModel: ObservableObject {
    @Published var vm: VirtualMachine
    private let vmManager: VMManager
    private var cancellables = Set<AnyCancellable>()
    
    init(vm: VirtualMachine, vmManager: VMManager) {
        self.vm = vm
        self.vmManager = vmManager
        
        // Observe VM status changes
        vm.$status
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    var name: String {
        vm.name
    }
    
    var status: VMStatus {
        vm.status
    }
    
    var statusDisplayName: String {
        vm.status.displayName
    }
    
    var cpuCount: Int {
        vm.configuration.cpuCount
    }
    
    var memorySize: UInt64 {
        vm.configuration.memorySize
    }
    
    var memorySizeGB: Double {
        Double(vm.configuration.memorySize) / Double(1024 * 1024 * 1024)
    }
    
    var diskImagePath: String {
        vm.configuration.diskImagePath
    }
    
    var kernelPath: String? {
        vm.configuration.kernelPath
    }
    
    var ramdiskPath: String? {
        vm.configuration.ramdiskPath
    }
    
    var errorMessage: String? {
        vm.errorMessage
    }
    
    var canStart: Bool {
        vm.status == .stopped || vm.status == .paused
    }
    
    var canStop: Bool {
        vm.status == .running || vm.status == .paused
    }
    
    var canPause: Bool {
        vm.status == .running
    }
    
    var canResume: Bool {
        vm.status == .paused
    }
    
    func startVM() {
        vmManager.startVM(vm)
    }
    
    func stopVM() {
        vmManager.stopVM(vm)
    }
    
    func pauseVM() {
        vmManager.pauseVM(vm)
    }
    
    func resumeVM() {
        vmManager.resumeVM(vm)
    }
    
    func removeVM() {
        vmManager.removeVM(vm)
    }
}
