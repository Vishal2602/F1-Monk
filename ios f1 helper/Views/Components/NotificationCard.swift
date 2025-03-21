import SwiftUI

struct NotificationCard: View {
    let notification: Notification
    @StateObject private var viewModel = NotificationViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                priorityIndicator
                
                Text(notification.title)
                    .font(.headline)
                
                Spacer()
                
                if !notification.isRead {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
                
                Text(timeAgo(notification.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(notification.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Spacer()
                
                Button(action: {
                    viewModel.markAsRead(notification)
                }) {
                    Text(notification.isRead ? "Marked as Read" : "Mark as Read")
                        .font(.caption)
                        .foregroundColor(notification.isRead ? .secondary : .blue)
                }
                .opacity(notification.isRead ? 0.6 : 1)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(notification.isRead ? Color.clear : Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(12)
    }
    
    private var priorityIndicator: some View {
        let color: Color
        switch notification.priority {
        case .high:
            color = .red
        case .normal:
            color = .orange
        case .low:
            color = .blue
        }
        
        return Circle()
            .fill(color)
            .frame(width: 12, height: 12)
    }
    
    private func timeAgo(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 ? "Yesterday" : "\(day) days ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) \(hour == 1 ? "hour" : "hours") ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) \(minute == 1 ? "min" : "mins") ago"
        } else {
            return "Just now"
        }
    }
}

struct PriorityBadge: View {
    let priority: Notification.NotificationPriority
    
    var body: some View {
        Text(priority.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(8)
    }
    
    private var backgroundColor: Color {
        switch priority {
        case .high:
            return Color.red.opacity(0.2)
        case .normal:
            return Color.blue.opacity(0.2)
        case .low:
            return Color.gray.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        switch priority {
        case .high:
            return Color.red
        case .normal:
            return Color.blue
        case .low:
            return Color.gray
        }
    }
}

struct NotificationCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            NotificationCard(
                notification: Notification(
                    id: 1,
                    title: "OPT Application Deadline",
                    content: "The deadline for OPT applications for May graduates is approaching. Submit your application at least 90 days before your program end date.",
                    priority: .high,
                    date: Date()
                )
            )
            
            NotificationCard(
                notification: Notification(
                    id: 2,
                    title: "I-20 Extension Reminder",
                    content: "If your I-20 is expiring within the next 60 days, please contact your DSO to discuss extension options.",
                    priority: .normal,
                    date: Date().addingTimeInterval(-86400 * 2)
                )
            )
        }
        .padding()
        .background(.gray.opacity(0.2))
        .previewLayout(.sizeThatFits)
    }
} 
