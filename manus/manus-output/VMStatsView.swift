import SwiftUI
import Virtualization

/// View for displaying VM statistics and monitoring information
struct VMStatsView: View {
    @ObservedObject var viewModel: VMDetailViewModel
    @State private var cpuUsage: Double = 0.0
    @State private var memoryUsage: Double = 0.0
    @State private var refreshTimer: Timer? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("VM Statistics")
                .font(.headline)
            
            Group {
                HStack {
                    Text("Status:")
                    Spacer()
                    HStack {
                        VMStatusIndicatorView(status: viewModel.status)
                        Text(viewModel.statusDisplayName)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("CPU Usage:")
                    ProgressView(value: cpuUsage, total: 100)
                        .progressViewStyle(.linear)
                    Text("\(Int(cpuUsage))% of \(viewModel.cpuCount) cores")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Memory Usage:")
                    ProgressView(value: memoryUsage, total: 100)
                        .progressViewStyle(.linear)
                    Text("\(Int(memoryUsage))% of \(String(format: "%.1f GB", viewModel.memorySizeGB))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Uptime:")
                    Spacer()
                    Text(viewModel.status == .running ? "00:45:12" : "N/A")
                }
                
                HStack {
                    Text("IP Address:")
                    Spacer()
                    Text(viewModel.status == .running ? "192.168.64.2" : "N/A")
                }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Button("Refresh Statistics") {
                refreshStats()
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .onAppear {
            setupRefreshTimer()
            refreshStats()
        }
        .onDisappear {
            refreshTimer?.invalidate()
            refreshTimer = nil
        }
    }
    
    private func setupRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            refreshStats()
        }
    }
    
    private func refreshStats() {
        // In a real implementation, this would get actual VM statistics
        // For this example, we'll simulate some values
        if viewModel.status == .running {
            // Simulate CPU usage between 5% and 80%
            cpuUsage = Double.random(in: 5...80)
            
            // Simulate memory usage between 20% and 70%
            memoryUsage = Double.random(in: 20...70)
        } else {
            cpuUsage = 0
            memoryUsage = 0
        }
    }
}

struct VMStatsView_Previews: PreviewProvider {
    static var previews: some View {
        let vmManager = VMManager()
        let config = VMConfiguration(
            name: "Test VM",
            cpuCount: 4,
            memorySize: 4 * 1024 * 1024 * 1024,
            diskImagePath: "/path/to/disk.img",
            kernelPath: "/path/to/kernel"
        )
        let vm = vmManager.createVM(configuration: config)
        vm.status = .running
        let viewModel = VMDetailViewModel(vm: vm, vmManager: vmManager)
        
        return VMStatsView(viewModel: viewModel)
            .frame(width: 400, height: 400)
    }
}
