# Glimpse 👁️

**A minimal macOS menu bar app that helps you understand how you spend your time—without distractions or complexity.**

Glimpse quietly runs in your menu bar and tracks the time you spend on each active application throughout the day. With a single click, you get a clear, real-time breakdown of your usage—helping you stay aware of your habits and make better decisions about your time.

## Features ✨
- **Zero Distraction:** Lives entirely in your menu bar. No dock icon, no intrusive notifications.
- **Automatic Tracking:** Automatically detects the frontmost active app and records usage in the background.
- **Idle Detection:** Automatically pauses tracking after 3 minutes of inactivity. Time is never logged when you step away. A live status badge in the popover header shows whether Glimpse is actively tracking or paused.
- **Live Menu Bar Timer:** Optionally displays the current app name and today's accumulated time directly in the menu bar (e.g. `VSCode  14m`), refreshing every second. Automatically hides while idle and reverts to the Glimpse eye icon when disabled.
- **Launch at Login:** Configure Glimpse to automatically start when you boot your Mac so you never forget to launch it.
- **Daily Recap & History:** Review your productivity with a visual "Daily Recap" summary. Browse back through previous days using the historical data engine to spot trends and review your achievements.
- **Daily Summary:** Presents a simple daily summary in a clean, elegant popover interface. Data is now archived daily instead of being wiped.
- **Productivity Categorization:** Classify apps as Productive, Distracting, or Neutral via a context menu. A persistent color-coded system helps you spot your focus areas instantly.
- **Productivity Ratio Bar:** See your day's efficiency at a glance with a horizontal bar showing the ratio of productive task time vs. distractions.
- **App Ignore List:** Exclude utility apps (Finder, System Settings, etc.) from tracking to ensure your productivity stats remain accurate.
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

## Architecture 🏗️

Glimpse is designed with a clean, modular structure to ensure easy maintainability:
- **`AppTracker`:** Monitors the active application dynamically using `NSWorkspace` notifications.
- **`IdleDetector`:** Prevents phantom tracking by checking system-wide inactivity via `CGEventSource`.
- **`UsageManager`:** Handles historical data persistence, app categorization, and seamless day-over-day archiving using JSON history files.
- **`MenuBarManager`:** Manages the system menu bar item (`LSUIElement`) lifecycle and popover state.
- **`MenuBarTimerManager`:** Drives the optional live label in the menu bar, polling `UsageManager` every second and respecting idle state. Preference is stored in `UserDefaults`.
- **Views (`DailyRecapView`, `ContentView` & Subviews):** A minimalist, component-driven SwiftUI frontend providing both a live dashboard and a detailed historical recap experience.

## Tech Stack 💻
* **Language:** Swift 5
* **UI:** SwiftUI
* **System Integration:** AppKit, Foundation, NSWorkspace, ServiceManagement

## Roadmap 🗺️

See [ROADMAP.md](ROADMAP.md) for planned features and future direction.
