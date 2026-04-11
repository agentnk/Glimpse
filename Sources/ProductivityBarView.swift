import SwiftUI

struct ProductivityBarView: View {
    let productiveTime: TimeInterval
    let neutralTime: TimeInterval
    let distractingTime: TimeInterval
    
    var total: TimeInterval {
        let sum = productiveTime + neutralTime + distractingTime
        return sum == 0 ? 1 : sum // Avoid division by zero
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Productive
                if productiveTime > 0 {
                    Rectangle()
                        .fill(AppCategory.productive.color)
                        .frame(width: geometry.size.width * CGFloat(productiveTime / total))
                }
                
                // Neutral
                if neutralTime > 0 {
                    Rectangle()
                        .fill(AppCategory.neutral.color)
                        .frame(width: geometry.size.width * CGFloat(neutralTime / total))
                }
                
                // Distracting
                if distractingTime > 0 {
                    Rectangle()
                        .fill(AppCategory.distracting.color)
                        .frame(width: geometry.size.width * CGFloat(distractingTime / total))
                }
            }
        }
        .frame(height: 6)
        .cornerRadius(3)
        .padding(.horizontal)
    }
}
