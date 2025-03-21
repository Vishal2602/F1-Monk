import Foundation

struct QuestionAnalytics: Identifiable, Codable {
    let id: Int
    let question: String
    let category: String
    let count: Int
    let lastAsked: Date
    
    enum CodingKeys: String, CodingKey {
        case id, question, category, count
        case lastAsked = "last_asked"
    }
    
    init(id: Int, question: String, category: String, count: Int, lastAsked: Date) {
        self.id = id
        self.question = question
        self.category = category
        self.count = count
        self.lastAsked = lastAsked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        question = try container.decode(String.self, forKey: .question)
        category = try container.decode(String.self, forKey: .category)
        count = try container.decode(Int.self, forKey: .count)
        
        // Handle date as a string
        let dateString = try container.decode(String.self, forKey: .lastAsked)
        let dateFormatter = ISO8601DateFormatter()
        if let parsedDate = dateFormatter.date(from: dateString) {
            lastAsked = parsedDate
        } else {
            lastAsked = Date()
        }
    }
} 