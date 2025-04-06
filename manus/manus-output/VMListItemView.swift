import SwiftUI

/// List item view for a virtual machine in the sidebar
struct VMListItemView: View {
    let vm: VirtualMachine
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VMStatusIndicatorView(status: vm.status)
                .padding(.trailing, 4)
            
            Text(vm.name)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .background(isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
        .cornerRadius(4)
    }
}

struct VMListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let config = VMConfiguration(name: "Test VM", diskImagePath: "/path/to/disk.img", kernelPath: "/path/to/kernel")
        let vm = VirtualMachine(configuration: config)
        
        return Group {
            VMListItemView(vm: vm, isSelected: false)
            VMListItemView(vm: vm, isSelected: true)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
