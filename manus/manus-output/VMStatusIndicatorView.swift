import SwiftUI
import Virtualization

/// Status indicator view for virtual machines
struct VMStatusIndicatorView: View {
    let status: VMStatus
    
    var body: some View {
        Circle()
            .fill(statusColor)
            .frame(width: 10, height: 10)
            .overlay(
                Circle()
                    .stroke(Color.gray, lineWidth: 0.5)
            )
            .shadow(radius: 1)
    }
    
    private var statusColor: Color {
        switch status {
        case .running:
            return Color.green
        case .starting, .pausing, .resuming, .shuttingDown:
            return Color.yellow
        case .paused:
            return Color.orange
        case .stopped:
            return Color.gray
        case .error:
            return Color.red
        }
    }
}

struct VMStatusIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            ForEach([VMStatus.running, .starting, .paused, .stopped, .error], id: \.self) { status in
                HStack {
                    VMStatusIndicatorView(status: status)
                    Text(status.displayName)
                }
            }
        }
        .padding()
    }
}
