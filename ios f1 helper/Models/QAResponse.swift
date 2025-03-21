import Foundation

struct QAResponse: Identifiable, Codable {
    let id: Int
    let question: String
    let answer: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id, question, answer, category
    }
} 