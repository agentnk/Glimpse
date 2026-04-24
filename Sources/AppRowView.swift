import SwiftUI
import Cocoa
import UniformTypeIdentifiers

struct AppRowView: View {
    let appInfo: AppUsageInfo
    
    var body: some View {
        let category = UsageManager.shared.appCategories[appInfo.id] ?? .neutral
        
        HStack {
            // Category Indicator
            Circle()
                .fill(category.color)
                .frame(width: 8, height: 8)
                .padding(.trailing, 4)
            
            Image(nsImage: getAppIcon(bundleID: appInfo.id))
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(appInfo.name)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(TimeFormatterUtil.formatTime(appInfo.time, style: .row))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .monospacedDigit()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
        .contextMenu {
            ForEach(AppCategory.allCases, id: \.self) { cat in
                Button(action: {
                    UsageManager.shared.setCategory(for: appInfo.id, category: cat)
                }) {
                    Label(cat.label, systemImage: cat.iconName)
                }
            }
        }
    }
    
    private func getAppIcon(bundleID: String) -> NSImage {
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) {
            return NSWorkspace.shared.icon(forFile: url.path)
        }
        // Fallback generic application icon using modern API if available
        if #available(macOS 12.0, *) {
            return NSWorkspace.shared.icon(for: .application)
        } else {
            return NSImage(named: NSImage.applicationIconName) ?? NSImage()
        }
    }
}
