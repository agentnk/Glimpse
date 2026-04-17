# Changelog

All notable changes to the **Glimpse** project will be documented in this file.

## [1.4.0] - Live Menu Bar Timer

### Added
- **`MenuBarTimerManager`**: New singleton that drives a live label in the macOS menu bar, refreshing every second with the current app name and accumulated time today (e.g. `VSCode  14m`).
- **Idle-awareness**: The timer automatically reverts to the static eye icon while the system is idle, keeping the bar clean when you step away.
- **Footer Toggle**: A new "Live menu bar timer" checkbox in the popover footer lets users enable or disable the feature at any time. The preference is persisted in `UserDefaults` and respected on the next app launch.
- **Smart truncation**: App names longer than 12 characters are gracefully truncated with an ellipsis so the menu bar label stays tidy on any screen.

---

## [1.3.0] - Productivity Categorization & App Ignoring
 
### Added
- **Productivity Categorization**: Users can now right-click any app in the summary list to tag it as **Productive**, **Neutral**, or **Distracting**.
- **Visual Indicators**: App rows now feature color-coded indicators (Green, Gray, Red) reflecting their assigned category.
- **Productivity Ratio Bar**: A new horizontal segmented bar in the daily summary header visualizes the proportion of time spent on productive vs. distracting tasks.
- **App Ignore List**: A new "Ignore App" category allows users to hide specific utility apps (like Finder or System Settings) from both the list and total time calculations.
- **Persistent Settings**: Categories are stored globally in `categories.json`, ensuring your classifications persist across daily resets.
 
---

## [1.2.0] - Idle & Inactivity Detection

### Added
- **Idle Detection Engine** (`IdleDetector.swift`): New singleton class using `CGEventSource.secondsSinceLastEventType` to poll for system-wide inactivity every 5 seconds.
- **Tracking Pause Logic**: `AppTracker` now skips logging usage when the system is idle. The elapsed clock is reset at the moment idle is detected so the gap is never back-filled when the user returns.
- **Live Status Badge**: The popover header now shows an animated `● Tracking` (green) / `● Paused · idle` (orange) badge that reflects the current idle state in real time.

---

## [1.0.0] - Initial Release


### Added
- **Menu Bar Integration**: A distraction-free status item that lives neatly in the macOS menu bar and avoids dock clutter (`LSUIElement`).
- **Active App Tracking**: Implemented a background tracking engine using `NSWorkspace` to record the frontmost application usage efficiently in the background.
- **Launch at Login**: Implemented a toggle using `SMAppService` to allow the app to automatically launch on startup.
- **Daily Summary UI**: Created a clean and interactive SwiftUI popover to view categorized, sorted app usage per day.
- **Data Persistence**: Added automatic daily usage serialization saving to standard `Application Support`, with built-in logic handling automated resets at midnight.
- **Custom Build System**: Introduced a blazing fast custom build script (`build.sh`) leveraging `swiftc` for zero-configuration native app packaging, complete with ad-hoc code signing required for `SMAppService` to function properly.
