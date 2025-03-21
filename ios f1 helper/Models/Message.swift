import Foundation

struct Message: Identifiable {
    let id: String
    let content: String
    let isFromUser: Bool
    let timestamp: Date
    
    // Format time as just the hour and minute
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: timestamp)
    }
    
    init(id: String = UUID().uuidString, content: String, isFromUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = timestamp
    }
} 