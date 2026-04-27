import SwiftUI

struct ContentView: View {
    @ObservedObject var usageManager = UsageManager.shared
    @ObservedObject var idleDetector = IdleDetector.shared
    @State private var showingRecap: Bool = false
    @State private var showingSettings: Bool = false
    @State private var selectedRecapDate: String = UsageManager.todayString()

    var sortedApps: [AppUsageInfo] {
        usageManager.currentUsage.sortedApps(categories: usageManager.appCategories)
    }

    var totalTime: TimeInterval {
        usageManager.currentUsage.totalTime(categories: usageManager.appCategories)
    }

    var productivityBreakdown: (productive: TimeInterval, neutral: TimeInterval, distracting: TimeInterval) {
        usageManager.currentUsage.breakdown(categories: usageManager.appCategories)
    }

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                isIdle: idleDetector.isIdle,
                onRecapTapped: {
                    selectedRecapDate = usageManager.currentUsage.dateString
                    showingRecap = true
                },
                onSettingsTapped: {
                    showingSettings = true
                }
            )
            Divider()

            TotalTimeSummaryView(totalTime: totalTime, breakdown: productivityBreakdown)
            Divider()

            AppListView(sortedApps: sortedApps)
            Divider()

            FooterView()
        }
        .frame(width: 320, height: 490)
        .sheet(isPresented: $showingRecap) {
            DailyRecapView(dateString: selectedRecapDate)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

