import SwiftUI

struct TotalTimeSummaryView: View {
    let totalTime: TimeInterval
    let breakdown: (productive: TimeInterval, neutral: TimeInterval, distracting: TimeInterval)
    
    var body: some View {
        VStack(spacing: 8) {
            Text(TimeFormatterUtil.formatTime(totalTime, style: .summary))
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Text("Total Active Time")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ProductivityBarView(
                productiveTime: breakdown.productive,
                neutralTime: breakdown.neutral,
                distractingTime: breakdown.distracting
            )
            .padding(.top, 8)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
    }
}
