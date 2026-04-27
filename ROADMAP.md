# Roadmap 🗺️

This document outlines the planned future features and improvements for **Glimpse**. Items are roughly ordered by priority and complexity.

---

## 🔜 Up Next

### 📊 Weekly Views & Trends
> See how your time trends evolve across weeks.

- [ ] Weekly aggregate bar chart using Swift Charts
- [ ] Productivity trends (Week over Week)

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
| `v1.6.0` | **App Settings Page** — dedicated settings panel with customizable idle timeout and data management |
| `v1.5.0` | **Daily Recap & Historical Data** — visual end-of-day summary with historical browsing |
| `v1.4.0` | **Live Menu Bar Timer** — real-time app name & session time in the menu bar, idle-aware, togglable |
| `v1.3.0` | **Productivity Categorization & App Ignoring** via context menu |
| `v1.2.0` | Idle & inactivity detection via `CGEventSource` with live status badge |
| `v1.1.0` | Launch at login via `SMAppService` |
| `v1.0.0` | Menu bar integration with `LSUIElement`, tracking, and basic JSON persistence |

---

> Have a feature idea? Open an issue or submit a pull request!
