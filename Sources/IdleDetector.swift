import Cocoa
import CoreGraphics

class IdleDetector: ObservableObject {
    static let shared = IdleDetector()

    /// UserDefaults key for the idle threshold (stored in seconds).
    static let thresholdKey = "idleThresholdSeconds"

    /// Reads the current idle threshold from UserDefaults; defaults to 3 minutes.
    var idleThreshold: TimeInterval {
        let stored = UserDefaults.standard.integer(forKey: Self.thresholdKey)
        return stored > 0 ? TimeInterval(stored) : 180
    }

    /// Published so the UI can react to idle state changes.
    @Published private(set) var isIdle: Bool = false

    private var timer: Timer?

    private init() {}

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.checkIdle()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func checkIdle() {
        let secondsSinceLastEvent = CGEventSource.secondsSinceLastEventType(
            .combinedSessionState,
            eventType: CGEventType(rawValue: ~0)! // any HID event (keyboard + mouse)
        )

        let nowIdle = secondsSinceLastEvent >= idleThreshold

        // Only post changes to avoid unnecessary SwiftUI redraws
        if nowIdle != isIdle {
            DispatchQueue.main.async {
                self.isIdle = nowIdle
            }
        }
    }
}
