# macOS VM Manager App Architecture

## Overview
This document outlines the architecture for a macOS Swift application that allows users to create and manage virtual machines using Apple's Virtualization framework. The app will feature a left-hand navigation panel to display VM status and provide functionality to add new Linux VMs.

## Architecture Pattern: MVVM
The application will follow the Model-View-ViewModel (MVVM) architecture pattern to ensure separation of concerns and maintainability.

### Components

#### Models
- **VirtualMachine**: Core data structure representing a VM with properties like name, status, configuration, etc.
- **VMConfiguration**: Configuration settings for a VM including CPU count, memory size, disk image path, etc.
- **VMStatus**: Enum representing possible VM states (running, stopped, paused, etc.)

#### ViewModels
- **VMListViewModel**: Manages the list of VMs displayed in the sidebar
- **VMDetailViewModel**: Manages the details and operations for a selected VM
- **VMCreationViewModel**: Handles the creation process for new VMs

#### Views
- **MainView**: Root view containing the NavigationSplitView
- **VMListView**: Left sidebar showing all VMs with their status
- **VMDetailView**: Detail view showing selected VM information and controls
- **VMCreationView**: Form for creating new VMs
- **VMStatusIndicatorView**: Visual indicator for VM status

#### Services
- **VMManager**: Core service that interfaces with the Virtualization framework
  - Handles VM lifecycle (create, start, stop, pause, resume, delete)
  - Monitors VM status
  - Manages VM configurations

## Data Flow
1. **VMManager** interfaces with the Virtualization framework to create and manage VMs
2. **ViewModels** observe and control the **VMManager**
3. **Views** bind to **ViewModels** to display data and handle user interactions

## Key Interactions
1. User selects a VM from the sidebar → VMListViewModel updates selected VM → VMDetailViewModel loads details
2. User clicks "Add VM" → VMCreationView is presented → VMCreationViewModel handles form submission → VMManager creates new VM
3. User performs action on VM (start, stop, etc.) → VMDetailViewModel calls VMManager → VMManager updates VM status → UI reflects changes

## Technical Considerations
- Use of Combine framework for reactive programming
- SwiftUI for all UI components
- NavigationSplitView for the main navigation structure
- Proper error handling for VM operations
- Persistence of VM configurations between app launches
