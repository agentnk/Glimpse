import Cocoa

/// Drives the live "App  Xm Ys" label in the macOS menu bar.
///
/// - Reads the frontmost application and its recorded usage from `UsageManager` once per second.
/// - Respects idle state: the timer text is hidden (reverting to the eye icon) while the user is idle.
/// - Controlled by the `showMenuBarTimer` `UserDefaults` key; the toggle in `FooterView` writes to that key.
class MenuBarTimerManager {

    // MARK: - Singleton

    static let shared = MenuBarTimerManager()

    // MARK: - Public interface

    /// Weak reference set by `AppDelegate` immediately after the status item is created.
    weak var statusItem: NSStatusItem?

    // MARK: - Private state

    private var refreshTimer: Timer?

    /// `UserDefaults` key that stores the user's preference.
    static let enabledKey = "showMenuBarTimer"

    private init() {}

    // MARK: - Lifecycle

    /// Call once from `AppDelegate` after the status item is ready.
    func start(statusItem: NSStatusItem) {
        self.statusItem = statusItem
        guard isEnabled else { return }
        startTimer()
    }

    /// Called by the UI toggle when the user changes the preference.
    func setEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Self.enabledKey)
        if enabled {
            startTimer()
        } else {
            stopTimer()
            restoreIcon()
        }
    }

    var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: Self.enabledKey)
    }

    // MARK: - Timer management

    private func startTimer() {
        stopTimer()
        let t = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.refresh()
        }
        RunLoop.main.add(t, forMode: .common)
        refreshTimer = t
        refresh() // Immediate first tick
    }

    private func stopTimer() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    // MARK: - Rendering

    private func refresh() {
        guard let item = statusItem else { return }

        // While idle: just show the eye icon so the bar stays clean.
        if IdleDetector.shared.isIdle {
            restoreIcon()
            return
        }

        guard
            let activeApp = NSWorkspace.shared.frontmostApplication,
            let bundleID  = activeApp.bundleIdentifier,
            let appName   = activeApp.localizedName
        else {
            restoreIcon()
            return
        }

        // Fetch the accumulated seconds for the front-most app today.
        let seconds = Int(UsageManager.shared.currentUsage.appUsage[bundleID] ?? 0)
        let label   = makeLabel(appName: appName, seconds: seconds)

        DispatchQueue.main.async {
            item.button?.image = nil
            item.button?.title = label
        }
    }

    private func makeLabel(appName: String, seconds: Int) -> String {
        // Truncate long app names to keep the bar tidy.
        let maxLen = 12
        let name   = appName.count > maxLen
            ? String(appName.prefix(maxLen - 1)) + "…"
            : appName

        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60

        let time: String
        if h > 0 {
            time = "\(h)h \(m)m"
        } else if m > 0 {
            time = "\(m)m"
        } else {
            time = "\(s)s"
        }

        return "\(name)  \(time)"
    }

    private func restoreIcon() {
        DispatchQueue.main.async { [weak self] in
            guard let item = self?.statusItem else { return }
            item.button?.title = ""
            item.button?.image = NSImage(
                systemSymbolName: "eye.circle.fill",
                accessibilityDescription: "Glimpse"
            )
        }
    }
}
