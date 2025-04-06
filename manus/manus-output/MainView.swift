import SwiftUI

/// Main view for the application using NavigationSplitView
struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar column with VM list
            List(viewModel.vmManager.virtualMachines, selection: $viewModel.vmManager.selectedVM) { vm in
                VMListItemView(vm: vm, isSelected: viewModel.vmManager.selectedVM?.id == vm.id)
                    .tag(vm)
            }
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.showNewVMSheet = true
                    }) {
                        Label("Add VM", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Virtual Machines")
        } detail: {
            // Detail column with VM details or placeholder
            if let selectedVM = viewModel.vmManager.selectedVM {
                EnhancedVMDetailView(viewModel: VMDetailViewModel(vm: selectedVM, vmManager: viewModel.vmManager))
            } else {
                ContentUnavailableView(
                    "No Virtual Machine Selected",
                    systemImage: "desktopcomputer",
                    description: Text("Select a virtual machine from the sidebar or create a new one.")
                )
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $viewModel.showNewVMSheet) {
            EnhancedVMCreationView(vmManager: viewModel.vmManager, isPresented: $viewModel.showNewVMSheet)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
