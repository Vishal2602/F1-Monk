import Foundation

struct Notification: Identifiable, Codable {
    let id: Int
    let title: String
    let content: String
    let priority: NotificationPriority
    let date: Date
    var isRead: Bool = false
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    enum NotificationPriority: String, Codable {
        case low
        case normal
        case high
        
        var color: String {
            switch self {
            case .low:
                return "blue"
            case .normal:
                return "orange"
            case .high:
                return "red"
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, priority, date, isRead
    }
    
    init(id: Int, title: String, content: String, priority: NotificationPriority, date: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.priority = priority
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        
        // Handle priority as a string
        let priorityString = try container.decode(String.self, forKey: .priority)
        priority = NotificationPriority(rawValue: priorityString) ?? .normal
        
        // Handle date as a string
        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = ISO8601DateFormatter()
        if let parsedDate = dateFormatter.date(from: dateString) {
            date = parsedDate
        } else {
            date = Date()
        }
        
        isRead = try container.decode(Bool.self, forKey: .isRead)
    }
} 