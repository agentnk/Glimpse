import SwiftUI
import ServiceManagement

struct AppUsageInfo: Identifiable, Comparable {
    let id: String // bundleID
    let name: String
    let time: TimeInterval
    
    static func < (lhs: AppUsageInfo, rhs: AppUsageInfo) -> Bool {
        return lhs.time > rhs.time // Sort descending by default
    }
}

struct ContentView: View {
    @ObservedObject var usageManager = UsageManager.shared
    @ObservedObject var idleDetector = IdleDetector.shared
    @State private var isLaunchAtLoginEnabled: Bool = SMAppService.mainApp.status == .enabled
    
    var sortedApps: [AppUsageInfo] {
        usageManager.currentUsage.appUsage.compactMap { (bundleID, time) in
            guard usageManager.appCategories[bundleID] != .ignored else { return nil }
            let name = usageManager.currentUsage.appNames[bundleID] ?? "Unknown"
            return AppUsageInfo(id: bundleID, name: name, time: time)
        }.sorted()
    }
    
    var totalTime: TimeInterval {
        usageManager.currentUsage.appUsage.reduce(0) { sum, entry in
            let bundleID = entry.key
            let time = entry.value
            return usageManager.appCategories[bundleID] == .ignored ? sum : sum + time
        }
    }
    
    var productivityBreakdown: (productive: TimeInterval, neutral: TimeInterval, distracting: TimeInterval) {
        var p: TimeInterval = 0
        var n: TimeInterval = 0
        var d: TimeInterval = 0
        
        for (bundleID, time) in usageManager.currentUsage.appUsage {
            let category = usageManager.appCategories[bundleID] ?? .neutral
            switch category {
            case .productive: p += time
            case .neutral: n += time
            case .distracting: d += time
            case .ignored: break
            }
        }
        return (p, n, d)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isIdle: idleDetector.isIdle)
            Divider()
            
            TotalTimeSummaryView(totalTime: totalTime, breakdown: productivityBreakdown)
            Divider()
            
            AppListView(sortedApps: sortedApps)
            Divider()
            
            FooterView(isLaunchAtLoginEnabled: $isLaunchAtLoginEnabled)
        }
        .frame(width: 320, height: 460)
        .onAppear {
            isLaunchAtLoginEnabled = SMAppService.mainApp.status == .enabled
        }
    }
}

// MARK: - Subviews

struct HeaderView: View {
    let isIdle: Bool
    
    var body: some View {
        HStack {
            Text("Glimpse")
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            // Idle status badge
            HStack(spacing: 4) {
                Circle()
                    .fill(isIdle ? Color.orange : Color.green)
                    .frame(width: 7, height: 7)
                Text(isIdle ? "Paused · idle" : "Tracking")
                    .font(.caption2)
                    .foregroundColor(isIdle ? .orange : .secondary)
            }
            .animation(.easeInOut(duration: 0.3), value: isIdle)
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct TotalTimeSummaryView: View {
    let totalTime: TimeInterval
    let breakdown: (productive: TimeInterval, neutral: TimeInterval, distracting: TimeInterval)
    
    var body: some View {
        VStack(spacing: 8) {
            Text(formatTime(totalTime))
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Text("Total Active Time")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ProductivityBarView(
                productiveTime: breakdown.productive,
                neutralTime: breakdown.neutral,
                distractingTime: breakdown.distracting
            )
            .padding(.top, 8)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let IntInterval = Int(interval)
        let hours = IntInterval / 3600
        let minutes = (IntInterval % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
}

struct AppListView: View {
    let sortedApps: [AppUsageInfo]
    
    var body: some View {
        Group {
            if sortedApps.isEmpty {
                VStack {
                    Spacer()
                    Text("No activity recorded yet.")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            } else {
                List(sortedApps) { appInfo in
                    AppRowView(appInfo: appInfo)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct FooterView: View {
    @Binding var isLaunchAtLoginEnabled: Bool
    
    var body: some View {
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
                        // Revert on failure
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
        .padding(10)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
