import Cocoa

class AppTracker {
    static let shared = AppTracker()
    
    private var timer: Timer?
    private var lastCheckTime: Date?
    
    func start() {
        lastCheckTime = Date()
        // Start idle detection alongside the main tracking timer
        IdleDetector.shared.start()
        // Track every 5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.trackCurrentApp()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func trackCurrentApp() {
        let now = Date()
        guard let lastTime = lastCheckTime else {
            lastCheckTime = now
            return
        }

        // When the user is idle, reset the clock so the idle gap is never
        // counted as usage time when they come back.
        guard !IdleDetector.shared.isIdle else {
            lastCheckTime = now
            return
        }
        
        let elapsed = now.timeIntervalSince(lastTime)
        lastCheckTime = now
        
        guard let activeApp = NSWorkspace.shared.frontmostApplication,
              let bundleID = activeApp.bundleIdentifier,
              let appName = activeApp.localizedName else {
            return
        }
        
        UsageManager.shared.addUsage(bundleID: bundleID, appName: appName, time: elapsed)
    }
}
