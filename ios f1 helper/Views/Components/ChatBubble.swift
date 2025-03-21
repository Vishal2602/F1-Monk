import SwiftUI

struct ChatBubble: View {
    let message: Message
    let isLoading: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !message.isFromUser {
                MascotAvatar(emotion: .happy, size: 32)
                    .padding(.bottom, 4)
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading) {
                if isLoading && message.content == "..." {
                    LoadingBubble()
                } else {
                    Text(message.content)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(message.isFromUser ? Color.blue : Color(.systemGray5))
                        .foregroundColor(message.isFromUser ? .white : .primary)
                        .cornerRadius(16)
                        .cornerRadius(message.isFromUser ? 16 : 16, corners: message.isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                }
            }
            
            if message.isFromUser {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct LoadingBubble: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray5))
        .cornerRadius(16)
        .onAppear {
            isAnimating = true
        }
    }
}

// Extension to apply different corner radii to different corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ChatBubble(
                message: Message(content: "Hello, how can I help you with your F1 visa questions?", isFromUser: false),
                isLoading: false
            )
            
            ChatBubble(
                message: Message(content: "Can I work off-campus with an F1 visa?", isFromUser: true),
                isLoading: false
            )
            
            ChatBubble(
                message: Message(content: "...", isFromUser: false),
                isLoading: true
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .previewLayout(.sizeThatFits)
    }
} 