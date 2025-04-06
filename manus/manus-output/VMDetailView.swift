import SwiftUI
import Virtualization

/// View for displaying and controlling a virtual machine
struct VMDetailView: View {
    @ObservedObject var viewModel: VMDetailViewModel
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with VM name and status
                HStack {
                    Text(viewModel.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    HStack {
                        VMStatusIndicatorView(status: viewModel.status)
                        Text(viewModel.statusDisplayName)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Error message if any
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // VM Configuration details
                GroupBox(label: Text("Configuration").font(.headline)) {
                    VStack(alignment: .leading, spacing: 10) {
                        DetailRow(label: "CPU Cores", value: "\(viewModel.cpuCount)")
                        DetailRow(label: "Memory", value: String(format: "%.1f GB", viewModel.memorySizeGB))
                        DetailRow(label: "Disk Image", value: viewModel.diskImagePath)
                        if let kernelPath = viewModel.kernelPath {
                            DetailRow(label: "Kernel", value: kernelPath)
                        }
                        if let ramdiskPath = viewModel.ramdiskPath {
                            DetailRow(label: "RAM Disk", value: ramdiskPath)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // VM Controls
                GroupBox(label: Text("Controls").font(.headline)) {
                    HStack(spacing: 16) {
                        Button(action: {
                            viewModel.startVM()
                        }) {
                            Label("Start", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!viewModel.canStart)
                        
                        Button(action: {
                            viewModel.stopVM()
                        }) {
                            Label("Stop", systemImage: "stop.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.canStop)
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            viewModel.pauseVM()
                        }) {
                            Label("Pause", systemImage: "pause.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.canPause)
                        
                        Button(action: {
                            viewModel.resumeVM()
                        }) {
                            Label("Resume", systemImage: "arrow.clockwise")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.canResume)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Label("Delete VM", systemImage: "trash")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 8)
                }
                
                // VM Display (when running)
                if viewModel.status == .running, let vm = viewModel.vm.vzVirtualMachine {
                    GroupBox(label: Text("Display").font(.headline)) {
                        VZVirtualMachineView(virtualMachine: vm)
                            .frame(height: 400)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Virtual Machine"),
                message: Text("Are you sure you want to delete \(viewModel.name)? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.removeVM()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

/// Helper view for displaying a label-value pair
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .frame(width: 100, alignment: .leading)
                .foregroundColor(.secondary)
            
            Text(value)
                .lineLimit(3)
            
            Spacer()
        }
    }
}

struct VMDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let vmManager = VMManager()
        let config = VMConfiguration(
            name: "Ubuntu Server",
            cpuCount: 2,
            memorySize: 2 * 1024 * 1024 * 1024,
            diskImagePath: "/path/to/disk.img",
            kernelPath: "/path/to/kernel",
            ramdiskPath: "/path/to/ramdisk",
            isLinux: true
        )
        let vm = vmManager.createVM(configuration: config)
        let viewModel = VMDetailViewModel(vm: vm, vmManager: vmManager)
        
        return VMDetailView(viewModel: viewModel)
    }
}
