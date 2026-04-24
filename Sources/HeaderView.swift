import SwiftUI

struct HeaderView: View {
    let isIdle: Bool
    var onRecapTapped: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onRecapTapped) {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .help("Daily Recap")
            
            Text("Glimpse")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            // Idle status badge
            HStack(spacing: 4) {
                Circle()
                    .fill(isIdle ? Color.orange : Color.green)
                    .frame(width: 7, height: 7)
                Text(isIdle ? "Paused · idle" : "Tracking")
                    .font(.caption2)
                    .foregroundColor(isIdle ? .orange : .secondary)
            }
            .animation(.easeInOut(duration: 0.3), value: isIdle)
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }
}

