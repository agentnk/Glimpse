import SwiftUI
import Cocoa

struct AppRowView: View {
    let appInfo: AppUsageInfo
    
    var body: some View {
        HStack {
            Image(nsImage: getAppIcon(bundleID: appInfo.id))
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(appInfo.name)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(formatTime(appInfo.time))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .monospacedDigit()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
    }
    
    private func getAppIcon(bundleID: String) -> NSImage {
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) {
            return NSWorkspace.shared.icon(forFile: url.path)
        }
        // Fallback generic application icon
        let genericAppIcon = NSWorkspace.shared.icon(forFileType: "'APPL'")
        return genericAppIcon
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let IntInterval = Int(interval)
        let hours = IntInterval / 3600
        let minutes = (IntInterval % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "< 1m"
        }
    }
}
