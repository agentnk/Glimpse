import Foundation

struct UsageData: Codable {
    var dateString: String
    var appUsage: [String: TimeInterval] // BundleID -> Time
    var appNames: [String: String] // BundleID -> App Name
}

class UsageManager: ObservableObject {
    static let shared = UsageManager()
    
    @Published var currentUsage: UsageData = UsageData(dateString: UsageManager.todayString(), appUsage: [:], appNames: [:])
    @Published var appCategories: [String: AppCategory] = [:]
    
    private let usageFileURL: URL
    private let categoriesFileURL: URL
    
    private init() {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportDir = paths[0].appendingPathComponent("com.nk.Glimpse")
        
        if !FileManager.default.fileExists(atPath: appSupportDir.path) {
            try? FileManager.default.createDirectory(at: appSupportDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        usageFileURL = appSupportDir.appendingPathComponent("usage.json")
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
            self.saveData()
        }
    }
    
    func setCategory(for bundleID: String, category: AppCategory) {
        DispatchQueue.main.async {
            self.appCategories[bundleID] = category
            self.saveCategories()
            
            // If switched TO ignored, we might want to clean up current usage, 
            // but for simplicity we'll just let it stay in history and filter it on UI.
            // Actually, let's keep it consistent: ignore means "don't show or count".
            self.objectWillChange.send()
        }
    }
    
    private func loadData() {
        guard let data = try? Data(contentsOf: usageFileURL),
              let usage = try? JSONDecoder().decode(UsageData.self, from: data) else {
            return
        }
        
        if usage.dateString == UsageManager.todayString() {
            self.currentUsage = usage
        } else {
            // New day, reset
            self.currentUsage = UsageData(dateString: UsageManager.todayString(), appUsage: [:], appNames: [:])
            saveData()
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
        guard let data = try? JSONEncoder().encode(currentUsage) else { return }
        try? data.write(to: usageFileURL)
    }
    
    private func saveCategories() {
        guard let data = try? JSONEncoder().encode(appCategories) else { return }
        try? data.write(to: categoriesFileURL)
    }
}
