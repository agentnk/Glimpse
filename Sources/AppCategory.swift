import SwiftUI

enum AppCategory: String, Codable, CaseIterable {
    case productive
    case neutral
    case distracting
    case ignored
    
    var label: String {
        switch self {
        case .productive: return "Productive"
        case .neutral: return "Neutral"
        case .distracting: return "Distracting"
        case .ignored: return "Ignore App"
        }
    }
    
    var color: Color {
        switch self {
        case .productive: return .green
        case .neutral: return .gray
        case .distracting: return .red
        case .ignored: return .secondary
        }
    }
    
    var iconName: String {
        switch self {
        case .productive: return "checkmark.circle.fill"
        case .neutral: return "circle"
        case .distracting: return "xmark.circle.fill"
        case .ignored: return "eye.slash.fill"
        }
    }
}
