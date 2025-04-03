//
//  ContentView.swift
//  VirtualMachineManager
//
//  Created by Shawn Cicoria on 4/3/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var vms: [VirtualMachine]
    @State private var selectedVM: VirtualMachine?
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationSplitView {
            List(vms, selection: $selectedVM) { vm in
                Label(vm.name, systemImage: "desktopcomputer")
                    .badge(vm.status.badgeText)
            }
            .navigationTitle("Virtual Machines")
        } detail: {
            if let vm = selectedVM {
                VMDetailView(vm: vm)
            } else {
                Text("Select a VM")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            // Insert sample data if no VMs exist
            if vms.isEmpty {
                let vm1 = VirtualMachine(
                    name: "Ubuntu 22.04",
                    status: .running,
                    os: "Ubuntu 22.04",
                    cpu: 2,
                    ram: 4,
                    disk: 64,
                    snapshots: ["Before Update", "Clean Install"]
                )
                let vm2 = VirtualMachine(
                    name: "Windows 11 Dev",
                    status: .stopped,
                    os: "Windows 11",
                    cpu: 4,
                    ram: 8,
                    disk: 128,
                    snapshots: ["Fresh Setup"]
                )
                let vm3 = VirtualMachine(
                    name: "Fedora Test",
                    status: .paused,
                    os: "Fedora 39",
                    cpu: 2,
                    ram: 2,
                    disk: 32,
                    snapshots: []
                )
                modelContext.insert(vm1)
                modelContext.insert(vm2)
                modelContext.insert(vm3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

