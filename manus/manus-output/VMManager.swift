import Foundation
import Virtualization
import Combine

/// Service responsible for managing virtual machines
class VMManager: ObservableObject {
    @Published var virtualMachines: [VirtualMachine] = []
    @Published var selectedVM: VirtualMachine?
    
    private var cancellables = Set<AnyCancellable>()
    private let fileManager = FileManager.default
    private let saveURL: URL
    
    init() {
        // Create directory for storing VM data if it doesn't exist
        let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectoryURL = applicationSupportURL.appendingPathComponent("VMManager", isDirectory: true)
        
        if !fileManager.fileExists(atPath: appDirectoryURL.path) {
            try? fileManager.createDirectory(at: appDirectoryURL, withIntermediateDirectories: true)
        }
        
        saveURL = appDirectoryURL.appendingPathComponent("vms.json")
        
        // Load saved VMs
        loadVirtualMachines()
    }
    
    // MARK: - VM Management
    
    /// Create a new virtual machine with the given configuration
    func createVM(configuration: VMConfiguration) -> VirtualMachine {
        let vm = VirtualMachine(configuration: configuration)
        virtualMachines.append(vm)
        saveVirtualMachines()
        return vm
    }
    
    /// Remove a virtual machine
    func removeVM(_ vm: VirtualMachine) {
        if vm.status != .stopped {
            stopVM(vm)
        }
        
        if let index = virtualMachines.firstIndex(where: { $0.id == vm.id }) {
            virtualMachines.remove(at: index)
            
            if selectedVM?.id == vm.id {
                selectedVM = nil
            }
            
            saveVirtualMachines()
        }
    }
    
    /// Start a virtual machine
    func startVM(_ vm: VirtualMachine) {
        VMOperationManager.startVM(vm) { result in
            switch result {
            case .success:
                print("VM started successfully")
                self.saveVirtualMachines()
            case .failure(let error):
                print("Failed to start VM: \(error.localizedDescription)")
            }
        }
    }
    
    /// Stop a virtual machine
    func stopVM(_ vm: VirtualMachine) {
        VMOperationManager.stopVM(vm) { result in
            switch result {
            case .success:
                print("VM stopped successfully")
                self.saveVirtualMachines()
            case .failure(let error):
                print("Failed to stop VM: \(error.localizedDescription)")
            }
        }
    }
    
    /// Pause a virtual machine
    func pauseVM(_ vm: VirtualMachine) {
        VMOperationManager.pauseVM(vm) { result in
            switch result {
            case .success:
                print("VM paused successfully")
                self.saveVirtualMachines()
            case .failure(let error):
                print("Failed to pause VM: \(error.localizedDescription)")
            }
        }
    }
    
    /// Resume a paused virtual machine
    func resumeVM(_ vm: VirtualMachine) {
        VMOperationManager.resumeVM(vm) { result in
            switch result {
            case .success:
                print("VM resumed successfully")
                self.saveVirtualMachines()
            case .failure(let error):
                print("Failed to resume VM: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Persistence
    
    /// Save virtual machines to disk
    private func saveVirtualMachines() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(virtualMachines)
            try data.write(to: saveURL)
        } catch {
            print("Failed to save virtual machines: \(error.localizedDescription)")
        }
    }
    
    /// Load virtual machines from disk
    private func loadVirtualMachines() {
        guard fileManager.fileExists(atPath: saveURL.path) else { return }
        
        do {
            let data = try Data(contentsOf: saveURL)
            let decoder = JSONDecoder()
            virtualMachines = try decoder.decode([VirtualMachine].self, from: data)
        } catch {
            print("Failed to load virtual machines: \(error.localizedDescription)")
        }
    }
}
