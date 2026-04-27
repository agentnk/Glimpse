import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var usageManager = UsageManager.shared

    // MARK: - General
    @State private var isLaunchAtLoginEnabled: Bool = SMAppService.mainApp.status == .enabled

    // MARK: - Tracking
    @State private var idleThresholdMinutes: Int = {
        let stored = UserDefaults.standard.integer(forKey: IdleDetector.thresholdKey)
        return stored > 0 ? stored / 60 : 3
    }()
    private let idleOptions: [Int] = [1, 2, 3, 5, 10]

    // MARK: - Menu Bar
    @State private var isMenuBarTimerEnabled: Bool = MenuBarTimerManager.shared.isEnabled

    // MARK: - Alerts
    @State private var showClearTodayAlert  = false
    @State private var showClearAllAlert    = false

    // MARK: - Version
    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ────────────────────────────────────────────────
            HStack {
                Text("Settings")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(NSColor.windowBackgroundColor))

            Divider()

            // ── Sections ──────────────────────────────────────────────
            ScrollView {
                VStack(spacing: 0) {
                    // GENERAL
                    sectionHeader("General")
                    settingsRow {
                        Toggle("Launch at Login", isOn: $isLaunchAtLoginEnabled)
                            .toggleStyle(.switch)
                            .onChange(of: isLaunchAtLoginEnabled) { _, newValue in
                                toggleLaunchAtLogin(newValue)
                            }
                    }
                    sectionDivider()

                    // TRACKING
                    sectionHeader("Tracking")
                    settingsRow {
                        HStack {
                            Text("Idle Timeout")
                                .foregroundColor(.primary)
                            Spacer()
                            Picker("", selection: $idleThresholdMinutes) {
                                ForEach(idleOptions, id: \.self) { mins in
                                    Text("\(mins) min").tag(mins)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 90)
                            .onChange(of: idleThresholdMinutes) { _, newValue in
                                UserDefaults.standard.set(newValue * 60, forKey: IdleDetector.thresholdKey)
                            }
                        }
                    }
                    rowCaption("Tracking pauses after this many minutes of inactivity.")
                    sectionDivider()

                    // MENU BAR
                    sectionHeader("Menu Bar")
                    settingsRow {
                        Toggle("Live Timer", isOn: $isMenuBarTimerEnabled)
                            .toggleStyle(.switch)
                            .onChange(of: isMenuBarTimerEnabled) { _, newValue in
                                MenuBarTimerManager.shared.setEnabled(newValue)
                            }
                    }
                    rowCaption("Shows the active app and its tracked time in the menu bar.")
                    sectionDivider()

                    // DATA
                    sectionHeader("Data")
                    settingsRow {
                        Button(role: .destructive) {
                            showClearTodayAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Clear Today's Data")
                            }
                            .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    Divider().padding(.leading, 16)
                    settingsRow {
                        Button(role: .destructive) {
                            showClearAllAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Clear All History")
                            }
                            .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    sectionDivider()

                    // ABOUT
                    sectionHeader("About")
                    settingsRow {
                        HStack {
                            Text("Version")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(appVersion)
                                .foregroundColor(.secondary)
                        }
                    }
                    Divider().padding(.leading, 16)
                    settingsRow {
                        HStack {
                            Text("Developer")
                                .foregroundColor(.primary)
                            Spacer()
                            Text("Nalina Kariyawasam")
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer(minLength: 24)
                }
            }
        }
        .frame(width: 320, height: 420)
        .background(Color(NSColor.controlBackgroundColor))
        .onAppear {
            isLaunchAtLoginEnabled = SMAppService.mainApp.status == .enabled
            isMenuBarTimerEnabled  = MenuBarTimerManager.shared.isEnabled
            let stored = UserDefaults.standard.integer(forKey: IdleDetector.thresholdKey)
            idleThresholdMinutes = stored > 0 ? stored / 60 : 3
        }
        // ── Alerts ──────────────────────────────────────────────────
        .alert("Clear Today's Data?", isPresented: $showClearTodayAlert) {
            Button("Clear", role: .destructive) { usageManager.clearToday() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove all tracked data for today.")
        }
        .alert("Clear All History?", isPresented: $showClearAllAlert) {
            Button("Clear All", role: .destructive) { usageManager.clearAllHistory() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove all tracked usage data across all days.")
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary)
                .kerning(0.5)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 4)
    }

    @ViewBuilder
    private func settingsRow<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        HStack {
            content()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(NSColor.windowBackgroundColor))
        .font(.system(size: 13))
    }

    @ViewBuilder
    private func rowCaption(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .background(Color(NSColor.windowBackgroundColor))
    }

    private func sectionDivider() -> some View {
        Color(NSColor.separatorColor).frame(height: 1)
    }

    // MARK: - Launch at Login

    private func toggleLaunchAtLogin(_ enable: Bool) {
        do {
            if enable {
                if SMAppService.mainApp.status != .enabled {
                    try SMAppService.mainApp.register()
                }
            } else {
                if SMAppService.mainApp.status == .enabled {
                    try SMAppService.mainApp.unregister()
                }
            }
        } catch {
            print("Failed to update Launch at Login: \(error)")
            isLaunchAtLoginEnabled = SMAppService.mainApp.status == .enabled
        }
    }
}
