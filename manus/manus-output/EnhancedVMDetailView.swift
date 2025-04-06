import SwiftUI
import Virtualization

/// Enhanced detail view that includes the console view and stats view
struct EnhancedVMDetailView: View {
    @ObservedObject var viewModel: VMDetailViewModel
    @State private var showDeleteConfirmation = false
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            // VM Info summary at the top
            VMInfoView(vm: viewModel.vm)
                .padding(.horizontal)
            
            // Tab selection
            Picker("View", selection: $selectedTab) {
                Text("Overview").tag(0)
                Text("Console").tag(1)
                Text("Statistics").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Tab content
            TabView(selection: $selectedTab) {
                // Overview tab
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
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
                        
                        // Error message if any
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
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
                        
                        // Delete button
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
                    .padding()
                }
                .tag(0)
                
                // Console tab
                VMConsoleView(viewModel: viewModel)
                    .tag(1)
                
                // Statistics tab
                VMStatsView(viewModel: viewModel)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
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

struct EnhancedVMDetailView_Previews: PreviewProvider {
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
        
        return EnhancedVMDetailView(viewModel: viewModel)
    }
}
