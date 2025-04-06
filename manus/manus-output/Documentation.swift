// MARK: - Project Structure
/*
 VMManagerApp/
 ├── Models/
 │   └── VirtualMachine.swift         // Core VM model with VMStatus enum and VMConfiguration struct
 ├── ViewModels/
 │   ├── VMListViewModel.swift        // ViewModel for the VM list in sidebar
 │   ├── VMDetailViewModel.swift      // ViewModel for VM details and operations
 │   ├── VMCreationViewModel.swift    // Basic ViewModel for VM creation
 │   ├── EnhancedVMCreationViewModel.swift // Extended ViewModel with disk image creation
 │   └── MainViewModel.swift          // ViewModel for main view with notification handling
 ├── Views/
 │   ├── MainView.swift               // Main view with NavigationSplitView
 │   ├── VMListView.swift             // Left sidebar view for VM list
 │   ├── VMListItemView.swift         // Individual VM item in the list
 │   ├── VMDetailView.swift           // Basic VM detail view
 │   ├── EnhancedVMDetailView.swift   // Enhanced VM detail view with tabs
 │   ├── VMCreationView.swift         // Basic VM creation view
 │   ├── EnhancedVMCreationView.swift // Enhanced VM creation with disk image creation
 │   ├── VMConsoleView.swift          // VM console output view
 │   └── VMStatusIndicatorView.swift  // Status indicator for VMs
 ├── Services/
 │   ├── VMManager.swift              // Service for managing collection of VMs
 │   ├── VMOperationManager.swift     // Service for VM lifecycle operations
 │   └── DiskImageCreator.swift       // Service for creating disk images
 ├── Tests/
 │   ├── VMManagerTests.swift         // Tests for VMManager
 │   ├── VMDetailViewModelTests.swift // Tests for VMDetailViewModel
 │   ├── VMCreationViewModelTests.swift // Tests for VMCreationViewModel
 │   ├── VMOperationManagerTests.swift // Tests for VMOperationManager
 │   └── DiskImageCreatorTests.swift  // Tests for DiskImageCreator
 ├── VMManagerApp.swift               // Main app entry point
 └── README.md                        // Project documentation
 */

// MARK: - Implementation Notes
/*
 1. Entitlements:
    - The app requires the com.apple.security.virtualization entitlement
    - Add this to the app's entitlements file in a real Xcode project
 
 2. Dependencies:
    - The app uses the Virtualization framework (import Virtualization)
    - The app uses SwiftUI for the user interface (import SwiftUI)
    - The app uses Combine for reactive programming (import Combine)
 
 3. VM Creation Process:
    - User provides VM name, CPU count, memory size
    - User either selects an existing disk image or creates a new one
    - User provides Linux kernel path and optional ramdisk path
    - The app creates a VM configuration and instantiates a VM
 
 4. VM Management:
    - VMs can be started, stopped, paused, and resumed
    - VM status is displayed in the sidebar with color indicators
    - VM details are shown in the detail view
    - VM console output is available in a separate tab
 
 5. Persistence:
    - VM configurations are saved to disk in JSON format
    - VMs are loaded from disk when the app starts
 
 6. Error Handling:
    - All operations include proper error handling
    - Errors are displayed to the user in the UI
    - Validation is performed before operations
 
 7. Testing:
    - Unit tests cover all key components
    - Tests verify VM creation, management, and validation
 */

// MARK: - Usage Instructions
/*
 1. Building the App:
    - Open the project in Xcode
    - Set the development team in the Signing & Capabilities tab
    - Add the com.apple.security.virtualization entitlement
    - Build and run the app
 
 2. Creating a VM:
    - Click the + button in the toolbar or use Cmd+N
    - Fill in the VM details (name, CPU, memory)
    - Choose to create a new disk image or use an existing one
    - Provide the Linux kernel path and optional ramdisk path
    - Click Create
 
 3. Managing VMs:
    - Select a VM in the sidebar to view its details
    - Use the control buttons to start, stop, pause, or resume the VM
    - View the console output in the Console tab
    - Delete a VM using the Delete button
 
 4. Keyboard Shortcuts:
    - Cmd+N: Create a new VM
    - Cmd+R: Start the selected VM
    - Cmd+.: Stop the selected VM
 */

// MARK: - Additional Features for Future Versions
/*
 1. VM Snapshots:
    - Create and manage VM snapshots
    - Restore VMs from snapshots
 
 2. VM Cloning:
    - Clone existing VMs
    - Customize cloned VMs
 
 3. Network Configuration:
    - Configure network settings for VMs
    - Set up port forwarding
 
 4. Shared Folders:
    - Share folders between host and guest
    - Configure shared folder permissions
 
 5. VM Import/Export:
    - Import VMs from other formats
    - Export VMs for use in other applications
 
 6. macOS VM Support:
    - Create and manage macOS VMs
    - Support for macOS recovery images
 */
