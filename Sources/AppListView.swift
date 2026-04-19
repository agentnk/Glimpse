import SwiftUI

struct AppListView: View {
    let sortedApps: [AppUsageInfo]
    
    var body: some View {
        Group {
            if sortedApps.isEmpty {
                VStack {
                    Spacer()
                    Text("No activity recorded yet.")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            } else {
                List(sortedApps) { appInfo in
                    AppRowView(appInfo: appInfo)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}
