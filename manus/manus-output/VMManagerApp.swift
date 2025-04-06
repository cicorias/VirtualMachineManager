import SwiftUI

/// Main application entry point
@main
struct VMManagerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .frame(minWidth: 900, minHeight: 600)
                .onAppear {
                    // Set the app name in the title bar
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .commands {
            // Add custom menu commands
            CommandGroup(replacing: .newItem) {
                Button("New Virtual Machine") {
                    NotificationCenter.default.post(name: Notification.Name("CreateNewVM"), object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            
            CommandMenu("Virtual Machine") {
                Button("Start") {
                    NotificationCenter.default.post(name: Notification.Name("StartVM"), object: nil)
                }
                .keyboardShortcut("r", modifiers: .command)
                
                Button("Stop") {
                    NotificationCenter.default.post(name: Notification.Name("StopVM"), object: nil)
                }
                .keyboardShortcut(".", modifiers: .command)
                
                Divider()
                
                Button("Pause") {
                    NotificationCenter.default.post(name: Notification.Name("PauseVM"), object: nil)
                }
                
                Button("Resume") {
                    NotificationCenter.default.post(name: Notification.Name("ResumeVM"), object: nil)
                }
            }
        }
    }
}
