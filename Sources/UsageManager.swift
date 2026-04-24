import Foundation

struct UsageData: Codable {
    var dateString: String
    var appUsage: [String: TimeInterval] // BundleID -> Time
    var appNames: [String: String] // BundleID -> App Name
}

struct UsageHistory: Codable {
    var days: [String: UsageData]
}


class UsageManager: ObservableObject {
    static let shared = UsageManager()
    
    @Published var currentUsage: UsageData = UsageData(dateString: UsageManager.todayString(), appUsage: [:], appNames: [:])
    @Published var history: [String: UsageData] = [:]
    @Published var appCategories: [String: AppCategory] = [:]
    
    private let usageFileURL: URL
    private let categoriesFileURL: URL
    
    private init() {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportDir = paths[0].appendingPathComponent("com.nk.Glimpse")
        
        if !FileManager.default.fileExists(atPath: appSupportDir.path) {
            try? FileManager.default.createDirectory(at: appSupportDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        usageFileURL = appSupportDir.appendingPathComponent("usage_history.json")
        categoriesFileURL = appSupportDir.appendingPathComponent("categories.json")
        loadData()
        loadCategories()
    }
    
    static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    func checkAndResetDate() {
        let today = UsageManager.todayString()
        if currentUsage.dateString != today {
            // Archive current usage before reset
            history[currentUsage.dateString] = currentUsage
            currentUsage = UsageData(dateString: today, appUsage: [:], appNames: [:])
            saveData()
        }
    }
    
    func addUsage(bundleID: String, appName: String, time: TimeInterval) {
        checkAndResetDate()
        DispatchQueue.main.async {
            // Only track if not ignored
            if self.appCategories[bundleID] == .ignored { return }
            
            self.currentUsage.appNames[bundleID] = appName
            let current = self.currentUsage.appUsage[bundleID] ?? 0
            self.currentUsage.appUsage[bundleID] = current + time
            
            // Also keep history updated in memory (optional, but good for real-time history views)
            self.history[self.currentUsage.dateString] = self.currentUsage
            self.saveData()
        }
    }
    
    func setCategory(for bundleID: String, category: AppCategory) {
        DispatchQueue.main.async {
            self.appCategories[bundleID] = category
            self.saveCategories()
            self.objectWillChange.send()
        }
    }
    
    private func loadData() {
        // Try loading history first
        if let data = try? Data(contentsOf: usageFileURL),
           let loadedHistory = try? JSONDecoder().decode(UsageHistory.self, from: data) {
            self.history = loadedHistory.days
            let today = UsageManager.todayString()
            if let todayUsage = self.history[today] {
                self.currentUsage = todayUsage
            } else {
                // Check if old format exists for migration or just start fresh
                self.currentUsage = UsageData(dateString: today, appUsage: [:], appNames: [:])
            }
        } else {
            // Migration check: if usage.json exists (old format)
            let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            let oldURL = paths[0].appendingPathComponent("com.nk.Glimpse").appendingPathComponent("usage.json")
            if let oldData = try? Data(contentsOf: oldURL),
               let oldUsage = try? JSONDecoder().decode(UsageData.self, from: oldData) {
                if oldUsage.dateString == UsageManager.todayString() {
                    self.currentUsage = oldUsage
                }
                self.history[oldUsage.dateString] = oldUsage
                saveData()
                try? FileManager.default.removeItem(at: oldURL) // Clean up old file
            }
        }
    }
    
    private func loadCategories() {
        guard let data = try? Data(contentsOf: categoriesFileURL),
              let categories = try? JSONDecoder().decode([String: AppCategory].self, from: data) else {
            return
        }
        self.appCategories = categories
    }
    
    private func saveData() {
        // Always save history
        let usageHistory = UsageHistory(days: history)
        guard let data = try? JSONEncoder().encode(usageHistory) else { return }
        try? data.write(to: usageFileURL)
    }
    
    private func saveCategories() {
        guard let data = try? JSONEncoder().encode(appCategories) else { return }
        try? data.write(to: categoriesFileURL)
    }
}

