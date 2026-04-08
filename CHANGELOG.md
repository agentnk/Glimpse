# Changelog

All notable changes to the **Glimpse** project will be documented in this file.

## [1.0.0] - Initial Release

### Added
- **Menu Bar Integration**: A distraction-free status item that lives neatly in the macOS menu bar and avoids dock clutter (`LSUIElement`).
- **Active App Tracking**: Implemented a background tracking engine using `NSWorkspace` to record the frontmost application usage efficiently in the background.
- **Launch at Login**: Implemented a toggle using `SMAppService` to allow the app to automatically launch on startup.
- **Daily Summary UI**: Created a clean and interactive SwiftUI popover to view categorized, sorted app usage per day.
- **Data Persistence**: Added automatic daily usage serialization saving to standard `Application Support`, with built-in logic handling automated resets at midnight.
- **Custom Build System**: Introduced a blazing fast custom build script (`build.sh`) leveraging `swiftc` for zero-configuration native app packaging, complete with ad-hoc code signing required for `SMAppService` to function properly.
