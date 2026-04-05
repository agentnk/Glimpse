import Cocoa

class MenuBarManager {
    let statusItem: NSStatusItem
    let popover: NSPopover

    init(statusItem: NSStatusItem, popover: NSPopover) {
        self.statusItem = statusItem
        self.popover = popover
    }

    func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            NSApplication.shared.activate(ignoringOtherApps: true)
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }
}
