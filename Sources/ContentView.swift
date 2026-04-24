import SwiftUI
import ServiceManagement

struct ContentView: View {
    @ObservedObject var usageManager = UsageManager.shared
    @ObservedObject var idleDetector = IdleDetector.shared
    @State private var isLaunchAtLoginEnabled: Bool = SMAppService.mainApp.status == .enabled
    @State private var showingRecap: Bool = false
    @State private var selectedRecapDate: String = UsageManager.todayString()
    
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
            HeaderView(isIdle: idleDetector.isIdle, onRecapTapped: {
                selectedRecapDate = usageManager.currentUsage.dateString
                showingRecap = true
            })
            Divider()
            
            TotalTimeSummaryView(totalTime: totalTime, breakdown: productivityBreakdown)
            Divider()
            
            AppListView(sortedApps: sortedApps)
            Divider()
            
            FooterView(isLaunchAtLoginEnabled: $isLaunchAtLoginEnabled)
        }
        .frame(width: 320, height: 490)
        .onAppear {
            isLaunchAtLoginEnabled = SMAppService.mainApp.status == .enabled
        }
        .sheet(isPresented: $showingRecap) {
            DailyRecapView(dateString: selectedRecapDate)
        }
    }
}
