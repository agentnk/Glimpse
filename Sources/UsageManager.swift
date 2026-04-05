import Foundation

struct UsageData: Codable {
    var dateString: String
    var appUsage: [String: TimeInterval] // BundleID -> Time
    var appNames: [String: String] // BundleID -> App Name
}

class UsageManager: ObservableObject {
    static let shared = UsageManager()
    
    @Published var currentUsage: UsageData = UsageData(dateString: UsageManager.todayString(), appUsage: [:], appNames: [:])
    
    private let fileURL: URL
    
    private init() {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportDir = paths[0].appendingPathComponent("com.nk.Glimpse")
        
        if !FileManager.default.fileExists(atPath: appSupportDir.path) {
            try? FileManager.default.createDirectory(at: appSupportDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        fileURL = appSupportDir.appendingPathComponent("usage.json")
        loadData()
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
            self.currentUsage.appNames[bundleID] = appName
            let current = self.currentUsage.appUsage[bundleID] ?? 0
            self.currentUsage.appUsage[bundleID] = current + time
            self.saveData()
        }
    }
    
    private func loadData() {
        guard let data = try? Data(contentsOf: fileURL),
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
    
    private func saveData() {
        guard let data = try? JSONEncoder().encode(currentUsage) else { return }
        try? data.write(to: fileURL)
    }
}
