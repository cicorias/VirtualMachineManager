import SwiftUI

/// View for the list of virtual machines in the sidebar
struct VMListView: View {
    @ObservedObject var viewModel: VMListViewModel
    @State private var showNewVMSheet = false
    
    var body: some View {
        VStack {
            List(viewModel.virtualMachines, selection: $viewModel.selectedVM) { vm in
                VMListItemView(vm: vm, isSelected: viewModel.selectedVM?.id == vm.id)
                    .tag(vm)
            }
            .listStyle(.sidebar)
            
            Divider()
            
            Button(action: {
                showNewVMSheet = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add VM")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .buttonStyle(.plain)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(6)
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .navigationTitle("Virtual Machines")
        .sheet(isPresented: $showNewVMSheet) {
            VMCreationView(vmManager: viewModel.vmManager, isPresented: $showNewVMSheet)
        }
    }
}

struct VMListView_Previews: PreviewProvider {
    static var previews: some View {
        let vmManager = VMManager()
        let viewModel = VMListViewModel(vmManager: vmManager)
        
        // Add some sample VMs for preview
        let config1 = VMConfiguration(name: "Ubuntu Server", diskImagePath: "/path/to/disk1.img", kernelPath: "/path/to/kernel")
        let config2 = VMConfiguration(name: "Debian", diskImagePath: "/path/to/disk2.img", kernelPath: "/path/to/kernel")
        
        let vm1 = vmManager.createVM(configuration: config1)
        let vm2 = vmManager.createVM(configuration: config2)
        
        vm1.status = .running
        vm2.status = .stopped
        
        return VMListView(viewModel: viewModel)
            .frame(width: 250, height: 400)
    }
}
