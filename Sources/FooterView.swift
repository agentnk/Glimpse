import SwiftUI
import ServiceManagement

struct FooterView: View {
    @Binding var isLaunchAtLoginEnabled: Bool
    @State private var isMenuBarTimerEnabled: Bool = MenuBarTimerManager.shared.isEnabled

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Toggle("Launch at login", isOn: $isLaunchAtLoginEnabled)
                    .toggleStyle(.checkbox)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .onChange(of: isLaunchAtLoginEnabled) { oldValue, newValue in
                        do {
                            if newValue {
                                if SMAppService.mainApp.status != .enabled {
                                    try SMAppService.mainApp.register()
                                }
                            } else {
                                if SMAppService.mainApp.status == .enabled {
                                    try SMAppService.mainApp.unregister()
                                }
                            }
                        } catch {
                            print("Failed to update Launch at login: \(error)")
                            isLaunchAtLoginEnabled = SMAppService.mainApp.status == .enabled
                        }
                    }

                Spacer()

                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Text("Quit Glimpse")
                        .font(.caption)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)

            Divider()

            HStack {
                Toggle("Live menu bar timer", isOn: $isMenuBarTimerEnabled)
                    .toggleStyle(.checkbox)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .onChange(of: isMenuBarTimerEnabled) { _, newValue in
                        MenuBarTimerManager.shared.setEnabled(newValue)
                    }
                Spacer()
                Text("Shows current app & time")
                    .font(.caption2)
                    .foregroundColor(Color.secondary.opacity(0.6))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}
