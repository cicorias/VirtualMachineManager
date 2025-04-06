# macOS VM Manager App

[https://manus.im/share/VKtwbhPEy25sgpvScKamGY?replay=1](https://manus.im/share/VKtwbhPEy25sgpvScKamGY?replay=1)

A Swift application for creating and managing virtual machines on macOS using Apple's Virtualization framework. The app features a left-hand navigation panel to view VM status and provides functionality to create and manage Linux virtual machines.

## Features

- Create and manage Linux virtual machines
- Monitor VM status through the left-hand navigation panel
- Start, stop, pause, and resume virtual machines
- Create and configure disk images for VMs
- View VM console output
- Comprehensive VM configuration options

## Requirements

- macOS 13.0 or later
- Xcode 14.0 or later
- Swift 5.7 or later
- Apple Silicon Mac or Intel Mac with virtualization support

## Architecture

The application follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Core data structures representing VMs and their configurations
- **ViewModels**: Business logic for managing VM state and operations
- **Views**: SwiftUI interface components
- **Services**: Core services for VM operations and disk image creation

## Key Components

### Models
- `VirtualMachine`: Core model representing a VM with its configuration and runtime state
- `VMConfiguration`: Configuration settings for a VM
- `VMStatus`: Enum representing possible VM states

### ViewModels
- `VMListViewModel`: Manages the list of VMs displayed in the sidebar
- `VMDetailViewModel`: Manages the details and operations for a selected VM
- `VMCreationViewModel`: Handles the creation process for new VMs

### Views
- `MainView`: Root view containing the NavigationSplitView
- `VMListView`: Left sidebar showing all VMs with their status
- `VMDetailView`: Detail view showing selected VM information and controls
- `VMCreationView`: Form for creating new VMs
- `VMConsoleView`: View for displaying VM console output

### Services
- `VMManager`: Core service that manages the collection of VMs
- `VMOperationManager`: Handles VM lifecycle operations
- `DiskImageCreator`: Service for creating disk images

## Usage

1. Launch the application
2. Click the "+" button in the toolbar or use Cmd+N to create a new VM
3. Configure the VM settings including name, CPU cores, memory, disk image, and kernel
4. Select a VM from the sidebar to view its details
5. Use the control buttons to start, stop, pause, or resume the VM
6. View the console output in the Console tab

## Implementation Notes

- The app uses SwiftUI's NavigationSplitView for the main interface
- VM state is persisted between app launches
- The app supports creating new disk images or using existing ones
- Error handling is implemented throughout the application
- The Virtualization framework is used to create and manage VMs

## Limitations

- Currently only supports Linux VMs
- Requires kernel and optional ramdisk files to be provided
- Some features may require elevated permissions

## Future Enhancements

- Support for macOS virtual machines
- VM snapshots and cloning
- Network configuration options
- Shared folders between host and guest
- VM import/export functionality
