# Roadmap 🗺️

This document outlines the planned future features and improvements for **Glimpse**. Items are roughly ordered by priority and complexity.

---

## 🔜 Up Next

### 🚫 App Ignore List
> Stop tracking apps that aren't relevant to your productivity.

Some utility apps (Finder, System Preferences, 1Password, etc.) tend to inflate your usage stats. We'll allow users to right-click any entry in the list and mark it as "ignored" so it's excluded from all tracking and summaries.

- [ ] Right-click context menu on app rows
- [ ] Persist ignored list to disk
- [ ] Filter ignored apps from the daily summary and total time counter

---

## 📅 Planned

### 📅 Historical Data & Weekly Views
> See how your time trends evolve across days.

Currently, usage data is wiped at midnight. We'll upgrade `UsageManager` to retain a rolling history so users can browse back through previous days and spot productivity trends.

- [ ] Save per-day snapshots to disk on midnight reset
- [ ] Add a date picker or segmented control (Today / Yesterday / Last 7 Days)
- [ ] Weekly aggregate bar chart using Swift Charts

---

### 🏷️ Productivity Categorization
> Tag apps as Productive, Distracting, or Neutral.

Allow users to categorize each tracked application. The daily summary view will then display a clear colour-coded breakdown and a ratio bar—giving instant visual feedback on how the day went.

- [ ] Tag state persisted per bundle ID
- [ ] Color-coded rows in the app list
- [ ] Summary header shows today's productive vs. distracting ratio

---

### ⏱️ Live Menu Bar Timer
> See at a glance how long you've been in the current app.

Replace (or supplement) the static eye icon with a live timer showing time spent in the currently active application directly in the menu bar — e.g. `VSCode  42m`.

- [ ] Optional toggle in the popover footer
- [ ] Efficient 1-second refresh without noticeable CPU overhead
- [ ] Respect idle detection so the timer pauses when you're away

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

---

> Have a feature idea? Open an issue or submit a pull request!
