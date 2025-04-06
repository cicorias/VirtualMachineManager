import SwiftUI
import UniformTypeIdentifiers

/// Enhanced view for creating a new virtual machine with disk image creation
struct EnhancedVMCreationView: View {
    @StateObject var viewModel: EnhancedVMCreationViewModel
    @Binding var isPresented: Bool
    @State private var showingProgressView = false
    
    init(vmManager: VMManager, isPresented: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: EnhancedVMCreationViewModel(vmManager: vmManager))
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
                    Picker("Disk Image", selection: $viewModel.createNewDiskImage) {
                        Text("Create New").tag(true)
                        Text("Use Existing").tag(false)
                    }
                    .pickerStyle(.segmented)
                    
                    if viewModel.createNewDiskImage {
                        VStack(alignment: .leading) {
                            Text("Disk Size: \(String(format: "%.0f GB", viewModel.diskSizeGB))")
                            Slider(value: $viewModel.diskSizeGB, in: 5...100, step: 5)
                        }
                        
                        HStack {
                            Text("Save Location")
                            Spacer()
                            Button("Select") {
                                viewModel.showDiskImageSavePicker = true
                            }
                        }
                        
                        if !viewModel.diskImageCreationPath.isEmpty {
                            Text(viewModel.diskImageCreationPath)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    } else {
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
                        Task {
                            showingProgressView = true
                            if await viewModel.createDiskImageAndVM() {
                                showingProgressView = false
                                isPresented = false
                            } else {
                                showingProgressView = false
                            }
                        }
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isCreatingDiskImage)
                }
            }
            .overlay {
                if showingProgressView {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            if viewModel.createNewDiskImage {
                                Text("Creating disk image...")
                                ProgressView(value: viewModel.diskImageCreationProgress)
                                    .progressViewStyle(.linear)
                                    .frame(width: 200)
                                    .padding()
                            } else {
                                ProgressView()
                                    .padding()
                                Text("Creating VM...")
                            }
                        }
                        .padding()
                        .background(Color(NSColor.windowBackgroundColor))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }
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
            .fileSaver(
                isPresented: $viewModel.showDiskImageSavePicker,
                document: VMDiskImageFile(),
                defaultFilename: "\(viewModel.name).img"
            ) { result in
                if case .success(let url) = result {
                    viewModel.diskImageCreationPath = url.path
                }
            }
        }
        .frame(width: 500, height: 600)
    }
}

/// Document type for saving disk images
struct VMDiskImageFile: FileDocument {
    static var readableContentTypes: [UTType] { [UTType.diskImage, UTType.data] }
    
    init() {}
    
    init(configuration: ReadConfiguration) throws {}
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        // This is just a placeholder - the actual file will be created later
        return FileWrapper(regularFileWithContents: Data())
    }
}

struct EnhancedVMCreationView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedVMCreationView(vmManager: VMManager(), isPresented: .constant(true))
    }
}
