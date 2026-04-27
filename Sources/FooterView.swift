import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Text("Quit Glimpse")
                    .font(.caption)
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
