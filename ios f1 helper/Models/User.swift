import Foundation

struct User: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    var university: String
    var major: String
    var programLevel: String
    var programStartDate: Date
    var programEndDate: Date
    var i20ExpiryDate: Date
    var hasOptApplied: Bool
    var isSevisActive: Bool
    var visaExpiryDate: Date?
    var photoURL: String?
    
    // Additional fields for user preferences
    var notificationsEnabled: Bool = true
    var reminderDays: Int = 30 // Days before deadline to send reminders
}

enum ProgramLevel: String, Codable, CaseIterable {
    case bachelors = "Bachelor's"
    case masters = "Master's"
    case phd = "PhD"
    case other = "Other"
} 