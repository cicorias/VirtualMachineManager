import SwiftUI
import Virtualization

/// Service for managing VM operations and lifecycle
class VMOperationManager {
    /// Start a virtual machine and handle the result
    static func startVM(_ vm: VirtualMachine, completion: @escaping (Result<Void, Error>) -> Void) {
        guard vm.status == .stopped || vm.status == .paused else {
            completion(.failure(NSError(domain: "VMOperationManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "VM must be stopped or paused to start"])))
            return
        }
        
        vm.status = .starting
        
        do {
            // Create VM configuration based on the stored settings
            let vzVMConfig = try createVZVirtualMachineConfiguration(for: vm)
            
            // Create the virtual machine
            let vzVM = VZVirtualMachine(configuration: vzVMConfig)
            vm.vzVirtualMachine = vzVM
            
            // Start the virtual machine
            vzVM.start { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        vm.status = .running
                        vm.errorMessage = nil
                        completion(.success(()))
                    case .failure(let error):
                        vm.status = .error
                        vm.errorMessage = error.localizedDescription
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            vm.status = .error
            vm.errorMessage = error.localizedDescription
            completion(.failure(error))
        }
    }
    
    /// Stop a virtual machine and handle the result
    static func stopVM(_ vm: VirtualMachine, completion: @escaping (Result<Void, Error>) -> Void) {
        guard vm.status == .running || vm.status == .paused else {
            completion(.failure(NSError(domain: "VMOperationManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "VM must be running or paused to stop"])))
            return
        }
        
        vm.status = .shuttingDown
        
        guard let vzVM = vm.vzVirtualMachine else {
            vm.status = .stopped
            completion(.success(()))
            return
        }
        
        // Request the VM to stop
        vzVM.stop { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    vm.status = .stopped
                    vm.errorMessage = nil
                    completion(.success(()))
                case .failure(let error):
                    vm.status = .error
                    vm.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Pause a virtual machine and handle the result
    static func pauseVM(_ vm: VirtualMachine, completion: @escaping (Result<Void, Error>) -> Void) {
        guard vm.status == .running else {
            completion(.failure(NSError(domain: "VMOperationManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "VM must be running to pause"])))
            return
        }
        
        vm.status = .pausing
        
        guard let vzVM = vm.vzVirtualMachine else {
            vm.status = .error
            vm.errorMessage = "Virtual machine not initialized"
            completion(.failure(NSError(domain: "VMOperationManager", code: 4, userInfo: [NSLocalizedDescriptionKey: "Virtual machine not initialized"])))
            return
        }
        
        // Pause the VM
        vzVM.pause { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    vm.status = .paused
                    vm.errorMessage = nil
                    completion(.success(()))
                case .failure(let error):
                    vm.status = .error
                    vm.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Resume a paused virtual machine and handle the result
    static func resumeVM(_ vm: VirtualMachine, completion: @escaping (Result<Void, Error>) -> Void) {
        guard vm.status == .paused else {
            completion(.failure(NSError(domain: "VMOperationManager", code: 5, userInfo: [NSLocalizedDescriptionKey: "VM must be paused to resume"])))
            return
        }
        
        vm.status = .resuming
        
        guard let vzVM = vm.vzVirtualMachine else {
            vm.status = .error
            vm.errorMessage = "Virtual machine not initialized"
            completion(.failure(NSError(domain: "VMOperationManager", code: 6, userInfo: [NSLocalizedDescriptionKey: "Virtual machine not initialized"])))
            return
        }
        
        // Resume the VM
        vzVM.resume { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    vm.status = .running
                    vm.errorMessage = nil
                    completion(.success(()))
                case .failure(let error):
                    vm.status = .error
                    vm.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Create a VZVirtualMachineConfiguration for the given VM
    private static func createVZVirtualMachineConfiguration(for vm: VirtualMachine) throws -> VZVirtualMachineConfiguration {
        let config = VZVirtualMachineConfiguration()
        
        // Set CPU and memory
        config.cpuCount = vm.configuration.cpuCount
        config.memorySize = vm.configuration.memorySize
        
        // Configure boot loader
        if vm.configuration.isLinux {
            guard let kernelURL = vm.kernelURL else {
                throw NSError(domain: "VMOperationManager", code: 7, userInfo: [NSLocalizedDescriptionKey: "Kernel path is required for Linux VMs"])
            }
            
            let bootLoader = VZLinuxBootLoader(kernelURL: kernelURL)
            
            // Add ramdisk if available
            if let ramdiskURL = vm.ramdiskURL {
                bootLoader.initialRamdiskURL = ramdiskURL
            }
            
            // Set command line arguments
            bootLoader.commandLine = "console=hvc0"
            
            config.bootLoader = bootLoader
        } else {
            // For macOS VMs (not implemented in this version)
            throw NSError(domain: "VMOperationManager", code: 8, userInfo: [NSLocalizedDescriptionKey: "macOS VMs are not supported in this version"])
        }
        
        // Configure storage
        let diskImageAttachment = try VZDiskImageStorageDeviceAttachment(url: vm.diskImageURL, readOnly: false)
        let storageDevice = VZVirtioBlockDeviceConfiguration(attachment: diskImageAttachment)
        config.storageDevices = [storageDevice]
        
        // Configure network
        let networkDevice = VZVirtioNetworkDeviceConfiguration()
        networkDevice.attachment = VZNATNetworkDeviceAttachment()
        config.networkDevices = [networkDevice]
        
        // Configure graphics (for GUI Linux)
        let graphicsDevice = VZVirtioGraphicsDeviceConfiguration()
        graphicsDevice.scanouts = [
            VZVirtioGraphicsScanoutConfiguration(widthInPixels: 1024, heightInPixels: 768)
        ]
        config.graphicsDevices = [graphicsDevice]
        
        // Configure input devices
        config.keyboards = [VZUSBKeyboardConfiguration()]
        config.pointingDevices = [VZUSBScreenCoordinatePointingDeviceConfiguration()]
        
        // Configure serial console
        let serialPortConfiguration = VZVirtioConsoleDeviceSerialPortConfiguration()
        serialPortConfiguration.attachment = VZFileHandleSerialPortAttachment(
            fileHandleForReading: FileHandle.nullDevice,
            fileHandleForWriting: FileHandle.standardOutput
        )
        config.serialPorts = [serialPortConfiguration]
        
        // Validate configuration
        try config.validate()
        
        return config
    }
}
