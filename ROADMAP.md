# Roadmap 🗺️

This document outlines the planned future features and improvements for **Glimpse**. Items are roughly ordered by priority and complexity.

---

## 🔜 Up Next

### 📅 Historical Data & Weekly Views
> See how your time trends evolve across days.

Currently, usage data is wiped at midnight. We'll upgrade `UsageManager` to retain a rolling history so users can browse back through previous days and spot productivity trends.

- [ ] Save per-day snapshots to disk on midnight reset
- [ ] Add a date picker or segmented control (Today / Yesterday / Last 7 Days)
- [ ] Weekly aggregate bar chart using Swift Charts

---

---

## 💡 Ideas & Exploration

These are longer-term ideas that need more exploration before committing to an implementation.

| Feature | Description |
|---|---|
| **Daily Recap Notification** | Optional end-of-day notification summarising your most-used apps. |
| **Website Tracking** | Track time per website inside browsers (Safari / Chrome extension companion). |
| **Focus Goals** | Set a daily time target for a specific app (e.g., "2h of coding") and get notified when you hit it. |
| **Export / CSV** | Export all usage data as a CSV for external analysis in tools like Notion or Excel. |
| **Custom Categories** | Group apps together under user-defined categories (e.g., "Creative", "Comms", "Deep Work"). |
| **Pomodoro Integration** | Built-in Pomodoro timer that works alongside the tracker to structure deep work sessions. |

---

## ✅ Shipped

| Version | Feature |
|---|---|
| `v1.0.0` | Menu bar integration with `LSUIElement` |
| `v1.0.0` | Active app tracking via `NSWorkspace` |
| `v1.0.0` | Daily summary SwiftUI popover |
| `v1.0.0` | Midnight data auto-reset & JSON persistence |
| `v1.0.0` | Custom `build.sh` with ad-hoc code signing |
| `v1.1.0` | Launch at login via `SMAppService` |
| `v1.2.0` | Idle & inactivity detection via `CGEventSource` with live status badge |
| `v1.3.0` | **Productivity Categorization & App Ignoring** via context menu |
| `v1.4.0` | **Live Menu Bar Timer** — real-time app name & session time in the menu bar, idle-aware, togglable |

---

> Have a feature idea? Open an issue or submit a pull request!
