import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    var menuBarManager: MenuBarManager!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 420)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView())

        // Initialize status bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem.button {
            // Using a simple SF Symbol for the eye
            button.image = NSImage(systemSymbolName: "eye.circle.fill", accessibilityDescription: "Glimpse")
            button.action = #selector(togglePopover(_:))
        }

        // Initialize MenuBarManager
        menuBarManager = MenuBarManager(statusItem: statusBarItem, popover: popover)

        // Start tracking usage
        AppTracker.shared.start()
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        menuBarManager.togglePopover(sender)
    }
}
