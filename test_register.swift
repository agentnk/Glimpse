import Foundation
import ServiceManagement

let bundleURL = URL(fileURLWithPath: "Glimpse.app")
guard let bundle = Bundle(url: bundleURL) else {
    print("Invalid bundle")
    exit(1)
}

if #available(macOS 13.0, *) {
    do {
        // SMAppService doesn't let you pass a bundle url for the main app. It registers the CURRENT process.
        // We can't really test it from a separate script this way.
        print("Need to run inside the app")
    } catch {
        print("Error: \(error)")
    }
}
