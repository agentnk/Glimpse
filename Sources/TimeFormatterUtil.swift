import Foundation

struct TimeFormatterUtil {
    enum FormatStyle {
        case summary // E.g., "1h 30m" or "0m"
        case row     // E.g., "1h 30m" or "30m" or "< 1m"
        case exact   // E.g., "1h 30m" or "30m" or "45s"
    }
    
    static func formatTime(_ interval: TimeInterval, style: FormatStyle) -> String {
        return formatTime(Int(interval), style: style)
    }
    
    static func formatTime(_ totalSeconds: Int, style: FormatStyle) -> String {
        let h = totalSeconds / 3600
        let m = (totalSeconds % 3600) / 60
        let s = totalSeconds % 60
        
        switch style {
        case .summary:
            if h > 0 {
                return "\(h)h \(m)m"
            }
            return "\(m)m"
            
        case .row:
            if h > 0 {
                return "\(h)h \(m)m"
            } else if m > 0 {
                return "\(m)m"
            } else {
                return "< 1m"
            }
            
        case .exact:
            if h > 0 {
                return "\(h)h \(m)m"
            } else if m > 0 {
                return "\(m)m"
            } else {
                return "\(s)s"
            }
        }
    }

    static func formatDuration(_ interval: TimeInterval) -> String {
        return formatTime(interval, style: .summary)
    }
}

