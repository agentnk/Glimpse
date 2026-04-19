import Foundation

struct AppUsageInfo: Identifiable, Comparable {
    let id: String // bundleID
    let name: String
    let time: TimeInterval
    
    static func < (lhs: AppUsageInfo, rhs: AppUsageInfo) -> Bool {
        return lhs.time > rhs.time // Sort descending by default
    }
}
