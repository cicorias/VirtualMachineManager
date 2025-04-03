//
//  VMDetail.swift
//  VirtualMachineManager
//
//  Created by Shawn Cicoria on 4/3/25.
//


import SwiftUI

struct VMDetailView: View {
    let vm: VirtualMachine
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(vm.name)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button("Start") { /* Start VM logic */ }
                Button("Stop") { /* Stop VM logic */ }
                Button("Snapshot") { /* Snapshot logic */ }
            }
            
            Divider()
            
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 10) {
                GridRow {
                    Text("OS:")
                    Text(vm.os)
                }
                GridRow {
                    Text("CPU:")
                    Text("\(vm.cpu) cores")
                }
                GridRow {
                    Text("RAM:")
                    Text("\(vm.ram) GB")
                }
                GridRow {
                    Text("Disk:")
                    Text("\(vm.disk) GB")
                }
            }
            .font(.system(.body, design: .monospaced))
            
            if !vm.snapshots.isEmpty {
                Text("Snapshots:")
                    .font(.headline)
                ForEach(vm.snapshots, id: \.self) { snapshot in
                    Label(snapshot, systemImage: "camera.on.rectangle")
                }
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.2))
                .overlay(Text("Console preview here").foregroundColor(.gray))
                .frame(height: 200)
        }
        .padding()
    }
}

struct VMDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with a sample VirtualMachine instance
        let sampleVM = VirtualMachine(
            name: "Ubuntu 22.04",
            status: .running,
            os: "Ubuntu 22.04",
            cpu: 2,
            ram: 4,
            disk: 64,
            snapshots: ["Before Update", "Clean Install"]
        )
        return VMDetailView(vm: sampleVM)
    }
}
