import SwiftUI
import Virtualization

/// View for displaying the VM console output
struct VMConsoleView: View {
    @ObservedObject var viewModel: VMDetailViewModel
    @State private var consoleOutput: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Console Output")
                .font(.headline)
                .padding(.bottom, 4)
            
            ScrollView {
                Text(consoleOutput)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.textBackgroundColor))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            HStack {
                Button("Clear") {
                    consoleOutput = ""
                }
                
                Spacer()
                
                Button("Refresh") {
                    refreshConsoleOutput()
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .onAppear {
            setupConsoleCapture()
        }
    }
    
    private func setupConsoleCapture() {
        // In a real implementation, this would capture console output from the VM
        // For this example, we'll just simulate some output
        consoleOutput = "VM Console initialized...\n"
    }
    
    private func refreshConsoleOutput() {
        // In a real implementation, this would refresh the console output from the VM
        // For this example, we'll just append some simulated output
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        consoleOutput.append("[\(timestamp)] VM status: \(viewModel.statusDisplayName)\n")
    }
}

struct VMConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        let vmManager = VMManager()
        let config = VMConfiguration(name: "Test VM", diskImagePath: "/path/to/disk.img", kernelPath: "/path/to/kernel")
        let vm = vmManager.createVM(configuration: config)
        let viewModel = VMDetailViewModel(vm: vm, vmManager: vmManager)
        
        return VMConsoleView(viewModel: viewModel)
            .frame(width: 600, height: 300)
    }
}
