import SwiftUI

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
    
    var sortedApps: [AppUsageInfo] {
        usageManager.currentUsage.appUsage.map { (bundleID, time) in
            let name = usageManager.currentUsage.appNames[bundleID] ?? "Unknown"
            return AppUsageInfo(id: bundleID, name: name, time: time)
        }.sorted()
    }
    
    var totalTime: TimeInterval {
        usageManager.currentUsage.appUsage.values.reduce(0, +)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Glimpse")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("Today")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Total Time summary
            VStack {
                Text(formatTime(totalTime))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("Total Active Time")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // App List
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
            
            Divider()
            
            // Footer
            HStack {
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Text("Quit Glimpse")
                        .font(.caption)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.secondary)
                Spacer()
            }
            .padding(10)
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(width: 320, height: 460)
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
