import SwiftUI

struct DailyRecapView: View {
    @State var dateString: String
    @ObservedObject var usageManager = UsageManager.shared
    @Environment(\.dismiss) var dismiss
    
    // Available dates in history (sorted)
    var availableDates: [String] {
        usageManager.history.keys.sorted()
    }
    
    var currentIndex: Int? {
        availableDates.firstIndex(of: dateString)
    }
    
    // Get usage data for this date
    var usage: UsageData? {
        usageManager.history[dateString]
    }
    
    var sortedApps: [AppUsageInfo] {
        usage?.sortedApps(categories: usageManager.appCategories) ?? []
    }
    
    var breakdown: (productive: TimeInterval, neutral: TimeInterval, distracting: TimeInterval) {
        usage?.breakdown(categories: usageManager.appCategories) ?? (0, 0, 0)
    }
    
    var totalTime: TimeInterval {
        usage?.totalTime(categories: usageManager.appCategories) ?? 0
    }
    
    var productivityScore: Int {
        guard totalTime > 0 else { return 0 }
        return Int((breakdown.productive / totalTime) * 100)
    }

    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        if let index = currentIndex, index > 0 {
                            dateString = availableDates[index - 1]
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .opacity((currentIndex ?? 0) > 0 ? 1 : 0.3)
                    }
                    .disabled((currentIndex ?? 0) == 0)
                    .buttonStyle(.plain)

                    Text(formatDate(dateString))
                        .font(.headline)
                        .frame(width: 120)
                    
                    Button(action: {
                        if let index = currentIndex, index < availableDates.count - 1 {
                            dateString = availableDates[index + 1]
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .opacity((currentIndex ?? 0) < availableDates.count - 1 ? 1 : 0.3)
                    }
                    .disabled((currentIndex ?? 0) == availableDates.count - 1)
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                // Placeholder for symmetry
                Color.clear.frame(width: 20)
            }

            .padding(.top)
            .padding(.horizontal)
            
            if let _ = usage {
                ScrollView {
                    VStack(spacing: 25) {
                        // Productivity Gauge
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 12)
                                    .frame(width: 120, height: 120)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(productivityScore) / 100.0)
                                    .stroke(
                                        LinearGradient(colors: [.green, .emerald], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                    )
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeOut(duration: 1.0), value: productivityScore)
                                
                                VStack(spacing: 0) {
                                    Text("\(productivityScore)%")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                    Text("Productive")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Text(TimeFormatterUtil.formatDuration(totalTime))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Text("Total Tracked Time")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 10)
                        
                        // Productivity Bar
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Efficiency Breakdown")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            
                            ProductivityBarView(
                                productiveTime: breakdown.productive,
                                neutralTime: breakdown.neutral,
                                distractingTime: breakdown.distracting
                            )
                        }
                        
                        // Top Apps
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Top Apps")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            
                            VStack(spacing: 1) {
                                ForEach(sortedApps.prefix(3)) { app in
                                    AppRowView(appInfo: app)
                                        .padding(.vertical, 4)
                                    if app.id != sortedApps.prefix(3).last?.id {
                                        Divider().padding(.leading, 45)
                                    }
                                }
                            }
                            .background(Color(NSColor.alternatingContentBackgroundColors[0]))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 20)
                    }
                }
            } else {
                Spacer()
                Text("No data for this day")
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private func formatDate(_ dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateStr) else { return dateStr }
        
        if Calendar.current.isDateInToday(date) { return "Today" }
        if Calendar.current.isDateInYesterday(date) { return "Yesterday" }
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

extension Color {
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
}
