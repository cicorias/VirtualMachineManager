import SwiftUI
import UniformTypeIdentifiers

/// View for creating a new virtual machine
struct VMCreationView: View {
    @ObservedObject var viewModel: VMCreationViewModel
    @Binding var isPresented: Bool
    
    init(vmManager: VMManager, isPresented: Binding<Bool>) {
        self.viewModel = VMCreationViewModel(vmManager: vmManager)
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("VM Name", text: $viewModel.name)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Hardware Configuration")) {
                    Stepper(value: $viewModel.cpuCount, in: 1...16) {
                        Text("CPU Cores: \(viewModel.cpuCount)")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Memory: \(String(format: "%.1f GB", viewModel.memorySizeGB))")
                        Slider(value: $viewModel.memorySizeGB, in: 0.5...32, step: 0.5)
                    }
                }
                
                Section(header: Text("Storage")) {
                    HStack {
                        Text("Disk Image")
                        Spacer()
                        Button("Select File") {
                            viewModel.showDiskImagePicker = true
                        }
                    }
                    
                    if !viewModel.diskImagePath.isEmpty {
                        Text(viewModel.diskImagePath)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                }
                
                Section(header: Text("Linux Configuration")) {
                    HStack {
                        Text("Kernel")
                        Spacer()
                        Button("Select File") {
                            viewModel.showKernelPicker = true
                        }
                    }
                    
                    if !viewModel.kernelPath.isEmpty {
                        Text(viewModel.kernelPath)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    HStack {
                        Text("RAM Disk (Optional)")
                        Spacer()
                        Button("Select File") {
                            viewModel.showRamdiskPicker = true
                        }
                    }
                    
                    if !viewModel.ramdiskPath.isEmpty {
                        Text(viewModel.ramdiskPath)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Create New VM")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        if viewModel.createVM() {
                            isPresented = false
                        }
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .fileImporter(
                isPresented: $viewModel.showDiskImagePicker,
                allowedContentTypes: [UTType.diskImage, UTType.data],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result, let url = urls.first {
                    viewModel.diskImagePath = url.path
                }
            }
            .fileImporter(
                isPresented: $viewModel.showKernelPicker,
                allowedContentTypes: [UTType.executable, UTType.data],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result, let url = urls.first {
                    viewModel.kernelPath = url.path
                }
            }
            .fileImporter(
                isPresented: $viewModel.showRamdiskPicker,
                allowedContentTypes: [UTType.data],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result, let url = urls.first {
                    viewModel.ramdiskPath = url.path
                }
            }
        }
        .frame(width: 500, height: 600)
    }
}

extension UTType {
    static let diskImage = UTType(filenameExtension: "img")!
}

struct VMCreationView_Previews: PreviewProvider {
    static var previews: some View {
        VMCreationView(vmManager: VMManager(), isPresented: .constant(true))
    }
}
