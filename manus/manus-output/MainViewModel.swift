import Foundation

/// Extension to provide notification names for VM operations
extension Notification.Name {
    static let createNewVM = Notification.Name("CreateNewVM")
    static let startVM = Notification.Name("StartVM")
    static let stopVM = Notification.Name("StopVM")
    static let pauseVM = Notification.Name("PauseVM")
    static let resumeVM = Notification.Name("ResumeVM")
}

/// Enhanced MainView with notification handling for menu commands
class MainViewModel: ObservableObject {
    @Published var vmManager = VMManager()
    @Published var showNewVMSheet = false
    
    init() {
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            forName: .createNewVM,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.showNewVMSheet = true
        }
        
        NotificationCenter.default.addObserver(
            forName: .startVM,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            if let vm = self?.vmManager.selectedVM, vm.status == .stopped || vm.status == .paused {
                self?.vmManager.startVM(vm)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: .stopVM,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            if let vm = self?.vmManager.selectedVM, vm.status == .running || vm.status == .paused {
                self?.vmManager.stopVM(vm)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: .pauseVM,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            if let vm = self?.vmManager.selectedVM, vm.status == .running {
                self?.vmManager.pauseVM(vm)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: .resumeVM,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            if let vm = self?.vmManager.selectedVM, vm.status == .paused {
                self?.vmManager.resumeVM(vm)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
