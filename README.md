# Glimpse 👁️

**A minimal macOS menu bar app that helps you understand how you spend your time—without distractions or complexity.**

Glimpse quietly runs in your menu bar and tracks the time you spend on each active application throughout the day. With a single click, you get a clear, real-time breakdown of your usage—helping you stay aware of your habits and make better decisions about your time.

## Features ✨
- **Zero Distraction:** Lives entirely in your menu bar. No dock icon, no intrusive notifications.
- **Automatic Tracking:** Automatically detects the frontmost active app and records usage in the background.
- **Launch at Login:** Configure Glimpse to automatically start when you boot your Mac so you never forget to launch it.
- **Daily Summary:** Presents a simple daily summary in a clean, elegant popover interface. Data automatically resets at midnight.
- **Native & Lightweight:** Built entirely with Swift, SwiftUI, and AppKit for lightning-fast performance, low data storage overhead, and minimal battery footprint.

## Installation & Build 🛠️

Glimpse is built using a custom lightweight build script so you don't have to deal with heavy or complex Xcode workspaces!

To compile and launch Glimpse from source:
1. Open your terminal in the project root directory.
2. Make the build script executable (if it isn't already):
   ```bash
   chmod +x build.sh
   ```
3. Run the script:
   ```bash
   ./build.sh
   ```
4. Glimpse will compile instantly into `Glimpse.app`. You can launch it by running `open Glimpse.app` in your terminal or simply double-clicking the application bundle in Finder.

## Tech Stack 💻
* **Language:** Swift 5
* **UI:** SwiftUI
* **System Integration:** AppKit, Foundation, NSWorkspace

## Roadmap 🗺️

See [ROADMAP.md](ROADMAP.md) for planned features and future direction.
