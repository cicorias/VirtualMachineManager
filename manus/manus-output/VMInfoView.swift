import SwiftUI
import Virtualization

/// Helper extension for file size formatting
extension UInt64 {
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(self))
    }
}

/// Helper view for VM information display
struct VMInfoView: View {
    let vm: VirtualMachine
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "desktopcomputer")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                
                VStack(alignment: .leading) {
                    Text(vm.name)
                        .font(.headline)
                    
                    HStack {
                        VMStatusIndicatorView(status: vm.status)
                        Text(vm.status.displayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Divider()
            
            Group {
                InfoRow(label: "CPU Cores", value: "\(vm.configuration.cpuCount)")
                InfoRow(label: "Memory", value: vm.configuration.memorySize.formattedSize)
                InfoRow(label: "OS Type", value: vm.configuration.isLinux ? "Linux" : "macOS")
            }
        }
        .padding()
        .background(Color(.textBackgroundColor).opacity(0.5))
        .cornerRadius(8)
    }
}

/// Helper view for displaying info rows
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .bold()
            Spacer()
        }
        .font(.system(.body, design: .rounded))
    }
}

struct VMInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let config = VMConfiguration(
            name: "Ubuntu Server",
            cpuCount: 4,
            memorySize: 4 * 1024 * 1024 * 1024,
            diskImagePath: "/path/to/disk.img",
            kernelPath: "/path/to/kernel"
        )
        let vm = VirtualMachine(configuration: config)
        vm.status = .running
        
        return VMInfoView(vm: vm)
            .frame(width: 350)
            .padding()
    }
}
